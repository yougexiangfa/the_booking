class RailsBookingInit < ActiveRecord::Migration[5.0]

  def change
  
    create_table :rooms do |t|
      t.references :organ
      t.string :room_number
      t.integer :limit_number
      t.string :color
      t.integer :time_plans_count, default: 0
      t.timestamps
    end
  
    create_table :time_lists do |t|
      t.references :organ  # For SaaS
      t.string :name
      t.string :code
      t.integer :interval_minutes
      t.integer :item_minutes
      t.boolean :default
      t.timestamps
    end

    create_table :time_items do |t|
      t.references :time_list
      t.time :start_at
      t.time :finish_at
      t.integer :position, default: 1
      t.timestamps
    end

    create_table :plan_events do |t|
      t.references :time_list
      t.references :event, polymorphic: true
      t.references :room
      t.date :begin_on
      t.string :repeat_type  # 日、周、月、天
      t.integer :repeat_count # 每几周
      t.integer :repeat_days, array: true
      t.timestamps
    end
    
    create_table :plan_items do |t|
      t.references :time_plan
      t.references :time_list
      t.references :time_item
      t.references :room
      t.date :plan_on
      t.string :repeat_index
      t.integer :time_bookings_count, default: 0
      if connection.adapter_name == 'PostgreSQL'
        t.jsonb :extra
      else
        t.json :extra
      end
      t.timestamps
    end

    create_table :plan_attenders do |t|
      t.references :time_plan
      t.references :plan_item
      t.references :attender, polymorphic: true
      t.references :room
      t.boolean :attended
      t.string :state
      if connection.adapter_name == 'PostgreSQL'
        t.jsonb :extra
      else
        t.json :extra
      end
      t.timestamps
    end

    create_table :time_bookings do |t|
      t.references :booker, polymorphic: true
      t.references :booked, polymorphic: true
      t.references :plan_item
      t.references :time_item
      t.references :time_list
      t.references :room
      t.date :booking_on
      t.timestamps
    end
    
  end

end
