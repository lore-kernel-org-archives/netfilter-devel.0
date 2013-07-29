From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/7] netfilter: nf_queue: relax NFQA_CT attribute check
Date: Mon, 29 Jul 2013 15:41:51 +0200
Message-ID: <1375105316-13216-3-git-send-email-fw@strlen.de>
References: <1375105316-13216-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52396 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756156Ab3G2Nk0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Jul 2013 09:40:26 -0400
In-Reply-To: <1375105316-13216-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Allow modifying attributes of the conntrack associated with a packet
without first requesting ct data via CFG_F_CONNTRACK or extra
nfnetlink_conntrack socket.

Also remove unneded rcu_read_lock; the entire function is already
protected by rcu.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_queue_core.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue_core.c
index 971ea14..ec9de12 100644
--- a/net/netfilter/nfnetlink_queue_core.c
+++ b/net/netfilter/nfnetlink_queue_core.c
@@ -987,8 +987,7 @@ nfqnl_recv_verdict(struct sock *ctnl, struct sk_buff *skb,
 	if (entry == NULL)
 		return -ENOENT;
 
-	rcu_read_lock();
-	if (nfqa[NFQA_CT] && (queue->flags & NFQA_CFG_F_CONNTRACK))
+	if (nfqa[NFQA_CT])
 		ct = nfqnl_ct_parse(entry->skb, nfqa[NFQA_CT], &ctinfo);
 
 	if (nfqa[NFQA_PAYLOAD]) {
@@ -1002,7 +1001,6 @@ nfqnl_recv_verdict(struct sock *ctnl, struct sk_buff *skb,
 		if (ct)
 			nfqnl_ct_seq_adjust(skb, ct, ctinfo, diff);
 	}
-	rcu_read_unlock();
 
 	if (nfqa[NFQA_MARK])
 		entry->skb->mark = ntohl(nla_get_be32(nfqa[NFQA_MARK]));
-- 
1.7.8.6

