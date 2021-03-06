## MySQL 笔记 - 事务&amp;锁

来源：[https://juejin.im/post/5b76938de51d45664715fba8](https://juejin.im/post/5b76938de51d45664715fba8)

时间 2018-08-17 17:22:40
 
这是一篇读（重）书（点）笔（摘）记（要）~内容为《高性能 MySQL》第一章~
 
and 七夕快乐，所以今天的配图是粉红色的(๑•̀ㅂ•́)و✧
 
## 事务
 
简单的说，事务就是一组原子性的 SQL 查询，这一组 SQL 要么全部执行成功，要么全部执行失败。这里简单介绍一下事务的 ACID，ACID 表示原子性、一致性、隔离性和持久性。
 
 
* 原子性：一个事务是不可分割的最小工作单元，整个事务要么全部成功，要么全部失败，不可能只执行中间的一部分操作。 
* 一致性：执行事务是使得数据库从一个一致性状态到另一个一致性状态，如果事务最终没有被提交，那么事务所做的修改也不会保存到数据库中。 
* 隔离性：通常来说，一个事务提交之前对其他事务是不可见的，但是这里所说的不可见需要考虑隔离级别，比如未提交读在提交前对于其他事务来说也是可见的，隔离级别，在下面会详细讲。 
* 持久性：事务一旦被提交，那么对数据库的修改会被永久的保存，即使数据库崩溃修改后的数据也不会丢失。 
 
 
## 隔离级别
 
SQL 标准中定义了四种隔离级别，这里简单介绍一下这四种隔离级别。
 
 
* 未提交读：未提交读的意思是，事务中的修改，即使没有提交，对其他事务也都是可见的，但是这样会出现脏读，一般情况下，通常都不会使用未提交读。 
* 提交读：提交读的意思是，一个事务所做的修改在提交之前对其他事务都是不可见的，这个级别也叫做“不可重复读”，因为执行两次相同的操作，可能会得到不同的结果。 
* 可重复读：可重复读解决了脏读的问题，这个级别保证了同一个事务多次读取同样记录的结果是一致的，但是这个隔离级别无法解决幻读的问题，所谓幻读就是说，当某个事务读取范围数据时，另一个事务又在该范围内插入了新的记录，当之前的事务再次读取该范围数据时，会产生幻行。InnoDB 存储引擎通过 MVCC 解决了幻读的问题，可重复读是 MySQL 默认的事务隔离级别。 
* 可串行化：是最高的隔离级别，避免了前面说到的幻读问题。可串行化会给读取的每一行都加锁，所以可能导致大量超时和锁争用的问题，实际中很少使用这个隔离级别。 
 
 
## 死锁
 
死锁是指两个或者多个事务在同一资源上相互占用，并请求锁定对方占用的资源。解决死锁的方法就是回滚一个或者多个事务。
 
## MVCC
 
MVCC 可以看做是行锁的一个变种，在很多情况下 MVCC 可以避免加锁，因此开销更小，不同事务型存储引擎对于 MVCC 的实现各有不同。 MVCC 的实现是通过保存数据在某个时间点的快照来实现的。也就是说，不管执行多长时间，每个事务看到的数据都是一致的。根据事务的开始时间不同，每个事务对同一张表，同一时刻看到的数据可能是不一样的。这里简单介绍一下 InnoDB 的 MVCC。 InnoDB 的 MVCC 通过在每行记录后面保存两个隐藏的列来实现。这两个列，一个保存了行的创建时间，一个保存了行的过期时间，存储的不是实际的时间，而是版本号。每开始一个新的事务，系统版本号都会自动递增。事务开始时刻的系统版本号会作为事务的版本号，用来和查询到的每行记录的版本号作对比。下面详细介绍一下在可重复读隔离级别下，MVCC 的具体操作。
 
 
* SELECT 
    * InnoDB 会根据以下两个条件检查每条记录： 
        * 只查找版本小于等于事务版本号的行 
        * 只查找未定义删除时间或者删除时间大于事务版本号的行 
       
  
* INSERT 
    * InnoDB 为新插入的每一行保存当前的系统版本号作为行版本号 
  
* DELETE 
    * InnoDB 为删除的每一行保存当前的系统版本号作为行的删除版本号 
  
* UPDATE 
    * InnoDB 新增一条记录，保存当前系统版本号作为新增行的版本号 
    * 在被删除记录的原始行，保存当前系统版本号作为被删除记录行的删除版本号 
 
优点：
 
* 因为有了两个隐藏列来记录数据的状态，所以大多数读操作都可以不加锁 
* 性能好，同时可以保证读取的数据是正确的 
 
缺点：
 
* 需要额外的空间记录每行的状态 
* 需要行状态的维护和检查 
 
## 如何解决幻读
 
MVCC 解决幻读的时候使用了间隙锁，也就是 next-key lock，这部分就要先从 InnoDB 的三种行锁说起：
 
 
* Record Lock：单个行记录上的锁，锁住的是索引 
* Gap Lock：区间锁，锁定一个区间范围，但不包括记录本身，开区间 
* Next-Key Lock：间隙锁，Record Lock + Gap Lock 
 
 
举个简单的例子，
 
```
select id from user where id > 15 and id < 30
```
 
 ![][0]
 
图示清楚的表示了间隙锁~
 
[0]: ./img/FRbQbeN.jpg