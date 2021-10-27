<?php
use System\Libraries\Core;

class Response extends Core
{
    const RESPONSE_GENERIC_NOT_ENOUGH_WALLET_BALANCE = 'not_enough_wallet_balance'; // недостаточно средств на счету
    const RESPONSE_GENERIC_NOT_ENOUGH_LIKE_BALANCE = 'not_enough_like_balance'; // недостаточно лайков на счету
}