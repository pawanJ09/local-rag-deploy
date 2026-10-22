# Local RAG

Ask questions about your own documents. Everything runs locally in Docker.

You only need **Docker** installed. No Git, no cloning.

## Run it

1. Unzip this package and open a terminal in the folder.
2. Copy the settings file:
   ```bash
   cp .env.example .env
   ```
3. Open `.env` and set:
   - `GHCR_OWNER` to the GitHub user that publishes the images
   - `DOCS_PATH` to the full path of the folder you want to search
4. Start the app:
   ```bash
   docker compose up -d
   ```
5. Download a language model (first time only):
   ```bash
   docker compose exec ollama ollama pull <model-name>
   ```
6. Open http://localhost:3000

## Everyday commands

| Task | Command |
|---|---|
| Start | `docker compose up -d` |
| Stop | `docker compose down` |
| See logs | `docker compose logs -f` |
| Update images | `docker compose pull && docker compose up -d` |

If you have `make`, shortcuts are available: `make up`, `make down`, `make logs`, `make update`, `make pull-models MODEL=<model-name>`.

## Notes

- Ollama in Docker uses the CPU only on a Mac, so answers can be slow.
- Your documents folder is mounted read-only. The app never changes your files.
- Saved vectors and models live in Docker volumes and survive restarts.
- To delete everything, including saved data: `docker compose down -v`
