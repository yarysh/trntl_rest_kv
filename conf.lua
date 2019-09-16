local os = require('os')


local NIL = 'NIL'
function merge_conf(base, extra)
    for k, v in pairs(extra) do
        base[k] = v ~= NIL and v or nil
    end
    return base
end

local base_conf = {
    SERVER_HOST = '0.0.0.0',
    SERVER_PORT = 3000,
    SERVER_RPS_LIMIT = 2,
    SERVER_LOG = '/var/log/server.log',
    SERVER_DISPLAY_ERRORS = false,

    BOX_LOG = '/var/log/box.log',
    BOX_FEEDBACK_ENABLED = false,

    APP_KV_SPACE = 'kv',
    APP_REQUEST_COUNT_SPACE = 'request_count',
}

local dev_conf = {
    SERVER_DISPLAY_ERRORS = true,
    BOX_LOG = NIL,
}

local testing_conf = {
    SERVER_RPS_LIMIT = 10,
    TESTING_APP_URL = 'http://127.0.0.1:3000/kv/',
    APP_KV_SPACE = 'test_kv',
    APP_REQUEST_COUNT_SPACE = 'test_request_count',
}

local app_mode = os.getenv('APP_MODE')
if app_mode == 'dev' then
    return merge_conf(base_conf, dev_conf)
elseif app_mode == 'testing' then
    return merge_conf(base_conf, testing_conf)
else
    return base_conf
end
