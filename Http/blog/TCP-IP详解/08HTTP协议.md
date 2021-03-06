<style type="text/css">
    body{background: rgba(12, 100, 129, 0.2)}
</style>
# [TCP/IP（七）之玩转HTTP协议][0]

**阅读目录(Content)**

* [一、HTTP协议概述][1]
    * [1.1、HTTP协议简介][2]
    * [1.2、HTTP协议特点][3]
* [二、URL和URI][4]
    * [2.1、URL][5]
    * [2.2、URI和URI的区别][6]
* [三、工作流程][7]
* [四、HTTP中请求消息（request）][8]
    * [4.1、请求消息格式][9]
    * [4.2、用GET请求的请求报文][10]
    * [4.3、用POST请求的请求报文][11]
* [五、HTTP请求详解][12]
    * [5.1、HTTP请求方法][13]
    * [5.2、GET和POST请求的区别][14]
* [六、HTTP中响应消息（response）][15]
    * [6.1、响应消息格式][16]
    * [6.2、响应消息][17]
    * [6.3、响应状态码][18]
* [七、HTTP工作原理][19]

 **前言**

前面一篇的博文简单的介绍了一下属于应用层的HTTP协议，这一篇我将详细的学习HTTP协议，这也是做Web开发中一定要用到的协议。虽然我是做大数据的，但是多学习一点肯定是

没有坏处的。国庆放假7天，很多人都是想着怎么玩，我也很想出去玩，但是没有办法，努力才能有出路，加油！

[回到顶部(go to top)][20]

# 一、HTTP协议概述

## 1.1、HTTP协议简介

1）协议： 计算机通信网络中两台计算机之间进行通信所必须共同遵守的规定或规则 ，超文本传输协议(HTTP)是一种 通信协议 ，它允许 将超文本标记语言(HTML)文档从Web服务器传送到客户端的浏览器。

2）HTTP协议是Hyper Text Transfer Protocol（超文本传输协议）的缩写,是用于从万维网（WWW:World Wide Web ）服务器传输超文本到本地浏览器的传送协议。

3）HTTP是一个基于 TCP/IP通信协议来传递数据 （HTML 文件, 图片文件, 查询结果等）。

4） HTTP是一个 属于应用层的面向对象的协议 ，由于其简捷、快速的方式，适用于分布式超媒体信息系统。它于1990年提出，经过几年的使用与发展，得到不断地完善和扩展。

目前在WWW中使用的是HTTP/1.0的第六版，HTTP/1.1的规范化工作正在进行之中，而且HTTP-NG(Next Generation of HTTP)的建议已经提出。

5）HTTP协议工作于 客户端-服务端架构为上 。 浏览器作为HTTP客户端通过URL向HTTP服务端即WEB服务器发送所有请求。Web服务器根据接收到的请求后，向客户端发送响应信息 。

![][21]

## 1.2、HTTP协议特点

1）简单快速：客户向服务器请求服务时， 只需传送请求方法和路径。请求方法常用的有GET、HEAD、POST 。每种方法规定了客户与服务器联系的类型不同。由于HTTP协议简单，使得HTTP服务器的程序规模小，因而通信速度很快。

2）灵活： HTTP允许传输任意类型的数据对象 。正在传输的类型由Content-Type加以标记。

3）无连接：无连接的含义是 限制每次连接只处理一个请求 。服务器处理完客户的请求，并收到客户的应答后，即断开连接。采用这种方式可以节省传输时间。

4）无状态：HTTP协议是 无状态协议 。 无状态是指协议对于事务处理没有记忆能力。缺少状态意味着如果后续处理需要前面的信息，则它必须重传，这样可能导致每次连接传送的数据量增大。

另一方面，在服务器不需要先前信息时它的应答就较快。  
5）支持B/S及C/S模式。 

[回到顶部(go to top)][20]

# 二、URL和URI

## 2.1、URL

其实前面已经简单的知道了什么是URL。

HTTP使用统一资源标识符（Uniform Resource Identifiers, URI）描述一个网络上的资源，来 传输数据和建立连接 。URL是一种特殊类型的URI，包含了用于查找某个资源的足够的信息。

URL,全称是UniformResourceLocator, 中文叫 统一资源定位符 ,是互联网上用来标识某一处资源的地址，它的组成部分是：

http://www.zyh.com:8080/woss/index.html?username=10086&password=123456#name 

从上面的URL可以看出，一个完整的URL包括以下几部分：  
1）协议部分：该URL的协议部分为“http：”，这代表网页使用的是HTTP协议。在Internet中可以使用多种协议，如HTTP，FTP等等本例中使用的是HTTP协议。在"HTTP"后面的“//”为分隔符

