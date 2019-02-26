require 'rails_helper'

describe 'タスク管理機能', type: :system do
  let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') }
  let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com') }
  let!(:task_a) { FactoryBot.create(:task, name: '最初のタスク', user: user_a) }

  before do
    #作成者がユーザーAであるタスクを作成しておく
    # FactoryBot.create(:task, name: '最初のタスク', user: user_a)

    visit login_path
    fill_in 'メールアドレス', with: login_user.email
    fill_in 'パスワード', with: login_user.password
    click_button 'ログインする'
  end

  shared_examples_for 'ユーザーAが作成したタスクが表示される' do
    it { expect(page).to have_content '最初のタスク' }
  end

  describe '一覧表示機能' do

    context 'ユーザーAがログインしている場合' do
      let(:login_user) { user_a }

      it_behaves_like 'ユーザーAが作成したタスクが表示される'
    end

    context 'ユーザーBがログインしている場合' do
      let(:login_user) { user_b }

      it 'ユーザーAが作成したタスクが表示されない' do
        expect(page).to have_no_content '最初のタスク'
      end
    end
  end

  describe '詳細表示機能' do
    context 'ユーザーAがログインしている場合' do
      let(:login_user) { user_a }

      before do
        visit task_path(task_a)
      end

      it_behaves_like 'ユーザーAが作成したタスクが表示される'
    end
  end

  describe '新規作成機能' do
    let(:login_user) { user_a }
    let(:task_name) { '新規作成のテストを書く' }

    before do
      visit new_task_path
      fill_in '名称', with: task_name
      click_button '確認'
    end

    # 仕様変更のためコメントアウト　画像登録をしなければこちらを使用
    # context '新規作成画面で名称を入力して登録ボタンを押したとき' do
    #
    #   context '登録ボタンをおした場合' do
    #     before do
    #       click_button '登録'
    #     end
    #
    #     it '正常に登録される' do
    #       expect(page).to have_selector '.alert-success', text: '新規作成のテストを書く'
    #     end
    #   end
    #
    #   context '戻るボタンを押した場合' do
    #     before do
    #       click_button '戻る'
    #     end
    #
    #     it "新規作成画面に戻る" do
    #       expect(page).to have_content 'タスクの新規登録'
    #     end
    #   end
    #
    # end

    context '新規作成画面で名称を入力しなかったとき' do
      let(:task_name) { '' }

      before do
        click_button '確認'
      end

      it 'エラーとなる' do
        within '#error_explanation' do
          expect(page).to have_content '名称を入力してください'
        end
      end
    end
  end

  describe '更新機能' do
    let(:login_user) { user_a }
    let!(:task_update) { FactoryBot.create(:task, name: '更新前', user: user_a) }

    context 'ユーザーAがログインしている場合' do

      before do
        visit edit_task_path(task_update)
        fill_in '名称', with: '更新後'
        click_button '更新する'
      end

      it 'ユーザーAが作成したタスクの名前が更新される' do
        expect(page).to have_content '更新後'
      end
    end
  end

  describe '削除機能' do
    let(:login_user) { user_a }

    context 'ユーザーAがログインしている場合' do

      before do
        visit task_path(task_a)
        click_on '削除'
        page.driver.browser.switch_to.alert.accept
      end

      it '削除ボタンを押したら、タスクが削除される' do
        expect(page).to have_content '削除しました'
      end
    end
  end
end

#　重複部分
# context 'ユーザーAがログインしている場合' do
  # before do
    #ユーザーAでログイン コードが重複している
    # visit login_path
    # fill_in 'メールアドレス', with: 'a@example.com'
    # fill_in 'パスワード', with: 'password'
    # click_button 'ログインする'
  # end

# context 'ユーザーBがログインしている場合' do
  # before do
    #ユーザーBを作成
    # FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com')
    # #ユーザーBでログイン コードに重複している部分があるのでDRYにしたいのでコメントアウト
    # visit login_path
    # fill_in 'メールアドレス', with: 'b@example.com'
    # fill_in 'パスワード', with: 'password'
    # click_button 'ログインする'
  # end
