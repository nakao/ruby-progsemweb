require 'test/unit'
require 'simplegraph.rb'

class TestSimpleGraph < Test::Unit::TestCase
  def test_new
    o = SimpleGraph.new
    assert(o)
  end
  
  def test_add
    o = SimpleGraph.new
    o.add('sub', 'pred', 'obj')
    assert(o)
  end

  def test_pos
    o = SimpleGraph.new
    o.add('sub', 'pred', 'obj')
    assert_equal({'pred' => {'obj' => ['sub']}}, o.instance_eval { @pos })
  end

  def test_osp
    o = SimpleGraph.new
    o.add('sub', 'pred', 'obj')
    assert_equal({'obj' => {'sub' => ['pred']}}, o.instance_eval { @osp })
  end

  def test_spo
    o = SimpleGraph.new
    o.add('sub', 'pred', 'obj')
    assert_equal({'sub' => {'pred' => ['obj']}}, o.instance_eval { @spo })
  end

  def test_value_obj
    o = SimpleGraph.new
    o.add('sub', 'pred', 'obj')
    assert_equal('obj', o.value('sub', 'pred', nil)) 
  end

  def test_value_sub
    o = SimpleGraph.new
    o.add('sub', 'pred', 'obj')
    assert_equal('sub', o.value(nil, 'pred', 'obj')) 
  end

  def test_value_pred
    o = SimpleGraph.new
    o.add('sub', 'pred', 'obj')
    assert_equal('pred', o.value('sub', nil, 'obj')) 
  end

  
  
  def test_triples_sub_pred_obj
    o = SimpleGraph.new
    o.add('sub', 'pred', 'obj')
    assert_equal([['sub', 'pred', 'obj']], o.triples('sub', 'pred', 'obj'))
  end
  
  def test_triples_sub_pred_obj_add
    o = SimpleGraph.new
    o.add('sub', 'pred', 'obj')
    o.add('sub', 'pred', 'obj')
    assert_equal([['sub', 'pred', 'obj']], o.triples('sub', 'pred', 'obj'))
  end

  def test_triples_sub_pred_nil
    o = SimpleGraph.new
    o.add('sub', 'pred', 'obj')
    assert_equal([['sub', 'pred', 'obj']], o.triples('sub', 'pred', nil))
  end

  def test_triples_sub_pred_nil_add
    o = SimpleGraph.new
    o.add('sub', 'pred', 'obj')
    o.add('sub', 'pred', 'obj')
    assert_equal([['sub', 'pred', 'obj']], o.triples('sub', 'pred', nil))
  end

  def test_triples_sub_nil_obj
    o = SimpleGraph.new
    o.add('sub', 'pred', 'obj')
    assert_equal([['sub', 'pred', 'obj']], o.triples('sub', nil, 'obj'))
  end

  def test_triples_sub_nil_nil
    o = SimpleGraph.new
    o.add('sub', 'pred', 'obj')
    assert_equal([['sub', 'pred', 'obj']], o.triples('sub', nil, nil))
  end

  def test_triples_nil_pred_obj
    o = SimpleGraph.new
    o.add('sub', 'pred', 'obj')
    assert_equal([['sub', 'pred', 'obj']], o.triples(nil, 'pred', 'obj'))
  end

  def test_triples_nil_nil_obj
    o = SimpleGraph.new
    o.add('sub', 'pred', 'obj')
    assert_equal([['sub', 'pred', 'obj']], o.triples(nil, nil, 'obj'))
  end

  def test_triples_nil_pred_nil
    o = SimpleGraph.new
    o.add('sub', 'pred', 'obj')
    assert_equal([['sub', 'pred', 'obj']], o.triples(nil, 'pred', nil))
  end

  def test_triples_nil_nil_nil
    o = SimpleGraph.new
    o.add('sub', 'pred', 'obj')
    assert_equal([['sub', 'pred', 'obj']], o.triples(nil, nil, nil))
  end

  def test_load
    o = SimpleGraph.new
    o.load("movies.csv")
    assert_equal([["/en/bad_taste", "name", "Bad Taste"]], o.triples(nil, nil, "Bad Taste"))
  end
  
end

