require 'rails_helper'

describe 'Todo管理機能', type: :system do
    let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') }
    let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com') }
    let(:todo_a) { FactoryBot.create(:todo, name: '最初のTodo', user: user_a) }


    before do
        FactoryBot.create(:todo, name: '最初のTodo', user: user_a)
        visit login_path
        fill_in 'メールアドレス', with: login_user.email
        fill_in 'パスワード', with: login_user.password
        click_button 'ログインする'
    end

    shared_examples_for 'ユーザーAが作成したTodoが表示される' do
        it { expect(page).to have_content '最初のTodo' }
    end

    describe '一覧表示機能' do
        context 'ユーザーAがログインしているとき' do
            let(:login_user) { user_a }

            it_behaves_like 'ユーザーAが作成したTodoが表示される'
        end

        context 'ユーザーBがログインしているとき' do
            let(:login_user) { user_b }

            it 'ユーザーAが作成したTodoが表示されない' do
                expect(page).to have_no_content '最初のTodo'
            end
        end
    end

    describe '詳細表示機能' do
        context 'ユーザーAがログインしているとき' do
            let(:login_user) { user_a }

            before do
                visit todo_path(todo_a)
            end

            it_behaves_like 'ユーザーAが作成したTodoが表示される'
        end
    end

    describe '新規作成機能' do
        let(:login_user) { user_a }

        before do
            visit new_todo_path
            fill_in 'Todoタイトル', with: todo_name
            click_button '登録'
        end

        context '新規作成画面で名称を入力したとき' do
            let(:todo_name){ '新規作成のテストを書く' }

            it '正常に登録される' do
                expect(page).to have_selector '.alert-success', text: '新規作成のテストを書く'
            end
        end

        context '新規作成画面で名称を入力しなかったとき' do
            let(:todo_name){ '' }

            it 'エラーとなる' do
                within '#error_explanation' do
                    expect(page).to have_no_content "Name can't be blank"
                end
            end
        end
    end
end