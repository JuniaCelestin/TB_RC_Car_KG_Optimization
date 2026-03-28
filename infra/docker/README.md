# Docker development

All Compose configuration for this project lives in this folder:

| File | Purpose |
|------|---------|
| `docker-compose.yml` | Defines `frontend`, `backend`, and `neo4j` services |
| `../Dockerfile.backend` | Image for the FastAPI app |
| `../Dockerfile.frontend` | Image for the Vite + React app |

The file at the **repository root** (`../../docker-compose.yml`) only **includes** this compose file so you can run `docker compose` from the project root without extra flags.

## Prerequisites

- Docker with the Compose plugin (`docker compose version`, not only legacy `docker-compose`).
- From the repository root, copy environment defaults:

**Windows**

```powershell
Copy-Item .env.example .env
```

**Mac and Linux**

```bash
cp .env.example .env
```

Optional variables in `.env`: `BACKEND_PORT`, `FRONTEND_PORT`, `NEO4J_USERNAME`, `NEO4J_PASSWORD`.

## Run from repository root (recommended)

Always `cd` to the top level of the clone (where `README.md` and `docker-compose.yml` are).

### Start everything (foreground, logs in terminal)

```bash
docker compose up --build
```


### Stop and remove containers

```bash
docker compose down
```

### Follow logs

```bash
docker compose logs -f
```

### Service status

```bash
docker compose ps
```

### Rebuild images without cache

```bash
docker compose build --no-cache
```

### Start individual services

```bash
docker compose up neo4j
docker compose up --build backend
docker compose up --build frontend
```

## Explicit compose file path

If you prefer to point at this folder directly:

```bash
docker compose -f infra/docker/docker-compose.yml up --build
```

Use the same `-f infra/docker/docker-compose.yml` prefix with `down`, `logs`, `ps`, etc.

## Ports in use

If you see “port already allocated”, pick different host ports:

**Windows**

```powershell
$env:BACKEND_PORT="18000"; $env:FRONTEND_PORT="15173"; docker compose up -d
```

**Mac and Linux**

```bash
BACKEND_PORT=18000 FRONTEND_PORT=15173 docker compose up -d
```

Default URLs (with default ports):

- Frontend: `http://localhost:5173`
- Backend API: `http://localhost:8000`
- Neo4j Browser: `http://localhost:7474`
- Bolt (from host tools): `bolt://localhost:7687`

## Data pipeline and graph load (host Python)

These run on your machine, not inside Compose, and talk to Neo4j once it is up:

```bash
python data_team/processing/validate_raw_telemetry.py
python data_team/processing/clean_raw_telemetry.py
python data_team/processing/build_sessions_csv.py
python data_team/processing/build_states_csv.py
python data_team/graph/load_to_neo4j.py
```

## Shell helper scripts

From the repo root:

**Mac and Linux**

```bash
sh scripts/bootstrap.sh
sh scripts/run_backend.sh
sh scripts/run_frontend.sh
```

**Windows**

Use **Git Bash** or **WSL** and run the same commands as on **Mac and Linux**, or use PowerShell with the `docker compose` commands from the sections above.

## Cross-platform notes

- Prefer `docker compose` (V2) on **Windows**, **Mac**, and **Linux**.
- **Windows:** run `docker compose` from PowerShell or Command Prompt at the repo root; forward slashes in paths are fine for Docker.
- **Mac and Linux:** run from Terminal at the repo root.
- Keep `scripts/*.sh` saved with **LF** line endings so they run correctly on Mac and Linux.
