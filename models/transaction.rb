
require_relative ('../db/sqlrunner.rb')

class Transaction

  attr_reader :id
  attr_accessor :transaction_date,:description, :category_id, :amount

  def initialize (params)
    @transaction_date = params['transaction_date']
    @category_id = params['category_id']
    @amount = params['amount'].to_f
    @description = params['description']
  end

  def save()
    sql =  "INSERT INTO transactions (transaction_date,category_id,amount,description) VALUES ('#{@transaction_date}','#{@category_id}',#{@amount},'#{@description}') RETURNING *"
    results = SqlRunner.run(sql).first
    @id = results['id'].to_i
  end

  def Transaction.all()
    sql = "SELECT * FROM transactions" 
    results = SqlRunner.run(sql)
    return results.map{|transaction| Transaction.new(transaction)}
  end

  def Transaction.delete_all()
    sql = "DELETE FROM transactions"
    SqlRunner.run(sql)
  end

  def destroy(id)
    sql = "DELETE FROM transactions WHERE id = #{id}"
    SqlRunner.run(sql)
  end

  def Transaction.find( id )
    sql = "SELECT * FROM transactions WHERE id=#{id}"
    results = SqlRunner.run( sql )
    return Transaction.new(results.first)
  end

  def update()
    sql = "UPDATE transactions SET (date,category_id,amount,description) = ('#{@transaction_date}','#{@category_id}', #{@amount}, '#{@description}') WHERE id = #{@id}"  
    results = SqlRunner.run(sql)
    return results
  end

  def Transaction.total_all_transactions

    # we could have simply pulled the date back from the database with :
    # SELECT sum(all) FROM transactions;
    # transaction_total = results.first['sum']

    transaction_total = 0
    transactions = Transaction.all()

    transactions.each {|transaction| transaction_total += transaction.amount}

   return transaction_total.to_f
 end

 def Transaction.total_transactions_by_category(id)
  category_total = 0
  sql = "SELECT sum(amount) as total FROM transactions WHERE category_id = #{id}"
  category_total = SqlRunner.run(sql).first["total"].to_f
 
  return category_total
 end

 def Transaction.check_within_budget()

  transaction_total = Transaction.total_all_transactions.to_f
  sql = "SELECT budget FROM users WHERE name = 'Gill Liddle'"
  user_budget = SqlRunner.run(sql).first["budget"].to_f
  if transaction_total >= user_budget 
    budget_overspend_flag = 1
  end
  return budget_overspend_flag
 end

 # def Transaction.check_within_overdraft_limit()
 #  transaction_total = Transaction.total_all_transactions.to_f
 #  sql = "SELECT user_budget FROM users WHERE name = 'Gill Liddle'"
 #  overspend_flag = SqlRunner.run(sql).first["budget_overspend_flag
 #    "]
 #  if overspend_flag = 1
 #    transaction_total = Transaction.total_all_transactions.to_f

 #  else
 #  end


 # end

def Transaction.total_transactions_by_date(start_date,end_date)
  sql = "SELECT sum(amount) as total FROM transactions WHERE transaction_date >='#{start_date}' AND transaction_date <= '#{end_date}'"
  total_transactions_by_date = SqlRunner.run(sql).first["total"].to_f
  return total_transactions_by_date
end
end