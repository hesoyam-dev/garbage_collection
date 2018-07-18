require_relative 'obj'
require 'pry'

module GarbageCollection

  # [white, grey, black]

  def start
    mark # marking collection
    divide # diviing object on two classes newest and elder objects
    if @new_objs.length > @old_objs.length
      puts "Badly / Prepare to STW (stop the world) / Running Major GC"
      sleep 5
      major_gc
    else
      puts "All is good / Enought space / Running Minor GC"
      minor_gc
    end
  end

  def mark
    @marked = objects_collection.each do |obj|
      obj.busy ? obj.instance_variable_set(:@color, "black") : obj.instance_variable_set(:@color, "white")
    end
  end

  def divide
    @new_objs, @old_objs = @marked.partition { |e| e.created_at.day > (Time.now - 86400).day }
  end

  def minor_gc
    lazy_sweep(@new_objs)
  end

  def major_gc
    lazy_sweep(@marked)
  end

  def lazy_sweep(objects)
    objects.delete_if { |obj| !obj.busy }
  end

  protected

  def objects_collection
    objs = []
    10.times do
      objs << Obj.new(busy: true)
    end
    10.times do
      objs << Obj.new(busy: false)
    end
    objs.shuffle
  end

end
