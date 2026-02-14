#!/usr/bin/env python3
import hashlib
import json
import re
import time
from datetime import datetime, timedelta, timezone
from pathlib import Path
from urllib.parse import quote, urljoin, urlparse, parse_qs, unquote

import requests
from bs4 import BeautifulSoup

HEADERS = {
    "User-Agent": (
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
        "AppleWebKit/537.36 (KHTML, like Gecko) "
        "Chrome/122.0.0.0 Safari/537.36"
    )
}
TIMEOUT_SECONDS = 20

BASE_KEYWORDS = [
    "\u30dc\u30f3\u30dc\u30f3\u30c9\u30ed\u30c3\u30d7 \u5165\u8377",
    "\u30dc\u30f3\u30dc\u30f3\u30c9\u30ed\u30c3\u30d7 \u8ca9\u58f2",
    "\u30dc\u30f3\u30dc\u30f3\u30c9\u30ed\u30c3\u30d7 \u62bd\u9078",
    "\u30dc\u30f3\u30dc\u30f3\u30c9\u30ed\u30c3\u30d7 \u518d\u8ca9",
]

STORE_KEYWORDS = [
    "\u30dc\u30f3\u30dc\u30f3\u30c9\u30ed\u30c3\u30d7 \u30ad\u30c7\u30a3\u30e9\u30f3\u30c9",
    "\u30dc\u30f3\u30dc\u30f3\u30c9\u30ed\u30c3\u30d7 \u30ed\u30d5\u30c8",
    "\u30dc\u30f3\u30dc\u30f3\u30c9\u30ed\u30c3\u30d7 \u30cf\u30f3\u30ba",
    "\u30dc\u30f3\u30dc\u30f3\u30c9\u30ed\u30c3\u30d7 \u30c9\u30f3\u30ad\u30db\u30fc\u30c6",
    "\u30dc\u30f3\u30dc\u30f3\u30c9\u30ed\u30c3\u30d7 \u30f4\u30a3\u30ec\u30c3\u30b8\u30f4\u30a1\u30f3\u30ac\u30fc\u30c9",
    "\u30dc\u30f3\u30dc\u30f3\u30c9\u30ed\u30c3\u30d7 \u30a2\u30cb\u30e1\u30a4\u30c8",
]

MAJOR_CITIES = [
    "\u5927\u962a",
    "\u6885\u7530",
    "\u96e3\u6ce2",
    "\u795e\u6238",
    "\u4e09\u5bae",
    "\u897f\u5bae",
    "\u5c3c\u5d0e",
    "\u59eb\u8def",
]

CONTENT_TERMS = [
    "\u30dc\u30f3\u30dc\u30f3\u30c9\u30ed\u30c3\u30d7 \u5165\u8377",
    "\u30dc\u30f3\u30dc\u30f3\u30c9\u30ed\u30c3\u30d7 \u8ca9\u58f2",
    "\u30dc\u30f3\u30dc\u30f3\u30c9\u30ed\u30c3\u30d7 \u62bd\u9078",
    "\u30dc\u30f3\u30dc\u30f3\u30c9\u30ed\u30c3\u30d7 \u518d\u8ca9",
]

CITY_KEYWORDS = [
    f"{term} {city}" for city in MAJOR_CITIES for term in CONTENT_TERMS
]

TAMAGOTCHI_MATCH = [
    "\u30b7\u30fc\u30eb",
    "\u30b9\u30c6\u30c3\u30ab\u30fc",
    "\u30c0\u30a4\u30ab\u30c3\u30c8",
]

CITY_TO_PREF = {
    "\u5927\u962a": "\u5927\u962a\u5e9c",
    "\u6885\u7530": "\u5927\u962a\u5e9c",
    "\u96e3\u6ce2": "\u5927\u962a\u5e9c",
    "\u5929\u738b\u5bfa": "\u5927\u962a\u5e9c",
    "\u795e\u6238": "\u5175\u5eab\u770c",
    "\u4e09\u5bae": "\u5175\u5eab\u770c",
    "\u897f\u5bae": "\u5175\u5eab\u770c",
    "\u5c3c\u5d0e": "\u5175\u5eab\u770c",
    "\u59eb\u8def": "\u5175\u5eab\u770c",
}

X_REQUEST_DELAY_SECONDS = 0.6
X_MAX_URLS_PER_KEYWORD = 5

OUTPUT_DIR = Path(__file__).resolve().parents[1] / "data"

