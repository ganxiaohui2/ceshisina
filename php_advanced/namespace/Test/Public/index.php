<?php  
  
//装载自动加载函数  
// $autoLoadFilePath = dirname($_SERVER['DOCUMENT_ROOT']).DIRECTORY_SEPARATOR.'vendor'.DIRECTORY_SEPARATOR.'autoload.php';  
// require_once $autoLoadFilePath;  
require_once "../vendor/autoload.php";  
  
$test = new \Admin\test();  
$test->sayHi();  

$home = new \Home\Home();
echo $home->getHome();