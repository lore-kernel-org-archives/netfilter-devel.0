From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] netfilter: nfnetlink_queue: fix error return code in nfnetlink_queue_init()
Date: Fri, 22 Mar 2013 19:28:18 +0800
Message-ID: <CAPgLHd-WKwgAUeXH9C7OvnEmJiqZt7CJh=tZVqm5Aq0DKcqVcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: yongjun_wei@trendmicro.com.cn, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org, coreteam@netfilter.org
To: pablo@netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:60731 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab3CVL2U (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Mar 2013 07:28:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as returned elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 net/netfilter/nfnetlink_queue_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue_core.c
index 1cb4854..42680b2 100644
--- a/net/netfilter/nfnetlink_queue_core.c
+++ b/net/netfilter/nfnetlink_queue_core.c
@@ -1062,8 +1062,10 @@ static int __init nfnetlink_queue_init(void)
 
 #ifdef CONFIG_PROC_FS
 	if (!proc_create("nfnetlink_queue", 0440,
-			 proc_net_netfilter, &nfqnl_file_ops))
+			 proc_net_netfilter, &nfqnl_file_ops)) {
+		status = -ENOMEM;
 		goto cleanup_subsys;
+	}
 #endif
 
 	register_netdevice_notifier(&nfqnl_dev_notifier);


