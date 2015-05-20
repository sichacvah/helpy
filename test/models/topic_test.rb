# == Schema Information
#
# Table name: topics
#
#  id               :integer          not null, primary key
#  forum_id         :integer
#  user_id          :integer
#  name             :string
#  posts_count      :integer          default(0), not null
#  waiting_on       :string           default("admin"), not null
#  last_post_date   :datetime
#  closed_date      :datetime
#  last_post_id     :integer
#  current_status   :string           default("new"), not null
#  private          :boolean          default(FALSE)
#  assigned_user_id :integer
#  cheatsheet       :boolean          default(FALSE)
#  points           :integer          default(0)
#  post_cache       :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  should belong_to(:forum)
  should belong_to(:user)
  should have_many(:posts)
  should validate_presence_of(:name)



#forum 1 should exist and be private
#forum 2 should exist and be private

#private posts should go in forum 1
# trashed posts should go in forum 2
# a closed topic should have a closed on date
# a closed topic should be unassigned

  test "to_param" do
    assert Topic.find(1).to_param == "1-Pending-private-topic"
  end


  test "a new topic should cache the creators name" do

    @user = User.first
    @topic = Topic.create(forum_id: 1, name: "Test topic", user_id: @user.id)

    assert @topic.user_name = @user.name

  end

  test "trashed messages should be in forum 2, and unassigned" do

    Topic.all.each do |topic|

      topic.trash

      assert topic.assigned_user_id.nil?
      assert topic.forum_id == 2
      assert topic.private == true
      assert topic.current_status == 'trash'
      assert_not_nil topic.closed_date

    end
  end

  test "closed messages should be unassigned" do

    Topic.all.each do |topic|

      topic.close

      assert topic.assigned_user_id.nil?
      assert topic.current_status == 'closed'
      assert_not_nil topic.closed_date

    end
  end


end