From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/3] netfilter: masquerade: attach nat extension if not present
Date: Thu, 20 Apr 2017 10:11:33 +0200
Message-ID: <20170420081135.20812-2-fw@strlen.de>
References: <20170420081135.20812-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46786 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S941953AbdDTILZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Apr 2017 04:11:25 -0400
In-Reply-To: <20170420081135.20812-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently the nat extension is always attached as soon as nat module is
loaded.  However, most NAT uses do not need the nat extension anymore.

Prepare to remove the add-nat-by-default by making those places that need
it attach it if its not present yet.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/nf_nat_masquerade_ipv4.c | 5 +++--
 net/ipv6/netfilter/nf_nat_masquerade_ipv6.c | 5 ++++-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c b/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
index ea91058b5f6f..dc1dea15c1b4 100644
--- a/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
+++ b/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
@@ -37,7 +37,6 @@ nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
 	NF_CT_ASSERT(hooknum == NF_INET_POST_ROUTING);
 
 	ct = nf_ct_get(skb, &ctinfo);
-	nat = nfct_nat(ct);
 
 	NF_CT_ASSERT(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
 			    ctinfo == IP_CT_RELATED_REPLY));
@@ -56,7 +55,9 @@ nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
 		return NF_DROP;
 	}
 
-	nat->masq_index = out->ifindex;
+	nat = nf_ct_nat_ext_add(ct);
+	if (nat)
+		nat->masq_index = out->ifindex;
 
 	/* Transfer from original range. */
 	memset(&newrange.min_addr, 0, sizeof(newrange.min_addr));
diff --git a/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c b/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
index 051b6a6bfff6..2297c9f073ba 100644
--- a/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
+++ b/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
@@ -30,6 +30,7 @@ nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range *range,
 		       const struct net_device *out)
 {
 	enum ip_conntrack_info ctinfo;
+	struct nf_conn_nat *nat;
 	struct in6_addr src;
 	struct nf_conn *ct;
 	struct nf_nat_range newrange;
@@ -42,7 +43,9 @@ nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range *range,
 			       &ipv6_hdr(skb)->daddr, 0, &src) < 0)
 		return NF_DROP;
 
-	nfct_nat(ct)->masq_index = out->ifindex;
+	nat = nf_ct_nat_ext_add(ct);
+	if (nat)
+		nat->masq_index = out->ifindex;
 
 	newrange.flags		= range->flags | NF_NAT_RANGE_MAP_IPS;
 	newrange.min_addr.in6	= src;
-- 
2.10.2

