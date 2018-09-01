class ReportService

  def self.create_report(start_date, end_date)
    @start_date = start_date.to_time
    @end_date = end_date.to_time
    rows = []

    User.find_each do |user|
      posts = Post.by_date(@start_date, @end_date).where(user: user).count
      comments = Comment.by_date(@start_date, @end_date).where(user: user).count

      rows << {
          nickname: user.nickname,
          email: user.email,
          posts: posts,
          comments: comments
      }
    end
    rows.sort_by! { |hash| -(hash[:posts] + hash[:comments])/10 }
  end

end