# YoWork × Geopher — Product Update Deck

An HTML presentation covering the latest product updates across **YoWork** and **Geopher** (YOYO Holdings), July 2026.

## Contents

- `index.html` — the **updates hub**: one entry per product update, each with its own table of contents deep-linking into the deck's slides
- `yowork-geopher-update.html` — the single-file slide deck (open directly in a browser)
- `yoyo-assets/` — logos, mascots, icons, QR code, and screenshots used by the deck
- `*.mp4` — the seven feature recordings embedded in the deck (720p, web-optimized)
- `serve-presentation.ps1` — optional local static server (PowerShell)

## Topics covered

1. **E-Signature** — Sign All, bulk sign requests, and external (third-party) signing links tracked via Lark
2. **Projects — Work Board** — filters, an updated Insights page, and assignment filtering & sorting
3. **People-First Dashboard** — workload, presence, morale & priorities
4. **Geopher × Xendit** — purchase and change plans directly through Xendit
5. **Brand Relation Tagging & Dedup** — alias grouping and ignore list for cleaner competitive analysis

## Viewing

Open `index.html` for the updates hub, or `yowork-geopher-update.html` for the deck directly. In the deck, use the arrow keys or the on-screen dots to navigate; `#n` in the URL jumps to slide _n_ (which is how the hub's chapter links work).

Also published via GitHub Pages at
<https://nkmcheng.github.io/yowork-geopher-updates-july2026/>

(The root URL shows the updates hub; each entry links into its deck.)

## Adding a future update

1. Put the new deck in its own folder, e.g. `updates/2026-08/`, and host its videos externally (link them by URL) to keep the repo light.
2. In `index.html`, copy the `<article class="entry">` block (there's a how-to comment above it), paste it **above** the previous update so newest stays first.
3. Move the `LATEST` badge to the new entry and update the date, summary, deck link, and chapter links (`#n` = slide _n_).

## Optional: run a local server

```powershell
./serve-presentation.ps1
```

Then open the printed `http://127.0.0.1:8734/` URL.
