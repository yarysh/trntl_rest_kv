local client = require('http.client')
local json = require('json')
local tap = require('tap')

local conf = require('conf')
local controller = require('app.controller')
local model = require('app.model')
local server = require('app.server')


local test = tap.test('Test GET operations')
local case = {}

function case.before() end
function case.after()
    model.kv.get_space():truncate()
end

function test_requests_limit()
    local key = 'test_limited_key'
    server:route({path = '/kv/' .. key, method = 'GET'}, limited_rps(controller.get, 1))
    client.get(conf.TESTING_APP_URL .. key)
    local r = client.get(conf.TESTING_APP_URL .. key)
    test:is(r.status, 429, 'get status 429 for requests limit')
end

function test_get_key()
    local key, value = 'test_key', json.encode({a = 1, b = 2, c = '3'})
    model.kv.get_space():insert({key, value})
    local r = client.get(conf.TESTING_APP_URL .. key)
    test:is(r.status, 200, 'get status 200 for key')
    test:is(json.decode(r.body), value, 'get correct value for key')
end

function test_get_unknown_key()
    local r = client.get(conf.TESTING_APP_URL .. 'test_key')
    test:is(r.status, 404, 'get status 404 for unknown key')
end

case.tests = {
    test_requests_limit,
    test_get_key,
    test_get_unknown_key,
}

return case
