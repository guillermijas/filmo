# frozen_string_literal: true

every 1.day, at: '7am' do
  rake 'cluster:cluster_id'
end
