<?php
namespace Model\Achievement\Enum;
use System\Emerald\Emerald_enum;

class Transaction_type extends Emerald_enum
{
    const WALLET_BALANCE_ACCRUAL = 'wallet_balance_accrual';
    const WALLET_BALANCE_WITHDRAW = 'wallet_balance_withdraw';
    const LIKES_BALANCE_ACCRUAL = 'likes_balance_accrual';
    const LIKES_BALANCE_WITHDRAW = 'likes_balance_withdraw';
}