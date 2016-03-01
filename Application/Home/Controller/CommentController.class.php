<?php
namespace Home\Controller;
class CommentController extends BaseController 
{
	public function add()
	{
		// 判断有没有登录
		$mid = session('mid');
		if(!$mid)
		{
			echo json_encode(array(
				'ok' => 0,
				'error' => '必须先登录',
			));
			exit;
		}
		if(IS_POST)
		{
			$model = D('Admin/Comment');
			if($model->create(I('post.'), 1))
			{
				if($model->add())
				{
					$memberModel = M('Member');
					$face = $memberModel->field('face')->find($mid);
					$realFace = !$face['face'] ? '/Public/Home/images/default_face.jpg' : '/Public/Home/'.$face['face'];
					echo json_encode(array(
						'ok' => 1,
						'content' => I('post.content'), 
						'addtime' => date('Y-m-d H:i'),
						'star' => I('post.star'),
						'email' => session('email'),
						'face' => $realFace,
					));
					exit;
				}
			}
			echo json_encode(array(
				'ok' => 0,
				'error' => $model->getError(),
			));
		}
	}
	public function ajaxGetComment()
	{
		// 定义每页显示的条数
		$perpage = 5;
		$p = I('get.p');
		$offset = ($p-1)*$perpage;  
		$goodsId = I('get.goods_id');
		$comment = M('Comment');
		$data = $comment->field('a.*,b.email,b.face,COUNT(c.id) reply_count')->alias('a')->join('LEFT JOIN php34_member b ON a.member_id=b.id LEFT JOIN php34_reply c ON a.id=c.comment_id')->where(array('a.goods_id'=>array('eq', $goodsId)))->limit("$offset,$perpage")->group('a.id')->order('a.id DESC')->select();
		// 处理一下数据
		foreach ($data as $k => $v)
		{
			$data[$k]['face'] = $v['face'] ? '/Public/Home/'.$v['face'] : '/Public/Home/images/default_face.jpg';
			$data[$k]['addtime'] = date('Y-m-d H:i', $v['addtime']);
		}
		echo json_encode($data);
	}
}




















