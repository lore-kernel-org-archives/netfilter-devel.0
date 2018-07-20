From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 15/38] netfilter: conntrack: remove l3proto abstraction
Date: Fri, 20 Jul 2018 15:08:43 +0200
Message-ID: <20180720130906.27687-16-pablo@netfilter.org>
References: <20180720130906.27687-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180720130906.27687-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This unifies ipv4 and ipv6 protocol trackers and removes the l3proto
abstraction.

This gets rid of all l3proto indirect calls and the need to do
a lookup on the function to call for l3 demux.

It increases module size by only a small amount (12kbyte), so this reduces
size because nf_conntrack.ko is useless without either nf_conntrack_ipv4
or nf_conntrack_ipv6 module.

before:
   text    data     bss     dec     hex filename
   7357    1088       0    8445    20fd nf_conntrack_ipv4.ko
   7405    1084       4    8493    212d nf_conntrack_ipv6.ko
  72614   13689     236   86539   1520b nf_conntrack.ko
 19K nf_conntrack_ipv4.ko
 19K nf_conntrack_ipv6.ko
179K nf_conntrack.ko

after:
   text    data     bss     dec     hex filename
  79277   13937     236   93450   16d0a nf_conntrack.ko
  191K nf_conntrack.ko

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/ipv4/nf_conntrack_ipv4.h     |   3 -
 include/net/netfilter/nf_conntrack.h               |   5 +
 include/net/netfilter/nf_conntrack_core.h          |   1 -
 include/net/netfilter/nf_conntrack_l3proto.h       |  54 --
 include/net/netfilter/nf_conntrack_l4proto.h       |   4 -
 net/ipv4/netfilter/Kconfig                         |  22 +-
 net/ipv4/netfilter/Makefile                        |   6 -
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c     | 368 ---------
 net/ipv6/netfilter/Kconfig                         |  27 +-
 net/ipv6/netfilter/Makefile                        |   6 -
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c     | 355 ---------
 net/netfilter/Kconfig                              |   2 +
 net/netfilter/Makefile                             |   7 +-
 net/netfilter/nf_conntrack_core.c                  |  11 +-
 net/netfilter/nf_conntrack_proto.c                 | 847 +++++++++++++++------
 net/{ipv4 => }/netfilter/nf_conntrack_proto_icmp.c |   0
 .../netfilter/nf_conntrack_proto_icmpv6.c          |   0
 net/netfilter/nf_conntrack_standalone.c            |  14 +-
 net/netfilter/nf_nat_core.c                        |   8 -
 19 files changed, 645 insertions(+), 1095 deletions(-)
 delete mode 100644 include/net/netfilter/nf_conntrack_l3proto.h
 delete mode 100644 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
 delete mode 100644 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
 rename net/{ipv4 => }/netfilter/nf_conntrack_proto_icmp.c (100%)
 rename net/{ipv6 => }/netfilter/nf_conntrack_proto_icmpv6.c (100%)

diff --git a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
index 73f825732326..c84b51682f08 100644
--- a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
+++ b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
@@ -10,9 +10,6 @@
 #ifndef _NF_CONNTRACK_IPV4_H
 #define _NF_CONNTRACK_IPV4_H
 
-
-const extern struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4;
-
 extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4;
 extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4;
 extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp;
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 062dc19b5840..a2b0ed025908 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -41,6 +41,11 @@ union nf_conntrack_expect_proto {
 	/* insert expect proto private data here */
 };
 
+struct nf_conntrack_net {
+	unsigned int users4;
+	unsigned int users6;
+};
+
 #include <linux/types.h>
 #include <linux/skbuff.h>
 
diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 35461b2d3462..2a3e0974a6af 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -14,7 +14,6 @@
 #define _NF_CONNTRACK_CORE_H
 
 #include <linux/netfilter.h>
-#include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
 
diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
deleted file mode 100644
index 5f160375c93a..000000000000
--- a/include/net/netfilter/nf_conntrack_l3proto.h
+++ /dev/null
@@ -1,54 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * Copyright (C)2003,2004 USAGI/WIDE Project
- *
- * Header for use in defining a given L3 protocol for connection tracking.
- *
- * Author:
- *	Yasuyuki Kozakai @USAGI	<yasuyuki.kozakai@toshiba.co.jp>
- *
- * Derived from include/netfilter_ipv4/ip_conntrack_protocol.h
- */
-
-#ifndef _NF_CONNTRACK_L3PROTO_H
-#define _NF_CONNTRACK_L3PROTO_H
-#include <linux/netlink.h>
-#include <net/netlink.h>
-#include <linux/seq_file.h>
-#include <net/netfilter/nf_conntrack.h>
-
-struct nf_conntrack_l3proto {
-	/* L3 Protocol Family number. ex) PF_INET */
-	u_int16_t l3proto;
-
-	/* size of tuple nlattr, fills a hole */
-	u16 nla_size;
-
-	/* Called when netns wants to use connection tracking */
-	int (*net_ns_get)(struct net *);
-	void (*net_ns_put)(struct net *);
-
-	/* Module (if any) which this is connected to. */
-	struct module *me;
-};
-
-extern struct nf_conntrack_l3proto __rcu *nf_ct_l3protos[NFPROTO_NUMPROTO];
-
-/* Protocol global registration. */
-int nf_ct_l3proto_register(const struct nf_conntrack_l3proto *proto);
-void nf_ct_l3proto_unregister(const struct nf_conntrack_l3proto *proto);
-
-const struct nf_conntrack_l3proto *nf_ct_l3proto_find_get(u_int16_t l3proto);
-
-/* Existing built-in protocols */
-extern struct nf_conntrack_l3proto nf_conntrack_l3proto_generic;
-
-static inline struct nf_conntrack_l3proto *
-__nf_ct_l3proto_find(u_int16_t l3proto)
-{
-	if (unlikely(l3proto >= NFPROTO_NUMPROTO))
-		return &nf_conntrack_l3proto_generic;
-	return rcu_dereference(nf_ct_l3protos[l3proto]);
-}
-
-#endif /*_NF_CONNTRACK_L3PROTO_H*/
diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index c7a0075d96df..6068c6da3eac 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -130,10 +130,6 @@ void nf_ct_l4proto_pernet_unregister(struct net *net,
 /* Protocol global registration. */
 int nf_ct_l4proto_register_one(const struct nf_conntrack_l4proto *proto);
 void nf_ct_l4proto_unregister_one(const struct nf_conntrack_l4proto *proto);
-int nf_ct_l4proto_register(const struct nf_conntrack_l4proto * const proto[],
-			   unsigned int num_proto);
-void nf_ct_l4proto_unregister(const struct nf_conntrack_l4proto * const proto[],
-			      unsigned int num_proto);
 
 /* Generic netlink helpers */
 int nf_ct_port_tuple_to_nlattr(struct sk_buff *skb,
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index bbfc356cb1b5..d9504adc47b3 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -9,22 +9,6 @@ config NF_DEFRAG_IPV4
 	tristate
 	default n
 
-config NF_CONNTRACK_IPV4
-	tristate "IPv4 connection tracking support (required for NAT)"
-	depends on NF_CONNTRACK
-	default m if NETFILTER_ADVANCED=n
-	select NF_DEFRAG_IPV4
-	---help---
-	  Connection tracking keeps a record of what packets have passed
-	  through your machine, in order to figure out how they are related
-	  into connections.
-
-	  This is IPv4 support on Layer 3 independent connection tracking.
-	  Layer 3 independent connection tracking is experimental scheme
-	  which generalize ip_conntrack to support other layer 3 protocols.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config NF_SOCKET_IPV4
 	tristate "IPv4 socket lookup support"
 	help
@@ -112,7 +96,7 @@ config NF_REJECT_IPV4
 
 config NF_NAT_IPV4
 	tristate "IPv4 NAT"
-	depends on NF_CONNTRACK_IPV4
+	depends on NF_CONNTRACK
 	default m if NETFILTER_ADVANCED=n
 	select NF_NAT
 	help
@@ -279,7 +263,7 @@ config IP_NF_TARGET_SYNPROXY
 # NAT + specific targets: nf_conntrack
 config IP_NF_NAT
 	tristate "iptables NAT support"
-	depends on NF_CONNTRACK_IPV4
+	depends on NF_CONNTRACK
 	default m if NETFILTER_ADVANCED=n
 	select NF_NAT
 	select NF_NAT_IPV4
@@ -340,7 +324,7 @@ config IP_NF_MANGLE
 config IP_NF_TARGET_CLUSTERIP
 	tristate "CLUSTERIP target support"
 	depends on IP_NF_MANGLE
-	depends on NF_CONNTRACK_IPV4
+	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
 	select NF_CONNTRACK_MARK
 	select NETFILTER_FAMILY_ARP
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 8394c17c269f..367993adf4d3 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -3,12 +3,6 @@
 # Makefile for the netfilter modules on top of IPv4.
 #
 
-# objects for l3 independent conntrack
-nf_conntrack_ipv4-y	:=  nf_conntrack_l3proto_ipv4.o nf_conntrack_proto_icmp.o
-
-# connection tracking
-obj-$(CONFIG_NF_CONNTRACK_IPV4) += nf_conntrack_ipv4.o
-
 nf_nat_ipv4-y		:= nf_nat_l3proto_ipv4.o nf_nat_proto_icmp.o
 nf_nat_ipv4-$(CONFIG_NF_NAT_MASQUERADE_IPV4) += nf_nat_masquerade_ipv4.o
 obj-$(CONFIG_NF_NAT_IPV4) += nf_nat_ipv4.o
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
deleted file mode 100644
index 9fbf6c7f8ece..000000000000
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ /dev/null
@@ -1,368 +0,0 @@
-
-/* (C) 1999-2001 Paul `Rusty' Russell
- * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
- * (C) 2006-2012 Patrick McHardy <kaber@trash.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/types.h>
-#include <linux/ip.h>
-#include <linux/netfilter.h>
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/icmp.h>
-#include <linux/sysctl.h>
-#include <net/route.h>
-#include <net/ip.h>
-
-#include <linux/netfilter_ipv4.h>
-#include <net/netfilter/nf_conntrack.h>
-#include <net/netfilter/nf_conntrack_helper.h>
-#include <net/netfilter/nf_conntrack_l4proto.h>
-#include <net/netfilter/nf_conntrack_l3proto.h>
-#include <net/netfilter/nf_conntrack_zones.h>
-#include <net/netfilter/nf_conntrack_core.h>
-#include <net/netfilter/nf_conntrack_seqadj.h>
-#include <net/netfilter/ipv4/nf_conntrack_ipv4.h>
-#include <net/netfilter/nf_nat_helper.h>
-#include <net/netfilter/ipv4/nf_defrag_ipv4.h>
-#include <net/netfilter/nf_log.h>
-
-static int conntrack4_net_id __read_mostly;
-static DEFINE_MUTEX(register_ipv4_hooks);
-
-struct conntrack4_net {
-	unsigned int users;
-};
-
-static unsigned int ipv4_helper(void *priv,
-				struct sk_buff *skb,
-				const struct nf_hook_state *state)
-{
-	struct nf_conn *ct;
-	enum ip_conntrack_info ctinfo;
-	const struct nf_conn_help *help;
-	const struct nf_conntrack_helper *helper;
-
-	/* This is where we call the helper: as the packet goes out. */
-	ct = nf_ct_get(skb, &ctinfo);
-	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
-		return NF_ACCEPT;
-
-	help = nfct_help(ct);
-	if (!help)
-		return NF_ACCEPT;
-
-	/* rcu_read_lock()ed by nf_hook_thresh */
-	helper = rcu_dereference(help->helper);
-	if (!helper)
-		return NF_ACCEPT;
-
-	return helper->help(skb, skb_network_offset(skb) + ip_hdrlen(skb),
-			    ct, ctinfo);
-}
-
-static unsigned int ipv4_confirm(void *priv,
-				 struct sk_buff *skb,
-				 const struct nf_hook_state *state)
-{
-	struct nf_conn *ct;
-	enum ip_conntrack_info ctinfo;
-
-	ct = nf_ct_get(skb, &ctinfo);
-	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
-		goto out;
-
-	/* adjust seqs for loopback traffic only in outgoing direction */
-	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
-	    !nf_is_loopback_packet(skb)) {
-		if (!nf_ct_seq_adjust(skb, ct, ctinfo, ip_hdrlen(skb))) {
-			NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), drop);
-			return NF_DROP;
-		}
-	}
-out:
-	/* We've seen it coming out the other side: confirm it */
-	return nf_conntrack_confirm(skb);
-}
-
-static unsigned int ipv4_conntrack_in(void *priv,
-				      struct sk_buff *skb,
-				      const struct nf_hook_state *state)
-{
-	return nf_conntrack_in(state->net, PF_INET, state->hook, skb);
-}
-
-static unsigned int ipv4_conntrack_local(void *priv,
-					 struct sk_buff *skb,
-					 const struct nf_hook_state *state)
-{
-	if (ip_is_fragment(ip_hdr(skb))) { /* IP_NODEFRAG setsockopt set */
-		enum ip_conntrack_info ctinfo;
-		struct nf_conn *tmpl;
-
-		tmpl = nf_ct_get(skb, &ctinfo);
-		if (tmpl && nf_ct_is_template(tmpl)) {
-			/* when skipping ct, clear templates to avoid fooling
-			 * later targets/matches
-			 */
-			skb->_nfct = 0;
-			nf_ct_put(tmpl);
-		}
-		return NF_ACCEPT;
-	}
-
-	return nf_conntrack_in(state->net, PF_INET, state->hook, skb);
-}
-
-/* Connection tracking may drop packets, but never alters them, so
-   make it the first hook. */
-static const struct nf_hook_ops ipv4_conntrack_ops[] = {
-	{
-		.hook		= ipv4_conntrack_in,
-		.pf		= NFPROTO_IPV4,
-		.hooknum	= NF_INET_PRE_ROUTING,
-		.priority	= NF_IP_PRI_CONNTRACK,
-	},
-	{
-		.hook		= ipv4_conntrack_local,
-		.pf		= NFPROTO_IPV4,
-		.hooknum	= NF_INET_LOCAL_OUT,
-		.priority	= NF_IP_PRI_CONNTRACK,
-	},
-	{
-		.hook		= ipv4_helper,
-		.pf		= NFPROTO_IPV4,
-		.hooknum	= NF_INET_POST_ROUTING,
-		.priority	= NF_IP_PRI_CONNTRACK_HELPER,
-	},
-	{
-		.hook		= ipv4_confirm,
-		.pf		= NFPROTO_IPV4,
-		.hooknum	= NF_INET_POST_ROUTING,
-		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
-	},
-	{
-		.hook		= ipv4_helper,
-		.pf		= NFPROTO_IPV4,
-		.hooknum	= NF_INET_LOCAL_IN,
-		.priority	= NF_IP_PRI_CONNTRACK_HELPER,
-	},
-	{
-		.hook		= ipv4_confirm,
-		.pf		= NFPROTO_IPV4,
-		.hooknum	= NF_INET_LOCAL_IN,
-		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
-	},
-};
-
-/* Fast function for those who don't want to parse /proc (and I don't
-   blame them). */
-/* Reversing the socket's dst/src point of view gives us the reply
-   mapping. */
-static int
-getorigdst(struct sock *sk, int optval, void __user *user, int *len)
-{
-	const struct inet_sock *inet = inet_sk(sk);
-	const struct nf_conntrack_tuple_hash *h;
-	struct nf_conntrack_tuple tuple;
-
-	memset(&tuple, 0, sizeof(tuple));
-
-	lock_sock(sk);
-	tuple.src.u3.ip = inet->inet_rcv_saddr;
-	tuple.src.u.tcp.port = inet->inet_sport;
-	tuple.dst.u3.ip = inet->inet_daddr;
-	tuple.dst.u.tcp.port = inet->inet_dport;
-	tuple.src.l3num = PF_INET;
-	tuple.dst.protonum = sk->sk_protocol;
-	release_sock(sk);
-
-	/* We only do TCP and SCTP at the moment: is there a better way? */
-	if (tuple.dst.protonum != IPPROTO_TCP &&
-	    tuple.dst.protonum != IPPROTO_SCTP) {
-		pr_debug("SO_ORIGINAL_DST: Not a TCP/SCTP socket\n");
-		return -ENOPROTOOPT;
-	}
-
-	if ((unsigned int) *len < sizeof(struct sockaddr_in)) {
-		pr_debug("SO_ORIGINAL_DST: len %d not %zu\n",
-			 *len, sizeof(struct sockaddr_in));
-		return -EINVAL;
-	}
-
-	h = nf_conntrack_find_get(sock_net(sk), &nf_ct_zone_dflt, &tuple);
-	if (h) {
-		struct sockaddr_in sin;
-		struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
-
-		sin.sin_family = AF_INET;
-		sin.sin_port = ct->tuplehash[IP_CT_DIR_ORIGINAL]
-			.tuple.dst.u.tcp.port;
-		sin.sin_addr.s_addr = ct->tuplehash[IP_CT_DIR_ORIGINAL]
-			.tuple.dst.u3.ip;
-		memset(sin.sin_zero, 0, sizeof(sin.sin_zero));
-
-		pr_debug("SO_ORIGINAL_DST: %pI4 %u\n",
-			 &sin.sin_addr.s_addr, ntohs(sin.sin_port));
-		nf_ct_put(ct);
-		if (copy_to_user(user, &sin, sizeof(sin)) != 0)
-			return -EFAULT;
-		else
-			return 0;
-	}
-	pr_debug("SO_ORIGINAL_DST: Can't find %pI4/%u-%pI4/%u.\n",
-		 &tuple.src.u3.ip, ntohs(tuple.src.u.tcp.port),
-		 &tuple.dst.u3.ip, ntohs(tuple.dst.u.tcp.port));
-	return -ENOENT;
-}
-
-static struct nf_sockopt_ops so_getorigdst = {
-	.pf		= PF_INET,
-	.get_optmin	= SO_ORIGINAL_DST,
-	.get_optmax	= SO_ORIGINAL_DST+1,
-	.get		= getorigdst,
-	.owner		= THIS_MODULE,
-};
-
-static int ipv4_hooks_register(struct net *net)
-{
-	struct conntrack4_net *cnet = net_generic(net, conntrack4_net_id);
-	int err = 0;
-
-	mutex_lock(&register_ipv4_hooks);
-
-	cnet->users++;
-	if (cnet->users > 1)
-		goto out_unlock;
-
-	err = nf_defrag_ipv4_enable(net);
-	if (err) {
-		cnet->users = 0;
-		goto out_unlock;
-	}
-
-	err = nf_register_net_hooks(net, ipv4_conntrack_ops,
-				    ARRAY_SIZE(ipv4_conntrack_ops));
-
-	if (err)
-		cnet->users = 0;
- out_unlock:
-	mutex_unlock(&register_ipv4_hooks);
-	return err;
-}
-
-static void ipv4_hooks_unregister(struct net *net)
-{
-	struct conntrack4_net *cnet = net_generic(net, conntrack4_net_id);
-
-	mutex_lock(&register_ipv4_hooks);
-	if (cnet->users && (--cnet->users == 0))
-		nf_unregister_net_hooks(net, ipv4_conntrack_ops,
-					ARRAY_SIZE(ipv4_conntrack_ops));
-	mutex_unlock(&register_ipv4_hooks);
-}
-
-const struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4 = {
-	.l3proto	 = PF_INET,
-	.net_ns_get	 = ipv4_hooks_register,
-	.net_ns_put	 = ipv4_hooks_unregister,
-	.me		 = THIS_MODULE,
-};
-
-module_param_call(hashsize, nf_conntrack_set_hashsize, param_get_uint,
-		  &nf_conntrack_htable_size, 0600);
-
-MODULE_ALIAS("nf_conntrack-" __stringify(AF_INET));
-MODULE_ALIAS("ip_conntrack");
-MODULE_LICENSE("GPL");
-
-static const struct nf_conntrack_l4proto * const builtin_l4proto4[] = {
-	&nf_conntrack_l4proto_tcp4,
-	&nf_conntrack_l4proto_udp4,
-	&nf_conntrack_l4proto_icmp,
-#ifdef CONFIG_NF_CT_PROTO_DCCP
-	&nf_conntrack_l4proto_dccp4,
-#endif
-#ifdef CONFIG_NF_CT_PROTO_SCTP
-	&nf_conntrack_l4proto_sctp4,
-#endif
-#ifdef CONFIG_NF_CT_PROTO_UDPLITE
-	&nf_conntrack_l4proto_udplite4,
-#endif
-};
-
-static int ipv4_net_init(struct net *net)
-{
-	return nf_ct_l4proto_pernet_register(net, builtin_l4proto4,
-					     ARRAY_SIZE(builtin_l4proto4));
-}
-
-static void ipv4_net_exit(struct net *net)
-{
-	nf_ct_l4proto_pernet_unregister(net, builtin_l4proto4,
-					ARRAY_SIZE(builtin_l4proto4));
-}
-
-static struct pernet_operations ipv4_net_ops = {
-	.init = ipv4_net_init,
-	.exit = ipv4_net_exit,
-	.id = &conntrack4_net_id,
-	.size = sizeof(struct conntrack4_net),
-};
-
-static int __init nf_conntrack_l3proto_ipv4_init(void)
-{
-	int ret = 0;
-
-	need_conntrack();
-
-	ret = nf_register_sockopt(&so_getorigdst);
-	if (ret < 0) {
-		pr_err("Unable to register netfilter socket option\n");
-		return ret;
-	}
-
-	ret = register_pernet_subsys(&ipv4_net_ops);
-	if (ret < 0) {
-		pr_err("nf_conntrack_ipv4: can't register pernet ops\n");
-		goto cleanup_sockopt;
-	}
-
-	ret = nf_ct_l4proto_register(builtin_l4proto4,
-				     ARRAY_SIZE(builtin_l4proto4));
-	if (ret < 0)
-		goto cleanup_pernet;
-
-	ret = nf_ct_l3proto_register(&nf_conntrack_l3proto_ipv4);
-	if (ret < 0) {
-		pr_err("nf_conntrack_ipv4: can't register ipv4 proto.\n");
-		goto cleanup_l4proto;
-	}
-
-	return ret;
-cleanup_l4proto:
-	nf_ct_l4proto_unregister(builtin_l4proto4,
-				 ARRAY_SIZE(builtin_l4proto4));
- cleanup_pernet:
-	unregister_pernet_subsys(&ipv4_net_ops);
- cleanup_sockopt:
-	nf_unregister_sockopt(&so_getorigdst);
-	return ret;
-}
-
-static void __exit nf_conntrack_l3proto_ipv4_fini(void)
-{
-	synchronize_net();
-	nf_ct_l3proto_unregister(&nf_conntrack_l3proto_ipv4);
-	nf_ct_l4proto_unregister(builtin_l4proto4,
-				 ARRAY_SIZE(builtin_l4proto4));
-	unregister_pernet_subsys(&ipv4_net_ops);
-	nf_unregister_sockopt(&so_getorigdst);
-}
-
-module_init(nf_conntrack_l3proto_ipv4_init);
-module_exit(nf_conntrack_l3proto_ipv4_fini);
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 37b14dc9d863..339d0762b027 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -5,26 +5,6 @@
 menu "IPv6: Netfilter Configuration"
 	depends on INET && IPV6 && NETFILTER
 
