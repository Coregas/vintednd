require_relative 'namu_darbai'
require 'test/unit'
#:nodoc:
class TestNamudarbai < Test::Unit::TestCase
  @test_file = 'test_input.txt'



  def test_validate_date
    Namudarbai.read_input_file('test_input.txt')
    Namudarbai.wrt_prices
    ats = [["2015-02.01", "S", "MR", nil, "Ignored"],
           ["2015-02-02", "S", "MR", nil, "-"],
           ["2015-02-03", "L", "LP", nil, "-"],
           ["2015-02-05", "S", "LP", nil, "-"],
           ["2015-02-06", "S", "MR", nil, "-"],
           ["2015-02-06", "L", "LP", nil, "-"],
           ["2015-02-07", "L", "MR", nil, "-"],
           ["2015-02-08", "M", "XMR", nil, "-"],
           ["2015-02-09", "L", "LP", nil, "-"],
           ["2015-02-10", "S", "MR", nil, "-"],
           ["2015-02-10", "S", "MR", nil, "-"],
           ["2015-02-10", "S", "MR", nil, "-"],
           ["2015-02-10", "S", "MR", nil, "-"],
           ["2015-02-10", "S", "MR", nil, "-"],
           ["2015-03-10", "L", "LP", nil, "-"],
           ["2015-03-09", "L", "LP", nil, "-"],
           ["2015-03-29", "L", "LP", nil, "-"]]
    assert_equal(ats, Namudarbai.validate_date)
  end

  def test_validate_vendor
    Namudarbai.read_input_file('test_input.txt')
    Namudarbai.wrt_prices
    Namudarbai.validate_date
    ats = [["2015-02.01", "S", "MR", nil, "Ignored"],
           ["2015-02-02", "S", "MR", nil, "-"],
           ["2015-02-03", "L", "LP", nil, "-"],
           ["2015-02-05", "S", "LP", nil, "-"],
           ["2015-02-06", "S", "MR", nil, "-"],
           ["2015-02-06", "L", "LP", nil, "-"],
           ["2015-02-07", "L", "MR", nil, "-"],
           ["2015-02-08", "M", "XMR", nil, "Ignored"],
           ["2015-02-09", "L", "LP", nil, "-"],
           ["2015-02-10", "S", "MR", nil, "-"],
           ["2015-02-10", "S", "MR", nil, "-"],
           ["2015-02-10", "S", "MR", nil, "-"],
           ["2015-02-10", "S", "MR", nil, "-"],
           ["2015-02-10", "S", "MR", nil, "-"],
           ["2015-03-10", "L", "LP", nil, "-"],
           ["2015-03-09", "L", "LP", nil, "-"],
           ["2015-03-29", "L", "LP", nil, "-"]]
    assert_equal(ats, Namudarbai.validate_vendor)
  end

  def test_wrt_shipping_prices
    Namudarbai.read_input_file('test_input.txt')
    Namudarbai.wrt_prices
    Namudarbai.validate_date
    Namudarbai.validate_vendor
    ats = [["2015-02.01", "S", "MR", nil, "Ignored"],
           ["2015-02-02", "S", "MR", "2.00", "-"],
           ["2015-02-03", "L", "LP", "6.90", "-"],
           ["2015-02-05", "S", "LP", "1.50", "-"],
           ["2015-02-06", "S", "MR", "2.00", "-"],
           ["2015-02-06", "L", "LP", "6.90", "-"],
           ["2015-02-07", "L", "MR", "4.00", "-"],
           ["2015-02-08", "M", "XMR", nil, "Ignored"],
           ["2015-02-09", "L", "LP", "6.90", "-"],
           ["2015-02-10", "S", "MR", "2.00", "-"],
           ["2015-02-10", "S", "MR", "2.00", "-"],
           ["2015-02-10", "S", "MR", "2.00", "-"],
           ["2015-02-10", "S", "MR", "2.00", "-"],
           ["2015-02-10", "S", "MR", "2.00", "-"],
           ["2015-03-10", "L", "LP", "6.90", "-"],
           ["2015-03-09", "L", "LP", "6.90", "-"],
           ["2015-03-29", "L", "LP", "6.90", "-"]]
    assert_equal(ats, Namudarbai.wrt_shipping_prices)
  end

  def test_lowest_price
    Namudarbai.wrt_prices
    s_size = 'S'
    ats = "1.50"
    assert_equal(ats, Namudarbai.lowest_price(s_size))
  end

  def test_wrt_lowest_prices
    s_size = 'S'
    Namudarbai.read_input_file('test_input.txt')
    Namudarbai.wrt_prices
    Namudarbai.validate_date
    Namudarbai.validate_vendor
    Namudarbai.wrt_shipping_prices
    s_price = Namudarbai.lowest_price(s_size)
    ats = [["2015-02.01", "S", "MR", nil, "Ignored"],
             ["2015-02-02", "S", "MR", 1.5, 0.5],
             ["2015-02-03", "L", "LP", "6.90", "-"],
             ["2015-02-05", "S", "LP", "1.50", "-"],
             ["2015-02-06", "S", "MR", 1.5, 0.5],
             ["2015-02-06", "L", "LP", "6.90", "-"],
             ["2015-02-07", "L", "MR", "4.00", "-"],
             ["2015-02-08", "M", "XMR", nil, "Ignored"],
             ["2015-02-09", "L", "LP", "6.90", "-"],
             ["2015-02-10", "S", "MR", 1.5, 0.5],
             ["2015-02-10", "S", "MR", 1.5, 0.5],
             ["2015-02-10", "S", "MR", 1.5, 0.5],
             ["2015-02-10", "S", "MR", 1.5, 0.5],
             ["2015-02-10", "S", "MR", 1.5, 0.5],
             ["2015-03-10", "L", "LP", "6.90", "-"],
             ["2015-03-09", "L", "LP", "6.90", "-"],
             ["2015-03-29", "L", "LP", "6.90", "-"]]
    assert_equal(ats, Namudarbai.wrt_lowest_prices(s_price,s_size))
  end

  def test_unique_months
    Namudarbai.read_input_file('test_input.txt')
    Namudarbai.validate_date
    ats = ["2015-02", "2015-03"]
    assert_equal(ats, Namudarbai.unique_months)
  end

end
