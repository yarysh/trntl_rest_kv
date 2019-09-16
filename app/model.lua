local conf = require('conf')


-- Model for storing key/value
local kv = {
    space_name = conf.APP_KV_SPACE,
    model = {
        key = 1,
        value = 2,
    },
}

function kv.create_db()
    local space = box.schema.space.create(kv.space_name, {
        if_not_exists = true,
    })
    space:create_index('primary', {
        type = 'hash',
        parts = {kv.model.key, 'string'},
        if_not_exists = true,
    })
end

function kv.get_space()
    return box.space[kv.space_name]
end


-- Model for storing last request
local last_request = {
    space_name = conf.APP_LAST_REQUEST_SPACE,
    model = {
        ip = 1,
        ts = 2,
    },
}

function last_request.create_db()
    local space = box.schema.space.create(last_request.space_name, {
        if_not_exists = true,
    })
    space:create_index('primary', {
        type = 'hash',
        parts = {last_request.model.ip, 'string'},
        if_not_exists = true,
    })
end

function last_request.get_space()
    return box.space[last_request.space_name]
end


return {
    kv = kv,
    last_request = last_request,
}
