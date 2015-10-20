<?php
/**
 * 数据库配置
 * 
 * @category QuickPHP(II)
 * @copyright http://www.myquickphp.com
 * @version $Id: Database.php 905 2011-05-05 07:43:56Z yuanwei $
 */

return array(
	/**
	 * 默认数据库连接,引用 QP_Db() 类时如果没有指数据库配置则自动使用该配置
	 */
	'default'=>array(
		// 主机名或IP
		'host'=>'localhost',
		// 端口,默认为 3306
		'port'=>3306,
		// 是否常连接
		'pconnect'=>false,
		// 数据库字符集
		'charset'=>'utf8',
		// 用户名
		'username'=>'root',
		// 密码
		'password'=>'jsppadmin',
		//数据库名
		'dbname'=>'erp',
	),
	
	/**
	 * 可根据具体设置多个数据配置，如果要使用 Master/Slave 等操作等
	 */
	/*
	'slave'=>array(
		'host'=>'192.168.1.168',
		'port'=>3307,
		'pconnect'=>false,
		'charset'=>'utf8',
		'username'=>'root',
		'password'=>'root',
		'dbname'=>'test',
	),
	*/
);