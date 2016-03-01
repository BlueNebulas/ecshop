create database if not exists myecshop character set utf8 collate utf8_general_ci;
Use jdShop;
set names utf8;
###############商品表#######################
create table if not exists jd_goods(
  id mediumint unsigned not null auto_increment,
  goods_name varchar(150) not null comment '商品名称',
  logo varchar(150) not null comment '商品图片',
  sm_logo varchar(150) not null comment '缩略图',
  brand_id smallint unsigned not null comment '所属品牌ID',
  type_id smallint unsigned not null comment '所属类型ID',
  market_price decimal(10,2) not null comment '市场价格',
  shop_price decimal(10,2) not null comment '本店价格',
  promote_price decimal(10,2) not null comment '促销价格',
  start_propmote datetime not null comment '促销开始时间',
  end_promote datetime not null comment '促销结束时间',
  goods_desc longtext not null comment '商品描述',
  short_order tinyint unsigned not null default '100' comment '商品排序',
  is_on_sale tinyint unsigned not null default '1' comment '1为上架，0为下架',
  is_delete tinyint unsigned not null default '0'  comment '回收站标记,1表示在回收站',
  is_hot tinyint unsigned not null default '0' comment '是否热卖',
  is_new tinyint unsigned not null default '0' comment '是否新品',
  is_best tinyint unsigned not null default '0' comment '是否精品',
  is_propmote tinyint unsigned not null default '0' comment '是否促销',
  addtime datetime not null comment '时间',
  primary key(id),
  key brand_id(brand_id),
  key type_id(type_id),
  key shop_price(shop_price),
  key is_hot(is_hot),
  key is_new(is_new),
  key is_best(is_best),
  key is_on_sale(is_on_sale),
  key is_propmote(is_propmote),
  key is_delete(is_delete)
)engine=myisam default charset=utf8 comment '商品表';
#使用第三方的全文索引，如sphinx、lucence
###############商品分类表#####################
  create table if not exists jd_goods_cat(
    id smallint unsigned not null auto_increment,
    goods_id mediumint unsigned not null comment '商品ID',
    cat_id smallint unsigned not null comment '分类ID',
    primary key(id)
)engine=myisam default charset=utf8 comment '商品分类表';
###############商品品牌表#####################
  create table if not exists jd_brands(
    id smallint unsigned not null auto_increment,
    brand_name varchar(45)  not null comment '品牌名称',
    site_url varchar(150)   not null comment '品牌连接',
    logo varchar(150)  not null comment '品牌LOGO',
    primary key(id)
)engine=myisam default charset=utf8 comment '商品品牌表';
###############商品优惠价格表#####################
  create table if not exists jd_discount(
    id smallint unsigned not null auto_increment,
    goods_id mediumint unsigned  not null comment '商品ID',
    discount_num int unsigned  not null comment '优惠数量',
    discount_price decimal(10,2) not null comment '优惠价格',
    primary key(id),
    key goods_id(goods_id)
)engine=myisam default charset=utf8 comment '商品优惠价格表';
###############管理员表#######################
create table if not exists jd_admin(
 id tinyint unsigned not null auto_increment,
 username varchar(30) not null comment '账号',
 password char(32) not null comment '密码',
 is_use tinyint unsigned not null default '1' comment '是否启用',
 role_id tinyint(3) unsigned not null comment '所属角色ID',
primary key(id)
)engine=myisam default charset=utf8 comment '管理员表';
insert into jd_admin (id,username,password) values('1','root','7d973a5657a434338e2ed3a5db2f930e');
###############RBAC:基于角色权限控制管理########
  create table if not exists jd_privilege(
    id smallint unsigned not null auto_increment,
    priv_name varchar(20) not null comment '权限名称',
    parents_id smallint unsigned not null comment '父类权限ID',
    module_name varchar(20) not null comment '模块名称',
    controller_name varchar(20) not null comment '控制名称',
    action_name varchar(20) not null comment '方法名称',
    priv_level tinyint(4) not null default '0' comment '基别,0代表最上级',
    primary key(id)
)engine=myisam default charset=utf8 comment '权限表';
#############################角色表##########
  create table if not exists jd_role(
    id smallint unsigned not null auto_increment,
    role_name varchar(20) not null comment '角色名称',
    priv_id smallint unsigned not null comment '权限ID',
    primary key(id)
)engine=myisam default charset=utf8 comment '角色表';
#############################分类表##########
create table if not exists jd_category(
   id smallint unsigned not null auto_increment,
   cat_name varchar(30) not null comment '分类名称',
   parent_id smallint unsigned not null default '0' comment '父类ID,0为最上级',
   primary key(id)
)engine=myisam default charset=utf8 comment '分类表';
#############################商品类型##########
create table if not exists jd_type(
   id tinyint unsigned not null auto_increment,
   type_name varchar(30) not null comment '商品类型名称',
   primary key(id)
)engine=myisam default charset=utf8 comment '商品类型表';
#############################属性类型##########
#一个类型可以有多个属性，一个属性只能属于一个类型，一对多的关系
#属性可以同名
#要区分属性类型表和商品属性表
drop table if exists jd_attribute;
create table jd_attribute(
   id mediumint unsigned not null auto_increment,
   attr_name varchar(30) not null comment '商品属性名称',
   attr_type tinyint unsigned not null default '0' comment '0为唯一，1为可选',
   attr_option_values varchar(150) not null comment '多个可选值用逗号隔开',
   type_id tinyint unsigned not null comment '所属类型ID',
   primary key(id),
   key type_id (type_id)
)engine=myisam default charset=utf8 comment '商品属性表';
#############################会员级别表##########
#经验值作为会员级别划分标准
create table if not exists  jd_member_level(
   id mediumint unsigned not null auto_increment,
   level_name varchar(30) not null comment '会员级别名称',
   bottom_num int unsigned not null  comment '经验值下限',
   top_num int unsigned not null  comment '经验值上限',
   primary key(id)
)engine=myisam default charset=utf8 comment '会员级别表';
#############################会员价格表##########
create table if not exists jd_member_price(
   id int unsigned not null auto_increment,
   level_id mediumint unsigned not null comment '会员级别ID',
   goods_id varchar(30) not null comment '商品ID',
   price decimal(10,2) not null  comment '价格',
   primary key(id)
)engine=myisam default charset=utf8 comment '会员价格表';
#############################商品图片表##########
create table if not exists jd_goods_img(
   id mediumint unsigned not null auto_increment,
   img_src varchar(30) not null comment '图片连接',
   thumb_src varchar(30) not null comment '缩略图连接',
   primary key(id)
)engine=myisam default charset=utf8 comment '商品图片表';
#############################商品属性表##########
#多对多
#同一个商品有多个属性ID则为可选
create table if not exists jd_goods_attr(
   id int unsigned not null auto_increment,
   goods_id  mediumint unsigned not null comment '商品ID',
   attr_id   mediumint unsigned not null comment '属性ID',
   attr_value varchar(150) not null comment '属性值',
   attr_price decimal(10,2) not null comment '属性价格',
   primary key(id),
   key goods_id(goods_id),
   key attr_id(attr_id)
)engine=myisam default charset=utf8 comment '商品属性表';
#############################商品库存表##########
#对唯一属性和可选属性分开处理，注意前后台要一致
create table if not exists jd_goods_num(
   id int unsigned not null auto_increment,
   goods_id  mediumint unsigned not null comment '商品ID',
   goods_num  int not null comment '商品库存值',
   goods_attr_id varchar(150) not null comment '商品属性表主键ID数组,通过它查出属性名和值,后台和前台查询ID顺序(升序)一致,比如手机：黑色32G|黑色64G',
   primary key(id),
   key goods_id(goods_id),
   key attr_id(attr_id)
)engine=InnoDB default charset=utf8 comment '商品库存表';
#############################用户基本表##########
create table if not exists jd_user(
   id mediumint unsigned not null auto_increment,
   email  varchar(60) not null comment '邮箱',
   email_code char(32) not null default ' ' comment '邮箱验证，为空表示验证成功',
   password char(32) not null comment '密码',
   primary key(id),
   key email(email),
   key email_code(email_code),
   key password(password)
)engine=myisam default charset=utf8 comment '用户基本表';
#############################用户信息表##########
#省略
#############################商品评论表##########
create table if not exists jd_comment(
   id mediumint unsigned not null auto_increment,
   content  varchar(1000) not null comment '内容',
   star tinyint unsigned not null comment '评分',
   add_time int unsigned not null default '3' comment '时间',
   member_id mediumint unsigned not null comment '会员ID',
   goods_id mediumint unsigned not null comment '商品ID',
   used smallint unsigned not null default '0' comment '有用数',
   primary key(id),
   key goods_id(goods_id)
)engine=myisam default charset=utf8 comment '商品评论表';
#############################评论回复表##########
create table if not exists jd_response(
   id mediumint unsigned not null auto_increment,
   comment_id mediumint unsigned not null comment '评论ID',
   content  varchar(1000) not null comment '内容',
   add_time int unsigned not null comment '时间',
   member_id mediumint unsigned not null comment '会员ID',
   goods_id mediumint unsigned not null comment '商品ID'，
   primary key(id),
   key goods_id(goods_id)
)engine=myisam default charset=utf8 comment '评论回复表';
#############################有用表##########
create table if not exists jd_checked_use(
   member_id mediumint unsigned not null comment '会员ID',
   comment_id mediumint unsigned not null comment '评论ID',
   primary key (member_id,comment_id)
)engine=myisam default charset=utf8 comment '有用表';
#############################印象表##########
create table if not exists jd_imp(
  id mediumint unsigned not null auto_increment,
  imp_name varchar(30) not null comment '印象名',
  imp_count smallint unsigned not null comment '印象出现次数',
  goods_id mediumint unsigned not null comment '商品ID',
  primary key (id),
  key goods_id(goods_id)
)engine=myisam default charset=utf8 comment '印象表';
#############################购物车表##########
#会员没有登陆就操作COOKIE(序列化后存于COOKIE)。登陆后转存数据库然后清空COOKIE
#$cat_save_cookie=array('商品ID-商品属性ID列表=>购买数量');
#注意商品选择属性列表与库存量表的排序(升序还是降序)应该一致
create table if not exists jd_cart(
  id mediumint unsigned not null auto_increment,
  goods_id mediumint unsigned not null comment '商品ID',
  goods_attr_id varchar(30)  not null comment '商品选择属性列表',
  goods_number int unsigned not null default '0' comment '购物数量',
  member_id mediumint unsigned not null comment '会员ID',
  primary key (id),
  key member_id(member_id)
)engine=myisam default charset=utf8 comment '购物车表';
#############################订单基本信息表##########
#下订单前先验证收货人信息
#只对购物车里选择的商品进行下单操作
#库存量检查
#锁机制：php文件锁
#事务问题 innodb存储引擎 mysql_query('START TRANSANCTION');
create table if not exists jd_order(
  id mediumint unsigned not null auto_increment,
  member_id mediumint unsigned not null comment '会员ID',
  addtime int unsigned not null comment '下单时间',
  busyer_name varchar(30) not null comment '收货人姓名',
  busyer_province varchar(30) not null comment '收货人所在省份',
  busyer_city varchar(30) not null comment '收货人所在城市',
  busyer_area varchar(30) not null comment '收货人所在地区',
  busyer_tel varchar(30) not null comment '收货人联系方式',
  busyer_address varchar(30) not null comment '收货人详细地址',
  pay_method varchar(30) not null comment '支付方式',
  post_method varchar(30) not null comment '发货方式',
  pay_status tinyint unsigned not null default '0' comment '订单支付状态，1为已支付',
  post_status tinyint unsigned not null default '0' comment '发货状态，0为未出货，1为出货中，2为退货申请中，3为退货中，4为购买完成，5为退货完成',
  priamary key(id),
  key member_id(member_id)
)engine=InnoDB default charset=utf8 comment '订单基本信息表';
#############################订单商品表##########
#可查询订单和商品销量
create table if not exists jd_order_goods(
  order_id mediumint unsigned not null comment '订单ID',
  goods_id mediumint unsigned not null comment '商品ID',
  member_id mediumint unsigned not null comment '会员ID',
  goods_attr_id varchar(30) not null comment '商品选择属性ID',
  goods_attr_string varchar(30) not null commnet '商品选择属性字符串',
  goods_price decimal(10,2) not null comment '价格',
  goods_number int unsigned not null comment '数量',
  key order_id(order_id),
  key goods_id (goods_id)
)engine=InnoDB default charset=utf8 comment '订单商品表';
