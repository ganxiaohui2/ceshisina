# [grep&正则表达式][0]

 目录

[grep 文本过滤工具][1]

[正则表达式][2]

[字符匹配][3]

[匹配次数][4]

[位置锚定][5]

[后向引用][6]

[扩展的正则表达式][7]

[小练习][8]

## grep 文本过滤工具 

**命令： grep**

**格式： grep [OPTIONS] PATTERN**

选项：**** --color=auto 将匹配的结果着色显示

-v 反向匹配

- i  忽略大小写

-n 显示的结果前增加行号

-c 仅显示匹配到结果的行数

-o 仅显示匹配到的字符串

-q 静默模式，不输出任何信息  相当于 &> /dev/null

-A# 显示关键字行及向后 # 行

-B# 显示关键字行及向前 # 行

-C# 显示关键字向前 # 行，当前行，及向后 # 行

-e 关键字 1 -e 关键字 2  实现多个选项间的逻辑 or 关系

-w 匹配整个单词

-E 使用扩展正则表达式 或 egrep

-F 不使用正则表达式 或  fgrep

Patten 格式：引用变量或文本用“” or ‘’引起来，

 引用命令则用 `` （反引号）引起来。

## 正则表达式 

正则表达式是 由一类特殊字符及文本字符所编写的模式，其中有些字符（元字符）不表示字符字面意义，而表示控制或通配的功能。 支持程序有 grep ， sed ， awk ， vim ， less ， nginx ， varnish ……它分为基本正则表达式和扩展正则表达式两类，用于 grep 中， 则 grep 后支持基本正则表达式， grep -E 或 egrep 后支持扩展正则表达式。

### 字符匹配 

字符 | 含义
-|-
`.`  | 匹配单个字符
`[]` | 匹配指定范围内的任意单个字符
`[^]` | 匹配指定范围外的任意单个字符
`[: alnum :]` | 所有字母和数字
`[:alpha :]` | 所有大小写字母（ a-z&A-Z ）
`[:lower :]` | 小写字母（ a-z ）
`[:upper :]` | 大写字母（ A-Z ）
`[:digit :]` | 十进制数字（ 0-9 ）
`[: xdigit :]` | 十六进制数字
`[:blank :]` | 空白字符（空格和制表符 tab ）
`[:space :]` | 水平和垂直的空白字符（比 `[:black:]` 范围广）
`[: punct :]` | 标点符号
`[:graph :]` | 可打印的非空白字符
`[:print:]` | 可打印字符
`[: cntrl :]` | 不可打印的控制字符（退格、删除、警铃……）

### 匹配次数 

匹配次数用于要指定次数的字符后面，用于指定前面的字符要出现的次数。

字符 | 含义
-|-
`*` | 匹配前面的字符任意次，包括 0 次 <br/> （贪婪模式：尽可能长的匹配）
`.*` | 匹配任意长度的任意字符
`\?` | 匹配其前面的字符 0 次或 1 次
`\+` | 匹配其前面的字符至少 1 次
`\{n\}` | 匹配其前面的字符 n 次
`\{ m,n \}` | 匹配其前面的字符至少 m 次，至多 n 次
`\ {,n \}` | 匹配其前面的字符至多 n 次
`\{ n,\ }` | 匹配其前面的字符至少 n 次


### 位置锚定 

位置锚 定用于 定位出现的位置。

字符 | 含义
-|-
`^` | 行首锚定，用于模式的最左侧
`$` | 行尾锚定，用于模式的最右侧
`^PATTERN$` | 用于模式匹配整行  
`^$` | 空行  
`^[[:space:]]$` | 空白行
`\< or \b` | 词首锚定，用于单词模式的左侧
`\> or \b` | 词尾锚定，用于单词模式的右侧
`\<PATTERN\>` | 匹配整个单词

### 后向引用 

