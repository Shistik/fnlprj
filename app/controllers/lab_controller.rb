class LabController < ApplicationController
  skip_before_action :require_login, only: [:input, :get_temp]
  def input
    @city_name = %w[Rzhev Tver Bologoye Gelendzhik Vologda
Yeysk Omsk Izhevsk]
    @info = []
    @city_name.each do |name|
      @info << get_temp(name)
    end
  end

  def get_temp(city_name)
    back = []
    uri = URI('http://api.openweathermap.org/data/2.5/weather')
    params = { q: city_name + ',RU', APPID: '044060b5e356d85cf5e18c11975fcbf8', lang: 'ru'}
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get(uri)
    hash = JSON.parse(res)
    back << (hash['main']['temp'] - 273.15).round(2)
    back << hash['wind']['speed']
    if I18n.locale==:ru
      s='en-ru'
      uri= URI('https://translate.yandex.net/api/v1.5/tr.json/translate')
      params={key:'trnsl.1.1.20180417T122051Z.2205b797c2ba7a3c.d9c6b70991b60bccf3931b8a77488188b98cef32',
      text:city_name,lang:s}
      uri.query = URI.encode_www_form(params)
      res = Net::HTTP.get(uri)
      hash = JSON.parse(res)
      tt=hash['text']
      back << tt[0]
    else
      back << hash['name']
    end
    back
  end

  def output
    @city_name = params[:city_name]#апи определения языков кривой
    uri= URI('https://translate.yandex.net/api/v1.5/tr.json/detect')
    params={key:'trnsl.1.1.20180417T122051Z.2205b797c2ba7a3c.d9c6b70991b60bccf3931b8a77488188b98cef32',
            text:@city_name,hint:['en','ru']}
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get(uri)
    hash = JSON.parse(res)
    @langu=hash['lang']
    country = 'ru'
    @temp = get_day_temp(@city_name + ',' + country)
    if @temp.nil?
      redirect_to root_path
      flash.now[:danger] = "введены неверные данные"
    end
      if I18n.locale==:ru
        if @langu=='en'
          s='en-ru'
          uri= URI('https://translate.yandex.net/api/v1.5/tr.json/translate')
          params={key:'trnsl.1.1.20180417T122051Z.2205b797c2ba7a3c.d9c6b70991b60bccf3931b8a77488188b98cef32',
                  text:@city_name,lang:s}
          uri.query = URI.encode_www_form(params)
          res = Net::HTTP.get(uri)
          hash = JSON.parse(res)
          @city_name=hash['text'][0]
        end
      else
        if @langu=="ru"
          s='ru-en'
          uri= URI('https://translate.yandex.net/api/v1.5/tr.json/translate')
          params={key:'trnsl.1.1.20180417T122051Z.2205b797c2ba7a3c.d9c6b70991b60bccf3931b8a77488188b98cef32',
                  text:@city_name,lang:s}
          uri.query = URI.encode_www_form(params)
          res = Net::HTTP.get(uri)
          hash = JSON.parse(res)
          @city_name=hash['text'][0]
        else
        end
      end
  end

  def get_day_temp(city_name)
    back = []
    uri = URI('http://api.openweathermap.org/data/2.5/forecast')
    params = { q: city_name, APPID: '975eb56a13afa0420d9636589ddf7fd5', lang: 'ru', cnt: 8}#исп 1 из 2 апи,ограничение  запросов
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get(uri)
    hash = JSON.parse(res)
    if hash['cod'] == '404'
      back = nil
    else
      hash['list'].each do |wt|
        temp = []
        temp << wt['dt_txt']
        temp << (wt['main']['temp'] - 273.15).round(2)
        temp << wt['main']['pressure']
        temp << wt['main']['humidity']
        temp << wt['wind']['speed']
        back << temp
      end
    end
    back
  end
end