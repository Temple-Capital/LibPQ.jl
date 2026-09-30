module LibPQInfinityExt

using Dates
using Infinity: InfExtendedTime, isposinf, ∞
using LibPQ: LibPQ, pqparse, string_parameter

# InfExtendedTime support for Dates.TimeType
function LibPQ.pqparse(
    ::Type{InfExtendedTime{T}}, str::AbstractString
) where {T<:Dates.TimeType}
    if str == "infinity"
        return InfExtendedTime{T}(∞)
    elseif str == "-infinity"
        return InfExtendedTime{T}(-∞)
    end

    return InfExtendedTime{T}(pqparse(T, str))
end

function LibPQ.pqparse(
    ::Type{InfExtendedTime{T}}, ptr::Ptr{UInt8}
) where {T<:Dates.AbstractDateTime}
    microseconds = ntoh(unsafe_load(Ptr{Int64}(ptr)))
    if microseconds == typemax(Int64)
        return InfExtendedTime{T}(∞)
    elseif microseconds == typemin(Int64)
        return InfExtendedTime{T}(-∞)
    end

    return InfExtendedTime{T}(pqparse(T, ptr))
end

function LibPQ.pqparse(::Type{InfExtendedTime{T}}, ptr::Ptr{UInt8}) where {T<:Date}
    microseconds = ntoh(unsafe_load(Ptr{Int32}(ptr)))
    if microseconds == typemax(Int32)
        return InfExtendedTime{T}(∞)
    elseif microseconds == typemin(Int32)
        return InfExtendedTime{T}(-∞)
    end

    return InfExtendedTime{T}(pqparse(T, ptr))
end

function LibPQ.string_parameter(parameter::InfExtendedTime{T}) where {T<:Dates.TimeType}
    if isinf(parameter)
        return isposinf(parameter) ? "infinity" : "-infinity"
    else
        return string_parameter(parameter.finitevalue)
    end
end

end
