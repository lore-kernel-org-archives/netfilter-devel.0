From: pablo@netfilter.org
Subject: [PATCH 3/3] netfilter: ipset: timeout fixing bug broke SET target special timeout value
Date: Thu, 11 Oct 2012 12:17:38 +0200
Message-ID: <1349950658-12548-4-git-send-email-pablo@netfilter.org>
References: <1349950658-12548-1-git-send-email-pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
To: stable@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53307 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758383Ab2JKKRw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Oct 2012 06:17:52 -0400
In-Reply-To: <1349950658-12548-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

The patch "127f559 netfilter: ipset: fix timeout value overflow bug"
broke the SET target when no timeout was specified.

Reported-by: Jean-Philippe Menil <jean-philippe.menil@univ-nantes.fr>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

This patch requires:

commit 127f559127f5175e4bec3dab725a34845d956591
Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date:   Mon May 7 02:35:44 2012 +0000

    netfilter: ipset: fix timeout value overflow bug
    
    Large timeout parameters could result wrong timeout values due to
    an overflow at msec to jiffies conversion (reported by Andreas Herz)

---
 net/netfilter/xt_set.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/xt_set.c b/net/netfilter/xt_set.c
index 035960e..c6f7db7 100644
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
+	if (add_opt.timeout != IPSET_NO_TIMEOUT &&
+	    add_opt.timeout > UINT_MAX/MSEC_PER_SEC)
 		add_opt.timeout = UINT_MAX/MSEC_PER_SEC;
 	if (info->add_set.index != IPSET_INVALID_ID)
 		ip_set_add(info->add_set.index, skb, par, &add_opt);
-- 
1.7.10.4

