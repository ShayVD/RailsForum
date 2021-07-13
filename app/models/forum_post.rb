# == Schema Information
#
# Table name: forum_posts
#
#  id              :bigint           not null, primary key
#  body            :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  forum_thread_id :integer
#  user_id         :integer
#
class ForumPost < ApplicationRecord
    belongs_to :user
    belongs_to :forum_thread

    validates :body, presence: true

    def send_notifications!
        users = forum_thread.users.uniq - [user]
        # TODO: Send an email to each of those users
        users.each do |user|
            NotificationMailer.forum_post_notification(user, self).deliver_later
        end
    end
end
