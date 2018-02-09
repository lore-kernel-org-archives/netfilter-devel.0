From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf 4/9] netfilter: xt_NFQUEUE: use pr ratelimiting
Date: Fri,  9 Feb 2018 15:52:02 +0100
Message-ID: <20180209145207.2097-5-fw@strlen.de>
References: <20180209145207.2097-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46634 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751053AbeBIOzb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Feb 2018 09:55:31 -0500
In-Reply-To: <20180209145207.2097-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

switch this to info, since these aren't really errors.
We only use printk because we cannot report meaningful errors
in the xtables framework.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Patch is new in v2.
 net/netfilter/xt_NFQUEUE.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index a360b99a958a..a9aca80a32ae 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -8,6 +8,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 
@@ -67,13 +69,13 @@ static int nfqueue_tg_check(const struct xt_tgchk_param *par)
 	init_hashrandom(&jhash_initval);
 
 	if (info->queues_total == 0) {
-		pr_err("NFQUEUE: number of total queues is 0\n");
+		pr_info_ratelimited("number of total queues is 0\n");
 		return -EINVAL;
 	}
 	maxid = info->queues_total - 1 + info->queuenum;
 	if (maxid > 0xffff) {
-		pr_err("NFQUEUE: number of queues (%u) out of range (got %u)\n",
-		       info->queues_total, maxid);
+		pr_info_ratelimited("number of queues (%u) out of range (got %u)\n",
+				    info->queues_total, maxid);
 		return -ERANGE;
 	}
 	if (par->target->revision == 2 && info->flags > 1)
-- 
2.13.6

