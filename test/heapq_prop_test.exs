defmodule HeapQueue.PropTest do
  use ExUnit.Case, async: false
  use ExCheck

  property :empty? do
    for_all {x, y} in {int, int} do
      q = HeapQueue.push(HeapQueue.new(), x, y)
      {{:value, ^x, value}, q} = HeapQueue.pop(q)
      value == y && HeapQueue.empty?(q)
    end
  end

  property :find_min do
    for_all {x, y} in such_that({xx, yy} in {int, int} when xx < yy) do
      q = HeapQueue.new()
        |> HeapQueue.push_value(x)
        |> HeapQueue.push_value(y)

      {{:value, value}, _q} = HeapQueue.pop_value(q)
      value == x
    end
  end

  def sorted?(q) do
    if(HeapQueue.empty?(q)) do
      true
    else
      {{:value, m}, q} = HeapQueue.pop_value(q)
      if(HeapQueue.empty?(q)) do
        true
      else
        {{:value, value}, _q} = HeapQueue.pop_value(q)
        (m <= value && sorted?(q))
      end
    end
  end

  property :sorted do
    for_all xs in list(int) do
      q = Enum.reduce(xs, HeapQueue.new(), &(HeapQueue.push_value(&2, &1)))
      sorted?(q)
    end
  end

  property :to_list_sorted do
    for_all xs in list(int) do
      q = Enum.reduce(xs, HeapQueue.new(), &(HeapQueue.push_value(&2, &1)))
      HeapQueue.to_list_of_values(q) == Enum.sort(xs)
    end
  end

  property :size do
    for_all xs in list(int) do
      q = Enum.reduce(xs, HeapQueue.new(), &(HeapQueue.push_value(&2, &1)))
      HeapQueue.size(q) == Enum.count(xs)
    end
  end
end
