local client = require('http.client')
local json = require('json')
local tap = require('tap')

local conf = require('conf')
local model = require('app.model')


local test = tap.test('Test POST operations')
local case = {}

function case.before() end
function case.after()
    model.kv.get_space():truncate()
    model.request_count:get_space():truncate()
end

function test_create_record()
    local key, value = 'test_key', {a = 1, b = '2'}
    local r = client.post(conf.TESTING_APP_URL, json.encode({key = key, value = value}))
    test:is(r.status, 201, 'get status 201 for created record')
    test:is(model.kv.get_space():select({key})[1][model.kv.model.value], json.encode(value), 'valid record exists after post')
end

function test_create_record_with_invalid_body()
    local r = client.post(conf.TESTING_APP_URL, '1')
    test:is(r.status, 400, 'get status 400 for post with invalid body')
end

function test_create_record_with_duplicate_key()
    local key = 'test_key'
    model.kv.get_space():insert({key, json.encode({a = 1})})
    local r = client.post(conf.TESTING_APP_URL, json.encode({key = key, value = {b = 2}}))
    test:is(r.status, 409, 'get status 409 for post with duplicate key')
end

case.tests = {
    test_create_record,
    test_create_record_with_invalid_body,
    test_create_record_with_duplicate_key,
}

return case
