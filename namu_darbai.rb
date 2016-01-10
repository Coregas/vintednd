# :modulis skirtas atlikti pateiktai uzduociai:
module Namudarbai
  require 'time'
  # kintamasis saugantis uzsakymus
  @order_data = []
  # kintamasis saugantis kainorasti
  @price_data = []
  # :nuskaito nurodyta inputo faila
  # filename - rake run filename:
  def self.read_input_file(filename)
    file = File.open(filename, 'rb')

    file.each_with_index do |line, line_num|
      line = line.split(' ')
      @order_data[line_num] = line
    end

    file.close
  end

  # :nuskaito kainorasti is prices.txt:
  def self.wrt_prices
    file = File.open('prices.txt', 'rb')

    file.each_with_index do |line, line_num|
      line = line.split(' ')
      @price_data[line_num] = line
    end

    file.close
  end

  # :tikrina ar data atitinka tinkama standarta jei ne - i raso Ignored
  # validatina ir keliamuosius metus
  # panaudojau regexa, buvo galima naudoti Time, bet uzimtu daugiau eiluciu
  # o dabar ir taip virsijamas countas
  # regexas virsija simboliu eiluteje counta:
  def self.validate_date
    time_format = /^(?:[1-9]\d{3}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1\d|2[0-8])|(?:0[13-9]|1[0-2])-(?:29|30)|(?:0[13578]|1[02])-31)|(?:[1-9]\d(?:0[48]|[2468][048]|[13579][26])|(?:[2468][048]|[13579][26])00)-02-29)/
    @order_data.each do |order|
      order[4] = '-'
      check = order.any? { |element| element =~ time_format }
      order[4] = 'Ignored' if check == false
    end
  end

  # :validatina ar vendor ir siuntos dydzio
  # kombinacija yra kainorastyje:
  def self.validate_vendor
    @order_data.each do |order|
      exists = nil
      @price_data.each do |price|
        exists = 1 if (order & price).length >= 2
      end
      order[4] = 'Ignored' if exists.nil? && !order[4] != 'Ignored'
    end
  end

  #: suraso kiek kainuos kiekviena siunta be discounto/taisykliu:
  def self.wrt_shipping_prices
    @order_data.each do |order|
      @price_data.each do |price|
        break if ignored?(order)
        intersection = order & price
        order[3] = format('%.02f', price[2]) if intersection.length >= 2
      end
    end
  end

  #:s_size - nurodytas siuntos dydis
  # suranda maziausia nurodytos siuntos dydzio kaina:
  def self.lowest_price(s_size)
    result = @price_data.sort_by(&:last)
    result = result.find { |x| x.include?(s_size) }.last
    result
  end

  # :metodas tikrina ar uzsakymas ignoruojamas:
  def self.ignored?(order)
    true if order[4] == 'Ignored'
  end

  #: s_size - nurodytas siuntos dydis
  # suranda nurodyto dydzio maziausia kaina
  # pritaiko ja uzsakymams kurie turi kitokia kaina, sudeda discountus:
  def self.wrt_lowest_prices(s_price, s_size)
    @order_data.each do |order|
      next if ignored?(order)
      if order.include?(s_size) && !order.include?(s_price)
        order[4] = order[3].to_f - s_price.to_f
        order[3] = s_price.to_f

      end
    end
  end

  #:suranda visas uzsakymu unikalias datas menesiu tikslumu:
  def self.unique_months
    unique = []
    @order_data.each do |order|
      next if ignored?(order)
      unique.push(Time.strptime(order[0], '%Y-%m-%d').strftime('%Y-%m'))

    end
    unique = unique.uniq
    unique
  end

  #:free_ship_rls - nurodyta kada taikomas nemokamas siuntimas
  # kokio vendro, koks siuntos dydis ir kelinta siunta per men nemokama
  # unique_dates - unikalios uzsakymu datos menesio tikslumu
  # metodas sudeda nemokama siuntima pagal nurodytas taisykles:
  def self.wrt_free_shipping(free_ship_rls, unique_dates)
    free_ship_rls.each do |rules|
      unique_dates.each do |date|
        counter = 0
        @order_data.each do |order|
          intersct = order & rules
          if valid_order?(order, intersct) && same_month?(order, date)
            counter += 1
            if counter == rules[2]
              order[4] = order[3]
              order[3] = '0'
              break
            end
          end
        end
      end
    end
  end

  #:order - uzsakymas
  # intersct - uzsakymo ir nemokamo siuntimo masyvu bendros reiksmes
  # returns true jei uzsakymas nera ignored
  # ir
  # bendros reiksmes yra bend dvi
  #  == operatorius netinka, nes gali atitikti dydziai
  # ir siuntu skaicius sutapti su siuntos kainas :
  def self.valid_order?(order, intersct)
    true if intersct.length >= 2 && order[4] != 'Ignored'
  end

  #:order - uzsakymas
  # date - unikali uzsakymo data menesio tikslumu
  # returns true jei data ir uzsakymo data sutapma menesio tikslumu :
  def self.same_month?(order, date)
    order_date2 = Time.strptime(order[0], '%Y-%m-%d')
    order_date3 = order_date2.strftime('%Y-%m')
    true if order_date3 == date
  end

  #:unique_dates - unikalios uzsakymu datos menesio tikslumu
  # max_sum - maksimali discountu suma per menesi
  # metodas panaikina/pakoreguoja discountus kad nebutu virsyta nurodyta discountu suma:
  def self.max_discount_sum(unique_dates, max_sum)
    unique_dates.each do |date|
      sum = 0
      max_reached = false
      @order_data.each do |order|
        next if ignored?(order)
        sum += order[4].to_f if same_month?(order, date)
        if max_reached == true && order[4] != 'Ignored' && order[4] != '-' && same_month?(order, date)
          order[3] = format('%.02f', order[3].to_f + order[4].to_f)
          order[4] = '-'
        else
          if sum > max_sum && max_reached == false && order[4] != 'Ignored'
            max_reached = true
            sum = (sum - order[4].to_f).round(2)
            discount = (max_sum - sum).round(2)
            order[3] = (order[4].to_f - discount.to_f).round(2)
            order[4] = discount

          end
        end
      end
    end
  end

  #: metodas skirtas duomenu isvedimui pagal uzduotyje pateikta formata
  # ji galima panaudoti po betkurio metodo norint isprintinti uzsakymus:
  def self.print_data
    @order_data.each do |order|
      if order[4] != '-' && order[4] != 'Ignored'
        order[4] = format('%.02f', order[4].to_f)
        order[3] = format('%.02f', order[3].to_f)
      end
      puts order.join(' ')
    end
  end
end