-config NF_DEFRAG_IPV6
-	tristate
-	default n
-
-config NF_CONNTRACK_IPV6
-	tristate "IPv6 connection tracking support"
-	depends on INET && IPV6 && NF_CONNTRACK
-	default m if NETFILTER_ADVANCED=n
-	select NF_DEFRAG_IPV6
-	---help---
-	  Connection tracking keeps a record of what packets have passed
-	  through your machine, in order to figure out how they are related
-	  into connections.
-
-	  This is IPv6 support on Layer 3 independent connection tracking.
-	  Layer 3 independent connection tracking is experimental scheme
-	  which generalize ip_conntrack to support other layer 3 protocols.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config NF_SOCKET_IPV6
 	tristate "IPv6 socket lookup support"
 	help
@@ -128,7 +108,7 @@ config NF_LOG_IPV6
 
 config NF_NAT_IPV6
 	tristate "IPv6 NAT"
-	depends on NF_CONNTRACK_IPV6
+	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
 	select NF_NAT
 	help
@@ -328,7 +308,7 @@ config IP6_NF_SECURITY
 
 config IP6_NF_NAT
 	tristate "ip6tables NAT support"
-	depends on NF_CONNTRACK_IPV6
+	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
 	select NF_NAT
 	select NF_NAT_IPV6
@@ -365,6 +345,7 @@ config IP6_NF_TARGET_NPT
 endif # IP6_NF_NAT
 
 endif # IP6_NF_IPTABLES
-
 endmenu
 
+config NF_DEFRAG_IPV6
+	tristate
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index 10a5a1c87320..200c0c235565 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -11,12 +11,6 @@ obj-$(CONFIG_IP6_NF_RAW) += ip6table_raw.o
 obj-$(CONFIG_IP6_NF_SECURITY) += ip6table_security.o
 obj-$(CONFIG_IP6_NF_NAT) += ip6table_nat.o
 
