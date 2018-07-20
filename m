From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 11/38] netfilter: conntrack: remove get_l4proto indirection from l3 protocol trackers
Date: Fri, 20 Jul 2018 15:08:39 +0200
Message-ID: <20180720130906.27687-12-pablo@netfilter.org>
References: <20180720130906.27687-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180720130906.27687-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Handle it in the core instead.

ipv6_skip_exthdr() is built-in even if ipv6 is a module, i.e. this
doesn't create an ipv6 dependency.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_l3proto.h   |   8 --
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |  30 -------
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |  29 -------
 net/netfilter/Makefile                         |   2 +-
 net/netfilter/nf_conntrack_core.c              | 108 ++++++++++++++++++++-----
 net/netfilter/nf_conntrack_l3proto_generic.c   |  46 -----------
 net/netfilter/nf_conntrack_proto.c             |   5 ++
 7 files changed, 94 insertions(+), 134 deletions(-)
 delete mode 100644 net/netfilter/nf_conntrack_l3proto_generic.c

diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
index 164641c743a5..5f160375c93a 100644
--- a/include/net/netfilter/nf_conntrack_l3proto.h
+++ b/include/net/netfilter/nf_conntrack_l3proto.h
@@ -24,14 +24,6 @@ struct nf_conntrack_l3proto {
 	/* size of tuple nlattr, fills a hole */
 	u16 nla_size;
 
-	/*
-	 * Called before tracking. 
-	 *	*dataoff: offset of protocol header (TCP, UDP,...) in skb
-	 *	*protonum: protocol number
-	 */
-	int (*get_l4proto)(const struct sk_buff *skb, unsigned int nhoff,
-			   unsigned int *dataoff, u_int8_t *protonum);
-
 	/* Called when netns wants to use connection tracking */
 	int (*net_ns_get)(struct net *);
 	void (*net_ns_put)(struct net *);
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index e10e38c443ab..9fbf6c7f8ece 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -38,35 +38,6 @@ struct conntrack4_net {
 	unsigned int users;
 };
 
-static int ipv4_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
-			    unsigned int *dataoff, u_int8_t *protonum)
-{
-	const struct iphdr *iph;
-	struct iphdr _iph;
-
-	iph = skb_header_pointer(skb, nhoff, sizeof(_iph), &_iph);
-	if (iph == NULL)
-		return -NF_ACCEPT;
-
-	/* Conntrack defragments packets, we might still see fragments
-	 * inside ICMP packets though. */
-	if (iph->frag_off & htons(IP_OFFSET))
-		return -NF_ACCEPT;
-
-	*dataoff = nhoff + (iph->ihl << 2);
-	*protonum = iph->protocol;
-
-	/* Check bogus IP headers */
-	if (*dataoff > skb->len) {
-		pr_debug("nf_conntrack_ipv4: bogus IPv4 packet: "
-			 "nhoff %u, ihl %u, skblen %u\n",
-			 nhoff, iph->ihl << 2, skb->len);
-		return -NF_ACCEPT;
-	}
-
-	return NF_ACCEPT;
-}
-
 static unsigned int ipv4_helper(void *priv,
 				struct sk_buff *skb,
 				const struct nf_hook_state *state)
