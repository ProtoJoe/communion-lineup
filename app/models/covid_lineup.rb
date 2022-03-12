class CovidLineup < ApplicationRecord
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
  end
end
