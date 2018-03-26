prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2016.08.24'
,p_release=>'5.1.4.00.08'
,p_default_workspace_id=>10390063953384733491
,p_default_application_id=>115922
,p_default_owner=>'CITIEST'
);
end;
/
prompt --application/shared_components/plugins/dynamic_action/mho_redirect
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(56584075706020401362)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'MHO.REDIRECT'
,p_display_name=>'Redirect'
,p_category=>'NAVIGATION'
,p_supported_ui_types=>'DESKTOP'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'subtype t_url_type is varchar2(10);',
'',
'c_url_static                    constant t_url_type := ''static'';',
'c_url_plsql_expression          constant t_url_type := ''plsql'';',
'',
'------------------------------------------------------------------------------',
'-- function get_static_url',
'------------------------------------------------------------------------------  ',
'function get_static_url (',
'  p_static_url varchar2',
') return varchar2',
'is',
'',
'  l_url varchar2(32000);',
'',
'begin',
'',
'  l_url := apex_plugin_util.replace_substitutions(p_static_url);',
'  ',
'  l_url := apex_util.prepare_url(',
'    p_url           => l_url',
'  , p_checksum_type => ''SESSION''',
'  );',
'     ',
'  return l_url;',
'',
'end get_static_url;',
'',
'------------------------------------------------------------------------------',
'-- function get_url_via_plsql_expression',
'------------------------------------------------------------------------------',
'function get_url_via_plsql_expression (',
'  p_plsql_expression varchar2',
') return varchar2',
'is',
'begin',
'',
'  return apex_plugin_util.get_plsql_expression_result(p_plsql_expression);',
'',
'end get_url_via_plsql_expression;',
'',
'',
'------------------------------------------------------------------------------',
'-- function get_js_function',
'------------------------------------------------------------------------------',
'function get_js_function(',
'  p_static_url        varchar2',
', p_replace_on_exec   varchar2',
') return varchar2',
'',
'is',
'',
'  l_js  varchar2(4000);',
'',
'begin',
'',
'  if p_replace_on_exec = ''Y'' then',
'      ',
'    l_js :=',
'      q''[function() {',
'        mho.navigation.ajaxRedirect({',
'          da: this,',
'          itemsToSubmit: "#ITEMS_TO_SUBMIT#",',
'          ajaxIdentifier: "#AJAX_IDENTIFIER#",',
'          newWindow: #NEW_WINDOW#',
'        });',
'      }]'';',
'      ',
'  else',
'',
'    l_js := ''function() { mho.navigation.redirect("'' || get_static_url(p_static_url) || ''", #NEW_WINDOW#); }'';',
'  ',
'  end if;',
'  ',
'  return l_js;',
'  ',
'end get_js_function;',
'',
'------------------------------------------------------------------------------',
'-- function get_js_function',
'------------------------------------------------------------------------------',
'function get_js_function (',
'  p_plsql_expression  varchar2',
') return varchar2',
'is',
'',
'  l_js  varchar2(4000);',
'  ',
'begin',
'',
'  l_js :=',
'    q''[function() {',
'      mho.navigation.ajaxRedirect({',
'        da: this,',
'        itemsToSubmit: "#ITEMS_TO_SUBMIT#",',
'        ajaxIdentifier: "#AJAX_IDENTIFIER#",',
'        newWindow: #NEW_WINDOW#',
'      });',
'    }]'';',
'  ',
'  return l_js;',
'',
'end get_js_function;',
'',
'------------------------------------------------------------------------------',
'-- function render',
'------------------------------------------------------------------------------',
'function render(p_dynamic_action in apex_plugin.t_dynamic_action',
'               ,p_plugin         in apex_plugin.t_plugin) return apex_plugin.t_dynamic_action_render_result',
'is',
'  l_js                  varchar2(4000); ',
'  l_items_to_submit     varchar2(4000);',
'  ',
'  l_url_type            apex_application_page_items.attribute_01%type := p_dynamic_action.attribute_01;',
'  l_static_url          apex_application_page_items.attribute_02%type := p_dynamic_action.attribute_02;',
'  l_plsql_expression    apex_application_page_items.attribute_03%type := p_dynamic_action.attribute_03;',
'  l_replace_on_exec     apex_application_page_items.attribute_04%type := p_dynamic_action.attribute_04;',
'  l_items_to_submit1    apex_application_page_items.attribute_05%type := p_dynamic_action.attribute_05;',
'  l_items_to_submit2    apex_application_page_items.attribute_06%type := p_dynamic_action.attribute_06;',
'  l_new_window          apex_application_page_items.attribute_07%type := p_dynamic_action.attribute_07;',
'  ',
'  l_result              apex_plugin.t_dynamic_action_render_result;',
'  ',
'begin',
'',
'  apex_plugin_util.debug_dynamic_action(p_plugin         => p_plugin',
'                                       ,p_dynamic_action => p_dynamic_action);',
'                                                                    ',
'  apex_javascript.add_library (',
'    p_name                    => ''apexNavigation#MIN#''',
'  , p_directory               => p_plugin.file_prefix',
'  , p_check_to_add_minified   => false',
'  ); ',
'',
'  l_js :=  ',
'    case l_url_type ',
'      when c_url_static then get_js_function(p_static_url => l_static_url, p_replace_on_exec => l_replace_on_exec)',
'      when c_url_plsql_expression then get_js_function(p_plsql_expression => l_plsql_expression)',
'    end;',
'',
'  l_items_to_submit :=  ',
'    case l_url_type ',
'      when c_url_static then l_items_to_submit1',
'      when c_url_plsql_expression then l_items_to_submit2',
'    end;',
'',
'  l_js := replace(l_js,''#ITEMS_TO_SUBMIT#'', apex_plugin_util.page_item_names_to_jquery(l_items_to_submit));',
'  l_js := replace(l_js,''#AJAX_IDENTIFIER#'', apex_plugin.get_ajax_identifier);',
'  l_js := replace(l_js,''#NEW_WINDOW#'', case when l_new_window = ''Y'' then ''true'' else ''false'' end);',
'',
'  l_result.javascript_function := l_js;',
'  ',
'  return l_result;',
'  ',
'end render;',
'',
'------------------------------------------------------------------------------',
'-- function ajax',
'------------------------------------------------------------------------------',
'function ajax(p_dynamic_action in apex_plugin.t_dynamic_action',
'             ,p_plugin         in apex_plugin.t_plugin) return apex_plugin.t_dynamic_action_ajax_result',
'is',
'',
'  l_url                 varchar2(32000);',
'  ',
'  l_url_type            apex_application_page_items.attribute_01%type := p_dynamic_action.attribute_01;',
'  l_static_url          apex_application_page_items.attribute_02%type := p_dynamic_action.attribute_02;',
'  l_plsql_expression    apex_application_page_items.attribute_03%type := p_dynamic_action.attribute_03;',
'  l_replace_on_exec     apex_application_page_items.attribute_04%type := p_dynamic_action.attribute_04;',
'  ',
'  ',
'  l_result              apex_plugin.t_dynamic_action_ajax_result;',
'',
'begin',
'',
'  l_url := ',
'    case l_url_type',
'      when c_url_static then get_static_url(l_static_url)',
'      when c_url_plsql_expression then get_url_via_plsql_expression(l_plsql_expression)',
'    end;',
'',
'  htp.prn(''{"url" : "'' || l_url || ''"}'');',
'',
'  return l_result;',
'    ',
'end ajax;'))
,p_api_version=>2
,p_render_function=>'render'
,p_ajax_function=>'ajax'
,p_standard_attributes=>'WAIT_FOR_RESULT'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.0'
,p_files_version=>7
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(56586483837894523532)
,p_plugin_id=>wwv_flow_api.id(56584075706020401362)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'URL Source'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'static'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(56586497440782531646)
,p_plugin_attribute_id=>wwv_flow_api.id(56586483837894523532)
,p_display_sequence=>10
,p_display_value=>'Static Value'
,p_return_value=>'static'
,p_help_text=>'Defines the URL in the plugin attributes'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(56586500081016534685)
,p_plugin_attribute_id=>wwv_flow_api.id(56586483837894523532)
,p_display_sequence=>20
,p_display_value=>'PL/SQL expression'
,p_return_value=>'plsql'
,p_help_text=>'Define the URL in a PL/SQL expression'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(56587688273322559014)
,p_plugin_id=>wwv_flow_api.id(56584075706020401362)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Target'
,p_attribute_type=>'LINK'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(56586483837894523532)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'static'
,p_help_text=>'The target URL to redirect to'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(56588187269756575835)
,p_plugin_id=>wwv_flow_api.id(56584075706020401362)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'PL/SQL Expression'
,p_attribute_type=>'PLSQL EXPRESSION'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(56586483837894523532)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'plsql'
,p_examples=>'apex_page.get_url(p_page => 1);'
,p_help_text=>'A PL/SQL Expression that returns a URL.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(56588860738970371959)
,p_plugin_id=>wwv_flow_api.id(56584075706020401362)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Update session state before redirect'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(56586483837894523532)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'static'
,p_help_text=>'Submit the items specified in the target before redirection. This way you get a URL including a checksum for items that have been changed by the user.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(56589497839846603777)
,p_plugin_id=>wwv_flow_api.id(56584075706020401362)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Items to Submit'
,p_attribute_type=>'PAGE ITEMS'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(56588860738970371959)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>'Enter page or application items to be set into session state before getting the URL for redirection. For multiple items, separate each item name with a comma. You can type in the name or pick from the list of available items. If you pick from the lis'
||'t and there is already text entered, then a comma is placed at the end of the existing text, followed by the item name returned from the list.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(56604403389958943909)
,p_plugin_id=>wwv_flow_api.id(56584075706020401362)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Items to Submit'
,p_attribute_type=>'PAGE ITEMS'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(56586483837894523532)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'plsql'
,p_help_text=>'Enter page or application items to be set into session state before getting the URL for redirection. For multiple items, separate each item name with a comma. You can type in the name or pick from the list of available items. If you pick from the lis'
||'t and there is already text entered, then a comma is placed at the end of the existing text, followed by the item name returned from the list.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(56604487986979950967)
,p_plugin_id=>wwv_flow_api.id(56584075706020401362)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Open target in new window'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A20676C6F62616C2061706578202A2F0D0A77696E646F772E6D686F203D2077696E646F772E6D686F207C7C207B7D0D0A3B2866756E6374696F6E20286E616D65737061636529207B0D0A202066756E6374696F6E207265646972656374202875726C';
wwv_flow_api.g_varchar2_table(2) := '2C206E657757696E646F7729207B0D0A20202020696620286E657757696E646F77203D3D3D207472756529207B0D0A202020202020617065782E6E617669676174696F6E2E6F70656E496E4E657757696E646F772875726C290D0A202020207D20656C73';
wwv_flow_api.g_varchar2_table(3) := '65207B0D0A202020202020617065782E6E617669676174696F6E2E72656469726563742875726C290D0A202020207D0D0A20207D0D0A0D0A202066756E6374696F6E20616A6178526564697265637420286F7074696F6E7329207B0D0A20202020766172';
wwv_flow_api.g_varchar2_table(4) := '207265717565737444617461203D207B7D0D0A0D0A20202020696620286F7074696F6E732E6974656D73546F5375626D697429207B0D0A20202020202072657175657374446174612E706167654974656D73203D206F7074696F6E732E6974656D73546F';
wwv_flow_api.g_varchar2_table(5) := '5375626D69740D0A202020207D0D0A0D0A202020207661722070726F6D697365203D20617065782E7365727665722E706C7567696E286F7074696F6E732E616A61784964656E7469666965722C207265717565737444617461290D0A0D0A202020207072';
wwv_flow_api.g_varchar2_table(6) := '6F6D6973652E646F6E652866756E6374696F6E20286461746129207B0D0A202020202020726564697265637428646174612E75726C2C206F7074696F6E732E6E657757696E646F77290D0A202020202020617065782E64612E726573756D65286F707469';
wwv_flow_api.g_varchar2_table(7) := '6F6E732E64612E726573756D6543616C6C6261636B2C2066616C7365290D0A202020207D290D0A20207D0D0A0D0A20206E616D6573706163652E6E617669676174696F6E203D207B0D0A2020202072656469726563743A2072656469726563742C0D0A20';
wwv_flow_api.g_varchar2_table(8) := '202020616A617852656469726563743A20616A617852656469726563740D0A20207D0D0A7D292877696E646F772E6D686F290D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(56593305881012405266)
,p_plugin_id=>wwv_flow_api.id(56584075706020401362)
,p_file_name=>'apexNavigation.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '77696E646F772E6D686F3D77696E646F772E6D686F7C7C7B7D2C66756E6374696F6E2865297B66756E6374696F6E206928652C69297B693D3D3D21303F617065782E6E617669676174696F6E2E6F70656E496E4E657757696E646F772865293A61706578';
wwv_flow_api.g_varchar2_table(2) := '2E6E617669676174696F6E2E72656469726563742865297D66756E6374696F6E206E2865297B766172206E3D7B7D3B652E6974656D73546F5375626D69742626286E2E706167654974656D733D652E6974656D73546F5375626D6974293B76617220613D';
wwv_flow_api.g_varchar2_table(3) := '617065782E7365727665722E706C7567696E28652E616A61784964656E7469666965722C6E293B612E646F6E652866756E6374696F6E286E297B69286E2E75726C2C652E6E657757696E646F77292C617065782E64612E726573756D6528652E64612E72';
wwv_flow_api.g_varchar2_table(4) := '6573756D6543616C6C6261636B2C2131297D297D652E6E617669676174696F6E3D7B72656469726563743A692C616A617852656469726563743A6E7D7D2877696E646F772E6D686F293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(56593306178258405268)
,p_plugin_id=>wwv_flow_api.id(56584075706020401362)
,p_file_name=>'apexNavigation.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
