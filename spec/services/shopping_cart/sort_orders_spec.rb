module ShoppingCart
  RSpec.describe SortOrdersService do
    let(:order) { create(:order) }
    subject { SortOrdersService.new(:in_progress, order) }

    describe '#initialize' do
      it 'assigns sort type to @sort_type' do
        expect(subject.instance_variable_get(:@sort_type)).to eq(:in_progress)
      end

      it 'assigns order to @orders' do
        expect(subject.instance_variable_get(:@orders)).to eq(order)
      end
    end

    describe '#sort_orders' do
      it 'call in_progress scope' do
        expect(subject.instance_variable_get(:@orders)).to receive(:in_progress)
        subject.sort_orders
      end

      context 'when sort type nil' do
        it 'should sort by default wit All' do
          subject = SortOrdersService.new(nil, order)
          expect(subject.instance_variable_get(:@orders)).to receive(:all)
          subject.sort_orders
        end
      end
    end

    describe '#choose_title' do
      it 'return scope title' do
        expect(subject.choose_title).to eq("In Progress")
      end
    end
  end
end