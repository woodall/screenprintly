module PrintPricesHelper
  def price_tiers
    [
      ["1  - 11", 1],
      ["12 - 23", 2],
      ["24 - 35", 3],
      ["36 - 47", 4],
      ["48 - 71", 5],
      ["72 - 143", 6],
      ["144 - 287", 7],
      ["288 - 575", 8],
      ["576 - 1171", 9],
      ["1172 - 2343", 10],
      ["2344 - 4687", 11],
      ["4688 - 9375", 12],
      ["9376 + ", 13],
    ]
  end
end