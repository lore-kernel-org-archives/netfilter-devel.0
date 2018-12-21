From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 22/37] netfilter: nat: remove nf_nat_l4proto struct
Date: Fri, 21 Dec 2018 01:28:26 +0100
Message-ID: <20181221002841.28587-23-pablo@netfilter.org>
References: <20181221002841.28587-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181221002841.28587-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This removes the (now empty) nf_nat_l4proto struct, all its instances
and all the no longer needed runtime (un)register functionality.

nf_nat_need_gre() can be axed as well: the module that calls it (to
load the no-longer-existing nat_gre module) also calls other nat core
functions. GRE nat is now always available if kernel is built with it.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_conntrack_proto_gre.h |   2 -
 include/net/netfilter/nf_nat_l3proto.h           |   2 -
 include/net/netfilter/nf_nat_l4proto.h           |  31 -------
 net/ipv4/netfilter/Makefile                      |   5 +-
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c         |  24 +-----
 net/ipv4/netfilter/nf_nat_proto_gre.c            |  61 -------------
 net/ipv4/netfilter/nf_nat_proto_icmp.c           |  21 -----
 net/ipv6/netfilter/Makefile                      |   2 +-
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c         |  24 +-----
 net/ipv6/netfilter/nf_nat_proto_icmpv6.c         |  24 ------
 net/netfilter/Makefile                           |   7 +-
 net/netfilter/nf_conntrack_netlink.c             |   1 -
 net/netfilter/nf_nat_core.c                      | 104 +----------------------
 net/netfilter/nf_nat_proto.c                     |  10 ---
 net/netfilter/nf_nat_proto_dccp.c                |  22 -----
 net/netfilter/nf_nat_proto_sctp.c                |  16 ----
 net/netfilter/nf_nat_proto_tcp.c                 |  23 -----
 net/netfilter/nf_nat_proto_unknown.c             |  21 -----
 18 files changed, 10 insertions(+), 390 deletions(-)
 delete mode 100644 net/ipv4/netfilter/nf_nat_proto_gre.c
 delete mode 100644 net/ipv4/netfilter/nf_nat_proto_icmp.c
 delete mode 100644 net/ipv6/netfilter/nf_nat_proto_icmpv6.c
 delete mode 100644 net/netfilter/nf_nat_proto_dccp.c
 delete mode 100644 net/netfilter/nf_nat_proto_sctp.c
 delete mode 100644 net/netfilter/nf_nat_proto_tcp.c
 delete mode 100644 net/netfilter/nf_nat_proto_unknown.c

