<?php
namespace Model;

use App;
use Exception;
use Model\Achievement\Enum\Transaction_type;
use System\Emerald\Emerald_model;
use stdClass;
use ShadowIgniterException;

/**
 * Created by PhpStorm.
 * User: mr.incognito
 * Date: 27.01.2020
 * Time: 10:10
 */
class Boosterpack_model extends Emerald_model
{
    const CLASS_TABLE = 'boosterpack';

    const FORM_VALIDATION_GROUP_BUY_BOOSTERPACK = 'buy_boosterpack';

    /** @var float Цена бустерпака */
    protected $price;
    /** @var float Банк, который наполняется  */
    protected $bank;
    /** @var float Наша комиссия */
    protected $us;

    protected $boosterpack_info;


    /** @var string */
    protected $time_created;
    /** @var string */
    protected $time_updated;

    /**
     * @return float
     */
    public function get_price(): float
    {
        return $this->price;
    }

    /**
     * @param float $price
     *
     * @return bool
     */
    public function set_price(int $price):bool
    {
        $this->price = $price;
        return $this->save('price', $price);
    }

    /**
     * @return float
     */
    public function get_bank(): float
    {
        return $this->bank;
    }

    /**
     * @param float $bank
     *
     * @return bool
     */
    public function set_bank(float $bank):bool
    {
        $this->bank = $bank;
        return $this->save('bank', $bank);
    }

    /**
     * @return float
     */
    public function get_us(): float
    {
        return $this->us;
    }

    /**
     * @param float $us
     *
     * @return bool
     */
    public function set_us(float $us):bool
    {
        $this->us = $us;
        return $this->save('us', $us);
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

    //////GENERATE

    /**
     * @return Boosterpack_info_model[]
     */
    public function get_boosterpack_info(): array
    {
        // TODO
        if (is_null($this->boosterpack_info))
        {
            $this->boosterpack_info = Boosterpack_info_model::get_by_boosterpack_id($this->get_id());
        }
        return $this->boosterpack_info;
    }

    function __construct($id = NULL)
    {
        parent::__construct();

        $this->set_id($id);
    }

    public function reload()
    {
        parent::reload();
        $this->boosterpack_info = NULL;
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

    public static function get_all()
    {
        return static::transform_many(App::get_s()->from(self::CLASS_TABLE)->many());
    }

    /**
     * @return int
     * @throws Exception
     */
    public function open(): int
    {
        // TODO: task 5, покупка и открытие бустерпака
        // Уровень изоляции устанавливаем Read committed для текущей транзакции
        // Изменения для других транзакций будут доступны после коммита текущей транзакции
        App::get_s()->set_transaction_read_committed('')->execute();
        App::get_s()->start_trans()->execute();

        // Данным запросом приостанавливаем чтение данных из таблицы для других транзакций до коммита текущей транзакции
        $user = User_model::transform_one(App::get_s()->from(User_model::CLASS_TABLE)
            ->where(['id' => User_model::get_user()->get_id()])
            ->for_update()
            ->one());
        // Данным запросом приостанавливаем чтение данных из таблицы для других транзакций до коммита текущей транзакции
        $boosterpack = static::transform_one(App::get_s()->from(self::get_table())
            ->where(['id' => $this->get_id()])
            ->for_update()
            ->one());

        // Проверить баланс, чтобы удостоверится что записи не были изменены в коротком временном промежутке
        if ($user->get_wallet_balance() < $boosterpack->get_price())
        {
            App::get_s()->rollback()->execute();
            return 0;
        }

        // Расчитываем максимальный прайс итема [макс. стоимость = профитбанк + (цена открываемого бустерпака - комиссия)]
        // Значение округлям до целого чисела
        $item_max_price = (int) ($boosterpack->get_bank() + $boosterpack->get_price() - $boosterpack->get_us());

        // Получаем доступный рандомный итем на основании максимальной цены
        $available_items = $this->get_contains($item_max_price);
        $random_item = $available_items[array_rand($available_items)];

        // Уменьшаем баланс кошелька пользователя на цену бустерпака
        $user_remove_money_result = $user->remove_money($boosterpack->get_price());
        // Производим запись в таблицу аналитики
        $insert_analytics_user_remove_money_result = Analytics_model::log(
            $boosterpack,
            Transaction_type::WALLET_BALANCE_WITHDRAW,
            $boosterpack->get_price()
        );

        // Пополняем баланс лайков пользователя на количество лайков рандомного итема
        $user_increment_likes_result = $user->increment_likes($random_item->get_price());
        // Производим запись в таблицу аналитики
        $insert_analytics_user_increment_likes_result = Analytics_model::log(
            $boosterpack,
            Transaction_type::LIKES_BALANCE_ACCRUAL,
            $random_item->get_price()
        );

        // Расчитываем новый профитбанк [профитбанк = профитбанк + цена бустерпака - комиссия - стоимость выданных в текущем открытии лайков]
        $new_bank = (float) ($boosterpack->get_bank() + $boosterpack->get_price() - $boosterpack->get_us() - $random_item->get_price());
        // Обновляем профитбанк для бустерпака
        App::get_s()
            ->from(self::get_table())
            ->where(['id' => $this->get_id()])
            ->update(['bank' => $new_bank])
            ->execute();
        $update_boosterpack_result = App::get_s()->is_affected();

        // Если изменения прошли, тогда коммит
        if (
            $user_remove_money_result
            && $insert_analytics_user_remove_money_result
            && $user_increment_likes_result
            && $insert_analytics_user_increment_likes_result
            && $update_boosterpack_result
        )
        {
            App::get_s()->commit()->execute();
            return $random_item->get_price();
        }

        // Изменения не прошли, откатываем
        App::get_s()->rollback()->execute();
        return 0;
    }

    /**
     * @param int|null $max_available_likes
     * @return Item_model[]
     */
    public function get_contains(int $max_available_likes = null): array
    {
        // TODO: task 5, покупка и открытие бустерпака
        $items = [];
        foreach ($this->get_boosterpack_info() as $boosterpack_info)
        {
            $items[] = $boosterpack_info->get_item();
        }
        if (is_null($max_available_likes))
        {
            return $items;
        }

        foreach ($items as $key => $item)
        {
            if ($item->get_price() > $max_available_likes)
            {
                unset($items[$key]);
            }
        }
        return $items;
    }


    /**
     * @param Boosterpack_model $data
     * @param string            $preparation
     *
     * @return stdClass|stdClass[]
     */
    public static function preparation(Boosterpack_model $data, string $preparation = 'default')
    {
        switch ($preparation)
        {
            case 'default':
                return self::_preparation_default($data);
            case 'contains':
                return self::_preparation_contains($data);
            default:
                throw new Exception('undefined preparation type');
        }
    }

    /**
     * @param Boosterpack_model $data
     *
     * @return stdClass
     */
    private static function _preparation_default(Boosterpack_model $data): stdClass
    {
        $o = new stdClass();

        $o->id = $data->get_id();
        $o->price = $data->get_price();

        return $o;
    }


    /**
     * @param Boosterpack_model $data
     *
     * @return stdClass
     */
    private static function _preparation_contains(Boosterpack_model $data): stdClass
    {
        // TODO: task 5, покупка и открытие бустерпака
        $o = new stdClass();

        $o->id = $data->get_id();
        $o->price = $data->get_price();
        $o->items = Item_model::preparation_many($data->get_contains());

        return $o;
    }
}
