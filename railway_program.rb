=begin
С этого занятия мы будем создавать объектную модель (классы и методы) для гипотетического приложения управления железнодорожными станциями, которое позволит управлять станциями, принимать и отправлять поезда, показывать информацию о них и т.д.

Требуется написать следующие классы:

Класс Station (Станция):
+ Имеет название, которое указывается при ее создании
+ Может принимать поезда (по одному за раз)
+ Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).
+ Может возвращать список всех поездов на станции, находящиеся в текущий момент
+ Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
=end

class Station
  attr_reader :name, :train

  def initialize(name)
    @name = name
    @train = []
  end

  def ingoing_train(train)
    self.train << train  
  end

  def outgoing_train(train)
    self.train.delete(train)
  end
  
  def train_by_type(type)
    self.train.filter { |train| train.type == type }
  end
  
  def type_count(type)
    self.train_by_type(type).size
  end

end



=begin
Класс Route (Маршрут):
+ Имеет начальную и конечную станцию, а также список промежуточных станций. Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
+ Может добавлять промежуточную станцию в список
+ Может удалять промежуточную станцию из списка
+ Может выводить список всех станций по-порядку от начальной до конечной
=end

class Route
  attr_reader :stations

  def initialize(start_station, finish_station)
    @stations = []
    @stations << start_station
    @stations << finish_station
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def delete_station(station)
    @stations.delete(station)
  end
end

=begin
Класс Train (Поезд):
+ Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов, эти данные указываются при создании экземпляра класса
+ Может набирать скорость
+ Может возвращать текущую скорость
+ Может тормозить (сбрасывать скорость до нуля)
+ Может возвращать количество вагонов
+ Может прицеплять/отцеплять вагоны (по одному вагону за операцию, метод просто увеличивает или уменьшает количество вагонов). Прицепка/отцепка вагонов может осуществляться только если поезд не движется.
+ Может принимать маршрут следования (объект класса Route). 
+ При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
+ Может перемещаться между станциями, указанными в маршруте. Перемещение возможно вперед и назад, но только на 1 станцию за раз.
+ Возвращать предыдущую станцию, текущую, следующую, на основе маршрута

В качестве ответа приложите ссылку на репозиторий с решением.
=end

class Train < Route
  attr_accessor :name, :type, :amount_wagons, :station
  attr_reader :route

  def initialize(name, type, amount_wagons)
    @name = name
    @type = type
    @amount_wagons = amount_wagons
    @current_speed = 0
    puts "Train #{name} created. Type: #{type}. Amount of vagons: #{amount_wagons} Speed: #{current_speed}"
  end

  def current_speed     # Может возвращать текущую скорость
    @current_speed
  end

  def speed_up(number)  # Может набирать скорость
    @current_speed += number
  end

  def brake             # Может тормозить до 0.
    @current_speed = 0
  end

  def add_vagon         # Может прицеплять вагоны
    if current_speed == 0
      self.vagon_count += 1
    else
      puts "Need speed down first!"
    end
  end

  def del_vagon         # Может отцеплять вагоны
    if current_speed == 0
      self.vagon_count -= 1
    else
      puts "Need speed down first!"
    end
  end

  def route=(route)
    @route = route
    self.station = self.route.stations.first
  end

  def next_station
    self.route.stations[self.route.stations.index(self.station) + 1]
  end

  def previous_station
    self.route.stations[self.route.stations.index(self.station) - 1]
  end

  def move_next_station
    if next_station != nil
      self.station = next_station unless next_station
    end
  end
  
  def move_previous_station
    if self.station != self.route.stations.first
      self.station = previous_station unless previous_station
    end
  end
end