SANRIO_LIST_URL = "https://shop.sanrio.co.jp/item?category_id=130"
TAMAGOTCHI_LIST_URL = "https://tamagotchi-official.com/jp/item/"
QLIA_CATEGORY_URL = "https://qlia.shop/?mode=cate&cbid=2943125&csid=16&sort=n"

SOLD_OUT_PATTERN = re.compile(
    r"SOLD\s*OUT|SOLDOUT|売り切れ|在庫切れ",
    re.IGNORECASE,
)
DATE_WITH_YEAR = re.compile(
    r"(20\d{2})\s*[./\-年]\s*(\d{1,2})\s*[./\-月]\s*(\d{1,2})\s*(?:日)?"
)
DATE_NO_YEAR = re.compile(
    r"(\d{1,2})\s*[./\-月]\s*(\d{1,2})\s*(?:日)?"
)


class FetchError(RuntimeError):
    pass


def fetch_html(url: str) -> str:
    try:
        response = requests.get(url, headers=HEADERS, timeout=TIMEOUT_SECONDS)
        response.raise_for_status()
        return response.text
    except Exception as exc:
        raise FetchError(str(exc)) from exc


def is_sold_out(html: str) -> bool:
    return bool(SOLD_OUT_PATTERN.search(html))


def iter_jsonld_nodes(obj):
    if isinstance(obj, list):
        for item in obj:
            yield from iter_jsonld_nodes(item)
    elif isinstance(obj, dict):
        if "@graph" in obj and isinstance(obj["@graph"], list):
            for item in obj["@graph"]:
                yield from iter_jsonld_nodes(item)
        else:
            yield obj


def is_product_node(node: dict) -> bool:
    node_type = node.get("@type")
    if isinstance(node_type, list):
        return "Product" in node_type
    return node_type == "Product"


def extract_jsonld_product(soup: BeautifulSoup) -> dict | None:
    for script in soup.find_all("script", attrs={"type": "application/ld+json"}):
        raw = script.string or script.get_text(strip=True)
        if not raw:
            continue
        try:
            data = json.loads(raw)
        except Exception:
            continue
        for node in iter_jsonld_nodes(data):
            if isinstance(node, dict) and is_product_node(node):
                return node
    return None


def normalize_price(value) -> float | None:
    if value is None:
        return None
    if isinstance(value, (int, float)):
        return float(value)
    if isinstance(value, str):
        digits = re.sub(r"[^0-9.]", "", value)
        return float(digits) if digits else None
    return None


def normalize_in_stock(value) -> bool:
    if value is None:
        return True
    text = str(value)
    if "OutOfStock" in text:
        return False
    if "InStock" in text:
        return True
    return True


def clean_text(value: str | None) -> str:
    if not value:
        return ""
    return re.sub(r"\s+", " ", value).strip()


def first_image(value) -> str | None:
    if isinstance(value, list) and value:
        return value[0]
    if isinstance(value, str):
        return value
    return None


def extract_meta(soup: BeautifulSoup, key: str) -> str | None:
    tag = soup.find("meta", attrs={"property": key}) or soup.find("meta", attrs={"name": key})
    if not tag:
        return None
    return tag.get("content")


def parse_relative_time(text: str) -> timedelta | None:
    match = re.search(r"(\d+)\s*(\u5206|\u6642\u9593|\u65e5)\u524d", text)
    if not match:
        return None
    value = int(match.group(1))
    unit = match.group(2)
    if unit == "\u5206":
        return timedelta(minutes=value)
    if unit == "\u6642\u9593":
        return timedelta(hours=value)
    if unit == "\u65e5":
        return timedelta(days=value)
    return None


def extract_links(html: str, base_url: str, patterns: list[str]) -> list[str]:
    soup = BeautifulSoup(html, "html.parser")
    links = set()
    for anchor in soup.find_all("a", href=True):
        href = anchor["href"]
        if any(token in href for token in patterns):
            links.add(urljoin(base_url, href))
    if not links:
        for token in patterns:
            for match in re.findall(re.escape(token) + r"[^\"'\s>]*", html):
                links.add(urljoin(base_url, match))
    return sorted(links)


def build_id(prefix: str, url: str) -> str:
    hash_id = hashlib.md5(url.encode("utf-8")).hexdigest()[:10]
    return f"{prefix}_{hash_id}"


