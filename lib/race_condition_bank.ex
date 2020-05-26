defmodule RaceConditionBank do
  alias RaceConditionBank.Bank
  @moduledoc """
  Documentation for RaceConditionBank.
  """

  @doc """
  Hello world.

  ## Examples

      iex> RaceConditionBank.hello()
      :world

  """
  def new_account(account_number, balance) do
    Bank.start_link(account_number, balance)
  end
  
  def credit(account, amount) do
    Bank.credit(account, amount)
  end
  
  def debit(account, amount) do
    Bank.debit(account, amount)
  end
  
  # Too clever. Do each one concurrently in its own task
  def transfer(from_account, to_account, amount) do
    Bank.debit(from_account, amount)
    Bank.credit(to_account, amount)
  end
  
  def mischief() do
    Enum.each((1..3), &new_account(&1, 100))
    
    1..100 
    |> Enum.map(fn _ -> 
      (1..3)
      |> Enum.shuffle
      |> Enum.take(2)
      |> sync_transfer(:random.uniform(3))
    end)
    
    
    # Now get the total
    ~w[1 2 3]a
    |> Enum.map(fn x -> :sys.get_state(x) end)
    |> Enum.sum
  end
  
  def async_transfer([from_account, to_account], amount) do
    Task.async(fn -> transfer(from_account, to_account, amount) end)
  end
  
  def sync_transfer([from_account, to_account], amount) do
    transfer(from_account, to_account, amount)
  end

end
