class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :items, through: :order_items

  validates_presence_of :status

  def total_items_for_merchant(merchant)
    order_items.joins(:item)
               .where(items: { user: merchant })
               .sum(:quantity)
  end

  def total_value_for_merchant(merchant)
    order_items.joins(:item)
               .where(items: { user: merchant })
               .sum('(order_items.quantity * order_items.unit_price)')
  end

  def self.top_states
    joins(:users)
    .where(status: 'completed')
    

  end

  def self.pending_orders(merchant)
    self.joins(:items)
        .where(status: 'pending', items: { user: merchant })
        .group(:id)
  end

  def quantity_of_items
    order_items.sum(:quantity)
  end

  def grand_total
    order_items.select("SUM(order_items.unit_price*order_items.quantity) as price_per_item")
              .group(:order_id)[0].price_per_item
  end
end
