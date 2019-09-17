local client = require('http.client')
local json = require('json')
local tap = require('tap')

local conf = require('conf')
local kv_db = require('app.model').kv
local request_count_db = require('app.model').request_count


local test = tap.test('Test DELETE operations')
local case = {}

function case.before() end
function case.after()
    kv_db.get_space():truncate()
    request_count_db.get_space():truncate()
end

function test_remove_key()
    local key, value = 'test_key', json.encode({a = 1, b = 2, c = '3'})
    kv_db.get_space():insert({key, value})
    local r = client.delete(conf.TESTING_APP_URL .. key)
    test:is(r.status, 204, 'get status 204 for deleting key')
    test:is(#kv_db.get_space():select({key}), 0, 'key was deleted')
end

function test_remove_unknown_key()
    local r = client.delete(conf.TESTING_APP_URL .. 'test_key')
    test:is(r.status, 404, 'get status 404 for deleting unknown key')
end

case.tests = {
    test_remove_key,
    test_remove_unknown_key,
}

return case
