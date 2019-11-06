package com.m4coding.chatroom.utils;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * 业务相关的工具类
 */
public class BusinessUtils {

    /**
     * 根据现在日期生成XML文件名，并判断该文件是否存在，如果不存在将创建该文件
     */
    public static void createFile(String fileURL) {

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
