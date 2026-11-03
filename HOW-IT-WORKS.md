# How to explain Glimpse

Say this, then open the file it points at if they want to see the code.

## 30-second version

"Glimpse is a small full-stack app. The website is React. The API is FastAPI.

You create an account. The password is hashed, so we never store the real password. Login returns a signed token, a JWT. The browser keeps that token and sends it on every later request. That is how the API knows who you are.

After login you paste a website URL. The API saves the link for that user and a picture of the page. The shelf only shows your own rows. Even if someone guesses another id, the query also checks the user id inside the token."

## Where to point on the screen

1. Create an account.
2. The sample Justdial link is already filled in. Press **Save preview**.
3. A card appears with a picture of that page.
4. Sign out, sign back in. The card is still there.
5. That saved list belongs to this account only.

## Where the code lives

| Open this | What you say |
| --- | --- |
| `backend/main.py` | The whole API. Signup, login, saving a URL, loading the picture. |
| `backend/capture.mjs` | Our own headless browser. It opens the page and takes a screenshot. |
| `src/lib/api.ts` | The React side of the same calls. This is where the token is attached. |
| `src/components/glimpse-app.tsx` | The two screens: the account form, and the shelf. |

You can ignore `.grok`, `server`, and `scripts`. Those are preview tooling, not the assessment.

## Signup and login

- `POST /api/auth/signup` with name, email, password.
- The password is hashed with PBKDF2 and a random salt. The database stores the salt and the hash, not the password.
- The same email cannot sign up twice.
- `POST /api/auth/login` checks the hash. Wrong email or wrong password both say "Email or password is incorrect", so we don't reveal which emails exist.
- A correct login returns a JWT. It is signed with a server secret and expires in 7 days. It contains the user id, nothing secret.
- React saves it in `localStorage` and sends `Authorization: Bearer <token>`.
- Sign out deletes that token in the browser. There is no session table. If the token is missing, expired, or edited, the API says sign in again.

## Saving a URL

- `POST /api/snapshots` with `{ "url": "..." }`. The token is required.
- If the link has no `https://`, we add it.
- We reject `localhost` and private IPs, so this feature cannot be used to scan the machine the API is running on.
- We try three ways to get a picture, and we **save the file** next to the database row:
  1. Headless Chrome on our server (`backend/capture.mjs`). This is the normal path.
  2. If the site blocks that (Justdial blocks datacenter IPs), we download a snapshot from thum.io and store those bytes ourselves.
  3. If both fail, we try the page's Open Graph image.
- The title comes from the page when the site allows it. If it doesn't, we build a readable title from the link. For the sample URL that becomes the hospital name, with Hyderabad and justdial.com underneath.
- `GET /api/snapshots` returns only rows for the logged-in user.
- The picture is `GET /api/snapshots/{id}/preview`, and that query is `id` **and** `user_id`. The React page downloads it with the token and shows it. A normal `<img>` tag cannot send that header, so we fetch it in JavaScript.

## What we did not add, on purpose

- No password reset, no email verification, no third-party login. The brief is signup, login, save a URL, show the preview again.
- SQLite is one file. No database server to install. Fine for this assessment. The same queries would move to Postgres later without changing the idea.

## Run it locally

Terminal 1:

```bash
python -m venv backend/.venv
source backend/.venv/bin/activate
pip install -r backend/requirements.txt
uvicorn main:app --app-dir backend --host 127.0.0.1 --port 8000
```

On Windows, activate with `backend\.venv\Scripts\activate`.

Terminal 2:

```bash
npm install
npx playwright install chromium
npm run dev
```

Open the site Vite prints. API docs, if you want them: `http://127.0.0.1:8000/docs`.

Playwright is only for the first screenshot attempt. If Chrome is not installed, the API still saves a picture through the snapshot fallback.

Set `GLIMPSE_JWT_SECRET` in the environment before a real deployment. The default secret is for local demos only.
