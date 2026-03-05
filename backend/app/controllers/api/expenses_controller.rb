class Api::ExpensesController < ApplicationController

  # GET /api/expenses
  # Returns all expenses
  def index

    # BUG-001 FIX
    # Previously expenses were ordered by created_at which caused
    # new expenses to appear randomly in the list.
    #
    # According to the ticket, expenses should be ordered by their
    # expense DATE (not creation time).
    #
    # We also add created_at as a secondary sort so when multiple
    # expenses have the same date, the newest record still appears first.

    expenses = Expense.includes(:category).order(date: :desc, created_at: :desc)

    # Filter expenses by year and month if parameters are provided
    if params[:year].present? && params[:month].present?
      year = params[:year].to_i
      month = params[:month].to_i

      start_date = Date.new(year, month, 1)
      end_date = start_date.end_of_month

      # BUG-001 FIX
      # Filter using expense DATE instead of created_at
      expenses = expenses.where(date: start_date..end_date)
    end

    render json: expenses.map { |expense| format_expense(expense) }
  end


  # POST /api/expenses
  # Creates a new expense
  def create
    expense = Expense.new(expense_params)

    if expense.save
      render json: format_expense(expense), status: :created
    else
      render json: { errors: expense.errors.full_messages }, status: :unprocessable_entity
    end
  end


  # PATCH /api/expenses/:id
  # Updates an existing expense
  def update
    expense = Expense.find(params[:id])

    if expense.update(expense_params)
      render json: format_expense(expense)
    else
      render json: { errors: expense.errors.full_messages }, status: :unprocessable_entity
    end
  end


  # DELETE /api/expenses/:id
  # Deletes an expense
  def destroy
    expense = Expense.find(params[:id])
    expense.destroy
    head :no_content
  end


  private

  # Strong parameters for expense creation/update
  def expense_params
    # DATA FIX
    # Permit category_id so the frontend can assign a category
    params.require(:expense).permit(
      :description,
      :amount,
      :category_id,
      :date
    )
  end


  # Helper method to format the expense JSON response
  def format_expense(expense)
    {
      id: expense.id,
      description: expense.description,
      amount: expense.amount.to_f,
      category: expense.category.name,
      date: expense.date.to_s,
      created_at: expense.created_at,
      updated_at: expense.updated_at
    }
  end

end