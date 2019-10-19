package com.m4coding.chatroom.user;

import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionBindingListener;

/**
 * user session监听处理
 */
public class UserSessionHandler implements HttpSessionBindingListener {

    private UserInfoBean mUser;
    private UserInfoManager userInfoManager = UserInfoManager.getInstance();

    public UserSessionHandler() {

    }

    public void setUser(UserInfoBean user) {
        mUser = user;
    }

    public UserInfoBean getUser() {
        return mUser;
    }

    @Override
    public void valueBound(HttpSessionBindingEvent event) {
        System.out.println("上线用户：" + mUser.username);
    }

    @Override
    public void valueUnbound(HttpSessionBindingEvent event) {
        System.out.println("下线用户：" + mUser.username);
        if (userInfoManager != null) {
            userInfoManager.removeUserInfo(mUser);
        }
    }
}
