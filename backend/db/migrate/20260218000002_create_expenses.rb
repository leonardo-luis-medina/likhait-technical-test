class CreateExpenses < ActiveRecord::Migration[7.2]
  def change
    # BUG-001 SUPPORT CHANGE
    # Added explicit expense date column to store the actual date
    # when the expense occurred. This allows the application to
    # sort expenses by their real date instead of created_at.
    #
    # This change ensures newly added expenses appear at the top
    # of the list when ordered by date (descending), which fixes
    # the issue described in BUG-001.

    create_table :expenses, if_not_exists: true do |t|
      t.string :description, null: false, limit: 255
      t.decimal :amount, precision: 10, scale: 2, null: false

      # ADDED: explicit date column for expense tracking
      # Previously the system relied on created_at which caused
      # incorrect ordering of expenses in the UI.
      t.date :date, null: false

      t.references :category, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end