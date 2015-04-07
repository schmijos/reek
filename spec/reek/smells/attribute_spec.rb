require_relative '../../spec_helper'
require_relative '../../../lib/reek/smells/attribute'
require_relative '../../../lib/reek/core/module_context'
require_relative 'smell_detector_shared'

describe Reek::Smells::Attribute do
  before :each do
    @source_name = 'dummy_source'
    @detector = build(:smell_detector, smell_type: :Attribute, source: @source_name)
  end

  it_should_behave_like 'SmellDetector'

  context 'with no attributes' do
    it 'records nothing in the module' do
      src = 'module Fred; end'
      ctx = Reek::Core::CodeContext.new(nil, Reek::Source::SourceCode.from(src).syntax_tree)
      expect(@detector.examine_context(ctx)).to be_empty
    end
  end

  context 'with one attribute' do
    before :each do
      @attr_name = 'super_thing'
    end

    shared_examples_for 'one attribute found' do
      before :each do
        ctx = Reek::Core::CodeContext.new(nil, Reek::Source::SourceCode.from(@src).syntax_tree)
        @smells = @detector.examine_context(ctx)
      end

      it 'records only that attribute' do
        expect(@smells.length).to eq(1)
      end

      it 'reports the attribute name' do
        expect(@smells[0].parameters[:name]).to eq(@attr_name)
      end

      it 'reports the declaration line number' do
        expect(@smells[0].lines).to eq([1])
      end

      it 'reports the correct smell class' do
        expect(@smells[0].smell_category).to eq(described_class.smell_category)
      end

      it 'reports the context fq name' do
        expect(@smells[0].context).to eq('Fred')
      end
    end

    context 'declared in a class' do
      before :each do
        @src = "class Fred; attr :#{@attr_name}; end"
      end

      it_should_behave_like 'one attribute found'
    end

    context 'reader in a class' do
      before :each do
        @src = "class Fred; attr_reader :#{@attr_name}; end"
      end

      it_should_behave_like 'one attribute found'
    end

    context 'writer in a class' do
      before :each do
        @src = "class Fred; attr_writer :#{@attr_name}; end"
      end

      it_should_behave_like 'one attribute found'
    end

    context 'accessor in a class' do
      before :each do
        @src = "class Fred; attr_accessor :#{@attr_name}; end"
      end

      it_should_behave_like 'one attribute found'
    end

    context 'declared in a module' do
      before :each do
        @src = "module Fred; attr :#{@attr_name}; end"
      end

      it_should_behave_like 'one attribute found'
    end

    context 'reader in a module' do
      before :each do
        @src = "module Fred; attr_reader :#{@attr_name}; end"
      end

      it_should_behave_like 'one attribute found'
    end

    context 'writer in a module' do
      before :each do
        @src = "module Fred; attr_writer :#{@attr_name}; end"
      end

      it_should_behave_like 'one attribute found'
    end

    context 'accessor in a module' do
      before :each do
        @src = "module Fred; attr_accessor :#{@attr_name}; end"
      end

      it_should_behave_like 'one attribute found'
    end
  end
end
