<?php
use Model\Boosterpack_model;
use Model\Comment_model;
use Model\Login_model;
use Model\User_model;

$config = [
    Login_model::FORM_VALIDATION_GROUP_LOGIN => [
        [
            'field' => 'login',
            'rules' => [
                'trim',
                'required',
                'valid_email'
            ],
            [
                'field' => 'password',
                'rules' => 'required',
            ],
        ],
    ],
    Comment_model::FORM_VALIDATION_GROUP_ADD_COMMENT => [
        [
            'field' => 'postId',
            'rules' => [
                'trim',
                'required',
                'integer',
                'greater_than[0]',
            ],
        ],
        [
            'field' => 'replyId',
            'rules' => [
                'trim',
                'required',
                'greater_than_equal_to[0]',
            ],
        ],
        [
            'field' => 'commentText',
            'rules' => 'trim|required',
        ],
    ],
    User_model::FORM_VALIDATION_GROUP_ADD_MONEY => [
        [
            'field' => 'sum',
            'rules' => [
                'trim',
                'required',
                'greater_than[0]',
            ],
        ],
    ],
    Boosterpack_model::FORM_VALIDATION_GROUP_BUY_BOOSTERPACK => [
        [
            'field' => 'id',
            'rules' => [
                'trim',
                'required',
                'greater_than[0]',
            ],
        ],
    ],
];