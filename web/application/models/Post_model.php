<?php
namespace Model;
use App;
use Exception;
use Model\Achievement\Enum\Transaction_type;
use stdClass;
use System\Emerald\Emerald_model;

/**
 * Created by PhpStorm.
 * User: mr.incognito
 * Date: 27.01.2020
 * Time: 10:10
 */
class Post_model extends Emerald_Model
{
    const CLASS_TABLE = 'post';


    /** @var int */
    protected $user_id;
    /** @var string */
    protected $text;
    /** @var string */
    protected $img;

    /** @var string */
    protected $time_created;
    /** @var string */
    protected $time_updated;

    // generated
    protected $comments;
    protected $likes;
    protected $user;


    /**
     * @return int
     */
    public function get_user_id(): int
    {
        return $this->user_id;
    }

    /**
     * @param int $user_id
     *
     * @return bool
     */
    public function set_user_id(int $user_id):bool
    {
        $this->user_id = $user_id;
        return $this->save('user_id', $user_id);
    }

    /**
     * @return string
     */
    public function get_text(): string
    {
        return $this->text;
    }

    /**
     * @param string $text
     *
     * @return bool
     */
    public function set_text(string $text):bool
    {
        $this->text = $text;
        return $this->save('text', $text);
    }

    /**
     * @return string
     */
    public function get_img(): string
    {
        return $this->img;
    }

    /**
     * @param string $img
     *
     * @return bool
     */
    public function set_img(string $img):bool
    {
        $this->img = $img;
        return $this->save('img', $img);
    }


    /**
     * @return string
     */
    public function get_time_created(): string
    {
        return $this->time_created;
    }

    /**
     * @param string $time_created
     *
     * @return bool
     */
    public function set_time_created(string $time_created):bool
    {
        $this->time_created = $time_created;
        return $this->save('time_created', $time_created);
    }

    /**
     * @return string
     */
    public function get_time_updated(): string
    {
        return $this->time_updated;
    }

    /**
     * @param string $time_updated
     *
     * @return bool
     */
    public function set_time_updated(int $time_updated):bool
    {
        $this->time_updated = $time_updated;
        return $this->save('time_updated', $time_updated);
    }

    /**
     * @return int|null
     */
    public function get_likes(): ?int
    {
        return $this->likes;
    }

    public function set_likes(int $likes):bool
    {
        $this->likes = $likes;
        return $this->save('likes', $likes);
    }

    // generated

    /**
     * @return Comment_model[]
     */
    public function get_comments():array
    {
       // TODO: task 2, комментирование
        if (is_null($this->comments))
        {
            $this->comments = Comment_model::get_all_by_assign_id($this->get_id());
        }
        return $this->comments;
    }

    /**
     * @return User_model
     */
    public function get_user():User_model
    {
        $this->is_loaded(TRUE);

        if (empty($this->user))
        {
            try {
                $this->user = new User_model($this->get_user_id());
            } catch (Exception $exception)
            {
                $this->user = new User_model();
            }
        }
        return $this->user;
    }

    function __construct($id = NULL)
    {
        parent::__construct();
        $this->set_id($id);
    }

    public function reload()
    {
        parent::reload();
        $this->comments = NULL;
        $this->user = NULL;
        return $this;
    }

    public static function create(array $data)
    {
        App::get_s()->from(self::CLASS_TABLE)->insert($data)->execute();
        return new static(App::get_s()->get_insert_id());
    }

    public function delete()
    {
        $this->is_loaded(TRUE);
        App::get_s()->from(self::CLASS_TABLE)->where(['id' => $this->get_id()])->delete()->execute();
        return App::get_s()->is_affected();
    }

    /**
     * @return static[]
     * @throws Exception
     */
    public static function get_all():array
    {
        return static::transform_many(App::get_s()->from(self::CLASS_TABLE)->many());
    }

    /**
     * @param User_model $user
     *
     * @return bool
     * @throws Exception
     */
    public function increment_likes(User_model $user): bool
    {
        // TODO: task 3, лайк поста
        // Уровень изоляции устанавливаем Read committed для текущей транзакции
        // Изменения для других транзакций будут доступны после коммита текущей транзакции
        App::get_s()->set_transaction_read_committed('')->execute();
        App::get_s()->start_trans()->execute();

        // Данным запросом приостанавливаем чтение данных из таблицы для других транзакций до коммита текущей транзакции
        $user = User_model::transform_one(App::get_s()->from(User_model::CLASS_TABLE)
            ->where(['id' => $user->get_id()])
            ->for_update()
            ->one());

        // Берем текущие данные по юзеру, есть вероятность того, что средств на балансе лайков уже недостаточно
        if ($user->get_likes_balance() < 1)
        {
            App::get_s()->rollback()->execute();
            return FALSE;
        }

        // Уменьшаем баланс лайков юзера на 1
        $user_decrement_likes_result = $user->decrement_likes();
        // Производим запись в таблицу аналитики
        $insert_analytics_result = Analytics_model::log(
            $this,
            Transaction_type::LIKES_BALANCE_WITHDRAW,
            1
        );

        // Увеличиваем количество лайков поста на 1 (атомарное обновление), не блокируем выборку для других запросов SELECT
        App::get_s()->from(self::get_table())
            ->where(['id' => $this->get_id()])
            ->update(sprintf('likes = likes + %s', App::get_s()->quote(1)))
            ->execute();
        $post_increment_likes_result = App::get_s()->is_affected();

        // Если изменения прошли, тогда коммит
        if ($user_decrement_likes_result && $insert_analytics_result && $post_increment_likes_result)
        {
            App::get_s()->commit()->execute();
            return TRUE;
        }

        // Изменения не прошли, откатываем
        App::get_s()->rollback()->execute();
        return FALSE;
    }

    /**
     * @param Post_model $data
     * @param string $preparation
     * @return stdClass
     * @throws Exception
     */
    public static function preparation(Post_model $data, $preparation = 'default'):stdClass
    {
        switch ($preparation)
        {
            case 'default':
                return self::_preparation_default($data);
            case 'full_info':
                return self::_preparation_full_info($data);
            default:
                throw new Exception('undefined preparation type');
        }
    }

    /**
     * @param Post_model $data
     * @return stdClass
     */
    private static function _preparation_default(Post_model  $data):stdClass
    {
        $o = new stdClass();

        $o->id = $data->get_id();
        $o->img = $data->get_img();

        $o->text = $data->get_text();

        $o->user = User_model::preparation($data->get_user(), 'main_page');

        $o->time_created = $data->get_time_created();
        $o->time_updated = $data->get_time_updated();

        return $o;
    }


    /**
     * @param Post_model $data
     * @return stdClass
     */
    private static function _preparation_full_info(Post_model $data):stdClass
    {
        $o = new stdClass();


        $o->id = $data->get_id();
        $o->img = $data->get_img();

        $o->user = User_model::preparation($data->get_user(),'main_page');
        $o->comments = Comment_model::preparation_many($data->get_comments(),'default');

        $o->likes = $data->get_likes();


        $o->time_created = $data->get_time_created();
        $o->time_updated = $data->get_time_updated();

        return $o;
    }
}
