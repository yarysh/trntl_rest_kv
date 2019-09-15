#!/usr/bin/env tarantool

require('strict').on()

conf = require('conf')

box.cfg {
    log = conf.BOX_LOG,
    feedback_enabled = conf.BOX_FEEDBACK_ENABLED,
}

require('app.server'):start()
