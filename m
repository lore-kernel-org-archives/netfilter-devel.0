From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2] netfilter: nf_conntrack_ipv6: Plug sk_buff leak in fragment handling
Date: Fri, 21 Jun 2013 02:38:41 +0200
Message-ID: <1371775121-9710-3-git-send-email-pablo@netfilter.org>
References: <1371775121-9710-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59462 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758217Ab3FUAi7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jun 2013 20:38:59 -0400
In-Reply-To: <1371775121-9710-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Phil Oester <kernel@linuxace.com>

In commit 4cdd3408 ("netfilter: nf_conntrack_ipv6: improve fragmentation
handling"), an sk_buff leak was introduced when dealing with reassembled
packets by grabbing a reference to the original skb instead of the
reassembled skb.  At this point, the leak only impacted conntracks with an
associated helper.

In commit 58a317f1 ("netfilter: ipv6: add IPv6 NAT support"), the bug was
expanded to include all reassembled packets with unconfirmed conntracks.

Fix this by grabbing a reference to the proper reassembled skb.  This
closes netfilter bugzilla #823.

Signed-off-by: Phil Oester <kernel@linuxace.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 97bcf2b..c9b6a6e 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -204,7 +204,7 @@ static unsigned int __ipv6_conntrack_in(struct net *net,
 		if (ct != NULL && !nf_ct_is_untracked(ct)) {
 			help = nfct_help(ct);
 			if ((help && help->helper) || !nf_ct_is_confirmed(ct)) {
-				nf_conntrack_get_reasm(skb);
+				nf_conntrack_get_reasm(reasm);
 				NF_HOOK_THRESH(NFPROTO_IPV6, hooknum, reasm,
 					       (struct net_device *)in,
 					       (struct net_device *)out,
-- 
1.7.10.4

