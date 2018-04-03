$(document).on 'turbolinks:load', () ->
  push_data_to_form = (columns) ->    
    $('#yakushoku_code').val(columns[1])
    $('#yakushoku_name').val(columns[2])
  if($('#yakushokus').length > 0)
    $('body').createTableForModel('yakushoku', push_data_to_form)
  else
    console.log('Yakushoku Table not found.') 