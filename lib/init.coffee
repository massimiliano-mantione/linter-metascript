path = require 'path'

module.exports =
  configDefaults:
    mjsExecutablePath: path.join __dirname, '..', 'node_modules', 'meta-script', 'bin'

  activate: ->
    console.log 'activate linter-jshint'
