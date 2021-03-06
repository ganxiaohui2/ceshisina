## [Just for fun——windows上的php-fpm](https://segmentfault.com/a/1190000010871293)

# fastcgi

As we all know，nginx配php是通过**fastcgi（一个类似http的协议，升级版的cgi）**的。在linux上有php-fpm帮你管理进程，在windows似乎没有，这是有点令人悲伤的。

# php-cgi-spawner

Github这么神奇的地方，怎么会有你找不到的东西呢？我找到了这个库[php-cgi-spawner][0]，这个库是用C语言写的，看了源码，它自己简单实现了fastcgi和进程管理

# 一步步使用

1. 下载php，我下载了VC14 x64 Non Thread Safe（多进程，所以不用线程安全）的PHP 7.0 (7.0.22) [php 7.0.22][1]，D盘新建一个wnp的文件夹（winodws，nginx，php），把下载文件放进去，解压为php7，注意php7需要VC14的支持，没装的要装下VC运行库[VC 2015 64位][2]
1. 下载nginx，下载最新稳定的nginx，[nginx-1.12.1][3]，也放到wnp中，解压为nginx
1. 下载php-cgi-spawner.exe（下载很慢，用我的七牛链接：[php-cgi-spawner][4]），整个目录文件如下：


![][5]

1. 然后修改php.ini（把php.ini-development或者php.ini-production改名过来），修改extension_dir（去掉;）为当前php7中ext文件夹的路径，也就是D:/wnp/php7/ext。检验一下：

```
    D:\wnp\php7>php.exe -v
    PHP 7.0.22 (cli) (built: Aug  1 2017 14:13:41) ( NTS )
    Copyright (c) 1997-2017 The PHP Group
    Zend Engine v3.0.0, Copyright (c) 1998-2017 Zend Technologies
```

然后开启php-cgi-spawner：

    set PHP_HELP_MAX_REQUESTS = 100
    php-cgi-spawner.exe "php7/php-cgi.exe -c php7/php.ini" 9000 4+16

![][6]

然后配置nginx中conf里nginx.conf文件：

```nginx
     server {
            listen       80;
            server_name  localhost;
            index index.php index.html;
            root D:/web_root;
    
            #charset koi8-r;
    
            #access_log  logs/host.access.log  main;
    
            # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
            #
            location ~ \.php$ {
                fastcgi_pass   127.0.0.1:9000;
                fastcgi_index  index.php;
                fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name;
                include        fastcgi_params;
            }
    }
```
在D盘建立一个web_root的文件夹，放入index.php，开启nginx测试

![][7]   
index.php写入

```php
    <?php
    echo "hello  world";
```
访问[http://localhost][8]

![][9]

# 应用

我的wnmp项目就用了这个东西，[SalamanderWnmp][10]，欢迎star

[0]: https://github.com/deemru/php-cgi-spawner
[1]: http://windows.php.net/downloads/releases/php-7.0.22-nts-Win32-VC14-x86.zip
[2]: https://download.microsoft.com/download/9/3/F/93FCF1E7-E6A4-478B-96E7-D4B285925B00/vc_redist.x64.exe
[3]: http://nginx.org/download/nginx-1.12.1.zip
[4]: http://ongd1spyv.bkt.clouddn.com/php-cgi-spawner.exe
[5]: ../img/bVTMgD.png
[6]: ../img/bVTMg1.png
[7]: ../img/bVTMhi.png
[8]: http://localhost
[9]: ../img/bVTNpW.png
[10]: https://github.com/salamander-mh/SalamanderWnmp