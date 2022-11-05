const path = require('path');
const Dotenv = require('dotenv-webpack');
const CompressionWebpackPlugin = require('compression-webpack-plugin')
const productionGzipExtensions = ['js', 'css']
module.exports = {
  pages: {
    index: {
      // entry for the page
      entry: 'src/main.js',
      title: '통합 API',
    },
  },
  productionSourceMap: false,
  configureWebpack: {
    devtool: 'inline-source-map',
    plugins: [
      new Dotenv({
        path: '.env',
        silent: true
      }),
      new CompressionWebpackPlugin({
        filename: '[path].gz[query]',
        algorithm: 'gzip',
        test: new RegExp('\\.(' + productionGzipExtensions.join('|') + ')$'),
        minRatio: 0.8
      })
    ],
    output: {
      filename: 'js/[name].[hash:8].js',
      chunkFilename: 'js/[name].[hash:8].js',
      sourceMapFilename: "js/[name].[hash:8].js.map"
    },
  },
  devServer: {
    host: '0.0.0.0',
    public: '0.0.0.0' + process.env.VUE_APP_OPEN_WEB_PORT,
    hot: true,
    quiet: true,
    compress: true,
    watchOptions: {
      poll: false,
      ignored: /node_modules/
    },
    disableHostCheck: true,
  },

  transpileDependencies: [
    'vuetify',
    'vuetify-dialog',
  ],
};
