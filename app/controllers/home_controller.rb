class HomeController < ApplicationController

  def chat
    @messages = [
      "Hello, World", "whats up", "would you like a cookie", "no?", "aw :("
    ].map { |m| { :sender => "drcatmd", :body => m } }
  end

end
