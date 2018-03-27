/* global apex */
window.mho = window.mho || {}
;(function (namespace) {
  // Create a copy of the original dialog function because we need to change it
  var gDialogOrig = apex.navigation.dialog.prototype['constructor']

  // Create copy of dialog members
  var gDialogMembers = Object.keys(apex.navigation.dialog).map(function (member) {
    return {
      name: member,
      object: apex.navigation.dialog[member]
    }
  })

  // Change the triggering element in the dialog function
  function _replaceDialogCode (da) {

    // Replace dialog function
    apex.navigation.dialog = function () {
      // Create an array of all arguments
      var args = Array.prototype.slice.call(arguments)

      // Currently third argument is always triggering element
      args[3] = da.triggeringElement
      gDialogOrig.apply(null, args)
    }
    // Re-attach dialog members
    gDialogMembers.forEach(function (member) {
      apex.navigation.dialog[member.name] = member.object
    })
  }

  // Reset the dialog function to the orinal one
  function _resetDialogCode () {
    setTimeout(function () {
      apex.navigation.dialog = gDialogOrig
    })
  }

  function redirect (da, url, newWindow) {
    if (newWindow === true) {
      // Dialogs will never be opened in a new window right?
      apex.navigation.openInNewWindow(url)
    } else {
      // Override the dialog code
      _replaceDialogCode(da)

      // Execute redirection
      apex.navigation.redirect(url)

      // And replace with original dialog code again
      _resetDialogCode()
    }
  }

  function ajaxRedirect (options) {
    var requestData = {}

    // Add page items to submit to request
    if (options.itemsToSubmit) {
      requestData.pageItems = options.itemsToSubmit
    }

    // Start AJAX
    var promise = apex.server.plugin(options.ajaxIdentifier, requestData)

    // Redirect after AJAX
    promise.done(function (data) {
      redirect(options.da, data.url, options.newWindow)
      apex.da.resume(options.da.resumeCallback, false)
    })
  }

  // Add functions to namespace
  namespace.navigation = {
    redirect: redirect,
    ajaxRedirect: ajaxRedirect
  }
})(window.mho)
