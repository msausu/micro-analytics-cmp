
.open "file::memory:";
.mode csv

-- load untyped schema

CREATE TABLE "T_MovtoITEM" (
  "item" TEXT,
  "tipo_movimento" TEXT,
  "data_lancamento" TEXT,
  "quantidade" TEXT,
  "valor" TEXT
);

CREATE TABLE "T_SaldoITEM" (
  "item" TEXT,
  "data_inicio" TEXT,
  "qtd_inicio" TEXT,
  "valor_inicio" TEXT,
  "data_final" TEXT,
  "qtd_final" TEXT,
  "valor_final" TEXT
);

-- load data

.import MovtoITEM.csv T_MovtoITEM
.import SaldoITEM.csv T_SaldoITEM

-- typed schema

CREATE TABLE "MovtoITEM" (
  id integer primary key autoincrement,
  "item" TEXT,
  "tipo_movimento" TEXT,
  "data_lancamento" DATE,
  "quantidade" DECIMAL(12,4),
  "valor" DECIMAL(12,2)
);

CREATE INDEX IX_MovtoITEM_ITEM on MovtoITEM (item);
CREATE INDEX IX_MovtoITEM_ITEM_DATA on MovtoITEM (item, data_lancamento);

CREATE TABLE "SaldoITEM" (
  id integer primary key autoincrement,
  "item" TEXT,
  "data_inicio" DATE,
  "qtd_inicio" DECIMAL(12,4),
  "valor_inicio" DECIMAL(12,2),
  "data_final" DATE,
  "qtd_final" DECIMAL(12,4),
  "valor_final" DECIMAL(12,2)
);

-- reload

insert into MovtoITEM (item, tipo_movimento, data_lancamento, quantidade, valor)
  select
    item,
    tipo_movimento,
    date(data_lancamento),
    cast(quantidade as numeric),
    cast(valor as numeric)
  from
   T_MovtoITEM
;

drop table T_MovtoITEM;

insert into SaldoITEM (item, data_inicio, qtd_inicio, valor_inicio, data_final, qtd_final, valor_final)
  select
    item,
    date(data_inicio),
    cast(qtd_inicio as numeric),
    cast(valor_inicio as numreric),
    date(data_final),
    cast(qtd_final as numeric),
    cast(valor_final as numeric)
  from
    T_SaldoITEM
;

drop table T_SaldoITEM;

-- aux views

drop view if exists vtot;

create view vtot (item, dt, qi, qf, vi, vf) as
  with
    i (item, dt, qtd, vlr) as (
      select
          item, data_lancamento,
          case
            when tipo_movimento = 'Ent' then quantidade
            when tipo_movimento = 'Sai' then quantidade * -1
          end,
          case
            when tipo_movimento = 'Ent' then valor
            when tipo_movimento = 'Sai' then valor * -1
          end
        from
          MovtoItem
    ),
    v (item, dt, q, v) as (
      select item, dt, sum(qtd), sum(vlr) from i group by item, dt
    ),
    s (item, dt, q, v) as (
      select
          item, data_inicio, qtd_inicio, valor_inicio 
        from
          SaldoITEM
        group by
          item
        having
          data_inicio = min(data_inicio)
    ),
    n (i, item, dt, q, v) as (
      select
          row_number() over (), v.item, v.dt, v.q + coalesce(s.q, 0), v.v + coalesce(s.v, 0)
        from 
            v left outer join s
          on
            v.item = s.item and v.dt = s.dt
    ),
    sv (item, dt, q, v) as (
      select 
          item, 
          dt, 
          sum(q) over (partition by n.item order by i), 
          sum(v) over (partition by n.item order by i) 
        from 
          n
    ),
    p (item, dt, qi, qf, vi, vf) as (
      select 
          sv.item,
          sv.dt,
          lag(sv.q, 1, s.q) over (partition by sv.item order by sv.dt),
          sv.q,
          lag(sv.v, 1, s.v) over (partition by sv.item order by sv.dt),
          sv.v
        from 
            sv left outer join s
          on
            sv.item = s.item and sv.dt = s.dt
    )
  select
      item,
      dt,
      printf("%.2f", qi),
      printf("%.2f", qf),
      printf("%.2f", vi),
      printf("%.2f", vf)
    from 
      p
;

drop view if exists vdaily;

create view vdaily (item, dt, qi, vi, qf, vf) as
  with 
    ai (item, dt, n, q, v) as (
      select
        item, data_lancamento,
        row_number() over (partition by item, data_lancamento) n,
        group_concat(printf('%.2f', quantidade), ' ') over (partition by item, data_lancamento order by quantidade),
        group_concat(printf('%.2f', valor), ' ') over (partition by item, data_lancamento order by valor) 
      from 
        MovtoITEM
      where 
        tipo_movimento = 'Ent'
    ),
    ao (item, dt, n, q, v) as (
      select
        item, data_lancamento,
        row_number() over (partition by item, data_lancamento) n,
        group_concat(printf('%.2f', quantidade), ' ') over (partition by item, data_lancamento order by quantidade),
        group_concat(printf('%.2f', valor), ' ') over (partition by item, data_lancamento order by valor) 
      from 
        MovtoITEM
      where 
        tipo_movimento = 'Sai'
    ),
    li (item, dt, n, q, v) as (
      select * from ai group by item, dt having n = max(n)
    ),
    lo (item, dt, n, q, v) as (
      select * from ao group by item, dt having n = max(n)
    )
  select
        li.item, li.dt, li.q, li.v, lo.q, lo.v
      from
          li left outer join lo
        on
          li.item = lo.item and li.dt = lo.dt
  union
  select
        lo.item, lo.dt, li.q, li.v, lo.q, lo.v
      from
          lo left outer join li
        on
          lo.item = li.item and lo.dt = li.dt
;

drop view if exists vbalance;

create view vbalance (item, dt, qtd_ent, vlr_ent, qtd_sai, vlr_sai, qtd_ini, vlr_ini, qtd_fin, vlr_fin)  as 
  select
      t.item, t.dt, a.qi, a.vi, a.qf, a.vf, t.qi, t.vi, t.qf, t.vf
    from
        vtot t inner join vdaily a
      on
        t.item = a.item and t.dt = a.dt
;

-- res 

select * from vbalance order by 2, 1;

.exit

-- eof
