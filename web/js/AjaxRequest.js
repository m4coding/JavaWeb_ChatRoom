/**
 * 网络获取
 */

var net = new Object(); //定义一个全局变量net

/**
 * 编写构造函数
 * @param url
 * @param onload 加载回调
 * @param onerror 错误回调
 * @param method http提交方法，例如get或post
 * @param params http提交的参数
 * @constructor
 */
net.AjaxRequest = function (url, onload, onerror, method, params) {
    this.req = null;
    this.onload = onload;
    this.onerror = (onerror) ? onerror : this.defaultError;
    this.loadDate(url, method, params);
}

//编写用于初始化XMLHttpRequest对象并指定处理函数，最后发送HTTP请求的方法
net.AjaxRequest.prototype.loadDate = function (url, method, params) {
    if (!method) { //若不指定method，则默认使用GET
        method = "GET";
    }
    if (window.XMLHttpRequest) { //非IE浏览器
        this.req = new XMLHttpRequest();
    } else if (window.ActiveXObject) { //IE浏览器
      try {
        this.req = new ActiveXObject("Msxml2.XMLHTTP");
      } catch (e) {
        try {
          this.req = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (e) {}
      }
    }

    if (this.req) {
        try {
            var loader = this;
            this.req.onreadystatechange = function () {
                net.AjaxRequest.onReadyState.call(loader);
            }

            //async为true时表示异步请求，为false表示同步请求
            this.req.open(method, url, true);
            if (method === "POST") {
                this.req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            }
            this.req.send(params);
        } catch (err) {
            this.onerror.call(this);
        }
    }
}

//重构回调函数
net.AjaxRequest.onReadyState = function () {
    var req = this.req;
    var ready = req.readyState;
    if (ready == 4) {
        if (req.status == 200) {
            this.onload.call(this);
        } else {
            this.onerror.call(this);
        }
    }
}

//重构默认的错误处理函籹
net.AjaxRequest.prototype.defaultError = function () {
    alert("错误数据\n\n回调状态:" + this.req.readyState + "\n状态: " + this.req.status);
}