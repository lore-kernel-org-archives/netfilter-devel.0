From: pablo@netfilter.org
Subject: [PATCH 2/2] netfilter: nf_tables: set NLM_F_DUMP_INTR if dump is invalid
Date: Thu, 28 Mar 2013 21:22:25 +0100
Message-ID: <1364502145-3701-3-git-send-email-pablo@netfilter.org>
References: <1364502145-3701-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, tomasz.bursztyka@linux.intel.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47319 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386Ab3C1UWq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Mar 2013 16:22:46 -0400
In-Reply-To: <1364502145-3701-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Use nl_dump_check_consistent to set NLM_F_DUMP_INTR to tell user-space
that it has to retry in this dump. Just like in rtnetlink.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netns/nftables.h  |    2 +-
 net/netfilter/nf_tables_api.c |   11 +++++------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/include/net/netns/nftables.h b/include/net/netns/nftables.h
index 14d9f14..dfeb8b9 100644
--- a/include/net/netns/nftables.h
+++ b/include/net/netns/nftables.h
@@ -12,8 +12,8 @@ struct netns_nftables {
 	struct nft_af_info	*bridge;
 	u32			transaction_owner;
 	struct list_head	transaction_rules;
+	unsigned int		base_seq;
 	u8			gencursor;
-	u8			genctr;
 };
 
 #endif
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 16d1c7dc..bb3bb74 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1400,8 +1400,8 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 	unsigned int idx = 0, s_idx = cb->args[0];
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
-	u8 genctr = ACCESS_ONCE(net->nft.genctr);
-	u8 gencursor = ACCESS_ONCE(net->nft.gencursor);
+
+	cb->seq = ACCESS_ONCE(net->nft.base_seq);
 
 	list_for_each_entry(afi, &net->nft.af_info, list) {
 		if (family != NFPROTO_UNSPEC && family != afi->family)
@@ -1430,9 +1430,7 @@ cont:
 		}
 	}
 done:
-	/* Invalidate this dump, a transition to the new generation happened */
-	if (gencursor != net->nft.gencursor || genctr != net->nft.genctr)
-		return -EBUSY;
+	nl_dump_check_consistent(cb, nlmsg_hdr(skb));
 
 	cb->args[0] = idx;
 	return skb->len;
@@ -1776,7 +1774,7 @@ static int nf_tables_commit(struct sock *nlsk, struct sk_buff *skb,
 		return PTR_ERR(afi);
 
 	/* Bump generation counter, invalidate any dump in progress */
-	net->nft.genctr++;
+	while (++net->nft.base_seq == 0);
 
 	/* A new generation has just started */
 	net->nft.gencursor = gencursor_next(net);
@@ -3238,6 +3236,7 @@ static int nf_tables_init_net(struct net *net)
 {
 	INIT_LIST_HEAD(&net->nft.af_info);
 	INIT_LIST_HEAD(&net->nft.transaction_rules);
+	net->nft.base_seq = 1;
 	return 0;
 }
 
-- 
1.7.10.4

