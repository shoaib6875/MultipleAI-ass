# Glimpse

Sign up, paste a website URL, and keep a picture of that page.

- **Frontend:** React (this repo, `src/`)
- **Backend:** FastAPI (`backend/`)
- **Database:** SQLite, created automatically in `backend/data/`

The interview walkthrough is in [HOW-IT-WORKS.md](HOW-IT-WORKS.md). Start there if you are explaining the project.

For the code, open `backend/main.py` and `src/components/glimpse-app.tsx`. Other folders (`scripts`, `server`) only start the React app.

## Run

```bash
python -m venv backend/.venv
source backend/.venv/bin/activate
pip install -r backend/requirements.txt
uvicorn main:app --app-dir backend --host 127.0.0.1 --port 8000
```

```bash
npm install
npx playwright install chromium
npm run dev
```

The React dev server forwards `/api` to FastAPI on port 8000.

Sample link, already filled in after you sign in:

https://www.justdial.com/Hyderabad/Dr-Sarita-Rao-Tx-Hospitals-Near-Masjid-Uppal-Bus-Stand-Bharath-Nagar-Colony-Uppal/040PXX40-XX40-231215200040-Y2E1_BZDET
