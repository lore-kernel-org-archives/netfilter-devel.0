Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C14E7C282DA
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:01:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87D0F2075B
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:01:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbfDORAn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 13:00:43 -0400
Received: from mail.us.es ([193.147.175.20]:50448 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727823AbfDORAm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 13:00:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 300711C4431
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1105FDA716
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:41 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 10184DA715; Mon, 15 Apr 2019 19:00:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 34741DA709;
        Mon, 15 Apr 2019 19:00:38 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 15 Apr 2019 19:00:38 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 075A64265A31;
        Mon, 15 Apr 2019 19:00:37 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 08/22] netfilter: nf_tables: merge route type into core
Date:   Mon, 15 Apr 2019 19:00:14 +0200
Message-Id: <20190415170028.3470-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190415170028.3470-1-pablo@netfilter.org>
References: <20190415170028.3470-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

very little code, so it really doesn't make sense to have extra
modules or even a kconfig knob for this.

Merge them and make functionality available unconditionally.
The merge makes inet family route support trivial, so add it
as well here.

Before:
   text	   data	    bss	    dec	    hex	filename
    835	    832	      0	   1667	    683 nft_chain_route_ipv4.ko
    870	    832	      0	   1702	    6a6	nft_chain_route_ipv6.ko
 111568	   2556	    529	 114653	  1bfdd	nf_tables.ko

After:
   text	   data	    bss	    dec	    hex	filename
 113133	   2556	    529	 116218	  1c5fa	nf_tables.ko

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_ipv6.h            |  15 +++
 include/net/netfilter/nf_tables.h         |   2 +
 net/ipv4/netfilter/Kconfig                |   8 --
 net/ipv4/netfilter/Makefile               |   1 -
 net/ipv4/netfilter/nft_chain_route_ipv4.c |  89 ----------------
 net/ipv6/netfilter/Kconfig                |   8 --
 net/ipv6/netfilter/Makefile               |   1 -
 net/ipv6/netfilter/nft_chain_route_ipv6.c |  91 ----------------
 net/netfilter/Makefile                    |   3 +-
 net/netfilter/nf_nat_proto.c              |  16 +--
 net/netfilter/nf_tables_api.c             |   2 +
 net/netfilter/nft_chain_route.c           | 169 ++++++++++++++++++++++++++++++
 12 files changed, 191 insertions(+), 214 deletions(-)
 delete mode 100644 net/ipv4/netfilter/nft_chain_route_ipv4.c
 delete mode 100644 net/ipv6/netfilter/nft_chain_route_ipv6.c
 create mode 100644 net/netfilter/nft_chain_route.c

diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 471e9467105b..12113e502656 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -87,6 +87,21 @@ static inline int nf_ip6_route(struct net *net, struct dst_entry **dst,
 }
 
 int ip6_route_me_harder(struct net *net, struct sk_buff *skb);
