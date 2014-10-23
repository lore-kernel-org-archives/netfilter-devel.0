From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/3] netfilter: nfnetlink_log: fix maximum packet length logged to userspace
Date: Thu, 23 Oct 2014 10:36:07 +0200
Message-ID: <1414053368-29037-3-git-send-email-fw@strlen.de>
References: <1414053368-29037-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49322 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752797AbaJWIgR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Oct 2014 04:36:17 -0400
In-Reply-To: <1414053368-29037-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

don't try to queue payloads > 0xffff - NLA_HDRLEN, it does not work.
The nla length includes the size of the nla struct, so anything larger
results in u16 integer overflow.

This patch is similar to
9cefbbc9c8f9abe (netfilter: nfnetlink_queue: cleanup copy_range usage).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_log.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 8117fba..2d02eac3 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -43,7 +43,8 @@
 #define NFULNL_NLBUFSIZ_DEFAULT	NLMSG_GOODSIZE
 #define NFULNL_TIMEOUT_DEFAULT 	100	/* every second */
 #define NFULNL_QTHRESH_DEFAULT 	100	/* 100 packets */
-#define NFULNL_COPY_RANGE_MAX	0xFFFF	/* max packet size is limited by 16-bit struct nfattr nfa_len field */
+/* max packet size is limited by 16-bit struct nfattr nfa_len field */
+#define NFULNL_COPY_RANGE_MAX	(0xFFFF - NLA_HDRLEN)
 
 #define PRINTR(x, args...)	do { if (net_ratelimit()) \
 				     printk(x, ## args); } while (0);
@@ -252,6 +253,8 @@ nfulnl_set_mode(struct nfulnl_instance *inst, u_int8_t mode,
 
 	case NFULNL_COPY_PACKET:
 		inst->copy_mode = mode;
+		if (range == 0)
+			range = NFULNL_COPY_RANGE_MAX;
 		inst->copy_range = min_t(unsigned int,
 					 range, NFULNL_COPY_RANGE_MAX);
 		break;
@@ -679,8 +682,7 @@ nfulnl_log_packet(struct net *net,
 		break;
 
 	case NFULNL_COPY_PACKET:
-		if (inst->copy_range == 0
-		    || inst->copy_range > skb->len)
+		if (inst->copy_range > skb->len)
 			data_len = skb->len;
 		else
 			data_len = inst->copy_range;
-- 
2.0.4

