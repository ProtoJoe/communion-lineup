class CreateCovidLineup < ActiveRecord::Migration[6.1]
  def change
    create_table :covid_lineups do |t|
      t.date    :service_date
      t.string  :position_1
      t.string  :position_2
      t.string  :position_3
      t.string  :position_4
      t.string  :position_5
      t.string  :position_6
      t.string  :position_7
      t.string  :position_8

      t.timestamps
    end
  end
end
