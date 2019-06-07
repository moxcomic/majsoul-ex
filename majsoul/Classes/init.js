if (!window.wkbridge)
{
    window.wkbridge =
    {
    responseCallbacks:{},
    callNative:function(name, sData, callback)
        {
            try {
                this.responseCallbacks[name] = callback;
                //alert('name:' + name + '\nsData:' + sData + '\ncallback:\n' + callback);
                window.webkit.messageHandlers[name].postMessage(sData);
            } catch(e) {
                var bb = '发生错误，请截图发给雀魂官方:';
                bb += e.message + '|';

                if (window) {
                    if (window.webkit) {
                        if (window.webkit.messageHandlers) {
                            if (window.webkit.messageHandlers[name]) {
                                bb += '???';
                            } else {
                                bb += 'n';
                            }
                        } else {
                            bb += 'mh';
                        }
                    } else {
                        bb += 'wk';
                    }
                } else {
                    bb += 'wd';
                }
                //                alert(error_info);
                alert(bb);
                alert('请重启应用');
            }
        }
    }
    window.wkbridge.callback = function(name, sData)
    {
        var cb = this.responseCallbacks[name];
        if (cb)
        {
            cb(sData);
        }
    }
    window.conchMarket = {};
    window.conchMarket.getMarketName = function() {
        return window.conchMarketData['market_name'];
    }
    window.conchMarket.getPayType = function() {
        return window.conchMarketData['pay_type'];
    }
    window.conchMarket.getLoginType = function() {
        return window.conchMarketData['login_type'];
    }
    window.conchMarket.getChargeType = function() {
        return window.conchMarketData['charge_type'];
    }
    window.conchMarket.setIsClearConchEngineMemory = function(bClear) {
        //TODO
    }
    window.conchMarket.getEnterPlatformType = function() {
        return window.conchMarketData['enter_platform_type'];
    }
    window.conchMarket.getIsLogined = function() {
        return false;//TODO
    }
    window.conchMarket.init = function(sData,callback)
    {
        window.wkbridge.callNative('init', sData, callback);
    }
    window.conchMarket.login = function(sData,callback)
    {
        window.wkbridge.callNative('login', sData, callback);
    }
    window.conchMarket.logout = function(sData,callback)
    {
        window.wkbridge.callNative('logout', sData, callback);
    }
    window.conchMarket.switchUser = function(sData,callback)
    {
        window.wkbridge.callNative('switchUser', sData, callback);
    }
    window.conchMarket.enterPlatform = function(sData,callback)
    {
        window.wkbridge.callNative('enterPlatform', sData, callback);
    }
    window.conchMarket.enterBBS = function(sData,callback)
    {
        window.wkbridge.callNative('enterBBS', sData, callback);
    }
    window.conchMarket.enterFeedback = function(sData,callback)
    {
        window.wkbridge.callNative('enterFeedback', sData, callback);
    }
    window.conchMarket.enterAccountMgr = function(sData,callback)
    {
        window.wkbridge.callNative('enterAccountMgr', sData, callback);
    }
    window.conchMarket.authorize = function(sData,callback)
    {
        window.wkbridge.callNative('authorize', sData, callback);
    }
    window.conchMarket.refreshToken = function(sData,callback)
    {
        window.wkbridge.callNative('refreshToken', sData, callback);
    }
    window.conchMarket.recharge = function(sData,callback)
    {
        window.wkbridge.callNative('recharge', sData, callback);
    }
    window.conchMarket.buyProps = function(sData,callback)
    {
        window.wkbridge.callNative('buyProps', sData, callback);
    }
    window.conchMarket.setRechargeInfo = function(sData,callback)
    {
        window.wkbridge.callNative('setRechargeInfo', sData, callback);
    }
    window.conchMarket.enterShareAndFeed = function(sData,callback)
    {
        window.wkbridge.callNative('enterShareAndFeed', sData, callback);
    }
    window.conchMarket.enterInvite = function(sData,callback)
    {
        window.wkbridge.callNative('enterInvite', sData, callback);
    }
    window.conchMarket.getGameFriends = function(sData,callback)
    {
        window.wkbridge.callNative('getGameFriends', sData, callback);
    }
    window.conchMarket.sendToDesktop = function(sData,callback)
    {
        window.wkbridge.callNative('sendToDesktop', sData, callback);
    }
    window.conchMarket.sendMessageToPlatform = function(sData,callback)
    {
        window.wkbridge.callNative('sendMessageToPlatform', sData, callback);
    }
    window.conchMarket.canSendToDesktop = function(sData,callback)
    {
        window.wkbridge.callNative('canSendToDesktop', sData, callback);
    }
    window.conchMarket.openTopicCircle = function(sData,callback)
    {
        window.wkbridge.callNative('openTopicCircle', sData, callback);
    }
    window.conchMarket.getUserInfo = function(sData,callback)
    {
        window.wkbridge.callNative('getUserInfo', sData, callback);
    }
    window.conchMarket.getAvailableLoginType = function(sData,callback)
    {
        window.wkbridge.callNative('getAvailableLoginType', sData, callback);
    }
    window.conchMarket.getValue = function(key)
    {
        return "";//TODO
    }
    window.conchMarket.setValue = function(key, value)
    {
        //TODO
    }
    window.conchMarket.writeLocalInfo = function(sData)
    {
        localStorage.setItem('cpinfo', sData);
    }
    window.conchMarket.getLocalInfo = function()
    {
        return localStorage.getItem('cpinfo');
    }
    window.conchMarket.openAppStoreUrl = function()
    {
        //TODO
    }
    window.conchMarket.getIsInstalledWx = function()
    {
        return false;//TODO
    }
}
