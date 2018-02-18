$(document).on 'turbolinks:load', () ->
  push_data_to_form = (columns) ->    
    $('#shozoku_code').val(columns[1])
    $('#shozoku_name').val(columns[2])
  if($('#shozokus').length > 0)
    $('body').createTableForModel('shozoku', push_data_to_form)
  else
    console.log('Shozoku Table not found.') 