def parse_product_page(url: str) -> dict:
    html = fetch_html(url)
    soup = BeautifulSoup(html, "html.parser")
    product_json = extract_jsonld_product(soup) or {}

    name = clean_text(product_json.get("name"))
    if not name:
        title = soup.find("title")
        name = clean_text(title.get_text()) if title else ""

    description = clean_text(product_json.get("description"))
    if not description:
        description = clean_text(extract_meta(soup, "description"))

    image = first_image(product_json.get("image"))
    if not image:
        image = extract_meta(soup, "og:image")
    if image:
        image = urljoin(url, image)

    offers = product_json.get("offers") if isinstance(product_json, dict) else None
    if isinstance(offers, list) and offers:
        offers = offers[0]
    price = normalize_price(offers.get("price") if isinstance(offers, dict) else None)
    in_stock = normalize_in_stock(offers.get("availability") if isinstance(offers, dict) else None)
    if is_sold_out(html):
        in_stock = False

    if price is None:
        price_match = re.search(r"([0-9,]+)\s*\u5186", html)
        if price_match:
            price = normalize_price(price_match.group(1))

    if price is None:
        price = 0.0

    return {
        "name": name,
        "description": description,
        "image": image or "",
        "price": price,
        "in_stock": in_stock,
        "url": url,
    }


def make_product(prefix: str, category: str, store_id: str, store_name: str, product: dict) -> dict:
    now = datetime.now(timezone.utc).isoformat()
    return {
        "id": build_id(prefix, product["url"]),
        "name": product["name"],
        "category": category,
        "imageUrl": product["image"],
        "description": product["description"] or product["name"],
        "prices": [
            {
                "storeId": store_id,
                "storeName": store_name,
                "price": float(product["price"]),
                "inStock": bool(product["in_stock"]),
                "location": "\u30aa\u30f3\u30e9\u30a4\u30f3",
                "url": product["url"],
                "lastUpdated": now,
            }
        ],
    }


def fetch_sanrio_products() -> list[dict]:
    products = []
    seen_urls = set()
    html = fetch_html(SANRIO_LIST_URL)
    page_urls = {SANRIO_LIST_URL}

    for link in extract_links(html, SANRIO_LIST_URL, ["category_id=130", "page="]):
        if "category_id=130" in link:
            page_urls.add(link)
        if len(page_urls) >= 5:
            break

    for page_url in sorted(page_urls):
        page_html = html if page_url == SANRIO_LIST_URL else fetch_html(page_url)
        for link in extract_links(page_html, SANRIO_LIST_URL, ["/item/detail/"]):
            if link in seen_urls:
                continue
            seen_urls.add(link)
            try:
                product = parse_product_page(link)
            except FetchError:
                continue
            if product["name"]:
                products.append(
                    make_product(
                        "sanrio",
                        "\u30b5\u30f3\u30ea\u30aa",
                        "sanrio_official",
                        "\u30b5\u30f3\u30ea\u30aa\u516c\u5f0f\u30aa\u30f3\u30e9\u30a4\u30f3\u30b7\u30e7\u30c3\u30d7",
                        product,
                    )
                )
    return products


def fetch_tamagotchi_products() -> list[dict]:
    products = []
    seen_urls = set()
    html = fetch_html(TAMAGOTCHI_LIST_URL)
    links = extract_links(html, TAMAGOTCHI_LIST_URL, ["/jp/item/"])

    item_links = []
    for link in links:
        if re.search(r"/jp/item/\d{2}_\d+/?$", link):
            item_links.append(link)

    for link in sorted(set(item_links))[:120]:
        if link in seen_urls:
            continue
        seen_urls.add(link)
        try:
            product = parse_product_page(link)
        except FetchError:
            continue
        name = product["name"]
        if not name:
            continue
        if not any(token in name for token in TAMAGOTCHI_MATCH):
            continue
        products.append(
            make_product(
                "tamagotchi",
                "\u305f\u307e\u3054\u3063\u3061",
                "tamagotchi_official",
                "\u305f\u307e\u3054\u3063\u3061\u516c\u5f0f\u30b5\u30a4\u30c8",
                product,
            )
        )
    return products


