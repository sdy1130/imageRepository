class Image < ApplicationRecord
    belongs_to :user
    has_rich_text :description
    has_one_attached :file
    validates :title, presence: true
    validates :description, presence: true

    def get_month
        month = self.created_at.month
        month_string = ""

        if (month == 1)
            month_string = "JAN"
        elsif (month == 2)
            month_string = "FEB"
        elsif (month == 3)
            month_string = "MAR"
        elsif (month == 4)
            month_string = "APR"
        elsif (month == 5)
            month_string = "MAY"
        elsif (month == 6)
            month_string = "JUN"
        elsif (month == 7)
            month_string = "JUL"
        elsif (month == 8)
            month_string = "AUG"
        elsif (month == 9)
            month_string = "SEP"
        elsif (month == 10)
            month_string = "OCT"
        elsif (month == 11)
            month_string = "NOV"
        else
            month_string = "DEC"
        end
        return month_string
    end
end
