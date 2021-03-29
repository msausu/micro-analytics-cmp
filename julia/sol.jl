using DataFrames, DataValues, Query, CategoricalArrays, Dates, Printf, XLSX
import Base.:(==), Base.:(<)

macro XLSX2DF(var, xlsx)
    quote 
        $(esc(var)) = XLSX.openxlsx(string("../data/", $xlsx, ".xlsx")) do xf DataFrame(XLSX.gettable(xf[$xlsx])...) end
    end
end

mutable struct Balance{T <: Number}
    i::AbstractArray{T, 1}
    o::AbstractArray{T, 1}
    s::T
    f::T
    function Balance{T}(v::T) where {T <: Number}
        self = new()
        self.i = Array{T, 1}()
        self.o = Array{T, 1}()
        self.s = v
        self.f = v
        self
    end
end

Balance(v::Float64) = Balance{Float64}(v)
Balance(v::Int64) = Balance{Float64}(convert(Float64, v))

mutable struct DailyBalance{T <: Number}
    q::Balance{T}
    v::Balance{T}
    function DailyBalance{T}(q::T, v::T) where {T <: Number}
        self = new()
        self.q = Balance{T}(q)
        self.v = Balance{T}(v)
        self
    end
end

DailyBalance(q::Float64, v::Float64) = DailyBalance{Float64}(q, v)
DailyBalance(q::Int64, v::Int64) = DailyBalance{Float64}(convert(Float64, q), convert(Float64, v))
DailyBalance(q::Float64, v::Int64) = DailyBalance{Float64}(q, convert(Float64, v))
DailyBalance(q::Int64, v::Float64) = DailyBalance{Float64}(convert(Float64, q), v)

struct Key
    item::AbstractString
    date::Date
end

Key(item::AbstractString, date::DataValue{Any}) = Key(item, get(date))
Key(item::DataValue{Any}, date::DataValue{Any}) = Key(get(item), get(date))
==(k1::Key, k2::Key) = k1.item == k2.item && k1.date == k2.date
<(k1::Key, k2::Key) = k1.item < k2.item || (k1.item == k2.item && k1.date < k2.date)

function qsa(a::AbstractArray{T, 1}) where {T <: Number} 
    v = join(string.(sort(a)), " ")
    length(a) > 1 ? string('"', v, '"') : v
end

function prt(i::AbstractString, d::Any, b::DailyBalance)
    println(join((i, Dates.format(d, "dd/mm/yyyy"), 
        qsa(b.q.i), qsa(b.v.i), qsa(b.q.o), qsa(b.v.o), 
        @sprintf("%.2f", b.q.s), @sprintf("%.2f", b.v.s), 
        @sprintf("%.2f", b.q.f), @sprintf("%.2f", b.v.f)), ",")
    )
end

function calc!(bal::DailyBalance, tipo::AbstractString, qtd::Number, vlr::Number)
    if tipo == "Ent"
        push!(bal.q.i, qtd); push!(bal.v.i, vlr)
        bal.q.f += qtd; bal.v.f += vlr
    elseif tipo == "Sai"
        push!(bal.q.o, qtd); push!(bal.v.o, vlr)
        bal.q.f -= qtd; bal.v.f -= vlr
    end
end

calc!(bal::DailyBalance, tipo::DataValue{Any}, qtd::DataValue{Any}, vlr::DataValue{Any}) = calc!(bal, get(tipo), get(qtd), get(vlr))

@XLSX2DF sld "SaldoITEM"
@XLSX2DF mov "MovtoITEM"

data_min = minimum(sld.data_inicio)
balance = @from s in eachrow(sld) begin
    @where s.data_inicio == data_min
    @select Key(s.item, s.data_inicio) => DailyBalance(s.qtd_inicio, s.valor_inicio)
    @collect Dict{Key, DailyBalance}
end

last_dt = data_min

items = CategoricalArrays.levels(mov.item); sort!(items)

for item in items
    global last_dt = data_min
    for i in (mov |> @filter(_.item == item) |> @orderby(_.data_lancamento) |> collect)
        key = Key(i.item, i.data_lancamento)
        if i.data_lancamento != last_dt
            last_key = Key(item, last_dt)
            last_balance = balance[last_key]
            balance[key] = DailyBalance(last_balance.q.f, last_balance.v.f)
        end
        calc!(balance[key], i.tipo_movimento, i.quantidade, i.valor)
        global last_dt = i.data_lancamento
    end
end

for date in sort(CategoricalArrays.levels(mov.data_lancamento))
    for item in items
        if haskey(balance, Key(item, date))
            prt(item, date, balance[Key(item, date)])
        end
    end
end

# eof