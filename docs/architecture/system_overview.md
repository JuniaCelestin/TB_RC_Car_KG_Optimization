# System Overview

This project has two distinct tracks that share a single Neo4j graph database: an **offline data pipeline** that builds the graph, and an **online chat path** that queries it.

## Full system diagram

```mermaid
flowchart TB
  subgraph offline [Offline Data Pipeline]
    direction TB
    rawRuns([electrical_dropoff/raw_runs])
    incoming[data_team/incoming]
    validate[validate_raw_telemetry.py]
    clean[clean_raw_telemetry.py]
    buildCSV["build_sessions_csv.py\nbuild_states_csv.py"]
    graphReady[data_team/graph_ready]
    loadScript["load_to_neo4j.py\n+ load_queries.cypher"]

    rawRuns -->|"copy when ready"| incoming
    incoming --> validate --> clean --> buildCSV --> graphReady
    graphReady --> loadScript
  end

  loadScript --> neo4jDB[(Neo4j)]

  subgraph online [Online Chat Path]
    direction TB
    user([User / Browser])
    frontend[frontend\nReact + Vite]
    fastapi[backend\nFastAPI]
    gemini[Gemini API\nCypher generation]

    user -->|"ask question"| frontend
    frontend -->|"POST /chat"| fastapi
    fastapi -->|"prompt + schema"| gemini
    gemini -->|"read-only Cypher"| fastapi
  end

  fastapi -->|"run Cypher"| neo4jDB
  neo4jDB -->|"records"| fastapi
  fastapi -->|"JSON answer"| frontend
  frontend -->|"display answer"| user
```

## Offline track (data pipeline)

Raw telemetry files from the electrical team flow through validation, cleaning, and CSV-building scripts maintained by the data team. The final step loads graph-ready data into Neo4j, creating nodes and relationships that represent sessions, laps, metrics, and their connections.

**Ownership:** Electrical team drops files; data team runs the pipeline and defines the graph schema.

## Online track (chat)

When a user asks a question in the browser, the frontend sends a `POST /chat` request to FastAPI. The backend passes the question (plus the graph schema) to Gemini, which returns a read-only Cypher query. The backend executes that Cypher against Neo4j, formats the results, and returns a JSON answer to the UI.

**Ownership:** Software team builds and maintains the frontend, API, and Gemini integration.

## Chat request lifecycle

```mermaid
sequenceDiagram
  participant U as User
  participant F as frontend
  participant A as FastAPI
  participant G as Gemini
  participant N as Neo4j

  U->>F: Type question
  F->>A: POST /chat {"message": "..."}
  A->>G: System prompt + schema + question
  G-->>A: Read-only Cypher query
  A->>N: Execute Cypher via Bolt
  N-->>A: Result records
  A-->>F: {"answer": "...", "cypher": "..."}
  F-->>U: Display answer
```

## Running locally

Start all three services with one command from the repo root:

```bash
docker compose up --build
```

Full command reference: see [infra/docker/README.md](../../infra/docker/README.md).
