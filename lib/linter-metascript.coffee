linterPath = atom.packages.getLoadedPackage("linter").path
Linter = require "#{linterPath}/lib/linter"
{warn} = require "#{linterPath}/lib/utils"

# Most of this has bin copied from the linter-jshint atom package.

class LinterMetascript extends Linter
  # The syntax that the linter handles. May be a string or
  # list/tuple of strings. Names should be all lowercase.
  @syntax: ['source.metascript']

  # A string, list, tuple or callable that returns a string, list or tuple,
  # containing the command line (with arguments) used to lint.
  cmd: ['mjs', 'check']

  linterName: 'metascript'

  # A regex pattern used to extract information from the executable's output.
  regex:
    '.+?\((?<line>[0-9]+),(?<col>[0-9]+)\): , (?<message>.+)'

  isNodeExecutable: no

  constructor: (editor) ->
    super(editor)

    atom.config.observe 'linter-metascript.mjsExecutablePath', @formatShellCmd

  formatShellCmd: =>
    mjsExecutablePath = atom.config.get 'linter-metascript.mjsExecutablePath'
    @executablePath = "#{mjsExecutablePath}"
    console.log 'metascript link exec path: ' + @executablePath

  formatMessage: (match) ->
    msg = match.message || "Regex does not match lint output"
    console.log 'linter message: ' + msg
    msg

  destroy: ->
    atom.config.unobserve 'linter-metascript.mjsExecutablePath'

module.exports = LinterMetascript
