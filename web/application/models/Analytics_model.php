<?php
namespace Model;
use App;
use Exception;
use Model\Achievement\Enum\Transaction_info;
use stdClass;
use System\Emerald\Emerald_model;

class Analytics_model extends Emerald_Model
{
    const CLASS_TABLE = 'analytics';

    /** @var Int */
    protected $user_id;
    /** @var String describes the object with which it is carried interaction (boosterpack, wallet, etc)  */
    protected $object;
    /** @var Int action with object (buy boosterpack, add money to wallet ...) */
    protected $action;
    /** @var Int object id with which user interaction */
    protected $object_id;
    /** @var Int */
    protected $amount;
    /** @var Int */
    protected $time_created;
    /** @var Int */
    protected $time_updated;

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
     * @return String
     */
    public function get_object():string
    {
        return $this->object;
    }

    /**
     * @param $object
     * @return bool
     */
    public function set_object($object):bool
    {
        $this->object = $object;
        return $this->save('object', $object);
    }

    /**
     * @return Int
     */
    public function get_action():string
    {
        return $this->action;
    }

    /**
     * @param $action
     * @return bool
     */
    public function set_action($action):bool
    {
        $this->action = $action;
        return $this->save('action', $action);
    }

    /**
     * @return Int
     */
    public function get_object_id():int
    {
        return $this->object_id;
    }

    /**
     * @param $object_id
     * @return bool
     */
    public function set_object_id($object_id):bool
    {
        $this->object_id = $object_id;
        return $this->save('object_id', $object_id);
    }

    /**
     * @return float
     */
    public function get_amount(): float
    {
        return $this->amount;
    }

    /**
     * @param int $amount
     *
     * @return bool
     */
    public function set_amount(int $amount):bool
    {
        $this->amount = $amount;
        return $this->save('amount', $amount);
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
    public function set_time_updated(string $time_updated):bool
    {
        $this->time_updated = $time_updated;
        return $this->save('time_updated', $time_updated);
    }

    function __construct($id = NULL)
    {
        parent::__construct();

        $this->set_id($id);
    }

    public function reload()
    {
        parent::reload();
        return $this;
    }

    public static function create(array $data)
    {
        App::get_s()->from(self::CLASS_TABLE)->insert($data)->execute();
        return new static(App::get_s()->get_insert_id());
    }

    public function delete():bool
    {
        $this->is_loaded(TRUE);
        App::get_s()->from(self::CLASS_TABLE)->where(['id' => $this->get_id()])->delete()->execute();
        return App::get_s()->is_affected();
    }

    public static function get_analytics_for_user(int $user_id): array
    {
        return static::transform_many(App::get_s()->from(self::CLASS_TABLE)->where(['user_id' => $user_id])->orderBy('time_created', 'ASC')->many());
    }

    /**
     * @param int $user_id
     * @return array
     */
    public static function get_boosterpack_analytics_for_user(int $user_id): array
    {
        return static::transform_many(App::get_s()->from(self::CLASS_TABLE)
            ->where([
                'user_id' => $user_id,
                'object' => Transaction_info::BOOSTERPACK,
            ])
            ->orderBy('time_created', 'ASC')
            ->many());
    }

    /**
     * @param Emerald_model $object
     * @param string        $action
     * @param float         $amount
     * @return bool
     */
    public static function log(Emerald_model $object, string $action, float $amount): bool
    {
        $analytics = static::create([
            'user_id' => (int) User_model::get_user()->get_id(),
            'object' => Transaction_info::get_object_name_by_class($object),
            'object_id' => $object->get_id(),
            'action' => $action,
            'amount' => $amount,
        ]);
        return (bool) $analytics->get_id();
    }

    /**
     * @param Analytics_model $data
     * @param string          $preparation
     * @return stdClass
     * @throws Exception
     */
    public static function preparation(Analytics_model $data, $preparation = 'default'):stdClass
    {
        switch ($preparation)
        {
            case 'default':
                return self::_preparation_default($data);
            default:
                throw new Exception('undefined preparation type');
        }
    }

    /**
     * @param Analytics_model $data
     * @return stdClass
     */
    private static function _preparation_default(Analytics_model  $data):stdClass
    {
        $o = new stdClass();

        $o->id = $data->get_id();
        $o->object = $data->get_object();
        $o->action = $data->get_action();
        $o->object_id = $data->get_object_id();
        $o->amount = $data->get_amount();
        $o->time_created = $data->get_time_created();

        return $o;
    }
}
