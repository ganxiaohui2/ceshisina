## 巧用JS位运算

来源：[https://fed.renren.com/2018/03/06/js-bit-algorithm/](https://fed.renren.com/2018/03/06/js-bit-algorithm/)

时间 2018-03-06 23:46:08

 
位运算的方法在其它语言也是一样的，不局限于JS，所以本文提到的位运算也适用于其它语言。
 
位运算是低级的运算操作，所以速度往往也是最快的，相对其它运算如加减乘除来说，并且借助位运算的特性还能实现一些算法，可以说恰当地使用运算还是有很多好处的。
 
### 1. 使用按位非~判断索引存在
 
这是一个很常用的技巧，如判断一个数是否在数组里面：

```js
// 如果url含有?号，则后面拼上&符号，否则加上?号
url += ~url.indexOf("?") ? "&" : "?";

```
 
因为
 
`~-1 === 0`
 
-1在内存的表示的二进制符号全为1，按位非之后就变成了0. 进一步说明，1在内存的表示为: 0000…0001，第一位0表示符号位为正，如果是-1的话符号位为负用1表示1000…0001，这个是-1的原码，然后符号位不动，其余位取反变成1111…1110，这个就是-1的反码表示，反码再加1就变成了1111…1111，这个就是-1的补码，负数在内存里面（机器数）使用补码表示，正数是用原码。所以全部都是1的机器数按位非之后就变成了全为0的数即0。剩下的其它所有数按位非都不为0，所以利用这个特性可以用来做indexOf的判断，这样代码看起来更简洁一点。
 
### 2. 使用异或交换两个数
 
交换两个整数的值，最直观的做法是这样：

```js
let a = 5,
    b = 6;
// 交换a, b的值 
let c = a;
a = b;
b = c;

```
 
现在要求不能使用额外的变量或内容空间交换两个整数的值。这个时候就得借助位运算，使用异或可以达到这个目的：

```js
let a = 5,
    b = 6;
 
a = a ^ b;
b = a ^ b; // b 等于 5
a = a ^ b; // a 等于 6

```
 
这个是为什么呢？很简单，把1、2式：

```js
a = a ^ b;
b = a ^ b;

```
 
连起来就等价于：

```js
b = (a ^ b) ^ b = a ^ (b ^ b) = a ^ 0 = a;

```
 
同理连同第3式可得：

```js
a = (a ^ b) ^ a  // 在执行第3式的时候b已经变成a了，而a是第1式的a ^ b
  = a ^ a ^ b = 0 ^ b = b;

```
 
为什么a ^ a = 0, b ^ b = 0呢？因为异或的运算就是这样的。如下示例：

```js
  01011010
^ 10010110
-----------
  11001100

```
 
异或的运算过程可以当作把两个数加起来，然后进位去掉，0 + 0 = 0，1 + 0 = 1，1 + 1 = 0。这样就很好记。所以a ^ a在所有二进制位上，要么同为0，要么同为1，相加结果都为0，最后就为0.
 
异或还经常被用于加密。
 
### 3. 使用按位与&去掉高位
 
按位与有很多作用，其中一个就是去操作数的高位，只保留低位，例如有a, b两个数：

```js
let a = 0b01000110; // 十进制为70
let b = 0b10000101; // 十进制为133

```
 
现在认为他们的高位是没用的，只有低4位是有用的，即最后面4位，为了比较a，b后4位的大小，可以这样比较：

```js
a & 0b00001111 < b & 0b00001111 // true

```
 
a, b的前4位和0000与一下之后就都变成0了，而后四位和1111与一下之后还是原来的数。这个实际的作用是有一个数字它的前几位被当作A用途，而后几位被用当B用途，为了去掉前几位对B用途的影响，就可以这样与一下。
 
另外一个例子是子网掩码，假设现在我是网络管理员，我能够管理的IP地址是从192.168.1.0到192.168.1.255，即只能调配最后面8位。现在把这些IP地址分成3个子网，通过IP地址进行区分，由于6等于二进制的110，所以最后面8位的前3位用来表示子网，而后5位用来表示主机（即总的主机数最多为0b00001 ~ 0b11111， 30个）。所以当前网络的子网掩码为255.255.255.110 00000即255.255.255.192，假设某台主机的IP地址为192.168.1.120，现在要知道它处于哪个子网，可以用它IP地址与子网掩码与一下：120 & 192 = 64 = 0b010 00000，所以它所在的子网为010即2号子网。
 
这个是保留高位去掉低位的例子，刚好与上面的例子相反。
 
### 4. 使用按位与&进行标志位判断
 
现在有个后台管理系统，操作权限分为一级、二级、三级管理员，其中一级管理员拥有最高的权限，二、三级较低，有些操作只允许一、二级管理员操作，有些操作只允许一、三级管理员操作。现在已经登陆的某权限的用户要进行某个操作，要用怎样的数据结构才能很方便地判断他能不能进行这个操作？
 
我们用位来表示管理权限，一级用第3位，二级用第2位，三级用第3位，即一级的权限表示为0b100 = 4，二级权限表示为0b010 = 2，三级权限表示为0b001 = 1。如果A操作只能由一级和二级操作，那么这个权限值表示为6 = 0b110，它和一级权限与一下：6 & 4 = 0b110 & 0b100 = 0b100 = 4，值不为0，所以认为有权限，同理和二级权限与一下6 & 2 = 2也不为0，而与三级权限与一下6 & 1 = 0，所以三级没有权限。
 
这样的好处在于，我们可以用一个数字，而不是一个数组来表示某个操作的权限集，在进行权限判断的时候也很方便。
 
### 5. 使用按位|构造属性集
 
上面构造了一个权限的属性集，属性集的例子还有很多，例如我在《 [Google地图开发总结][1] 》里面就提到一个边界判断的例子——要在当前鼠标的位置往上弹一个悬浮框，如下图左所示，但是当鼠标比较靠边的时候就会导致悬浮框超出边界了，如下图右所示： 
 

![][0]
 
为此，需要做边界判断，总共有3种超出情况：右、上、左，并且可能会叠加，如鼠标在左上角的时候会导致左边和上面同时超出。需要记录超出的情况进行调整，用001表示右边超出，010表示上方超出，100表示左边超出，如下代码计算：

```js
let postFlag = 0;
//右边超出
if(pos.right < maxLen) posFlag |= 1;
//上面超出
if(pos.top < maxLen) posFlag |= 2;
//左边超出
if(pos.left < maxLeftLen) posFlag |= 4;
//对超出的情况进行处理，代码略
switch(posFlag){
      case 1: //右
      case 2: //上
      case 3: //右上
      case 4: //左
      case 6: //左上
}

```
 
如果左边和上面同时超出，那么通过或运算2 | 4 = 6，得到6 = 0b110. 这样代码相对于在if里面写两个判断要好一些。
 
### 6. 位运算的综合应用
 
这里有个例子——不使用加减乘除来做加法，经常用来考察对位运算的掌握情况。读者可以先自行尝试分析和实现。
 
不能用加减乘除，意思就是要用位运算进行计算。以实际例子说明，如a = 81 = 0b1010001，b = 53 = 0b0110101。通过异或运算，我们发现异或把两个数相加但是不能进位，而通过与运算能够知道哪些位需要进位，如下所示：

```js
  1010001
^ 0110101
 ---------
  1100100
 
  1010001
& 0110101
 ---------
  0010001

```
 
把通过与运算得到的值向左移一位，再和通过异或得到的值相加，就相当于实现了进位，这个应该不难理解。为了实现这两个数的相加可以再重复这个过程：先异或，再与，然后进位，直到不需要再进位了就加完了。所以不难写出以下代码：

```js
function addByBit(a, b) {
    if (b === 0) {
        return a;
    }
    // 不用进位的相加
    let c = a ^ b;
    // 记录需要进位的
    let d = a & b;
    d = d << 1;
    // 继续相加，直到d进位为0
    return addByBit(c, d);
}
 
let ans = addByBit(5, 8);
console.log(ans);

```
 
位运算还经常用于生成随机数、哈希，例如Chrome对字符串进行哈希的算法是这样的：

```js
uint32_t StringHasher::AddCharacterCore(uint32_t running_hash, uint16_t c) {
  running_hash += c;
  running_hash += (running_hash << 10);
  running_hash ^= (running_hash >> 6);
  return running_hash;
}

```
 
不断对当前字符串的ASCII值进行累加运算，里面用到了异或，左移和右移。
 
本篇介绍了使用位运算的几个实际的例子，希望能加深位运算的理解，并对开发有帮助。
 
浏览量: 3 
 


[1]: http://yincheng.site/google-map
[0]: https://img0.tuicool.com/iuyyuqa.jpg