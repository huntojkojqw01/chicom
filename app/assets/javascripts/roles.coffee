$(document).on 'turbolinks:load', () ->
  push_data_to_form = (columns) ->    
    $('#role_code').val(columns[1])
    $('#role_name').val(columns[2])
    $('#role_rank').val(columns[3])
  if($('#roles').length > 0)
    $('body').createTableForModel('role', push_data_to_form)
  else
    console.log('Role Table not found.') 