-# objects for l3 independent conntrack
-nf_conntrack_ipv6-y  :=  nf_conntrack_l3proto_ipv6.o nf_conntrack_proto_icmpv6.o
-
-# l3 independent conntrack
-obj-$(CONFIG_NF_CONNTRACK_IPV6) += nf_conntrack_ipv6.o
-
 nf_nat_ipv6-y		:= nf_nat_l3proto_ipv6.o nf_nat_proto_icmpv6.o
 nf_nat_ipv6-$(CONFIG_NF_NAT_MASQUERADE_IPV6) += nf_nat_masquerade_ipv6.o
 obj-$(CONFIG_NF_NAT_IPV6) += nf_nat_ipv6.o
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
deleted file mode 100644
index 37ab25645cf2..000000000000
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ /dev/null
@@ -1,355 +0,0 @@
-/*
- * Copyright (C)2004 USAGI/WIDE Project
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * Author:
- *	Yasuyuki Kozakai @USAGI <yasuyuki.kozakai@toshiba.co.jp>
- */
-
-#include <linux/types.h>
-#include <linux/ipv6.h>
-#include <linux/in6.h>
-#include <linux/netfilter.h>
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/icmp.h>
-#include <net/ipv6.h>
-#include <net/inet_frag.h>
-
-#include <linux/netfilter_bridge.h>
-#include <linux/netfilter_ipv6.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
-#include <net/netfilter/nf_conntrack.h>
-#include <net/netfilter/nf_conntrack_helper.h>
-#include <net/netfilter/nf_conntrack_l4proto.h>
-#include <net/netfilter/nf_conntrack_l3proto.h>
-#include <net/netfilter/nf_conntrack_core.h>
-#include <net/netfilter/nf_conntrack_zones.h>
-#include <net/netfilter/nf_conntrack_seqadj.h>
-#include <net/netfilter/ipv6/nf_conntrack_ipv6.h>
-#include <net/netfilter/nf_nat_helper.h>
-#include <net/netfilter/ipv6/nf_defrag_ipv6.h>
-#include <net/netfilter/nf_log.h>
-
-static int conntrack6_net_id;
-static DEFINE_MUTEX(register_ipv6_hooks);
-
-struct conntrack6_net {
-	unsigned int users;
-};
-
-static unsigned int ipv6_helper(void *priv,
-				struct sk_buff *skb,
-				const struct nf_hook_state *state)
-{
-	struct nf_conn *ct;
-	const struct nf_conn_help *help;
-	const struct nf_conntrack_helper *helper;
-	enum ip_conntrack_info ctinfo;
-	__be16 frag_off;
-	int protoff;
-	u8 nexthdr;
-
-	/* This is where we call the helper: as the packet goes out. */
-	ct = nf_ct_get(skb, &ctinfo);
-	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
-		return NF_ACCEPT;
-
-	help = nfct_help(ct);
-	if (!help)
-		return NF_ACCEPT;
-	/* rcu_read_lock()ed by nf_hook_thresh */
-	helper = rcu_dereference(help->helper);
-	if (!helper)
-		return NF_ACCEPT;
-
-	nexthdr = ipv6_hdr(skb)->nexthdr;
-	protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &nexthdr,
-				   &frag_off);
-	if (protoff < 0 || (frag_off & htons(~0x7)) != 0) {
-		pr_debug("proto header not found\n");
-		return NF_ACCEPT;
-	}
-
-	return helper->help(skb, protoff, ct, ctinfo);
-}
-
-static unsigned int ipv6_confirm(void *priv,
-				 struct sk_buff *skb,
-				 const struct nf_hook_state *state)
-{
-	struct nf_conn *ct;
-	enum ip_conntrack_info ctinfo;
-	unsigned char pnum = ipv6_hdr(skb)->nexthdr;
-	int protoff;
-	__be16 frag_off;
-
-	ct = nf_ct_get(skb, &ctinfo);
-	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
-		goto out;
-
-	protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &pnum,
-				   &frag_off);
-	if (protoff < 0 || (frag_off & htons(~0x7)) != 0) {
-		pr_debug("proto header not found\n");
-		goto out;
-	}
-
-	/* adjust seqs for loopback traffic only in outgoing direction */
-	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
-	    !nf_is_loopback_packet(skb)) {
-		if (!nf_ct_seq_adjust(skb, ct, ctinfo, protoff)) {
-			NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), drop);
-			return NF_DROP;
-		}
-	}
-out:
-	/* We've seen it coming out the other side: confirm it */
-	return nf_conntrack_confirm(skb);
-}
-
-static unsigned int ipv6_conntrack_in(void *priv,
-				      struct sk_buff *skb,
-				      const struct nf_hook_state *state)
-{
-	return nf_conntrack_in(state->net, PF_INET6, state->hook, skb);
-}
-
-static unsigned int ipv6_conntrack_local(void *priv,
-					 struct sk_buff *skb,
-					 const struct nf_hook_state *state)
-{
-	return nf_conntrack_in(state->net, PF_INET6, state->hook, skb);
-}
-
-static const struct nf_hook_ops ipv6_conntrack_ops[] = {
-	{
-		.hook		= ipv6_conntrack_in,
-		.pf		= NFPROTO_IPV6,
-		.hooknum	= NF_INET_PRE_ROUTING,
-		.priority	= NF_IP6_PRI_CONNTRACK,
-	},
-	{
-		.hook		= ipv6_conntrack_local,
-		.pf		= NFPROTO_IPV6,
-		.hooknum	= NF_INET_LOCAL_OUT,
-		.priority	= NF_IP6_PRI_CONNTRACK,
-	},
-	{
-		.hook		= ipv6_helper,
-		.pf		= NFPROTO_IPV6,
-		.hooknum	= NF_INET_POST_ROUTING,
-		.priority	= NF_IP6_PRI_CONNTRACK_HELPER,
-	},
-	{
-		.hook		= ipv6_confirm,
-		.pf		= NFPROTO_IPV6,
-		.hooknum	= NF_INET_POST_ROUTING,
-		.priority	= NF_IP6_PRI_LAST,
-	},
-	{
-		.hook		= ipv6_helper,
-		.pf		= NFPROTO_IPV6,
-		.hooknum	= NF_INET_LOCAL_IN,
-		.priority	= NF_IP6_PRI_CONNTRACK_HELPER,
-	},
-	{
-		.hook		= ipv6_confirm,
-		.pf		= NFPROTO_IPV6,
-		.hooknum	= NF_INET_LOCAL_IN,
-		.priority	= NF_IP6_PRI_LAST-1,
-	},
-};
-
-static int
-ipv6_getorigdst(struct sock *sk, int optval, void __user *user, int *len)
-{
-	struct nf_conntrack_tuple tuple = { .src.l3num = NFPROTO_IPV6 };
-	const struct ipv6_pinfo *inet6 = inet6_sk(sk);
-	const struct inet_sock *inet = inet_sk(sk);
-	const struct nf_conntrack_tuple_hash *h;
-	struct sockaddr_in6 sin6;
-	struct nf_conn *ct;
-	__be32 flow_label;
-	int bound_dev_if;
-
-	lock_sock(sk);
-	tuple.src.u3.in6 = sk->sk_v6_rcv_saddr;
-	tuple.src.u.tcp.port = inet->inet_sport;
-	tuple.dst.u3.in6 = sk->sk_v6_daddr;
-	tuple.dst.u.tcp.port = inet->inet_dport;
-	tuple.dst.protonum = sk->sk_protocol;
-	bound_dev_if = sk->sk_bound_dev_if;
-	flow_label = inet6->flow_label;
-	release_sock(sk);
-
-	if (tuple.dst.protonum != IPPROTO_TCP &&
-	    tuple.dst.protonum != IPPROTO_SCTP)
-		return -ENOPROTOOPT;
-
-	if (*len < 0 || (unsigned int) *len < sizeof(sin6))
-		return -EINVAL;
-
-	h = nf_conntrack_find_get(sock_net(sk), &nf_ct_zone_dflt, &tuple);
-	if (!h) {
-		pr_debug("IP6T_SO_ORIGINAL_DST: Can't find %pI6c/%u-%pI6c/%u.\n",
-			 &tuple.src.u3.ip6, ntohs(tuple.src.u.tcp.port),
-			 &tuple.dst.u3.ip6, ntohs(tuple.dst.u.tcp.port));
-		return -ENOENT;
-	}
-
-	ct = nf_ct_tuplehash_to_ctrack(h);
-
-	sin6.sin6_family = AF_INET6;
-	sin6.sin6_port = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u.tcp.port;
-	sin6.sin6_flowinfo = flow_label & IPV6_FLOWINFO_MASK;
-	memcpy(&sin6.sin6_addr,
-		&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u3.in6,
-					sizeof(sin6.sin6_addr));
-
-	nf_ct_put(ct);
-	sin6.sin6_scope_id = ipv6_iface_scope_id(&sin6.sin6_addr, bound_dev_if);
-	return copy_to_user(user, &sin6, sizeof(sin6)) ? -EFAULT : 0;
-}
-
-static int ipv6_hooks_register(struct net *net)
-{
-	struct conntrack6_net *cnet = net_generic(net, conntrack6_net_id);
-	int err = 0;
-
-	mutex_lock(&register_ipv6_hooks);
-	cnet->users++;
-	if (cnet->users > 1)
-		goto out_unlock;
-
-	err = nf_defrag_ipv6_enable(net);
-	if (err < 0) {
-		cnet->users = 0;
-		goto out_unlock;
-	}
-
-	err = nf_register_net_hooks(net, ipv6_conntrack_ops,
-				    ARRAY_SIZE(ipv6_conntrack_ops));
-	if (err)
-		cnet->users = 0;
- out_unlock:
-	mutex_unlock(&register_ipv6_hooks);
-	return err;
-}
-
-static void ipv6_hooks_unregister(struct net *net)
-{
-	struct conntrack6_net *cnet = net_generic(net, conntrack6_net_id);
-
-	mutex_lock(&register_ipv6_hooks);
-	if (cnet->users && (--cnet->users == 0))
-		nf_unregister_net_hooks(net, ipv6_conntrack_ops,
-					ARRAY_SIZE(ipv6_conntrack_ops));
-	mutex_unlock(&register_ipv6_hooks);
-}
-
-const struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv6 = {
-	.l3proto		= PF_INET6,
-	.net_ns_get		= ipv6_hooks_register,
-	.net_ns_put		= ipv6_hooks_unregister,
-	.me			= THIS_MODULE,
-};
-
-MODULE_ALIAS("nf_conntrack-" __stringify(AF_INET6));
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Yasuyuki KOZAKAI @USAGI <yasuyuki.kozakai@toshiba.co.jp>");
-
-static struct nf_sockopt_ops so_getorigdst6 = {
-	.pf		= NFPROTO_IPV6,
-	.get_optmin	= IP6T_SO_ORIGINAL_DST,
-	.get_optmax	= IP6T_SO_ORIGINAL_DST + 1,
-	.get		= ipv6_getorigdst,
-	.owner		= THIS_MODULE,
-};
-
-static const struct nf_conntrack_l4proto * const builtin_l4proto6[] = {
-	&nf_conntrack_l4proto_tcp6,
-	&nf_conntrack_l4proto_udp6,
-	&nf_conntrack_l4proto_icmpv6,
-#ifdef CONFIG_NF_CT_PROTO_DCCP
-	&nf_conntrack_l4proto_dccp6,
-#endif
-#ifdef CONFIG_NF_CT_PROTO_SCTP
-	&nf_conntrack_l4proto_sctp6,
-#endif
-#ifdef CONFIG_NF_CT_PROTO_UDPLITE
-	&nf_conntrack_l4proto_udplite6,
-#endif
-};
-
-static int ipv6_net_init(struct net *net)
-{
-	return nf_ct_l4proto_pernet_register(net, builtin_l4proto6,
-					     ARRAY_SIZE(builtin_l4proto6));
-}
-
-static void ipv6_net_exit(struct net *net)
-{
-	nf_ct_l4proto_pernet_unregister(net, builtin_l4proto6,
-					ARRAY_SIZE(builtin_l4proto6));
-}
-
-static struct pernet_operations ipv6_net_ops = {
-	.init = ipv6_net_init,
-	.exit = ipv6_net_exit,
-	.id = &conntrack6_net_id,
-	.size = sizeof(struct conntrack6_net),
-};
-
-static int __init nf_conntrack_l3proto_ipv6_init(void)
-{
-	int ret = 0;
-
-	need_conntrack();
-
-	ret = nf_register_sockopt(&so_getorigdst6);
-	if (ret < 0) {
-		pr_err("Unable to register netfilter socket option\n");
-		return ret;
-	}
-
-	ret = register_pernet_subsys(&ipv6_net_ops);
-	if (ret < 0)
-		goto cleanup_sockopt;
-
-	ret = nf_ct_l4proto_register(builtin_l4proto6,
-				     ARRAY_SIZE(builtin_l4proto6));
-	if (ret < 0)
-		goto cleanup_pernet;
-
-	ret = nf_ct_l3proto_register(&nf_conntrack_l3proto_ipv6);
-	if (ret < 0) {
-		pr_err("nf_conntrack_ipv6: can't register ipv6 proto.\n");
-		goto cleanup_l4proto;
-	}
-	return ret;
-cleanup_l4proto:
-	nf_ct_l4proto_unregister(builtin_l4proto6,
-				 ARRAY_SIZE(builtin_l4proto6));
- cleanup_pernet:
-	unregister_pernet_subsys(&ipv6_net_ops);
- cleanup_sockopt:
-	nf_unregister_sockopt(&so_getorigdst6);
-	return ret;
-}
-
-static void __exit nf_conntrack_l3proto_ipv6_fini(void)
-{
-	synchronize_net();
-	nf_ct_l3proto_unregister(&nf_conntrack_l3proto_ipv6);
-	nf_ct_l4proto_unregister(builtin_l4proto6,
-				 ARRAY_SIZE(builtin_l4proto6));
-	unregister_pernet_subsys(&ipv6_net_ops);
-	nf_unregister_sockopt(&so_getorigdst6);
-}
-
-module_init(nf_conntrack_l3proto_ipv6_init);
-module_exit(nf_conntrack_l3proto_ipv6_fini);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 3ce657fbca67..9eab519b403a 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -49,6 +49,8 @@ config NETFILTER_NETLINK_LOG
 config NF_CONNTRACK
 	tristate "Netfilter connection tracking support"
 	default m if NETFILTER_ADVANCED=n
+	select NF_DEFRAG_IPV4
+	select NF_DEFRAG_IPV6 if IPV6 != n
 	help
 	  Connection tracking keeps a record of what packets have passed
 	  through your machine, in order to figure out how they are related
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index f132ea850778..53bd1ed1228a 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -1,7 +1,12 @@
 # SPDX-License-Identifier: GPL-2.0
 netfilter-objs := core.o nf_log.o nf_queue.o nf_sockopt.o utils.o
 
