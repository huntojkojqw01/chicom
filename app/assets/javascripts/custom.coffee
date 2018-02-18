$.fn.createTableForModel = (model, push_data_to_form_func) ->    
  oTable = $("##{model}s").DataTable({
    "dom": "<'row'<'col-md-6'l><'col-md-6'f>><'row'<'col-md-7'B><'col-md-5'p>><'row'<'col-md-12'tr>><'row'<'col-md-12'i>>",
    
    "pagingType": "simple_numbers",     

    "buttons": [
      {
        extend:    'copyHtml5',
        text:      '<i class="fa fa-files-o"></i>',
        titleAttr: 'Copy'
      },
      {
        extend:    'excelHtml5',
        text:      '<i class="fa fa-file-excel-o"></i>',
        titleAttr: 'Excel'
      },
      {
        extend:    'csvHtml5',
        text:      '<i class="fa fa-file-text-o"></i>',
        titleAttr: 'CSV'
      },
      {
        text: '<i class="fa fa-upload"></i>',
        titleAttr: 'Import',        
        action: ( e, dt, node, config ) ->
          $('#import-csv-modal').modal('show')
      },
      {
        extend: 'selectAll',
        attr: {
          id: 'all'
        }
      },
      {
        extend: 'selectNone',
        attr: {
          id: 'none'
        }      
      },
      {
        text: 'New',        
        attr: {
          id: 'new'
          }        
        action: ( e, dt, node, config ) ->
          if $("##{model}-new-modal").length
            $("##{model}-new-modal").modal('show')
          else
            window.location = "#{model}s/new"
      },
      {
        text: 'Edit',
        attr: {
          id: 'edit',
          class: 'btn btn-secondary disabled'
          }        
        action: ( e, dt, node, config ) ->          
          data_of_selected_row = dt.row('tr.selected').data()
          if $("##{model}-edit-modal").length
            push_data_to_form_func(data_of_selected_row)
            $("##{model}-edit-modal form#edit_#{model}").attr('action', "#{model}s/#{data_of_selected_row[0]}")          
            $("##{model}-edit-modal").modal('show')            
          else
            window.location = "#{model}s/#{data_of_selected_row[0]}/edit"
      },
      {
        text: 'Destroy',
        attr: {
          id: 'destroy',
          class: 'btn btn-secondary disabled'
          }        
        action: ( e, dt, node, config ) ->
          ids = dt.cells('.selected', 0).data()
          if ids.length == 0
            swal($('#message_confirm_select').text())
          else
            swal({
              title: $('#message_confirm_delete').text()
              text: ""
              type: "warning"
              showCancelButton: true
              confirmButtonColor: "#DD6B55"
              confirmButtonText: "OK",
              cancelButtonText: "キャンセル"
              closeOnConfirm: false
              closeOnCancel: false
            })              
            .then () ->
              $.ajax
                url: "/#{model}s/id"
                beforeSend: (xhr) ->
                  xhr.setRequestHeader(
                    'X-CSRF-Token',
                    $('meta[name="csrf-token"]').attr('content'))
                data: { 'ids': Array.from(ids) }
                dataType: 'json'
                type: 'delete'
                success: (data) ->
                  swal("削除されました!", "", "success")
                  if data.status == 'OK'
                    dt.rows('.selected').remove().draw()
                  else
                    console.log('failed: '+ data.status)
                failure: () ->
                  console.log('ajax failure')
              node.addClass('disabled')
              node.parent().find('#edit').addClass('disabled')
      }
    ],
    select: 'multi'
  })
  oTable.on 'select deselect', (e, dt, type, indexes) ->    
    number_of_selected_row = oTable.rows('.selected').data().length
    oTable.button('#edit').node().toggleClass("disabled", number_of_selected_row != 1 )
    oTable.button('#destroy').node().toggleClass("disabled", number_of_selected_row == 0)

$.fn.clear_previous_errors = () ->
  this.find('input.is-invalid').each (index) ->
    $(this).removeClass('is-invalid')
    $(this).parent().find('.invalid-feedback').empty()

$.fn.render_form_errors = (model, errors) ->
  this_form = this
  $.each JSON.parse(errors), (attr, messages)->
    form_group = this_form.find('.' + model + '_' + attr)
    form_group.find('input').addClass('is-invalid')
    help_block = form_group.find('.invalid-feedback')
    $.each messages, (index, mess)->
      help_block.append(mess + '<br>')