2）域名部分：该URL的域名部分为“www.zyh.com”。一个URL中，也可以使用IP地址作为域名使用

3）端口部分：跟在域名后面的是端口，域名和端口之间使用“:”作为分隔符。端口不是一个URL必须的部分，如果省略端口部分，将采用默认端口（80）

4）虚拟目录部分：从域名后的第一个“/”开始到最后一个“/”为止，是虚拟目录部分。虚拟目录也不是一个URL必须的部分。本例中的虚拟目录是“/woss/”

5）文件名部分：从域名后的最后一个“/”开始到“？”为止，是文件名部分，如果没有“?”,则是从域名后的最后一个“/”开始到“#”为止，是文件部分，如果没有“？”和“#”，那么从域名后的最后一个“/”开始到结束，

都是文件名部分。本例中的文件名是“index.html”。文件名部分也不是一个URL必须的部分，如果省略该部分，则使用默认的文件名

6）锚部分：从“#”开始到最后，都是锚部分。本例中的锚部分是“name”。锚部分也不是一个URL必须的部分

7）参数部分：从“？”开始到“#”为止之间的部分为参数部分，又称搜索部分、查询部分。本例中的参数部分为“username=10086&password=123456”。参数可以允许有多个参数，参数与参数之间用“&”作为分隔符。

## 2.2、URI和URI的区别

1）URI，是uniform resource identifier， 统一资源标识符，用来唯一的标识一个资源 。  
Web上可用的每种资源如HTML文档、图像、视频片段、程序等都是一个来URI来定位的  
URI一般由三部组成：  
访问资源的命名机制  
存放资源的主机名  
资源自身的名称，由路径表示，着重强调于资源。

2）URL是uniform resource locator，统一资源定位器， 它是一种具体的URI，即URL可以用来标识一个资源，而且还指明了如何locate这个资源 。  
URL是Internet上用来描述信息资源的字符串，主要用在各种WWW客户程序和服务器程序上，特别是著名的Mosaic。  
采用URL可以用一种统一的格式来描述各种信息资源，包括文件、服务器的地址和目录等。URL一般由三部组成：  
协议(或称为服务方式)  
存有该资源的主机IP地址(有时也包括端口号)  
主机资源的具体地址。如目录和文件名等

[回到顶部(go to top)][20]

# 三、工作流程

一次HTTP操作称为一个事务，其工作过程可分为四步：  
1）首先 客户机与服务器需要建立连接。只要单击某个超级链接，HTTP的工作开始 。  
2）建立连接后， 客户机发送一个请求给服务器 ，请求方式的格式为： 统一资源标识符（URL）、协议版本号，后边是MIME信息包括请求修饰符、客户机信息和可能的内容 。  
3）服务器接到请求后，给予相应的 响应信息 ，其格式为 一个状态行，包括信息的协议版本号、一个成功或错误的代码，后边是MIME信息包括服务器信息、实体信息和可能的内容。   
4）客户端接收服务器所返回的信息 通过浏览器显示在用户的显示屏上，然后客户机与服务器断开连接 。  
如果在以上过程中的某一步出现错误，那么产生错误的信息将返回到客户端，有显示屏输出。对于用户来说，这些过程是由HTTP自己完成的，用户只要用鼠标点击，等待信息显示就可以了。

我们用图来理解一下： 

当我们打开浏览器，在地址栏中输入URL，然后我们就看到了网页。 

实际上我们输入URL后，我们的 浏览器给Web服务器发送了一个Request, Web服务器接到Request后进行处理，生成相应的Response，然后发送给浏览器， 浏览器解析Response中的HTML,这样我们就看到了网页 ，过程如下图所示：

![][22]

我们的Request 有可能是经过了代理服务器，最后才到达Web服务器的。过程如下图所示：

![][23]

代理服务器就是网络信息的中转站，它的功能是：

提高访问速度， 大多数的代理服务器都有缓存功能。

突破限制， 也就是FQ了

隐藏身份。

注意：

HTTP是基于 传输层的TCP协议，而TCP是一个端到端的面向连接的协议。所谓的端到端可以理解为进程到进程之间的通信。 所以HTTP在开始传输之前，首先需要建立TCP连接，而TCP连接的过程需要所谓的“三次握手”。

下图所示TCP连接的三次握手。  
在TCP三次握手之后，建立了TCP连接，此时HTTP就可以进行传输了。一个重要的概念是面向连接，既 HTTP在传输完成之间并不断开TCP连接。在HTTP1.1中(通过Connection头设置)这是默认行为 。

![][24]

