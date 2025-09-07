local style = {}
function style.parseStyle(styleStr)
    local styles = {}
    for prop, val in styleStr:gmatch("([%w-]+)%s*:%s*([^;]+)") do
        styles[prop] = val
    end
    return styles
end


return style