-nf_conntrack-y	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_expect.o nf_conntrack_helper.o nf_conntrack_proto.o nf_conntrack_proto_generic.o nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o nf_conntrack_extend.o nf_conntrack_acct.o nf_conntrack_seqadj.o
+nf_conntrack-y	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_expect.o nf_conntrack_helper.o \
+		   nf_conntrack_proto.o nf_conntrack_proto_generic.o nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o \
+		   nf_conntrack_proto_icmp.o \
+		   nf_conntrack_extend.o nf_conntrack_acct.o nf_conntrack_seqadj.o
+
+nf_conntrack-$(subst m,y,$(CONFIG_IPV6)) += nf_conntrack_proto_icmpv6.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_TIMEOUT) += nf_conntrack_timeout.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_TIMESTAMP) += nf_conntrack_timestamp.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_EVENTS) += nf_conntrack_ecache.o
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index c069f2faff4c..5123e91b1982 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -291,7 +291,6 @@ static int ipv4_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
 			    u_int8_t *protonum)
 {
 	int dataoff = -1;
-#if IS_ENABLED(CONFIG_NF_CONNTRACK_IPV4)
 	const struct iphdr *iph;
 	struct iphdr _iph;
 
@@ -314,15 +313,14 @@ static int ipv4_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
 			 nhoff, iph->ihl << 2, skb->len);
 		return -1;
 	}
-#endif
 	return dataoff;
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
 static int ipv6_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
 			    u8 *protonum)
 {
 	int protoff = -1;
-#if IS_ENABLED(CONFIG_NF_CONNTRACK_IPV6)
 	unsigned int extoff = nhoff + sizeof(struct ipv6hdr);
 	__be16 frag_off;
 	u8 nexthdr;
@@ -343,9 +341,9 @@ static int ipv6_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
 	}
 
 	*protonum = nexthdr;
-#endif
 	return protoff;
 }
+#endif
 
 static int get_l4proto(const struct sk_buff *skb,
 		       unsigned int nhoff, u8 pf, u8 *l4num)
