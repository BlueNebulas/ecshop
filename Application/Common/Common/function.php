<?php
function sendMail($to, $title, $content)
{
	require_once('./PHPMailer_v5.1/class.phpmailer.php');
    $mail = new PHPMailer();
    $mail->IsSMTP();
    $mail->IsHTML(TRUE);
    $mail->SMTPAuth=TRUE;
    $mail->CharSet='UTF-8';
    $mail->From=C('MAIL_ADDRESS');
    $mail->FromName=C('MAIL_FROM');
    $mail->Host=C('MAIL_SMTP');
    $mail->Username=C('MAIL_LOGINNAME');
    $mail->Password=C('MAIL_PASSWORD');
    $mail->Port = 25;
    $mail->AddAddress($to);
    $mail->Subject=$title;
    $mail->Body=$content;
    return($mail->Send());
}
function removeXSS($val)
{

	static $obj = null;
	if($obj === null)
	{
		require('./HTMLPurifier/HTMLPurifier.includes.php');
		$config = HTMLPurifier_Config::createDefault();
		$config->set('HTML.TargetBlank', TRUE);
		$obj = new HTMLPurifier($config);  
	}
	return $obj->purify($val);  
}
function uploadOne($imgName, $dirName, $thumb = array())
{
	// 上传LOGO
	if(isset($_FILES[$imgName]) && $_FILES[$imgName]['error'] == 0)
	{
		$rootPath = C('IMG_rootPath');
		$upload = new \Think\Upload(array(
			'rootPath' => $rootPath,
		));
		$upload->maxSize = (int)C('IMG_maxSize') * 1024 * 1024;// 设置附件上传大小
		$upload->exts = C('IMG_exts');// 设置附件上传类型
		/// $upload->rootPath = $rootPath; // 设置附件上传根目录
		$upload->savePath = $dirName . '/'; // 图片二级目录的名称
		// 上传文件 
		$info   =   $upload->upload(array($imgName=>$_FILES[$imgName]));
		if(!$info)
		{
			return array(
				'ok' => 0,
				'error' => $upload->getError(),
			);
		}
		else
		{
			$ret['ok'] = 1;
		    $ret['images'][0] = $logoName = $info[$imgName]['savepath'] . $info[$imgName]['savename'];
		    // 判断是否生成缩略图
		    if($thumb)
		    {
		    	$image = new \Think\Image();
		    	// 循环生成缩略图
		    	foreach ($thumb as $k => $v)
		    	{
		    		$ret['images'][$k+1] = $info[$imgName]['savepath'] . 'thumb_'.$k.'_' .$info[$imgName]['savename'];
				    $image->open($rootPath.$logoName);
				    $image->thumb($v[0], $v[1])->save($rootPath.$ret['images'][$k+1]);
		    	}
		    }
		    return $ret;
		}
	}
}
// 显示图片
function showImage($url, $width='', $height='')
{
	if(empty($url))
		return ;
	$url = C('IMG_URL').$url;
	if($width)
		$width = "width='$width'";
	if($height)
		$height = "height='$height'";
	echo "<img src='$url' $width $width />";
}
// 删除图片：参数：一维数组：所有要删除的图片的路径
function deleteImage($images)
{
	$rp = C('IMG_rootPath');
	foreach ($images as $v)
	{
		@unlink($rp . $v);
	}
}
// 判断批量上传的数组中有没有上传至少一张图片
function hasImage($imgName)
{
	foreach ($_FILES[$imgName]['error'] as $v)
	{
		if($v == 0)
			return TRUE;
	}
	return FALSE;
}
function attr_id_sort($a, $b)
{
	if ($a['attr_id'] == $b['attr_id'])
		return 0;
	return ($a['attr_id'] < $b['attr_id']) ? -1 : 1;
}









