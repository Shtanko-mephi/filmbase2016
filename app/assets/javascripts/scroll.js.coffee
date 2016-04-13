ready= ->
  element = document.getElementById("mess_id")
  if element
    element.scrollTop = element.scrollHeight

$(document).ready ready
$(document).on 'page:load', ready
