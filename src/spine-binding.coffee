Spine = require('spine')

assert_options = (options, keys...) ->
  for key in keys
    throw new Error('Missing option #{key}') unless options[key]

class Binding
  constructor: (options) ->
    assert_options(options, 'view', 'key')
    @child_view = options.view
    key = options.key
    @child_key = if typeof key == 'string' then (item) -> item[key] else key
    @child_views = {}
  
  update: (owner_view, data) ->
    keys_to_remove = Object.keys(@child_views)
    for key, child_view of @child_views
      child_view.el.detach()
    
    new_ids = for d in data
      key = String(@child_key(d))
      
      # Remove from to-remove list
      index = keys_to_remove.indexOf(key)
      keys_to_remove.splice(index, 1) if index != -1
      
      # Check for existing view
      view = @child_views[key]
      
      # Create new view if needed
      if !view
        view = @build_view(d)
        @child_views[key] = view
      
      # (Re-)attach the view
      owner_view.append view
    
    for key in keys_to_remove
      view = @child_views[key]
      view.el.remove()
  
  build_view: (d) ->
    new @child_view(model: d)

Spine.Binding =
  extended: (klass) ->
    @include Spine.Binding

  binding: (options) ->
    ###
      Binds children elements to an array. There are two modes of operation:
      
      1. Template-based
        Template `template` will be used to render in a `tag` for each item.
        Data must be updated manually.
      
      2. View-based
        View `child_view` will be used to render the array. Every item will be
        passed to the view constructor.
      
      Shared options
      
      - `key` Used to identify items in data array. Must be defined and unique.
              Key can be either function or a string.
    ###
    @_binding = new Binding(options)

  data: (data) ->
    ###
      Updates child views based on new data array
    ###
    @constructor._binding.update(@, data)