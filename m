From: pablo@netfilter.org
Subject: [PATCH 4/7] netfilter: nf_tables: move specific layer 3 compat code to nf_tables_ipv[4|6]
Date: Thu, 10 Jan 2013 16:28:38 +0100
Message-ID: <1357831721-10182-4-git-send-email-pablo@netfilter.org>
References: <1357831721-10182-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, tomasz.bursztyka@linux.intel.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37140 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679Ab3AJP27 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:28:59 -0500
In-Reply-To: <1357831721-10182-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch moves the struct xt_action_param to struct nft_pktinfo
and that structure is filled at the beginning of the every chain.

The specific code to handle IPv4 and IPv6 now resides in
nf_tables_ipv[4|6].

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h         |   24 +++++++---
 include/net/netfilter/nf_tables_ipv4.h    |   23 ++++++++++
 include/net/netfilter/nf_tables_ipv6.h    |   29 ++++++++++++
 include/net/netns/nftables.h              |    3 +-
 net/ipv4/netfilter/nf_tables_ipv4.c       |   30 ++++++++++---
 net/ipv4/netfilter/nft_chain_nat_ipv4.c   |    6 ++-
 net/ipv4/netfilter/nft_chain_route_ipv4.c |    6 ++-
 net/ipv6/netfilter/nf_tables_ipv6.c       |   31 ++++++++++---
 net/ipv6/netfilter/nft_chain_nat_ipv6.c   |    6 ++-
 net/ipv6/netfilter/nft_chain_route_ipv6.c |    7 ++-
 net/netfilter/nf_tables_core.c            |   19 +++-----
 net/netfilter/nft_compat.c                |   69 +++--------------------------
 12 files changed, 154 insertions(+), 99 deletions(-)
 create mode 100644 include/net/netfilter/nf_tables_ipv4.h
 create mode 100644 include/net/netfilter/nf_tables_ipv6.h

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 0dc7d80..98e31eb 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -3,6 +3,7 @@
 
 #include <linux/list.h>
 #include <linux/netfilter.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/netlink.h>
 
@@ -16,10 +17,22 @@ struct nft_pktinfo {
 	u8				nhoff;
 	u8				thoff;
 	/* for x_tables compatibility */
-	bool				compat_set;
-	u16				fragoff;
+	struct xt_action_param		xt;
 };
 
