From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/3] netfilter: don't attach a nat extension by default
Date: Thu, 20 Apr 2017 10:11:35 +0200
Message-ID: <20170420081135.20812-4-fw@strlen.de>
References: <20170420081135.20812-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46790 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S943487AbdDTIL1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Apr 2017 04:11:27 -0400
In-Reply-To: <20170420081135.20812-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nowadays the NAT extension only stores the interface index
(used to purge connections that got masqueraded when interface goes down)
and pptp nat information.

Previous patches moved nf_ct_nat_ext_add to those places that need it.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_nat.h           | 2 +-
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c | 4 +---
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c | 4 +---
 net/netfilter/nf_nat_core.c              | 6 ------
 4 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index c327a431a6f3..05c82a1a4267 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -67,7 +67,7 @@ static inline bool nf_nat_oif_changed(unsigned int hooknum,
 {
 #if IS_ENABLED(CONFIG_NF_NAT_MASQUERADE_IPV4) || \
     IS_ENABLED(CONFIG_NF_NAT_MASQUERADE_IPV6)
-	return nat->masq_index && hooknum == NF_INET_POST_ROUTING &&
+	return nat && nat->masq_index && hooknum == NF_INET_POST_ROUTING &&
 	       CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL &&
 	       nat->masq_index != out->ifindex;
 #else
diff --git a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
index e3bfa6a169f0..feedd759ca80 100644
--- a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
@@ -264,9 +264,7 @@ nf_nat_ipv4_fn(void *priv, struct sk_buff *skb,
 	if (!ct)
 		return NF_ACCEPT;
 
-	nat = nf_ct_nat_ext_add(ct);
-	if (nat == NULL)
-		return NF_ACCEPT;
+	nat = nfct_nat(ct);
 
 	switch (ctinfo) {
 	case IP_CT_RELATED:
diff --git a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
index 922b5aef273c..bf3ad3e7b647 100644
--- a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
@@ -273,9 +273,7 @@ nf_nat_ipv6_fn(void *priv, struct sk_buff *skb,
 	if (!ct)
 		return NF_ACCEPT;
 
-	nat = nf_ct_nat_ext_add(ct);
-	if (nat == NULL)
-		return NF_ACCEPT;
+	nat = nfct_nat(ct);
 
 	switch (ctinfo) {
 	case IP_CT_RELATED:
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 9cbf49f9c1b7..14ad38b7ad01 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -408,12 +408,6 @@ nf_nat_setup_info(struct nf_conn *ct,
 		  enum nf_nat_manip_type maniptype)
 {
 	struct nf_conntrack_tuple curr_tuple, new_tuple;
-	struct nf_conn_nat *nat;
-
-	/* nat helper or nfctnetlink also setup binding */
-	nat = nf_ct_nat_ext_add(ct);
-	if (nat == NULL)
-		return NF_ACCEPT;
 
 	NF_CT_ASSERT(maniptype == NF_NAT_MANIP_SRC ||
 		     maniptype == NF_NAT_MANIP_DST);
-- 
2.10.2

