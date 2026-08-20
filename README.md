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

- **Search** by customer, plate, job #, invoice #, vehicle, description,
  phone number, email, VIN — or a supplier (purchase) invoice reference from
  the job-card notes, e.g. `wp#8332813` or `ps#669192`.
- **Filter** by type (Invoice / Quote / Credit), status (Closed / Open / Parked),
  purchase refs (with / without) and posting-date range; **sort** by clicking
  any column header. The **Purchase Refs** column lists every supplier invoice
  reference found in the job's notes.
- **Export CSV** downloads the currently filtered list (with the purchase
  refs) for reconciling supplier invoices in a spreadsheet.
- **Click a row** to open the invoice, rendered like the sample PDF.
- Click **Print / Save as PDF** and pick *Save as PDF* as the destination
  (paper size A4, margins *None* / *Default*, "Background graphics" ON if the
  grey panels don't show).
- **Prev / Next** steps through the invoices of the current filtered list.
- **Internal notes** (job-card and invoice notes, including supplier invoice
  references like `WP#…`, `PS#…`, `NP#…`) appear in an amber box above the
  invoice — on screen only, they are never part of the printed PDF.

## Data

| File | Contents |
|---|---|
| `data/invoices.js` | 12,229 invoices / quotes / credits (Mar 2023 – Aug 2026) |
| `data/items.js` | 70,981 invoice line items |
| `data/customers.js` | 4,688 customers (phone, email, address) |
| `data/vehicles.js` | 5,255 vehicles (VIN, next service date) |

Customers are joined to invoices by display name and vehicles by plate, which
fills in the phone, address, VIN and next-service fields on the printed
invoice, and makes phone numbers, emails and VINs searchable.

To refresh with newer Workshop Software exports, run:

```bash
python3 tools/convert_csv.py <invoices.csv> <invoice_items.csv> [customers.csv] [vehicles.csv] data
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
