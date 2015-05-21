bitState = require 'bit-state'

schedule = (method) ->
  dictUnitSeconds = { seconds: 1, minutes: 60, hours: 3600 }
  shouldRun       = bitState()

  convertToNumberAndUnits = (str) ->
    (if str.match /^\d/ then str else "1 #{str}s").split /\s/

  convertToMs = (strInterval) ->
    [ nb, unit ] = convertToNumberAndUnits(strInterval)
    +nb * 1000 * dictUnitSeconds[unit]

  repeat = (strInterval) ->
    method() if shouldRun.is(true)
    every(strInterval)

  every = (str) -> setTimeout (-> repeat str), convertToMs str
  chain = (method) -> (args...) -> method(args...); @

  pause: chain(shouldRun.no)
  resume: chain(shouldRun.yes)
  every: chain(every)

if exports?
  if module?.exports?
    exports = module.exports = schedule
  exports.schedule = schedule
else
  root.schedule = schedule

