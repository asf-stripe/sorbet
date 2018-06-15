# typed: strict
# MutableContext::permitOverloadDefinitions is aware of this file name. Don't rename this file.
class HasOverloads
  sig
  .returns(T.untyped())
  def make_untyped
  end

  sig
  .returns(Integer)
  sig(
    _: String,
  )
  .returns(String)
  sig(
      _: Exception,
    )
  .returns(NilClass)
  sig(
    _: Class,
    _1: String,
    _2: T::Array[String],
  )
  .returns(Symbol)
  def overloaded(_=_, _1=_, _2=_);
    make_untyped
  end

  sig(
    a: Class,  # error: Malformed `sig`
    b: String, # error: Malformed `sig`
  )
  .returns(Integer)
  sig(
    b: Class,  # error: Malformed `sig`
    a: String, # error: Malformed `sig`
  )
  .returns(Symbol)
  def invalid_overloaded(a:, b:);
    make_untyped
  end
end

class OverloadAndGenerics
  extend T::Generic
  Elem = type_member

  def _; end

  sig(x: Elem).returns(Elem)
  sig(x: String).returns(String)
  def overloaded(x); _; end
end

class Foo
  def test
    h = HasOverloads.new
    T.assert_type!(h.overloaded(), Integer)
    T.assert_type!(h.overloaded("s"), String)
    T.assert_type!(h.overloaded(Exception.new), NilClass)
    T.assert_type!(h.overloaded(self.class), Symbol)
    h.overloaded(1) # error: `Integer(1)` doesn't match `String` for argument `_`
                    # should ask for string
    h.overloaded("1", 2) # error: MULTI

    g = OverloadAndGenerics[Integer].new
    T.assert_type!(g.overloaded("hi"), String)
    T.assert_type!(g.overloaded(4), Integer)
  end
end
