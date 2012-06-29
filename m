From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 1/1] Timeout fixing bug broke SET target special timeout value, fixed
Date: Fri, 29 Jun 2012 21:42:28 +0200
Message-ID: <1340998948-29672-2-git-send-email-kadlec@blackhole.kfki.hu>
References: <1340998948-29672-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:54332 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671Ab2F2Tma (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Jun 2012 15:42:30 -0400
In-Reply-To: <1340998948-29672-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The patch "Fix timeout value overflow bug at large timeout parameters"
broke the SET target when no timeout was specified (reported by
Jean-Philippe Menil).

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/xt_set.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_set.c b/net/netfilter/xt_set.c
index 035960e..b172cbc 100644
--- a/net/netfilter/xt_set.c
+++ b/net/netfilter/xt_set.c
@@ -16,6 +16,7 @@
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_set.h>
+#include <linux/netfilter/ipset/ip_set_timeout.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
@@ -310,7 +311,8 @@ set_target_v2(struct sk_buff *skb, const struct xt_action_param *par)
 		info->del_set.flags, 0, UINT_MAX);
 
 	/* Normalize to fit into jiffies */
-	if (add_opt.timeout > UINT_MAX/MSEC_PER_SEC)
+	if (add_opt.timeout != IPSET_NO_TIMEOUT
+	    && add_opt.timeout > UINT_MAX/MSEC_PER_SEC)
 		add_opt.timeout = UINT_MAX/MSEC_PER_SEC;
 	if (info->add_set.index != IPSET_INVALID_ID)
 		ip_set_add(info->add_set.index, skb, par, &add_opt);
-- 
1.7.0.4

