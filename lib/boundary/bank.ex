defmodule RaceConditionBank.Bank do
  use GenServer
  alias RaceConditionBank.Account
  
  def start_link(account_number, initial_balance) do
    GenServer.start_link(__MODULE__, initial_balance, name: to_a(account_number))
  end
  
  # This is a terrible idea! A GenServer is not a global variable!
  def debit(account_number, amount) do
    balance = GenServer.call(to_a(account_number), :get_balance)
    GenServer.cast(to_a(account_number), {:set_balance, Account.debit(balance, amount)})
  end
  def credit(account_number, amount) do
    balance = GenServer.call(to_a(account_number), :get_balance)
    GenServer.cast(to_a(account_number), {:set_balance, Account.credit(balance, amount)})
  end

  
  @impl true
  def init(balance) do
    {:ok, balance}
  end
  
  @impl true
  def handle_cast({:set_balance, new_balance}, _state) do
    {:noreply, new_balance}
  end
  
  @impl true
  def handle_call(:get_balance, _from, state) do
    {:reply, state, state}
  end
  
  defp to_a(n), do: :"#{n}"
end