@@ -353,8 +351,10 @@ static int get_l4proto(const struct sk_buff *skb,
 	switch (pf) {
 	case NFPROTO_IPV4:
 		return ipv4_get_l4proto(skb, nhoff, l4num);
+#if IS_ENABLED(CONFIG_IPV6)
 	case NFPROTO_IPV6:
 		return ipv6_get_l4proto(skb, nhoff, l4num);
+#endif
 	default:
 		*l4num = 0;
 		break;
@@ -2197,9 +2197,6 @@ int nf_conntrack_set_hashsize(const char *val, const struct kernel_param *kp)
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_set_hashsize);
 
-module_param_call(hashsize, nf_conntrack_set_hashsize, param_get_uint,
-		  &nf_conntrack_htable_size, 0600);
-
 static __always_inline unsigned int total_extension_size(void)
 {
 	/* remember to add new extensions below */
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 39df72bb9d56..803607a90102 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -1,14 +1,4 @@
-/* L3/L4 protocol support for nf_conntrack. */
-
-/* (C) 1999-2001 Paul `Rusty' Russell
- * (C) 2002-2006 Netfilter Core Team <coreteam@netfilter.org>
- * (C) 2003,2004 USAGI/WIDE Project <http://www.linux-ipv6.org>
- * (C) 2006-2012 Patrick McHardy <kaber@trash.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
+// SPDX-License-Identifier: GPL-2.0
 
 #include <linux/types.h>
 #include <linux/netfilter.h>
@@ -24,22 +14,39 @@
 #include <linux/netdevice.h>
 
 #include <net/netfilter/nf_conntrack.h>
-#include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_log.h>
 
+#include <linux/ip.h>
+#include <linux/icmp.h>
+#include <linux/sysctl.h>
+#include <net/route.h>
+#include <net/ip.h>
+
+#include <linux/netfilter_ipv4.h>
+#include <linux/netfilter_ipv6.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_zones.h>
+#include <net/netfilter/nf_conntrack_seqadj.h>
+#include <net/netfilter/ipv4/nf_conntrack_ipv4.h>
+#include <net/netfilter/ipv6/nf_conntrack_ipv6.h>
+#include <net/netfilter/nf_nat_helper.h>
+#include <net/netfilter/ipv4/nf_defrag_ipv4.h>
+#include <net/netfilter/ipv6/nf_defrag_ipv6.h>
+
+#include <linux/ipv6.h>
+#include <linux/in6.h>
+#include <net/ipv6.h>
+#include <net/inet_frag.h>
+
+extern unsigned int nf_conntrack_net_id;
+
 static struct nf_conntrack_l4proto __rcu **nf_ct_protos[NFPROTO_NUMPROTO] __read_mostly;
-struct nf_conntrack_l3proto __rcu *nf_ct_l3protos[NFPROTO_NUMPROTO] __read_mostly;
-EXPORT_SYMBOL_GPL(nf_ct_l3protos);
 
 static DEFINE_MUTEX(nf_ct_proto_mutex);
 
-struct nf_conntrack_l3proto nf_conntrack_l3proto_generic __read_mostly = {
-	.l3proto	 = PF_UNSPEC,
-};
-EXPORT_SYMBOL_GPL(nf_conntrack_l3proto_generic);
-
 #ifdef CONFIG_SYSCTL
 static int
 nf_ct_register_sysctl(struct net *net,
@@ -127,137 +134,6 @@ __nf_ct_l4proto_find(u_int16_t l3proto, u_int8_t l4proto)
 }
 EXPORT_SYMBOL_GPL(__nf_ct_l4proto_find);
 
-/* this is guaranteed to always return a valid protocol helper, since
- * it falls back to generic_protocol */
-const struct nf_conntrack_l3proto *
-nf_ct_l3proto_find_get(u_int16_t l3proto)
-{
-	struct nf_conntrack_l3proto *p;
-
-	rcu_read_lock();
-	p = __nf_ct_l3proto_find(l3proto);
-	if (!try_module_get(p->me))
-		p = &nf_conntrack_l3proto_generic;
-	rcu_read_unlock();
-
-	return p;
-}
-EXPORT_SYMBOL_GPL(nf_ct_l3proto_find_get);
-
-int
-nf_ct_l3proto_try_module_get(unsigned short l3proto)
-{
-	const struct nf_conntrack_l3proto *p;
-	int ret;
-
-retry:	p = nf_ct_l3proto_find_get(l3proto);
-	if (p == &nf_conntrack_l3proto_generic) {
-		ret = request_module("nf_conntrack-%d", l3proto);
-		if (!ret)
-			goto retry;
-
-		return -EPROTOTYPE;
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(nf_ct_l3proto_try_module_get);
-
-void nf_ct_l3proto_module_put(unsigned short l3proto)
-{
-	struct nf_conntrack_l3proto *p;
-
-	/* rcu_read_lock not necessary since the caller holds a reference, but
-	 * taken anyways to avoid lockdep warnings in __nf_ct_l3proto_find()
-	 */
-	rcu_read_lock();
-	p = __nf_ct_l3proto_find(l3proto);
-	module_put(p->me);
-	rcu_read_unlock();
-}
-EXPORT_SYMBOL_GPL(nf_ct_l3proto_module_put);
-
-static int nf_ct_netns_do_get(struct net *net, u8 nfproto)
-{
-	const struct nf_conntrack_l3proto *l3proto;
-	int ret;
-
-	might_sleep();
-
-	ret = nf_ct_l3proto_try_module_get(nfproto);
-	if (ret < 0)
-		return ret;
-
-	/* we already have a reference, can't fail */
-	rcu_read_lock();
-	l3proto = __nf_ct_l3proto_find(nfproto);
-	rcu_read_unlock();
-
-	if (!l3proto->net_ns_get)
-		return 0;
-
-	ret = l3proto->net_ns_get(net);
-	if (ret < 0)
-		nf_ct_l3proto_module_put(nfproto);
-
-	return ret;
-}
-
-int nf_ct_netns_get(struct net *net, u8 nfproto)
-{
-	int err;
-
-	if (nfproto == NFPROTO_INET) {
-		err = nf_ct_netns_do_get(net, NFPROTO_IPV4);
-		if (err < 0)
-			goto err1;
-		err = nf_ct_netns_do_get(net, NFPROTO_IPV6);
-		if (err < 0)
-			goto err2;
-	} else {
-		err = nf_ct_netns_do_get(net, nfproto);
-		if (err < 0)
-			goto err1;
-	}
-	return 0;
-
-err2:
-	nf_ct_netns_put(net, NFPROTO_IPV4);
-err1:
-	return err;
-}
-EXPORT_SYMBOL_GPL(nf_ct_netns_get);
-
-static void nf_ct_netns_do_put(struct net *net, u8 nfproto)
-{
-	const struct nf_conntrack_l3proto *l3proto;
-
-	might_sleep();
-
-	/* same as nf_conntrack_netns_get(), reference assumed */
-	rcu_read_lock();
-	l3proto = __nf_ct_l3proto_find(nfproto);
-	rcu_read_unlock();
-
-	if (WARN_ON(!l3proto))
-		return;
-
-	if (l3proto->net_ns_put)
-		l3proto->net_ns_put(net);
-
-	nf_ct_l3proto_module_put(nfproto);
-}
-
-void nf_ct_netns_put(struct net *net, uint8_t nfproto)
-{
-	if (nfproto == NFPROTO_INET) {
-		nf_ct_netns_do_put(net, NFPROTO_IPV4);
-		nf_ct_netns_do_put(net, NFPROTO_IPV6);
-	} else
-		nf_ct_netns_do_put(net, nfproto);
-}
-EXPORT_SYMBOL_GPL(nf_ct_netns_put);
-
 const struct nf_conntrack_l4proto *
 nf_ct_l4proto_find_get(u_int16_t l3num, u_int8_t l4num)
 {
@@ -279,11 +155,6 @@ void nf_ct_l4proto_put(const struct nf_conntrack_l4proto *p)
 }
 EXPORT_SYMBOL_GPL(nf_ct_l4proto_put);
 
-static int kill_l3proto(struct nf_conn *i, void *data)
-{
-	return nf_ct_l3num(i) == ((const struct nf_conntrack_l3proto *)data)->l3proto;
-}
-
 static int kill_l4proto(struct nf_conn *i, void *data)
 {
 	const struct nf_conntrack_l4proto *l4proto;
@@ -292,49 +163,6 @@ static int kill_l4proto(struct nf_conn *i, void *data)
 	       nf_ct_l3num(i) == l4proto->l3proto;
 }
 
-int nf_ct_l3proto_register(const struct nf_conntrack_l3proto *proto)
-{
-	int ret = 0;
-	struct nf_conntrack_l3proto *old;
-
-	if (proto->l3proto >= NFPROTO_NUMPROTO)
-		return -EBUSY;
-
-	mutex_lock(&nf_ct_proto_mutex);
-	old = rcu_dereference_protected(nf_ct_l3protos[proto->l3proto],
-					lockdep_is_held(&nf_ct_proto_mutex));
-	if (old != &nf_conntrack_l3proto_generic) {
-		ret = -EBUSY;
-		goto out_unlock;
-	}
-
-	rcu_assign_pointer(nf_ct_l3protos[proto->l3proto], proto);
-
-out_unlock:
-	mutex_unlock(&nf_ct_proto_mutex);
-	return ret;
-
-}
-EXPORT_SYMBOL_GPL(nf_ct_l3proto_register);
-
-void nf_ct_l3proto_unregister(const struct nf_conntrack_l3proto *proto)
-{
-	BUG_ON(proto->l3proto >= NFPROTO_NUMPROTO);
-
-	mutex_lock(&nf_ct_proto_mutex);
-	BUG_ON(rcu_dereference_protected(nf_ct_l3protos[proto->l3proto],
-					 lockdep_is_held(&nf_ct_proto_mutex)
-					 ) != proto);
-	rcu_assign_pointer(nf_ct_l3protos[proto->l3proto],
-			   &nf_conntrack_l3proto_generic);
-	mutex_unlock(&nf_ct_proto_mutex);
-
-	synchronize_rcu();
-	/* Remove all contrack entries for this protocol */
-	nf_ct_iterate_destroy(kill_l3proto, (void*)proto);
-}
-EXPORT_SYMBOL_GPL(nf_ct_l3proto_unregister);
-
 static struct nf_proto_net *nf_ct_l4proto_net(struct net *net,
 				const struct nf_conntrack_l4proto *l4proto)
 {
@@ -501,8 +329,23 @@ void nf_ct_l4proto_pernet_unregister_one(struct net *net,
 }
 EXPORT_SYMBOL_GPL(nf_ct_l4proto_pernet_unregister_one);
 
-int nf_ct_l4proto_register(const struct nf_conntrack_l4proto * const l4proto[],
-			   unsigned int num_proto)
+static void
+nf_ct_l4proto_unregister(const struct nf_conntrack_l4proto * const l4proto[],
+			 unsigned int num_proto)
+{
+	mutex_lock(&nf_ct_proto_mutex);
+	while (num_proto-- != 0)
+		__nf_ct_l4proto_unregister_one(l4proto[num_proto]);
+	mutex_unlock(&nf_ct_proto_mutex);
+
+	synchronize_net();
+	/* Remove all contrack entries for this protocol */
+	nf_ct_iterate_destroy(kill_l4proto, (void *)l4proto);
+}
+
+static int
+nf_ct_l4proto_register(const struct nf_conntrack_l4proto * const l4proto[],
+		       unsigned int num_proto)
 {
 	int ret = -EINVAL, ver;
 	unsigned int i;
@@ -520,7 +363,6 @@ int nf_ct_l4proto_register(const struct nf_conntrack_l4proto * const l4proto[],
 	}
 	return ret;
 }
-EXPORT_SYMBOL_GPL(nf_ct_l4proto_register);
 
 int nf_ct_l4proto_pernet_register(struct net *net,
 				  const struct nf_conntrack_l4proto *const l4proto[],
@@ -544,20 +386,6 @@ int nf_ct_l4proto_pernet_register(struct net *net,
 }
 EXPORT_SYMBOL_GPL(nf_ct_l4proto_pernet_register);
 
-void nf_ct_l4proto_unregister(const struct nf_conntrack_l4proto * const l4proto[],
-			      unsigned int num_proto)
-{
-	mutex_lock(&nf_ct_proto_mutex);
-	while (num_proto-- != 0)
-		__nf_ct_l4proto_unregister_one(l4proto[num_proto]);
-	mutex_unlock(&nf_ct_proto_mutex);
-
-	synchronize_net();
-	/* Remove all contrack entries for this protocol */
-	nf_ct_iterate_destroy(kill_l4proto, (void *)l4proto);
-}
-EXPORT_SYMBOL_GPL(nf_ct_l4proto_unregister);
-
 void nf_ct_l4proto_pernet_unregister(struct net *net,
 				const struct nf_conntrack_l4proto *const l4proto[],
 				unsigned int num_proto)
@@ -567,6 +395,563 @@ void nf_ct_l4proto_pernet_unregister(struct net *net,
 }
 EXPORT_SYMBOL_GPL(nf_ct_l4proto_pernet_unregister);
 
+static unsigned int ipv4_helper(void *priv,
+				struct sk_buff *skb,
+				const struct nf_hook_state *state)
+{
+	struct nf_conn *ct;
+	enum ip_conntrack_info ctinfo;
+	const struct nf_conn_help *help;
+	const struct nf_conntrack_helper *helper;
+
+	/* This is where we call the helper: as the packet goes out. */
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
+		return NF_ACCEPT;
+
+	help = nfct_help(ct);
+	if (!help)
+		return NF_ACCEPT;
+
+	/* rcu_read_lock()ed by nf_hook_thresh */
+	helper = rcu_dereference(help->helper);
+	if (!helper)
+		return NF_ACCEPT;
+
+	return helper->help(skb, skb_network_offset(skb) + ip_hdrlen(skb),
+			    ct, ctinfo);
+}
+
+static unsigned int ipv4_confirm(void *priv,
+				 struct sk_buff *skb,
+				 const struct nf_hook_state *state)
+{
+	struct nf_conn *ct;
+	enum ip_conntrack_info ctinfo;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
+		goto out;
+
+	/* adjust seqs for loopback traffic only in outgoing direction */
+	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
+	    !nf_is_loopback_packet(skb)) {
+		if (!nf_ct_seq_adjust(skb, ct, ctinfo, ip_hdrlen(skb))) {
+			NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), drop);
+			return NF_DROP;
+		}
+	}
+out:
+	/* We've seen it coming out the other side: confirm it */
+	return nf_conntrack_confirm(skb);
+}
+
+static unsigned int ipv4_conntrack_in(void *priv,
+				      struct sk_buff *skb,
+				      const struct nf_hook_state *state)
+{
+	return nf_conntrack_in(state->net, PF_INET, state->hook, skb);
+}
+
+static unsigned int ipv4_conntrack_local(void *priv,
+					 struct sk_buff *skb,
+					 const struct nf_hook_state *state)
+{
+	if (ip_is_fragment(ip_hdr(skb))) { /* IP_NODEFRAG setsockopt set */
+		enum ip_conntrack_info ctinfo;
+		struct nf_conn *tmpl;
+
+		tmpl = nf_ct_get(skb, &ctinfo);
+		if (tmpl && nf_ct_is_template(tmpl)) {
+			/* when skipping ct, clear templates to avoid fooling
+			 * later targets/matches
+			 */
+			skb->_nfct = 0;
+			nf_ct_put(tmpl);
+		}
+		return NF_ACCEPT;
+	}
+
+	return nf_conntrack_in(state->net, PF_INET, state->hook, skb);
+}
+
+/* Connection tracking may drop packets, but never alters them, so
+ * make it the first hook.
+ */
+static const struct nf_hook_ops ipv4_conntrack_ops[] = {
+	{
+		.hook		= ipv4_conntrack_in,
+		.pf		= NFPROTO_IPV4,
+		.hooknum	= NF_INET_PRE_ROUTING,
+		.priority	= NF_IP_PRI_CONNTRACK,
+	},
+	{
+		.hook		= ipv4_conntrack_local,
+		.pf		= NFPROTO_IPV4,
+		.hooknum	= NF_INET_LOCAL_OUT,
+		.priority	= NF_IP_PRI_CONNTRACK,
+	},
+	{
+		.hook		= ipv4_helper,
+		.pf		= NFPROTO_IPV4,
+		.hooknum	= NF_INET_POST_ROUTING,
+		.priority	= NF_IP_PRI_CONNTRACK_HELPER,
+	},
+	{
+		.hook		= ipv4_confirm,
+		.pf		= NFPROTO_IPV4,
+		.hooknum	= NF_INET_POST_ROUTING,
+		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
+	},
+	{
+		.hook		= ipv4_helper,
+		.pf		= NFPROTO_IPV4,
+		.hooknum	= NF_INET_LOCAL_IN,
+		.priority	= NF_IP_PRI_CONNTRACK_HELPER,
+	},
+	{
+		.hook		= ipv4_confirm,
+		.pf		= NFPROTO_IPV4,
+		.hooknum	= NF_INET_LOCAL_IN,
+		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
+	},
+};
+
+/* Fast function for those who don't want to parse /proc (and I don't
+ * blame them).
+ * Reversing the socket's dst/src point of view gives us the reply
+ * mapping.
+ */
+static int
+getorigdst(struct sock *sk, int optval, void __user *user, int *len)
+{
+	const struct inet_sock *inet = inet_sk(sk);
+	const struct nf_conntrack_tuple_hash *h;
+	struct nf_conntrack_tuple tuple;
+
+	memset(&tuple, 0, sizeof(tuple));
+
+	lock_sock(sk);
+	tuple.src.u3.ip = inet->inet_rcv_saddr;
+	tuple.src.u.tcp.port = inet->inet_sport;
+	tuple.dst.u3.ip = inet->inet_daddr;
+	tuple.dst.u.tcp.port = inet->inet_dport;
+	tuple.src.l3num = PF_INET;
+	tuple.dst.protonum = sk->sk_protocol;
+	release_sock(sk);
+
+	/* We only do TCP and SCTP at the moment: is there a better way? */
+	if (tuple.dst.protonum != IPPROTO_TCP &&
+	    tuple.dst.protonum != IPPROTO_SCTP) {
+		pr_debug("SO_ORIGINAL_DST: Not a TCP/SCTP socket\n");
+		return -ENOPROTOOPT;
+	}
+
+	if ((unsigned int)*len < sizeof(struct sockaddr_in)) {
+		pr_debug("SO_ORIGINAL_DST: len %d not %zu\n",
+			 *len, sizeof(struct sockaddr_in));
+		return -EINVAL;
+	}
+
+	h = nf_conntrack_find_get(sock_net(sk), &nf_ct_zone_dflt, &tuple);
+	if (h) {
+		struct sockaddr_in sin;
+		struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
+
+		sin.sin_family = AF_INET;
+		sin.sin_port = ct->tuplehash[IP_CT_DIR_ORIGINAL]
+			.tuple.dst.u.tcp.port;
+		sin.sin_addr.s_addr = ct->tuplehash[IP_CT_DIR_ORIGINAL]
+			.tuple.dst.u3.ip;
+		memset(sin.sin_zero, 0, sizeof(sin.sin_zero));
+
+		pr_debug("SO_ORIGINAL_DST: %pI4 %u\n",
+			 &sin.sin_addr.s_addr, ntohs(sin.sin_port));
+		nf_ct_put(ct);
+		if (copy_to_user(user, &sin, sizeof(sin)) != 0)
+			return -EFAULT;
+		else
+			return 0;
+	}
+	pr_debug("SO_ORIGINAL_DST: Can't find %pI4/%u-%pI4/%u.\n",
+		 &tuple.src.u3.ip, ntohs(tuple.src.u.tcp.port),
+		 &tuple.dst.u3.ip, ntohs(tuple.dst.u.tcp.port));
+	return -ENOENT;
+}
+
+static struct nf_sockopt_ops so_getorigdst = {
+	.pf		= PF_INET,
+	.get_optmin	= SO_ORIGINAL_DST,
+	.get_optmax	= SO_ORIGINAL_DST + 1,
+	.get		= getorigdst,
+	.owner		= THIS_MODULE,
+};
+
+#if IS_ENABLED(CONFIG_IPV6)
+static int
+ipv6_getorigdst(struct sock *sk, int optval, void __user *user, int *len)
+{
+	struct nf_conntrack_tuple tuple = { .src.l3num = NFPROTO_IPV6 };
+	const struct ipv6_pinfo *inet6 = inet6_sk(sk);
+	const struct inet_sock *inet = inet_sk(sk);
+	const struct nf_conntrack_tuple_hash *h;
+	struct sockaddr_in6 sin6;
+	struct nf_conn *ct;
+	__be32 flow_label;
+	int bound_dev_if;
+
+	lock_sock(sk);
+	tuple.src.u3.in6 = sk->sk_v6_rcv_saddr;
+	tuple.src.u.tcp.port = inet->inet_sport;
+	tuple.dst.u3.in6 = sk->sk_v6_daddr;
+	tuple.dst.u.tcp.port = inet->inet_dport;
+	tuple.dst.protonum = sk->sk_protocol;
+	bound_dev_if = sk->sk_bound_dev_if;
+	flow_label = inet6->flow_label;
+	release_sock(sk);
+
+	if (tuple.dst.protonum != IPPROTO_TCP &&
+	    tuple.dst.protonum != IPPROTO_SCTP)
+		return -ENOPROTOOPT;
+
+	if (*len < 0 || (unsigned int)*len < sizeof(sin6))
+		return -EINVAL;
+
+	h = nf_conntrack_find_get(sock_net(sk), &nf_ct_zone_dflt, &tuple);
+	if (!h) {
+		pr_debug("IP6T_SO_ORIGINAL_DST: Can't find %pI6c/%u-%pI6c/%u.\n",
+			 &tuple.src.u3.ip6, ntohs(tuple.src.u.tcp.port),
+			 &tuple.dst.u3.ip6, ntohs(tuple.dst.u.tcp.port));
+		return -ENOENT;
+	}
+
+	ct = nf_ct_tuplehash_to_ctrack(h);
+
+	sin6.sin6_family = AF_INET6;
+	sin6.sin6_port = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u.tcp.port;
+	sin6.sin6_flowinfo = flow_label & IPV6_FLOWINFO_MASK;
+	memcpy(&sin6.sin6_addr,
+	       &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u3.in6,
+	       sizeof(sin6.sin6_addr));
+
+	nf_ct_put(ct);
+	sin6.sin6_scope_id = ipv6_iface_scope_id(&sin6.sin6_addr, bound_dev_if);
+	return copy_to_user(user, &sin6, sizeof(sin6)) ? -EFAULT : 0;
+}
+
+static struct nf_sockopt_ops so_getorigdst6 = {
+	.pf		= NFPROTO_IPV6,
+	.get_optmin	= IP6T_SO_ORIGINAL_DST,
+	.get_optmax	= IP6T_SO_ORIGINAL_DST + 1,
+	.get		= ipv6_getorigdst,
+	.owner		= THIS_MODULE,
+};
+
+static unsigned int ipv6_confirm(void *priv,
+				 struct sk_buff *skb,
+				 const struct nf_hook_state *state)
+{
+	struct nf_conn *ct;
+	enum ip_conntrack_info ctinfo;
+	unsigned char pnum = ipv6_hdr(skb)->nexthdr;
+	int protoff;
+	__be16 frag_off;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
+		goto out;
+
+	protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &pnum,
+				   &frag_off);
+	if (protoff < 0 || (frag_off & htons(~0x7)) != 0) {
+		pr_debug("proto header not found\n");
+		goto out;
+	}
+
+	/* adjust seqs for loopback traffic only in outgoing direction */
+	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
+	    !nf_is_loopback_packet(skb)) {
+		if (!nf_ct_seq_adjust(skb, ct, ctinfo, protoff)) {
+			NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), drop);
+			return NF_DROP;
+		}
+	}
+out:
+	/* We've seen it coming out the other side: confirm it */
+	return nf_conntrack_confirm(skb);
+}
+
+static unsigned int ipv6_conntrack_in(void *priv,
+				      struct sk_buff *skb,
+				      const struct nf_hook_state *state)
+{
+	return nf_conntrack_in(state->net, PF_INET6, state->hook, skb);
+}
+
+static unsigned int ipv6_conntrack_local(void *priv,
+					 struct sk_buff *skb,
+					 const struct nf_hook_state *state)
+{
+	return nf_conntrack_in(state->net, PF_INET6, state->hook, skb);
+}
+
+static unsigned int ipv6_helper(void *priv,
+				struct sk_buff *skb,
+				const struct nf_hook_state *state)
+{
+	struct nf_conn *ct;
+	const struct nf_conn_help *help;
+	const struct nf_conntrack_helper *helper;
+	enum ip_conntrack_info ctinfo;
+	__be16 frag_off;
+	int protoff;
+	u8 nexthdr;
+
+	/* This is where we call the helper: as the packet goes out. */
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
+		return NF_ACCEPT;
+
+	help = nfct_help(ct);
+	if (!help)
+		return NF_ACCEPT;
+	/* rcu_read_lock()ed by nf_hook_thresh */
+	helper = rcu_dereference(help->helper);
+	if (!helper)
+		return NF_ACCEPT;
+
+	nexthdr = ipv6_hdr(skb)->nexthdr;
+	protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &nexthdr,
+				   &frag_off);
+	if (protoff < 0 || (frag_off & htons(~0x7)) != 0) {
+		pr_debug("proto header not found\n");
+		return NF_ACCEPT;
+	}
+
+	return helper->help(skb, protoff, ct, ctinfo);
+}
+
+static const struct nf_hook_ops ipv6_conntrack_ops[] = {
+	{
+		.hook		= ipv6_conntrack_in,
+		.pf		= NFPROTO_IPV6,
+		.hooknum	= NF_INET_PRE_ROUTING,
+		.priority	= NF_IP6_PRI_CONNTRACK,
+	},
+	{
+		.hook		= ipv6_conntrack_local,
+		.pf		= NFPROTO_IPV6,
+		.hooknum	= NF_INET_LOCAL_OUT,
+		.priority	= NF_IP6_PRI_CONNTRACK,
+	},
+	{
+		.hook		= ipv6_helper,
+		.pf		= NFPROTO_IPV6,
+		.hooknum	= NF_INET_POST_ROUTING,
+		.priority	= NF_IP6_PRI_CONNTRACK_HELPER,
+	},
+	{
+		.hook		= ipv6_confirm,
+		.pf		= NFPROTO_IPV6,
+		.hooknum	= NF_INET_POST_ROUTING,
+		.priority	= NF_IP6_PRI_LAST,
+	},
+	{
+		.hook		= ipv6_helper,
+		.pf		= NFPROTO_IPV6,
+		.hooknum	= NF_INET_LOCAL_IN,
+		.priority	= NF_IP6_PRI_CONNTRACK_HELPER,
+	},
+	{
+		.hook		= ipv6_confirm,
+		.pf		= NFPROTO_IPV6,
+		.hooknum	= NF_INET_LOCAL_IN,
+		.priority	= NF_IP6_PRI_LAST - 1,
+	},
+};
+#endif
+
+static int nf_ct_netns_do_get(struct net *net, u8 nfproto)
+{
+	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
+	int err = 0;
+
+	mutex_lock(&nf_ct_proto_mutex);
+
+	switch (nfproto) {
+	case NFPROTO_IPV4:
+		cnet->users4++;
+		if (cnet->users4 > 1)
+			goto out_unlock;
+		err = nf_defrag_ipv4_enable(net);
+		if (err) {
+			cnet->users4 = 0;
+			goto out_unlock;
+		}
+
+		err = nf_register_net_hooks(net, ipv4_conntrack_ops,
+					    ARRAY_SIZE(ipv4_conntrack_ops));
+		if (err)
+			cnet->users4 = 0;
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case NFPROTO_IPV6:
+		cnet->users6++;
+		if (cnet->users6 > 1)
+			goto out_unlock;
+		err = nf_defrag_ipv6_enable(net);
+		if (err < 0) {
+			cnet->users6 = 0;
+			goto out_unlock;
+		}
+
+		err = nf_register_net_hooks(net, ipv6_conntrack_ops,
+					    ARRAY_SIZE(ipv6_conntrack_ops));
+		if (err)
+			cnet->users6 = 0;
+		break;
+#endif
+	default:
+		err = -EPROTO;
+		break;
+	}
+ out_unlock:
+	mutex_unlock(&nf_ct_proto_mutex);
+	return err;
+}
+
+static void nf_ct_netns_do_put(struct net *net, u8 nfproto)
+{
+	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
+
+	mutex_lock(&nf_ct_proto_mutex);
+	switch (nfproto) {
+	case NFPROTO_IPV4:
+		if (cnet->users4 && (--cnet->users4 == 0))
+			nf_unregister_net_hooks(net, ipv4_conntrack_ops,
+						ARRAY_SIZE(ipv4_conntrack_ops));
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case NFPROTO_IPV6:
+		if (cnet->users6 && (--cnet->users6 == 0))
+			nf_unregister_net_hooks(net, ipv6_conntrack_ops,
+						ARRAY_SIZE(ipv6_conntrack_ops));
+		break;
+#endif
+	}
+
+	mutex_unlock(&nf_ct_proto_mutex);
+}
+
+int nf_ct_netns_get(struct net *net, u8 nfproto)
+{
+	int err;
+
+	if (nfproto == NFPROTO_INET) {
+		err = nf_ct_netns_do_get(net, NFPROTO_IPV4);
+		if (err < 0)
+			goto err1;
+		err = nf_ct_netns_do_get(net, NFPROTO_IPV6);
+		if (err < 0)
+			goto err2;
+	} else {
+		err = nf_ct_netns_do_get(net, nfproto);
+		if (err < 0)
+			goto err1;
+	}
+	return 0;
+
+err2:
+	nf_ct_netns_put(net, NFPROTO_IPV4);
+err1:
+	return err;
+}
+EXPORT_SYMBOL_GPL(nf_ct_netns_get);
+
+void nf_ct_netns_put(struct net *net, uint8_t nfproto)
+{
+	if (nfproto == NFPROTO_INET) {
+		nf_ct_netns_do_put(net, NFPROTO_IPV4);
+		nf_ct_netns_do_put(net, NFPROTO_IPV6);
+	} else {
+		nf_ct_netns_do_put(net, nfproto);
+	}
+}
+EXPORT_SYMBOL_GPL(nf_ct_netns_put);
+
+static const struct nf_conntrack_l4proto * const builtin_l4proto[] = {
+	&nf_conntrack_l4proto_tcp4,
+	&nf_conntrack_l4proto_udp4,
+	&nf_conntrack_l4proto_icmp,
+#ifdef CONFIG_NF_CT_PROTO_DCCP
+	&nf_conntrack_l4proto_dccp4,
+#endif
+#ifdef CONFIG_NF_CT_PROTO_SCTP
+	&nf_conntrack_l4proto_sctp4,
+#endif
+#ifdef CONFIG_NF_CT_PROTO_UDPLITE
+	&nf_conntrack_l4proto_udplite4,
+#endif
+#if IS_ENABLED(CONFIG_IPV6)
+	&nf_conntrack_l4proto_tcp6,
+	&nf_conntrack_l4proto_udp6,
+	&nf_conntrack_l4proto_icmpv6,
+#ifdef CONFIG_NF_CT_PROTO_DCCP
+	&nf_conntrack_l4proto_dccp6,
+#endif
+#ifdef CONFIG_NF_CT_PROTO_SCTP
+	&nf_conntrack_l4proto_sctp6,
+#endif
+#ifdef CONFIG_NF_CT_PROTO_UDPLITE
+	&nf_conntrack_l4proto_udplite6,
+#endif
+#endif /* CONFIG_IPV6 */
+};
+
+int nf_conntrack_proto_init(void)
+{
+	int ret = 0;
+
+	ret = nf_register_sockopt(&so_getorigdst);
+	if (ret < 0)
+		return ret;
+
+#if IS_ENABLED(CONFIG_IPV6)
+	ret = nf_register_sockopt(&so_getorigdst6);
+	if (ret < 0)
+		goto cleanup_sockopt;
+#endif
+	ret = nf_ct_l4proto_register(builtin_l4proto,
+				     ARRAY_SIZE(builtin_l4proto));
+	if (ret < 0)
+		goto cleanup_sockopt2;
+
+	return ret;
+cleanup_sockopt2:
+	nf_unregister_sockopt(&so_getorigdst);
+#if IS_ENABLED(CONFIG_IPV6)
+cleanup_sockopt:
+	nf_unregister_sockopt(&so_getorigdst6);
+#endif
+	return ret;
+}
+
+void nf_conntrack_proto_fini(void)
+{
+	unsigned int i;
+
+	nf_ct_l4proto_unregister(builtin_l4proto,
+				 ARRAY_SIZE(builtin_l4proto));
+	nf_unregister_sockopt(&so_getorigdst);
+#if IS_ENABLED(CONFIG_IPV6)
+	nf_unregister_sockopt(&so_getorigdst6);
+#endif
+
+	/* free l3proto protocol tables */
+	for (i = 0; i < ARRAY_SIZE(nf_ct_protos); i++)
+		kfree(nf_ct_protos[i]);
+}
+
 int nf_conntrack_proto_pernet_init(struct net *net)
 {
 	int err;
@@ -583,6 +968,14 @@ int nf_conntrack_proto_pernet_init(struct net *net)
 	if (err < 0)
 		return err;
 
+	err = nf_ct_l4proto_pernet_register(net, builtin_l4proto,
+					    ARRAY_SIZE(builtin_l4proto));
+	if (err < 0) {
+		nf_ct_l4proto_unregister_sysctl(net, pn,
+						&nf_conntrack_l4proto_generic);
+		return err;
+	}
+
 	pn->users++;
 	return 0;
 }
