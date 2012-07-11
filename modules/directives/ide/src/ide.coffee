###
 Ace Editor in your browser!
 Code Mirror coming soon!
 
 @example <div ace syntax="'json'" ng-model="current_object.text"></div> // must have explicit width
 @author nickretallack 
 @link https://github.com/nickretallack/Visual-Language/blob/master/stuff.coffee
 @param syntax {expression} the syntax language (must evaluate to a string that matches the filename of the IDE mode) json|js|html|css|etc
 @param ngModel {expression} the model to store the results into
###
angular.module('ui.directives').directive 'uiIde', ['ui.config', (uiConfig)->
    options = {};
    if uiConfig.ide?
      angular.extend(options, uiConfig.ide)

    require: '?ngModel'
    link:(scope, element, attributes, ngModel) ->
        opts = angular.extend({}, options, scope.$eval(attrs.uiIde));

        # set up ace
        editor = ace.edit element[0]
        session = editor.getSession()

        syntax = scope.$eval attributes.syntax

        # Set the theme
        if syntax and syntax isnt 'plain'
            JavaScriptMode = require("ace/mode/#{syntax}").Mode
            session.setMode new JavaScriptMode()

        # set up data binding
        return unless ngModel

        changing = false
        ngModel.$render = ->
            changing = true
            session.setValue ngModel.$viewValue or ''
            changing = false

        read = -> ngModel.$setViewValue session.getValue()
        session.on 'change', -> scope.$apply read unless changing
]