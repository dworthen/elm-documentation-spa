var webpack = require('webpack');
var argv = require('yargs').argv;

module.exports = {
  context: __dirname,
  entry: './src/index.js',
  devtool: (argv.inline || argv.hot) ? "#eval" : "#source-map",
  output: {
    filename: './docs/assets/index.js'
  },
  plugins: [
      new webpack.optimize.UglifyJsPlugin({compress: {warnings: false}})
  ],
  module: {
    loaders: [
      {
        test: /\.elm$/,
        exclude: [/node_modules/, /elm-stuff/],
        loader: 'elm-hot!elm-webpack',
      },
      {
        test: /\.css$/,
        loader: 'style!css' 
      },
      {
        test: /\.(jpg|png|gif)$/,
        loader: 'url'
      },
      {
        test: /\.woff(\?v=\d+\.\d+\.\d+)?$/,
        loader: "url?mimetype=application/font-woff"
      }, 
      {
        test: /\.woff2(\?v=\d+\.\d+\.\d+)?$/,
        loader: "url?mimetype=application/font-woff"
      }, 
      {
        test: /\.ttf(\?v=\d+\.\d+\.\d+)?$/,
        loader: "url?mimetype=application/octet-stream"
      }, 
      {
        test: /\.eot(\?v=\d+\.\d+\.\d+)?$/,
        loader: "url?mimetype=application/vnd.ms-fontobject"
      }, 
      {
        test: /\.svg(\?v=\d+\.\d+\.\d+)?$/,
        loader: "url?mimetype=image/svg+xml"
      }
    ],
    noParse: /\.elm$/
  }
};