##############################################################################
#
# Skew Heap Priority Queue
#
# This module was ported to Elixir from Michael Truog's pqueue2.
# Copyright (c) 2014, Kohei Takeda <k-tak at void dot in>
#
# Original Copyright:
# BSD LICENSE
#
# Copyright (c) 2011, Michael Truog <mjtruog at gmail dot com>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in
#       the documentation and/or other materials provided with the
#       distribution.
#     * All advertising materials mentioning features or use of this
#       software must display the following acknowledgment:
#         This product includes software developed by Michael Truog
#     * The name of the author may not be used to endorse or promote
#       products derived from this software without specific prior
#       written permission
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
# DAMAGE.
#
##############################################################################
defmodule HeapQueue do
  defstruct heap: nil

  def new(),
    do: %HeapQueue{}

  def push_value(%HeapQueue{} = q, val),
    do: push(q, val, val)

  def push(%HeapQueue{heap: h} = q, pri, val),
    do: %HeapQueue{q | heap: _merge({pri, nil, nil, :element, val}, h)}

  def pop_value(%HeapQueue{heap: h} = q) do
    {res, h_out} = _pop_value(h)
    {res, %HeapQueue{q | heap: h_out}}
  end

  defp _pop_value(nil),
    do: {:empty, nil}

  defp _pop_value({_, hl, hr, :element, val}),
    do: {{:value, val}, _merge(hl, hr)}

  defp _pop_value({p, hl, hr, :queue, queue}) do
    case :queue.out(queue) do
      {{:value, _} = res, queue_out} -> {res, {p, hl, hr, :queue, queue_out}}
      {:empty, _} -> _pop_value(_merge(hl, hr))
    end
  end

  def pop(%HeapQueue{heap: h} = q) do
    {res, h_out} = _pop(h)
    {res, %HeapQueue{q | heap: h_out}}
  end

  defp _pop(nil),
    do: {:empty, nil}

  defp _pop({p, hl, hr, :element, val}),
    do: {{:value, p, val}, _merge(hl, hr)}

  defp _pop({p, hl, hr, :queue, queue}) do
    case :queue.out(queue) do
      {{:value, val}, queue_out} -> {{:value, p, val}, {p, hl, hr, :queue, queue_out}}
      {:empty, _} -> _pop(_merge(hl, hr))
    end
  end

  def size(%HeapQueue{heap: h}),
    do: _size(0, _pop_value(h))

  defp _size(s, {:empty, _}),
    do: s

  defp _size(s, {{:value, _}, h}),
    do: _size(s + 1, _pop_value(h))

  def to_list_of_values(%HeapQueue{heap: h}),
    do: _to_list_of_values([], _pop_value(h))

  defp _to_list_of_values(list, {:empty, _}),
    do: :lists.reverse(list)

  defp _to_list_of_values(list, {{:value, val}, h}),
    do: _to_list_of_values([val | list], _pop_value(h))

  def to_list(%HeapQueue{heap: h}),
    do: _to_list([], _pop(h))

  defp _to_list(list, {:empty, _}),
    do: :lists.reverse(list)

  defp _to_list(list, {{:value, p, val}, h}),
    do: _to_list([{p, val} | list], _pop(h))

  def empty?(%HeapQueue{heap: h}),
    do: _empty?(h)

  defp _empty?(nil),
    do: true

  defp _empty?({_, hl, hr, :queue, queue}),
    do: _empty?(hl) and _empty?(hr) and :queue.is_empty(queue)

  defp _empty?(_),
    do: false

  def queue?(%HeapQueue{heap: h}),
    do: _queue?(h)

  def queue?(_),
    do: false

  defp _queue?(nil),
    do: true

  defp _queue?({_, _, _, :element, _}),
    do: true

  defp _queue?({_, _, _, :queue, queue}),
    do: :queue.is_queue(queue)

  defp _queue?(_),
    do: false

  defp _merge(nil, nil),
    do: nil

  defp _merge(nil, {_, _, _, _, _} = h),
    do: h

  defp _merge({_, _, _, _, _} = h, nil),
    do: h

  defp _merge({p1, hl1, hr1, t, d}, {p2, _, _, _, _} = h2) when p1 < p2,
    do: {p1, hl1, _merge(hr1, h2), t, d}

  defp _merge({p1, _, _, _, _} = h1, {p2, hl2, hr2, t, d}) when p1 > p2,
    do: {p2, hl2, _merge(h1, hr2), t, d}

  defp _merge({p, hl1, hr1, :element, val1}, {p, hl2, hr2, :element, val2}),
    do: {p, _merge(hl1, hr1), _merge(hl2, hr2), :queue, :queue.from_list([val2, val1])}

  defp _merge({p, hl1, hr1, :queue, queue}, {p, hl2, hr2, :element, val}),
    do: {p, _merge(hl1, hr1), _merge(hl2, hr2), :queue, :queue.in(val, queue)}

  defp _merge({p, hl1, hr1, :element, val}, {p, hl2, hr2, :queue, queue}),
    do: {p, _merge(hl1, hr1), _merge(hl2, hr2), :queue, :queue.in(val, queue)}
end

defimpl Inspect, for: HeapQueue do
  import Inspect.Algebra

  def inspect(q, opts) do
    concat(["#HeapQueue<", to_doc(HeapQueue.to_list(q), opts), ">"])
  end
end

