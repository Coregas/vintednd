# :Sveiki,
# :pastebejimas '2015-02-28 CUSPS' elementas blogas tiek del datos
# nes ne keliamieji mietai tiek del Vendoriaus.
#
# Main modulis paleidzia visus namu_darbai modulio metodus
#
# filename parametras imamas is terminalo 'rake run input.txt'
#
# max_sum - maximalus discountas per men
#
# free_ship_rls:
# 1 element - koks vendor
# 2 element - koks siuntos dydis
# 3 element - kelinta siunta per men bus nemokama
#
# s_size - nurodomas kaip zymimas maziausias siuntos dydis
#
# visur kitur komentarai virs metodu namu_darbai.rb faile
module Main
  require_relative 'namu_darbai'
  def self.initialize(filename)
    foo = 1.5
    # max discount per mounth
    max_sum = 10
    # free shipping rules
    # 1st company
    # 2nd size
    # 3rd count
    free_ship_rls = [['LP', 'L', 3]]
    # what is the smallest size
    s_size = 'S'
    Namudarbai.read_input_file(filename)
    Namudarbai.wrt_prices
    Namudarbai.validate_date
    Namudarbai.validate_vendor
    Namudarbai.wrt_shipping_prices
    s_price = Namudarbai.lowest_price(s_size)
    Namudarbai.wrt_lowest_prices(s_price, s_size)
    unique_dates = Namudarbai.unique_months
    Namudarbai.wrt_free_shipping(free_ship_rls, unique_dates)
    Namudarbai.max_discount_sum(unique_dates, max_sum)
    Namudarbai.print_data
  end
end
