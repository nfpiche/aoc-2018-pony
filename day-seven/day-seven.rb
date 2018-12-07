require 'set'
require 'pry'

class AdjacencyGraph
  attr_reader :completed, :requirement_graph, :dependency_graph, :queue, :answer

  def initialize(file_name)
    @completed = Set[]
    @requirement_graph = {}
    @dependency_graph = {}
    @requirement_graph.default_proc = -> (h, k) { h[k] = SortedSet.new([]) }
    @dependency_graph.default_proc = -> (h, k) { h[k] = SortedSet.new([]) }
    @queue = SortedSet.new([])
    @workers = [nil, nil, nil, nil, nil]
    build(file_name)
  end

  def solve
    current = queue.first
    queue.delete(current)
    completed.add(current)
    answer = "#{current}"

    until current.nil?
      searchables = dependency_graph[current]
      queue.merge(searchables)
      current = determine_next
      answer += current.to_s
      queue.delete(current)
      completed.add(current)
    end

    @answer = answer
  end

  def solve2
    current_second = 0

    loop do
      @workers.map! do |worker|
        task, time = worker
        if time == current_second
          completed.add(task)
          searchables = dependency_graph[task]
          queue.merge(searchables)
          nil
        else
          worker
        end
      end

      @workers.map! do |worker|
        task = determine_next

        if !worker.nil? || task.nil?
          worker
        else
          queue.delete(task)
          time = work_for(task, current_second)
          [task, time]
        end
      end

      break if queue.empty? && @workers.all?(&:nil?)
      current_second += 1
    end

    @answer = current_second
  end

  private

  def build(file_name)
    File.open(file_name).each do |line|
      parent, child = line.match(/Step (.*) must.* step (.*) can.*/).captures

      insert_nodes(parent, child)
    end
    determine_starting_queue
  end

  def determine_next
    check = nil
    visitable = false
    q = queue.to_a
    i = 0

    until visitable || i == q.length
      check = q[i]
      visitable = completed.superset?(requirement_graph[check])
      i += 1
    end

    visitable ? check : nil
  end

  def determine_starting_queue
    requirement_graph.keys.each { |k| queue.delete(k) }
  end

  def insert_nodes(parent, child)
    requirement_graph[child] << parent
    dependency_graph[parent] << child
    queue.add(parent)
  end

  def work_for(task, current_time)
    current_time + 60 + (task.ord - 64)
  end
end

class Node
  attr_reader :value

  def initialize(value)
    @value = value
  end
end

part = ARGV[0]
a = AdjacencyGraph.new("./input.txt")

if part == "1"
  a.solve
  p a.answer
elsif part == "2"
  a.solve2
  p a.answer
else
  raise "Use 1 or 2 plz"
end
