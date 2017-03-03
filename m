From: fgao@ikuai8.com
Subject: [PATCH nf 1/1] netfilter: nat_masquerade: Check oom when invoke nfct_nat
Date: Fri,  3 Mar 2017 09:58:52 +0800
Message-ID: <1488506332-21265-1-git-send-email-fgao@ikuai8.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        gfree.wind@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from SMTPBG252.QQ.COM ([183.60.52.105]:48127 "EHLO smtpbg252.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751148AbdCCCVO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Mar 2017 21:21:14 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

When memory is exhausted, nf_ct_nat_ext_add may return NULL. Then
nf_nat_ipv4_fn and nf_nat_ipv6_fn would return NF_ACCEPT in this
case.
So we need add the NULL check when invoke nfct_nat in these two
functions.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/ipv4/netfilter/nf_nat_masquerade_ipv4.c | 2 ++
 net/ipv6/netfilter/nf_nat_masquerade_ipv6.c | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c b/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
index ea91058..353ca0c 100644
--- a/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
+++ b/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
@@ -38,6 +38,8 @@
 
 	ct = nf_ct_get(skb, &ctinfo);
 	nat = nfct_nat(ct);
+	if (!nat)
+		return NF_ACCEPT;
 
 	NF_CT_ASSERT(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
 			    ctinfo == IP_CT_RELATED_REPLY));
diff --git a/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c b/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
index 051b6a6..875e776 100644
--- a/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
+++ b/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
@@ -32,17 +32,21 @@
 	enum ip_conntrack_info ctinfo;
 	struct in6_addr src;
 	struct nf_conn *ct;
+	struct nf_conn_nat *nat;
 	struct nf_nat_range newrange;
 
 	ct = nf_ct_get(skb, &ctinfo);
 	NF_CT_ASSERT(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
 			    ctinfo == IP_CT_RELATED_REPLY));
+	nat = nfct_nat(ct);
+	if (!nat)
+		return NF_ACCEPT;
 
 	if (ipv6_dev_get_saddr(nf_ct_net(ct), out,
 			       &ipv6_hdr(skb)->daddr, 0, &src) < 0)
 		return NF_DROP;
 
-	nfct_nat(ct)->masq_index = out->ifindex;
+	nat->masq_index = out->ifindex;
 
 	newrange.flags		= range->flags | NF_NAT_RANGE_MAP_IPS;
 	newrange.min_addr.in6	= src;
-- 
1.9.1


