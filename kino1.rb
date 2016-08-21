# encoding: utf-8
# (с) 2015 goodprogrammer.ru
# Выбираем кино посмотреть
=begin
Задача 13-4 Обработайте исключение «нет сети» для программы «Киновыбиратель».

Пример результата:

>ruby kino.rb
Не удалось добраться до Кинопоиска. Проверьте сеть.
Для воспроизведения ошибки просто отключите свой комп от сети перед запуском программы.

Задача 13-5 Улучшаем наш «Киновыбиратель» дальше.
Давайте предложим пользователю выбрать, что сделать с выбранным фильмом: открыть его на Кинопоиске или сразу поискать на РуТрекере. А когда он определиться — откроем ему нужную страницу.
Пример результата:
>ruby kino.rb
Темный рыцарь: Возрождение легенды

            США...
            реж. Кристофер Нолан
            (фантастика, боевик, триллер...)

Рейтинг Кинопоиска: 8.309 (196 891)
Смотрим? (Y/N)
y
Какую страницу открыть?
1. Страница фильм Кинопоиске
2. Найти фильм ну РуТрекере (нужна авторизация там)
1
Да, придется погуглить ;)

Так как рутрекр запрещен. Выбора с какой страницы загрузить не будет. 
Загружать буду со страницы киногоу.
=end
# XXX/ Этот код необходим только при использовании русских букв на Windows
if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end
# /XXX


# ВНИМАНИЕ! когда вы запускаете этот скрипт верстка сайта http://kinogo.club/filmy_2016/ может измениться 
#и ничего работать не будет.
# Смотрите видео урок - так вы поймете принцип и сможете заставить программу работать.


# либа для загрузки сайтов

require 'mechanize'
require 'launchy' # подключили гем launchy для запуска фильма с сайта
#  экземпляр нашего виртуального браузера
agent = Mechanize.new

# флажок индикатор — если в цикле он стал true, значит фильм найден
chosen = false

# повторяем предложение, пока пользователь не согласится с выбором
until chosen
  # качаем страницу из списка http://kinogo.club/filmy_2016/
  begin # обработка исключения. Обрабатываем команду get 
  page = agent.get("http://kinogo.club/filmy_2016/page/#{rand(22)}/")

  #puts page.body #— так в консоль можно вывести содержимое страницы
  rescue # ошибка в отсутствии подключения к сети
  puts "Не удалось добраться до Киногоу. Проверьте сеть."
  abort 
  end
  # ищем среди тэгов div, чей аттрибут class называется 'shortstory' и выбираем случайный фильм
  # предварительно создав массив методом to_a
  #tr_tag = page.search("//div[starts-with(@class, 'shortstory')]").to_a.sample
  div_tag = page.search("//div[@class='shortstory']").to_a.sample
  
  #puts  div_tag
  # ищем внутри выбранного тэга аттрибуты фильма:
  film_title = div_tag.search("h2[@class='zagolovki']").text # название фильма
 
  kinogo_rating = div_tag.search("li[@itemprop='average']").text # рейтинг фильма
  #kinopoisk_link = "http://kinopoisk.ru/film/#{tr_tag.attributes["id"].to_s.gsub(/tr_/,'')}/"
  kinogo_link = div_tag.search("h2/a/@href") # получение ссылки URL фильма от значения аттрибута href 
  
  film_description = div_tag.search("./div/div/text()[1]") # .- текущий контекст, text()[1] - первый
 # текстовый узел, /div/div/ - путь к тексту  

  #film_description = tr_tag.search("span[@class='gray_text']")[0].text
  # homework - добавить главных ролей (не делал)

 puts
 puts
 puts "Название фильма: #{film_title}"
 puts
 puts film_description
 puts
 puts "Рейтинг Киногоу: #{kinogo_rating}"
 puts
 puts kinogo_link 
 puts
 puts "Смотрим? (Y/N)"

  choice = STDIN.gets.chomp

  if choice.downcase == 'y'
    chosen = true

    # Homework - open браузер http://www.copiousfreetime.org/projects/launchy/
    # puts 'Открыть на 1. кинопоиске или 2. rutracker.org?'
    # choice = STDIN.gets.to_i
    #
    # case choice
    #   when 1 kinopoisk_link
    #   when 2 "http://rutracker.org/forum/tracker.php?nm=title"
  end
end
      Launchy.open("#{kinogo_link}") # открываем страницу фильма в браузере
    
