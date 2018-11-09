class InstallPostgisExtension < ActiveRecord::Migration[5.2]
  def up
    enable_extension 'postgis'
  end
end
