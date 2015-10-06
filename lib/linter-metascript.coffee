path = require 'path'
{CompositeDisposable} = require 'atom'
metaScript = require 'meta-script'

makeRange = (location) ->
  lineStart = location.line - 1
  colStart = location.column
  lineEnd = location.lineTo - 1
  colEnd = location.columnTo
  [ [lineStart, colStart], [lineEnd, colEnd] ]

makeError = (filePath, range, message) ->
  type: 'error'
  filePath: filePath
  range: range
  text: message

checkFile = (filePath, fileText) ->
  try
    mjs = metaScript()
    compiler = mjs.compilerFromString(fileText, filePath)
    ast = compiler.produceAst()
    compiler.errors.map (e) ->
      makeError(filePath, makeRange(e), e.message)
  catch ex
    console.warn '[Linter-Metascript] error while linting file'
    console.warn ex.message
    console.warn ex.stack
    [makeError(filePath, [[1, 0], [1, 0]], 'Error while linting: ' + ex.message)]

module.exports =
  config:
    mjsExecutablePath:
      type: 'string'
      default: path.join __dirname, '..', 'node_modules', 'meta-script', 'bin'

  activate: ->
    require('atom-package-deps').install('linter-metascript')
    console.log 'activate linter-metascript'
    @executablePath = atom.config.get 'linter-metascript.mjsExecutablePath'
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.config.observe \
     'linter-shellcheck.shellcheckExecutablePath',
      (executablePath) =>
        @executablePath = executablePath

  deactivate: ->
    @subscriptions.dispose()

  provideLinter: ->
    provider =
      name: 'Metascript Linter'
      grammarScopes: ['source.metascript']
      scope: 'file'
      lintOnFly: true
      lint: (textEditor) ->
        filePath = textEditor.getPath()
        fileText = textEditor.getText()
        checkFile(filePath, fileText)
