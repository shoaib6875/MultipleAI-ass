#!/bin/sh
set -eu
cd /workspace
node scripts/preview.mjs stop || true

if ! curl -sf -o /dev/null --max-time 2 http://127.0.0.1:8000/api/health; then
  if [ ! -x /workspace/backend/.venv/bin/uvicorn ]; then
    python3 -m venv /workspace/backend/.venv
    /workspace/backend/.venv/bin/pip install -r /workspace/backend/requirements.txt
  fi
  /workspace/backend/.venv/bin/uvicorn main:app --app-dir /workspace/backend --host 127.0.0.1 --port 8000 >>/tmp/glimpse-api.log 2>&1 &
fi

if curl -sf -o /dev/null --max-time 2 http://127.0.0.1:8080/; then
  exit 0
fi
npm run dev >>/tmp/app-startup.log 2>&1 &
