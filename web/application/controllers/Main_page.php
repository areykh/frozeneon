<?php
use Model\Analytics_model;
use Model\Boosterpack_model;
use Model\Comment_model;
use Model\Post_model;
use Model\User_model;
use Model\Login_model;

/**
 * Created by PhpStorm.
 * User: mr.incognito
 * Date: 10.11.2018
 * Time: 21:36
 */
class Main_page extends MY_Controller
{

    public function __construct()
    {

        parent::__construct();

        if (is_prod())
        {
            die('In production it will be hard to debug! Run as development environment!');
        }
    }

    public function index()
    {
        $user = User_model::get_user();

        App::get_ci()->load->view('main_page', ['user' => User_model::preparation($user, 'default')]);
    }

    public function get_all_posts()
    {
        $posts =  Post_model::preparation_many(Post_model::get_all(), 'default');
        return $this->response_success(['posts' => $posts]);
    }

    public function get_boosterpacks()
    {
        $posts =  Boosterpack_model::preparation_many(Boosterpack_model::get_all(), 'default');
        return $this->response_success(['boosterpacks' => $posts]);
    }

    public function login()
    {
        // TODO: task 1, аутентификация
        if (User_model::is_logged())
        {
            $this->response_success([
                'user' => User_model::preparation(User_model::get_user(), 'main_page'),
            ]);
        }

        if ( ! App::get_ci()->form_validation->run(Login_model::FORM_VALIDATION_GROUP_LOGIN))
        {
            return $this->response_error(Response::RESPONSE_GENERIC_WRONG_PARAMS);
        }
        $email = (string) App::get_ci()->input->post('login');
        $password = (string) App::get_ci()->input->post('password');

        $user = Login_model::login($email, $password);

        if ( ! User_model::is_logged())
        {
            return $this->response_error(Response::RESPONSE_GENERIC_WRONG_PARAMS);
        }

        return $this->response_success([
            'user' => User_model::preparation($user, 'main_page'),
        ]);
    }

    public function logout()
    {
        // TODO: task 1, аутентификация
        Login_model::logout();

        App::get_ci()->load->library('user_agent');

        $redirect_url = $this->agent->is_referral() ? $this->agent->referrer() : base_url();

        redirect($redirect_url);
    }

    /**
     * @return object|string|void
     * @throws Exception
     */
    public function comment()
    {
        // TODO: task 2, комментирование
        if ( ! User_model::is_logged())
        {
            return $this->response_error(Response::RESPONSE_GENERIC_NEED_AUTH);
        }

        if ( ! App::get_ci()->form_validation->run(Comment_model::FORM_VALIDATION_GROUP_ADD_COMMENT))
        {
            return $this->response_error(Response::RESPONSE_GENERIC_WRONG_PARAMS);
        }

        try
        {
            $post_id = (int) App::get_ci()->input->post('postId');
            new Post_model($post_id);
            $reply_id = (int) App::get_ci()->input->post('replyId');
            if ($reply_id) {
                new Comment_model($reply_id);
            }
        }
        catch (Exception $exception)
        {
            return $this->response_error(Response::RESPONSE_GENERIC_WRONG_PARAMS);
        }

        Comment_model::create([
            'user_id' => User_model::get_user()->get_id(),
            'assign_id' => $post_id,
            'reply_id' => $reply_id,
            'text' => htmlentities(App::get_ci()->input->post('commentText')),
        ]);

        return $this->response_success();
    }

    public function like_comment(int $comment_id)
    {
        // TODO: task 3, лайк комментария
        if ( ! User_model::is_logged())
        {
            return $this->response_error(Response::RESPONSE_GENERIC_NEED_AUTH);
        }

        if (User_model::get_user()->get_likes_balance() < 1)
        {
            return $this->response_error(Response::RESPONSE_GENERIC_NOT_ENOUGH_LIKE_BALANCE);
        }

        try
        {
            $comment = new Comment_model($comment_id);
        }
        catch (Exception $exception)
        {
            return $this->response_error(Response::RESPONSE_GENERIC_WRONG_PARAMS);
        }


        if ( ! $comment->increment_likes(User_model::get_user()))
        {
            return $this->response_error(Response::RESPONSE_GENERIC_TRY_LATER);
        }

        return $this->response_success(['likes' => $comment->reload()->get_likes()]);
    }

