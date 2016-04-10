ActiveAdmin.register Book do
  permit_params :title, :isbn, :published_date, author_books_attributes: [:author_id, :_destroy, :id]
  filter :authors_name_eq, label: I18n.t('activerecord.attributes.author.name'), as: :select, collection: Author.all.map { |a| [a.name, a.name] }
  filter :title
  filter :isbn
  filter :published_date

  index title: I18n.t('activerecord.models.book') + '一覧' do
    column I18n.t('activerecord.attributes.book.title'), :title
    column I18n.t('activerecord.attributes.book.isbn'), :isbn
    column I18n.t('activerecord.attributes.book.published_date'), :published_date
    column I18n.t('activerecord.attributes.author.name') do |book|
      Author.where(id: AuthorBook.where(book_id: book.id).all.pluck(:author_id)).all.pluck(:name).join(', ')
    end
    actions
  end

  form do |f|
    f.inputs I18n.t('activerecord.models.book') + '登録' do
      f.input :title
      f.input :isbn
      f.input :published_date
      f.has_many :author_books, allow_destroy: true, heading: false,
                                new_record: true do |ab|
        ab.input :author_id,
                 label: I18n.t('activerecord.attributes.author.name'),
                 as: :select,
                 collection: Author.all.map { |a| [a.name, a.id] }
      end
      f.actions
    end
  end

  show do
    attributes_table do
      row I18n.t('activerecord.attributes.book.title') do
        resource.title
      end
      row I18n.t('activerecord.attributes.book.isbn') do
        resource.isbn
      end
      row I18n.t('activerecord.attributes.book.published_date') do
        resource.published_date
      end
      row I18n.t('activerecord.attributes.author.name') do
        Author.where(id: AuthorBook.where(book_id: resource.id).all.pluck(:author_id)).all.pluck(:name).join(', ')
      end
    end
  end
end
