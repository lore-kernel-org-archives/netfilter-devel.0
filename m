From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 15/21] netfilter: ipset: Use better include files in xt_set.c
Date: Mon, 18 May 2015 18:25:18 +0200
Message-ID: <1431966324-4494-16-git-send-email-pablo@netfilter.org>
References: <1431966324-4494-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44040 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932275AbbERQUw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 May 2015 12:20:52 -0400
In-Reply-To: <1431966324-4494-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_set.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/xt_set.c b/net/netfilter/xt_set.c
index 8904598..b103e96 100644
--- a/net/netfilter/xt_set.c
+++ b/net/netfilter/xt_set.c
@@ -15,8 +15,9 @@
 #include <linux/skbuff.h>
 
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_set.h>
+#include <linux/netfilter/ipset/ip_set.h>
 #include <linux/netfilter/ipset/ip_set_timeout.h>
+#include <uapi/linux/netfilter/xt_set.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
-- 
1.7.10.4

