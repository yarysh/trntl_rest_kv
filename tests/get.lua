local client = require('http.client')
local json = require('json')
local tap = require('tap')

local conf = require('conf')
local model = require('app.model')


local test = tap.test('Test GET operations')
local case = {}

function case.before() end
function case.after()
    model.kv.get_space():truncate()
end

function test_get_key()
    local key, value = 'test_key', {a = 1, b = 2, c = '3'}
    model.kv.get_space():insert({key, json.encode(value)})
    local r = client.get(conf.TESTING_APP_URL .. key)
    test:is(r.status, 200, 'get status 200 for key')
    test:is(json.decode(r.body), value, 'get correct value for key')
end

function test_get_unknown_key()
    local r = client.get(conf.TESTING_APP_URL .. '1')
    test:is(r.status, 404, 'get status 404 for unknown key')
end

case.tests = {
    test_get_key,
    test_get_unknown_key,
}

return case
