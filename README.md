# micro-analytics-cmp

Data report comparison of 3 approaches: `shell/awk`, `julia`, `sql`

## Presentation of the report to be developed

The case to be developed is the movement of stock over a year. The result
expected is a database ready to be published as analysis in tables and graphs.
The available data (data folder) are in 2 files in the format of an electronic spreadsheet containing
all movement of items over 1 (one) year and the initial and final balances of each item
during the corresponding period.

## Expected outcome

1. A database (spreadsheet or CSV) containing the DAILY movement of each ITEM, as follows:

The. Item: text format
a. Release date: dd/mm/yyyy format
b. INPUT entries: quantity, decimal format
c. INPUT entries: value, decimal format
d. OUTPUT entries: quantity, decimal format
e. OUTPUT entries: value, decimal format
f. Initial balance in quantity, decimal format
g. Initial balance in value, decimal format
h. Final balance in quantity, decimal format
i. Final balance in value, decimal format

## Details

a. There may be several entries, either inbound or outbound, for each item in the same
day. Important that the final basis is daily. That is, it is necessary to do the due
daily grouping for each item, adding all occurrences of entry and/or corresponding output
b. The general balance formula is: `final balance = opening balance + inflow - outflow`
c. In the balance file, the start and end dates define the total movement period

## Source Data

### `SaldoITEM.xlsx` file

a. Item: product item code
b. start\_date: base date of the initial balance of the item
c. qty\_initial: opening balance, in quantity
d. initial\_value: opening balance, in value
e. end\_date: base date of the final balance of the item
f. final\_type: final balance, in quantity
g. final\_value: final balance, in value

### `MovtoITEM.xlsx` file

a. item: product item code
b. movement\_type:
   “Ent” means entry movement of the item in stock
   "Out" means outbound movement of the item in stock
c. release_date: date on which the move_type for the item occurred
d. quantity: quantity of type\_movement of the item
e. value: value of the item's move\_type 
