From: Daniel Borkmann <dborkman@redhat.com>
Subject: [PATCH -nf] nft: masq: fix uninitialized range in nft_masq_{ipv4,ipv6}_eval
Date: Fri,  7 Nov 2014 15:34:54 +0100
Message-ID: <1415370894-31528-1-git-send-email-dborkman@redhat.com>
Cc: arturo.borrero.glez@gmail.com, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbaKGOe7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:34:59 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When transferring from the original range in nf_nat_masquerade_{ipv4,ipv6}()
we copy over values from stack in from min_proto/max_proto due to uninitialized
range variable in both, nft_masq_{ipv4,ipv6}_eval. As we only initialize
flags at this time from nft_masq struct, just zero out the rest.

Fixes: 9ba1f726bec09 ("netfilter: nf_tables: add new nft_masq expression")
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Acked-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 net/ipv4/netfilter/nft_masq_ipv4.c | 1 +
 net/ipv6/netfilter/nft_masq_ipv6.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/ipv4/netfilter/nft_masq_ipv4.c b/net/ipv4/netfilter/nft_masq_ipv4.c
index c1023c4..665de06 100644
--- a/net/ipv4/netfilter/nft_masq_ipv4.c
+++ b/net/ipv4/netfilter/nft_masq_ipv4.c
@@ -24,6 +24,7 @@ static void nft_masq_ipv4_eval(const struct nft_expr *expr,
 	struct nf_nat_range range;
 	unsigned int verdict;
 
+	memset(&range, 0, sizeof(range));
 	range.flags = priv->flags;
 
 	verdict = nf_nat_masquerade_ipv4(pkt->skb, pkt->ops->hooknum,
diff --git a/net/ipv6/netfilter/nft_masq_ipv6.c b/net/ipv6/netfilter/nft_masq_ipv6.c
index 8a7ac68..529c119 100644
--- a/net/ipv6/netfilter/nft_masq_ipv6.c
+++ b/net/ipv6/netfilter/nft_masq_ipv6.c
@@ -25,6 +25,7 @@ static void nft_masq_ipv6_eval(const struct nft_expr *expr,
 	struct nf_nat_range range;
 	unsigned int verdict;
 
+	memset(&range, 0, sizeof(range));
 	range.flags = priv->flags;
 
 	verdict = nf_nat_masquerade_ipv6(pkt->skb, &range, pkt->out);
-- 
1.7.11.7

