defmodule Bench do
  def bench() do bench(100) end

  def spread(_dist, first, first) do
    [first]
  end
  def spread(dist, first, last) do
    [first | spread(dist, first + dist, last)]
  end

  def bench(l) do
    #hs = [1,2,3,4,5,6,7,8,9,10]
    #hs = [1, 100,200,300,400,500,600,700,800,900,100]
    #hs = [1, 1000,2000,3000,4000,5000,6000,7000,8000,9000,10000]
    #hs = [1, 2000,4000,6000,8000,10000,12000,14000,16000,18000,20000]
    #hs = [1, 30000,60000,90000,120000,150000,180000,210000,240000,270000,300000]
    _hsl = [1,
    15000,
    30000,
    45000,
    60000,
    75000,
    90000,
    105000,
    120000,
    135000,
    150000,
    165000,
    180000,
    195000,
    210000,
    225000,
    240000,
    255000,
    270000,
    285000,
    300000]
    hs = spread(1250, 0, 300000)
    time = fn (h, f) ->
      (elem(:timer.tc(fn () -> loop(l, fn -> f.(h) end) end),0) / l) / 1000
    end

    {:ok, file} = File.open("bench.dat", [:write, :list])

    bench = fn (h) ->

      dummy = fn (_p) -> dummy() end
      #fun1 = fn (h) -> Huffman.test(h) end
      tdecode = Huffman.test(h) / 1000
      #fun2 = fn (p) -> Prim2.prim(p) end
      #fun3 = fn (p) -> Prim3.prim(p) end

      tdummy = time.(h, dummy)
      #tfun1 = time.(h, fun1)
      #tfun2 = time.(p, fun2)
      #tfun3 = time.(p, fun3)

      :io.format(file, "~w\t~w\t~w\n", [h, tdummy, tdecode])
    end

    :io.format(file, "# benchmark of huffman (loop: #{l}) \n", [])
    Enum.map(hs, bench)
    File.close(file)
    :ok
  end

  def loop(0,_) do :ok end
  def loop(n, f) do
    f.()
    loop(n-1, f)
  end

  def dummy() do
    :ok
  end
end
