From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next] netfilter: nfnetlink_log: add "nf-logger-5-1" module alias name
Date: Mon, 14 Nov 2016 22:41:08 +0800
Message-ID: <1479134468-18999-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-13.163.com ([220.181.12.13]:38206 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753696AbcKNOlh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Nov 2016 09:41:37 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

So we can autoload nfnetlink_log.ko when the user adding nft log
group X rule in netdev family.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/netfilter/nfnetlink_log.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 7435505..8580883 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -1152,6 +1152,7 @@ MODULE_ALIAS_NF_LOGGER(AF_INET, 1);
 MODULE_ALIAS_NF_LOGGER(AF_INET6, 1);
 MODULE_ALIAS_NF_LOGGER(AF_BRIDGE, 1);
 MODULE_ALIAS_NF_LOGGER(3, 1); /* NFPROTO_ARP */
+MODULE_ALIAS_NF_LOGGER(5, 1); /* NFPROTO_NETDEV */
 
 module_init(nfnetlink_log_init);
 module_exit(nfnetlink_log_fini);
-- 
2.5.5