[回到顶部(go to top)][20]

# 四、HTTP中请求消息（request）

## 4.1、请求消息格式

客户端发送一个HTTP请求到服务器的请求消息是有一定的格式：

![][25]

从上面可以看出来，请求消息由四部分组成：

 请求行（request line）、请求头部（header）、空行和请求数据 四个部分组成

![][26]

第一行中的Method 表示请求方法 ,比如"POST","GET", Path-to-resoure表示请求的资源（url） ， Http/version-number 表示 HTTP协议的版本号

当使用的是"GET" 方法的时候， body是为空的。

## 4.2、用GET请求的请求报文

当我们访问搜狐的官网的时候，我使用的是Firebug抓取的请求消息

![][27]

第一部分：请求行，用来说明 请求类型,要访问的资源以及所使用的HTTP版本 。

GET /http://www.sohu.com HTTP/1.1 请求行，只不过这里被分开了，请求的方式 URL 版本

第二部分：请求头部，紧接着请求行（即第一行）之后的部分，用来 说明服务器要使用的附加信息 。 

1）Host：主机名 www.solu.com 

2）User-Agent：使用什么代理服务器，这里就是FireFox，也就是火狐

3）Accept：能 接收的数据类型有哪些

4）Accept-Language：表示用户希望 优先想得到的版本，一次排列下去，先是中文，再是英文

5）Accept-Encoding：通知 服务端可以发送的数据压缩格式

6）Cookie：浏览器端的一个技术，在 服务器上记录用户信息，但是也会在浏览器中保存一份 。

7）Connection：连接的方式，有两种， 非持续连接和持续连接，非持续连接，一次请求/响应就对应一个TCP连接，接到了响应该连接就关闭，然后在发送请求就在建立TCP连接，持续连接就相反，这里使用的是持续连接

8）Upgrade-Insecure-Requests：该指令用于让浏览器自动升级请求从http到https,用于大量包含http资源的http网页直接升级到https而不会报错.简洁的来讲,就相当于在http和https之间起的一个过渡作用。

第三部分：空行，请求头部后面的空行是必须的  
即使第四部分的 请求数据为空，也必须有空行 。 

第四部分：请求数据也叫主体，可以添加任意的其他数据。  
使用GET方式请求时请求数据为空。

由于一般请求报文都不会有请求数据的，所以在9后面就没有内容了，一般如果想要发送数据过去度会通过在域名后面加?然后将数据创送过去

## 4.3、用POST请求的请求报文

![][28]

第一部分：请求行，第一行明了是post请求，以及http1.1版本。  
第二部分：请求头部，第二行至第六行。  
第三部分：空行，第七行的空行。  
第四部分：请求数据，第八行。

[回到顶部(go to top)][20]

# 五、HTTP请求详解

## 5.1、HTTP请求方法

根据HTTP标准，HTTP请求可以使用多种请求方法。  
HTTP1.0定义了三种请求方法： GET, POST 和 HEAD方法。 

    GET：请求指定的页面信息，并返回实体主体。
    POST： 向指定资源提交数据进行处理请求（例如提交表单或者上传文件）。数据被包含在请求体中。POST请求可能会导致新的资源的建立和/或已有资源的修改。
    HEAD： 类似于get请求，只不过返回的响应中没有具体的内容，用于获取报头

HTTP1.1新增了五种请求方法：OPTIONS, PUT, DELETE, TRACE 和 CONNECT 方法。

    PUT：从客户端向服务器传送的数据取代指定的文档的内容。
    DELETE ：请求服务器删除指定的页面。
    CONNECT：HTTP/1.1协议中预留给能够将连接改为管道方式的代理服务器。
    OPTIONS： 允许客户端查看服务器的性能。
    TRACE：回显服务器收到的请求，主要用于测试或诊断。

## 5.2、GET和POST请求的区别

Http协议定义 了很多与服务器交互的方法，最基本的有4种，分别是GET,POST,PUT,DELETE.。 一个URL地址用于描述 一个网络上的资源，而HTTP中的GET, POST, PUT, DELETE就对应着对这个资源的查，改，增，删4个操作 。

我们最常见的就是GET和POST了。 GET一般用于获取/查询资源信息，而POST一般用于更新资源信息。

1）提交数据方式：GET提交， 请求的数据会附在URL之后（就是把数据放置在HTTP协议头中），以?分割URL和传输数据，多个参数用&连接 。

例 如：login.action?name=hyddd&password=idontknow&verify=%E4%BD%A0 %E5%A5%BD。如果数据是 英文字母/数字，原样发送 ，如果是空格，转换为+，

