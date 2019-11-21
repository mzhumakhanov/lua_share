-- function compares two tables by contents
function __deepcompare(t1, t2, ignore_mt)
    local ty1 = type(t1)
    local ty2 = type(t2)
    if ty1 ~= ty2 then return false end
    if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
    local mt = getmetatable(t1)
    if not ignore_mt and mt and mt.__eq then return t1 == t2 end
    for k1,v1 in pairs(t1) do
        local v2 = t2[k1]
        if v2 == nil or not __deepcompare(v1, v2) then return false end
    end
    for k2,v2 in pairs(t2) do
        local v1 = t1[k2]
        if v1 == nil or not __deepcompare(v1, v2) then return false end
    end
    return true
end

-- function finds the key in table and returns an original key
function __findkey(t, k)
    if type(t) ~= 'table' or type(k) ~= 'table' then return nil end
    for idx,val in pairs(t) do
        if type(idx) == "table" then
            if __deepcompare(idx, k) then return idx end
        end
    end
    return nil
end

-- dataspace metatable implemantation
-- assume that self.__data is a container for actual table data
__default_namespace_metatable = {
    __newindex = function(self, key, value)
--        MessageBox('__newindex()')  -- show debug message
        if type(key)~="table" then
            self.__data[key] = value
        else
            local idx = __findkey(self.__data, key)
            if idx then
                self.__data[idx] = value
            else
                self.__data[key] = value
            end
        end
    end,

    __index = function(self, key)
--        MessageBox('__index()')     -- show debug message
        if type(key)~="table" then
            return self.__data[key]
        else
            local idx = __findkey(self.__data, key)
            if idx then return self.__data[idx] end
        end
        return nil
    end
}