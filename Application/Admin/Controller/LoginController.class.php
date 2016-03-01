<?php
namespace Admin\Controller;
use Think\Controller;
class LoginController extends Controller 
{
	public function login()
	{
		if(IS_POST)
		{
			$model = D('Admin');
			if($model->validate($model->_login_validate)->create('',  7))
			{
				if(TRUE === $model->login())
					redirect(U('Admin/Index/index')); 
			}
			$this->error($model->getError());
		}
		$this->display();
	}
	// 生成验证码的图片
	public function chkcode()
	{
		$Verify = new \Think\Verify(array(
			'length' => 2,
			'useNoise' => FALSE,
		));
		$Verify->entry();
	}
}














