# micro-analytics-cmp

Data report comparison of 3 approaches: `shell/awk`, `julia`, `sql` (`sqlite`)

## Presentation of the report to be developed

The case to be developed is the movement of stock over a year. The result
expected is a database ready to be published as analysis in tables and graphs.
The available data (data folder) are in 2 files in the format of an electronic spreadsheet containing
all movement of items over 1 (one) year and the initial and final balances of each item
during the corresponding period.

## Expected outcome

1. A database (spreadsheet or CSV) containing the DAILY movement of each ITEM, as follows:

The. Item: text format
B. Release date: dd/mm/yyyy format
ç. ENTRY entries: quantity, decimal format
d. INPUT entries: value, decimal format
e. SAIDA entries: quantity, decimal format
f. SAIDA entries: value, decimal format
g. Initial balance in quantity, decimal format
H. Initial balance in value, decimal format
i. Final balance in quantity, decimal format
j. Final balance in value, decimal format

## Details

a) There may be several entries, either inbound or outbound, for each item in the same
day. Important that the final basis is daily. That is, it is necessary to do the due
daily grouping for each item, adding all occurrences of entry and/or corresponding output
b) The general balance formula is: `final balance = opening balance + inflow - outflow`
c) In the balance file, the start and end dates define the total movement period

## Source Data

### `SaldoITEM.xlsx` file

a) Item: product item code
b) start_date: base date of the initial balance of the item
c) qty_initial: opening balance, in quantity
d) initial_value: opening balance, in value
e) end_date: base date of the final balance of the item
f) final_type: final balance, in quantity
g) final_value: final balance, in value

### `MovtoITEM.xlsx` file

a) item: product item code
b) movement_type:
   “Ent” means entry movement of the item in stock
   "Out" means outbound movement of the item in stock
c) release_date: date on which the move_type for the item occurred
d) quantity: quantity of type_movement of the item
e) value: value of the item's move_type 