From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 22/30] netfilter: nf_tables: Pass struct net in nft_pktinfo
Date: Tue, 22 Sep 2015 11:14:12 +0200
Message-ID: <1442913260-3925-23-git-send-email-pablo@netfilter.org>
References: <1442913260-3925-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35160 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932647AbbIVJIA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Sep 2015 05:08:00 -0400
In-Reply-To: <1442913260-3925-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: "Eric W. Biederman" <ebiederm@xmission.com>

nft_pktinfo is passed on the stack so this does not bloat any in core
data structures.

By centrally computing this information this makes maintence of the code
simpler, and understading of the code easier.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index c051652..42e239e 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -14,6 +14,7 @@
 
 struct nft_pktinfo {
 	struct sk_buff			*skb;
+	struct net			*net;
 	const struct net_device		*in;
 	const struct net_device		*out;
 	u8				pf;
@@ -30,7 +31,7 @@ static inline void nft_set_pktinfo(struct nft_pktinfo *pkt,
 				   const struct nf_hook_state *state)
 {
 	pkt->skb = skb;
-	pkt->xt.net = state->net;
+	pkt->net = pkt->xt.net = state->net;
 	pkt->in = pkt->xt.in = state->in;
 	pkt->out = pkt->xt.out = state->out;
 	pkt->hook = pkt->xt.hooknum = state->hook;
-- 
1.7.10.4