说到后向引用，我们先要了解一个概念——分组。分组就是用`（）`把一个或多个字符捆绑在一起， 当做 一个整体进行处理，当然，在我们的基本正则表达式中，`（）`需要用 `\` 来转义，所以，用法如下：

`\(root\)\+`  代表匹配 root 至少一次

在分组括号中的模式匹配到的内容会被正则表达式引擎记录与内部的变量中，这些变量的命名方式为： `\1` ， `\2` ， `\3` ……

`\n` 就是从左侧起第 n 个 左括号以及与之匹配的有括号之间的模式所匹配到的字符。

eg ：   
`\(string1\+\(string2 \)* \)`

\1 ： `string1\+\(string2 \)*`

\2 ： `string2`

后向引用：引用前面的分组括号中的模式所匹配的字符，而 非模式 本身。

单说概念大家应该不会很明白，那我们来看一个例子，因为后向引用很重要，所以我们就说细致一点。（敲黑板！划重点！）

![][9]

这个是我们的文件，如果我们想匹配所有行，应该怎么做呢？就用到我们上面所说到的正则表达式的知识。

![][10]

我们把这个命令单独拉出来说： `grep "^h.\{4\ }.* h.\{4\}$" example`

`^h.\{4 \}` 表示匹配以 `h` 后加任意 4 个字符为开头， `.*` 表示匹配任意多个字符，` h.\{4\}$` 表示匹配以 `h` 后加任意 4 个字符为结尾。 hello 和 hiiii 都是以 `h` 后跟 4 个任意字符组成的，所以上述命令就可以匹配所有的行。

那么，如果我只想匹配开头和结尾单词一样的行呢？也就是职匹配前两行。这个时候，我们就要用到后向引用了，如下：

![][11]

上述命令就可以完成我们的需求，我们来详细的说一下这个命令。

分为两部分：红框内： `\(h. \{ 4\}\)`  蓝框内： `\1`

先说红框内的，这个和我们上一个示例没有区别，只是加了 `\(\)` 括 起来，含义还是不变，依然表示 `h` 后跟任意 4 个字符。

那么 蓝框 内呢？是什么意思？

“ `\1` ”表示的就是从左侧起第 1 个左括号以及与之匹配的有括号之间的模式所匹配到的字符。上述我们只有一对括号，所以 蓝框 内的 “ `\1` ” 表示的就是红框内 “ `\(h.\{4\}\)` ” 所匹配到的内容。如果没看明白，那么看看下面这张图吧：

![][12]

现在可以明白为什么要添加括号分组了吗？因为当我们添加了括号分组，“ `h.\{4\}` ”就成为整个正则中第 1 个分组中的正则，当“ `h.\{4\}` ”匹配到的结果为 hello 时，“ `\1` ”引用的就是 hello ，当“ `h.\{4\}` ”匹配到的结果是 hiiii 时，“ `\1` ”引用的就是 hiiii 。

这个就是所谓的后项引用了。当然， `\2` ， `\3` 的内容相信也就不言而喻了。

## 扩展的正则表达式 

**命令： egrep = grep -E**

**格式： egrep [OPTIONS] PATTERN [FILE...]**

扩展的正则表达式与正则表达式的元字符大致一样。为什么叫他扩展的正则表达式呢？因为 在扩展正则表达式中，除了 词首词尾锚定 和 后项引用 以外，其他的元字符都可以直接引用，不需要加“ `\` ”转义。

## 小练习 

讲了这么多东西，我们来做 一些题练练手 吧 ~ 提供的答案仅为参考，因为不同的解题思路，你的解题步骤也会有所不同喏，小伙伴们尽情发挥吧 ( 〃 '▽' 〃 )

1 、统计当前连接本机的每个远程主机 IP 的连接数，并按从大到小排序

    netstat -tun |grep "[0-9]" |tr -s " " ":" |cut -d: -f6 |sort |uniq -c |sort -n

2 、显示 / etc / passwd 文件中不以 /bin/bash 结尾的行

    cat /etc/passwd | grep -v /bin/bash$

3 、找出 / etc / passwd 中的两位或三位数

    cat /etc/passwd |grep "\b[0-9]\{2,3\}\b"

4 、显示 CentOS7 的 / etc /grub2.cfg 文件中，至少以一个空白字符开头的且 后面存非 空白字符的行

    cat /etc/grub2.cfg |grep "^[[:space:]]\+[^[:space:]].*$"

5 、 使用 egrep 取出 / etc / rc.d / init.d /functions 中其基名

    echo /etc/rc.d/init.d/functions | egrep -o "[^/]+/?$"

6 、找出 / etc / rc.d / init.d /functions 文件中行首为某单词 ( 包括下划线 ) 后面跟一个小括号的行

    cat /etc/rc.d/init.d/functions |egrep "^.*[^[:space:]]\(\)"

7 、统计 last 命令中以 root 登录的每个主机 IP 地址登录次数

    last |grep ^root |egrep -o "([0-9]{1,3}\.){3}[0-9]{1,3}" |sort |uniq -c

8 、显示 ifconfig 命令结果中所有 IPv4 地址

    ifconfig | egrep -o "\<(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4]0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\>"

9 、显示三个用户 root 、 mage 、 wang 的 UID 和默认 shell

    cat /etc/passwd |egrep "^(root|mage|wang)\b" |cut -d: -f3,7

10 、只利用 df 、 grep 和 sort ，取出磁盘各分区利用率，并从大到小排序

    df |grep sd |grep -Eo "[0-9]{1,3}%" |sort -nr

[0]: http://www.cnblogs.com/keerya/p/7307026.html
[1]: #_Toc489968228
[2]: #_Toc489968229
[3]: #_Toc489968230
[4]: #_Toc489968231
[5]: #_Toc489968232
[6]: #_Toc489968233
[7]: #_Toc489968234
[8]: #_Toc489968235
[9]: ../img/2092631496.png
[10]: ../img/982231790.png
[11]: ../img/1832960384.png
[12]: ../img/285303028.png