@@ -592,25 +985,19 @@ void nf_conntrack_proto_pernet_fini(struct net *net)
 	struct nf_proto_net *pn = nf_ct_l4proto_net(net,
 					&nf_conntrack_l4proto_generic);
 
+	nf_ct_l4proto_pernet_unregister(net, builtin_l4proto,
+					ARRAY_SIZE(builtin_l4proto));
 	pn->users--;
 	nf_ct_l4proto_unregister_sysctl(net,
 					pn,
 					&nf_conntrack_l4proto_generic);
 }
 
-int nf_conntrack_proto_init(void)
-{
-	unsigned int i;
-	for (i = 0; i < NFPROTO_NUMPROTO; i++)
-		rcu_assign_pointer(nf_ct_l3protos[i],
-				   &nf_conntrack_l3proto_generic);
-	return 0;
-}
 
-void nf_conntrack_proto_fini(void)
-{
-	unsigned int i;
-	/* free l3proto protocol tables */
-	for (i = 0; i < ARRAY_SIZE(nf_ct_protos); i++)
-		kfree(nf_ct_protos[i]);
-}
+module_param_call(hashsize, nf_conntrack_set_hashsize, param_get_uint,
+		  &nf_conntrack_htable_size, 0600);
+
+MODULE_ALIAS("ip_conntrack");
+MODULE_ALIAS("nf_conntrack-" __stringify(AF_INET));
+MODULE_ALIAS("nf_conntrack-" __stringify(AF_INET6));
+MODULE_LICENSE("GPL");
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
similarity index 100%
rename from net/ipv4/netfilter/nf_conntrack_proto_icmp.c
rename to net/netfilter/nf_conntrack_proto_icmp.c
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/netfilter/nf_conntrack_proto_icmpv6.c
similarity index 100%
rename from net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
rename to net/netfilter/nf_conntrack_proto_icmpv6.c
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 47b80fd0d2c3..13279f683da9 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -1,12 +1,4 @@
-/* (C) 1999-2001 Paul `Rusty' Russell
- * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
- * (C) 2005-2012 Patrick McHardy <kaber@trash.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
+// SPDX-License-Identifier: GPL-2.0
 #include <linux/types.h>
 #include <linux/netfilter.h>
 #include <linux/slab.h>
@@ -32,7 +24,7 @@
 #include <net/netfilter/nf_conntrack_timestamp.h>
 #include <linux/rculist_nulls.h>
 
-MODULE_LICENSE("GPL");
+unsigned int nf_conntrack_net_id __read_mostly;
 
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
 void
@@ -674,6 +666,8 @@ static void nf_conntrack_pernet_exit(struct list_head *net_exit_list)
 static struct pernet_operations nf_conntrack_net_ops = {
 	.init		= nf_conntrack_pernet_init,
 	.exit_batch	= nf_conntrack_pernet_exit,
+	.id		= &nf_conntrack_net_id,
+	.size = sizeof(struct nf_conntrack_net),
 };
 
 static int __init nf_conntrack_standalone_init(void)
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 86df2a1666fd..6366f0c0b8c1 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -28,7 +28,6 @@
 #include <net/netfilter/nf_nat_helper.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_seqadj.h>
-#include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <linux/netfilter/nf_nat.h>
 
@@ -743,12 +742,6 @@ EXPORT_SYMBOL_GPL(nf_nat_l4proto_unregister);
 
 int nf_nat_l3proto_register(const struct nf_nat_l3proto *l3proto)
 {
-	int err;
-
-	err = nf_ct_l3proto_try_module_get(l3proto->l3proto);
-	if (err < 0)
-		return err;
-
 	mutex_lock(&nf_nat_proto_mutex);
 	RCU_INIT_POINTER(nf_nat_l4protos[l3proto->l3proto][IPPROTO_TCP],
 			 &nf_nat_l4proto_tcp);
@@ -781,7 +774,6 @@ void nf_nat_l3proto_unregister(const struct nf_nat_l3proto *l3proto)
 	synchronize_rcu();
 
 	nf_nat_l3proto_clean(l3proto->l3proto);
-	nf_ct_l3proto_module_put(l3proto->l3proto);
 }
 EXPORT_SYMBOL_GPL(nf_nat_l3proto_unregister);
 
-- 
2.11.0
