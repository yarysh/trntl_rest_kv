local server = require('http.server')

local conf = require('conf')
local controller = require('app.controller')


function limited_rps(handler, rps_limit)
    rps_limit = rps_limit or conf.SERVER_RPS_LIMIT
    return function (req)
        return handler(req)
    end
end

local httpd = server.new(conf.SERVER_HOST, conf.SERVER_PORT)
httpd:route({path = '/kv/:id', method = 'GET'}, limited_rps(controller.get))
httpd:route({path = '/kv', method = 'POST'}, limited_rps(controller.post))
httpd:route({path = '/kv/:id', method = 'PUT'}, limited_rps(controller.put))
httpd:route({path = '/kv/:id', method = 'DELETE'}, limited_rps(controller.delete))

return httpd
