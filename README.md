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
- **Tire Storage** (header tab) shows the seasonal tire-storage history:
  every storage charge and pick-up/removal grouped by customer with their
  plates, tire sizes, totals and last activity; optionally interleaved with
  the seasonal tire-swap visits. Rows open the underlying invoice.
  Each customer's status is taken from the **physical stocktake** when one is
  loaded: **On the rack** (with slot numbers), **Gone — pickup not recorded**,
  or **Closed out**. Without a stocktake the app falls back to inferring
  **Possibly abandoned** from inactivity (12 or 24 month threshold). **Print list** produces a clean landscape report of exactly what is on
  screen (current search, filters and swap toggle), with a title header and
  repeating column headers; invoices always print portrait.
- **Internal notes** (job-card and invoice notes, including supplier invoice
  references like `WP#…`, `PS#…`, `NP#…`) appear in an amber box above the
  invoice — on screen only, they are never part of the printed PDF.

## Data

| File | Contents |
|---|---|
| `data/invoices.js` | 12,229 invoices / quotes / credits (Mar 2023 – Aug 2026) |
| `data/items.js` | 70,981 invoice line items |
| `data/customers.js` | 4,688 customers (phone, email, address, account balance) |
| `data/vehicles.js` | 5,255 vehicles (VIN, next service date, tire size) |
| `data/inventory.js` | physical tire-rack stocktake — 48 slots, 44 occupied |

Customers are joined to invoices by display name and vehicles by plate, which
fills in the phone, address, VIN and next-service fields on the printed
invoice, and makes phone numbers, emails and VINs searchable.

**Invoice Cleanup** (header tab) turns the stale open invoices into a
worklist for closing them off in Workshop Software. Every invoice carrying a
balance is tiered: **Safe to close** ($0 account balance, over a year old,
under $500, no tires on the racks), **Review first** (large amounts or
customers whose tires you hold) and **Keep open** (a real account balance, or
under a year old). Each row explains its reasoning, ticks off as you close it
in WSS (ticks persist in that browser), and the list prints landscape with
tick boxes or exports to CSV. The app never writes to Workshop Software.

**Balances** (header tab) flags customers who still owe money, showing two
figures side by side: the **account balance** Workshop Software keeps on the
customer record (what is really owed, updated as payments are applied) and the
total of **open invoices** (invoices never marked closed). Filter to confirmed
balances, all open invoices, customers whose tires are on the racks, or recent
debt only; sortable, printable landscape and exportable to CSV. Customers with
a balance are also flagged in the Tire Storage and Rack Inventory views.

**Rack Inventory** (header tab) lists the physical stocktake slot by slot —
customer, plate, vehicle, tires, rims, last swap — flags each set as
**Billed**/**Not billed** for storage, filters by container or unbilled only,
and prints landscape. After a new stocktake, update `tools/inventory_rows.py`
and run `python3 tools/convert_inventory.py data`.

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
