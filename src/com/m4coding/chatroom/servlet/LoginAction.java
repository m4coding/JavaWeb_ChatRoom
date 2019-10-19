package com.m4coding.chatroom.servlet;

import com.m4coding.chatroom.user.UserInfoBean;
import com.m4coding.chatroom.user.UserInfoManager;
import com.m4coding.chatroom.user.UserSessionHandler;

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
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Vector;

@WebServlet("/LoginAction")
public class LoginAction extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");

        HttpSession session = req.getSession();
        session.setMaxInactiveInterval(600); //设置Session的过期时间为10分钟
        resp.setContentType("text/html;charset=UTF-8"); //设置返回格式和编码  设置utf-8后能正确显示中文

        Vector<UserInfoBean> vector = UserInfoManager.getInstance().getList();
        boolean isHadRegisterInfo = false; //是否有已注册信息
        if (vector != null && vector.size() > 0) {
            for (UserInfoBean userInfoBean : vector) {
                if (userInfoBean.username != null && userInfoBean.username.equals(username)) {
                    try {
                        PrintWriter out = resp.getWriter();
                        out.println("<script>alert('该用户已经登录');" +
                                "window.location.href='index.jsp'</script>");
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                    isHadRegisterInfo = true;
                    break;
                }
            }
        }

        //若还没保留用户信息，则保存
        if (!isHadRegisterInfo) {
            UserSessionHandler userSessionHandler = new UserSessionHandler();
            UserInfoBean userInfoBean = new UserInfoBean();
            userInfoBean.username = username;
            UserInfoManager.getInstance().addUserInfo(userInfoBean);
            session.setAttribute("user", userSessionHandler);// 将UserSessionHandler对象绑定到Session中
            session.setAttribute("username", username); // 保存当前登录的用户名
            session.setAttribute("loginTime", new Date().toLocaleString()); // 保存登录时间

            //开始系统公告
            String newTime = new SimpleDateFormat("yyyyMMdd")
                    .format(new Date());
            // 获取当前用户
            try {

                //若xml目录不存在则进行创建
                String dirXmlUrl = req.getSession().getServletContext()
                        .getRealPath("xml/");
                File dir = new File(dirXmlUrl);
                if (!dir.exists()) {
                    dir.mkdirs();
                }
                String fileURL = req.getSession().getServletContext()
                        .getRealPath("xml/" + newTime + ".xml");
                createFile(fileURL);// 判断XML文件是否存在，如果不存在则创建该文件

                /**
                 * 添加对应xml信息,例如：
                 * <?xml version="1.0" encoding="UTF-8"?>
                 * <chat>
                 *     <messages>
                 *         <message>
                 *             <from>[系统公告]</from>
                 *             <face/>
                 *             <to/>
                 *             <content><![CDATA[<font color='gray'>d走进了聊天室！</font>]]></content>
                 *             <sendTime>Oct 19, 2019 10:45:45 PM</sendTime>
                 *             <isPrivate>false</isPrivate>
                 *         </message>
                 * </chat>
                 */
                SAXReader reader = new SAXReader(); // 实例化SAXReader对象
                Document feedDoc = reader.read(new File(fileURL));// 获取XML文件对应的XML文档对象
                Element root = feedDoc.getRootElement(); // 获取根节点
                Element messages = root.element("messages"); // 获取messages节点
                Element message = messages.addElement("message"); // 创建子节点message
                message.addElement("from").setText("[系统公告]"); // 创建子节点from
                message.addElement("face").setText(""); // 创建子节点face
                message.addElement("to").setText(""); // 创建子节点to
                message.addElement("content").addCDATA(
                        "<font color='gray'>" + username + "走进了聊天室！</font>"); // 创建子节点content
                message.addElement("sendTime").setText(
                        new Date().toLocaleString()); // 创建子节点sendTime
                message.addElement("isPrivate").setText("false"); // 创建子节点

                //跳转到login_ok.jsp
                req.getRequestDispatcher("login_ok.jsp").forward(req,
                        resp);

                //写入文件
                OutputFormat format = new OutputFormat(); // 创建OutputFormat对象
                XMLWriter writer = new XMLWriter(new FileWriter(fileURL), format);
                writer.write(feedDoc); // 向流写入数据
                writer.close(); // 关闭XMLWriter

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    // 根据现在日期生成XML文件名，并判断该文件是否存在，如果不存在将创建该文件
    private void createFile(String fileURL) {

        //判断XML文件是否存在，如果不存在则创建该文件
        File file = new File(fileURL);
        if (!file.exists()) { // 判断文件是否存在，如果不存在，则创建该文件
            try {
                file.createNewFile(); // 创建文件
                StringBuilder stringBuilder = new StringBuilder();
                stringBuilder.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n");
                stringBuilder.append("<chat>\r\n");
                stringBuilder.append("<messages></messages>");
                stringBuilder.append("</chat>");
                byte[] content = stringBuilder.toString().getBytes();
                FileOutputStream fout = new FileOutputStream(file);
                fout.write(content); // 将数据写入输出流
                fout.flush(); // 刷新缓冲区
                fout.close(); // 关闭输出流
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
