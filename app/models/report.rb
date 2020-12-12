class Report < ApplicationRecord
    belongs_to :device
    validate :device_is_not_disabled

    def device_is_not_disabled
        if self.device && self.device.disabled
            self.errors.add(:device, "Device is disabled")
        end
    end
end
