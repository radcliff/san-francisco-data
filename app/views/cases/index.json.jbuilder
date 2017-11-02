json.array! @cases do |caze|
  json.partial! 'cases/case', caze: caze
end
