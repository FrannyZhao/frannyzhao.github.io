
目录
--
[为什么用git gerrit jenkins三剑客做代码版本控制](https://github.com/FrannyZhao/FrannyZhao.github.io/blob/master/CodeManagement/git.useful.skills.md#为什么用git_gerrit_jenkins三剑客做代码版本控制) <br/>
[更新代码](https://github.com/FrannyZhao/FrannyZhao.github.io/blob/master/CodeManagement/git.useful.skills.md#更新代码)<br/>
[提交](https://github.com/FrannyZhao/FrannyZhao.github.io/blob/master/CodeManagement/git.useful.skills.md#提交)<br/>
[还原文件](https://github.com/FrannyZhao/FrannyZhao.github.io/blob/master/CodeManagement/git.useful.skills.md#还原文件)<br/>
[合并多个提交](https://github.com/FrannyZhao/FrannyZhao.github.io/blob/master/CodeManagement/git.useful.skills.md#合并多个提交)<br/>
[找不同版本的区别](https://github.com/FrannyZhao/FrannyZhao.github.io/blob/master/CodeManagement/git.useful.skills.md#找不同版本的区别)<br/>
[这锅该谁背](https://github.com/FrannyZhao/FrannyZhao.github.io/blob/master/CodeManagement/git.useful.skills.md#这锅该谁背)<br/>
[方便的配置](https://github.com/FrannyZhao/FrannyZhao.github.io/blob/master/CodeManagement/git.useful.skills.md#方便的配置)<br/>
[其他](https://github.com/FrannyZhao/FrannyZhao.github.io/blob/master/CodeManagement/git.useful.skills.md#其他)<br/>

----------

为什么用git gerrit jenkins三剑客做代码版本控制
--

**烦恼：**

 - 经常没有一个好的基础版本来发布和开发，一更新代码发现又跑不起来；
 - 辛苦改好的代码进不去版本库；
 - 不是我的bug却要我来花时间;
 - 开发团队人越多，集成越困难……

**好处：**

 - 版本历史有迹可查（git）；
 - 提交前代码检查，坏代码不会污染代码库（gerrit&jenkins）；
 - 快速定位问题；
 - 方便管理多项目；
 - 方便团队合作……

> git gerrit jenkins三剑客： 灵活，快速，强大，好用。

git各种命令与状态：

![image](https://raw.githubusercontent.com/FrannyZhao/FrannyZhao.github.io/master/CodeManagement/pic/git_commands_and_status.png)

想详细了解更多git技能推荐阅读：[Git Community Book 中文版](http://gitbook.liuhui998.com/)
本文挑了最最实用、最最常用的技能，方便大家快速掌握，提高工作效率。

在理解下面的技能前，希望大家先在脑海中形象滴理解下git branch和git commit:

> 把branch理解成一条流水线，把commit理解成乐高积木。
branch这条流水线是由一个一个commit积木组成的。

----------

更新代码
--
> 不要用git pull, 改用git fetch + git rebase

因为`git pull`会做`git merge`产生讨厌的merge commit。

**merge commit是什么？**
git中两个branch合并的时候，需要做个标记，这是我们合并的点，就像两根绳子打个结：

   ![image](https://raw.githubusercontent.com/FrannyZhao/FrannyZhao.github.io/master/CodeManagement/pic/git_pull_biyu.jpg)
   
这个结就是`git merge`时生成的merge commit。

**merge commit为啥就讨厌了？**
如果是重要的branch合并，我们会需要个merge commit作为见证。就像结婚说誓词时需要个证婚人一样。
但是你平时说话就不需要见证了，不然太累了。
因为你的本地branch根本不重要，跟主线master合并的时候不需要留下见证。
主线只要你的commit并不想要整个branch。

**解决办法**：
```
    git fetch origin
    git rebase origin/master
```
`git rebase`做的动作就是把你的commit挪到主线的最顶端。

**rebase过程中出现冲突怎么办？**

 1. `git status` 看下哪个文件冲突了？（假设是src/java/a.java有冲突）
 2. 打开这个文件，解决冲突
 3. `git add src/java/a.java` 
 4. `git rebase --continue`
 
----------

提交
--

 - **提交前自检**： 过一遍自己刚才改了什么
 
```
    git status
    git diff
```
git命令都可以加路径来指定文件或者目录，这几个命令也不例外。
比如：
`git status .` 查看当前目录下修改的文件。
`git diff src/java/franny.java` 查看franny.java文件的具体修改。

 - **提交**

```
	git commit
	git push origin HEAD:refs/for/master
```
`git commit .` 提交当前目录下修改的文件；
`git commit src/java/a.java src/java/b.java` 只提交a.java, b.java这两个文件。
`refs/for` 表示提交到gerrit上，走代码review流程，由有权限的人review过才给你合进代码库。
与其对应的是`refs/heads`和`refs/tags`直接提交进代码库，普通群众是没有这个权限的就不说了。

----------

还原文件
--

**常用场景**：
哎呀，我修改了几十个文件还分散个各种不同目录下，其中有一个文件（假设叫a.java）不需要提交咋办，用`git commit file1 file2 file3 ...` 太麻烦。

**解决办法**：
那么就先把a.java还原成未修改的状态： `git checkout src/java/a.java`
然后`git commit -a` 一次性提交全部文件。

----------

合并多个提交
--

**常用场景**：
哎呀，我的修改提交了3个commit，我想把它们合并成一个commit然后push。

**解决办法**：
有3种：

----------

找不同版本的区别
--

**常用场景**：
这个bug上个版本还没有，这个版本怎么就出现了呢？我得看看上个版本和这个版本之间都改了什么。

**解决办法**：


----------

这锅该谁背
--

**常用场景**：
找到了，就是这行代码改出来的问题，看看谁改的。

**解决办法**：
`git blame`

**高级一点的需求**：
`git blame` 只能看到谁加了这行，如果知道有些代码被删了，想看看谁删了怎么办呢？

**解决办法**：

----------

方便的配置
--
git 这么多命令，敲起来又长又麻烦，一不小心敲错了就更烦了。

**解决办法**：
缩写alias

----------

其他
--

----------

暂时就写这么多啦，以后有需要再补充~
欢迎指导和提意见 :blush:

> Written with [StackEdit](https://stackedit.io/).