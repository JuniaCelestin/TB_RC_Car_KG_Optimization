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

## Technologies

**Docker** — Makes sure the app runs the same way on every computer, no matter what operating system you're using.

**Backend (Python):**

| Package | What it does |
|---|---|
| **fastapi** | Creates the API that the frontend talks to (handles `/health` and `/chat` requests) |
| **uvicorn[standard]** | The server that runs FastAPI and listens for incoming requests |
| **pydantic** | Validates incoming data so bad requests get rejected automatically |
| **pydantic-settings** | Loads settings from the `.env` file into Python so you don't hardcode secrets |
| **neo4j** | Connects Python to the Neo4j graph database so you can run Cypher queries |
| **python-dotenv** | Reads the `.env` file and makes its values available as environment variables |
| **google-generativeai** | Talks to Google's Gemini AI to turn plain English questions into Cypher queries |

**Frontend (TypeScript):**

| Package | What it does |
|---|---|
| **React** | Builds the chat UI from reusable pieces (components) |
| **Vite** | Runs the frontend locally and refreshes the browser when you save changes |
| **TypeScript** | JavaScript but with types, so you catch mistakes early |

## Local development model (Docker-first)

- **`docker-compose.yml`** (repo root) — defines the full stack (`frontend`, `backend`, `neo4j`)
- **`infra/Dockerfile.backend`** / **`infra/Dockerfile.frontend`** — dev images for the API and UI

**Full command reference (ports, logs, troubleshooting):** see [`infra/docker/README.md`](infra/docker/README.md).

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

Treat the folder boundaries below as the "contract" between teams:
- Raw electrical input: `electrical_dropoff/raw_runs/`
- Data processing + graph loading: `data_team/`
- Chat API: `backend/`
- Chat UI: `frontend/`

## Student TODOs

Every file that students need to implement contains globally numbered `TODO` comments (TODO-1 through TODO-21) with step-by-step instructions. Search for `TODO-` in your editor to find them all. The numbers are sequential across the entire project so you can assign specific TODOs to specific students.

**Backend — TODOs 1–11 across 7 files:**

| # | File | What you implement |
|---|---|---|
| TODO-1 | `backend/app/models/schemas.py` | Add `message` field to ChatRequest |
| TODO-2 | `backend/app/models/schemas.py` | Add `answer` and `cypher` fields to ChatResponse |
| TODO-3 | `backend/app/models/schemas.py` | Add fields to HealthResponse |
| TODO-4 | `backend/app/main.py` | Add CORS middleware |
| TODO-5 | `backend/app/main.py` | Register route files (routers) |
| TODO-6 | `backend/app/api/routes/health.py` | Check Neo4j connectivity, return health status |
| TODO-7 | `backend/app/api/routes/chat.py` | Error handling with try/except and HTTP status codes |
| TODO-8 | `backend/app/services/graph_client.py` | Execute Cypher queries against Neo4j |
| TODO-9 | `backend/app/services/answer_formatter.py` | Format Neo4j results into readable text |
| TODO-10 | `backend/app/services/chat_service.py` | Write the Gemini system prompt |
| TODO-11 | `backend/app/services/chat_service.py` | Call the Gemini API and extract Cypher |

**Frontend — TODOs 12–21 across 7 files:**

| # | File | What you implement |
|---|---|---|
| TODO-12 | `frontend/src/types/chat.ts` | Define TypeScript types matching backend schemas |
| TODO-13 | `frontend/src/lib/api.ts` | Implement `sendChat()` POST to `/chat` |
| TODO-14 | `frontend/src/lib/api.ts` | (Optional) Implement `getHealth()` |
| TODO-15 | `frontend/src/main.tsx` | Mount the React app into the page |
| TODO-16 | `frontend/src/App.tsx` | Import and render the ChatLayout component |
| TODO-17 | `frontend/src/components/ChatInput.tsx` | Create input state variable |
| TODO-18 | `frontend/src/components/ChatInput.tsx` | Build submit handler and JSX |
| TODO-19 | `frontend/src/components/MessageList.tsx` | Render messages with user/bot styling |
| TODO-20 | `frontend/src/components/ChatLayout.tsx` | State management, handleSend function |
| TODO-21 | `frontend/src/components/ChatLayout.tsx` | Render layout with MessageList and ChatInput |

**Instructor-owned files (do not modify):** `backend/app/core/config.py`, all Docker/infra files, `Makefile`, `scripts/*.sh`.

## File structure

```text
.
├── README.md
├── LICENSE
├── Makefile
├── docker-compose.yml            # full stack: frontend, backend, neo4j
├── .env.example
├── backend/
│   ├── requirements.txt
│   └── app/
│       ├── main.py               # TODO-4, 5
│       ├── api/routes/
│       │   ├── chat.py           # TODO-7
│       │   └── health.py         # TODO-6
│       ├── core/
│       │   └── config.py         # instructor-owned
│       ├── models/
│       │   └── schemas.py        # TODO-1, 2, 3
│       └── services/
│           ├── chat_service.py   # TODO-10, 11
│           ├── graph_client.py   # TODO-8
│           └── answer_formatter.py # TODO-9
├── frontend/
│   ├── package.json
│   ├── index.html
│   ├── tsconfig.json
│   ├── vite.config.ts
│   ├── public/
│   │   └── favicon.svg
│   └── src/
│       ├── main.tsx              # TODO-15
│       ├── App.tsx               # TODO-16
│       ├── lib/api.ts            # TODO-13, 14
│       ├── types/chat.ts         # TODO-12
│       └── components/
│           ├── ChatLayout.tsx    # TODO-20, 21
│           ├── ChatInput.tsx     # TODO-17, 18
│           └── MessageList.tsx   # TODO-19
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
│   └── architecture/
│       └── system_overview.md
├── infra/
│   ├── docker/
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
