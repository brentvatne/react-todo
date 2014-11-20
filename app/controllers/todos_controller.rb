class TodosController < ApplicationController
  def index
    @todos = Todo.order(:id).all
    render json: @todos.map(&:attributes)
  end

  def create
    @todo = Todo.create(title: params[:title])
    index
  end

  def complete
    @todo = Todo.find(params[:id])
    @todo.update_attributes(complete: true)
    render json: {success: true}
  end

  def incomplete
    @todo = Todo.find(params[:id])
    @todo.update_attributes(complete: false)
    render json: {success: true}
  end

  def destroy
    @todo = Todo.find(params[:id])
    @todo.destroy
    render json: {success: true}
  end

  def clear_completed
    Todo.completed.map(&:destroy)
    index
  end
end
