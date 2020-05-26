defmodule RaceConditionBank.Account do
  def debit(balance, amount) do
    balance - amount
  end
  
  def credit(balance, amount) do
    balance + amount
  end
end