# local-rag kit

Ask questions about your own documents. Everything runs on your computer, and
nothing is sent to the internet while you use it.

## What you need

- **Docker Desktop**, running.
- **About 8 GB of memory** given to Docker, and **about 10 GB of free disk**.
- **Internet for the first start only.** It downloads the app and two AI models
  (about 5 GB). After that it works offline.
- Free ports **3000** and **8000**.

## Start it (first time)

1. **Make your settings file.** In this folder run:
   ```bash
   make init
   ```
   (No `make`? Copy `.env.example` to `.env` and put any long random text on the
   `API_KEY=` line. On Mac/Linux, `openssl rand -hex 32` makes one.)
2. **Put your documents in a folder called `docs`** next to this file:
   `.txt`, `.md`, `.pdf` and `.docx` files are read. Folders inside are fine.
   To use a folder somewhere else, set `DOCS_HOST_DIR` in `.env`.
3. **Start everything:**
   ```bash
   docker compose up -d
   ```
   The first time this takes several minutes because it downloads the models.
   To watch: `docker compose logs -f model-puller`.
4. **Open http://localhost:3000**, click **Re-scan documents**, then ask a question.

## Everyday use

| I want to... | Run |
|---|---|
| Start | `docker compose up -d` (or `make up`) |
| Stop (keeps your index and models) | `docker compose down` (or `make down`) |
| Add or change documents | Put them in `docs`, then click **Re-scan documents** |
| Update to newer versions | `docker compose pull`, then `docker compose up -d` |
| See what is happening | `docker compose logs -f` |
| Erase the index and the downloaded models | `docker compose down -v` |

## If something goes wrong

- **"manifest unknown" or "denied" when starting:** the images have not been
  published and made public yet, or the username in `docker-compose.yml` is wrong.
- **The page says "Cannot reach the backend":** the backend is still starting.
  Wait a minute and refresh. Check with `docker compose ps`.
- **Answers are slow:** on a Mac, Docker cannot use the GPU, so the model runs on
  the CPU. Set a smaller `LLM_MODEL` in `.env` (for example `llama3.2:3b`) and run
  `docker compose up -d`.
- **"I don't have that information":** the app only answers from your documents.
  Make sure the file was scanned (it appears under "Indexed documents").

## Good to know

- Both web addresses only work on this computer. To share them on your network,
  remove `127.0.0.1:` from the `ports` lines in `docker-compose.yml`.
- The API key is not a user login. Anyone who can open the web page can use it.
- Your documents are only read, never changed. The index lives in a Docker volume,
  not in this folder.
- The AI models come with their own licences. Check the licence of the model you use
  before sharing answers or this kit commercially.

## For the person publishing this kit

1. Publish the backend and UI images (their own repos build them on every push to
   `main` and on version tags) and set each package to **Public** on GitHub.
2. The username (`pawanj09`) is already written into the two image lines of
   `docker-compose.yml`. Change those two lines only if the images move to another
   GitHub account.
3. Edit `BACKEND_VERSION` and `UI_VERSION` in `.env.example` if you want the kit
   pinned to specific versions instead of `latest`.
4. Push a tag such as `v1.0.0`. The `release-kit` workflow attaches the kit zip
   (compose file, README and `.env.example`) to the release, with your username
   filled into `docker-compose.yml`.
5. The `test-stack` workflow runs on every push and pull request. It starts the
   published images, ingests a sample file and asks one question.
6. `make save` writes `local-rag-images.tar` for a computer that cannot reach the
   registry (load it with `docker load -i local-rag-images.tar`). It does not contain
   the AI models, so that computer still needs internet once to download them,
   unless you copy the models in another way.
