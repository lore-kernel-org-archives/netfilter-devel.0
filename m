From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 2/2] nfnetlink_log: use proper net to allocate skb
Date: Mon, 23 Sep 2013 19:20:56 +0800
Message-ID: <1379935256-18598-2-git-send-email-gaofeng@cn.fujitsu.com>
References: <1379935256-18598-1-git-send-email-gaofeng@cn.fujitsu.com>
Cc: Gao feng <gaofeng@cn.fujitsu.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:49862 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753126Ab3IWLTx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Sep 2013 07:19:53 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8NBJkkj026201
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Sep 2013 19:19:47 +0800
In-Reply-To: <1379935256-18598-1-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use proper net struct to allocate skb, otherwise
netlink mmap will be of no effect.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 net/netfilter/nfnetlink_log.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index d92cc31..71e39d2 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -318,8 +318,10 @@ nfulnl_set_flags(struct nfulnl_instance *inst, u_int16_t flags)
 	return 0;
 }
 
-static struct sk_buff *
-nfulnl_alloc_skb(u32 peer_portid, unsigned int inst_size, unsigned int pkt_size)
+static struct sk_buff * nfulnl_alloc_skb(struct net *net,
+					 u32 peer_portid,
+					 unsigned int inst_size,
+					 unsigned int pkt_size)
 {
 	struct sk_buff *skb;
 	unsigned int n;
@@ -328,13 +330,13 @@ nfulnl_alloc_skb(u32 peer_portid, unsigned int inst_size, unsigned int pkt_size)
 	 * message.  WARNING: has to be <= 128k due to slab restrictions */
 
 	n = max(inst_size, pkt_size);
-	skb = nfnetlink_alloc_skb(&init_net, n, peer_portid, GFP_ATOMIC);
+	skb = nfnetlink_alloc_skb(net, n, peer_portid, GFP_ATOMIC);
 	if (!skb) {
 		if (n > pkt_size) {
 			/* try to allocate only as much as we need for current
 			 * packet */
 
-			skb = nfnetlink_alloc_skb(&init_net, pkt_size,
+			skb = nfnetlink_alloc_skb(net, pkt_size,
 						  peer_portid, GFP_ATOMIC);
 			if (!skb)
 				pr_err("nfnetlink_log: can't even alloc %u bytes\n",
@@ -702,7 +704,9 @@ nfulnl_log_packet(struct net *net,
 	}
 
 	if (!inst->skb) {
-		inst->skb = nfulnl_alloc_skb(inst->peer_portid, inst->nlbufsiz,
+		inst->skb = nfulnl_alloc_skb(net,
+					     inst->peer_portid,
+					     inst->nlbufsiz,
 					     size);
 		if (!inst->skb)
 			goto alloc_failure;
-- 
1.8.3.1

