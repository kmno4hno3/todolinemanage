class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :edit, :update, :destroy]

  def index
    @todos = current_user.todos.order(created_at: :desc)
  end

  def edit
  end

  def update
    @todo.update!(todo_params)
    redirect_to todos_url, notice: "todo「#{@todo.name}」を更新しました。"
  end

  def show
  end

  def new
    @todo = Todo.new
  end

  def create
    @todo = Todo.new(todo_params.merge(user_id: current_user.id))

    if @todo.save
      redirect_to @todo, notice: "todo「#{@todo.name}」を登録しました。"
    else
      render :new
    end
  end

  def destroy
    @todo.destroy
    redirect_to todos_url, notice: "Todo「#{@todo.name}」を削除しました。"
  end

  private

  def todo_params
    params.require(:todo).permit(:name, :description)
  end

  def set_todo
    @todo = current_user.todos.find(params[:id])
  end
end
