#!/usr/bin/env tarantool

require('strict').on()
local os = require('os')


local TEST_CASES = {
    'tests.get',
}

-- Starting server
os.setenv('APP_MODE', 'testing')
require('init')

-- Running tests
for _, case_name in ipairs(TEST_CASES) do
    local case = require(case_name)
    for i = 1, #case.tests do
        case.before()
        case.tests[i]()
        case.after()
    end
end

os.exit(0)
