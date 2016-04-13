json.array!(@dialogs) do |dialog|
  json.extract! dialog, :id
  json.url dialog_url(dialog, format: :json)
end
