package com.m4coding.chatroom.user;

import java.util.Vector;

/**
 * 用户信息管理器
 */
public class UserInfoManager {
    private Vector<UserInfoBean> mVector = null;
    private static UserInfoManager sInstance;

    public static UserInfoManager getInstance() {
        if (null == sInstance) {
            synchronized (UserInfoManager.class) {
                if (null == sInstance) {
                    sInstance = new UserInfoManager();
                }
            }
        }

        return sInstance;
    }

    private UserInfoManager() {
        mVector = new Vector<>();
    }

    public boolean addUserInfo(UserInfoBean bean) {
        if (bean != null) {
            mVector.add(bean);
            return true;
        } else {
            return false;
        }
    }

    public boolean removeUserInfo(UserInfoBean bean) {
        if (mVector != null && mVector != null) {
            return mVector.removeElement(bean);
        }

        return false;
    }

    public Vector<UserInfoBean> getList() {
        return mVector;
    }
}