+
+static inline int nf_ip6_route_me_harder(struct net *net, struct sk_buff *skb)
+{
+#if IS_MODULE(CONFIG_IPV6)
+	const struct nf_ipv6_ops *v6_ops = nf_get_ipv6_ops();
+
+	if (!v6_ops)
+		return -EHOSTUNREACH;
+
+	return v6_ops->route_me_harder(net, skb);
+#else
+	return ip6_route_me_harder(net, skb);
+#endif
+}
+
 __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
 			unsigned int dataoff, u_int8_t protocol);
 
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 3e9ab643eedf..55dff3ab44c7 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1411,4 +1411,6 @@ struct nft_trans_flowtable {
 int __init nft_chain_filter_init(void);
 void nft_chain_filter_fini(void);
 
+void __init nft_chain_route_init(void);
+void nft_chain_route_fini(void);
 #endif /* _NET_NF_TABLES_H */
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index c98391d49200..ea688832fc4e 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -27,14 +27,6 @@ config NF_TABLES_IPV4
 
 if NF_TABLES_IPV4
 
-config NFT_CHAIN_ROUTE_IPV4
-	tristate "IPv4 nf_tables route chain support"
-	help
-	  This option enables the "route" chain for IPv4 in nf_tables. This
-	  chain type is used to force packet re-routing after mangling header
-	  fields such as the source, destination, type of service and
-	  the packet mark.
-
 config NFT_REJECT_IPV4
 	select NF_REJECT_IPV4
 	default NFT_REJECT
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index e241f5188ebe..2cfdda7b109f 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -24,7 +24,6 @@ nf_nat_snmp_basic-y := nf_nat_snmp_basic.asn1.o nf_nat_snmp_basic_main.o
 $(obj)/nf_nat_snmp_basic_main.o: $(obj)/nf_nat_snmp_basic.asn1.h
 obj-$(CONFIG_NF_NAT_SNMP_BASIC) += nf_nat_snmp_basic.o
 
-obj-$(CONFIG_NFT_CHAIN_ROUTE_IPV4) += nft_chain_route_ipv4.o
 obj-$(CONFIG_NFT_REJECT_IPV4) += nft_reject_ipv4.o
 obj-$(CONFIG_NFT_FIB_IPV4) += nft_fib_ipv4.o
 obj-$(CONFIG_NFT_DUP_IPV4) += nft_dup_ipv4.o
diff --git a/net/ipv4/netfilter/nft_chain_route_ipv4.c b/net/ipv4/netfilter/nft_chain_route_ipv4.c
deleted file mode 100644
index 7d82934c46f4..000000000000
--- a/net/ipv4/netfilter/nft_chain_route_ipv4.c
+++ /dev/null
@@ -1,89 +0,0 @@
-/*
- * Copyright (c) 2008 Patrick McHardy <kaber@trash.net>
- * Copyright (c) 2012 Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/list.h>
-#include <linux/skbuff.h>
-#include <linux/netlink.h>
-#include <linux/netfilter.h>
-#include <linux/netfilter_ipv4.h>
-#include <linux/netfilter/nfnetlink.h>
-#include <linux/netfilter/nf_tables.h>
-#include <net/netfilter/nf_tables.h>
-#include <net/netfilter/nf_tables_ipv4.h>
-#include <net/route.h>
-#include <net/ip.h>
-
-static unsigned int nf_route_table_hook(void *priv,
-					struct sk_buff *skb,
-					const struct nf_hook_state *state)
-{
-	unsigned int ret;
-	struct nft_pktinfo pkt;
-	u32 mark;
-	__be32 saddr, daddr;
-	u_int8_t tos;
-	const struct iphdr *iph;
-	int err;
-
-	nft_set_pktinfo(&pkt, skb, state);
-	nft_set_pktinfo_ipv4(&pkt, skb);
-
-	mark = skb->mark;
-	iph = ip_hdr(skb);
-	saddr = iph->saddr;
-	daddr = iph->daddr;
-	tos = iph->tos;
-
-	ret = nft_do_chain(&pkt, priv);
-	if (ret != NF_DROP && ret != NF_STOLEN) {
-		iph = ip_hdr(skb);
-
-		if (iph->saddr != saddr ||
-		    iph->daddr != daddr ||
-		    skb->mark != mark ||
-		    iph->tos != tos) {
-			err = ip_route_me_harder(state->net, skb, RTN_UNSPEC);
-			if (err < 0)
-				ret = NF_DROP_ERR(err);
-		}
-	}
-	return ret;
-}
-
-static const struct nft_chain_type nft_chain_route_ipv4 = {
-	.name		= "route",
-	.type		= NFT_CHAIN_T_ROUTE,
-	.family		= NFPROTO_IPV4,
-	.owner		= THIS_MODULE,
-	.hook_mask	= (1 << NF_INET_LOCAL_OUT),
-	.hooks		= {
-		[NF_INET_LOCAL_OUT]	= nf_route_table_hook,
-	},
-};
-
-static int __init nft_chain_route_init(void)
-{
-	nft_register_chain_type(&nft_chain_route_ipv4);
-
-	return 0;
-}
-
-static void __exit nft_chain_route_exit(void)
-{
-	nft_unregister_chain_type(&nft_chain_route_ipv4);
-}
-
-module_init(nft_chain_route_init);
-module_exit(nft_chain_route_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_ALIAS_NFT_CHAIN(AF_INET, "route");
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index ddc99a1653aa..3de3adb1a0c9 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -23,14 +23,6 @@ config NF_TABLES_IPV6
 
 if NF_TABLES_IPV6
 
-config NFT_CHAIN_ROUTE_IPV6
-	tristate "IPv6 nf_tables route chain support"
-	help
-	  This option enables the "route" chain for IPv6 in nf_tables. This
-	  chain type is used to force packet re-routing after mangling header
-	  fields such as the source, destination, flowlabel, hop-limit and
-	  the packet mark.
-
 config NFT_REJECT_IPV6
 	select NF_REJECT_IPV6
 	default NFT_REJECT
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index 3853c648ebaa..93aff604b243 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -27,7 +27,6 @@ obj-$(CONFIG_NF_REJECT_IPV6) += nf_reject_ipv6.o
 obj-$(CONFIG_NF_DUP_IPV6) += nf_dup_ipv6.o
 
 # nf_tables
-obj-$(CONFIG_NFT_CHAIN_ROUTE_IPV6) += nft_chain_route_ipv6.o
 obj-$(CONFIG_NFT_REJECT_IPV6) += nft_reject_ipv6.o
 obj-$(CONFIG_NFT_DUP_IPV6) += nft_dup_ipv6.o
 obj-$(CONFIG_NFT_FIB_IPV6) += nft_fib_ipv6.o
diff --git a/net/ipv6/netfilter/nft_chain_route_ipv6.c b/net/ipv6/netfilter/nft_chain_route_ipv6.c
deleted file mode 100644
index da3f1f8cb325..000000000000
--- a/net/ipv6/netfilter/nft_chain_route_ipv6.c
+++ /dev/null
@@ -1,91 +0,0 @@
-/*
- * Copyright (c) 2008 Patrick McHardy <kaber@trash.net>
- * Copyright (c) 2012 Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * Development of this code funded by Astaro AG (http://www.astaro.com/)
- */
-
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/list.h>
-#include <linux/skbuff.h>
-#include <linux/netlink.h>
-#include <linux/netfilter.h>
-#include <linux/netfilter_ipv6.h>
-#include <linux/netfilter/nfnetlink.h>
-#include <linux/netfilter/nf_tables.h>
-#include <net/netfilter/nf_tables.h>
-#include <net/netfilter/nf_tables_ipv6.h>
-#include <net/route.h>
-
-static unsigned int nf_route_table_hook(void *priv,
-					struct sk_buff *skb,
-					const struct nf_hook_state *state)
-{
-	unsigned int ret;
-	struct nft_pktinfo pkt;
-	struct in6_addr saddr, daddr;
-	u_int8_t hop_limit;
-	u32 mark, flowlabel;
-	int err;
-
-	nft_set_pktinfo(&pkt, skb, state);
-	nft_set_pktinfo_ipv6(&pkt, skb);
-
-	/* save source/dest address, mark, hoplimit, flowlabel, priority */
-	memcpy(&saddr, &ipv6_hdr(skb)->saddr, sizeof(saddr));
-	memcpy(&daddr, &ipv6_hdr(skb)->daddr, sizeof(daddr));
-	mark = skb->mark;
-	hop_limit = ipv6_hdr(skb)->hop_limit;
-
-	/* flowlabel and prio (includes version, which shouldn't change either */
-	flowlabel = *((u32 *)ipv6_hdr(skb));
-
-	ret = nft_do_chain(&pkt, priv);
-	if (ret != NF_DROP && ret != NF_STOLEN &&
-	    (memcmp(&ipv6_hdr(skb)->saddr, &saddr, sizeof(saddr)) ||
-	     memcmp(&ipv6_hdr(skb)->daddr, &daddr, sizeof(daddr)) ||
-	     skb->mark != mark ||
-	     ipv6_hdr(skb)->hop_limit != hop_limit ||
-	     flowlabel != *((u_int32_t *)ipv6_hdr(skb)))) {
-		err = ip6_route_me_harder(state->net, skb);
-		if (err < 0)
-			ret = NF_DROP_ERR(err);
-	}
-
-	return ret;
-}
-
-static const struct nft_chain_type nft_chain_route_ipv6 = {
-	.name		= "route",
-	.type		= NFT_CHAIN_T_ROUTE,
-	.family		= NFPROTO_IPV6,
-	.owner		= THIS_MODULE,
-	.hook_mask	= (1 << NF_INET_LOCAL_OUT),
-	.hooks		= {
-		[NF_INET_LOCAL_OUT]	= nf_route_table_hook,
-	},
-};
-
-static int __init nft_chain_route_init(void)
-{
-	nft_register_chain_type(&nft_chain_route_ipv6);
-
-	return 0;
-}
-
-static void __exit nft_chain_route_exit(void)
-{
-	nft_unregister_chain_type(&nft_chain_route_ipv6);
-}
-
-module_init(nft_chain_route_init);
-module_exit(nft_chain_route_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_ALIAS_NFT_CHAIN(AF_INET6, "route");
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 4894a85cdd0b..afbf475e02b2 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -77,7 +77,8 @@ obj-$(CONFIG_NF_DUP_NETDEV)	+= nf_dup_netdev.o
 nf_tables-objs := nf_tables_core.o nf_tables_api.o nft_chain_filter.o \
 		  nf_tables_trace.o nft_immediate.o nft_cmp.o nft_range.o \
 		  nft_bitwise.o nft_byteorder.o nft_payload.o nft_lookup.o \
-		  nft_dynset.o nft_meta.o nft_rt.o nft_exthdr.o
+		  nft_dynset.o nft_meta.o nft_rt.o nft_exthdr.o \
+		  nft_chain_route.o
 
 nf_tables_set-objs := nf_tables_set_core.o \
 		      nft_set_hash.o nft_set_bitmap.o nft_set_rbtree.o
diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 606d0a740615..84f5c90a7f21 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -926,20 +926,6 @@ nf_nat_ipv6_out(void *priv, struct sk_buff *skb,
 	return ret;
 }
 
-static int nat_route_me_harder(struct net *net, struct sk_buff *skb)
-{
-#ifdef CONFIG_IPV6_MODULE
-	const struct nf_ipv6_ops *v6_ops = nf_get_ipv6_ops();
-
-	if (!v6_ops)
-		return -EHOSTUNREACH;
-
-	return v6_ops->route_me_harder(net, skb);
-#else
-	return ip6_route_me_harder(net, skb);
-#endif
-}
-
 static unsigned int
 nf_nat_ipv6_local_fn(void *priv, struct sk_buff *skb,
 		     const struct nf_hook_state *state)
@@ -959,7 +945,7 @@ nf_nat_ipv6_local_fn(void *priv, struct sk_buff *skb,
 
 		if (!nf_inet_addr_cmp(&ct->tuplehash[dir].tuple.dst.u3,
 				      &ct->tuplehash[!dir].tuple.src.u3)) {
-			err = nat_route_me_harder(state->net, skb);
+			err = nf_ip6_route_me_harder(state->net, skb);
 			if (err < 0)
 				ret = NF_DROP_ERR(err);
 		}
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2d28b138ed18..a2bd439937e6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7530,6 +7530,7 @@ static int __init nf_tables_module_init(void)
 	if (err < 0)
 		goto err5;
 
+	nft_chain_route_init();
 	return err;
 err5:
 	rhltable_destroy(&nft_objname_ht);
@@ -7549,6 +7550,7 @@ static void __exit nf_tables_module_exit(void)
 	nfnetlink_subsys_unregister(&nf_tables_subsys);
 	unregister_netdevice_notifier(&nf_tables_flowtable_notifier);
 	nft_chain_filter_fini();
+	nft_chain_route_fini();
 	unregister_pernet_subsys(&nf_tables_net_ops);
 	cancel_work_sync(&trans_destroy_work);
 	rcu_barrier();
diff --git a/net/netfilter/nft_chain_route.c b/net/netfilter/nft_chain_route.c
new file mode 100644
index 000000000000..8826bbe71136
--- /dev/null
+++ b/net/netfilter/nft_chain_route.c
@@ -0,0 +1,169 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/skbuff.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/netfilter_ipv6.h>
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_ipv4.h>
+#include <net/netfilter/nf_tables_ipv6.h>
+#include <net/route.h>
+#include <net/ip.h>
+
+#ifdef CONFIG_NF_TABLES_IPV4
+static unsigned int nf_route_table_hook4(void *priv,
+					 struct sk_buff *skb,
+					 const struct nf_hook_state *state)
+{
+	const struct iphdr *iph;
+	struct nft_pktinfo pkt;
+	__be32 saddr, daddr;
+	unsigned int ret;
+	u32 mark;
+	int err;
+	u8 tos;
+
+	nft_set_pktinfo(&pkt, skb, state);
+	nft_set_pktinfo_ipv4(&pkt, skb);
+
+	mark = skb->mark;
+	iph = ip_hdr(skb);
+	saddr = iph->saddr;
+	daddr = iph->daddr;
+	tos = iph->tos;
+
+	ret = nft_do_chain(&pkt, priv);
+	if (ret == NF_ACCEPT) {
+		iph = ip_hdr(skb);
+
+		if (iph->saddr != saddr ||
+		    iph->daddr != daddr ||
+		    skb->mark != mark ||
+		    iph->tos != tos) {
+			err = ip_route_me_harder(state->net, skb, RTN_UNSPEC);
+			if (err < 0)
+				ret = NF_DROP_ERR(err);
+		}
+	}
+	return ret;
+}
+
+static const struct nft_chain_type nft_chain_route_ipv4 = {
+	.name		= "route",
+	.type		= NFT_CHAIN_T_ROUTE,
+	.family		= NFPROTO_IPV4,
+	.hook_mask	= (1 << NF_INET_LOCAL_OUT),
+	.hooks		= {
+		[NF_INET_LOCAL_OUT]	= nf_route_table_hook4,
+	},
+};
+#endif
+
+#ifdef CONFIG_NF_TABLES_IPV6
+static unsigned int nf_route_table_hook6(void *priv,
+					 struct sk_buff *skb,
+					 const struct nf_hook_state *state)
+{
+	struct in6_addr saddr, daddr;
+	struct nft_pktinfo pkt;
+	u32 mark, flowlabel;
+	unsigned int ret;
+	u8 hop_limit;
+	int err;
+
+	nft_set_pktinfo(&pkt, skb, state);
+	nft_set_pktinfo_ipv6(&pkt, skb);
+
+	/* save source/dest address, mark, hoplimit, flowlabel, priority */
+	memcpy(&saddr, &ipv6_hdr(skb)->saddr, sizeof(saddr));
+	memcpy(&daddr, &ipv6_hdr(skb)->daddr, sizeof(daddr));
+	mark = skb->mark;
+	hop_limit = ipv6_hdr(skb)->hop_limit;
+
+	/* flowlabel and prio (includes version, which shouldn't change either)*/
+	flowlabel = *((u32 *)ipv6_hdr(skb));
+
+	ret = nft_do_chain(&pkt, priv);
+	if (ret == NF_ACCEPT &&
+	    (memcmp(&ipv6_hdr(skb)->saddr, &saddr, sizeof(saddr)) ||
+	     memcmp(&ipv6_hdr(skb)->daddr, &daddr, sizeof(daddr)) ||
+	     skb->mark != mark ||
+	     ipv6_hdr(skb)->hop_limit != hop_limit ||
+	     flowlabel != *((u32 *)ipv6_hdr(skb)))) {
+		err = nf_ip6_route_me_harder(state->net, skb);
+		if (err < 0)
+			ret = NF_DROP_ERR(err);
+	}
+
+	return ret;
+}
+
+static const struct nft_chain_type nft_chain_route_ipv6 = {
+	.name		= "route",
+	.type		= NFT_CHAIN_T_ROUTE,
+	.family		= NFPROTO_IPV6,
+	.hook_mask	= (1 << NF_INET_LOCAL_OUT),
+	.hooks		= {
+		[NF_INET_LOCAL_OUT]	= nf_route_table_hook6,
+	},
+};
+#endif
+
+#ifdef CONFIG_NF_TABLES_INET
+static unsigned int nf_route_table_inet(void *priv,
+					struct sk_buff *skb,
+					const struct nf_hook_state *state)
+{
+	struct nft_pktinfo pkt;
+
+	switch (state->pf) {
+	case NFPROTO_IPV4:
+		return nf_route_table_hook4(priv, skb, state);
+	case NFPROTO_IPV6:
+		return nf_route_table_hook6(priv, skb, state);
+	default:
+		nft_set_pktinfo(&pkt, skb, state);
+		break;
+	}
+
+	return nft_do_chain(&pkt, priv);
+}
+
+static const struct nft_chain_type nft_chain_route_inet = {
+	.name		= "route",
+	.type		= NFT_CHAIN_T_ROUTE,
+	.family		= NFPROTO_INET,
+	.hook_mask	= (1 << NF_INET_LOCAL_OUT),
+	.hooks		= {
+		[NF_INET_LOCAL_OUT]	= nf_route_table_inet,
+	},
+};
+#endif
+
+void __init nft_chain_route_init(void)
+{
+#ifdef CONFIG_NF_TABLES_IPV6
+	nft_register_chain_type(&nft_chain_route_ipv6);
+#endif
+#ifdef CONFIG_NF_TABLES_IPV4
+	nft_register_chain_type(&nft_chain_route_ipv4);
+#endif
+#ifdef CONFIG_NF_TABLES_INET
+	nft_register_chain_type(&nft_chain_route_inet);
+#endif
+}
+
+void __exit nft_chain_route_fini(void)
+{
+#ifdef CONFIG_NF_TABLES_IPV6
+	nft_unregister_chain_type(&nft_chain_route_ipv6);
+#endif
+#ifdef CONFIG_NF_TABLES_IPV4
+	nft_unregister_chain_type(&nft_chain_route_ipv4);
+#endif
+#ifdef CONFIG_NF_TABLES_INET
+	nft_unregister_chain_type(&nft_chain_route_inet);
+#endif
+}
-- 
2.11.0

