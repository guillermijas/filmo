# frozen_string_literal: true

namespace :cluster do
  task cluster_users: :environment do
    r_script = Rails.root.join('lib', 'assets', 'cluster_users.R')
    R.eval(`cat #{r_script}`)
    cluster_users = R.cluster_users
    R.quit
    Cluster.destroy_all
    cluster_users.each_with_index { |cluster, index|
      Cluster.create(user_id: index.to_i + 1, cluster: cluster)
    }
  end
end