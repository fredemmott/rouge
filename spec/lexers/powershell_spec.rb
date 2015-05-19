# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Powershell do
  let(:subject) { Rouge::Lexers::Powershell.new }

  include Support::Lexing
  it 'parses a basic shell string' do
    tokens = subject.lex('foo=bar').to_a
    assert { tokens.size == 3 }
    assert { tokens.first[0] == Token['Name.Variable'] }
  end

  it 'parses case statements correctly' do
    assert_no_errors <<-sh
      case $foo in
        a) echo "LOL" ;;
      esac
    sh
  end

  it 'parses case statement with globs correctly' do
    assert_no_errors <<-sh
      case $foo in
        a[b]) echo "LOL" ;;
      esac
    sh
  end

  it 'parses comments correctly' do
    tokens = subject.lex('foo=bar # this is a comment').to_a
    assert { tokens.size == 4 }
    assert { tokens.last[0] == Token['Comment'] }
  end


  it 'does not confuse a prompt with a variable' do
    tokens = subject.lex('$foo').to_a
    assert { tokens.size == 1 }
    assert { tokens.first[0] == Token['Name.Variable'] }
  end

  it 'does not confuse a prompt with a comment' do
    tokens = subject.lex('# commentaire').to_a
    assert { tokens.size == 1 }
    assert { tokens.first[0] == Token['Comment'] }
  end

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.ps1'
      assert_guess :filename => 'foo.psm1'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'application/x-powershell'
    end

    it 'guesses by source' do
      assert_guess :source => '#!/bin/bash'
      assert_guess :source => '   #!   /bin/bash'
      assert_guess :source => '#!/usr/bin/env bash'
      assert_guess :source => '#!/usr/bin/env bash -i'
      deny_guess   :source => '#!/bin/smash'
      # not sure why you would do this, but hey, whatevs
      deny_guess   :source => '#!/bin/bash/python'
    end
  end
end
