local fio = require('fio')
local errno = require('errno')
local log = require('log')
local os = require('os')
local server = require('http.server')

local conf = require('conf')
local controller = require('app.controller')
local request_count = require('app.model').request_count


function operation_logger(req, resp)
    local f = fio.open(conf.SERVER_LOG, {'O_WRONLY', 'O_CREAT', 'O_APPEND'})
    if not f then
        log.error(string.format('Failed to open %s: %s', conf.SERVER_LOG, errno.strerror()))
        return
    end
    local req_body = req:read_cached()
    if req_body == nil or req_body == '' then
        req_body = '-'
    elseif req_body:find('%s') then
        req_body = string.format("'%s'", req_body)
    end
    local resp_body = resp.body
    if resp_body == nil or resp_body == '' then
        resp_body = '-'
    elseif resp_body:find('%s') then
        resp_body = string.format("'%s'", resp_body)
    end
    f:write(string.format(
        "%s %s %s %s %s %s %s %s\n",
        os.date('%Y-%m-%d %H:%M:%S', os.time()),
        req.peer.host,
        '-',
        req.method,
        req.path,
        req_body,
        resp_body,
        resp.status or '-'
    ))
    f:close()
end

function limited_rps(handler, rps_limit)
    rps_limit = rps_limit or conf.SERVER_RPS_LIMIT
    return function (req)
        local ts = os.time()
        local rows = request_count.get_space():select({req.peer.host, ts})
        if #rows ~= 0 and rows[1][request_count.model.cnt] == rps_limit then
            local resp = req:render({text = 'Too Many Requests'})
            resp.status = 429
            return resp
        end
        request_count.get_space():upsert({req.peer.host, ts, 1}, {{'+', request_count.model.cnt, 1}})
        return handler(req)
    end
end

local httpd = server.new(conf.SERVER_HOST, conf.SERVER_PORT, {
    display_errors = conf.SERVER_DISPLAY_ERRORS,
})
httpd:hook('after_dispatch', operation_logger)

httpd:route({path = '/kv/:id', method = 'GET'}, limited_rps(controller.get))
httpd:route({path = '/kv', method = 'POST'}, limited_rps(controller.post))
httpd:route({path = '/kv/:id', method = 'PUT'}, limited_rps(controller.put))
httpd:route({path = '/kv/:id', method = 'DELETE'}, limited_rps(controller.delete))

return httpd
