TodoList = React.createClass
  handleTodoSubmit: (options) ->
    $.post('/todos', options,
      ((todos) => @setState(todos: todos))).
      error((err) -> console.error('/todos', status, err.toString()))

  handleTodoClear: ->
    $.post('/todos/clear_completed',
      ((todos) => @setState(todos: todos)))

  loadTodosFromServer: ->
    $.ajax
      url: @props.url
      dataType: 'json'
      success: (todos) =>
        @setState(todos: todos)
      error: (xhr, status, err) =>
        console.error(@props.url, status, err.toString())

  getInitialState: ->
    { todos: [] }

  componentDidMount: ->
    @loadTodosFromServer()

  render: ->
    self = this
    todoItems = @state.todos.map((todo) ->
      `<Todo updateCompleteStatus={self.loadTodosFromServer} title={todo.title} complete={todo.complete} id={todo.id}>
       </Todo>`
    )

    `<div class="todo-list">
      <NewTodoForm onTodoSubmit={this.handleTodoSubmit}/>
      {todoItems}
      <TodoClearButton onTodoClear={this.handleTodoClear}/>
     </div>`

TodoClearButton = React.createClass
  handleSubmit: (e) ->
    e.preventDefault()
    @props.onTodoClear()

  render: ->
    `<button onClick={this.handleSubmit}>Clear completed</button>`

NewTodoForm = React.createClass
  handleSubmit: (e) ->
    e.preventDefault()
    title = @refs.title.getDOMNode().value.trim()
    return if !title
    @props.onTodoSubmit(title: title)
    @refs.title.getDOMNode().value = ''

  render: ->
    `<form class="new-todo-form" onSubmit={this.handleSubmit}>
      <input placeholder="What do you need to do?" ref="title" id="todo-title" type="text" />
      <input type="submit" value="Add todo" />
     </form>`

TodoCompleteCheckbox = React.createClass
  handleUpdateCompleteStatus: () ->
    $el = $(@refs.complete.getDOMNode())
    checked = $el.is(':checked')

    if checked
      @props.onMarkComplete()
    else
      @props.onMarkIncomplete()

  render: ->
    `<input type="checkbox" checked={this.props.complete} ref="complete" onClick={this.handleUpdateCompleteStatus} />`

Todo = React.createClass
  markComplete: ->
    $.post("/todos/#{@props.id}/complete", =>
      @props.updateCompleteStatus()
    )

  markIncomplete: ->
    $.post("/todos/#{@props.id}/incomplete", =>
      @props.updateCompleteStatus()
    )

  render: ->
    if @props.complete
      classes = 'todo complete'
    else
      classes = 'todo'

    `<div className={classes}>
      <TodoCompleteCheckbox
        complete={this.props.complete}
        onMarkComplete={this.markComplete}
        onMarkIncomplete={this.markIncomplete} />
      {this.props.title}
    </div>`

window.NewTodoForm = NewTodoForm
window.TodoCompleteCheckbox = NewTodoForm
window.TodoList = TodoList
window.TodoClearButton = TodoClearButton
window.Todo = Todo
