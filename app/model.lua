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


-- Model storing requests count for ip and ts
local request_count = {
    space_name = conf.APP_REQUEST_COUNT_SPACE,
    model = {
        ip = 1,
        ts = 2,
        cnt = 3,
    },
}

function request_count.create_db()
    local space = box.schema.space.create(request_count.space_name, {
        if_not_exists = true,
        temporary = true,
    })
    space:create_index('primary', {
        type = 'hash',
        parts = {request_count.model.ip, 'string', request_count.model.ts, 'unsigned'},
        if_not_exists = true,
    })
end

function request_count.get_space()
    return box.space[request_count.space_name]
end


return {
    kv = kv,
    request_count = request_count,
}
