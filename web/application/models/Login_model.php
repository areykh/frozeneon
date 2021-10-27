<?php

namespace Model;

use App;
use Exception;
use System\Core\CI_Model;

class Login_model extends CI_Model {
    const PASSWORD_SALT = 'bnKgwJWbCkrwmq';

    const FORM_VALIDATION_GROUP_LOGIN = 'login';

    public function __construct()
    {
        parent::__construct();

    }

    public static function logout()
    {
        App::get_ci()->session->unset_userdata('id');
    }

    /**
     * @param string $email
     * @param string $password
     * @return User_model
     * @throws Exception
     */
    public static function login(string $email, string $password): User_model
    {
        // TODO: task 1, аутентификация
        $user = User_model::find_user_by_email($email);

        if (static::get_password_hash($password) === $user->get_password())
        {
            self::start_session((int) $user->get_id());
        }

        return $user;
    }

    public static function start_session(int $user_id)
    {
        // если перенедан пользователь
        if (empty($user_id))
        {
            throw new Exception('No id provided!');
        }

        App::get_ci()->session->set_userdata('id', $user_id);
    }

    /**
     * @param string $password
     * @return string
     */
    public static function get_password_hash(string $password): string
    {
        return md5($password . static::PASSWORD_SALT);
    }
}
