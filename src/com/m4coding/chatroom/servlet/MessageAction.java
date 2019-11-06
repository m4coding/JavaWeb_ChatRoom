package com.m4coding.chatroom.servlet;

import com.m4coding.chatroom.utils.BusinessUtils;
import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.SAXReader;
import org.dom4j.io.XMLWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.Random;

@WebServlet("/MessageAction")
public class MessageAction extends HttpServlet {

    private static final String TAG = "MessageAction";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        handle(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        handle(req, resp);
    }

    private void handle(HttpServletRequest req, HttpServletResponse resp) {
        String action = req.getParameter("action");
        if ("getMessages".equals(action)) { // 从XML文件中读取聊天信息
            getMessages(req, resp);
        } else if ("exitRoom".equals(action)) {
            exitRoom(req, resp);
        } else if ("sendMessage".equals(action)) {
            sendMessages(req, resp);
        }
    }

    // 读取保存聊天信息的XML文件
    private void getMessages(HttpServletRequest request,
                            HttpServletResponse response) {

        System.out.println("getMessages");

        response.setContentType("text/html;charset=UTF-8");
        String newTime = new SimpleDateFormat("yyyyMMdd").format(new Date());
        String fileURL = request.getSession().getServletContext()
                .getRealPath("xml/" + newTime + ".xml");
        BusinessUtils.createFile(fileURL); // 当文件不存在时创建该文件
        /******************* 开始解析保存聊天内容的XML文件 **********************/
        try {
            SAXReader reader = new SAXReader(); // 实例化SAXReader对象
            Document feedDoc = reader.read(new File(fileURL));// 获取XML文件对应的XML文档对象
            Element root = feedDoc.getRootElement(); // 获取根节点
            Element channel = root.element("messages"); // 获取messages节点
            Iterator items = channel.elementIterator("message"); // 获取message节点
            String messages = "";
            // 获取当前用户
            HttpSession session = request.getSession();
            String userName = "";
            if (null == session.getAttribute("username")) {
                System.out.println("getMessages, username is null");
                request.setAttribute("messages", "error"); // 保存标记信息，表示用户账户已经过期
            } else {
                userName = session.getAttribute("username").toString();
                DateFormat df = DateFormat.getDateTimeInstance();
                while (items.hasNext()) {
                    Element item = (Element) items.next();
                    String sendTime = item.elementText("sendTime"); // 获取发言时间
                    try {
                        if (df.parse(sendTime).after(
                                df.parse(session.getAttribute("loginTime")
                                        .toString()))
                                || sendTime.equals(session.getAttribute(
                                "loginTime").toString())) {
                            String from = item.elementText("from"); // 获取发言人
                            String face = item.elementText("face"); // 获取表情
                            String to = item.elementText("to"); // 获取接收者
                            String content = item.elementText("content"); // 获取发言内容
                            boolean isPrivate = Boolean.valueOf(item
                                    .elementText("isPrivate"));
                            if (isPrivate) { // 获取私聊内容
                                if (userName.equals(to)
                                        || userName.equals(from)) {
                                    messages += "<font color='red'>[私人对话]</font><font color='blue'><b>"
                                            + from
                                            + "</b></font><font color='#CC0000'>"
                                            + face
                                            + "</font>对<font color='green'>["
                                            + to
                                            + "]</font>说："
                                            + content
                                            + "&nbsp;<font color='gray'>["
                                            + sendTime + "]</font><br>";
                                }
                            } else if ("[系统公告]".equals(from)) { // 获取系统公告信息
                                messages += "[系统公告]：" + content
                                        + "&nbsp;<font color='gray'>["
                                        + sendTime + "]</font><br>";
                            } else { // 获取普通发言信息
                                messages += "<font color='blue'><b>" + from
                                        + "</b></font><font color='#CC0000'>"
                                        + face
                                        + "</font>对<font color='green'>[" + to
                                        + "]</font>说：" + content
                                        + "&nbsp;<font color='gray'>["
                                        + sendTime + "]</font><br>";
                            }
                        }
                    } catch (Exception e) {
                        System.out.println("" + e.getMessage());
                    }
                }

                //利用setAttribute来进行不同页面的之间的传递数据
                request.setAttribute("messages", messages); // 保存获取的聊天信息
            }
            request.getRequestDispatcher("content.jsp").forward(request,
                    response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //退出时，写入系统公告
    private void exitRoom(HttpServletRequest request,
                         HttpServletResponse response) {
        System.out.println("exitRoom");

        HttpSession session = request.getSession();// 获取HttpSession
        session.invalidate(); // 销毁session
        try {
            request.getRequestDispatcher("index.jsp")
                    .forward(request, response);// 重定向页面到登录页面
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 发送聊天信息
    private void sendMessages(HttpServletRequest request,
                             HttpServletResponse response) {
        response.setContentType("text/html;charset=UTF-8");
        Random random = new Random();
        String from = request.getParameter("from"); // 发言人
        String face = request.getParameter("face"); // 表情
        String to = request.getParameter("to"); // 接收者
        String color = request.getParameter("color"); // 字体颜色
        String content = request.getParameter("content"); // 发言内容
        String isPrivate = request.getParameter("isPrivate"); // 是否为悄悄话
        String sendTime = new Date().toLocaleString(); // 发言时间

        System.out.println("sendMessages from=" + from + "; face="
                + face + "; to=" + to + "; color=" + color + "; content=" + content + "; isPrivate=" + isPrivate + "; sendTime=" + sendTime);

        /** *******************开始添加聊天信息********************************** */
        String newTime = new SimpleDateFormat("yyyyMMdd").format(new Date());
        String fileURL = request.getSession().getServletContext()
                .getRealPath("xml/" + newTime + ".xml");
        BusinessUtils.createFile(fileURL); // 判断文件是否存在，当文件不存在时创建该文件
        try {
            SAXReader reader = new SAXReader(); // 实例化SAXReader对象
            Document feedDoc = reader.read(new File(fileURL));// 获取XML文件对应的XML文档对象
            Element root = feedDoc.getRootElement(); // 获取根节点
            Element messages = root.element("messages"); // 获取messages节点
            Element message = messages.addElement("message"); // 创建子节点message
            message.addElement("from").setText(from); // 创建子节点from
            message.addElement("face").setText(face); // 创建子节点face
            message.addElement("to").setText(to); // 创建子节点to
            message.addElement("content").addCDATA(
                    "<font color='" + color + "'>" + content + "</font>"); // 创建子节点content
            message.addElement("sendTime").setText(sendTime); // 创建子节点sendTime
            message.addElement("isPrivate").setText(isPrivate); // 创建子节点

            OutputFormat format = OutputFormat.createPrettyPrint(); // 创建OutputFormat对象
            format.setEncoding("gb2312"); //设置编码格式，避免中文乱码。todo linux平台待测？
            XMLWriter writer = new XMLWriter(new FileWriter(fileURL), format);
            writer.write(feedDoc); // 向流写入数据
            writer.close(); // 关闭XMLWriter

            request.getRequestDispatcher(
                    "MessageAction?action=getMessages&nocache="
                            + random.nextInt(10000)).forward(request, response);
            /** *****************添加结束******************************* */
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
