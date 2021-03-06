## Hash算法入门指南(聊点不一样的算法人生)

来源：[http://www.cnblogs.com/ECJTUACM-873284962/p/8919336.html](http://www.cnblogs.com/ECJTUACM-873284962/p/8919336.html)

时间 2018-04-23 15:22:00

## 前言
 
很多人到现在为止都总是问我算法该怎么学啊，数据结构好难啊怎么的，学习难度被莫名的夸大了，其实不然。对于一个学计算机相关专业的人都知道，数据结构是大学的一门必修课，数据结构与算法是基础，却常常容易被忽视，行业越浮躁，变化越快，开发平台越便捷，高级 API 越多，基本功的重要性就越容易被忽视。即使能意识到基础薄弱，肯下定决心腾出几个月时间恶补基本功不是件容易的事，尤其是参加工作后，琐事繁多，一时热血下定的决心能坚持一周都实属不易。数据结构与算法的学习难度经常被夸大，不少人甚至谈算法色变，尤其无法忍受在面试当中问及算法问题。其实多点儿耐心，多投入些时间，学习算法并不难。至少学习基础的算法并不难，理解算法和去 leetcode 一些平台刷题是两回事，刷题所涉及的算法多半需要技巧，基础的算法知识和其他计算机知识一样，不需要特别「聪明」的大脑，大多数人都能学会并完全掌握。数据结构和算法是相辅相成的，基础的其实就那么些：时间复杂度的概念，List，Array，Stack，Queue，Tree 等。Graph 实际应用中较少遇到，可以不做深入了解，但 BFS，DFS，Dijkstra 还是应该知道。基础的算法需要能达到手写的程度，比如排序至少能写出两种时间复杂度为 N*logN 的算法。理解这些比去刷海量的习题显得更为重要，学习难度也并不是太高。学习这些算法的意义在于掌握解决问题的基础思路，形成计算机思维，从而在一定程度上提升自我。
 
## 正文
 
当然我们还是需要回到本文的核心重点是需要提及hash算法，介于网上很多文章对hash 算法的实现原理和关键概念讲解的已经有很多了，秉承着让每一位学习者都尽量少走弯路的原则，我就挑其重点进行讲解，尽量地把原理性的东西讲清楚，让每一个看完文章的人都能学得会，看得明白，能理解其精髓部分。OK，开始我们的聊天之旅~~~
 
## 1.Hash是什么

首先我们先举个例子。我们每个人，为了能够参与各种社会活动，都需要一个用于识别自己的标志。也许你觉得名字或是身份证就足以代表你这个人，但是这种代表性非常脆弱，因为重名的人很多，身份证也可以伪造。最可靠的办法是把一个人的所有基因序列记录下来用来代表这个人，但显然，这样做并不实际。而指纹看上去是一种不错的选择，虽然一些专业组织仍然可以模拟某个人的指纹，但这种代价实在太高了。所以现在我们似乎考虑到用其他无法伪造的识别方法去进行辨识，比如指关节(似乎是因为有血液的流动，目前有些品牌汽车就是采用这个方式解锁)，而对于在互联网世界里传送的文件来说，如何标志一个文件的身份同样重要。比如说我们下载一个文件，文件的下载过程中会经过很多网络服务器、路由器的中转，如何保证这个文件就是我们所需要的呢？我们不可能去一一检测这个文件的每个字节，也不能简单地利用文件名、文件大小这些极容易伪装的信息，这时候，我们就需要一种指纹一样的标志来检查文件的可靠性，这种指纹就是我们现在所用的Hash算法(也叫散列算法)。

## 2.Hash表
 
大学数据结构课本排序那节有提到一个叫做hash表的东东，hash表，也叫做散列表，是根据键（Key）而直接访问在内存存储位置的数据结构。也就是说，它通过计算一个关于键值的函数，将所需查询的数据映射到表中一个位置来访问记录，这加快了查找速度。这个映射函数称做散列函数，存放记录的数组称做 **`散列表`**  。
 
一个通俗的例子是，为了查找电话簿中某人的号码，可以创建一个按照人名首字母顺序排列的表（即建立人名 到首字母 

![][0]

 的一个函数关系），在首字母为W的表中查找“王”姓的电话号码，显然比直接查找就要快得多。这里使用人名作为关键字，“取首字母”是这个例子中散列函数的函数法则 

![][1]

，存放首字母的表对应散列表。关键字和函数法则理论上可以任意确定。  

### Hash构造函数的方法            
 
散列函数能使对一个数据序列的访问过程更加迅速有效，通过散列函数，数据元素将被更快定位。我们有以下几种            Hash构造函数的方法

* 直接定址法：取关键字或关键字的某个线性函数值为散列地址。即 

![][2]

 或 

![][3]

 ，其中 

![][4]

为常数（这种散列函数叫做自身函数）             
* 数字分析法：假设关键字是以 r  为基的数，并且哈希表中可能出现的关键字都是事先知道的，则可取关键字的若干数位组成哈希地址。  
* 平方取中法：取关键字平方后的中间几位为哈希地址。通常在选定哈希函数时不一定能知道关键字的全部情况，取其中的哪几位也不一定合适，而一个数平方后的中间几位数和数的每一位都相关，由此使随机分布的关键字得到的哈希地址也是随机的。取的位数由表长决定。 
* 折叠法：将关键字分割成位数相同的几部分（最后一部分的位数可以不同），然后取这几部分的叠加和（舍去进位）作为哈希地址。 
* 随机数法 
* 除留余数法：取关键字被某个不大于散列表表长m的数p除后所得的余数为散列地址。即 

![][5]

。不仅可以对关键字直接取模，也可在折叠法、平方取中法等运算之后取模。对p的选择很重要，一般取素数或m，若p选择不好，容易产生冲突。         

### 处理冲突
 
为了知道冲突产生的相同散列函数地址所对应的关键字，必须选用另外的散列函数，或者对冲突结果进行处理。而不发生冲突的可能性是非常之小的，所以通常对冲突进行处理。常用方法有以下几种：

* 开放定址法（open addressing）： 

![][6]

 ，其中 

![][7]

 为散列函数， 为散列表长， 

![][8]

 为增量序列， 为已发生冲突的次数。增量序列可有下列取法：                          


![][9]

 称为  **`线性探测(Linear Probing)`**  ；即 

![][10]

，或者为其他线性函数。相当于逐个探测存放地址的表，直到查找到一个空单元，把散列地址存放在该空单元。



![][11]

 称为  **`平方探测(Quadratic Probing)`**  。相对线性探测，相当于发生冲突时探测间隔 

![][12]

个单元的位置是否为空，如果为空，将地址存放进去。



![][13]

 伪随机数序列，称为  **`伪随机探测`**  。

显示 **`线性探测`**  填装一个散列表的过程：
关键字为{89,18,49,58,69}插入到一个散列表中的情况。此时线性探测的方法是取 


![][10]

 
。并假定取关键字除以10的余数为散列函数法则。 

| 散列地址 | 空表 | 插入89 | 插入18 | 插入49 | 插入58 | 插入69 | 
|-|-|-|-|-|-|-|
| 0 |  |  |  | 49 | 49 | 49 | 
| 1 |  |  |  |  | 58 | 58 | 
| 2 |  |  |  |  |  | 69 | 
| 3 |  |  |  |  |  | | 
| 4 |  |  |  |  |  | | 
| 5 |  |  |  |  |  | | 
| 6 |  |  |  |  |  | | 
| 7 |  |  |  |  |  | | 
| 8 |  |  | 18 | 18 | 18 | 18 | 
| 9 |  | 89 | 89 | 89 | 89 | 89 | 

第一次冲突发生在填装49的时候。地址为9的单元已经填装了89这个关键字，所以取 


![][15]

 
 ，往下查找一个单位，发现为空，所以将49填装在地址为0的空单元。第二次冲突则发生在58上，取 

![][16]

，往下查找两个单位，将58填装在地址为1的空单元。69同理。


表的大小选取至关重要，此处选取10作为大小，发生冲突的几率就比选择质数11作为大小的可能性大。越是质数，mod取余就越可能均匀分布在表的各处。

聚集（Cluster，也翻译做“堆积”）的意思是，在函数地址的表中，散列函数的结果不均匀地占据表的单元，形成区块，造成线性探测产生一次聚集（primary clustering）和平方探测的二次聚集（secondary clustering），散列到区块中的任何关键字需要查找多次试选单元才能插入表中，解决冲突，造成时间浪费。对于开放定址法，聚集会造成性能的灾难性损失，是必须避免的。

* 单独链表法：将散列到同一个存储位置的所有元素保存在一个链表中。实现时，一种策略是散列表同一位置的所有冲突结果都是用栈存放的，新元素被插入到表的前端还是后端完全取决于怎样方便。 

* 双散列。 

* 再散列： 

![][17]

 。 

![][18]

是一些散列函数。即在上次散列计算发生冲突时，利用该次冲突的散列函数地址产生新的散列函数地址，直到冲突不再发生。这种方法不易产生“聚集”（Cluster），但增加了计算时间。             

* 建立一个公共溢出区 

更详细的内容可以参照大学数据结构课本或者维基百科关于散列表的讲解： [https://zh.wikipedia.org/wiki/%E5%93%88%E5%B8%8C%E8%A1%A8][19]

## 3.Hash函数            
 
在计算机理论中，没有Hash函数的说法，只有单向函数的说法。所谓的单向函数，是一个复杂的定义，大家可以去看计算理论或者密码学方面的数据。用“人 类”的语言描述单向函数就是：如果某个函数在给定输入的时候，很容易计算出其结果来；而当给定结果的时候，很难计算出输入来，这就是单项函数。各种加密函 数都可以被认为是单向函数的逼近。Hash函数（或者成为散列函数）也可以看成是单向函数的一个逼近。即它接近于满足单向函数的定义。 
 Hash函数还有另外的含义。实际中的Hash函数是指把一个大范围映射到一个小范围。把大范围映射到一个小范围的目的往往是为了节省空间，使得数据容易保存。除此以外，Hash函数往往应用于查找上。所以，在考虑使用Hash函数之前，需要明白它的几个限制： 
 1. Hash的主要原理就是把大范围映射到小范围；所以，你输入的实际值的个数必须和小范围相当或者比它更小。不然冲突就会很多。 
 2. 由于Hash逼近单向函数；所以，你可以用它来对数据进行加密。 
 3. 不同的应用对Hash函数有着不同的要求；比如，用于加密的Hash函数主要考虑它和单项函数的差距，而用于查找的Hash函数主要考虑它映射到小范围的冲突率。
 
Hash函数应用的主要对象是数组（比如，字符串），而其目标一般是一个int类型。
 
一般的说，Hash函数可以简单的划分为如下几类：

* **`加法hash            `**   
* **`位运算Hash            `**   
* **`乘法Hash            `**   
* **`除法Hash            `**   
* **`查表Hash            `**   
* **`混合Hash            `**   

下面将会详细的介绍以上各种方式在实际中的运用

### 一、加法Hash            
 
所谓的加法Hash就是把输入元素一个一个的加起来构成最后的结果。标准的加法Hash的构造如下：
 
```c


static int additiveHash(String key, int prime)
{
    int hash, i;
    for(hash = key.length(), i = 0; i < key.length(); i++){
        hash += key.charAt(i);
    }
    return (hash % prime);
}


```
 
这里的prime是任意的质数，看得出，结果的值域为[0,prime-1]。

### 二、位运算Hash
 
这类型Hash函数通过利用各种位运算（常见的是移位和异或）来充分的混合输入元素。比如，标准的旋转Hash的构造如下：
 
```c


static int rotatingHash(String key, int prime)
{
   int hash,i;
   for(hash=key.length(),i=0;i<key.length();++i){
       hash = (hash<<4)^(hash>>28)^key.charAt(i);
   }
   return (hash % prime);
}


```
 
先移位，然后再进行各种位运算是这种类型Hash函数的主要特点。比如，以上的那段计算hash的代码还可以有如下几种变形：

#### 变形1：
 
```c


hash = (hash<27)^key.charAt(i);


```

#### 变形2：
 
```c


hash += key.charAt(i);
hash += (hash << 10);
hash ^= (hash >> 6);


```

#### 变形3：
 
```c


if((i&1) == 0){
    hash ^= (hash<3);
}
else{
    hash ^= ~((hash<5));
}


```

#### 变形4：
 
```c


hash += (hash<<5) + key.charAt(i);


```

#### 变形5：
 
```c


hash = key.charAt(i) + (hash<16) – hash;


```

#### 变形6：
 
```c


hash ^= ((hash<2));


```

### 三、乘法Hash
 
这种类型的Hash函数利用了乘法的不相关性（乘法的这种性质，最有名的莫过于平方取头尾的随机数生成算法，虽然这种算法效果不好）。比如：
 
```c


static int bernstein(String key){
    int hash = 0;
    int i;
    for(i=0;i<key.length();++i){
        hash = 33*hash + key.charAt(i);
    }
    return hash;
}


```
 
使用这种方式的著名Hash函数还有：
 
```c


//32位FNV算法
int M_SHIFT = 0;
public int FNVHash(byte[] data){
    int hash = (int)2166136261L;
    for(byte b : data){
        hash = (hash * 16777619) ^ b;
    }
    if (M_SHIFT == 0){
        return hash;
    }
    return (hash ^ (hash >> M_SHIFT)) & M_MASK;
}


```
 
以及改进的FNV算法：
 
```c


class FNV32Hash {  
    private static final long OFFSET_BASIS = 2166136261L;// 32位offset basis  
    private static final long PRIME = 16777619; // 32位prime  

    public static long hash(byte[] src) {  
        long hash = OFFSET_BASIS;  
        for (byte b : src) {  
            hash ^= b;  
            hash *= PRIME;  
        }  
        return hash;  
    }  
}


```
 
代码中的OFFSET_BASIS，PRIME是32位的，不同的位数是用一个算法算出的常量，更多的可以参考文章： [FNV quick index][20]
 
除了乘以一个固定的数，常见的还有乘以一个不断改变的数，比如：
 
```c


static int RSHash(String str)
{
    int b = 378551;
    int a = 63689;
    int hash = 0;
    for(int i = 0; i < str.length(); i++){
        hash = hash * a + str.charAt(i);
        a = a * b;
    }
    return (hash & 0x7FFFFFFF);
}


```
 
虽然Adler32算法的应用没有CRC32广泛，不过，它可能是乘法Hash里面最有名的一个了。关于它的介绍，大家可以去看RFC1950规范。

### 四、除法Hash
 
除法和乘法一样，同样具有表面上看起来的不相关性。不过，因为除法太慢，这种方式几乎找不到真正的应用。需要注意的是，我们在前面看到的hash的 结果除以一个prime的目的只是为了保证结果的范围。如果你不需要它限制一个范围的话，可以使用如下的代码替代hash%prime： hash = hash ^ (hash>>10) ^ (hash>>20)。

### 五 查表Hash
 
查表Hash最有名的例子莫过于CRC系列算法。虽然CRC系列算法本身并不是查表，但是，查表是它的一种最快的实现方式。查表Hash中有名的例子有：Universal Hashing和Zobrist Hashing。他们的表格都是随机生成的。

### 六 混合Hash
 
混合Hash算法利用了以上各种方式。各种常见的Hash算法，比如MD5、Tiger都属于这个范围。它们一般很少在面向查找的Hash函数里面使用。
 
关于对Hash算法的评价：这个网站上 [http://www.burtleburtle.net/bob/hash/doobs.html][21] 提供了对几种流行Hash算法的评价。我们对Hash函数的建议如下：
 
1. 字符串的Hash。最简单可以使用基本的乘法Hash，当乘数为33时，对于英文单词有很好的散列效果（小于6个的小写形式可以保证没有冲突）。复杂一点可以使用FNV算法（及其改进形式），它对于比较长的字符串，在速度和效果上都不错。
 
2. 长数组的Hash。可以使用 [http://burtleburtle.net/bob/c/lookup3.c][22] 这种算法，它一次运算多个字节，速度还算不错。
 
Hash算法除了应用于这个方面以外，另外一个著名的应用是巨型字符串匹配（这时的 Hash算法叫做：rolling hash，因为它必须可以滚动的计算）。设计一个真正好的Hash算法并不是一件容易的事情。做为应用来说，选择一个适合的算法是最重要的。
 
在数组方面有以下用途：
 
```c


inline int hashcode(const int *v){
    int s = 0;
    for(int i=0;i<k;i++){
        s = ((s<<2)+(v[i]>>4))^(v[i]<<10);
    }
    s = s%M;
    s = s<0?s+M:s;
    return s;
}


```
 
虽说以上的hash能极大程度地避免冲突，但是冲突是在所难免的。所以无论用哪hash函数，都要加上处理冲突的方法。

## 4.典型例题讲解
 
说了那么多，怕是小伙伴们也看晕了，做几道题目看看就知道Hash到底是什么东西了

#### HDU 1280 
 
题意：给出n(3000)个数，两两求和，输出最大的m(5000)个和
 
分析：典型的hash: 用数组下标表示两两相加所得到的和，开辟一个满足题意的大小的数组 sum， 这样下标由大到小输出m个就可以了。
 
```c


#include <stdio.h>
#include <string.h>
int main ()
{
    int a[3001];
    int sum[10010];
    int n, m;
    int i,j;
    while ( scanf ("%d %d", &n, &m) != EOF )
    {
        memset ( a, 0, sizeof (a) );
        memset ( sum, 0, sizeof (sum) );
        for ( i = 0; i < n; i ++ )
        {
            scanf ("%d", &a[i]);
        }

        int temp;
        for ( i = 0; i < n; i ++ )
        {
            for ( j = i + 1; j < n; j++ )
            {
                temp = a[i] + a[j];
                sum[temp] ++;
            }
        }

        int count = 0;      //输出前 m  个数
        for ( i = 10001; i >= 0 ; i -- )
        {
            if ( sum[i] )
            {
                for (j = 0; j < sum[i]; j ++)
                {
                    count ++;
                    count == 1 ? printf ("%d", i) : printf (" %d", i);
                    if ( count == m )
                        break;
                }
            }
            if ( count == m )
                break;
        }

        printf ("\n");
    }
    return 0;
}


```

#### HDU 1425
 
题意：给你n个整数，请按从大到小的顺序输出其中前m大的数。
 
分析：每组测试数据有两行，第一行有两个数n,m(0< n,m<1000000)，第二行包含n个各不相同，且都处于区间[-500000,500000]的整数。用hash牺牲空间换取时间，达到常数级。
 
```c


#include<cstdio>
#include<iostream>
#include<cstring>
using namespace std;
int n,m;
int hash[1000010];
int main(){
    while(~scanf("%d%d",&n,&m)){
        memset(hash,0,sizeof(hash));
        for(int i=0;i<n;i++){
            int t;
            scanf("%d",&t);
            hash[t+500000]=1;
        }
        for(int i=1000000;i>=0;i--){
            if(hash[i]==0)continue;
            if(m==1){
                printf("%d\n",i-500000);
                break;
            }
            else {
                printf("%d ",i-500000);
                m--;
            }
        }
    }
    return 0;
}


```

#### HDU 3833
 
题意：给你一个1~n的排列...问是否存在a[i1]-a[i2]=a[i2]-a[i3] 其中(i1< i2< i3)
 
思路：1到n每个元素只会出现一次，引入hash[]来记录该数是否已经出现，出现为1，否则为0 ；读入一个数t ，从1到t-1依次判断是否有hash[t-i]+hash[t+i]==1 即以t为中项，对于t-i,t+i是否仅出现过一个，由于是按顺序读入的，即可保证t-i和t+i在原序列中一定是在t的两边。本题一看到最长要求时间是4s，按照正常思路写用了3个for循环会超时，因此其中隐藏着某些算法。就现在所知，一是利用二级排序，二是利用hash表。先说说hash表吧。既然要找到1到n序列中是否存在满足题意的三个元素，注意这三个元素有先后顺序之分，可以用一个数组来模拟。首先将数组全部清0，然后开始读入元素i，每读入一个元素就将以该元素为下标的hash表中的元素加1，即hash[i]++，然后在hash表中寻找，在hash[i]的对称的前面和后面查找，如果hash[i-j]+hash[i+j]==1,说明在i出现时，有两种可能，一是比i小的数已经出现但比i大的数还没出现，或者比i大的数已经出现，比i小的数还没出现，没出现的数在i的后面，已经出现的在i的前面，这就找到了满足题意的序列。
 
需要注意的是，题目说的是1到N的序列，不是说随便的N个数。
 
```c


#include<cstdio>
#include<cstring>
int main()
{
    int k,i,j,a,hash[10047],n,m,t;
    while(~scanf("%d",&t))
    {
        while(t--)
        {
            memset(hash,0,sizeof(hash));
            k = 0;
            scanf("%d",&n);
            for(int l =  0 ; l < n ; l++)
            {
                scanf("%d",&i);
                hash[i]++;       //以i为对称中心,请注意此处与代码二有所不同

                if( k == 1)
                    continue;
                for(j = 1 ; j < i && j+i <= n ; j++)
                {
                    ///对称是因为P[i1]- P[i2] = P[i2] - P[i3],它们的差（距离）要相等
                    if(hash[i-j]+hash[i+j] == 1)
                    {
                        k = 1 ;
                        break;
                    }
                }
            }

            if( k == 1)
                printf("Y\n");
            else
                printf("N\n");
        }
    }
    return 0;
}


```

## 5.推荐习题

* HDU 1496  给定a,b,c,d。a*x1^2+b*x2^2+c*x3^2+d*x4^2=0，其中x1~x4 在 [-100,100]区间内， a,b,c,d在[-50,50] 区间内，求满足上面那个式子的所有解的个数。 
* HDU 2648 有N个店，他们的商品价格每天都在上涨，问你 ith天有个叫memory的店，它的价格在所有商店中，有几个高过它，输出它的排名，有k个高过它，它就是第k+1名。 
* HDU 2027 统计每个元音字母在字符串中出现的次数。 
* POJ 1200 给出两个数n,nc，并给出一个由nc种字符组成的字符串。求这个字符串中长度为n的子串有多少种。 
* POJ 3320 一本书有P页，每页有个知识点，知识点可以重复。问至少连续读几页，使得覆盖全部知识点。 
* HDU 6161 给你一颗n个节点的完全二叉树，从根节点标号为1。标号为x的节点的左、右儿子标号分别为：2x、2x+1。这棵树的每个节点的权值为它本身的标号。现在告诉你有m次操作，每次操作要么就是把一个点变成给定值，要么就是让你输出经过给定某点的一条最长路径的长度。（一条路径的长度就是它经过的每个点的权值和，包括端点） 数据范围：$n<1e8，m<1e5$ 
* HDU 6046 给出一个1e3*1e3的矩阵以及 一个 生成1e6*1e6的矩阵的随机函数,在1e6*1e6的矩阵中找到1e3*1e3的矩阵的位置  
* HDU 4334 给五个数的集合，问能否从每个集合中取一个数，使五个数之和为0. 
* HDU 1880 给你一个10w的词典,让你输出对应的字段 
* HDU 5782  给出两个字符串，判断他们每一个前缀是否循环同构，循环同构的意思就是，字符串首位相接拼成一个环，两个环通过旋转可以相等。 

## 6.参考文献

* 维基百科： [https://zh.wikipedia.org/wiki/%E5%93%88%E5%B8%8C%E8%A1%A8][19]  
* Hash算法评价： [http://www.burtleburtle.net/bob/hash/doobs.html][21]  
* [http://burtleburtle.net/bob/c/lookup3.c][22]  
* Hash算法总结： [https://www.jianshu.com/p/bf1d7eee28d0][26]  

[19]: https://zh.wikipedia.org/wiki/%E5%93%88%E5%B8%8C%E8%A1%A8
[20]: http://www.isthe.com/chongo/tech/comp/fnv/
[21]: http://www.burtleburtle.net/bob/hash/doobs.html
[22]: http://burtleburtle.net/bob/c/lookup3.c
[23]: https://zh.wikipedia.org/wiki/%E5%93%88%E5%B8%8C%E8%A1%A8
[24]: http://www.burtleburtle.net/bob/hash/doobs.html
[25]: http://burtleburtle.net/bob/c/lookup3.c
[26]: https://www.jianshu.com/p/bf1d7eee28d0
[0]: ./img/EJnQvme.gif 
[1]: ./img/ABFbQf3.gif 
[2]: ./img/quamimf.gif 
[3]: https://latex.codecogs.com/gif.latex?%7B%5Cdisplaystyle%20hash%28k%29%3Da%5Ccdot%20k+b%7D
[4]: ./img/MBvAz2Q.gif 
[5]: ./img/byUbE3v.gif 
[6]: https://latex.codecogs.com/gif.latex?%7B%5Cdisplaystyle%20hash_%7Bi%7D%3D%28hash%28key%29+d_%7Bi%7D%29%5C%2C%7B%5Cbmod%20%7B%5C%2C%7D%7Dm%7D%2C%20%7B%5Cdisplaystyle%20i%3D1%2C2...k%5C%2C%28k%5Cleq%20m-1%29%7D
[7]: ./img/jYnAjaB.gif 
[8]: ./img/yu2mEnQ.gif 
[9]: ./img/naIj6rE.gif 
[10]: ./img/JB3U3iB.gif 
[11]: ./img/V3u22iJ.gif 
[12]: ./img/zm6NJ3r.gif 
[13]: ./img/Rj6NZzu.gif 
[14]: ./img/JB3U3iB.gif 
[15]: ./img/Y73amyB.gif 
[16]: ./img/aYB7Zvy.gif 
[17]: ./img/uE3UN3v.gif 
[18]: ./img/j2Yryy2.gif 