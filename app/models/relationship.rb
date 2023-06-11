class Relationship < ApplicationRecord
    belongs_to :follower, class_name: "User" #フォローしてくれる人
    belongs_to :followed, class_name: "User" #フォローされる人
end
