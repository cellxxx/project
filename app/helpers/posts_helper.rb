# frozen_string_literal: true

module PostsHelper

    def comment_author(comment_id)
        Comment.find(comment_id ).username
    end

    def comment_created_at(comment_id)
        Comment.find(comment_id ).created_at
    end

    
    def comment_text(comment_id)
        Comment.find(comment_id ).content
    end


end
