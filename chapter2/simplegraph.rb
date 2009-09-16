require 'csv'

class SimpleGraph
  def initialize
    @spo = {}
    @pos = {}
    @osp = {}
  end
  
  def add(sub, pred, obj)
    add_to_index(@spo, sub,  pred, obj)
    add_to_index(@pos, pred, obj,  sub)
    add_to_index(@osp, obj,  sub,  pred)
  end
  
  def add_to_index(index, a, b, c)
    unless index.include?(a)
      index[a] = {b => [c]}
    else
      unless index[a].include?(b)
        index[a][b] = [c]
      else
        index[a][b] << c
      end
    end
  end
  private :add_to_index
  
  def remove(sub, pred, obj)
    triples(sub, pred, obj).each do |del_sub, del_pred, del_obj|
      remove_from_index(@spo, del_sub,  del_pred, del_obj)
      remove_from_index(@pos, del_pred, del_obj,  del_sub)
      remove_from_index(@osp, del_obj,  del_sub,  del_pred)
    end
  end
    
  def remove_from_index(index, a, b, c)
    begin
      bs = index[a]
      cset = bs[b]
      cset.remove(c)
      bs.delete(b) if cset.size == 0
      index.delete(a) if bs.size == 0
    rescue 
    end
  end
  private :remove_from_index
  
  def triples(sub, pred, obj)
    unless block_given?
      ary = []
      triples(sub, pred, obj) {|x| ary << x }
      return ary
    end
    begin
      if sub and pred and obj  # sub pred obj
        if @spo[sub][pred].include?(obj) 
          yield [sub, pred, obj]
        end
      elsif sub and pred       # sub pred nil
        @spo[sub][pred].each do |ret_obj|
          yield [sub, pred, ret_obj]
        end
      elsif sub and obj        # sub nil obj
        @osp[obj][sub].each do |ret_pred|
          yield [sub, ret_pred, obj]
        end
      elsif sub                # sub nil nil
        @spo[sub].each do |ret_pred, ret_objs|
          ret_objs.each do |ret_obj|
            yield [sub, ret_pred, ret_obj]
          end
        end
      elsif pred and obj       # nil pred obj
        @pos[pred][obj].each do |ret_sub|
          yield [ret_sub, pred, obj]
        end
      elsif pred               # nil pred nil
        @pos[pred].each do |ret_obj, ret_subs|
          ret_subs.each do |ret_sub|
            yield [ret_sub, pred, ret_obj]
          end
        end
      elsif obj                # nil nil obj
        @osp[obj].each do |ret_sub, ret_preds|
          ret_preds.each do |ret_pred|
            yield [ret_sub, ret_pred, obj]
          end
        end
      else                     # nil nil nil
        @spo.each do |ret_sub, ret_preds|
          ret_preds.each do |ret_pred, ret_objs|
            ret_objs.each do |ret_obj|
              yield [ret_sub, ret_pred, ret_obj]
            end
          end
        end
      end          
    rescue
    end
  end

  
  def value(sub = nil, pred = nil, obj = nil)
    triples(sub, pred, obj) do |ret_sub, ret_pred, ret_obj|
      return ret_sub  unless sub
      return ret_pred unless pred
      return ret_obj  unless obj
      break
    end
    return nil
  end

  def load(file_name)
    CSV.open(file_name, 'r').each do |sub, pred, obj|
      add(sub, pred, obj)
    end
  end

  def save(file_name)
    CSV.open(file_name, 'w').each do |f|
      triples(nil, nil, nil).each do |row|
        f << row
      end
    end
  end
end
  

if __FILE__ == $0
  g = SimpleGraph.new
  g.add("blade_runner", "name", "Blade Runner")
  g.add("blade_runner", "name", "Blade Runner")
  g.add("blade_runner", "release_date", "June 25, 1982")
  g.add("blade_runner", "directed_by", "Ridley Scott")

  puts
  p g.triples(nil, nil, nil)
  puts
  p g.triples("blade_runner", nil, nil)
  puts
  p g.triples("blade_runner", "name", nil)
  puts
  p g.triples("blade_runner", "name", "Blade Runner")
  puts
  p g.triples("blade_runner", nil, "Blade Runner")
  puts
  p g.triples(nil, "name", "Blade Runner")
  puts
  p g.triples(nil, nil, "Blade Runner")
  puts
  p g.triples("foo", "name", "Blade Runner")
  puts
  p g.triples("blade_runner", "foo", "Blade Runner")
  puts
  p g.triples("blade_runner", "name", "foo")
end