def fetch_qlia_products() -> list[dict]:
    products = []
    seen_urls = set()
    html = fetch_html(QLIA_CATEGORY_URL)
    page_urls = {QLIA_CATEGORY_URL}

    for link in extract_links(html, QLIA_CATEGORY_URL, ["page=", "pno="]):
        if "cbid=2943125" in link and "csid=16" in link:
            page_urls.add(link)
        if len(page_urls) >= 5:
            break

    for page_url in sorted(page_urls):
        page_html = html if page_url == QLIA_CATEGORY_URL else fetch_html(page_url)
        links = extract_links(page_html, QLIA_CATEGORY_URL, ["?pid="])

        for link in links:
            if link in seen_urls:
                continue
            seen_urls.add(link)
            try:
                product = parse_product_page(link)
            except FetchError:
                continue
            name = product["name"]
            if not name:
                continue
            if not product["in_stock"]:
                continue
            products.append(
                make_product(
                    "bonbondrop",
                    "\u30dc\u30f3\u30dc\u30f3\u30c9\u30ed\u30c3\u30d7",
                    "bonbondrop_official",
                    "\u30dc\u30f3\u30dc\u30f3\u30c9\u30ed\u30c3\u30d7\u516c\u5f0f\u30aa\u30f3\u30e9\u30a4\u30f3\u30b7\u30e7\u30c3\u30d7",
                    product,
                )
            )
    return products


def infer_location(keyword: str) -> str | None:
    for city, prefecture in CITY_TO_PREF.items():
        if city in keyword:
            return prefecture
    return None


def infer_store_name(keyword: str) -> str | None:
    store_names = [
        "\u30ad\u30c7\u30a3\u30e9\u30f3\u30c9",
        "\u30ed\u30d5\u30c8",
        "\u30cf\u30f3\u30ba",
        "\u30c9\u30f3\u30ad\u30db\u30fc\u30c6",
        "\u30f4\u30a3\u30ec\u30c3\u30b8\u30f4\u30a1\u30f3\u30ac\u30fc\u30c9",
        "\u30a2\u30cb\u30e1\u30a4\u30c8",
    ]
    for store in store_names:
        if store in keyword:
            return store
    return None


def normalize_ddg_url(url: str) -> str:
    try:
        parsed = urlparse(url)
    except Exception:
        return url
    if parsed.netloc.endswith("duckduckgo.com") and parsed.path == "/l/":
        params = parse_qs(parsed.query)
        if "uddg" in params and params["uddg"]:
            return unquote(params["uddg"][0])
    return url


def extract_date_candidates(text: str, now: datetime) -> list[datetime]:
    candidates = []
    year_spans = []
    for match in DATE_WITH_YEAR.finditer(text):
        year, month, day = map(int, match.groups())
        try:
            candidates.append(datetime(year, month, day, tzinfo=now.tzinfo))
            year_spans.append((match.start(), match.end()))
        except ValueError:
            continue
    for match in DATE_NO_YEAR.finditer(text):
        if any(start <= match.start() < end for start, end in year_spans):
            continue
        month, day = map(int, match.groups())
        try:
            candidate = datetime(now.year, month, day, tzinfo=now.tzinfo)
        except ValueError:
            continue
        if candidate < now:
            next_year = datetime(now.year + 1, month, day, tzinfo=now.tzinfo)
            if next_year <= now + timedelta(days=31):
                candidates.append(next_year)
            else:
                candidates.append(candidate)
        else:
            candidates.append(candidate)
    return candidates


def select_upcoming_date(candidates: list[datetime], now: datetime, window_days: int = 31) -> datetime | None:
    latest = now + timedelta(days=window_days)
    upcoming = [date for date in candidates if now <= date <= latest]
    if not upcoming:
        return None
    return sorted(upcoming)[0]


def search_duckduckgo(query: str, max_results: int = 12) -> list[dict]:
    url = "https://duckduckgo.com/html/?q=" + quote(query)
    html = fetch_html(url)
    soup = BeautifulSoup(html, "html.parser")
    results = []
    for result in soup.select("div.result"):
        link = result.select_one("a.result__a")
        if not link:
            continue
        raw_url = link.get("href")
        if not raw_url:
            continue
        target_url = normalize_ddg_url(raw_url)
        if not target_url.startswith("http"):
            continue
        title = clean_text(link.get_text())
        snippet_tag = result.select_one(".result__snippet")
        snippet = clean_text(snippet_tag.get_text()) if snippet_tag else ""
        results.append({
            "title": title,
            "url": target_url,
            "snippet": snippet,
        })
        if len(results) >= max_results:
            break
    return results


def extract_raffle_date(title: str, snippet: str, url: str, now: datetime) -> datetime | None:
    combined = f"{title} {snippet}"
    if "抽選" not in combined:
        return None
    candidates = extract_date_candidates(combined, now)
    selected = select_upcoming_date(candidates, now)
    if selected:
        return selected
    try:
        html = fetch_html(url)
    except FetchError:
        return None
    text = BeautifulSoup(html, "html.parser").get_text(" ", strip=True)
    if "抽選" not in text:
        return None
    candidates = extract_date_candidates(text, now)
    return select_upcoming_date(candidates, now)


