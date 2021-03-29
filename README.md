# micro-analytics-cmp

Data report comparison of 3 approaches: `shell/awk`, `julia`, `sql`

## Presentation of the report to be developed

The case to be developed is the movement of stock over a year. The result
expected is a database ready to be published as analysis in tables and graphs.
The available data (data folder) are in 2 files in the format of an electronic spreadsheet containing
all movement of items over 1 (one) year and the initial and final balances of each item
during the corresponding period.

## Expected outcome

> *A database (spreadsheet or CSV) containing the DAILY movement of each ITEM, as follows*:

<ol type="a">
<li>The item: text format
<li>Release date: dd/mm/yyyy format
<li>INPUT entries: quantity, decimal format
<li>INPUT entries: value, decimal format
<li>OUTPUT entries: quantity, decimal format
<li>OUTPUT entries: value, decimal format
<li>Initial balance in quantity, decimal format
<li>Initial balance in value, decimal format
<li>Final balance in quantity, decimal format
<li>Final balance in value, decimal format
</ol>

## Details

<ol type="a">
<li> There may be several entries, either inbound or outbound, for each item in the same
day. Important that the final basis is daily. That is, it is necessary to do the due
daily grouping for each item, adding all occurrences of entry and/or corresponding output
<li> The general balance formula is: `final balance = opening balance + inflow - outflow`
<li> In the balance file, the start and end dates define the total movement period
</ol>

## Source Data

### `SaldoITEM.xlsx` file

<ol type="a">
<li> Item: product item code
<li> start\_date: base date of the initial balance of the item
<li> qty\_initial: opening balance, in quantity
<li> initial\_value: opening balance, in value
<li> end\_date: base date of the final balance of the item
<li> final\_type: final balance, in quantity
<li> final\_value: final balance, in value
</ol>

### `MovtoITEM.xlsx` file

<ol type="a">
<li> item: product item code
<li> movement\_type:
   “Ent” means entry movement of the item in stock
   "Out" means outbound movement of the item in stock
<li> release\_date: date on which the move\_type for the item occurred
<li> quantity: quantity of type\_movement of the item
<li> value: value of the item's move\_type 
</ol>