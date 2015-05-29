bitState = require 'bit-state'

schedule = (method) ->
  dictUnitSeconds = { seconds: 1, minutes: 60, hours: 3600 }
  shouldRun       = bitState()
  isRunning       = bitState init: false, set_false: "stop", set_true: "start"

  convertToNumberAndUnits = (str) ->
    (if str.match /^\d/ then str else "1 #{str}s").split /\s/

  convertToMs = (strInterval) ->
    [ nb, unit ] = convertToNumberAndUnits(strInterval)
    +nb * 1000 * dictUnitSeconds[unit]

  run = ->
    isRunning.start()
    method isRunning.stop

  repeat = (strInterval) ->
    run() if shouldRun.is(true) and isRunning.is(false)
    every(strInterval)

  every = (str) -> setTimeout (-> repeat str), convertToMs str

  chain = (method) -> (args...) -> method(args...); @

  pause: chain(shouldRun.no)
  resume: chain(shouldRun.yes)
  every: chain(every)
  run: chain(run)

module.exports = schedule

