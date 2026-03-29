# RC Car Graph Chatbot + Data Pipeline

This repository is organized around a simple end-to-end workflow:
`electrical_dropoff (raw telemetry) -> data_team (clean/transform) -> Neo4j (graph) -> backend (chat API) -> frontend (chat UI)`

## Teams and responsibilities

### Electrical team
- Drops raw telemetry files into `electrical_dropoff/raw_runs/`
- Follows the file naming + payload conventions described in `electrical_dropoff/README.md`
- Does not modify pipeline/graph-loading scripts

### Data team
- Copies raw files into `data_team/incoming/` when ready
- Validates and cleans raw telemetry in `data_team/processing/`
- Builds graph-ready CSVs in `data_team/processing/`
- Loads graph-ready data into Neo4j in `data_team/graph/`

### Software team
- Builds the chatbot UI in `frontend/`
- Builds the FastAPI backend API in `backend/`
- Queries Neo4j via the backend graph client

## Local development model (Docker-first)

Stack definitions and Dockerfiles live under `infra/`:

- **`infra/docker/docker-compose.yml`** — canonical Compose file (`frontend`, `backend`, `neo4j`)
- **`docker-compose.yml`** (repo root) — includes the file above so you can run `docker compose` from the project root
- **`infra/Dockerfile.backend`** / **`infra/Dockerfile.frontend`** — dev images for the API and UI

**Full command reference (ports, logs, troubleshooting, optional compose path):** see [`infra/docker/README.md`](infra/docker/README.md).

### Quick start

From the **repository root** (where this `README.md` is):

1. Copy environment defaults from `.env.example` to `.env`.

   **Windows**

   ```powershell
   Copy-Item .env.example .env
   ```

   **Mac and Linux**

   ```bash
   cp .env.example .env
   ```

   Edit `.env` and add a **Google Gemini** API key (free tier) from [Google AI Studio](https://aistudio.google.com/apikey) as `GEMINI_API_KEY`. The chat backend uses Gemini to turn questions into read-only Cypher queries against Neo4j.

2. Start the stack:

   ```bash
   docker compose up --build
   ```

3. Stop when finished:

   ```bash
   docker compose down
   ```

Optional: use **`Makefile`** targets (`make up`, `make down`, …) if you have `make` installed (common on Mac and Linux).

**System architecture diagram:** see [docs/architecture/system_overview.md](docs/architecture/system_overview.md) for a visual walkthrough of the offline data pipeline and the online chat path.

## Where to edit

Treat the folder boundaries below as the “contract” between teams:
- Raw electrical input: `electrical_dropoff/raw_runs/`
- Data processing + graph loading: `data_team/`
- Chat API: `backend/`
- Chat UI: `frontend/`

## File structure

```text
.
├── README.md
├── LICENSE
├── Makefile
├── docker-compose.yml          # includes infra/docker/docker-compose.yml
├── .env.example
├── backend/
│   ├── requirements.txt
│   └── app/
│       ├── main.py
│       ├── api/routes/
│       │   ├── chat.py
│       │   └── health.py
│       ├── core/
│       │   ├── config.py
│       │   └── logging_config.py
│       ├── models/
│       │   └── schemas.py
│       └── services/
│           ├── chat_service.py
│           ├── graph_client.py
│           ├── query_templates.py
│           └── answer_formatter.py
├── frontend/
│   ├── package.json
│   ├── index.html
│   ├── tsconfig.json
│   ├── vite.config.ts
│   ├── public/
│   │   └── favicon.svg
│   └── src/
│       ├── main.tsx
│       ├── App.tsx
│       ├── lib/api.ts
│       ├── types/chat.ts
│       └── components/
│           ├── ChatLayout.tsx
│           ├── ChatInput.tsx
│           └── MessageList.tsx
├── data_team/
│   ├── README.md
│   ├── incoming/
│   │   └── .gitkeep
│   ├── processing/
│   │   ├── validate_raw_telemetry.py
│   │   ├── clean_raw_telemetry.py
│   │   ├── build_sessions_csv.py
│   │   └── build_states_csv.py
│   └── graph/
│       ├── load_to_neo4j.py
│       └── cypher/
│           ├── constraints.cypher
│           └── load_queries.cypher
├── electrical_dropoff/
│   ├── README.md
│   └── raw_runs/
│       └── .gitkeep
├── docs/
│   ├── architecture/
│   │   ├── system_overview.md
│   │   └── graph_schema_notes.md
│   ├── repo_design/
│   │   └── RC_Car_Repo_Design_Document.md
│   └── team_handoffs/
│       ├── data_team_workflow.md
│       └── electrical_team_workflow.md
├── infra/
│   ├── docker/
│   │   ├── docker-compose.yml
│   │   └── README.md
│   ├── Dockerfile.backend
│   └── Dockerfile.frontend
└── scripts/
    ├── bootstrap.sh
    ├── run_backend.sh
    ├── run_frontend.sh
    ├── run_data_pipeline.sh
    └── load_graph.sh
```
