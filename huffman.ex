defmodule Huffman do
  def sample do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
    end
  def text() do
    'this is something that we should encode'
  end
  def small() do
    'abcdeeee'
  end

  def test(n) do
    t0 = System.os_time()
    text = read("kallocain.txt", n)
    #text = ''
    t1 = System.os_time()
    IO.puts("Read: #{t1-t0}")
    #text = sample()
    sample = text
    tree = tree(sample)
    t2 = System.os_time()
    IO.puts("Make tree: #{t2-t1}")
    #IO.inspect(tree)
    encode = encode_table(tree)
    t3 = System.os_time()
    IO.puts("Encode table: #{t3-t2}")
    #IO.inspect(encode)
    decode = tree
    seq = encode(text, encode)
    t4 = System.os_time()
    IO.puts("Encode: #{t4-t3}")
    #IO.inspect(seq)
    decode_better(seq, decode)
    t5 = System.os_time()
    IO.puts("Decode: #{t5-t4}")
    #IO.puts(d)
    #t5-t4
  end

  def read(file, n) do
    {:ok, file} = File.open(file, [:read, :utf8])
    binary = IO.read(file, n)
    File.close(file)
    case :unicode.characters_to_list(binary, :utf8) do
      {:incomplete, list, _} ->
        list
      list ->
        list
    end
  end

  def tree(sample) do
    freq = freq(sample)
    huffman(freq)
  end

  def encode_table(tree) do encode_table(tree, [], []) end
  def encode_table({left, right}, pos, acc) do
    acc = encode_table(left, [0 | pos], acc)
    encode_table(right, [1 | pos], acc)
  end
  def encode_table(c, pos, acc) do
    pos = Enum.reverse(pos)
    [{c, pos} | acc]
  end

  #def decode_table(tree) do
  #  encode_table(tree)
  #end

  def encode(text, table) do
    Enum.reverse(encode(text, table, []))
  end
  def encode([], _table, acc) do acc end
  def encode([h | t], table, acc) do
    l = lookup(h, table)
    encode(t, table, add_rev(l, acc))
  end

  def lookup(_c, []) do
    :nil
  end
  def lookup(c, [{c, l} | _t]) do
    l
  end
  def lookup(c, [_h | t]) do
    lookup(c, t)
  end

  def add_rev([], l2) do
    l2
  end
  def add_rev([h | t], l2) do
    add_rev(t, [h | l2])
  end

  def decode_better([], _) do
    []
  end
  def decode_better(seq, tree) do
    {char, rest} = decode_char_better(seq, tree)
    [char | decode_better(rest, tree)]
  end

  def decode_char_better([h | t], {left, right}) do
    case h do
      0 ->
        decode_char_better(t, left)
      1 ->
        decode_char_better(t, right)
    end
  end
  def decode_char_better(seq, c) do
    {c, seq}
  end

  def decode([], _) do
    []
  end
  def decode(seq, table) do
    {char, rest} = decode_char(seq, 1, table)
    [char | decode(rest, table)]
  end

  def decode_char(seq, n, table) do
    {code, rest} = Enum.split(seq, n)
    case List.keyfind(table, code, 1) do
      {c, _code} ->
        {c, rest};
      nil ->
        decode_char(seq, n + 1, table)
    end
  end

  def huffman([]) do :nil end
  def huffman([{tree, _f}]) do
    tree
  end
  def huffman([{c1, f1}, {c2, f2} | t]) do
    l = insert({{c1, c2}, f1 + f2}, t)
    huffman(l)
  end

  def sort(freq) do
    sort(freq, [])
  end
  def sort([], sorted) do sorted end
  def sort([h | t], sorted) do
    sort(t, insert(h, sorted))
  end

  def insert(elem, []) do [elem] end
  def insert({elem, f}, [{helem, hf} | t]) when f < hf do
    [{elem, f}, {helem, hf} | t]
  end
  def insert(elem, [h | t]) do
    [h | insert(elem, t)]
  end

  def freq(sample) do
    f = freq(sample, [])
    sort(f)
  end
  def freq([], freq) do
    freq
  end
  def freq([char | rest], freq) do
    freq = add(char, freq)
    freq(rest, freq)
  end

  def add(char, []) do
    [{char, 1}]
  end
  def add(char, [{char, num} | t]) do
    [{char, num + 1} | t]
  end
  def add(char, [{wrong, num} | t]) do
    [{wrong, num} | add(char, t)]
  end


end
