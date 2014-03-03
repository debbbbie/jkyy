class Order < ActiveRecord::Base
  STATUS_NORMAL = 0
  STATUS_SUCCESS = 1
  STATUS_CANCEL = 2

  TYPE_C1_1 = 1
  TYPE_C1_2 = 2
  TYPE_C1_3 = 3
  TYPE_C1_4 = 4
  belongs_to :user

  def type_str
    case yuyue_type
      when 1; '科目1'
      when 2; '科目2'
      when 3; '科目3'
      when 4; '科目4'
    end
  end
  def yuyue_at_str
    case yuyue_at
      when '1'; '星期1'
      when '2'; '星期2'
      when '3'; '星期3'
      when '4'; '星期4'
      when '5'; '星期5'
    end
  end
end
