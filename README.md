# Oracle APEX Dynamic Action Plug-in: Redirect

This is a plug-in to redirect users with a Dynamic Action.

## Prerequisite
- APEX 5.0 or higher (not tested for older versions)

## Install
- Import plug-in file "dynamic_action_plugin_mho_redirect.sql" from `plugin` directory into your application
- (Optional) Deploy the JS from "server" directory on your webserver and change the "File Prefix" to webservers folder.

## How to use
- Create a dynamic action
- Select the plug-in as the Action and set the attributes

### Attributes
<table>
<tbody><tr>
<td style="font-weight: bold;">URL Source</td><td>Use link builder or PL/SQL process</td>
</tr>
<tr>
<td style="font-weight: bold;">Target</td><td>The url</td>
</tr>
<tr>
<td style="font-weight: bold; padding-right:10px;">Update session state before redirect</td><td>Updates the URL with current session state</td>
</tr>
<tr>
<td style="font-weight: bold;">Items to Submit</td><td>Items to update in session state</td>
</tr>
<tr>
<td style="font-weight: bold;">Open target in new window</td><td>Use current browser window or new one</td>
</tr>
</tbody></table>

## Demo Application
<https://apex.oracle.com/pls/apex/f?p=115922:4>
