#!/bin/bash
#常用定义方法：
func_1() {
    #局部变量
    local num=6
    #嵌套执行函数
    func_2
    #函数的return值保存在特殊变量?中
    if [ $? -gt 10 ];then
        echo "大于10"
    else
        echo "小于等于10"
    fi
}
################
func_2()
{
    # 内置命令return使函数退出，并使其的返回值为命令后的数字
    # 如果return后没有参数，则返回函数中最后一个命令的返回值
    return $((num+5))
}
#执行。就如同执行一个简单命令。函数必须先定义后执行(包括嵌套执行的函数)
func_1
###############
#一般定义方法
#函数名后面可以是任何复合命令：
func_3() for NUM
do
    # 内置命令shift将会调整位置变量，每次执行都把前n个参数撤销，后面的参数前移。
    # 如果shift后的数字省略，则表示撤销第一个参数$1，其后参数前移($2变为$1....)
    shift
    echo -n "$((NUM+$#)) "
done
#函数内部位置变量被重置为函数的参数
func_3 `seq 10`;echo