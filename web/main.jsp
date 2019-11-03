<%--
  Created by IntelliJ IDEA.
  User: mcsheng
  Date: 2019/10/20
  Time: 上午11:52
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>聊天室</title>
    <link rel="stylesheet" href="css/style.css" type="text/css">
    <style type="text/css">
        body {
            background: #42423c;
            margin: 0; /*消除body中的留白*/
            padding: 0;
            text-align: center;
        }

        .container {
            width: 778px;
            background: #FFF;
            margin: 0 auto; /*侧边的自动值与宽度结合使用，可以将布局居中对齐*/
            text-align: left;
        }

        .header {
            padding: 10px 0;
            background: #ADB96E;
        }

        .sidebar {
            float: left; /*侧边栏局左，改为right可令侧边栏居右*/
            width: 200px;
            height: 300px;
            background: #a4f;
        }

        .mainContent {
            width: 570px;
            height: 300px;
            background: #eee;
        }

        .footer {
            clear: both; /*清除前后的浮动元素，使页脚显示在最下方*/
            position: relative; /*修正IE浏览器中clear无效的bug*/
            padding: 10px 10px 10px 10px;
            background: #CCC49F;
        }
    </style>

    <script language="JavaScript">
        function checkIsPrivate() {
            if (form1.isPrivate.checked) {
                if (form1.to.value == "所有人") {
                    alert("请选择私聊对象");
                    form1.to.value = "";
                }
            }
        }

        //滚屏检查
        function checkScrollScreen() {
            if (form1.scrollScreen.checked) {
                document.getElementById("content").style.overflow = "scroll";
            } else {
                document.getElementById("content").style.overflow = "hidden";
                //当聊天信息超过一屏时，设置最先发送的聊天信息不显示
                document.getElementById('content').scrollTop = document.getElementById('content').scrollHeight * 2;
            }
        }

        function showContent() {
            var loader1 = new net.AjaxRequest("MessagesAction?action=getMessages&nocache="
                + new Date().getTime(), deal_content, onerror, "GET");
        }

        function showOnline() {

        }

        window.onload = function () {
            checkScrollScreen();				//当页面载入后控制是否滚屏
            showContent();						//当页面载入后显示聊天内容
            showOnline();						//当页面载入后显示在线人员列表
        }
    </script>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>网页头部</h1>
        </div>

        <div>
            <div class="sidebar" id="chat_room_online_people">
                在线人员列表
            </div>

            <div class="mainContent" id="char_room_content">
                聊天内容
            </div>
        </div>

        <div class="footer">
            <form action="" name="form1" method="post">
                [<%=session.getAttribute("username")%>]对
                <input name="to" type="text" value="" size="35" readonly="readonly">
                &nbsp;&nbsp;表情
                <select name="faceSelector" class="selector">
                    <option value="无表情的">无表情的</option>
                    <option value="微笑着" selected>微笑着</option>
                    <option value="笑呵呵地">笑呵呵地</option>
                    <option value="热情的">热情的</option>
                    <option value="温柔的">温柔的</option>
                    <option value="红着脸">红着脸</option>
                    <option value="幸福的">幸福的</option>
                    <option value="嘟着嘴">嘟着嘴</option>
                    <option value="热泪盈眶的">热泪盈眶的</option>
                    <option value="依依不舍的">依依不舍的</option>
                    <option value="得意的">得意的</option>
                    <option value="神秘兮兮的">神秘兮兮的</option>
                    <option value="恶狠狠的">恶狠狠的</option>
                    <option value="大声的">大声的</option>
                    <option value="生气的">生气的</option>
                    <option value="幸灾乐祸的">幸灾乐祸的</option>
                    <option value="同情的">同情的</option>
                    <option value="遗憾的">遗憾的</option>
                    <option value="正义凛然的">正义凛然的</option>
                    <option value="严肃的">严肃的</option>
                    <option value="慢条斯理的">慢条斯理的</option>
                    <option value="无精打采的">无精打采的</option>
                </select>
                说： 悄悄话
                <input name="isPrivate" type="checkbox" class="noBorder" id="isPrivate" value="true"
                       onClick="checkIsPrivate()">

                滚屏
                <input name="scrollScreen" type="checkbox" class="noBorder" id="scrollScreen"
                       onClick="checkScrollScreen()" value="1" checked>

                字体颜色：
                <select name="colorSelector" size="1" class="selector">
                    <option selected>默认颜色</option>
                    <option style="color:#FF0000" value="FF0000">红色热情</option>
                    <option style="color:#0000FF" value="0000ff">蓝色开朗</option>
                    <option style="color:#ff00ff" value="ff00ff">桃色浪漫</option>
                    <option style="color:#009900" value="009900">绿色青春</option>
                    <option style="color:#009999" value="009999">青色清爽</option>
                    <option style="color:#990099" value="990099">紫色拘谨</option>
                    <option style="color:#990000" value="990000">暗夜兴奋</option>
                    <option style="color:#000099" value="000099">深蓝忧郁</option>
                    <option style="color:#999900" value="999900">卡其制服</option>
                    <option style="color:#ff9900" value="ff9900">镏金岁月</option>
                    <option style="color:#0099ff" value="0099ff">湖波荡漾</option>
                    <option style="color:#9900ff" value="9900ff">发亮蓝紫</option>
                    <option style="color:#ff0099" value="ff0099">爱的暗示</option>
                    <option style="color:#006600" value="006600">墨绿深沉</option>
                    <option style="color:#999999" value="999999">烟雨蒙蒙</option>
                </select>
                <br>
                <div style="margin-top: 10px;">
                    <input name="sendContent" type="text" size="70" onKeyDown="if(event.keyCode==13 && event.ctrlKey){send();}">
                    <input name="sendSubmit" type="button" class="btnBlank" value="发送" onClick="send()">
                    <input name="button_exit"  type="button" style="float: right;" class="btnTheme" value="退出聊天室" onClick="Exit()">
                </div>
            </form>
            <div style="text-align: center">modify by m4coding</div>
    </div>
    </div>
</body>
</html>
