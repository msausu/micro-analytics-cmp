function datefix(s) {
  split(s, d, "/")
  return (length(d[2]) == 1 ? "0" : "") d[2] "/" (length(d[1]) == 1 ? "0" : "") d[1] "/" d[3]
}

function srt(s) {
  if (length(s) == 0) return ""
  n = split(s, v, " ")
  if (n == 1) return s
  asort(v)
  r = ""
  for (i in v) r = r (v[i] == 0 ? "" : " " v[i])
  return substr(r, 2)
}  

BEGIN {
  last = lastd = ""
  first = 1
  sldQtd = quantidade; accQtd = 0; sldVlr = valor; accVlr = 0
  leqtd = levlr = lsqtd = lsvlr = ""
}

END {
  print last "," $2 "," datefix(lastd) ",\"" \
    srt(leqtd) "\",\"" srt(lsevlr) "\",\"" srt(lsqtd) "\",\"" srt(lsvlr) "\"," \
    sldQtd "," sldVlr "," (sldQtd + accQtd) "," (sldVlr + accVlr)
}

$1 == last && $3 == "Ent" {
  leqtd = leqtd (length(leqtd) == 0 ? "" : " ") $5
  levlr = levlr (length(levlr) == 0 ? "" : " ") $6
  accQtd += $5; accVlr += $6
  next
}

$1 == last && $3 == "Sai" {
  lsqtd = lsqtd (length(lsqtd) == 0 ? "" : " ") $5
  lsvlr = lsvlr (length(lsvlr) == 0 ? "" : " ") $6
  accQtd -= $5; accVlr -= $6
  next
}

first == 0 {
  print last "," $2 "," datefix(lastd) ",\"" \
    srt(leqtd) "\",\"" srt(lsevlr) "\",\"" srt(lsqtd) "\",\"" srt(lsvlr) "\"," \
    sldQtd "," sldVlr "," (sldQtd + accQtd) "," (sldVlr + accVlr)
  sldQtd += accQtd; sldVlr += accVlr; accQtd = 0; accVlr = 0
  if ($3 == "Ent") {
    leqtd = "" $5; levlr = "" $6
    lsqtd = lsvlr = ""
    accQtd += $5; accVlr += $6
  } else if ($3 == "Sai") {
    leqtd = levlr = ""
    lsqtd = "" $5; lsvlr = "" $6
    accQtd -= $5; accVlr -= $6
  }
  last = $1; lastd = $4
  next
}

first == 1 {
  if ($3 == "Ent") {
    leqtd = "" $5; levlr = "" $6
    lsqtd = lsvlr = ""
    accQtd += $5; accVlr += $6
  } else if ($3 == "Sai") {
    leqtd = levlr = ""
    lsqtd = "" $5; lsvlr = "" $6
    accQtd -= $5; accVlr -= $6
  }
  last = $1; lastd = $4; first = 0
  next
}