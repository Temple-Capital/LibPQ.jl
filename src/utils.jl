"""
    @logthrow err

Log `err` at the error level, then throw it.
"""
macro logthrow(err)
    return quote
        local e = $(esc(err))
        @error sprint(showerror, e) _file = $(String(__source__.file)) _line = $(
            __source__.line
        )
        throw(e)
    end
end

"""
    unsafe_string_or_null(ptr::Cstring) -> Union{String, Missing}

Convert a `Cstring` to a `Union{String, Missing}`, returning `missing` if the pointer is
`C_NULL`.
"""
function unsafe_string_or_null(ptr::Cstring)::Union{String, Missing}
    ptr == C_NULL ? missing : unsafe_string(ptr)
end
