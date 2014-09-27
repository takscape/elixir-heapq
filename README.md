HeapQueue
=========

A Heap-based priority queue implementation in Elixir.
Ported from  Michael Truog's pqueue2.

Original copyright:

```
BSD LICENSE

Copyright (c) 2011, Michael Truog <mjtruog at gmail dot com>
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in
      the documentation and/or other materials provided with the
      distribution.
    * All advertising materials mentioning features or use of this
      software must display the following acknowledgment:
        This product includes software developed by Michael Truog
    * The name of the author may not be used to endorse or promote
      products derived from this software without specific prior
      written permission

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
DAMAGE.
```

## Usage

```
# Create
q = HeapQueue.new()

# Push
q = HeapQueue.push(
    q,
    1, # priority
    "foo" # value
    )

# Pop
{{:value, priority, value}, newq} = HeapQueue.pop(q)
{:empty, _} = HeapQueue.pop(newq)

# Convert to list
HeapQueue.to_list(q)

# Misc.
HeapQueue.size(q)
HeapQueue.empty?(q)
HeapQueue.queue?(q)
```

