# ⚖️ Januszex Labor Law RAG App

> *"Panie Areczku! Prawo pracy jest dla zarządu..."*

Nowoczesny asystent prawa pracy wykorzystujący architekturę **RAG (Retrieval-Augmented Generation)**, stworzony z myślą o szybkim, precyzyjnym i bezkompromisowym odpowiadaniu na pytania dotyczące przepisów Kodeksu Pracy. 

Aplikacja mobilna napisana we **Flutterze** komunikuje się z własnym backendem w **Pythonie (Flask)**, który odpytuje bazę wektorową **Qdrant** o faktyczne zapisy prawne i generuje odpowiedzi odporne na halucynacje modelu. 

Ponadto backend za pomocą skryptu automatycznego odpytuje raz dziennie API Sejmu RP w celu weryfikacji nowelizacji przepisów. W przypadku wykrycia zmian system samodzielnie pobiera aktualny tekst ujednolicony (PDF) i przeprowadzania re-indeksację bazy wektorowej, dzięki czemu użytkownik zawsze otrzymuje odpowiedzi w oparciu o najbardziej aktualny stan prawny.

---

## 🏗️ Architektura Projektu

Projekt został zorganizowany w strukturze **Monorepo**, co pozwala na czytelny podział między warstwą mobilną a backendową:

```text
PrawoPracy/
├── backend/                  # Python backend (Flask + LangChain + Qdrant)
│   ├── app.py                # Punkty końcowe API (endpoints)
│   ├── rag.py                # Logika RAG i integracja z LangChain
│   ├── update.py             # Pobieranie aktów z API Sejmu i aktualizacja bazy Qdrant
│   ├── prompts/
│   │   └── prompt_1.txt      # Szablon promptu systemowego
│   ├── Dockerfile            # Konteneryzacja środowiska pod Render.com
│   └── requirements.txt      # Zależności Pythona
│
├── app_flutter/              # Aplikacja mobilna (Flutter / Dart)
│   ├── lib/                  # Główny kod Dart / Flutter
│   │   ├── functions/        # Logika pomocnicza
│   │   └── views/            # Widoki i interfejs użytkownika (UI)
│   └── pubspec.yaml          # Zależności Fluttera
│
└── README.md