diff --git a/include/linux/netfilter/nf_conntrack_proto_gre.h b/include/linux/netfilter/nf_conntrack_proto_gre.h
index b8d95564bd53..f76efa5f2996 100644
--- a/include/linux/netfilter/nf_conntrack_proto_gre.h
+++ b/include/linux/netfilter/nf_conntrack_proto_gre.h
@@ -28,7 +28,5 @@ int nf_ct_gre_keymap_add(struct nf_conn *ct, enum ip_conntrack_dir dir,
 /* delete keymap entries */
 void nf_ct_gre_keymap_destroy(struct nf_conn *ct);
 
-void nf_nat_need_gre(void);
-
 #endif /* __KERNEL__ */
 #endif /* _CONNTRACK_PROTO_GRE_H */
diff --git a/include/net/netfilter/nf_nat_l3proto.h b/include/net/netfilter/nf_nat_l3proto.h
index 1ce0980da638..d774ca0c4c5e 100644
--- a/include/net/netfilter/nf_nat_l3proto.h
+++ b/include/net/netfilter/nf_nat_l3proto.h
@@ -2,13 +2,11 @@
 #ifndef _NF_NAT_L3PROTO_H
 #define _NF_NAT_L3PROTO_H
 
-struct nf_nat_l4proto;
 struct nf_nat_l3proto {
 	u8	l3proto;
 
 	bool	(*manip_pkt)(struct sk_buff *skb,
 			     unsigned int iphdroff,
-			     const struct nf_nat_l4proto *l4proto,
 			     const struct nf_conntrack_tuple *target,
 			     enum nf_nat_manip_type maniptype);
 
diff --git a/include/net/netfilter/nf_nat_l4proto.h b/include/net/netfilter/nf_nat_l4proto.h
index 7b57bd302107..95a4655bd1ad 100644
--- a/include/net/netfilter/nf_nat_l4proto.h
+++ b/include/net/netfilter/nf_nat_l4proto.h
@@ -5,43 +5,12 @@
 #include <net/netfilter/nf_nat.h>
 #include <linux/netfilter/nfnetlink_conntrack.h>
 
-struct nf_nat_range;
 struct nf_nat_l3proto;
 
-struct nf_nat_l4proto {
-	/* Protocol number. */
-	u8 l4proto;
-
-};
-
-/* Protocol registration. */
-int nf_nat_l4proto_register(u8 l3proto, const struct nf_nat_l4proto *l4proto);
-void nf_nat_l4proto_unregister(u8 l3proto,
-			       const struct nf_nat_l4proto *l4proto);
-
-const struct nf_nat_l4proto *__nf_nat_l4proto_find(u8 l3proto, u8 l4proto);
-
 /* Translate a packet to the target according to manip type.  Return on success. */
 bool nf_nat_l4proto_manip_pkt(struct sk_buff *skb,
 			      const struct nf_nat_l3proto *l3proto,
 			      unsigned int iphdroff, unsigned int hdroff,
 			      const struct nf_conntrack_tuple *tuple,
 			      enum nf_nat_manip_type maniptype);
-
-/* Built-in protocols. */
-extern const struct nf_nat_l4proto nf_nat_l4proto_tcp;
-extern const struct nf_nat_l4proto nf_nat_l4proto_udp;
-extern const struct nf_nat_l4proto nf_nat_l4proto_icmp;
-extern const struct nf_nat_l4proto nf_nat_l4proto_icmpv6;
-extern const struct nf_nat_l4proto nf_nat_l4proto_unknown;
-#ifdef CONFIG_NF_NAT_PROTO_DCCP
-extern const struct nf_nat_l4proto nf_nat_l4proto_dccp;
-#endif
-#ifdef CONFIG_NF_NAT_PROTO_SCTP
-extern const struct nf_nat_l4proto nf_nat_l4proto_sctp;
-#endif
-#ifdef CONFIG_NF_NAT_PROTO_UDPLITE
-extern const struct nf_nat_l4proto nf_nat_l4proto_udplite;
-#endif
-
 #endif /*_NF_NAT_L4PROTO_H*/
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 367993adf4d3..fd7122e0e2c9 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -3,7 +3,7 @@
 # Makefile for the netfilter modules on top of IPv4.
 #
 
-nf_nat_ipv4-y		:= nf_nat_l3proto_ipv4.o nf_nat_proto_icmp.o
+nf_nat_ipv4-y		:= nf_nat_l3proto_ipv4.o
 nf_nat_ipv4-$(CONFIG_NF_NAT_MASQUERADE_IPV4) += nf_nat_masquerade_ipv4.o
 obj-$(CONFIG_NF_NAT_IPV4) += nf_nat_ipv4.o
 
@@ -28,9 +28,6 @@ nf_nat_snmp_basic-y := nf_nat_snmp_basic.asn1.o nf_nat_snmp_basic_main.o
 $(obj)/nf_nat_snmp_basic_main.o: $(obj)/nf_nat_snmp_basic.asn1.h
 obj-$(CONFIG_NF_NAT_SNMP_BASIC) += nf_nat_snmp_basic.o
 
-# NAT protocols (nf_nat)
-obj-$(CONFIG_NF_NAT_PROTO_GRE) += nf_nat_proto_gre.o
-
 obj-$(CONFIG_NFT_CHAIN_ROUTE_IPV4) += nft_chain_route_ipv4.o
 obj-$(CONFIG_NFT_CHAIN_NAT_IPV4) += nft_chain_nat_ipv4.o
 obj-$(CONFIG_NFT_REJECT_IPV4) += nft_reject_ipv4.o
diff --git a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
index 65fdb7a74621..2687db015b6f 100644
--- a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
@@ -64,7 +64,6 @@ static void nf_nat_ipv4_decode_session(struct sk_buff *skb,
 
 static bool nf_nat_ipv4_manip_pkt(struct sk_buff *skb,
 				  unsigned int iphdroff,
-				  const struct nf_nat_l4proto *l4proto,
 				  const struct nf_conntrack_tuple *target,
 				  enum nf_nat_manip_type maniptype)
 {
@@ -171,7 +170,6 @@ int nf_nat_icmp_reply_translation(struct sk_buff *skb,
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
 	enum nf_nat_manip_type manip = HOOK2MANIP(hooknum);
 	unsigned int hdrlen = ip_hdrlen(skb);
-	const struct nf_nat_l4proto *l4proto;
 	struct nf_conntrack_tuple target;
 	unsigned long statusbit;
 
@@ -202,9 +200,8 @@ int nf_nat_icmp_reply_translation(struct sk_buff *skb,
 	if (!(ct->status & statusbit))
 		return 1;
 
-	l4proto = __nf_nat_l4proto_find(NFPROTO_IPV4, inside->ip.protocol);
 	if (!nf_nat_ipv4_manip_pkt(skb, hdrlen + sizeof(inside->icmp),
-				   l4proto, &ct->tuplehash[!dir].tuple, !manip))
+				   &ct->tuplehash[!dir].tuple, !manip))
 		return 0;
 
 	if (skb->ip_summed != CHECKSUM_PARTIAL) {
@@ -218,8 +215,7 @@ int nf_nat_icmp_reply_translation(struct sk_buff *skb,
 
 	/* Change outer to look like the reply to an incoming packet */
 	nf_ct_invert_tuplepr(&target, &ct->tuplehash[!dir].tuple);
-	l4proto = __nf_nat_l4proto_find(NFPROTO_IPV4, 0);
-	if (!nf_nat_ipv4_manip_pkt(skb, 0, l4proto, &target, manip))
+	if (!nf_nat_ipv4_manip_pkt(skb, 0, &target, manip))
 		return 0;
 
 	return 1;
@@ -376,26 +372,12 @@ EXPORT_SYMBOL_GPL(nf_nat_l3proto_ipv4_unregister_fn);
 
 static int __init nf_nat_l3proto_ipv4_init(void)
 {
-	int err;
-
-	err = nf_nat_l4proto_register(NFPROTO_IPV4, &nf_nat_l4proto_icmp);
-	if (err < 0)
-		goto err1;
-	err = nf_nat_l3proto_register(&nf_nat_l3proto_ipv4);
-	if (err < 0)
-		goto err2;
-	return err;
-
-err2:
-	nf_nat_l4proto_unregister(NFPROTO_IPV4, &nf_nat_l4proto_icmp);
-err1:
-	return err;
+	return nf_nat_l3proto_register(&nf_nat_l3proto_ipv4);
 }
 
 static void __exit nf_nat_l3proto_ipv4_exit(void)
 {
 	nf_nat_l3proto_unregister(&nf_nat_l3proto_ipv4);
-	nf_nat_l4proto_unregister(NFPROTO_IPV4, &nf_nat_l4proto_icmp);
 }
 
 MODULE_LICENSE("GPL");
diff --git a/net/ipv4/netfilter/nf_nat_proto_gre.c b/net/ipv4/netfilter/nf_nat_proto_gre.c
deleted file mode 100644
index 25849295d537..000000000000
--- a/net/ipv4/netfilter/nf_nat_proto_gre.c
+++ /dev/null
@@ -1,61 +0,0 @@
-/*
- * nf_nat_proto_gre.c
- *
- * NAT protocol helper module for GRE.
- *
- * GRE is a generic encapsulation protocol, which is generally not very
- * suited for NAT, as it has no protocol-specific part as port numbers.
- *
- * It has an optional key field, which may help us distinguishing two
- * connections between the same two hosts.
- *
- * GRE is defined in RFC 1701 and RFC 1702, as well as RFC 2784
- *
- * PPTP is built on top of a modified version of GRE, and has a mandatory
- * field called "CallID", which serves us for the same purpose as the key
- * field in plain GRE.
- *
- * Documentation about PPTP can be found in RFC 2637
- *
- * (C) 2000-2005 by Harald Welte <laforge@gnumonks.org>
- *
- * Development of this code funded by Astaro AG (http://www.astaro.com/)
- *
- * (C) 2006-2012 Patrick McHardy <kaber@trash.net>
- *
- */
-
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/ip.h>
-
-#include <net/netfilter/nf_nat.h>
-#include <net/netfilter/nf_nat_l4proto.h>
-#include <linux/netfilter/nf_conntrack_proto_gre.h>
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
-MODULE_DESCRIPTION("Netfilter NAT protocol helper module for GRE");
-
-static const struct nf_nat_l4proto gre = {
-	.l4proto		= IPPROTO_GRE,
-};
-
-static int __init nf_nat_proto_gre_init(void)
-{
-	return nf_nat_l4proto_register(NFPROTO_IPV4, &gre);
-}
-
-static void __exit nf_nat_proto_gre_fini(void)
-{
-	nf_nat_l4proto_unregister(NFPROTO_IPV4, &gre);
-}
-
-module_init(nf_nat_proto_gre_init);
-module_exit(nf_nat_proto_gre_fini);
-
-void nf_nat_need_gre(void)
-{
-	return;
-}
-EXPORT_SYMBOL_GPL(nf_nat_need_gre);
diff --git a/net/ipv4/netfilter/nf_nat_proto_icmp.c b/net/ipv4/netfilter/nf_nat_proto_icmp.c
deleted file mode 100644
index c2b7fd1a997b..000000000000
--- a/net/ipv4/netfilter/nf_nat_proto_icmp.c
+++ /dev/null
@@ -1,21 +0,0 @@
-/* (C) 1999-2001 Paul `Rusty' Russell
- * (C) 2002-2006 Netfilter Core Team <coreteam@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/types.h>
-#include <linux/init.h>
-#include <linux/export.h>
-#include <linux/ip.h>
-
-#include <linux/netfilter.h>
-#include <net/netfilter/nf_nat.h>
-#include <net/netfilter/nf_nat_core.h>
-#include <net/netfilter/nf_nat_l4proto.h>
-
-const struct nf_nat_l4proto nf_nat_l4proto_icmp = {
-	.l4proto		= IPPROTO_ICMP,
-};
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index 200c0c235565..9ea43d5256e0 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -11,7 +11,7 @@ obj-$(CONFIG_IP6_NF_RAW) += ip6table_raw.o
 obj-$(CONFIG_IP6_NF_SECURITY) += ip6table_security.o
 obj-$(CONFIG_IP6_NF_NAT) += ip6table_nat.o
 
-nf_nat_ipv6-y		:= nf_nat_l3proto_ipv6.o nf_nat_proto_icmpv6.o
+nf_nat_ipv6-y		:= nf_nat_l3proto_ipv6.o
 nf_nat_ipv6-$(CONFIG_NF_NAT_MASQUERADE_IPV6) += nf_nat_masquerade_ipv6.o
 obj-$(CONFIG_NF_NAT_IPV6) += nf_nat_ipv6.o
 
diff --git a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
index 6ff1375799c7..23022447eb49 100644
--- a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
@@ -63,7 +63,6 @@ static void nf_nat_ipv6_decode_session(struct sk_buff *skb,
 
 static bool nf_nat_ipv6_manip_pkt(struct sk_buff *skb,
 				  unsigned int iphdroff,
-				  const struct nf_nat_l4proto *l4proto,
 				  const struct nf_conntrack_tuple *target,
 				  enum nf_nat_manip_type maniptype)
 {
@@ -181,7 +180,6 @@ int nf_nat_icmpv6_reply_translation(struct sk_buff *skb,
 	} *inside;
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
 	enum nf_nat_manip_type manip = HOOK2MANIP(hooknum);
-	const struct nf_nat_l4proto *l4proto;
 	struct nf_conntrack_tuple target;
 	unsigned long statusbit;
 
@@ -212,9 +210,8 @@ int nf_nat_icmpv6_reply_translation(struct sk_buff *skb,
 	if (!(ct->status & statusbit))
 		return 1;
 
-	l4proto = __nf_nat_l4proto_find(NFPROTO_IPV6, inside->ip6.nexthdr);
 	if (!nf_nat_ipv6_manip_pkt(skb, hdrlen + sizeof(inside->icmp6),
-				   l4proto, &ct->tuplehash[!dir].tuple, !manip))
+				   &ct->tuplehash[!dir].tuple, !manip))
 		return 0;
 
 	if (skb->ip_summed != CHECKSUM_PARTIAL) {
@@ -229,8 +226,7 @@ int nf_nat_icmpv6_reply_translation(struct sk_buff *skb,
 	}
 
 	nf_ct_invert_tuplepr(&target, &ct->tuplehash[!dir].tuple);
-	l4proto = __nf_nat_l4proto_find(NFPROTO_IPV6, IPPROTO_ICMPV6);
-	if (!nf_nat_ipv6_manip_pkt(skb, 0, l4proto, &target, manip))
+	if (!nf_nat_ipv6_manip_pkt(skb, 0, &target, manip))
 		return 0;
 
 	return 1;
@@ -400,26 +396,12 @@ EXPORT_SYMBOL_GPL(nf_nat_l3proto_ipv6_unregister_fn);
 
 static int __init nf_nat_l3proto_ipv6_init(void)
 {
-	int err;
-
-	err = nf_nat_l4proto_register(NFPROTO_IPV6, &nf_nat_l4proto_icmpv6);
-	if (err < 0)
-		goto err1;
-	err = nf_nat_l3proto_register(&nf_nat_l3proto_ipv6);
-	if (err < 0)
-		goto err2;
-	return err;
-
-err2:
-	nf_nat_l4proto_unregister(NFPROTO_IPV6, &nf_nat_l4proto_icmpv6);
-err1:
-	return err;
+	return nf_nat_l3proto_register(&nf_nat_l3proto_ipv6);
 }
 
 static void __exit nf_nat_l3proto_ipv6_exit(void)
 {
 	nf_nat_l3proto_unregister(&nf_nat_l3proto_ipv6);
-	nf_nat_l4proto_unregister(NFPROTO_IPV6, &nf_nat_l4proto_icmpv6);
 }
 
 MODULE_LICENSE("GPL");
diff --git a/net/ipv6/netfilter/nf_nat_proto_icmpv6.c b/net/ipv6/netfilter/nf_nat_proto_icmpv6.c
deleted file mode 100644
index fcbe7e750420..000000000000
--- a/net/ipv6/netfilter/nf_nat_proto_icmpv6.c
+++ /dev/null
@@ -1,24 +0,0 @@
-/*
- * Copyright (c) 2011 Patrick Mchardy <kaber@trash.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * Based on Rusty Russell's IPv4 ICMP NAT code. Development of IPv6
- * NAT funded by Astaro.
- */
-
-#include <linux/types.h>
-#include <linux/init.h>
-#include <linux/icmpv6.h>
-
-#include <linux/netfilter.h>
-#include <net/netfilter/nf_nat.h>
-#include <net/netfilter/nf_nat_core.h>
-#include <net/netfilter/nf_nat_l3proto.h>
-#include <net/netfilter/nf_nat_l4proto.h>
-
-const struct nf_nat_l4proto nf_nat_l4proto_icmpv6 = {
-	.l4proto		= IPPROTO_ICMPV6,
-};
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index ed4a912c5484..1ae65a314d7a 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -47,12 +47,7 @@ obj-$(CONFIG_NF_CONNTRACK_SANE) += nf_conntrack_sane.o
 obj-$(CONFIG_NF_CONNTRACK_SIP) += nf_conntrack_sip.o
 obj-$(CONFIG_NF_CONNTRACK_TFTP) += nf_conntrack_tftp.o
 
-nf_nat-y	:= nf_nat_core.o nf_nat_proto_unknown.o \
-		   nf_nat_proto.o nf_nat_proto_tcp.o nf_nat_helper.o
-
-# NAT protocols (nf_nat)
-nf_nat-$(CONFIG_NF_NAT_PROTO_DCCP) += nf_nat_proto_dccp.o
-nf_nat-$(CONFIG_NF_NAT_PROTO_SCTP) += nf_nat_proto_sctp.o
+nf_nat-y	:= nf_nat_core.o nf_nat_proto.o nf_nat_helper.o
 
 # generic transport layer logging
 obj-$(CONFIG_NF_LOG_COMMON) += nf_log_common.o
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 4f54c4355d33..1213beb5a714 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -47,7 +47,6 @@
 #include <net/netfilter/nf_conntrack_synproxy.h>
 #ifdef CONFIG_NF_NAT_NEEDED
 #include <net/netfilter/nf_nat_core.h>
-#include <net/netfilter/nf_nat_l4proto.h>
 #include <net/netfilter/nf_nat_helper.h>
 #endif
 
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 2d7fac80341b..9935b66427e6 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -23,7 +23,6 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_l3proto.h>
-#include <net/netfilter/nf_nat_l4proto.h>
 #include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_nat_helper.h>
 #include <net/netfilter/nf_conntrack_helper.h>
@@ -38,8 +37,6 @@ static spinlock_t nf_nat_locks[CONNTRACK_LOCKS];
 static DEFINE_MUTEX(nf_nat_proto_mutex);
 static const struct nf_nat_l3proto __rcu *nf_nat_l3protos[NFPROTO_NUMPROTO]
 						__read_mostly;
-static const struct nf_nat_l4proto __rcu **nf_nat_l4protos[NFPROTO_NUMPROTO]
-						__read_mostly;
 static unsigned int nat_net_id __read_mostly;
 
 static struct hlist_head *nf_nat_bysource __read_mostly;
@@ -67,13 +64,6 @@ __nf_nat_l3proto_find(u8 family)
 	return rcu_dereference(nf_nat_l3protos[family]);
 }
 
-inline const struct nf_nat_l4proto *
-__nf_nat_l4proto_find(u8 family, u8 protonum)
-{
-	return rcu_dereference(nf_nat_l4protos[family][protonum]);
-}
-EXPORT_SYMBOL_GPL(__nf_nat_l4proto_find);
-
 #ifdef CONFIG_XFRM
 static void __nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl)
 {
@@ -646,16 +636,13 @@ static unsigned int nf_nat_manip_pkt(struct sk_buff *skb, struct nf_conn *ct,
 				     enum ip_conntrack_dir dir)
 {
 	const struct nf_nat_l3proto *l3proto;
-	const struct nf_nat_l4proto *l4proto;
 	struct nf_conntrack_tuple target;
 
 	/* We are aiming to look like inverse of other direction. */
 	nf_ct_invert_tuplepr(&target, &ct->tuplehash[!dir].tuple);
 
 	l3proto = __nf_nat_l3proto_find(target.src.l3num);
-	l4proto = __nf_nat_l4proto_find(target.src.l3num,
-					target.dst.protonum);
-	if (!l3proto->manip_pkt(skb, 0, l4proto, &target, mtype))
+	if (!l3proto->manip_pkt(skb, 0, &target, mtype))
 		return NF_DROP;
 
 	return NF_ACCEPT;
@@ -811,16 +798,6 @@ static int nf_nat_proto_clean(struct nf_conn *ct, void *data)
 	return 0;
 }
 
-static void nf_nat_l4proto_clean(u8 l3proto, u8 l4proto)
-{
-	struct nf_nat_proto_clean clean = {
-		.l3proto = l3proto,
-		.l4proto = l4proto,
-	};
-
-	nf_ct_iterate_destroy(nf_nat_proto_remove, &clean);
-}
-
 static void nf_nat_l3proto_clean(u8 l3proto)
 {
 	struct nf_nat_proto_clean clean = {
@@ -830,82 +807,8 @@ static void nf_nat_l3proto_clean(u8 l3proto)
 	nf_ct_iterate_destroy(nf_nat_proto_remove, &clean);
 }
 
-/* Protocol registration. */
-int nf_nat_l4proto_register(u8 l3proto, const struct nf_nat_l4proto *l4proto)
-{
-	const struct nf_nat_l4proto **l4protos;
-	unsigned int i;
-	int ret = 0;
-
-	mutex_lock(&nf_nat_proto_mutex);
-	if (nf_nat_l4protos[l3proto] == NULL) {
-		l4protos = kmalloc_array(IPPROTO_MAX,
-					 sizeof(struct nf_nat_l4proto *),
-					 GFP_KERNEL);
-		if (l4protos == NULL) {
-			ret = -ENOMEM;
-			goto out;
-		}
-
-		for (i = 0; i < IPPROTO_MAX; i++)
-			RCU_INIT_POINTER(l4protos[i], &nf_nat_l4proto_unknown);
-
-		/* Before making proto_array visible to lockless readers,
-		 * we must make sure its content is committed to memory.
-		 */
-		smp_wmb();
-
-		nf_nat_l4protos[l3proto] = l4protos;
-	}
-
-	if (rcu_dereference_protected(
-			nf_nat_l4protos[l3proto][l4proto->l4proto],
-			lockdep_is_held(&nf_nat_proto_mutex)
-			) != &nf_nat_l4proto_unknown) {
-		ret = -EBUSY;
-		goto out;
-	}
-	RCU_INIT_POINTER(nf_nat_l4protos[l3proto][l4proto->l4proto], l4proto);
- out:
-	mutex_unlock(&nf_nat_proto_mutex);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(nf_nat_l4proto_register);
-
-/* No one stores the protocol anywhere; simply delete it. */
-void nf_nat_l4proto_unregister(u8 l3proto, const struct nf_nat_l4proto *l4proto)
-{
-	mutex_lock(&nf_nat_proto_mutex);
-	RCU_INIT_POINTER(nf_nat_l4protos[l3proto][l4proto->l4proto],
-			 &nf_nat_l4proto_unknown);
-	mutex_unlock(&nf_nat_proto_mutex);
-	synchronize_rcu();
-
-	nf_nat_l4proto_clean(l3proto, l4proto->l4proto);
-}
-EXPORT_SYMBOL_GPL(nf_nat_l4proto_unregister);
-
 int nf_nat_l3proto_register(const struct nf_nat_l3proto *l3proto)
 {
-	mutex_lock(&nf_nat_proto_mutex);
-	RCU_INIT_POINTER(nf_nat_l4protos[l3proto->l3proto][IPPROTO_TCP],
-			 &nf_nat_l4proto_tcp);
-	RCU_INIT_POINTER(nf_nat_l4protos[l3proto->l3proto][IPPROTO_UDP],
-			 &nf_nat_l4proto_udp);
-#ifdef CONFIG_NF_NAT_PROTO_DCCP
-	RCU_INIT_POINTER(nf_nat_l4protos[l3proto->l3proto][IPPROTO_DCCP],
-			 &nf_nat_l4proto_dccp);
-#endif
-#ifdef CONFIG_NF_NAT_PROTO_SCTP
-	RCU_INIT_POINTER(nf_nat_l4protos[l3proto->l3proto][IPPROTO_SCTP],
-			 &nf_nat_l4proto_sctp);
-#endif
-#ifdef CONFIG_NF_NAT_PROTO_UDPLITE
-	RCU_INIT_POINTER(nf_nat_l4protos[l3proto->l3proto][IPPROTO_UDPLITE],
-			 &nf_nat_l4proto_udplite);
-#endif
-	mutex_unlock(&nf_nat_proto_mutex);
-
 	RCU_INIT_POINTER(nf_nat_l3protos[l3proto->l3proto], l3proto);
 	return 0;
 }
@@ -1236,7 +1139,6 @@ static int __init nf_nat_init(void)
 static void __exit nf_nat_cleanup(void)
 {
 	struct nf_nat_proto_clean clean = {};
-	unsigned int i;
 
 	nf_ct_iterate_destroy(nf_nat_proto_clean, &clean);
 
@@ -1244,10 +1146,6 @@ static void __exit nf_nat_cleanup(void)
 	nf_ct_helper_expectfn_unregister(&follow_master_nat);
 	RCU_INIT_POINTER(nf_nat_hook, NULL);
 
-	synchronize_rcu();
-
-	for (i = 0; i < NFPROTO_NUMPROTO; i++)
-		kfree(nf_nat_l4protos[i]);
 	synchronize_net();
 	kvfree(nf_nat_bysource);
 	unregister_pernet_subsys(&nat_net_ops);
diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 1042706827cb..f83bf9d8c9f5 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -341,13 +341,3 @@ bool nf_nat_l4proto_manip_pkt(struct sk_buff *skb,
 	return true;
 }
 EXPORT_SYMBOL_GPL(nf_nat_l4proto_manip_pkt);
-
-#ifdef CONFIG_NF_NAT_PROTO_UDPLITE
-const struct nf_nat_l4proto nf_nat_l4proto_udplite = {
-	.l4proto		= IPPROTO_UDPLITE,
-};
-#endif /* CONFIG_NF_NAT_PROTO_UDPLITE */
-
-const struct nf_nat_l4proto nf_nat_l4proto_udp = {
-	.l4proto		= IPPROTO_UDP,
-};
diff --git a/net/netfilter/nf_nat_proto_dccp.c b/net/netfilter/nf_nat_proto_dccp.c
deleted file mode 100644
index dace808d4a23..000000000000
--- a/net/netfilter/nf_nat_proto_dccp.c
+++ /dev/null
@@ -1,22 +0,0 @@
-/*
- * DCCP NAT protocol helper
- *
- * Copyright (c) 2005, 2006, 2008 Patrick McHardy <kaber@trash.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/skbuff.h>
-
-#include <net/netfilter/nf_conntrack.h>
-#include <net/netfilter/nf_nat.h>
-#include <net/netfilter/nf_nat_l3proto.h>
-#include <net/netfilter/nf_nat_l4proto.h>
-
-const struct nf_nat_l4proto nf_nat_l4proto_dccp = {
-	.l4proto		= IPPROTO_DCCP,
-};
diff --git a/net/netfilter/nf_nat_proto_sctp.c b/net/netfilter/nf_nat_proto_sctp.c
deleted file mode 100644
index e555cb7a248c..000000000000
--- a/net/netfilter/nf_nat_proto_sctp.c
+++ /dev/null
@@ -1,16 +0,0 @@
-/*
- * Copyright (c) 2008 Patrick McHardy <kaber@trash.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/types.h>
-
-#include <net/netfilter/nf_nat_l4proto.h>
-
-
-const struct nf_nat_l4proto nf_nat_l4proto_sctp = {
-	.l4proto		= IPPROTO_SCTP,
-};
diff --git a/net/netfilter/nf_nat_proto_tcp.c b/net/netfilter/nf_nat_proto_tcp.c
deleted file mode 100644
index 04d2dc100048..000000000000
--- a/net/netfilter/nf_nat_proto_tcp.c
+++ /dev/null
@@ -1,23 +0,0 @@
-/* (C) 1999-2001 Paul `Rusty' Russell
- * (C) 2002-2006 Netfilter Core Team <coreteam@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/types.h>
-#include <linux/init.h>
-#include <linux/export.h>
-#include <linux/tcp.h>
-
-#include <linux/netfilter.h>
-#include <linux/netfilter/nfnetlink_conntrack.h>
-#include <net/netfilter/nf_nat.h>
-#include <net/netfilter/nf_nat_l3proto.h>
-#include <net/netfilter/nf_nat_l4proto.h>
-#include <net/netfilter/nf_nat_core.h>
-
-const struct nf_nat_l4proto nf_nat_l4proto_tcp = {
-	.l4proto		= IPPROTO_TCP,
-};
diff --git a/net/netfilter/nf_nat_proto_unknown.c b/net/netfilter/nf_nat_proto_unknown.c
deleted file mode 100644
index 7f6201208a32..000000000000
--- a/net/netfilter/nf_nat_proto_unknown.c
+++ /dev/null
@@ -1,21 +0,0 @@
-/* The "unknown" protocol.  This is what is used for protocols we
- * don't understand.  It's returned by ip_ct_find_proto().
- */
-
-/* (C) 1999-2001 Paul `Rusty' Russell
- * (C) 2002-2006 Netfilter Core Team <coreteam@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/types.h>
-#include <linux/init.h>
-
-#include <linux/netfilter.h>
-#include <net/netfilter/nf_nat.h>
-#include <net/netfilter/nf_nat_l4proto.h>
-
-const struct nf_nat_l4proto nf_nat_l4proto_unknown = {
-};
-- 
2.11.0
