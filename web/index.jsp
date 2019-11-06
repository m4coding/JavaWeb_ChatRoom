<%--
  Created by IntelliJ IDEA.
  User: m4coding
  Date: 2019/10/13
  Time: 下午6:08
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<%--导入css样式表--%>
<link rel="stylesheet" href="css/style.css" type="text/css">
<head>
    <title>聊天室</title>
</head>
<style>
    /*表格居中样式*/
    .css_main_tb
    {
        height:360px;
        width:480px;
        position:absolute;
        top:50%;
        left:50%;
        margin-top:-180px;
        margin-left:-240px;
        margin-right:0px;
        margin-bottom:0px;
        background: #CCC49F;

        display: flex;
        align-items: center;
    }

    .flex{
        /*flex 布局*/
        display: flex;
        /*实现垂直居中*/
        align-items: center;
        /*实现水平居中*/
        justify-content: center;
        /*实现两端对齐文本效果*/
        text-align: justify;
        /*设置对象上下间距为0，左右自动 为了让内容水平居中所设置*/
        margin:0 auto;
        color:#212121;
        font-size: 20px;
    }
</style>
<script language="JavaScript">
    function check(input) {
        if (input.username.value === "") {
            input.username.focus();
            alert("请输入用户名！！！");
            return false;
        } else if (input.username.value === "\'") {
            alert("请不要输入非法字符！！！");
            input.username.focus();
            return false;
        }
    }
</script>
<body>
<div class="css_main_tb">
    <div style="display: flex; flex-direction: column; justify-content: center; align-items: center;margin:0 auto;">
        <div style="margin-bottom: 50px;"><span style="font-size: 30px;">聊天室</span></div>
        <form class="flex" name="input_form" method="post" action="LoginAction" onsubmit="return check(input_form)">
            用户名：<input type="text" name="username">
            <input style="margin-left: 10px; width: 34px; height: 34px;" type="image" name="imageGo" src="images/ic_go_login.png">
        </form>
    </div>
</div>
</body>
</html>
