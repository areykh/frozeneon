<?php
namespace Model\Achievement\Enum;
use Model\Boosterpack_model;
use Model\Comment_model;
use Model\Post_model;
use Model\User_model;
use System\Emerald\Emerald_enum;
use System\Emerald\Emerald_model;

class Transaction_info extends Emerald_enum
{
    const USER = 'user';
    const POST = 'post';
    const COMMENT = 'comment';
    const BOOSTERPACK = 'boosterpack';

    protected static $_class_map = [
        User_model::class => self::USER,
        Post_model::class => self::POST,
        Comment_model::class => self::COMMENT,
        Boosterpack_model::class => self::BOOSTERPACK,
    ];

    public static function get_object_name_by_class(Emerald_model $object): string
    {
        return static::$_class_map[get_class($object)] ?? '';
    }
}