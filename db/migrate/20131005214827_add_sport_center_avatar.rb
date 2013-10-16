class AddSportCenterAvatar < ActiveRecord::Migration

  def change
    add_column :sport_centers, :avatar, :string
  end

end
