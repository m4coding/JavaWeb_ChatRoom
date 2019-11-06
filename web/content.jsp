<%--
  Created by IntelliJ IDEA.
  User: m4coding
  Date: 2019/11/4
  Time: 15:35
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.util.*" %>
<% request.setCharacterEncoding("UTF-8"); %>

<%-- 向客户端浏览器输出messages内容--%>
<% out.println(request.getAttribute("messages").toString()); %>
