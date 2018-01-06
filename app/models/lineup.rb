class Lineup < ApplicationRecord
  before_validation :normalize_names

  private

  def normalize_name(name)
    name.strip.squeeze(' ')
  end

  def normalize_names
    self.position_1 = normalize_name(self.position_1)
    self.position_2 = normalize_name(self.position_2)
    self.position_3 = normalize_name(self.position_3)
    self.position_4 = normalize_name(self.position_4)
    self.position_5 = normalize_name(self.position_5)
    self.position_6 = normalize_name(self.position_6)
    self.position_7 = normalize_name(self.position_7)
    self.position_8 = normalize_name(self.position_8)
    self.position_9 = normalize_name(self.position_9)
    self.position_10 = normalize_name(self.position_10)
    self.position_11 = normalize_name(self.position_11)
    self.position_12 = normalize_name(self.position_12)
    self.position_13 = normalize_name(self.position_13)
    self.position_14 = normalize_name(self.position_14)
    self.position_15 = normalize_name(self.position_15)
    self.position_16 = normalize_name(self.position_16)
    self.position_17 = normalize_name(self.position_17)
    self.position_18 = normalize_name(self.position_18)
  end
end
