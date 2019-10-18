package com.m4coding.chatroom.servlet;

import com.m4coding.chatroom.user.UserInfoBean;
import com.m4coding.chatroom.user.UserInfoManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
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
            try {
                PrintWriter out = resp.getWriter();
                out.println("<script>alert('去保留该用户信息');" +
                        "window.location.href='index.jsp'</script>");
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
