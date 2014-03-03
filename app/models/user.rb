# coding: utf-8
class User < ActiveRecord::Base
  require 'httparty'
  require 'nokogiri'
  #sattr_accessible :account, :pwd
  has_one :user_info, class_name: 'UserInfo', foreign_key: 'user_id'
  has_many :orders, class_name: 'Order', foreign_key: 'user_id'

  attr_accessor :__VIEWSTATE, :__VIEWSTATEGENERATOR, :__EVENTVALIDATION,
                :__EVENTTARGET, :__EVENTARGUMENT

  attr_accessor :cookie

  after_create :set_userinfo
  def set_userinfo
    self.init
    self.login
    self.info
  end

  def init
    url = 'http://jkyy2.aycgs.com:8080/Login.aspx'
    rsp = HTTParty.get(url)
    self.cookie = HTTParty::CookieHash.new
    self.cookie.add_cookies rsp.headers['set-cookie'] unless rsp.headers['set-cookie'].blank?
    doc = Nokogiri::HTML(rsp.body)
    self.refresh_params(doc)
  end
  def refresh_cookie cookie_str
    self.cookie.add_cookies cookie_str unless cookie_str.blank?
  end
  def login
    url = 'http://jkyy2.aycgs.com:8080/Login.aspx'
    hash = {txtSfzmhm: account, txtUserPwd: pwd,
            __VIEWSTATE: self.__VIEWSTATE,
            __VIEWSTATEGENERATOR: self.__VIEWSTATEGENERATOR,
            __EVENTVALIDATION: self.__EVENTVALIDATION,
            __EVENTTARGET: self.__EVENTTARGET,
            __EVENTARGUMENT: self.__EVENTARGUMENT,
            btnLogin: '登录'}
    puts 'logining'
    #rsp = HTTParty.post(url, :body => hash, :headers => {'Cookie' => self.cookie.to_cookie_string})
    #puts rsp.body
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.initialize_http_header({"Cookie" => self.cookie.to_cookie_string})
    request.set_form_data(hash)
    response = http.request(request)
    self.refresh_cookie(response['set-cookie'])
    puts response.body
    response
  end

  def info
    url = 'http://jkyy2.aycgs.com:8080/student/studentdetail.aspx'
    rsp = HTTParty.get(url, headers: {'Cookie' => self.cookie.to_cookie_string})
    doc = Nokogiri::HTML(rsp.body)
    self.refresh_params(doc)
    self.refresh_cookie(rsp['set-cookie'])

    self.user_info = UserInfo.new
    self.user_info.user_id = self.id

    tds = doc.css('.TextTable table td')
    tds.each_with_index do |dom, index|
      case dom.content.strip.gsub(' ','')
        # when '身份证号：'   ; self.user_info.idcard      = tds[index + 1].content.strip
        when '姓名：'      ; self.user_info.name        = tds[index + 1].content.strip
        when '性别：'      ; self.user_info.sex         = tds[index + 1].content.strip
        when '出生日期：'   ; self.user_info.birth       = tds[index + 1].content.strip
        when '登记地址：'   ; self.user_info.reg_addr    = tds[index + 1].content.strip
        when '电话：'      ; self.user_info.mobile      = tds[index + 1].content.strip
        when '联系地址：'   ; self.user_info.cont_addr   = tds[index + 1].content.strip
        when '考试车型：'   ; self.user_info.che_xing    = tds[index + 1].content.strip
        when '状态：'      ; self.user_info.status      = tds[index + 1].content.strip
        when '有效期始：'   ; self.user_info.valid_start = tds[index + 1].content.strip
        when '有效期止：'   ; self.user_info.valid_end   = tds[index + 1].content.strip
        when '驾校：'      ; self.user_info.school      = tds[index + 1].content.strip
        when '流水号：'    ; self.user_info.flow_no     = tds[index + 1].content.strip
      end if dom.attr('class') == 'TableTitle'
    end
    self.user_info.save
  end
  def list
    url = 'http://jkyy2.aycgs.com:8080/Preasign/QueryPn.aspx?t=y'
    rsp = HTTParty.get(url, headers: {'Cookie' => self.cookie.to_cookie_string})
    doc = Nokogiri::HTML(rsp.body)
    self.refresh_params(doc)
    self.refresh_cookie(rsp['set-cookie'])

    ret = []
    doc.css('.ListTable tr').each do |dom|
      tds = dom.css('td')
      next if tds[0].attr('class') == 'TableTitleCenter'
      ret.push({ 'date'      => tds[0].content.strip,
                 'type'      => tds[1].content.strip,
                 'location'  => tds[2].content.strip,
                 'count'     => tds[3].content.strip,
                 'leftcount' => tds[4].content.strip,
                 'time'      => tds[5].content.strip,
                 'canop'     => (tds[6].css('a')[0].attr('href') rescue '').gsub('javascript:__doPostBack(', '').gsub(')', '').gsub('\'', '')
               })
    end
    ret
  end
  def refresh_params(doc)
    self.__VIEWSTATE = doc.css('#__VIEWSTATE')[0].attr('value') rescue ''
    self.__VIEWSTATEGENERATOR = doc.css("#__VIEWSTATEGENERATOR")[0].attr('value') rescue ''
    self.__EVENTVALIDATION = doc.css("#__EVENTVALIDATION")[0].attr('value') rescue ''
    self.__EVENTTARGET = doc.css("#__EVENTTARGET")[0].attr('value') rescue ''
    self.__EVENTARGUMENT = doc.css("#__EVENTARGUMENT")[0].attr('value') rescue ''

    puts (self.__VIEWSTATE)
  end
end
