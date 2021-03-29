## `shell / awk`

1. 'unoconv` for converting from xlsx to csv
2. `awk`,` sort`, `bash` for the script that generates the result

## List of files

1. Entry

- `MovtoITEM.xlsx`: movement worksheet (data entry)
- `SaldoITEM.xlsx`: balance sheet (data entry)

2. Support

- `balance-item.awk`: script for processing the report lines
- `balance-item.sh`: auxiliary script combining scripts and files

3. Output

- `res.csv`: CSV file resulting from the processing 