def fetch_raffle_posts() -> list[dict]:
    now = datetime.now(timezone(timedelta(hours=9)))
    results = search_duckduckgo("\u30dc\u30f3\u30dc\u30f3\u30c9\u30ed\u30c3\u30d7\u30b7\u30fc\u30eb \u62bd\u9078", max_results=12)
    posts = []
    seen_urls = set()

    for item in results:
        url = item["url"]
        if url in seen_urls:
            continue
        seen_urls.add(url)
        raffle_date = extract_raffle_date(item["title"], item["snippet"], url, now)
        if not raffle_date:
            continue
        date_str = raffle_date.strftime("%Y-%m-%d")
        content = f"\u62bd\u9078\u60c5\u5831: {item['title']} / \u62bd\u9078\u65e5: {date_str}"
        posts.append({
            "id": build_id("raffle", url),
            "type": "other",
            "productId": build_id("raffle", url),
            "username": "\u62bd\u9078\u60c5\u5831",
            "content": content,
            "imageUrl": None,
            "postUrl": url,
            "postedAt": now.isoformat(),
            "storeName": None,
            "location": None,
            "price": None,
            "isVerified": False,
        })

    return posts


def search_yahoo_realtime(keyword: str) -> list[dict]:
    url = (
        "https://search.yahoo.co.jp/realtime/search?p="
        + quote(keyword)
        + "&ei=UTF-8"
    )
    html = fetch_html(url)
    results = []
    seen = set()
    now = datetime.now(timezone.utc)

    for match in re.finditer(r"https://(?:twitter\.com|x\.com)/[^/]+/status/\d+", html):
        link = match.group(0)
        if link in seen:
            continue
        seen.add(link)
        window = html[max(0, match.start() - 200): match.end() + 200]
        delta = parse_relative_time(window)
        posted_at = now - delta if delta else now

        username_match = re.search(r"/(?:twitter\.com|x\.com)/([^/]+)/status/", link)
        username = "@" + username_match.group(1) if username_match else "@unknown"
        status_id = re.search(r"/status/(\d+)", link)
        status_id = status_id.group(1) if status_id else build_id("x", link)

        results.append({
            "id": f"x_{status_id}",
            "type": "twitter",
            "productId": f"x_{status_id}",
            "username": username,
            "content": f"{keyword} \u306b\u95a2\u3059\u308b\u6295\u7a3f",
            "imageUrl": None,
            "postUrl": link,
            "postedAt": posted_at.isoformat(),
            "storeName": infer_store_name(keyword),
            "location": infer_location(keyword),
            "price": None,
            "isVerified": False,
        })

        if len(results) >= X_MAX_URLS_PER_KEYWORD:
            break

    return results


def fetch_x_posts() -> list[dict]:
    keywords = BASE_KEYWORDS + STORE_KEYWORDS + CITY_KEYWORDS
    posts = []
    seen_urls = set()

    for keyword in keywords:
        try:
            keyword_posts = search_yahoo_realtime(keyword)
        except FetchError:
            keyword_posts = []

        for post in keyword_posts:
            if post["postUrl"] in seen_urls:
                continue
            seen_urls.add(post["postUrl"])
            posts.append(post)

        time.sleep(X_REQUEST_DELAY_SECONDS)

    posts.sort(key=lambda item: item["postedAt"], reverse=True)
    return posts


def write_json(path: Path, payload: list[dict]):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as handle:
        json.dump(payload, handle, ensure_ascii=True, indent=2)


def main() -> int:
    all_products = []
    seen = set()

    for fetcher in (fetch_sanrio_products, fetch_tamagotchi_products, fetch_qlia_products):
        try:
            products = fetcher()
        except FetchError:
            products = []
        for product in products:
            url = product["prices"][0]["url"]
            if url in seen:
                continue
            seen.add(url)
            all_products.append(product)

    all_products.sort(key=lambda item: item["name"])

    sns_posts = fetch_x_posts()
    raffle_posts = fetch_raffle_posts()
    if raffle_posts:
        seen = {post["postUrl"] for post in sns_posts}
        for post in raffle_posts:
            if post["postUrl"] in seen:
                continue
            sns_posts.append(post)
            seen.add(post["postUrl"])

    write_json(OUTPUT_DIR / "products.json", all_products)
    write_json(OUTPUT_DIR / "sns.json", sns_posts)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
