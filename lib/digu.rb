#!/usr/bin/env ruby
#
# == Description
#   
#   This is a client library of digu.com  for post messages, will add more features later...
#
# == Example
#   
#   digu = Digu.new.login 'user', 'pass'
#   if digu.login?
#       if digu.post 'I like this'
#           puts "Your message has posted to digu.com"
#       end
#       digu.logout
#   end
#
# == Version
#   
#   v0.2
#
# == Author
#
#   xianhua.zhou<xianhua.zhou@gmail.com>
#
#

require 'rubygems'
require 'http_request'

class Digu
    VERSION = '0.2'
    BASE_DIGU_URL = 'http://digu.com'

    def initialize
        @http = http.get home_url
    end

    def login(username, password, change_account = false)
        if login?
            if change_account
                logout
            else
               return true
            end
        end
        @username, @password = username, password
        @http = http.post(
            :url => login_url,
            :parameters => {
            :backActionId  => '/home',
            :action        => 1,
            :userName      => @username,
            :password      => @password
        },
            :cookies => @http.cookies
        )
    end

    def login?
        @http.body.include?('isLogin:true') and @http.body.include?(@username)
    end

    def post(message)
        @http = http.get(:url => home_url, :cookies => @http.cookies)

        @http.body.scan(/name="type"\svalue="([0-9]+)"/)
        type = $1

        @http.body.scan(/name="cookieId"\svalue="([0-9]+)"/)
        cookie_id = $1

        #@http.body.scan(/name="postLawless"\svalue="(.+?)"/)
        #post_law_less = $1

        @http.body.scan(/name="groupId"\svalue="([0-9]+)"/)
        group_id = $1

        #@http.body.scan(/name="writeSloganTitle"\svalue="(.+?)"/)
        #wrie_slogan_title = $1

        @http = http.post(:url => post_message_url,
            :parameters => {
                :cookieId => cookie_id,
                :type => type,
                :group_id => group_id,
                :text => message
            },
            :cookies => http.cookies
        )
        @http.body.include? 'success'
    end

    def logout
        http.get logout_url
    end

    private

    def url(path)
       "#{BASE_DIGU_URL}/#{path}"
    end

    def login_url
       url "login"
    end

    def logout_url
       url "logout"
    end

    def home_url
       url "home"
    end

    def post_message_url
       url "/jump?aid=addLekuData"
    end

    def http
        ::HttpRequest
    end
end

if __FILE__ == $0
   digu = Digu.new
   puts digu.post 'hello world' if digu.login(ARGV[0] || 'username', ARGV[1] || 'password')
   digu.logout if digu.login?
end