如果是 中文/其他字符，则直接把字符串用BASE64加密 ，得出如： %E4%BD%A0%E5%A5%BD，其中％XX中的XX为该符号以16进制表示的ASCII。

POST提交：把 提交的数据放置在是HTTP包的包体 中。在前面的例子中提交的数据就是在回车换行的下面。 

2）传输数据的大小：首先声明： HTTP协议没有对传输的数据大小进行限制，HTTP协议规范也没有对URL长度进行限制 。而在实际开发中存在的限制主要有： 

GET： 特定浏览器和服务器对URL长度有限制 ，例如 IE对URL长度的限制是2083字节(2K+35)。对于其他浏览器，如Netscape、FireFox等，理论上没有长度限制，其限制取决于操作系 统的支持。

因此对于GET提交时，传输数据就会受到URL长度的 限制。

POST：由于不是通过URL传值，理论上数据不受 限。但 实际各个WEB服务器会规定对post提交数据大小进行限制 ，Apache、IIS6都有各自的配置。

3）安全性： POST的安全性要比GET的安全性高 。比如：通过GET提交数据，用户名和密码将明文出现在URL上，因为(1)登录页面有可能被浏览器缓存；(2)其他人查看浏览器的历史纪录，那么别人就可以拿到你的账号和密码了，

除此之外，使用GET提交数据还可能会造成Cross-site request forgery攻击。

4）Http get,post,soap协议都是在http上运行的 

get：请求参数是作为一个key/value对的序列（查询字符串）附加到URL上的  
查询字符串的长度受到web浏览器和web服务器的限制（如IE最多支持2048个字符），不适合传输大型数据集同时，它很不安全

post：请求参数是在http标题的一个不同部分（名为entity body）传输的，这一部分用来传输表单信息，因此必须将Content-type设置为:application/x-www-form- urlencoded。

post设计用来支持web窗体上的用户字段，其参数也是作为key/value对传输。但是：它不支持复杂数据类型，因为post没有定义传输数据结构的语义和规则。

soap：是http post的一个专用版本，遵循一种特殊的xml消息格式，Content-type设置为: text/xml 任何数据都可以xml化。  
总结上面所说的，GET和POST的区别： 

GET提交的 数据会放在URL之后 ，以?分割URL和传输数据，参数之间以&相连，如login.action?name=hyddd&password=idontknow&verify=%E4%BD%A0 %E5%A5%BD。POST方法是把 提交的数据放在HTTP包的Body中 .

GET提交的 数据大小有限制 （因为浏览器对URL的长度有限制），而POST方法提 交的数据没有限制.

GET方式需要 使用Request.QueryString来取得变量的值 ，而POST方式通过 Request.Form来获取变量的值 。

GET方式 提交数据，会带来安全问题 ，比如一个登录页面，通过GET方式提交数据时，用户名和密码将出现在URL上，如果页面可以被缓存或者其他人可以访问这台机器，就可以从历史记录获得该用户的账号和密码.

## 5.3、打开一个网页需要浏览器发送多次Request请求

1） 当你在浏览器输入URL http://www.cnblogs.com 的时候，浏览器发送一个Request去获取 http://www.cnblogs.com 的html. 服务器把Response发送回给浏览器.  
2） 浏览器分析Response中的 HTML，发现其中引用了很多其他文件，比如图片，CSS文件，JS文件。  
3） 浏览器会自动再次发送Request去获取图片，CSS文件，或者JS文件。  
4） 等所有的文件都下载成功后。 网页就被显示出来了。

[回到顶部(go to top)][20]

# 六、HTTP中响应消息（response）

## 6.1、响应消息格式

一般情况下，服务器接收并处理客户端发过来的请求后会返回一个HTTP的响应消息。格式如下：

![][29]

HTTP响应也由四个部分组成，分别是：状态行、消息报头、空行和响应正文。

## 6.2、响应消息

    

![][30]

第一部分： 状态行 ，由 HTTP协议版本号， 状态码， 状态消息 三部分组成。

第一行为状态行，（HTTP/1.1）表明HTTP版本为1.1版本，状态码为200，状态消息为（ok）

第二部分： 消息报头 ，用来说明客户端要使用的一些附加信息

第二行和第三行为消息报头。Date:生成响应的日期和时间；Content-Type:指定了MIME类型的HTML(text/html),编码类型是UTF-8

第三部分： 空行 ，消息报头后面的空行是必须的

第四部分： 响应正文 ，服务器返回给客户端的文本信息。

空行后面的html部分为响应正文。

## 6.3、响应状态码