@@ -297,7 +268,6 @@ static void ipv4_hooks_unregister(struct net *net)
 
 const struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4 = {
 	.l3proto	 = PF_INET,
-	.get_l4proto	 = ipv4_get_l4proto,
 	.net_ns_get	 = ipv4_hooks_register,
 	.net_ns_put	 = ipv4_hooks_unregister,
 	.me		 = THIS_MODULE,
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index f8051fe20489..37ab25645cf2 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -41,34 +41,6 @@ struct conntrack6_net {
 	unsigned int users;
 };
 
-static int ipv6_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
-			    unsigned int *dataoff, u_int8_t *protonum)
-{
-	unsigned int extoff = nhoff + sizeof(struct ipv6hdr);
-	__be16 frag_off;
-	int protoff;
-	u8 nexthdr;
-
-	if (skb_copy_bits(skb, nhoff + offsetof(struct ipv6hdr, nexthdr),
-			  &nexthdr, sizeof(nexthdr)) != 0) {
-		pr_debug("ip6_conntrack_core: can't get nexthdr\n");
-		return -NF_ACCEPT;
-	}
-	protoff = ipv6_skip_exthdr(skb, extoff, &nexthdr, &frag_off);
-	/*
-	 * (protoff == skb->len) means the packet has not data, just
-	 * IPv6 and possibly extensions headers, but it is tracked anyway
-	 */
-	if (protoff < 0 || (frag_off & htons(~0x7)) != 0) {
-		pr_debug("ip6_conntrack_core: can't find proto in pkt\n");
-		return -NF_ACCEPT;
-	}
-
-	*dataoff = protoff;
-	*protonum = nexthdr;
-	return NF_ACCEPT;
-}
-
 static unsigned int ipv6_helper(void *priv,
 				struct sk_buff *skb,
 				const struct nf_hook_state *state)
@@ -281,7 +253,6 @@ static void ipv6_hooks_unregister(struct net *net)
 
 const struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv6 = {
 	.l3proto		= PF_INET6,
-	.get_l4proto		= ipv6_get_l4proto,
 	.net_ns_get		= ipv6_hooks_register,
 	.net_ns_put		= ipv6_hooks_unregister,
 	.me			= THIS_MODULE,
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 44449389e527..f132ea850778 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 netfilter-objs := core.o nf_log.o nf_queue.o nf_sockopt.o utils.o
 
-nf_conntrack-y	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_expect.o nf_conntrack_helper.o nf_conntrack_proto.o nf_conntrack_l3proto_generic.o nf_conntrack_proto_generic.o nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o nf_conntrack_extend.o nf_conntrack_acct.o nf_conntrack_seqadj.o
+nf_conntrack-y	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_expect.o nf_conntrack_helper.o nf_conntrack_proto.o nf_conntrack_proto_generic.o nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o nf_conntrack_extend.o nf_conntrack_acct.o nf_conntrack_seqadj.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_TIMEOUT) += nf_conntrack_timeout.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_TIMESTAMP) += nf_conntrack_timestamp.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_EVENTS) += nf_conntrack_ecache.o
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 14c040805b32..0674c6e5bfed 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -37,7 +37,6 @@
 #include <linux/rculist_nulls.h>
 
 #include <net/netfilter/nf_conntrack.h>
-#include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_helper.h>
@@ -55,6 +54,7 @@
 #include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_nat_helper.h>
 #include <net/netns/hash.h>
+#include <net/ip.h>
 
 #include "nf_internals.h"
 
@@ -273,21 +273,94 @@ nf_ct_get_tuple(const struct sk_buff *skb,
 	return l4proto->pkt_to_tuple(skb, dataoff, net, tuple);
 }
 
