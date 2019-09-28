# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def first
    render json: { modules: FirstModule.modules }
  end

  def second
    render json: { SecondModule.name => ThirdModule.name }
  end
end
