local client = require('http.client')
local json = require('json')
local tap = require('tap')

local conf = require('conf')
local kv_db = require('app.model').kv
local request_count_db = require('app.model').request_count


local test = tap.test('Test PUT operations')
local case = {}

function case.before() end
function case.after()
    kv_db.get_space():truncate()
    request_count_db:get_space():truncate()
end

function test_edit_record()
    local key, value, new_value = 'test_key', {a = 1, b = '2'}, {a = 2, b = '3', c = 4}
    kv_db.get_space():insert({key, value})
    local r = client.put(conf.TESTING_APP_URL .. key, json.encode({value = new_value}))
    test:is(r.status, 204, 'get status 204 for update record')
    test:is_deeply(kv_db.get_space():select({key})[1][kv_db.model.value], json.encode(new_value), 'valid record exists after put')
end

function test_edit_record_with_invalid_body()
    local key, value, new_value = 'test_key', {a = 1, b = '2'}, '1'
    kv_db.get_space():insert({key, value})
    local r = client.put(conf.TESTING_APP_URL .. key, json.encode({value = new_value}))
    test:is(r.status, 400, 'get status 400 for update record with invalid body')
    test:is_deeply(kv_db.get_space():select({key})[1][kv_db.model.value], value, 'valid record after trying update with invalid body')
end

function test_edit_unknown_key()
    local key = 'test_key'
    local r = client.post(conf.TESTING_APP_URL .. key, json.encode({value = {b = 2}}))
    test:is(r.status, 404, 'get status 404 for update unknown key')
end

case.tests = {
    test_edit_record,
    test_edit_record_with_invalid_body,
    test_edit_unknown_key,
}

return case
