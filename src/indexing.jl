# Scalar indexing (and related) conversion helpers

@propagate_inbounds function Base.getindex(d::AbstractDictionary{I}, i) where {I}
	return d[convert(I, i)]
end

@propagate_inbounds function Base.setindex!(d::AbstractDictionary{I}, v, i) where {I}
    # Should we do a `isequal` check here?
    return setindex!(d, v, convert(I, i))
end

@propagate_inbounds function Base.setindex!(d::AbstractDictionary{I, T}, v, i::I) where {I, T}
    return setindex!(d, convert(v, T), i)
end

# Non-scalar indexing

# Basically, one maps the indices over the indexee
@inline function Indexing.getindices(d, inds::AbstractDictionary)
    @boundscheck checkindices(keys(d), inds)
    map(i -> @inbounds(d[i]), inds)
end

@inline function Indexing.setindices!(d, value, inds::AbstractDictionary)
    @boundscheck checkindices(keys(d), inds)
    map(i -> @inbounds(d[i] = value), inds)
end

#@inline function Base.view()

#function Base.checkindices(target_inds, inds::AbstractDictionary)
#    for i in inds
#        if !(i ∈ target_inds)
#            throw(IndexError("Index not found: $i"))
#        end
#    end
#end