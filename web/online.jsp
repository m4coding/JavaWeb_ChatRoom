<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.util.*" %>
<%@ page import="com.m4coding.chatroom.user.*" %>
<% request.setCharacterEncoding("UTF-8"); %>
<%
    Vector<UserInfoBean> vector = UserInfoManager.getInstance().getList();
    int amount = 0; //在线人数
%>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td height="32" align="center">欢迎来到&quot;闲聊&quot;聊天室！</td>
    </tr>
    <tr>
        <!-- href="#" 链接到当前页面 如果去掉的话，链接的onclick会失效的-->
        <td height="23" align="center"><a href="#" onClick="setChatObject('所有人');">所有人</a></td>
    </tr>
    <%
        if (vector != null && vector.size() > 0) {
            String username = "";
            amount = vector.size();
            for (int i = 0; i < amount; i++) {
                username = vector.elementAt(i).username;
    %>
    <tr>
        <td height="23" align="center"><a href="#" onclick="setChatObject('<%=username%>')"><%=username%>
        </a></td>
    </tr>
    <%
            }
        }
    %>
    <tr>
        <td height="30" align="center">当前在线[<font color="#FF5722"><%=amount%>
        </font>]人
        </td>
    </tr>
</table>