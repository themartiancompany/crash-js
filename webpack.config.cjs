const
  _path =
    require(
      'path');
const
  _output_dir =
    _path.resolve(
      __dirname);
const
  _input_file_name =
    "crash-js";
const
  _output_file_name =
    `${_input_file_name}.js`;
const
  _input_file_path =
    `./${_input_file_name}/${_input_file_name}`;
const
  _node_fs_ignore =
  { resourceRegExp:
      /^node:fs$/ };
const
  _yargs_ignore =
  { resourceRegExp:
      /^yargs$/ };
const
  _yargs_helpers_ignore = {
    resourceRegExp:
      /^yargs\/helpers$/
};
const
  _webpack =
    require(
     "webpack");
const
  _ignore_plugin =
    _webpack.IgnorePlugin; 
const
  _node_fs_ignore_plugin =
    new _ignore_plugin(
          _node_fs_ignore);
const
  _yargs_ignore_plugin =
    new _ignore_plugin(
          _yargs_ignore);
const
  _yargs_helpers_ignore_plugin =
    new _ignore_plugin(
          _yargs_helpers_ignore);
const
  _output =
  { path:
      _output_dir,
    filename:
      _output_file_name };
module.exports = {
  entry:
    _input_file_path,
  output:
    _output,
  optimization: {
    moduleIds: 'deterministic',
  },
  resolve: {
    alias: {
      "path":
        _path.resolve(
          __dirname,
          'node_modules/path/mod.js'),
      "web-worker":
        _path.resolve(
          __dirname,
          'node_modules/web-worker/dist/browser/index.cjs'),
    },
    fallback: {
      "node:fs":
        false,
      "utils":
        false
    },
  },
  externals:
    { yargs:
        'yargs' },
  plugins: [
    _node_fs_ignore_plugin,
    _yargs_ignore_plugin,
    _yargs_helpers_ignore_plugin
  ]
};
