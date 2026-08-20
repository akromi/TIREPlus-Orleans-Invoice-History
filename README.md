# TIREPlus Orleans — Invoice History

A self-contained web app to **browse** the TIREPlus Orleans invoice history and
**print any invoice as a PDF** in the same layout as the official
Workshop Software invoice (bilingual EN/FR, HST, section totals).

## Run it — no install, no server

Everything runs locally in the browser from the file system:

1. Download / clone this repository.
2. Double-click **`index.html`** (Chrome, Edge or Firefox).

That's it. All data is bundled in `data/*.js`, so it works completely offline
over `file://` — nothing is uploaded anywhere.

> Optional: if you host the folder on any web server it also works as an
> installable PWA (offline-capable via `sw.js` + `manifest.json`).

## Using the app

- **Search** by customer, plate, job #, invoice #, vehicle or description.
- **Filter** by type (Invoice / Quote / Credit), status (Closed / Open / Parked)
  and posting-date range; **sort** by clicking any column header.
- **Click a row** to open the invoice, rendered like the sample PDF.
- Click **Print / Save as PDF** and pick *Save as PDF* as the destination
  (paper size A4, margins *None* / *Default*, "Background graphics" ON if the
  grey panels don't show).
- **Prev / Next** steps through the invoices of the current filtered list.

## Data

| File | Contents |
|---|---|
| `data/invoices.js` | 12,229 invoices / quotes / credits (Mar 2023 – Aug 2026) |
| `data/items.js` | 70,981 invoice line items |

To refresh with a newer Workshop Software export, run:

```bash
python3 tools/convert_csv.py <invoice_export.csv> <invoice_item_export.csv> data
```

Line items are laid out exactly like the Workshop Software invoice:
items are walked in `ordering` order and every `is_bom_parent` row starts a
service-bundle group (`CODE - Description`) whose lines follow it, closed by a
`CODE Total` row showing Subtotal / HST / Total. Items before the first bundle
(or all items when an invoice has no bundles) fall into the classic
product-type sections (`J` → Labor, `S` → Parts, `T` → Tires,
`W` → Consumables, `A` → Sublet) with a single section total.

Company details printed in the header (address, phone, HST #) are constants at
the top of the `<script>` block in `index.html` — edit them there if they change.