+static inline void nft_set_pktinfo(struct nft_pktinfo *pkt,
+				   const struct nf_hook_ops *ops,
+				   struct sk_buff *skb,
+				   const struct net_device *in,
+				   const struct net_device *out)
+{
+	pkt->skb = skb;
+	pkt->in = pkt->xt.in = in;
+	pkt->out = pkt->xt.out = out;
+	pkt->hooknum = pkt->xt.hooknum = ops->hooknum;
+	pkt->xt.family = ops->pf;
+}
+
 struct nft_data {
 	union {
 		u32				data[4];
@@ -397,11 +410,8 @@ static inline struct nft_base_chain *nft_base_chain(const struct nft_chain *chai
 	return container_of(chain, struct nft_base_chain, chain);
 }
 
-extern unsigned int nft_do_chain(const struct nf_hook_ops *ops,
-				 struct sk_buff *skb,
-				 const struct net_device *in,
-				 const struct net_device *out,
-				 int (*okfn)(struct sk_buff *));
+extern unsigned int nft_do_chain_pktinfo(struct nft_pktinfo *pkt,
+					 const struct nf_hook_ops *ops);
 
 /**
  *	struct nft_table - nf_tables table
diff --git a/include/net/netfilter/nf_tables_ipv4.h b/include/net/netfilter/nf_tables_ipv4.h
new file mode 100644
index 0000000..1be1c2c
--- /dev/null
+++ b/include/net/netfilter/nf_tables_ipv4.h
@@ -0,0 +1,23 @@
+#ifndef _NF_TABLES_IPV4_H_
+#define _NF_TABLES_IPV4_H_
+
+#include <net/netfilter/nf_tables.h>
+#include <net/ip.h>
+
+static inline void
+nft_set_pktinfo_ipv4(struct nft_pktinfo *pkt,
+		     const struct nf_hook_ops *ops,
+		     struct sk_buff *skb,
+		     const struct net_device *in,
+		     const struct net_device *out)
+{
+	struct iphdr *ip;
+
+	nft_set_pktinfo(pkt, ops, skb, in, out);
+
+	pkt->xt.thoff = ip_hdrlen(pkt->skb);
+	ip = ip_hdr(pkt->skb);
+	pkt->xt.fragoff = ntohs(ip->frag_off) & IP_OFFSET;
+}
+
+#endif
diff --git a/include/net/netfilter/nf_tables_ipv6.h b/include/net/netfilter/nf_tables_ipv6.h
new file mode 100644
index 0000000..f836642
--- /dev/null
+++ b/include/net/netfilter/nf_tables_ipv6.h
@@ -0,0 +1,29 @@
+#ifndef _NF_TABLES_IPV6_H_
+#define _NF_TABLES_IPV6_H_
+
+#include <linux/netfilter_ipv6/ip6_tables.h>
+
+static inline int
+nft_set_pktinfo_ipv6(struct nft_pktinfo *pkt,
+		     const struct nf_hook_ops *ops,
+		     struct sk_buff *skb,
+		     const struct net_device *in,
+		     const struct net_device *out)
+{
+	int protohdr, thoff = 0;
+	unsigned short frag_off;
+
+	nft_set_pktinfo(pkt, ops, skb, in, out);
+
+	protohdr = ipv6_find_hdr(pkt->skb, &thoff, -1, &frag_off, NULL);
+	/* If malformed, drop it */
+	if (protohdr < 0)
+		return -1;
+
+	pkt->xt.thoff = thoff;
+	pkt->xt.fragoff = frag_off;
+
+	return 0;
+}
+
+#endif
diff --git a/include/net/netns/nftables.h b/include/net/netns/nftables.h
index 255757c..a98b1c5 100644
--- a/include/net/netns/nftables.h
+++ b/include/net/netns/nftables.h
@@ -2,7 +2,8 @@
 #define _NETNS_NFTABLES_H_
 
 #include <linux/list.h>
-#include <net/netfilter/nf_tables.h>
+
+struct nft_af_info;
 
 struct netns_nftables {
 	struct list_head	af_info;
diff --git a/net/ipv4/netfilter/nf_tables_ipv4.c b/net/ipv4/netfilter/nf_tables_ipv4.c
index 29e09e9..9ae1dae 100644
--- a/net/ipv4/netfilter/nf_tables_ipv4.c
+++ b/net/ipv4/netfilter/nf_tables_ipv4.c
@@ -15,7 +15,7 @@
 #include <linux/netfilter_ipv4.h>
 #include <net/netfilter/nf_tables.h>
 #include <net/net_namespace.h>
-#include <net/ip.h>
+#include <net/netfilter/nf_tables_ipv4.h>
 
 static unsigned int nft_ipv4_output(const struct nf_hook_ops *ops,
 				    struct sk_buff *skb,
@@ -23,6 +23,8 @@ static unsigned int nft_ipv4_output(const struct nf_hook_ops *ops,
 				    const struct net_device *out,
 				    int (*okfn)(struct sk_buff *))
 {
+	struct nft_pktinfo pkt;
+
 	if (unlikely(skb->len < sizeof(struct iphdr) ||
 		     ip_hdr(skb)->ihl < sizeof(struct iphdr) / 4)) {
 		if (net_ratelimit())
@@ -30,8 +32,9 @@ static unsigned int nft_ipv4_output(const struct nf_hook_ops *ops,
 				"packet\n");
 		return NF_ACCEPT;
 	}
+	nft_set_pktinfo_ipv4(&pkt, ops, skb, in, out);
 
-	return nft_do_chain(ops, skb, in, out, okfn);
+	return nft_do_chain_pktinfo(&pkt, ops);
 }
 
 static struct nft_af_info nft_af_ipv4 __read_mostly = {
@@ -68,6 +71,20 @@ static struct pernet_operations nf_tables_ipv4_net_ops = {
 	.exit	= nf_tables_ipv4_exit_net,
 };
 
+static unsigned int
+nft_do_chain_ipv4(const struct nf_hook_ops *ops,
+		  struct sk_buff *skb,
+		  const struct net_device *in,
+		  const struct net_device *out,
+		  int (*okfn)(struct sk_buff *))
+{
+	struct nft_pktinfo pkt;
+
+	nft_set_pktinfo_ipv4(&pkt, ops, skb, in, out);
+
+	return nft_do_chain_pktinfo(&pkt, ops);
+}
+
 static struct nf_chain_type filter_ipv4 = {
 	.family		= NFPROTO_IPV4,
 	.name		= "filter",
@@ -78,11 +95,12 @@ static struct nf_chain_type filter_ipv4 = {
 			  (1 << NF_INET_PRE_ROUTING) |
 			  (1 << NF_INET_POST_ROUTING),
 	.fn		= {
-		[NF_INET_LOCAL_IN]	= nft_do_chain,
+		[NF_INET_LOCAL_IN]	= nft_do_chain_ipv4,
 		[NF_INET_LOCAL_OUT]	= nft_ipv4_output,
-		[NF_INET_FORWARD]	= nft_do_chain,
-		[NF_INET_PRE_ROUTING]	= nft_do_chain,
-		[NF_INET_POST_ROUTING]	= nft_do_chain,
+		[NF_INET_LOCAL_OUT]	= nft_do_chain_ipv4,
+		[NF_INET_FORWARD]	= nft_do_chain_ipv4,
+		[NF_INET_PRE_ROUTING]	= nft_do_chain_ipv4,
+		[NF_INET_POST_ROUTING]	= nft_do_chain_ipv4,
 	},
 };
 
diff --git a/net/ipv4/netfilter/nft_chain_nat_ipv4.c b/net/ipv4/netfilter/nft_chain_nat_ipv4.c
index ce9879e..e42d6d9 100644
--- a/net/ipv4/netfilter/nft_chain_nat_ipv4.c
+++ b/net/ipv4/netfilter/nft_chain_nat_ipv4.c
@@ -22,6 +22,7 @@
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_ipv4.h>
 #include <net/netfilter/nf_nat_l3proto.h>
 #include <net/ip.h>
 
@@ -39,6 +40,7 @@ static unsigned int nf_nat_fn(const struct nf_hook_ops *ops,
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 	struct nf_conn_nat *nat;
 	enum nf_nat_manip_type maniptype = HOOK2MANIP(ops->hooknum);
+	struct nft_pktinfo pkt;
 	unsigned int ret;
 
 	if (ct == NULL || nf_ct_is_untracked(ct))
@@ -71,7 +73,9 @@ static unsigned int nf_nat_fn(const struct nf_hook_ops *ops,
 		if (nf_nat_initialized(ct, maniptype))
 			break;
 
-		ret = nft_do_chain(ops, skb, in, out, okfn);
+		nft_set_pktinfo_ipv4(&pkt, ops, skb, in, out);
+
+		ret = nft_do_chain_pktinfo(&pkt, ops);
 		if (ret != NF_ACCEPT)
 			return ret;
 		if (!nf_nat_initialized(ct, maniptype)) {
diff --git a/net/ipv4/netfilter/nft_chain_route_ipv4.c b/net/ipv4/netfilter/nft_chain_route_ipv4.c
index 471edd3..f991eb0 100644
--- a/net/ipv4/netfilter/nft_chain_route_ipv4.c
+++ b/net/ipv4/netfilter/nft_chain_route_ipv4.c
@@ -17,6 +17,7 @@
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_ipv4.h>
 #include <net/route.h>
 
 static unsigned int nf_route_table_hook(const struct nf_hook_ops *ops,
@@ -26,11 +27,14 @@ static unsigned int nf_route_table_hook(const struct nf_hook_ops *ops,
 					int (*okfn)(struct sk_buff *))
 {
 	unsigned int ret;
+	struct nft_pktinfo pkt;
 	u32 mark;
 
+	nft_set_pktinfo_ipv4(&pkt, ops, skb, in, out);
+
 	// FIXME: length validation
 	mark = skb->mark;
-	ret = nft_do_chain(ops, skb, in, out, okfn);
+	ret = nft_do_chain_pktinfo(&pkt, ops);
 	if (ret != NF_DROP && ret != NF_QUEUE) {
 		if (skb->mark != mark && ip_route_me_harder(skb, RTN_UNSPEC))
 			ret = NF_DROP;
diff --git a/net/ipv6/netfilter/nf_tables_ipv6.c b/net/ipv6/netfilter/nf_tables_ipv6.c
index 84ccd35..e2d856e 100644
--- a/net/ipv6/netfilter/nf_tables_ipv6.c
+++ b/net/ipv6/netfilter/nf_tables_ipv6.c
@@ -14,6 +14,7 @@
 #include <linux/ipv6.h>
 #include <linux/netfilter_ipv6.h>
 #include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_ipv6.h>
 
 static unsigned int nft_ipv6_output(const struct nf_hook_ops *ops,
 				    struct sk_buff *skb,
@@ -21,14 +22,18 @@ static unsigned int nft_ipv6_output(const struct nf_hook_ops *ops,
 				    const struct net_device *out,
 				    int (*okfn)(struct sk_buff *))
 {
+	struct nft_pktinfo pkt;
+
 	if (unlikely(skb->len < sizeof(struct ipv6hdr))) {
 		if (net_ratelimit())
 			pr_info("nf_tables_ipv6: ignoring short SOCK_RAW "
 				"packet\n");
 		return NF_ACCEPT;
 	}
+	if (nft_set_pktinfo_ipv6(&pkt, ops, skb, in, out) < 0)
+		return NF_DROP;
 
-	return nft_do_chain(ops, skb, in, out, okfn);
+	return nft_do_chain_pktinfo(&pkt, ops);
 }
 
 static struct nft_af_info nft_af_ipv6 __read_mostly = {
@@ -65,6 +70,22 @@ static struct pernet_operations nf_tables_ipv6_net_ops = {
 	.exit	= nf_tables_ipv6_exit_net,
 };
 
+static unsigned int
+nft_do_chain_ipv6(const struct nf_hook_ops *ops,
+		  struct sk_buff *skb,
+		  const struct net_device *in,
+		  const struct net_device *out,
+		  int (*okfn)(struct sk_buff *))
+{
+	struct nft_pktinfo pkt;
+
+	/* malformed packet, drop it */
+	if (nft_set_pktinfo_ipv6(&pkt, ops, skb, in, out) < 0)
+		return NF_DROP;
+
+	return nft_do_chain_pktinfo(&pkt, ops);
+}
+
 static struct nf_chain_type filter_ipv6 = {
 	.family		= NFPROTO_IPV6,
 	.name		= "filter",
@@ -75,11 +96,11 @@ static struct nf_chain_type filter_ipv6 = {
 			  (1 << NF_INET_PRE_ROUTING) |
 			  (1 << NF_INET_POST_ROUTING),
 	.fn		= {
-		[NF_INET_LOCAL_IN]	= nft_do_chain,
+		[NF_INET_LOCAL_IN]	= nft_do_chain_ipv6,
 		[NF_INET_LOCAL_OUT]	= nft_ipv6_output,
-		[NF_INET_FORWARD]	= nft_do_chain,
-		[NF_INET_PRE_ROUTING]	= nft_do_chain,
-		[NF_INET_POST_ROUTING]	= nft_do_chain,
+		[NF_INET_FORWARD]	= nft_do_chain_ipv6,
+		[NF_INET_PRE_ROUTING]	= nft_do_chain_ipv6,
+		[NF_INET_POST_ROUTING]	= nft_do_chain_ipv6,
 	},
 };
 
diff --git a/net/ipv6/netfilter/nft_chain_nat_ipv6.c b/net/ipv6/netfilter/nft_chain_nat_ipv6.c
index bc2f351..9f283dd 100644
--- a/net/ipv6/netfilter/nft_chain_nat_ipv6.c
+++ b/net/ipv6/netfilter/nft_chain_nat_ipv6.c
@@ -20,6 +20,7 @@
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_ipv6.h>
 #include <net/netfilter/nf_nat_l3proto.h>
 #include <net/ipv6.h>
 
@@ -40,6 +41,7 @@ static unsigned int nf_nat_ipv6_fn(const struct nf_hook_ops *ops,
 	__be16 frag_off;
 	int hdrlen;
 	u8 nexthdr;
+	struct nft_pktinfo pkt;
 	unsigned int ret;
 
 	if (ct == NULL || nf_ct_is_untracked(ct))
@@ -75,7 +77,9 @@ static unsigned int nf_nat_ipv6_fn(const struct nf_hook_ops *ops,
 		if (nf_nat_initialized(ct, maniptype))
 			break;
 
-		ret = nft_do_chain(ops, skb, in, out, okfn);
+		nft_set_pktinfo_ipv6(&pkt, ops, skb, in, out);
+
+		ret = nft_do_chain_pktinfo(&pkt, ops);
 		if (ret != NF_ACCEPT)
 			return ret;
 		if (!nf_nat_initialized(ct, maniptype)) {
diff --git a/net/ipv6/netfilter/nft_chain_route_ipv6.c b/net/ipv6/netfilter/nft_chain_route_ipv6.c
index 0504695..341b3a8 100644
--- a/net/ipv6/netfilter/nft_chain_route_ipv6.c
+++ b/net/ipv6/netfilter/nft_chain_route_ipv6.c
@@ -19,6 +19,7 @@
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_ipv6.h>
 #include <net/route.h>
 
 static unsigned int nf_route_table_hook(const struct nf_hook_ops *ops,
@@ -28,10 +29,14 @@ static unsigned int nf_route_table_hook(const struct nf_hook_ops *ops,
 					int (*okfn)(struct sk_buff *))
 {
 	unsigned int ret;
+	struct nft_pktinfo pkt;
 	u32 mark;
 
+	if (nft_set_pktinfo_ipv6(&pkt, ops, skb, in, out) < 0)
+		return NF_DROP;
+
 	mark = skb->mark;
-	ret = nft_do_chain(ops, skb, in, out, okfn);
+	ret = nft_do_chain_pktinfo(&pkt, ops);
 	if (ret != NF_DROP && ret != NF_QUEUE) {
 		if (skb->mark != mark && ip6_route_me_harder(skb))
 			ret = NF_DROP;
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index a860769..a87a5b7 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -60,22 +60,13 @@ static bool nft_payload_fast_eval(const struct nft_expr *expr,
 	return true;
 }
 
-unsigned int nft_do_chain(const struct nf_hook_ops *ops,
-			  struct sk_buff *skb,
-			  const struct net_device *in,
-			  const struct net_device *out,
-			  int (*okfn)(struct sk_buff *))
+unsigned int
+nft_do_chain_pktinfo(struct nft_pktinfo *pkt, const struct nf_hook_ops *ops)
 {
 	const struct nft_chain *chain = ops->priv;
 	const struct nft_rule *rule;
 	const struct nft_expr *expr, *last;
 	struct nft_data data[NFT_REG_MAX + 1];
-	const struct nft_pktinfo pkt = {
-		.skb		= skb,
-		.in		= in,
-		.out		= out,
-		.hooknum	= ops->hooknum,
-	};
 	unsigned int stackptr = 0;
 	struct {
 		const struct nft_chain	*chain;
@@ -91,8 +82,8 @@ next_rule:
 			if (expr->ops == &nft_cmp_fast_ops)
 				nft_cmp_fast_eval(expr, data);
 			else if (expr->ops != &nft_payload_fast_ops ||
-				 !nft_payload_fast_eval(expr, data, &pkt))
-				expr->ops->eval(expr, data, &pkt);
+				 !nft_payload_fast_eval(expr, data, pkt))
+				expr->ops->eval(expr, data, pkt);
 
 			if (data[NFT_REG_VERDICT].verdict != NFT_CONTINUE)
 				break;
@@ -138,7 +129,7 @@ next_rule:
 
 	return nft_base_chain(chain)->policy;
 }
-EXPORT_SYMBOL_GPL(nft_do_chain);
+EXPORT_SYMBOL_GPL(nft_do_chain_pktinfo);
 
 int __init nf_tables_core_module_init(void)
 {
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 416c89e..1bd642c 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -17,53 +17,16 @@
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter/nf_tables_compat.h>
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
 #include <net/netfilter/nf_tables.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
 
-static inline int
-nft_compat_set_pktinfo(struct nft_pktinfo *pkt, u8 family)
-{
-	int protohdr, thoff = 0;
-	unsigned short frag_off;
-	struct iphdr *ip;
-
-	switch(family) {
-	case NFPROTO_IPV4:
-		pkt->thoff = ip_hdrlen(pkt->skb);
-		ip = ip_hdr(pkt->skb);
-		pkt->fragoff = ntohs(ip->frag_off) & IP_OFFSET;
-		pkt->compat_set = true;
-		break;
-	case NFPROTO_IPV6:
-		protohdr = ipv6_find_hdr(pkt->skb, &thoff, -1, &frag_off, NULL);
-		/* If malformed, drop it */
-		if (protohdr < 0)
-			return -1;
-
-		pkt->thoff = thoff;
-		pkt->fragoff = frag_off;
-		pkt->compat_set = true;
-		break;
-	}
-	return 0;
-}
-
 static inline void
-nft_compat_set_par(struct xt_action_param *par, const struct nft_pktinfo *pkt,
-		   const void *xt, const void *xt_info, u8 family)
+nft_compat_set_par(struct xt_action_param *par, void *xt, const void *xt_info)
 {
 	par->target	= xt;
 	par->targinfo	= xt_info;
-	par->in		= pkt->in;
-	par->out	= pkt->out;
-	par->hooknum	= pkt->hooknum;
-	par->thoff	= pkt->thoff;
-	par->family	= family;
 	par->hotdrop	= false;
-	par->fragoff	= pkt->fragoff;
 }
 
 static void nft_target_eval(const struct nft_expr *expr,
@@ -73,22 +36,13 @@ static void nft_target_eval(const struct nft_expr *expr,
 	void *info = nft_expr_priv(expr);
 	struct xt_target *target = expr->ops->data;
 	struct sk_buff *skb = pkt->skb;
-	struct xt_action_param par;
 	int ret;
 
-	if (!pkt->compat_set) {
-		if (nft_compat_set_pktinfo((struct nft_pktinfo *)pkt,
-					   target->family) < 0) {
-			data[NFT_REG_VERDICT].verdict = NF_DROP;
-			return;
-		}
-	}
-
-	nft_compat_set_par(&par, pkt, target, info, target->family);
+	nft_compat_set_par((struct xt_action_param *)&pkt->xt, target, info);
 
-	ret = target->target(skb, &par);
+	ret = target->target(skb, &pkt->xt);
 
-	if (par.hotdrop)
+	if (pkt->xt.hotdrop)
 		ret = NF_DROP;
 
 	switch(ret) {
@@ -213,22 +167,13 @@ static void nft_match_eval(const struct nft_expr *expr,
 	void *info = nft_expr_priv(expr);
 	struct xt_match *match = expr->ops->data;
 	struct sk_buff *skb = pkt->skb;
-	struct xt_action_param par;
 	bool ret;
 
-	if (!pkt->compat_set) {
-		if (nft_compat_set_pktinfo((struct nft_pktinfo *)pkt,
-					   match->family) < 0) {
-			data[NFT_REG_VERDICT].verdict = NF_DROP;
-			return;
-		}
-	}
-
-	nft_compat_set_par(&par, pkt, match, info, match->family);
+	nft_compat_set_par((struct xt_action_param *)&pkt->xt, match, info);
 
-	ret = match->match(skb, &par);
+	ret = match->match(skb, (struct xt_action_param *)&pkt->xt);
 
-	if (par.hotdrop) {
+	if (pkt->xt.hotdrop) {
 		data[NFT_REG_VERDICT].verdict = NF_DROP;
 		return;
 	}
-- 
1.7.10.4

