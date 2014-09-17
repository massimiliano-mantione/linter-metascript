linterPath = atom.packages.getLoadedPackage("linter").path
Linter = require "#{linterPath}/lib/linter"
{warn} = require "#{linterPath}/lib/utils"

packageRootOf = (filename) ->
  {dirname, join} = require 'path'
  {existsSync} = require 'fs'
  prev = undefined
  cur = dir = dirname filename
  while cur != prev
    if (existsSync(join(cur, 'package.json')))
      return cur
    prev = cur
    cur = dirname cur
  dir

# Most of this has bin copied from the linter-jshint atom package.
class LinterMetascript extends Linter
  # The syntax that the linter handles. May be a string or
  # list/tuple of strings. Names should be all lowercase.
  @syntax: ['source.metascript']

  linterName: 'metascript'

  regex:
    '.+?\\((?<line>[0-9]+),(?<col>[0-9]+)\\): (?<message>.+)'

  isNodeExecutable: no

  constructor: (editor) ->
    super(editor)
    file = editor.getBuffer().getPath()
    @cwd = packageRootOf file
    @cmd = ['mjs', 'check', '--name', file]
    atom.config.observe 'linter-metascript.mjsExecutablePath', @formatShellCmd

  formatShellCmd: =>
    mjsExecutablePath = atom.config.get 'linter-metascript.mjsExecutablePath'
    @executablePath = "#{mjsExecutablePath}"

  destroy: ->
    atom.config.unobserve 'linter-metascript.mjsExecutablePath'

module.exports = LinterMetascript
