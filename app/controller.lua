local json = require('json')

local kv_db = require('app.model').kv


function get(req)
    local resp
    local rows = kv_db.get_space():select({req:stash('id')})
    if #rows ~= 0 then
        resp = req:render({json = json.decode(rows[1][kv_db.model.value])})
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

    if #kv_db.get_space():select({key}) ~= 0 then
        resp = req:render({text = 'Key already exists'})
        resp.status = 409
        return resp
    end

    kv_db.get_space():insert({key, value})
    resp = req:render({json = {key = key, value = data.value}})
    resp.status = 201
    return resp
end

function put(req)
    local resp
    local key = req:stash('id')

    local rows = kv_db.get_space():select({key})
    if  #rows == 0 then
        resp = req:render({text = 'No such key'})
        resp.status = 404
        return resp
    end

    local success, data = pcall(function () return req:json() end)
    if not success or type(data) ~= 'table' then
        resp = req:render({text = 'Invalid request body'})
        resp.status = 400
        return resp
    end

    local value
    if type(data.value) == 'table' then
        value = json.encode(data.value)
    end
    if not value then
        resp = req:render({text = 'Invalid request body'})
        resp.status = 400
        return resp
    end

    kv_db.get_space():update({key}, {{'=', kv_db.model.value, value}})
    resp = req:render({text = ''})
    resp.status = 204
    return resp
end

function delete(req)
    local resp
    local key = req:stash('id')
    local rows = kv_db.get_space():select({key})
    if #rows ~= 0 then
        kv_db.get_space():delete(key)
        resp = req:render({text = ''})
        resp.status = 204
    else
        resp = req:render({text = 'No such key'})
        resp.status = 404
    end
    return resp;
end

return {
    get = get,
    post = post,
    put = put,
    delete = delete
}
