describe Rouge::Lexers::Elixir do
  let(:subject) { Rouge::Lexers::Elixir.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.ex'
      assert_guess :filename => 'foo.exs'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/x-elixir'
      assert_guess :mimetype => 'application/x-elixir'
    end
  end

  describe 'lexing' do
    include Support::Lexing

    it 'lexes double colon as punctuation' do
      assert_tokens_equal 'Elixir::Builtin',
        ['Name.Constant', 'Elixir'],
        ['Punctuation',   '::'],
        ['Name.Constant', 'Builtin']
    end

    it 'lexes keywords without following whitespaces' do
      assert_tokens_equal %{cond do\nend},
        ['Keyword', 'cond'],
        ['Text',    ' '],
        ['Keyword', 'do'],
        ['Text',    "\n"],
        ['Keyword', 'end']
    end

    it 'lexes bitwise operators' do
      assert_tokens_equal %{~~~1\n2&&&3},
        ['Operator', '~~~'],
        ['Literal.Number', '1'],
        ['Text', "\n"],
        ['Literal.Number', '2'],
        ['Operator', '&&&'],
        ['Literal.Number', '3']
    end
  end
end
