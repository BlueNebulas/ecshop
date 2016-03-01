<?php
namespace Home\Controller;
class IndexController extends BaseController 
{
	// 商品详情页
	public function goods()
	{
		$goodsId = I('get.id');
		$goodsModel = M('Goods');
		$info = $goodsModel->find($goodsId);
		$gpModel = M('GoodsPics');
		$gpData = $gpModel->where(array('goods_id'=>array('eq', $goodsId)))->select();
		/*********** 取出商品属性 ******************/
		$gaModel = M('GoodsAttr');  // php34_goods_attr
		$_gaData1 = $gaModel->field('a.*,b.attr_name')->alias('a')->join('LEFT JOIN php34_attribute b ON a.attr_id=b.id')->where(array('a.goods_id'=>array('eq', $goodsId), 'b.attr_type'=>array('eq', 1)))->select();
		$gaData1 = array(); 
		foreach ($_gaData1 as $k => $v)
		{
			$gaData1[$v['attr_name']][] = $v;
		}
		
		// 取出商品的唯一的属性
		$gaData2 = $gaModel->field('a.*,b.attr_name')->alias('a')->join('LEFT JOIN php34_attribute b ON a.attr_id=b.id')->where(array('a.goods_id'=>array('eq', $goodsId), 'b.attr_type'=>array('eq', 0)))->select();
		$this->assign(array(
			'info' => $info,
			'gpData' => $gpData,
			'gaData1' => $gaData1,
			'gaData2' => $gaData2,
		));
		
		$this->setPageInfo($info['goods_name'] . '-商品详情页', $info['seo_keyword'], $info['seo_description'], 0, array('goods','common','jqzoom'), array('goods','jqzoom-core'));
		$this->display();
	}
    public function index()
    {	
    	$goodsModel = D('Admin/Goods');
    	// 获取疯狂抢购的商品
    	$goods1 = $goodsModel->getPromoteGoods();
    	$goods2 = $goodsModel->getHot();
    	$goods3 = $goodsModel->getBest();
    	$goods4 = $goodsModel->getNew();
    	
    	$this->assign(array(
	    	'goods1' => $goods1,
	    	'goods2' => $goods2,
	    	'goods3' => $goods3,
	    	'goods4' => $goods4,
    	));
    	$this->setPageInfo('首页', '关键字', '描述', 1, array('index'), array('index'));
    	$this->display();
    }
    // 计算会员价格
    public function ajaxGetPrice()
    {
    	$goodsId = I('get.goods_id');
    	$goodsModel = D('Admin/Goods');
    	$recentDisplay = isset($_COOKIE['recentDisplay']) ? unserialize($_COOKIE['recentDisplay']) : array();
    	array_unshift($recentDisplay, $goodsId);
    	// 去复
    	$recentDisplay = array_unique($recentDisplay);
    	// 如果超过10个就只保留前10个
    	if(count($recentDisplay) > 10)
    		$recentDisplay = array_slice($recentDisplay, 0, 10);
    	// 把处理好的数组保存回COOKIE中
    	$aMonth = 30 * 86400;
    	$data = serialize($recentDisplay);
    	setcookie('recentDisplay', $data, time() + $aMonth, '/', '34.com');
    	
    	echo $goodsModel->getMemberPrice($goodsId);
    }
    // 取出最近浏览过的商品的信息
    public function ajaxGetRecentDisGoods()
    {
    	$recentDisplay = isset($_COOKIE['recentDisplay']) ? unserialize($_COOKIE['recentDisplay']) : array();
    	if($recentDisplay)
    	{
    		$goodsModel = M('Goods');
    		$recentDisplay_str = implode(',', $recentDisplay);
    		$goods = $goodsModel->field('id,goods_name,sm_logo')->where(array('id'=> array('in', $recentDisplay)))->order("INSTR(',$recentDisplay_str,',CONCAT(',',id,','))")->select();
    		echo json_encode($goods);
    	}
    }
    public function ajaxGetComment()
    {
    	$ret = array('login' => 0);
    	$mid = session('mid');
    	if($mid)
    	{
    		$ret['login'] = 1;
    	}
		echo json_encode($ret);
    }
}




















