class Device < ApplicationRecord
    has_many :heartbeats
    has_many :reports
    validates :phone_number, phone: true
    validates :carrier, presence: true

    def disabled?
        !!self.disabled_at
    end
end
