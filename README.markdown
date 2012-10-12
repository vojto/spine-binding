Spine.Binding is a Spine extension that allows easy binding of data to views.

## Installation

If you're using Spine with Hem, add the following to your `package.json`:

    {
      // ...
      "dependencies": {
        // ...
        "spine-binding": "git://github.com/vojto/spine-binding.git",
      }
    }

Add the following to your `slug.json`:

    {
      // ...
      "dependencies": [
        // ...
        "spine-binding"
      ]
    }

Add this wherever you want to use Spine.Binding (add it to your `setup.coffee`):

    require('spine-binding')

## Usage`

Let's say we are building a to-do list. We have `TaskListController` class that manages a list of tasks, and renders each task with `TaskController`.

To use Spine.Binding, add the following code to `TaskListController`.

    class TaskListController
      @extend Spine.Binding
    
      @binding
        view: TaskController
        key: 'cid'

This code will set up a new binding. The `view` option specifies a class that should be used to render each task.

The `key` option specifies unique identifier of each item. Each Spine model has a unique `cid` field that we can use to identify tasks.

Now, each time you want to re-render the collection, call `data` method:

    class TaskListController
      render: ->
        tasks = Task.all
        @data tasks

The `data` method takes an array of models as an argument, and figures out how to update the DOM elements with minimal effort.

It creates instances of `TaskController` (the single view class) and passes them items from array under key `model`.

### Arrays

Spine.Binding works with an arbitrary array of objects too, such as this one:

    @data [{name: 'Vojtech'}, {name: 'Anna'}]

In this case we would pass `name` as `key` option, assuming it's unique.

### Handling events

Spine.Binding works with any model layer and it doesn't do any model event handling, you have to do that manually.

You could for example re-render any time the collection changes:

    constructor: ->
      Task.bind 'change', =>
        @data Task.all

This event will only be fired when the collection changes, that is when an object is added or removed.

Handling object changes should be responsibility of view that represents one instance (`TaskController` in this case.)
