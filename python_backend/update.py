import requests
import time
import random
from datetime import datetime
from rag import RetrievalAugmentedGeneration
from qdrant_client.http.exceptions import UnexpectedResponse


def update():
    url = "https://api.sejm.gov.pl/eli/acts/DU/1974/volumes/24"
    last_change = datetime.fromisoformat("2024-10-14T09:58:16")

    while True:
        print("[UPDATE MANAGER]: Check for law update...", flush=True)

        try:
            response = requests.get(url)
            data = response.json()["items"][1]
            change_date = datetime.fromisoformat(data["changeDate"])

            if last_change < change_date:
                print("[UPDATE MANAGER]: Found changes! Download new file...", flush=True)
                update_url = "https://isap.sejm.gov.pl/isap.nsf/download.xsp/WDU19740240141/U/D19740141Lj.pdf"
                download_file = requests.get(
                    update_url,
                    headers={
                        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
                        "Accept": "application/pdf",
                    },
                )
                with open("D19740141Lj.pdf", mode="wb") as file:
                    file.write(download_file.content)
                RetrievalAugmentedGeneration("labour_law").update()
                last_change = change_date
            else:
                print("[UPDATE MANAGER]: Don't need to update", flush=True)
        except UnexpectedResponse as e:
            if e.status_code == 404:
                pass
            else:
                raise e
        except Exception as e:
            print(f"Błąd pobierania:\n{e}", flush=True)
        time.sleep(random.randint(43200, 86400))
