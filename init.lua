#!/usr/bin/env tarantool

require('strict').on()


local conf = require('conf')
local model = require('app.model')


local app_mode = require('os').getenv('APP_MODE')

box.cfg {
    log = conf.BOX_LOG,
    feedback_enabled = conf.BOX_FEEDBACK_ENABLED,
}

local once_key = 'init'
if app_mode ~= nil and app_mode ~= '' then
    once_key = string.format('%s_%s', once_key, app_mode:lower())
end
box.once(once_key, function ()
    model.kv.create_db()
    model.last_request.create_db()
end)

require('app.server'):start()
