module Testas
  require'time'
  require 'date'
def self.getfilecontents(filename)

  file = File.open(filename , "rb")
  contents = File.read(filename)

  orderData = {}


  if(contents != "")
    linenumb = 0

    file.each_line do |line|
      line = line.split (" ")
      orderData[linenumb] = {}
      orderData[linenumb]["date"] = line[0]
      orderData[linenumb]["size"] = line[1]
      orderData[linenumb]["company"] = line[2]
      linenumb +=1
    end
    pricesData = getPrices
    if !pricesData.nil?
      orderData = validateData(orderData, pricesData)
      orderData = getShippingPrices(orderData, pricesData)
      orderData = discountRules(orderData)
      printToFile(orderData)
    else
      puts "prices.txt doesnt exsists or is empty"

    end

  else

    return "Unable to read file or the file is empty"

  end
  file.close
end
def self.printToFile (orderData)

  output = File.open("results.txt", "w")
  orderData.each do |order|

    output << "#{order[1]['date']} #{order[1]['size']} #{order[1]['company']} #{'%.02f' % order[1]['price'].to_f} #{order[1]['discount']}\n"

  end
  output.close
end
def self.getShippingPrices(orderData, pricesData)

  lowestSmallPrice = getLowestSPrice(pricesData)

orderData.each do |order|
  pricesData.each do |price|

    if order[1]["company"] == price[1]["company"] && order[1]["size"] == price[1]["size"] && !order[1]["discount"]
      order[1]["price"] = price[1]["price"]


      if order[1]["size"]=="S" && order[1]["price"] > lowestSmallPrice && !order[1]["discount"]
        diff = order[1]["price"].to_f - lowestSmallPrice.to_f

        order[1]["discount"] = '%.02f' % diff
      else
        if !order[1]["discount"]
        order[1]["discount"] = "-"
          end
      end

    end
  end


end

  return orderData



end
  def self.discountRules(orderData)

    #maximum sum of discounts per mounth
    maxSum = 10
    #witch shippment should be free
    freeCount = 3
    #what company
    company = "LP"
    #what size
    size = "L"
    #unique dates array
    uniqueDates = []


    numb = 0
    orderData.each do |order|
      if order[1]["discount"] != "Ignored"
      uniqueDates[numb] = Time.strptime(order[1]["date"], "%Y-%m-%d")
      uniqueDates[numb] = uniqueDates[numb].strftime("%Y-%m")
      numb += 1

      end
    end
  uniqueDates = uniqueDates.uniq

    uniqueDates.each do |uniqueDate|
      freeCounter = 0
      maxSumCounter = 0
      orderData.each do |order|
        date = Time.strptime(order[1]["date"], "%Y-%m-%d")
        date = date.strftime("%Y-%m")

        if uniqueDate == date && order[1]["discount"] != "Ignored"
          if order[1]["company"] == company && order[1]["size"] == size
            freeCounter +=1
            if freeCounter == freeCount
              order[1]["discount"] = '%.02f' % order[1]["price"].to_f

            end
          end

          if order[1]["discount"] != "-"
            if maxSumCounter == maxSum
              order[1]["discount"] = "-"
            end
          maxSumCounter += order[1]["discount"].to_f

          if maxSumCounter > maxSum

            maxSumCounter -= order[1]["discount"].to_f

            price = (maxSum - maxSumCounter).round(2)
            puts order[1]["date"]
            order[1]["discount"] = '%.02f' % price
            maxSumCounter = maxSum
          end

          end



        end
      end

    end



    return orderData
  end

def self.getPrices

  file = File.open("prices.txt" , "rb")
  contents = File.read("prices.txt")

  pricesData = {}

  if(contents != "")
    linenumb = 0

    file.each_line do |line|
      line = line.split(" ")
      pricesData[linenumb] = {}
      pricesData[linenumb]["company"] = line[0]
      pricesData[linenumb]["size"] = line[1]
      pricesData[linenumb]["price"] = line[2]
      linenumb += 1
    end

    return pricesData

  else
    return 0
  end
  file.close
end
def self.getLowestSPrice (pricesData)
  lowestprice = 0
  pricesData.each do |price|
    if price[1]["size"] == "S"
      lowestprice = price[1]["price"]
    end
  end

  pricesData.each do |price|
    if price[1]["size"] == "S" && price[1]["price"] < lowestprice
      lowestprice = price[1]["price"]
    end
  end

  return lowestprice
end


def self.validateData(orderData, pricesData)

  orderData = validateDate(orderData)
  orderData = validateVendor(orderData, pricesData)

  return orderData
end


def self.validateDate (orderData)
  orderData.each do |order|
    begin
     Time.strptime(order[1]["date"], '%Y-%m-%d')
    rescue ArgumentError
      order[1]["discount"] = "Ignored"
      end
  end
  return orderData
end

def self.validateVendor (orderData, pricesData)

  orderData.each do |order|
    selectResult = pricesData.select{|key,x| x["company"] == order[1]["company"] && x["size"] == order[1]["size"]}
    if selectResult.empty?
      order[1]["discount"] = "Ignored"
    end
  end

  return orderData
end
  end