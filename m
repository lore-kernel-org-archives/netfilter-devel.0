From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 34/34] netfilter: ipset: Use better include files in xt_set.c
Date: Sat,  2 May 2015 19:28:23 +0200
Message-ID: <1430587703-3387-35-git-send-email-kadlec@blackhole.kfki.hu>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:36971 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbbEBR2M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2015 13:28:12 -0400
In-Reply-To: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/xt_set.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/xt_set.c b/net/netfilter/xt_set.c
index b4eb4a3..07653c2 100644
--- a/net/netfilter/xt_set.c
+++ b/net/netfilter/xt_set.c
@@ -16,8 +16,9 @@
 #include <linux/skbuff.h>
 
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_set.h>
+#include <linux/netfilter/ipset/ip_set.h>
 #include <linux/netfilter/ipset/ip_set_timeout.h>
+#include <uapi/linux/netfilter/xt_set.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
-- 
1.8.5.1

