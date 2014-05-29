define [
  'ractive'
  'show_source'
  'paths/tree'
  'json!data/ducks.json'
  'text!templates/tree.html'
], (Ractive, show_source, Tree, ducks, template)->

  children = (x) ->
    if x.collapsed then [] else x.children

  tree = new Ractive
    el: '#tree'
    template: template
    data:
      Tree: Tree
      data: ducks
      children: children
      width: 350
      height: 300
      leaf: (point) ->
        not (children(point)?.length)

  tree.on 'toggle', (event) ->
    node = event.context.item
    node.collapsed = not node.collapsed
    @update()

  show_source('tree', tree)