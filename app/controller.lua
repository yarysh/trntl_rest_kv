local json = require('json')

local kv = require('app.model').kv


function get(req)
    local resp
    local rows = kv.get_space():select({req:stash('id')})
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
    local resp
    local success, data = pcall(function () return req:json() end)
    if not success or type(data) ~= 'table' then
        resp = req:render({text = 'Invalid request body'})
        resp.status = 400
        return resp
    end

    local key, value
    if data.key ~= nil and data.key ~= '' then
        key = tostring(data.key)
    end
    if type(data.value) == 'table' then
        value = json.encode(data.value)
    end
    if not key or not value then
        resp = req:render({text = 'Invalid request body'})
        resp.status = 400
        return resp
    end

    if #kv.get_space():select({key}) ~= 0 then
        resp = req:render({text = 'Key already exists'})
        resp.status = 409
        return resp
    end

    kv.get_space():insert({key, value})
    resp = req:render({json = {key = key, value = data.value}})
    resp.status = 201
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
