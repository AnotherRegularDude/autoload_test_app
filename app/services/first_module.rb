# frozen_string_literal: true

module FirstModule
  MODULE_ARR = [SecondModule, ThirdModule].freeze

  def self.modules
    MODULE_ARR
  end
end
