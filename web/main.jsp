<%--
  Created by IntelliJ IDEA.
  User: m4coding
  Date: 2019/10/20
  Time: 上午11:52
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% request.setCharacterEncoding("UTF-8");
    int maxTime = 50 * 60 * 1000;        //设置5分钟不说话，将其踢出聊天室
%>

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
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .container {
            width: 830px;
            background: #FFF;
            text-align: left;
            /*margin: 0 auto; !*侧边的自动值与宽度结合使用，可以将布局居中对齐*!*/
        }

        .header {
            display: flex;
            flex-direction: row;
            justify-content: center;
            padding: 5px 0;
            background: #CCC49F;
        }

        .sidebar {
            float: left; /*侧边栏局左，改为right可令侧边栏居右*/
            height: 100%;
            background: #CCC49F;
            width: 200px;
            padding-top: 10px;
            padding-bottom: 10px;
        }

        .mainContent {
            height: 100%;
            background: #f0f0f0;
            flex-grow: 1; /*沾满剩余的空间*/
            padding: 10px;
            font-size: 18px;
        }

        .footer {
            clear: both; /*清除前后的浮动元素，使页脚显示在最下方*/
            position: relative; /*修正IE浏览器中clear无效的bug*/
            padding: 10px 10px 10px 10px;
            background: #CCC49F;
        }
    </style>

    <script src="js/AjaxRequest.js"></script>
    <script>

        var sysBBS = "<span style='font-size:15px; line-height:30px;'>欢迎光临&quot;闲聊&quot;聊天室，请遵守聊天室规则，不要使用不文明用语。</span>" +
            "<br>" +
            "<span style='line-height:22px;'>";

        //添加聊天对象 用于在线人数区域链接点击
        function setChatObject(selectPerson) {
            if (selectPerson !== "<%=session.getAttribute("username")%>") {
                if (chatForm.isPrivate.checked && selectPerson === "所有人") {
                    alert("悄悄话已被勾选，请选择私聊对象！");
                } else {
                    chatForm.toWhoText.value = selectPerson; //赋值给chatForm.toWhoText.value
                }
            } else {
                alert("不能对自己发言，请重新选择聊天对象！");
            }
        }

        //发送内容
        function send() {
            //验证聊天信息并发送
            if (chatForm.toWhoText.value == "") {
                alert("请选择聊天对象！");
                return false;
            }

            if (chatForm.sendContentText.value === "") {
                alert("发送信息不可以为空！");
                chatForm.sendContentText.focus();
                return false;
            }

            //悄悄话是否勾选
            if (chatForm.isPrivate.checked) {
                isPrivate = "true";
            } else {
                isPrivate = "false";
            }

            /**
             * from       发言人
             * face       表情
             * to         接受者
             * color      字体颜色
             * content    发言内容
             * isPrivate  是否为悄悄话
             */
            var param = "from=" + encodeURI(encodeURI(chatForm.fromWhoText.value)) //进行两次uri编码处理，避免多端中文乱码
                + "&face=" + encodeURI(encodeURI(chatForm.faceSelector.value))
                + "&color=" + encodeURI(encodeURI(chatForm.colorSelector.value))
                + "&to=" + encodeURI(encodeURI(chatForm.toWhoText.value))
                + "&content=" + encodeURI(encodeURI(chatForm.sendContentText.value))
                + "&isPrivate=" + isPrivate;

            var loader = new net.AjaxRequest("MessageAction?action=sendMessage", dealSend, onError, "POST", param);
        }

        function dealSend() {
            chatRoomContent.innerHTML = sysBBS + this.req.responseText + "</span>";
            if (chatForm.scrollScreen.checked) {
                document.getElementById('chatRoomContent').scrollTop = document.getElementById('chatRoomContent').scrollHeight * 2;	//当聊天信息超过一屏时，设置最先发送的聊天信息不显示
            }
            //重新计时
            clearTimeout(timer);
            //超时执行
            timer = window.setTimeout("exit()", <%=maxTime%>);
            chatForm.sendContentText.value = "";
        }

        //退出聊天室
        function exit() {
            window.location.href = "MessageAction?action=exitRoom";
            alert("欢迎您下次光临！");
        }

        //长时间不发言，退出聊天室
        function exitForLongTimeNoSay() {
            window.location.href = "MessageAction?action=exitRoom";
            alert("由于你长时间不发言，已被踢出聊天室，欢迎您下次光临！");
        }

        function checkIsPrivate() {
            if (chatForm.isPrivate.checked) {
                if (chatForm.toWhoText.value == "所有人") {
                    alert("请选择私聊对象");
                    chatForm.toWhoText.value = "";
                }
            }
        }

        function onError() {
            alert("很抱歉，服务器出现错误，当前窗口将关闭！");
            /**
             * 解决问题：
             * 在页面中触发window.close()，页面没有按照预期那样关闭，控制台提示警告：Scripts may close only the windows that were opened by it
             * 意思是脚本只能关闭通过脚本打开的页面，当我们在浏览器地址栏输入URL打开页面，是不会通过window.close()关闭的
             */
            if(navigator.userAgent.indexOf("Firefox") !== -1 || navigator.userAgent.indexOf("Chrome") !== -1){
                window.location.href = "about:blank";
                window.close();
            }else{
                window.opener = null;
                window.open("", "_self");
                window.close();
            }
        }

        function dealContent() {
            var returnValue = this.req.responseText;		//获取Ajax处理页的返回值
            var h = returnValue.replace(/\s/g, "");	//去除字符串中的Unicode空白符
            if (h == "error") {
                //alert("您的账户已经过期，请重新登录！");
                exit();
            } else {
                chatRoomContent.innerHTML = sysBBS + returnValue + "</span>";
            }
        }

        function dealOnline() {
            chatRoomOnlinePeople.innerHTML = this.req.responseText;
        }

        //滚屏检查
        function checkScrollScreen() {
            if (chatForm.scrollScreen.checked) {
                document.getElementById("chatRoomContent").style.overflow = "scroll";
            } else {
                document.getElementById("chatRoomContent").style.overflow = "hidden";
                //当聊天信息超过一屏时，设置最先发送的聊天信息不显示
                document.getElementById('chatRoomContent').scrollTop = document.getElementById('chatRoomContent').scrollHeight * 2;
            }
        }

        //显示聊天内容
        function showContent() {
            var loader = new net.AjaxRequest("MessageAction?action=getMessages&nocache="
                + new Date().getTime(), dealContent, onError, "GET");
        }

        //获取在线人数显示
        function showOnline() {
            var loader = new net.AjaxRequest("online.jsp?nocache=" + new Date().getTime(), dealOnline, onError, "GET");
        }

        window.onload = function () {
            checkScrollScreen();				//当页面载入后控制是否滚屏
            showContent();						//当页面载入后显示聊天内容
            showOnline();						//当页面载入后显示在线人员列表
        }

        window.setInterval("showContent();", 1000); //每1秒调用一次showContent()
        window.setInterval("showOnline();", 10000); //每10秒调用一次showOnline()

        timer = window.setTimeout("exitForLongTimeNoSay()", <%=maxTime%>); 		//用于当用户长时间不说话时，将其踢出聊天室
        window.onbeforeunload = function () {   //当用户单击浏览器中的“关闭”按钮时，执行退出操作
            ver = navigator.appVersion; //浏览器的版本
            bType = navigator.appName;//浏览器的类型
            vNumber = parseFloat(ver.substring(ver.indexOf("MSIE") + 5, ver.lastIndexOf("Windows")));
            if (bType == "Microsoft Internet Explorer") {
                if (vNumber > 6) {//IE6以上浏览器
                    vOffset = document.body.offsetWidth - document.body.scrollWidth;
                    if (event.clientY < 0 && event.clientX > document.body.scrollWidth - vOffset - 20) {
                        exit();		//执行退出操作
                    } else {//IE6及以下浏览器
                        if (event.clientY < 0 && event.clientX > document.body.scrollWidth) {
                            exit();		//执行退出操作
                        }
                    }
                }
            }
        }
    </script>
</head>
<body>
<div class="container">
<%--    <div class="header">--%>
<%--        <span style="font-size: 30px;margin-top: 10px; margin-bottom: 10px;"></span>--%>
<%--    </div>--%>
    <div style="display: flex; height: 500px">
        <div class="sidebar" id="chatRoomOnlinePeople">
            在线人员列表
        </div>

        <div class="mainContent" id="chatRoomContent">
            聊天内容
        </div>
    </div>

    <div class="footer">
        <form action="" name="chatForm" method="post">
            <input name="fromWhoText" type="hidden" value="<%=session.getAttribute("username")%>">
            [<%=session.getAttribute("username")%>]对
            <input name="toWhoText" type="text" value="" size="35" readonly="readonly">
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
                <input name="sendContentText" type="text" size="70"
                       onKeyDown="if(event.keyCode==13 && event.ctrlKey){send();}">
                <input name="submitBtn" type="button" class="btnBlank" value="发送" onClick="send()">
                <input name="exitBtn" type="button" style="float: right;" class="btnBlank" value="退出聊天室"
                       onClick="exit()">
            </div>
        </form>
        <div style="text-align: center">modify by m4coding</div>
    </div>
</div>
</body>
</html>
