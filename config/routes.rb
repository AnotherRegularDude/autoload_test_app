# frozen_string_literal: true

Rails.application.routes.draw do
  get "first", to: "application#first"
  get "second", to: "application#second"
end