+static int ipv4_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
+			    u_int8_t *protonum)
+{
+	int dataoff = -1;
+#if IS_ENABLED(CONFIG_NF_CONNTRACK_IPV4)
+	const struct iphdr *iph;
+	struct iphdr _iph;
+
+	iph = skb_header_pointer(skb, nhoff, sizeof(_iph), &_iph);
+	if (!iph)
+		return -1;
+
+	/* Conntrack defragments packets, we might still see fragments
+	 * inside ICMP packets though.
+	 */
+	if (iph->frag_off & htons(IP_OFFSET))
+		return -1;
+
+	dataoff = nhoff + (iph->ihl << 2);
+	*protonum = iph->protocol;
+
+	/* Check bogus IP headers */
+	if (dataoff > skb->len) {
+		pr_debug("bogus IPv4 packet: nhoff %u, ihl %u, skblen %u\n",
+			 nhoff, iph->ihl << 2, skb->len);
+		return -1;
+	}
+#endif
+	return dataoff;
+}
+
+static int ipv6_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
+			    u8 *protonum)
+{
+	int protoff = -1;
+#if IS_ENABLED(CONFIG_NF_CONNTRACK_IPV6)
+	unsigned int extoff = nhoff + sizeof(struct ipv6hdr);
+	__be16 frag_off;
+	u8 nexthdr;
+
+	if (skb_copy_bits(skb, nhoff + offsetof(struct ipv6hdr, nexthdr),
+			  &nexthdr, sizeof(nexthdr)) != 0) {
+		pr_debug("can't get nexthdr\n");
+		return -1;
+	}
+	protoff = ipv6_skip_exthdr(skb, extoff, &nexthdr, &frag_off);
+	/*
+	 * (protoff == skb->len) means the packet has not data, just
+	 * IPv6 and possibly extensions headers, but it is tracked anyway
+	 */
+	if (protoff < 0 || (frag_off & htons(~0x7)) != 0) {
+		pr_debug("can't find proto in pkt\n");
+		return -1;
+	}
+
+	*protonum = nexthdr;
+#endif
+	return protoff;
+}
+
+static int get_l4proto(const struct sk_buff *skb,
+		       unsigned int nhoff, u8 pf, u8 *l4num)
+{
+	switch (pf) {
+	case NFPROTO_IPV4:
+		return ipv4_get_l4proto(skb, nhoff, l4num);
+	case NFPROTO_IPV6:
+		return ipv6_get_l4proto(skb, nhoff, l4num);
+	default:
+		*l4num = 0;
+		break;
+	}
+	return -1;
+}
+
 bool nf_ct_get_tuplepr(const struct sk_buff *skb, unsigned int nhoff,
 		       u_int16_t l3num,
 		       struct net *net, struct nf_conntrack_tuple *tuple)
 {
-	const struct nf_conntrack_l3proto *l3proto;
 	const struct nf_conntrack_l4proto *l4proto;
-	unsigned int protoff;
-	u_int8_t protonum;
+	u8 protonum;
+	int protoff;
 	int ret;
 
 	rcu_read_lock();
 
-	l3proto = __nf_ct_l3proto_find(l3num);
-	ret = l3proto->get_l4proto(skb, nhoff, &protoff, &protonum);
-	if (ret != NF_ACCEPT) {
+	protoff = get_l4proto(skb, nhoff, l3num, &protonum);
+	if (protoff <= 0) {
 		rcu_read_unlock();
 		return false;
 	}
@@ -1397,14 +1470,12 @@ unsigned int
 nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
 		struct sk_buff *skb)
 {
-	const struct nf_conntrack_l3proto *l3proto;
 	const struct nf_conntrack_l4proto *l4proto;
 	struct nf_conn *ct, *tmpl;
 	enum ip_conntrack_info ctinfo;
 	unsigned int *timeouts;
-	unsigned int dataoff;
 	u_int8_t protonum;
-	int ret;
+	int dataoff, ret;
 
 	tmpl = nf_ct_get(skb, &ctinfo);
 	if (tmpl || ctinfo == IP_CT_UNTRACKED) {
@@ -1418,14 +1489,12 @@ nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
 	}
 
 	/* rcu_read_lock()ed by nf_hook_thresh */
-	l3proto = __nf_ct_l3proto_find(pf);
-	ret = l3proto->get_l4proto(skb, skb_network_offset(skb),
-				   &dataoff, &protonum);
-	if (ret <= 0) {
+	dataoff = get_l4proto(skb, skb_network_offset(skb), pf, &protonum);
+	if (dataoff <= 0) {
 		pr_debug("not prepared to track yet or error occurred\n");
 		NF_CT_STAT_INC_ATOMIC(net, error);
 		NF_CT_STAT_INC_ATOMIC(net, invalid);
-		ret = -ret;
+		ret = NF_ACCEPT;
 		goto out;
 	}
 
@@ -1641,14 +1710,14 @@ static void nf_conntrack_attach(struct sk_buff *nskb, const struct sk_buff *skb)
 
 static int nf_conntrack_update(struct net *net, struct sk_buff *skb)
 {
-	const struct nf_conntrack_l3proto *l3proto;
 	const struct nf_conntrack_l4proto *l4proto;
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_tuple tuple;
 	enum ip_conntrack_info ctinfo;
 	struct nf_nat_hook *nat_hook;
-	unsigned int dataoff, status;
+	unsigned int status;
 	struct nf_conn *ct;
+	int dataoff;
 	u16 l3num;
 	u8 l4num;
 
@@ -1657,10 +1726,9 @@ static int nf_conntrack_update(struct net *net, struct sk_buff *skb)
 		return 0;
 
 	l3num = nf_ct_l3num(ct);
-	l3proto = nf_ct_l3proto_find_get(l3num);
 
-	if (l3proto->get_l4proto(skb, skb_network_offset(skb), &dataoff,
-				 &l4num) <= 0)
+	dataoff = get_l4proto(skb, skb_network_offset(skb), l3num, &l4num);
+	if (dataoff <= 0)
 		return -1;
 
 	l4proto = nf_ct_l4proto_find_get(l3num, l4num);
diff --git a/net/netfilter/nf_conntrack_l3proto_generic.c b/net/netfilter/nf_conntrack_l3proto_generic.c
deleted file mode 100644
index d6a8fe591ccc..000000000000
--- a/net/netfilter/nf_conntrack_l3proto_generic.c
+++ /dev/null
@@ -1,46 +0,0 @@
-/*
- * (C) 2003,2004 USAGI/WIDE Project <http://www.linux-ipv6.org>
- *
- * Based largely upon the original ip_conntrack code which
- * had the following copyright information:
- *
- * (C) 1999-2001 Paul `Rusty' Russell
- * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * Author:
- *	Yasuyuki Kozakai @USAGI	<yasuyuki.kozakai@toshiba.co.jp>
- */
-
-#include <linux/types.h>
-#include <linux/ip.h>
-#include <linux/netfilter.h>
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/icmp.h>
-#include <linux/sysctl.h>
-#include <net/ip.h>
-
-#include <linux/netfilter_ipv4.h>
-#include <net/netfilter/nf_conntrack.h>
-#include <net/netfilter/nf_conntrack_l4proto.h>
-#include <net/netfilter/nf_conntrack_l3proto.h>
-#include <net/netfilter/nf_conntrack_core.h>
-#include <net/netfilter/ipv4/nf_conntrack_ipv4.h>
-
-static int generic_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
-			       unsigned int *dataoff, u_int8_t *protonum)
-{
-	/* Never track !!! */
-	return -NF_ACCEPT;
-}
-
-
-struct nf_conntrack_l3proto nf_conntrack_l3proto_generic __read_mostly = {
-	.l3proto	 = PF_UNSPEC,
-	.get_l4proto	 = generic_get_l4proto,
-};
-EXPORT_SYMBOL_GPL(nf_conntrack_l3proto_generic);
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 859cb303bb91..39df72bb9d56 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -35,6 +35,11 @@ EXPORT_SYMBOL_GPL(nf_ct_l3protos);
 
 static DEFINE_MUTEX(nf_ct_proto_mutex);
 
+struct nf_conntrack_l3proto nf_conntrack_l3proto_generic __read_mostly = {
+	.l3proto	 = PF_UNSPEC,
+};
+EXPORT_SYMBOL_GPL(nf_conntrack_l3proto_generic);
+
 #ifdef CONFIG_SYSCTL
 static int
 nf_ct_register_sysctl(struct net *net,
-- 
2.11.0