    public function like_post(int $post_id)
    {
        // TODO: task 3, лайк поста
        if ( ! User_model::is_logged())
        {
            return $this->response_error(Response::RESPONSE_GENERIC_NEED_AUTH);
        }

        if (User_model::get_user()->get_likes_balance() < 1)
        {
            return $this->response_error(Response::RESPONSE_GENERIC_NOT_ENOUGH_LIKE_BALANCE);
        }

        try
        {
            $post = new Post_model($post_id);
        }
        catch (Exception $exception)
        {
            return $this->response_error(Response::RESPONSE_GENERIC_WRONG_PARAMS);
        }

        if ( ! $post->increment_likes(User_model::get_user()))
        {
            return $this->response_error(Response::RESPONSE_GENERIC_TRY_LATER);
        }

        return $this->response_success(['likes' => $post->reload()->get_likes()]);
    }

    public function add_money()
    {
        // TODO: task 4, пополнение баланса
        if ( ! User_model::is_logged())
        {
            return $this->response_error(Response::RESPONSE_GENERIC_NEED_AUTH);
        }

        if ( ! App::get_ci()->form_validation->run(User_model::FORM_VALIDATION_GROUP_ADD_MONEY))
        {
            return $this->response_error(Response::RESPONSE_GENERIC_WRONG_PARAMS);
        }

        if ( ! User_model::get_user()->refill_wallet_balance((float) App::get_ci()->input->post('sum')))
        {
            return $this->response_error(Response::RESPONSE_GENERIC_SHOULD_WAIT);
        }

        return $this->response_success();
    }

    public function get_post(int $post_id)
    {
        // TODO получения поста по id
        try
        {
            $post = new Post_model($post_id);
        }
        catch (Exception $exception)
        {
            return $this->response_error(Response::RESPONSE_GENERIC_WRONG_PARAMS);
        }

        return $this->response_success([
            'post' => Post_model::preparation($post, 'full_info'),
        ]);
    }

    public function buy_boosterpack()
    {
        // Check user is authorize
        if ( ! User_model::is_logged())
        {
            return $this->response_error(Response::RESPONSE_GENERIC_NEED_AUTH);
        }

        // TODO: task 5, покупка и открытие бустерпака
        if ( ! App::get_ci()->form_validation->run(Boosterpack_model::FORM_VALIDATION_GROUP_BUY_BOOSTERPACK))
        {
            return $this->response_error(Response::RESPONSE_GENERIC_WRONG_PARAMS);
        }

        try
        {
            $boosterpack_id = (int) App::get_ci()->input->post('id');
            $boosterpack = new Boosterpack_model($boosterpack_id);
        }
        catch (Exception $exception)
        {
            return $this->response_error(Response::RESPONSE_GENERIC_WRONG_PARAMS);
        }

        if (User_model::get_user()->get_wallet_balance() < $boosterpack->get_price())
        {
            return $this->response_error(Response::RESPONSE_GENERIC_NOT_ENOUGH_WALLET_BALANCE);
        }

        $amount = $boosterpack->open();
        if ( ! $amount)
        {
            return $this->response_error(Response::RESPONSE_GENERIC_TRY_LATER);
        }

        return $this->response_success(['amount' => $amount]);
    }





    /**
     * @return object|string|void
     */
    public function get_boosterpack_info(int $bootserpack_id)
    {
        // Check user is authorize
        if ( ! User_model::is_logged())
        {
            return $this->response_error(System\Libraries\Core::RESPONSE_GENERIC_NEED_AUTH);
        }

        //TODO получить содержимое бустерпака
        try
        {
            $bootserpack = new Boosterpack_model($bootserpack_id);
        }
        catch (Exception $exception)
        {
            return $this->response_error(Response::RESPONSE_GENERIC_WRONG_PARAMS);
        }

        return $this->response_success([
            'items' => Boosterpack_model::preparation($bootserpack, 'contains'),
        ]);
    }

    public function get_analytics()
    {
        // Check user is authorize
        if ( ! User_model::is_logged())
        {
            return $this->response_error(Response::RESPONSE_GENERIC_NEED_AUTH);
        }

        return $this->response_success([
            'all' => Analytics_model::preparation_many(Analytics_model::get_analytics_for_user(User_model::get_user()->get_id()), 'default'),
            'balance' => User_model::preparation(User_model::get_user(), 'balance'),
            'boosterpaks' => Analytics_model::preparation_many(Analytics_model::get_boosterpack_analytics_for_user(User_model::get_user()->get_id()), 'default'),
        ]);
    }

    public function get_like_balance()
    {
        // Check user is authorize
        if ( ! User_model::is_logged())
        {
            return $this->response_error(Response::RESPONSE_GENERIC_NEED_AUTH);
        }

        return $this->response_success([
            'amount' => User_model::get_user()->get_likes_balance(),
        ]);
    }
}
