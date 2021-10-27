/*
Сколько денег потрачено на бустерпаки по каждому паку отдельно, почасовая выборка.
Также нужно показать, сколько получили юзеры из каждого пока в эквиваленте $. Выборка должна быть за последние 30 дней.
 */

SELECT `object_id`                                          as `boosterpack_id`,
       CONCAT(DATE_FORMAT(`time_created`, '%Y-%m-%d %H:00:00'), ' - ',
              DATE_FORMAT(`time_created`, '%H:59:59'))      as `date_range`,
       SUM(CASE WHEN `action` = 2 then `amount` ELSE 0 END) as total_pack_hour_price, /* WALLET_BALANCE_WITHDRAW = 2;*/
       SUM(CASE WHEN `action` = 3 then `amount` ELSE 0 END) as total_pack_hour_likes /* LIKES_BALANCE_ACCRUAL = 3 */
FROM `analytics`
WHERE `object` = 'boosterpack'
  AND
    DATE (`time_created`) >= DATE (NOW()) - INTERVAL 30 DAY
GROUP BY
    `object_id`, `date_range`
ORDER BY
    `object_id` ASC,
    `date_range` ASC;


/*
Выборка по юзеру, на сколько он пополнил баланс и сколько получил лайков за все время. Текущий остаток баланса в $ и лайков на счету.
 */
SELECT `U`.`id`             as `user_id`,
       `U`.`personaname`,
       `U`.`wallet_total_refilled`,
       COALESCE(
               (SELECT SUM(`A`.`amount`)
                FROM `analytics` as `A`
                WHERE `A`.`user_id` = `U`.`id`
                  AND `A`.`object` = 'boosterpack'
                  AND `A`.`action` = 3 /* LIKES_BALANCE_ACCRUAL = 3 */
                GROUP BY `A`.`user_id`),
               0
           )                as likes_total_refilled,
       `U`.`wallet_balance` as `current_wallet_balance`,
       `U`.`likes_balance`  as `current_likes_balance`
FROM `user` as `U`
ORDER BY `U`.`id` ASC;