import requests
from bs4 import BeautifulSoup
import json

headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) "
                      "Chrome/91.0.4472.124 Safari/537.36"
    }

def get_performance_links(base_url):
    response = requests.get(base_url, headers=headers)
    soup = BeautifulSoup(response.text, 'html.parser')
    performances = []

    for a_tag in soup.select(".catItemImage a"):
        performances.append(a_tag['href'])

    return performances


def get_performance_details(performance_url):
    response = requests.get("https://mnt.mk" + performance_url, headers=headers)
    soup = BeautifulSoup(response.text, 'html.parser')

    title = soup.select_one(".itemTitle").text.strip() if soup.select_one(".itemTitle") else ""
    image = soup.select_one(".itemImage img")

    image_url = image["src"] if image else None

    description = soup.select_one(".itemFullText")

    if description:
        description = "\n".join([p.get_text(strip=True) for p in description.find_all("p", recursive=False)])
    else:
        description = None

    datetime = soup.select_one(".mod_events_latest_first")
    date = ""
    time = ""
    if datetime:
        date = datetime.find_all("span")[0].get_text(strip=True)
        time = datetime.find_all("span")[1].get_text(strip=True)

    return {
        "title": title,
        "image": "https://mnt.mk" + image_url,
        "description": description,
        "date": date,
        "time": time,
        "location": "Skopje, Macedonian National Theatre",
        "url": "https://mnt.mk" + performance_url
    }


def main():
    base_url = "https://mnt.mk/en/pretstavi-menu/performances"
    performance_links = get_performance_links(base_url)

    all_performances = []
    for link in performance_links:
        details = get_performance_details(link)
        all_performances.append(details)

    with open("../lib/assets/plays.json", "w", encoding="utf-8") as f:
        json.dump(all_performances, f, ensure_ascii=False, indent=4)


if __name__ == "__main__":
    main()