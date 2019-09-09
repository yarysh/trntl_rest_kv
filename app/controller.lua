function get(req)
    local id = req:stash('id')
    local resp = req:render({text = 'GET - ' .. id})
    return resp
end

function post(req)
    local resp = req:render({text = 'POST'})
    return resp
end

function put(req)
    local id = req:stash('id')
    local resp = req:render({text = 'PUT - ' .. id})
    return resp
end

function delete(req)
    local id = req:stash('id')
    local resp = req:render({text = 'DELETE - ' .. id})
    return resp
end

return {
    get = get,
    post = post,
    put = put,
    delete = delete
}
