local kv = require('app.model').kv


function get(req)
    local rows = kv.get_space():select({req:stash('id')})
    local resp
    if #rows ~= 0 then
        resp = req:render({json = rows[1][kv.model.value]})
        resp.status = 200
    else
        resp = req:render({text = 'No such key'})
        resp.status = 404
    end
    return resp;
end

function post(req)
    local resp = req:render({json = {method = 'POST'}})
    resp.status = 200
    return resp
end

function put(req)
    local id = req:stash('id')
    local resp = req:render({json = {method = 'PUT', id = id}})
    resp.status = 200
    return resp
end

function delete(req)
    local id = req:stash('id')
    local resp = req:render({json = {method = 'DELETE', id = id}})
    resp.status = 200
    return resp
end

return {
    get = get,
    post = post,
    put = put,
    delete = delete
}