状态代码有 三位数字组成，第一个数字定义了响应的类别 ，共分五种类别：  
1xx：指示信息--表示 请求已接收，继续处理   
2xx：成功--表示请求已被成功接收、理解、接受  
3xx：重定向--要完成请求必须进行更进一步的操作  
4xx：客户端错误--请求有语法错误或请求无法实现  
5xx：服务器端错误--服务器未能实现合法的请求

常见的状态码有： 

 

[![复制代码](//common.cnblogs.com/images/copycode.gif)](javascript:void(0); "复制代码")

    200 OK                        //客户端请求成功
    400 Bad Request               //客户端请求有语法错误，不能被服务器所理解
    401 Unauthorized              //请求未经授权，这个状态代码必须和WWW-Authenticate报头域一起使用 
    403 Forbidden                 //服务器收到请求，但是拒绝提供服务
    404 Not Found                 //请求资源不存在，eg：输入了错误的URL
    500 Internal Server Error     //服务器发生不可预期的错误
    503 Server Unavailable        //服务器当前不能处理客户端的请求，一段时间后可能恢复正常

[![复制代码](//common.cnblogs.com/images/copycode.gif)](javascript:void(0); "复制代码")

[回到顶部(go to top)][20]

# 七、HTTP工作原理

前面把HTTP的内容讲的非常的细致，那我们来总体的看一下它的工作原理吧！

HTTP协议定义 Web客户端如何从Web服务器请求Web页面，以及服务器如何把Web页面传送给客户端 。HTTP协议采用了 请求/响应模型 。客户端向服务器 发送一个请求报文 ，

请求报文包含 请求的方法、URL、协议版本、请求头部和请求数据 。服务器以 一个状态行作为响应，响应的内容包括协议的版本、成功或者错误代码、服务器信息、响应头部和响应数 据。

HTTP 请求/响应的步骤：

1）客户端连接到Web服务器

一个HTTP客户端，通常是浏览器，与Web服务器的HTTP端口（默认为80）建立一个 TCP套接字连接 。例如，http://www.oakcms.cn。

2）发送HTTP请求

通过TCP套接字，客户端向Web服务器发送一个文本的请求报文，一个请求报文由请求行、请求头部、空行和请求数据4部分组成。

3）服务器接受请求并返回HTTP响应

Web服务器解析请求，定位请求资源。服务器将资源复本写到TCP套接字，由客户端读取。一个响应由状态行、响应头部、空行和响应数据4部分组成。

4）释放连接TCP连接

若connection 模式为close，则服务器主动关闭TCP连接，客户端被动关闭连接，释放TCP连接;若connection 模式为keepalive，则该连接会保持一段时间，在该时间内可以继续接收请求;

5）客户端浏览器解析HTML内容

客户端浏览器首先解析状态行，查看表明请求是否成功的状态代码。然后解析每一个响应头，响应头告知以下为若干字节的HTML文档和文档的字符集。

客户端浏览器读取响应数据HTML，根据HTML的语法对其进行格式化，并在浏览器窗口中显示。

例如：在浏览器地址栏键入URL，按下回车之后会经历以下流程：

浏览器向 DNS 服务器请求解析该 URL 中的域名所对应的 IP 地址;

解析出 IP 地址后，根据该 IP 地址和默认端口 80，和服务器建立TCP连接;

浏览器发出读取文件(URL 中域名后面部分对应的文件)的HTTP 请求，该请求报文作为 TCP 三次握手的第三个报文的数据发送给服务器;

服务器对浏览器请求作出响应，并把对应的 html 文本发送给浏览器;

释放 TCP连接;

浏览器将该 html 文本并显示内容;

[0]: http://www.cnblogs.com/zhangyinhua/p/7614800.html
[1]: #_label0
[2]: #_lab2_0_0
[3]: #_lab2_0_1
[4]: #_label1
[5]: #_lab2_1_0
[6]: #_lab2_1_1
[7]: #_label2
[8]: #_label3
[9]: #_lab2_3_0
[10]: #_lab2_3_1
[11]: #_lab2_3_2
[12]: #_label4
[13]: #_lab2_4_0
[14]: #_lab2_4_1
[15]: #_label5
[16]: #_lab2_5_0
[17]: #_lab2_5_1
[18]: #_lab2_5_2
[19]: #_label6
[20]: #_labelTop
[21]: ./img/1045168955.png
[22]: ./img/1539783244.png
[23]: ./img/685597381.png
[24]: ./img/1642006770.png
[25]: ./img/1134722875.png
[26]: ./img/1505946240.png
[27]: ./img/1434056493.png
[28]: ./img/786954344.png
[29]: ./img/1491450577.png
[30]: ./img/1011067028.png