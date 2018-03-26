/* global apex */
window.mho = window.mho || {}
;(function (namespace) {
  function redirect (url, newWindow) {
    if (newWindow === true) {
      apex.navigation.openInNewWindow(url)
    } else {
      apex.navigation.redirect(url)
    }
  }

  function ajaxRedirect (options) {
    var requestData = {}

    if (options.itemsToSubmit) {
      requestData.pageItems = options.itemsToSubmit
    }

    var promise = apex.server.plugin(options.ajaxIdentifier, requestData)

    promise.done(function (data) {
      redirect(data.url, options.newWindow)
      apex.da.resume(options.da.resumeCallback, false)
    })
  }

  namespace.navigation = {
    redirect: redirect,
    ajaxRedirect: ajaxRedirect
  }
})(window.mho)
