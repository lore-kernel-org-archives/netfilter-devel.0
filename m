Return-Path: <SRS0=Sk6b=RF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5087FC4360F
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E8CD20838
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727214AbfCBSfU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Mar 2019 13:35:20 -0500
Received: from mail.us.es ([193.147.175.20]:35764 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727111AbfCBSfR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Mar 2019 13:35:17 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7A30F1361A4
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:35:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 49038DA867
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:35:14 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3AB7CDA876; Sat,  2 Mar 2019 19:35:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 74DA1DA86A;
        Sat,  2 Mar 2019 19:35:10 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 02 Mar 2019 19:35:10 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.223.53])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D790C4265A2F;
        Sat,  2 Mar 2019 19:35:09 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 06/29] netfilter: nat: merge nf_nat_ipv4,6 into nat core
Date:   Sat,  2 Mar 2019 19:34:34 +0100
Message-Id: <20190302183457.3079-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190302183457.3079-1-pablo@netfilter.org>
References: <20190302183457.3079-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

before:
   text    data     bss     dec     hex filename
  16566    1576    4136   22278    5706 nf_nat.ko
   3598	    844	      0	   4442	   115a	nf_nat_ipv6.ko
   3187	    844	      0	   4031	    fbf	nf_nat_ipv4.ko

after:
   text    data     bss     dec     hex filename
  22948    1612    4136   28696    7018 nf_nat.ko

... with ipv4/v6 nat now provided directly via nf_nat.ko.

Also changes:
       ret = nf_nat_ipv4_fn(priv, skb, state);
       if (ret != NF_DROP && ret != NF_STOLEN &&
into
	if (ret != NF_ACCEPT)
		return ret;

everywhere.

The nat hooks never should return anything other than
ACCEPT or DROP (and the latter only in rare error cases).

The original code uses multi-line ANDing including assignment-in-if:
        if (ret != NF_DROP && ret != NF_STOLEN &&
           !(IPCB(skb)->flags & IPSKB_XFRM_TRANSFORMED) &&
            (ct = nf_ct_get(skb, &ctinfo)) != NULL) {

I removed this while moving, breaking those in separate conditionals
and moving the assignments into extra lines.

checkpatch still generates some warnings:
 1. Overly long lines (of moved code).
    Breaking them is even more ugly. so I kept this as-is.
 2. use of extern function declarations in a .c file.
    This is necessary evil, we must call
    nf_nat_l3proto_register() from the nat core now.
    All l3proto related functions are removed later in this series,
    those prototypes are then removed as well.

v2: keep empty nf_nat_ipv6_csum_update stub for CONFIG_IPV6=n case.
v3: remove IS_ENABLED(NF_NAT_IPV4/6) tests, NF_NAT_IPVx toggles
    are removed here.
v4: also get rid of the assignments in conditionals.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/Kconfig               |  15 +-
 net/ipv4/netfilter/Makefile              |   3 -
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c | 330 ---------------
 net/ipv6/netfilter/Kconfig               |  15 +-
 net/ipv6/netfilter/Makefile              |   3 -
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c | 367 -----------------
 net/netfilter/Kconfig                    |   8 +-
 net/netfilter/nf_nat_core.c              |  17 +
 net/netfilter/nf_nat_proto.c             | 678 +++++++++++++++++++++++++++++++
 net/openvswitch/Kconfig                  |   2 -
 net/openvswitch/conntrack.c              |   8 +-
 tools/testing/selftests/net/config       |   3 +-
 12 files changed, 711 insertions(+), 738 deletions(-)
 delete mode 100644 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
 delete mode 100644 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index db05a835748a..8688461ed077 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -94,17 +94,7 @@ config NF_REJECT_IPV4
 	tristate "IPv4 packet rejection"
 	default m if NETFILTER_ADVANCED=n
 
-config NF_NAT_IPV4
-	tristate "IPv4 NAT"
-	depends on NF_CONNTRACK
-	default m if NETFILTER_ADVANCED=n
-	select NF_NAT
-	help
-	  The IPv4 NAT option allows masquerading, port forwarding and other
-	  forms of full Network Address Port Translation. This can be
-	  controlled by iptables or nft.
-
-if NF_NAT_IPV4
+if NF_NAT
 
 if NF_TABLES
 config NFT_CHAIN_NAT_IPV4
@@ -163,7 +153,7 @@ config NF_NAT_H323
 	depends on NF_CONNTRACK
 	default NF_CONNTRACK_H323
 
-endif # NF_NAT_IPV4
+endif # NF_NAT
 
 config IP_NF_IPTABLES
 	tristate "IP tables support (required for filtering/masq/NAT)"
@@ -260,7 +250,6 @@ config IP_NF_NAT
 	depends on NF_CONNTRACK
 	default m if NETFILTER_ADVANCED=n
 	select NF_NAT
-	select NF_NAT_IPV4
 	select NETFILTER_XT_NAT
 	help
 	  This enables the `nat' table in iptables. This allows masquerading,
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index ddeb35ab8bdb..b2cdf705fdf1 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -3,9 +3,6 @@
 # Makefile for the netfilter modules on top of IPv4.
 #
 
-nf_nat_ipv4-y		:= nf_nat_l3proto_ipv4.o
-obj-$(CONFIG_NF_NAT_IPV4) += nf_nat_ipv4.o
-
 # defrag
 obj-$(CONFIG_NF_DEFRAG_IPV4) += nf_defrag_ipv4.o
 
diff --git a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
deleted file mode 100644
index 36b4f9659ffa..000000000000
--- a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
+++ /dev/null
@@ -1,330 +0,0 @@
-/*
- * (C) 1999-2001 Paul `Rusty' Russell
- * (C) 2002-2006 Netfilter Core Team <coreteam@netfilter.org>
- * (C) 2011 Patrick McHardy <kaber@trash.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/types.h>
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/ip.h>
-#include <linux/icmp.h>
-#include <linux/netfilter.h>
-#include <linux/netfilter_ipv4.h>
-#include <net/secure_seq.h>
-#include <net/checksum.h>
-#include <net/route.h>
-#include <net/ip.h>
-
-#include <net/netfilter/nf_conntrack_core.h>
-#include <net/netfilter/nf_conntrack.h>
-#include <net/netfilter/nf_nat_core.h>
-#include <net/netfilter/nf_nat_l3proto.h>
-#include <net/netfilter/nf_nat_l4proto.h>
-
-static const struct nf_nat_l3proto nf_nat_l3proto_ipv4;
-
-static bool nf_nat_ipv4_manip_pkt(struct sk_buff *skb,
-				  unsigned int iphdroff,
-				  const struct nf_conntrack_tuple *target,
-				  enum nf_nat_manip_type maniptype)
-{
-	struct iphdr *iph;
-	unsigned int hdroff;
-
-	if (!skb_make_writable(skb, iphdroff + sizeof(*iph)))
-		return false;
-
-	iph = (void *)skb->data + iphdroff;
-	hdroff = iphdroff + iph->ihl * 4;
-
-	if (!nf_nat_l4proto_manip_pkt(skb, &nf_nat_l3proto_ipv4, iphdroff,
-				      hdroff, target, maniptype))
-		return false;
-	iph = (void *)skb->data + iphdroff;
-
-	if (maniptype == NF_NAT_MANIP_SRC) {
-		csum_replace4(&iph->check, iph->saddr, target->src.u3.ip);
-		iph->saddr = target->src.u3.ip;
-	} else {
-		csum_replace4(&iph->check, iph->daddr, target->dst.u3.ip);
-		iph->daddr = target->dst.u3.ip;
-	}
-	return true;
-}
-
-static void nf_nat_ipv4_csum_update(struct sk_buff *skb,
-				    unsigned int iphdroff, __sum16 *check,
-				    const struct nf_conntrack_tuple *t,
-				    enum nf_nat_manip_type maniptype)
-{
-	struct iphdr *iph = (struct iphdr *)(skb->data + iphdroff);
-	__be32 oldip, newip;
-
-	if (maniptype == NF_NAT_MANIP_SRC) {
-		oldip = iph->saddr;
-		newip = t->src.u3.ip;
-	} else {
-		oldip = iph->daddr;
-		newip = t->dst.u3.ip;
-	}
-	inet_proto_csum_replace4(check, skb, oldip, newip, true);
-}
-
-static void nf_nat_ipv4_csum_recalc(struct sk_buff *skb,
-				    u8 proto, void *data, __sum16 *check,
-				    int datalen, int oldlen)
-{
-	if (skb->ip_summed != CHECKSUM_PARTIAL) {
-		const struct iphdr *iph = ip_hdr(skb);
-
-		skb->ip_summed = CHECKSUM_PARTIAL;
-		skb->csum_start = skb_headroom(skb) + skb_network_offset(skb) +
-			ip_hdrlen(skb);
-		skb->csum_offset = (void *)check - data;
-		*check = ~csum_tcpudp_magic(iph->saddr, iph->daddr, datalen,
-					    proto, 0);
-	} else
-		inet_proto_csum_replace2(check, skb,
-					 htons(oldlen), htons(datalen), true);
-}
-
-static const struct nf_nat_l3proto nf_nat_l3proto_ipv4 = {
-	.l3proto		= NFPROTO_IPV4,
-	.manip_pkt		= nf_nat_ipv4_manip_pkt,
-	.csum_update		= nf_nat_ipv4_csum_update,
-	.csum_recalc		= nf_nat_ipv4_csum_recalc,
-};
-
-int nf_nat_icmp_reply_translation(struct sk_buff *skb,
-				  struct nf_conn *ct,
-				  enum ip_conntrack_info ctinfo,
-				  unsigned int hooknum)
-{
-	struct {
-		struct icmphdr	icmp;
-		struct iphdr	ip;
-	} *inside;
-	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
-	enum nf_nat_manip_type manip = HOOK2MANIP(hooknum);
-	unsigned int hdrlen = ip_hdrlen(skb);
-	struct nf_conntrack_tuple target;
-	unsigned long statusbit;
-
-	WARN_ON(ctinfo != IP_CT_RELATED && ctinfo != IP_CT_RELATED_REPLY);
-
-	if (!skb_make_writable(skb, hdrlen + sizeof(*inside)))
-		return 0;
-	if (nf_ip_checksum(skb, hooknum, hdrlen, 0))
-		return 0;
-
-	inside = (void *)skb->data + hdrlen;
-	if (inside->icmp.type == ICMP_REDIRECT) {
-		if ((ct->status & IPS_NAT_DONE_MASK) != IPS_NAT_DONE_MASK)
-			return 0;
-		if (ct->status & IPS_NAT_MASK)
-			return 0;
-	}
-
-	if (manip == NF_NAT_MANIP_SRC)
-		statusbit = IPS_SRC_NAT;
-	else
-		statusbit = IPS_DST_NAT;
-
-	/* Invert if this is reply direction */
-	if (dir == IP_CT_DIR_REPLY)
-		statusbit ^= IPS_NAT_MASK;
-
-	if (!(ct->status & statusbit))
-		return 1;
-
-	if (!nf_nat_ipv4_manip_pkt(skb, hdrlen + sizeof(inside->icmp),
-				   &ct->tuplehash[!dir].tuple, !manip))
-		return 0;
-
-	if (skb->ip_summed != CHECKSUM_PARTIAL) {
-		/* Reloading "inside" here since manip_pkt may reallocate */
-		inside = (void *)skb->data + hdrlen;
-		inside->icmp.checksum = 0;
-		inside->icmp.checksum =
-			csum_fold(skb_checksum(skb, hdrlen,
-					       skb->len - hdrlen, 0));
-	}
-
-	/* Change outer to look like the reply to an incoming packet */
-	nf_ct_invert_tuple(&target, &ct->tuplehash[!dir].tuple);
-	target.dst.protonum = IPPROTO_ICMP;
-	if (!nf_nat_ipv4_manip_pkt(skb, 0, &target, manip))
-		return 0;
-
-	return 1;
-}
-EXPORT_SYMBOL_GPL(nf_nat_icmp_reply_translation);
-
-static unsigned int
-nf_nat_ipv4_fn(void *priv, struct sk_buff *skb,
-	       const struct nf_hook_state *state)
-{
-	struct nf_conn *ct;
-	enum ip_conntrack_info ctinfo;
-
-	ct = nf_ct_get(skb, &ctinfo);
-	if (!ct)
-		return NF_ACCEPT;
-
-	if (ctinfo == IP_CT_RELATED || ctinfo == IP_CT_RELATED_REPLY) {
-		if (ip_hdr(skb)->protocol == IPPROTO_ICMP) {
-			if (!nf_nat_icmp_reply_translation(skb, ct, ctinfo,
-							   state->hook))
-				return NF_DROP;
-			else
-				return NF_ACCEPT;
-		}
-	}
-
-	return nf_nat_inet_fn(priv, skb, state);
-}
-
-static unsigned int
-nf_nat_ipv4_in(void *priv, struct sk_buff *skb,
-	       const struct nf_hook_state *state)
-{
-	unsigned int ret;
-	__be32 daddr = ip_hdr(skb)->daddr;
-
-	ret = nf_nat_ipv4_fn(priv, skb, state);
-	if (ret != NF_DROP && ret != NF_STOLEN &&
-	    daddr != ip_hdr(skb)->daddr)
-		skb_dst_drop(skb);
-
-	return ret;
-}
-
-static unsigned int
-nf_nat_ipv4_out(void *priv, struct sk_buff *skb,
-		const struct nf_hook_state *state)
-{
-#ifdef CONFIG_XFRM
-	const struct nf_conn *ct;
-	enum ip_conntrack_info ctinfo;
-	int err;
-#endif
-	unsigned int ret;
-
-	ret = nf_nat_ipv4_fn(priv, skb, state);
-#ifdef CONFIG_XFRM
-	if (ret != NF_DROP && ret != NF_STOLEN &&
-	    !(IPCB(skb)->flags & IPSKB_XFRM_TRANSFORMED) &&
-	    (ct = nf_ct_get(skb, &ctinfo)) != NULL) {
-		enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
-
-		if ((ct->tuplehash[dir].tuple.src.u3.ip !=
-		     ct->tuplehash[!dir].tuple.dst.u3.ip) ||
-		    (ct->tuplehash[dir].tuple.dst.protonum != IPPROTO_ICMP &&
-		     ct->tuplehash[dir].tuple.src.u.all !=
-		     ct->tuplehash[!dir].tuple.dst.u.all)) {
-			err = nf_xfrm_me_harder(state->net, skb, AF_INET);
-			if (err < 0)
-				ret = NF_DROP_ERR(err);
-		}
-	}
-#endif
-	return ret;
-}
-
-static unsigned int
-nf_nat_ipv4_local_fn(void *priv, struct sk_buff *skb,
-		     const struct nf_hook_state *state)
-{
-	const struct nf_conn *ct;
-	enum ip_conntrack_info ctinfo;
-	unsigned int ret;
-	int err;
-
-	ret = nf_nat_ipv4_fn(priv, skb, state);
-	if (ret != NF_DROP && ret != NF_STOLEN &&
-	    (ct = nf_ct_get(skb, &ctinfo)) != NULL) {
-		enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
-
-		if (ct->tuplehash[dir].tuple.dst.u3.ip !=
-		    ct->tuplehash[!dir].tuple.src.u3.ip) {
-			err = ip_route_me_harder(state->net, skb, RTN_UNSPEC);
-			if (err < 0)
-				ret = NF_DROP_ERR(err);
-		}
-#ifdef CONFIG_XFRM
-		else if (!(IPCB(skb)->flags & IPSKB_XFRM_TRANSFORMED) &&
-			 ct->tuplehash[dir].tuple.dst.protonum != IPPROTO_ICMP &&
-			 ct->tuplehash[dir].tuple.dst.u.all !=
-			 ct->tuplehash[!dir].tuple.src.u.all) {
-			err = nf_xfrm_me_harder(state->net, skb, AF_INET);
-			if (err < 0)
-				ret = NF_DROP_ERR(err);
-		}
-#endif
-	}
-	return ret;
-}
-
-static const struct nf_hook_ops nf_nat_ipv4_ops[] = {
-	/* Before packet filtering, change destination */
-	{
-		.hook		= nf_nat_ipv4_in,
-		.pf		= NFPROTO_IPV4,
-		.hooknum	= NF_INET_PRE_ROUTING,
-		.priority	= NF_IP_PRI_NAT_DST,
-	},
-	/* After packet filtering, change source */
-	{
-		.hook		= nf_nat_ipv4_out,
-		.pf		= NFPROTO_IPV4,
-		.hooknum	= NF_INET_POST_ROUTING,
-		.priority	= NF_IP_PRI_NAT_SRC,
-	},
-	/* Before packet filtering, change destination */
-	{
-		.hook		= nf_nat_ipv4_local_fn,
-		.pf		= NFPROTO_IPV4,
-		.hooknum	= NF_INET_LOCAL_OUT,
-		.priority	= NF_IP_PRI_NAT_DST,
-	},
-	/* After packet filtering, change source */
-	{
-		.hook		= nf_nat_ipv4_fn,
-		.pf		= NFPROTO_IPV4,
-		.hooknum	= NF_INET_LOCAL_IN,
-		.priority	= NF_IP_PRI_NAT_SRC,
-	},
-};
-
-int nf_nat_l3proto_ipv4_register_fn(struct net *net, const struct nf_hook_ops *ops)
-{
-	return nf_nat_register_fn(net, ops, nf_nat_ipv4_ops, ARRAY_SIZE(nf_nat_ipv4_ops));
-}
-EXPORT_SYMBOL_GPL(nf_nat_l3proto_ipv4_register_fn);
-
-void nf_nat_l3proto_ipv4_unregister_fn(struct net *net, const struct nf_hook_ops *ops)
-{
-	nf_nat_unregister_fn(net, ops, ARRAY_SIZE(nf_nat_ipv4_ops));
-}
-EXPORT_SYMBOL_GPL(nf_nat_l3proto_ipv4_unregister_fn);
-
-static int __init nf_nat_l3proto_ipv4_init(void)
-{
-	return nf_nat_l3proto_register(&nf_nat_l3proto_ipv4);
-}
-
-static void __exit nf_nat_l3proto_ipv4_exit(void)
-{
-	nf_nat_l3proto_unregister(&nf_nat_l3proto_ipv4);
-}
-
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("nf-nat-" __stringify(AF_INET));
-
-module_init(nf_nat_l3proto_ipv4_init);
-module_exit(nf_nat_l3proto_ipv4_exit);
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index f57fc99e9a04..a04a38166d8c 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -31,7 +31,7 @@ config NFT_CHAIN_ROUTE_IPV6
 	  fields such as the source, destination, flowlabel, hop-limit and
 	  the packet mark.
 
-if NF_NAT_IPV6
+if NF_NAT
 
 config NFT_CHAIN_NAT_IPV6
 	tristate "IPv6 nf_tables nat chain support"
@@ -57,7 +57,7 @@ config NFT_REDIR_IPV6
 	  This is the expression that provides IPv4 redirect support for
 	  nf_tables.
 
-endif # NF_NAT_IPV6
+endif # NF_NAT
 
 config NFT_REJECT_IPV6
 	select NF_REJECT_IPV6
@@ -106,16 +106,6 @@ config NF_LOG_IPV6
 	default m if NETFILTER_ADVANCED=n
 	select NF_LOG_COMMON
 
-config NF_NAT_IPV6
-	tristate "IPv6 NAT"
-	depends on NF_CONNTRACK
-	depends on NETFILTER_ADVANCED
-	select NF_NAT
-	help
-	  The IPv6 NAT option allows masquerading, port forwarding and other
-	  forms of full Network Address Port Translation. This can be
-	  controlled by iptables or nft.
-
 config IP6_NF_IPTABLES
 	tristate "IP6 tables support (required for filtering)"
 	depends on INET && IPV6
@@ -304,7 +294,6 @@ config IP6_NF_NAT
 	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
 	select NF_NAT
-	select NF_NAT_IPV6
 	select NETFILTER_XT_NAT
 	help
 	  This enables the `nat' table in ip6tables. This allows masquerading,
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index a7b18d13e056..afb880427133 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -11,9 +11,6 @@ obj-$(CONFIG_IP6_NF_RAW) += ip6table_raw.o
 obj-$(CONFIG_IP6_NF_SECURITY) += ip6table_security.o
 obj-$(CONFIG_IP6_NF_NAT) += ip6table_nat.o
 
-nf_nat_ipv6-y		:= nf_nat_l3proto_ipv6.o
-obj-$(CONFIG_NF_NAT_IPV6) += nf_nat_ipv6.o
-
 # defrag
 nf_defrag_ipv6-y := nf_defrag_ipv6_hooks.o nf_conntrack_reasm.o
 obj-$(CONFIG_NF_DEFRAG_IPV6) += nf_defrag_ipv6.o
diff --git a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
deleted file mode 100644
index 5d667cf9bab8..000000000000
--- a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
+++ /dev/null
@@ -1,367 +0,0 @@
-/*
- * Copyright (c) 2011 Patrick McHardy <kaber@trash.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * Development of IPv6 NAT funded by Astaro.
- */
-#include <linux/types.h>
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/ipv6.h>
-#include <linux/netfilter.h>
-#include <linux/netfilter_ipv6.h>
-#include <net/secure_seq.h>
-#include <net/checksum.h>
-#include <net/ip6_checksum.h>
-#include <net/ip6_route.h>
-#include <net/xfrm.h>
-#include <net/ipv6.h>
-
-#include <net/netfilter/nf_conntrack_core.h>
-#include <net/netfilter/nf_conntrack.h>
-#include <net/netfilter/nf_nat_core.h>
-#include <net/netfilter/nf_nat_l3proto.h>
-#include <net/netfilter/nf_nat_l4proto.h>
-
-static const struct nf_nat_l3proto nf_nat_l3proto_ipv6;
-
-static bool nf_nat_ipv6_manip_pkt(struct sk_buff *skb,
-				  unsigned int iphdroff,
-				  const struct nf_conntrack_tuple *target,
-				  enum nf_nat_manip_type maniptype)
-{
-	struct ipv6hdr *ipv6h;
-	__be16 frag_off;
-	int hdroff;
-	u8 nexthdr;
-
-	if (!skb_make_writable(skb, iphdroff + sizeof(*ipv6h)))
-		return false;
-
-	ipv6h = (void *)skb->data + iphdroff;
-	nexthdr = ipv6h->nexthdr;
-	hdroff = ipv6_skip_exthdr(skb, iphdroff + sizeof(*ipv6h),
-				  &nexthdr, &frag_off);
-	if (hdroff < 0)
-		goto manip_addr;
-
-	if ((frag_off & htons(~0x7)) == 0 &&
-	    !nf_nat_l4proto_manip_pkt(skb, &nf_nat_l3proto_ipv6, iphdroff, hdroff,
-				      target, maniptype))
-		return false;
-
-	/* must reload, offset might have changed */
-	ipv6h = (void *)skb->data + iphdroff;
-
-manip_addr:
-	if (maniptype == NF_NAT_MANIP_SRC)
-		ipv6h->saddr = target->src.u3.in6;
-	else
-		ipv6h->daddr = target->dst.u3.in6;
-
-	return true;
-}
-
-static void nf_nat_ipv6_csum_update(struct sk_buff *skb,
-				    unsigned int iphdroff, __sum16 *check,
-				    const struct nf_conntrack_tuple *t,
-				    enum nf_nat_manip_type maniptype)
-{
-	const struct ipv6hdr *ipv6h = (struct ipv6hdr *)(skb->data + iphdroff);
-	const struct in6_addr *oldip, *newip;
-
-	if (maniptype == NF_NAT_MANIP_SRC) {
-		oldip = &ipv6h->saddr;
-		newip = &t->src.u3.in6;
-	} else {
-		oldip = &ipv6h->daddr;
-		newip = &t->dst.u3.in6;
-	}
-	inet_proto_csum_replace16(check, skb, oldip->s6_addr32,
-				  newip->s6_addr32, true);
-}
-
-static void nf_nat_ipv6_csum_recalc(struct sk_buff *skb,
-				    u8 proto, void *data, __sum16 *check,
-				    int datalen, int oldlen)
-{
-	if (skb->ip_summed != CHECKSUM_PARTIAL) {
-		const struct ipv6hdr *ipv6h = ipv6_hdr(skb);
-
-		skb->ip_summed = CHECKSUM_PARTIAL;
-		skb->csum_start = skb_headroom(skb) + skb_network_offset(skb) +
-			(data - (void *)skb->data);
-		skb->csum_offset = (void *)check - data;
-		*check = ~csum_ipv6_magic(&ipv6h->saddr, &ipv6h->daddr,
-					  datalen, proto, 0);
-	} else
-		inet_proto_csum_replace2(check, skb,
-					 htons(oldlen), htons(datalen), true);
-}
-
-static const struct nf_nat_l3proto nf_nat_l3proto_ipv6 = {
-	.l3proto		= NFPROTO_IPV6,
-	.manip_pkt		= nf_nat_ipv6_manip_pkt,
-	.csum_update		= nf_nat_ipv6_csum_update,
-	.csum_recalc		= nf_nat_ipv6_csum_recalc,
-};
-
-int nf_nat_icmpv6_reply_translation(struct sk_buff *skb,
-				    struct nf_conn *ct,
-				    enum ip_conntrack_info ctinfo,
-				    unsigned int hooknum,
-				    unsigned int hdrlen)
-{
-	struct {
-		struct icmp6hdr	icmp6;
-		struct ipv6hdr	ip6;
-	} *inside;
-	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
-	enum nf_nat_manip_type manip = HOOK2MANIP(hooknum);
-	struct nf_conntrack_tuple target;
-	unsigned long statusbit;
-
-	WARN_ON(ctinfo != IP_CT_RELATED && ctinfo != IP_CT_RELATED_REPLY);
-
-	if (!skb_make_writable(skb, hdrlen + sizeof(*inside)))
-		return 0;
-	if (nf_ip6_checksum(skb, hooknum, hdrlen, IPPROTO_ICMPV6))
-		return 0;
-
-	inside = (void *)skb->data + hdrlen;
-	if (inside->icmp6.icmp6_type == NDISC_REDIRECT) {
-		if ((ct->status & IPS_NAT_DONE_MASK) != IPS_NAT_DONE_MASK)
-			return 0;
-		if (ct->status & IPS_NAT_MASK)
-			return 0;
-	}
-
-	if (manip == NF_NAT_MANIP_SRC)
-		statusbit = IPS_SRC_NAT;
-	else
-		statusbit = IPS_DST_NAT;
-
-	/* Invert if this is reply direction */
-	if (dir == IP_CT_DIR_REPLY)
-		statusbit ^= IPS_NAT_MASK;
-
-	if (!(ct->status & statusbit))
-		return 1;
-
-	if (!nf_nat_ipv6_manip_pkt(skb, hdrlen + sizeof(inside->icmp6),
-				   &ct->tuplehash[!dir].tuple, !manip))
-		return 0;
-
-	if (skb->ip_summed != CHECKSUM_PARTIAL) {
-		struct ipv6hdr *ipv6h = ipv6_hdr(skb);
-		inside = (void *)skb->data + hdrlen;
-		inside->icmp6.icmp6_cksum = 0;
-		inside->icmp6.icmp6_cksum =
-			csum_ipv6_magic(&ipv6h->saddr, &ipv6h->daddr,
-					skb->len - hdrlen, IPPROTO_ICMPV6,
-					skb_checksum(skb, hdrlen,
-						     skb->len - hdrlen, 0));
-	}
-
-	nf_ct_invert_tuple(&target, &ct->tuplehash[!dir].tuple);
-	target.dst.protonum = IPPROTO_ICMPV6;
-	if (!nf_nat_ipv6_manip_pkt(skb, 0, &target, manip))
-		return 0;
-
-	return 1;
-}
-EXPORT_SYMBOL_GPL(nf_nat_icmpv6_reply_translation);
-
-static unsigned int
-nf_nat_ipv6_fn(void *priv, struct sk_buff *skb,
-	       const struct nf_hook_state *state)
-{
-	struct nf_conn *ct;
-	enum ip_conntrack_info ctinfo;
-	__be16 frag_off;
-	int hdrlen;
-	u8 nexthdr;
-
-	ct = nf_ct_get(skb, &ctinfo);
-	/* Can't track?  It's not due to stress, or conntrack would
-	 * have dropped it.  Hence it's the user's responsibilty to
-	 * packet filter it out, or implement conntrack/NAT for that
-	 * protocol. 8) --RR
-	 */
-	if (!ct)
-		return NF_ACCEPT;
-
-	if (ctinfo == IP_CT_RELATED || ctinfo == IP_CT_RELATED_REPLY) {
-		nexthdr = ipv6_hdr(skb)->nexthdr;
-		hdrlen = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr),
-					  &nexthdr, &frag_off);
-
-		if (hdrlen >= 0 && nexthdr == IPPROTO_ICMPV6) {
-			if (!nf_nat_icmpv6_reply_translation(skb, ct, ctinfo,
-							     state->hook,
-							     hdrlen))
-				return NF_DROP;
-			else
-				return NF_ACCEPT;
-		}
-	}
-
-	return nf_nat_inet_fn(priv, skb, state);
-}
-
-static unsigned int
-nf_nat_ipv6_in(void *priv, struct sk_buff *skb,
-	       const struct nf_hook_state *state)
-{
-	unsigned int ret;
-	struct in6_addr daddr = ipv6_hdr(skb)->daddr;
-
-	ret = nf_nat_ipv6_fn(priv, skb, state);
-	if (ret != NF_DROP && ret != NF_STOLEN &&
-	    ipv6_addr_cmp(&daddr, &ipv6_hdr(skb)->daddr))
-		skb_dst_drop(skb);
-
-	return ret;
-}
-
-static unsigned int
-nf_nat_ipv6_out(void *priv, struct sk_buff *skb,
-		const struct nf_hook_state *state)
-{
-#ifdef CONFIG_XFRM
-	const struct nf_conn *ct;
-	enum ip_conntrack_info ctinfo;
-	int err;
-#endif
-	unsigned int ret;
-
-	ret = nf_nat_ipv6_fn(priv, skb, state);
-#ifdef CONFIG_XFRM
-	if (ret != NF_DROP && ret != NF_STOLEN &&
-	    !(IP6CB(skb)->flags & IP6SKB_XFRM_TRANSFORMED) &&
-	    (ct = nf_ct_get(skb, &ctinfo)) != NULL) {
-		enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
-
-		if (!nf_inet_addr_cmp(&ct->tuplehash[dir].tuple.src.u3,
-				      &ct->tuplehash[!dir].tuple.dst.u3) ||
-		    (ct->tuplehash[dir].tuple.dst.protonum != IPPROTO_ICMPV6 &&
-		     ct->tuplehash[dir].tuple.src.u.all !=
-		     ct->tuplehash[!dir].tuple.dst.u.all)) {
-			err = nf_xfrm_me_harder(state->net, skb, AF_INET6);
-			if (err < 0)
-				ret = NF_DROP_ERR(err);
-		}
-	}
-#endif
-	return ret;
-}
-
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
-static unsigned int
-nf_nat_ipv6_local_fn(void *priv, struct sk_buff *skb,
-		     const struct nf_hook_state *state)
-{
-	const struct nf_conn *ct;
-	enum ip_conntrack_info ctinfo;
-	unsigned int ret;
-	int err;
-
-	ret = nf_nat_ipv6_fn(priv, skb, state);
-	if (ret != NF_DROP && ret != NF_STOLEN &&
-	    (ct = nf_ct_get(skb, &ctinfo)) != NULL) {
-		enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
-
-		if (!nf_inet_addr_cmp(&ct->tuplehash[dir].tuple.dst.u3,
-				      &ct->tuplehash[!dir].tuple.src.u3)) {
-			err = nat_route_me_harder(state->net, skb);
-			if (err < 0)
-				ret = NF_DROP_ERR(err);
-		}
-#ifdef CONFIG_XFRM
-		else if (!(IP6CB(skb)->flags & IP6SKB_XFRM_TRANSFORMED) &&
-			 ct->tuplehash[dir].tuple.dst.protonum != IPPROTO_ICMPV6 &&
-			 ct->tuplehash[dir].tuple.dst.u.all !=
-			 ct->tuplehash[!dir].tuple.src.u.all) {
-			err = nf_xfrm_me_harder(state->net, skb, AF_INET6);
-			if (err < 0)
-				ret = NF_DROP_ERR(err);
-		}
-#endif
-	}
-	return ret;
-}
-
-static const struct nf_hook_ops nf_nat_ipv6_ops[] = {
-	/* Before packet filtering, change destination */
-	{
-		.hook		= nf_nat_ipv6_in,
-		.pf		= NFPROTO_IPV6,
-		.hooknum	= NF_INET_PRE_ROUTING,
-		.priority	= NF_IP6_PRI_NAT_DST,
-	},
-	/* After packet filtering, change source */
-	{
-		.hook		= nf_nat_ipv6_out,
-		.pf		= NFPROTO_IPV6,
-		.hooknum	= NF_INET_POST_ROUTING,
-		.priority	= NF_IP6_PRI_NAT_SRC,
-	},
-	/* Before packet filtering, change destination */
-	{
-		.hook		= nf_nat_ipv6_local_fn,
-		.pf		= NFPROTO_IPV6,
-		.hooknum	= NF_INET_LOCAL_OUT,
-		.priority	= NF_IP6_PRI_NAT_DST,
-	},
-	/* After packet filtering, change source */
-	{
-		.hook		= nf_nat_ipv6_fn,
-		.pf		= NFPROTO_IPV6,
-		.hooknum	= NF_INET_LOCAL_IN,
-		.priority	= NF_IP6_PRI_NAT_SRC,
-	},
-};
-
-int nf_nat_l3proto_ipv6_register_fn(struct net *net, const struct nf_hook_ops *ops)
-{
-	return nf_nat_register_fn(net, ops, nf_nat_ipv6_ops, ARRAY_SIZE(nf_nat_ipv6_ops));
-}
-EXPORT_SYMBOL_GPL(nf_nat_l3proto_ipv6_register_fn);
-
-void nf_nat_l3proto_ipv6_unregister_fn(struct net *net, const struct nf_hook_ops *ops)
-{
-	nf_nat_unregister_fn(net, ops, ARRAY_SIZE(nf_nat_ipv6_ops));
-}
-EXPORT_SYMBOL_GPL(nf_nat_l3proto_ipv6_unregister_fn);
-
-static int __init nf_nat_l3proto_ipv6_init(void)
-{
-	return nf_nat_l3proto_register(&nf_nat_l3proto_ipv6);
-}
-
-static void __exit nf_nat_l3proto_ipv6_exit(void)
-{
-	nf_nat_l3proto_unregister(&nf_nat_l3proto_ipv6);
-}
-
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("nf-nat-" __stringify(AF_INET6));
-
-module_init(nf_nat_l3proto_ipv6_init);
-module_exit(nf_nat_l3proto_ipv6_exit);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 5a753cec005b..5beb51d39dc2 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -396,7 +396,13 @@ config NETFILTER_NETLINK_GLUE_CT
 	  the enqueued via NFNETLINK.
 
 config NF_NAT
-	tristate
+	tristate "Network Address Translation support"
+	depends on NF_CONNTRACK
+	default m if NETFILTER_ADVANCED=n
+	help
+	  The NAT option allows masquerading, port forwarding and other
+	  forms of full Network Address Port Translation. This can be
+	  controlled by iptables, ip6tables or nft.
 
 config NF_NAT_NEEDED
 	bool
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 0f39ae7a9f34..0c548ff215b2 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1203,6 +1203,8 @@ static struct nf_nat_hook nat_hook = {
 	.manip_pkt		= nf_nat_manip_pkt,
 };
 
+int nf_nat_l3proto_init(void);
+void nf_nat_l3proto_exit(void);
 static int __init nf_nat_init(void)
 {
 	int ret, i;
@@ -1237,6 +1239,19 @@ static int __init nf_nat_init(void)
 	WARN_ON(nf_nat_hook != NULL);
 	RCU_INIT_POINTER(nf_nat_hook, &nat_hook);
 
+	ret = nf_nat_l3proto_init();
+	if (ret) {
+		nf_ct_extend_unregister(&nat_extend);
+		nf_ct_helper_expectfn_unregister(&follow_master_nat);
+		RCU_INIT_POINTER(nf_nat_hook, NULL);
+
+		synchronize_net();
+		kvfree(nf_nat_bysource);
+		unregister_pernet_subsys(&nat_net_ops);
+
+		return ret;
+	}
+
 	return 0;
 }
 
@@ -1246,6 +1261,8 @@ static void __exit nf_nat_cleanup(void)
 
 	nf_ct_iterate_destroy(nf_nat_proto_clean, &clean);
 
+	nf_nat_l3proto_exit();
+
 	nf_ct_extend_unregister(&nat_extend);
 	nf_ct_helper_expectfn_unregister(&follow_master_nat);
 	RCU_INIT_POINTER(nf_nat_hook, NULL);
diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index f83bf9d8c9f5..9c4db18741ef 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -24,6 +24,22 @@
 #include <net/netfilter/nf_nat_l3proto.h>
 #include <net/netfilter/nf_nat_l4proto.h>
 
+#include <linux/ipv6.h>
+#include <linux/netfilter_ipv6.h>
+#include <net/checksum.h>
+#include <net/ip6_checksum.h>
+#include <net/ip6_route.h>
+#include <net/xfrm.h>
+#include <net/ipv6.h>
+
+#include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack.h>
+
+static const struct nf_nat_l3proto nf_nat_l3proto_ipv4;
+#if IS_ENABLED(CONFIG_IPV6)
+static const struct nf_nat_l3proto nf_nat_l3proto_ipv6;
+#endif
+
 static void
 __udp_manip_pkt(struct sk_buff *skb,
 	        const struct nf_nat_l3proto *l3proto,
@@ -341,3 +357,665 @@ bool nf_nat_l4proto_manip_pkt(struct sk_buff *skb,
 	return true;
 }
 EXPORT_SYMBOL_GPL(nf_nat_l4proto_manip_pkt);
+
+static bool nf_nat_ipv4_manip_pkt(struct sk_buff *skb,
+				  unsigned int iphdroff,
+				  const struct nf_conntrack_tuple *target,
+				  enum nf_nat_manip_type maniptype)
+{
+	struct iphdr *iph;
+	unsigned int hdroff;
+
+	if (!skb_make_writable(skb, iphdroff + sizeof(*iph)))
+		return false;
+
+	iph = (void *)skb->data + iphdroff;
+	hdroff = iphdroff + iph->ihl * 4;
+
+	if (!nf_nat_l4proto_manip_pkt(skb, &nf_nat_l3proto_ipv4, iphdroff,
+				      hdroff, target, maniptype))
+		return false;
+	iph = (void *)skb->data + iphdroff;
+
+	if (maniptype == NF_NAT_MANIP_SRC) {
+		csum_replace4(&iph->check, iph->saddr, target->src.u3.ip);
+		iph->saddr = target->src.u3.ip;
+	} else {
+		csum_replace4(&iph->check, iph->daddr, target->dst.u3.ip);
+		iph->daddr = target->dst.u3.ip;
+	}
+	return true;
+}
+
+static bool nf_nat_ipv6_manip_pkt(struct sk_buff *skb,
+				  unsigned int iphdroff,
+				  const struct nf_conntrack_tuple *target,
+				  enum nf_nat_manip_type maniptype)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	struct ipv6hdr *ipv6h;
+	__be16 frag_off;
+	int hdroff;
+	u8 nexthdr;
+
+	if (!skb_make_writable(skb, iphdroff + sizeof(*ipv6h)))
+		return false;
+
+	ipv6h = (void *)skb->data + iphdroff;
+	nexthdr = ipv6h->nexthdr;
+	hdroff = ipv6_skip_exthdr(skb, iphdroff + sizeof(*ipv6h),
+				  &nexthdr, &frag_off);
+	if (hdroff < 0)
+		goto manip_addr;
+
+	if ((frag_off & htons(~0x7)) == 0 &&
+	    !nf_nat_l4proto_manip_pkt(skb, &nf_nat_l3proto_ipv6, iphdroff, hdroff,
+				      target, maniptype))
+		return false;
+
+	/* must reload, offset might have changed */
+	ipv6h = (void *)skb->data + iphdroff;
+
+manip_addr:
+	if (maniptype == NF_NAT_MANIP_SRC)
+		ipv6h->saddr = target->src.u3.in6;
+	else
+		ipv6h->daddr = target->dst.u3.in6;
+
+#endif
+	return true;
+}
+
+static void nf_nat_ipv4_csum_update(struct sk_buff *skb,
+				    unsigned int iphdroff, __sum16 *check,
+				    const struct nf_conntrack_tuple *t,
+				    enum nf_nat_manip_type maniptype)
+{
+	struct iphdr *iph = (struct iphdr *)(skb->data + iphdroff);
+	__be32 oldip, newip;
+
+	if (maniptype == NF_NAT_MANIP_SRC) {
+		oldip = iph->saddr;
+		newip = t->src.u3.ip;
+	} else {
+		oldip = iph->daddr;
+		newip = t->dst.u3.ip;
+	}
+	inet_proto_csum_replace4(check, skb, oldip, newip, true);
+}
+
+static void nf_nat_ipv6_csum_update(struct sk_buff *skb,
+				    unsigned int iphdroff, __sum16 *check,
+				    const struct nf_conntrack_tuple *t,
+				    enum nf_nat_manip_type maniptype)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	const struct ipv6hdr *ipv6h = (struct ipv6hdr *)(skb->data + iphdroff);
+	const struct in6_addr *oldip, *newip;
+
+	if (maniptype == NF_NAT_MANIP_SRC) {
+		oldip = &ipv6h->saddr;
+		newip = &t->src.u3.in6;
+	} else {
+		oldip = &ipv6h->daddr;
+		newip = &t->dst.u3.in6;
+	}
+	inet_proto_csum_replace16(check, skb, oldip->s6_addr32,
+				  newip->s6_addr32, true);
+#endif
+}
+
+static void nf_nat_ipv4_csum_recalc(struct sk_buff *skb,
+				    u8 proto, void *data, __sum16 *check,
+				    int datalen, int oldlen)
+{
+	if (skb->ip_summed != CHECKSUM_PARTIAL) {
+		const struct iphdr *iph = ip_hdr(skb);
+
+		skb->ip_summed = CHECKSUM_PARTIAL;
+		skb->csum_start = skb_headroom(skb) + skb_network_offset(skb) +
+			ip_hdrlen(skb);
+		skb->csum_offset = (void *)check - data;
+		*check = ~csum_tcpudp_magic(iph->saddr, iph->daddr, datalen,
+					    proto, 0);
+	} else {
+		inet_proto_csum_replace2(check, skb,
+					 htons(oldlen), htons(datalen), true);
+	}
+}
+
+#if IS_ENABLED(CONFIG_IPV6)
+static void nf_nat_ipv6_csum_recalc(struct sk_buff *skb,
+				    u8 proto, void *data, __sum16 *check,
+				    int datalen, int oldlen)
+{
+	if (skb->ip_summed != CHECKSUM_PARTIAL) {
+		const struct ipv6hdr *ipv6h = ipv6_hdr(skb);
+
+		skb->ip_summed = CHECKSUM_PARTIAL;
+		skb->csum_start = skb_headroom(skb) + skb_network_offset(skb) +
+			(data - (void *)skb->data);
+		skb->csum_offset = (void *)check - data;
+		*check = ~csum_ipv6_magic(&ipv6h->saddr, &ipv6h->daddr,
+					  datalen, proto, 0);
+	} else {
+		inet_proto_csum_replace2(check, skb,
+					 htons(oldlen), htons(datalen), true);
+	}
+}
+#endif
+
+static const struct nf_nat_l3proto nf_nat_l3proto_ipv4 = {
+	.l3proto		= NFPROTO_IPV4,
+	.manip_pkt		= nf_nat_ipv4_manip_pkt,
+	.csum_update		= nf_nat_ipv4_csum_update,
+	.csum_recalc		= nf_nat_ipv4_csum_recalc,
+};
+
+int nf_nat_icmp_reply_translation(struct sk_buff *skb,
+				  struct nf_conn *ct,
+				  enum ip_conntrack_info ctinfo,
+				  unsigned int hooknum)
+{
+	struct {
+		struct icmphdr	icmp;
+		struct iphdr	ip;
+	} *inside;
+	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
+	enum nf_nat_manip_type manip = HOOK2MANIP(hooknum);
+	unsigned int hdrlen = ip_hdrlen(skb);
+	struct nf_conntrack_tuple target;
+	unsigned long statusbit;
+
+	WARN_ON(ctinfo != IP_CT_RELATED && ctinfo != IP_CT_RELATED_REPLY);
+
+	if (!skb_make_writable(skb, hdrlen + sizeof(*inside)))
+		return 0;
+	if (nf_ip_checksum(skb, hooknum, hdrlen, 0))
+		return 0;
+
+	inside = (void *)skb->data + hdrlen;
+	if (inside->icmp.type == ICMP_REDIRECT) {
+		if ((ct->status & IPS_NAT_DONE_MASK) != IPS_NAT_DONE_MASK)
+			return 0;
+		if (ct->status & IPS_NAT_MASK)
+			return 0;
+	}
+
+	if (manip == NF_NAT_MANIP_SRC)
+		statusbit = IPS_SRC_NAT;
+	else
+		statusbit = IPS_DST_NAT;
+
+	/* Invert if this is reply direction */
+	if (dir == IP_CT_DIR_REPLY)
+		statusbit ^= IPS_NAT_MASK;
+
+	if (!(ct->status & statusbit))
+		return 1;
+
+	if (!nf_nat_ipv4_manip_pkt(skb, hdrlen + sizeof(inside->icmp),
+				   &ct->tuplehash[!dir].tuple, !manip))
+		return 0;
+
+	if (skb->ip_summed != CHECKSUM_PARTIAL) {
+		/* Reloading "inside" here since manip_pkt may reallocate */
+		inside = (void *)skb->data + hdrlen;
+		inside->icmp.checksum = 0;
+		inside->icmp.checksum =
+			csum_fold(skb_checksum(skb, hdrlen,
+					       skb->len - hdrlen, 0));
+	}
+
+	/* Change outer to look like the reply to an incoming packet */
+	nf_ct_invert_tuple(&target, &ct->tuplehash[!dir].tuple);
+	target.dst.protonum = IPPROTO_ICMP;
+	if (!nf_nat_ipv4_manip_pkt(skb, 0, &target, manip))
+		return 0;
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(nf_nat_icmp_reply_translation);
+
+static unsigned int
+nf_nat_ipv4_fn(void *priv, struct sk_buff *skb,
+	       const struct nf_hook_state *state)
+{
+	struct nf_conn *ct;
+	enum ip_conntrack_info ctinfo;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct)
+		return NF_ACCEPT;
+
+	if (ctinfo == IP_CT_RELATED || ctinfo == IP_CT_RELATED_REPLY) {
+		if (ip_hdr(skb)->protocol == IPPROTO_ICMP) {
+			if (!nf_nat_icmp_reply_translation(skb, ct, ctinfo,
+							   state->hook))
+				return NF_DROP;
+			else
+				return NF_ACCEPT;
+		}
+	}
+
+	return nf_nat_inet_fn(priv, skb, state);
+}
+
+static unsigned int
+nf_nat_ipv4_in(void *priv, struct sk_buff *skb,
+	       const struct nf_hook_state *state)
+{
+	unsigned int ret;
+	__be32 daddr = ip_hdr(skb)->daddr;
+
+	ret = nf_nat_ipv4_fn(priv, skb, state);
+	if (ret == NF_ACCEPT && daddr != ip_hdr(skb)->daddr)
+		skb_dst_drop(skb);
+
+	return ret;
+}
+
+static unsigned int
+nf_nat_ipv4_out(void *priv, struct sk_buff *skb,
+		const struct nf_hook_state *state)
+{
+#ifdef CONFIG_XFRM
+	const struct nf_conn *ct;
+	enum ip_conntrack_info ctinfo;
+	int err;
+#endif
+	unsigned int ret;
+
+	ret = nf_nat_ipv4_fn(priv, skb, state);
+#ifdef CONFIG_XFRM
+	if (ret != NF_ACCEPT)
+		return ret;
+
+	if (IPCB(skb)->flags & IPSKB_XFRM_TRANSFORMED)
+		return ret;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct) {
+		enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
+
+		if (ct->tuplehash[dir].tuple.src.u3.ip !=
+		     ct->tuplehash[!dir].tuple.dst.u3.ip ||
+		    (ct->tuplehash[dir].tuple.dst.protonum != IPPROTO_ICMP &&
+		     ct->tuplehash[dir].tuple.src.u.all !=
+		     ct->tuplehash[!dir].tuple.dst.u.all)) {
+			err = nf_xfrm_me_harder(state->net, skb, AF_INET);
+			if (err < 0)
+				ret = NF_DROP_ERR(err);
+		}
+	}
+#endif
+	return ret;
+}
+
+static unsigned int
+nf_nat_ipv4_local_fn(void *priv, struct sk_buff *skb,
+		     const struct nf_hook_state *state)
+{
+	const struct nf_conn *ct;
+	enum ip_conntrack_info ctinfo;
+	unsigned int ret;
+	int err;
+
+	ret = nf_nat_ipv4_fn(priv, skb, state);
+	if (ret != NF_ACCEPT)
+		return ret;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct) {
+		enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
+
+		if (ct->tuplehash[dir].tuple.dst.u3.ip !=
+		    ct->tuplehash[!dir].tuple.src.u3.ip) {
+			err = ip_route_me_harder(state->net, skb, RTN_UNSPEC);
+			if (err < 0)
+				ret = NF_DROP_ERR(err);
+		}
+#ifdef CONFIG_XFRM
+		else if (!(IPCB(skb)->flags & IPSKB_XFRM_TRANSFORMED) &&
+			 ct->tuplehash[dir].tuple.dst.protonum != IPPROTO_ICMP &&
+			 ct->tuplehash[dir].tuple.dst.u.all !=
+			 ct->tuplehash[!dir].tuple.src.u.all) {
+			err = nf_xfrm_me_harder(state->net, skb, AF_INET);
+			if (err < 0)
+				ret = NF_DROP_ERR(err);
+		}
+#endif
+	}
+	return ret;
+}
+
+static const struct nf_hook_ops nf_nat_ipv4_ops[] = {
+	/* Before packet filtering, change destination */
+	{
+		.hook		= nf_nat_ipv4_in,
+		.pf		= NFPROTO_IPV4,
+		.hooknum	= NF_INET_PRE_ROUTING,
+		.priority	= NF_IP_PRI_NAT_DST,
+	},
+	/* After packet filtering, change source */
+	{
+		.hook		= nf_nat_ipv4_out,
+		.pf		= NFPROTO_IPV4,
+		.hooknum	= NF_INET_POST_ROUTING,
+		.priority	= NF_IP_PRI_NAT_SRC,
+	},
+	/* Before packet filtering, change destination */
+	{
+		.hook		= nf_nat_ipv4_local_fn,
+		.pf		= NFPROTO_IPV4,
+		.hooknum	= NF_INET_LOCAL_OUT,
+		.priority	= NF_IP_PRI_NAT_DST,
+	},
+	/* After packet filtering, change source */
+	{
+		.hook		= nf_nat_ipv4_fn,
+		.pf		= NFPROTO_IPV4,
+		.hooknum	= NF_INET_LOCAL_IN,
+		.priority	= NF_IP_PRI_NAT_SRC,
+	},
+};
+
+int nf_nat_l3proto_ipv4_register_fn(struct net *net, const struct nf_hook_ops *ops)
+{
+	return nf_nat_register_fn(net, ops, nf_nat_ipv4_ops, ARRAY_SIZE(nf_nat_ipv4_ops));
+}
+EXPORT_SYMBOL_GPL(nf_nat_l3proto_ipv4_register_fn);
+
+void nf_nat_l3proto_ipv4_unregister_fn(struct net *net, const struct nf_hook_ops *ops)
+{
+	nf_nat_unregister_fn(net, ops, ARRAY_SIZE(nf_nat_ipv4_ops));
+}
+EXPORT_SYMBOL_GPL(nf_nat_l3proto_ipv4_unregister_fn);
+
+int nf_nat_l3proto_init(void)
+{
+	int ret = nf_nat_l3proto_register(&nf_nat_l3proto_ipv4);
+
+#if IS_ENABLED(CONFIG_IPV6)
+	if (ret)
+		return ret;
+
+	ret = nf_nat_l3proto_register(&nf_nat_l3proto_ipv6);
+	if (ret == 0)
+		return ret;
+
+	nf_nat_l3proto_unregister(&nf_nat_l3proto_ipv4);
+#endif
+	return ret;
+}
+
+void nf_nat_l3proto_exit(void)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	nf_nat_l3proto_unregister(&nf_nat_l3proto_ipv6);
+#endif
+	nf_nat_l3proto_unregister(&nf_nat_l3proto_ipv4);
+}
+
+#if IS_ENABLED(CONFIG_IPV6)
+static const struct nf_nat_l3proto nf_nat_l3proto_ipv6;
+
+static const struct nf_nat_l3proto nf_nat_l3proto_ipv6 = {
+	.l3proto		= NFPROTO_IPV6,
+	.manip_pkt		= nf_nat_ipv6_manip_pkt,
+	.csum_update		= nf_nat_ipv6_csum_update,
+	.csum_recalc		= nf_nat_ipv6_csum_recalc,
+};
+
+int nf_nat_icmpv6_reply_translation(struct sk_buff *skb,
+				    struct nf_conn *ct,
+				    enum ip_conntrack_info ctinfo,
+				    unsigned int hooknum,
+				    unsigned int hdrlen)
+{
+	struct {
+		struct icmp6hdr	icmp6;
+		struct ipv6hdr	ip6;
+	} *inside;
+	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
+	enum nf_nat_manip_type manip = HOOK2MANIP(hooknum);
+	struct nf_conntrack_tuple target;
+	unsigned long statusbit;
+
+	WARN_ON(ctinfo != IP_CT_RELATED && ctinfo != IP_CT_RELATED_REPLY);
+
+	if (!skb_make_writable(skb, hdrlen + sizeof(*inside)))
+		return 0;
+	if (nf_ip6_checksum(skb, hooknum, hdrlen, IPPROTO_ICMPV6))
+		return 0;
+
+	inside = (void *)skb->data + hdrlen;
+	if (inside->icmp6.icmp6_type == NDISC_REDIRECT) {
+		if ((ct->status & IPS_NAT_DONE_MASK) != IPS_NAT_DONE_MASK)
+			return 0;
+		if (ct->status & IPS_NAT_MASK)
+			return 0;
+	}
+
+	if (manip == NF_NAT_MANIP_SRC)
+		statusbit = IPS_SRC_NAT;
+	else
+		statusbit = IPS_DST_NAT;
+
+	/* Invert if this is reply direction */
+	if (dir == IP_CT_DIR_REPLY)
+		statusbit ^= IPS_NAT_MASK;
+
+	if (!(ct->status & statusbit))
+		return 1;
+
+	if (!nf_nat_ipv6_manip_pkt(skb, hdrlen + sizeof(inside->icmp6),
+				   &ct->tuplehash[!dir].tuple, !manip))
+		return 0;
+
+	if (skb->ip_summed != CHECKSUM_PARTIAL) {
+		struct ipv6hdr *ipv6h = ipv6_hdr(skb);
+
+		inside = (void *)skb->data + hdrlen;
+		inside->icmp6.icmp6_cksum = 0;
+		inside->icmp6.icmp6_cksum =
+			csum_ipv6_magic(&ipv6h->saddr, &ipv6h->daddr,
+					skb->len - hdrlen, IPPROTO_ICMPV6,
+					skb_checksum(skb, hdrlen,
+						     skb->len - hdrlen, 0));
+	}
+
+	nf_ct_invert_tuple(&target, &ct->tuplehash[!dir].tuple);
+	target.dst.protonum = IPPROTO_ICMPV6;
+	if (!nf_nat_ipv6_manip_pkt(skb, 0, &target, manip))
+		return 0;
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(nf_nat_icmpv6_reply_translation);
+
+static unsigned int
+nf_nat_ipv6_fn(void *priv, struct sk_buff *skb,
+	       const struct nf_hook_state *state)
+{
+	struct nf_conn *ct;
+	enum ip_conntrack_info ctinfo;
+	__be16 frag_off;
+	int hdrlen;
+	u8 nexthdr;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	/* Can't track?  It's not due to stress, or conntrack would
+	 * have dropped it.  Hence it's the user's responsibilty to
+	 * packet filter it out, or implement conntrack/NAT for that
+	 * protocol. 8) --RR
+	 */
+	if (!ct)
+		return NF_ACCEPT;
+
+	if (ctinfo == IP_CT_RELATED || ctinfo == IP_CT_RELATED_REPLY) {
+		nexthdr = ipv6_hdr(skb)->nexthdr;
+		hdrlen = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr),
+					  &nexthdr, &frag_off);
+
+		if (hdrlen >= 0 && nexthdr == IPPROTO_ICMPV6) {
+			if (!nf_nat_icmpv6_reply_translation(skb, ct, ctinfo,
+							     state->hook,
+							     hdrlen))
+				return NF_DROP;
+			else
+				return NF_ACCEPT;
+		}
+	}
+
+	return nf_nat_inet_fn(priv, skb, state);
+}
+
+static unsigned int
+nf_nat_ipv6_in(void *priv, struct sk_buff *skb,
+	       const struct nf_hook_state *state)
+{
+	unsigned int ret;
+	struct in6_addr daddr = ipv6_hdr(skb)->daddr;
+
+	ret = nf_nat_ipv6_fn(priv, skb, state);
+	if (ret != NF_DROP && ret != NF_STOLEN &&
+	    ipv6_addr_cmp(&daddr, &ipv6_hdr(skb)->daddr))
+		skb_dst_drop(skb);
+
+	return ret;
+}
+
+static unsigned int
+nf_nat_ipv6_out(void *priv, struct sk_buff *skb,
+		const struct nf_hook_state *state)
+{
+#ifdef CONFIG_XFRM
+	const struct nf_conn *ct;
+	enum ip_conntrack_info ctinfo;
+	int err;
+#endif
+	unsigned int ret;
+
+	ret = nf_nat_ipv6_fn(priv, skb, state);
+#ifdef CONFIG_XFRM
+	if (ret != NF_ACCEPT)
+		return ret;
+
+	if (IP6CB(skb)->flags & IP6SKB_XFRM_TRANSFORMED)
+		return ret;
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct) {
+		enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
+
+		if (!nf_inet_addr_cmp(&ct->tuplehash[dir].tuple.src.u3,
+				      &ct->tuplehash[!dir].tuple.dst.u3) ||
+		    (ct->tuplehash[dir].tuple.dst.protonum != IPPROTO_ICMPV6 &&
+		     ct->tuplehash[dir].tuple.src.u.all !=
+		     ct->tuplehash[!dir].tuple.dst.u.all)) {
+			err = nf_xfrm_me_harder(state->net, skb, AF_INET6);
+			if (err < 0)
+				ret = NF_DROP_ERR(err);
+		}
+	}
+#endif
+
+	return ret;
+}
+
+static int nat_route_me_harder(struct net *net, struct sk_buff *skb)
+{
+#ifdef CONFIG_IPV6_MODULE
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
+static unsigned int
+nf_nat_ipv6_local_fn(void *priv, struct sk_buff *skb,
+		     const struct nf_hook_state *state)
+{
+	const struct nf_conn *ct;
+	enum ip_conntrack_info ctinfo;
+	unsigned int ret;
+	int err;
+
+	ret = nf_nat_ipv6_fn(priv, skb, state);
+	if (ret != NF_ACCEPT)
+		return ret;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct) {
+		enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
+
+		if (!nf_inet_addr_cmp(&ct->tuplehash[dir].tuple.dst.u3,
+				      &ct->tuplehash[!dir].tuple.src.u3)) {
+			err = nat_route_me_harder(state->net, skb);
+			if (err < 0)
+				ret = NF_DROP_ERR(err);
+		}
+#ifdef CONFIG_XFRM
+		else if (!(IP6CB(skb)->flags & IP6SKB_XFRM_TRANSFORMED) &&
+			 ct->tuplehash[dir].tuple.dst.protonum != IPPROTO_ICMPV6 &&
+			 ct->tuplehash[dir].tuple.dst.u.all !=
+			 ct->tuplehash[!dir].tuple.src.u.all) {
+			err = nf_xfrm_me_harder(state->net, skb, AF_INET6);
+			if (err < 0)
+				ret = NF_DROP_ERR(err);
+		}
+#endif
+	}
+
+	return ret;
+}
+
+static const struct nf_hook_ops nf_nat_ipv6_ops[] = {
+	/* Before packet filtering, change destination */
+	{
+		.hook		= nf_nat_ipv6_in,
+		.pf		= NFPROTO_IPV6,
+		.hooknum	= NF_INET_PRE_ROUTING,
+		.priority	= NF_IP6_PRI_NAT_DST,
+	},
+	/* After packet filtering, change source */
+	{
+		.hook		= nf_nat_ipv6_out,
+		.pf		= NFPROTO_IPV6,
+		.hooknum	= NF_INET_POST_ROUTING,
+		.priority	= NF_IP6_PRI_NAT_SRC,
+	},
+	/* Before packet filtering, change destination */
+	{
+		.hook		= nf_nat_ipv6_local_fn,
+		.pf		= NFPROTO_IPV6,
+		.hooknum	= NF_INET_LOCAL_OUT,
+		.priority	= NF_IP6_PRI_NAT_DST,
+	},
+	/* After packet filtering, change source */
+	{
+		.hook		= nf_nat_ipv6_fn,
+		.pf		= NFPROTO_IPV6,
+		.hooknum	= NF_INET_LOCAL_IN,
+		.priority	= NF_IP6_PRI_NAT_SRC,
+	},
+};
+
+int nf_nat_l3proto_ipv6_register_fn(struct net *net, const struct nf_hook_ops *ops)
+{
+	return nf_nat_register_fn(net, ops, nf_nat_ipv6_ops,
+				  ARRAY_SIZE(nf_nat_ipv6_ops));
+}
+EXPORT_SYMBOL_GPL(nf_nat_l3proto_ipv6_register_fn);
+
+void nf_nat_l3proto_ipv6_unregister_fn(struct net *net, const struct nf_hook_ops *ops)
+{
+	nf_nat_unregister_fn(net, ops, ARRAY_SIZE(nf_nat_ipv6_ops));
+}
+EXPORT_SYMBOL_GPL(nf_nat_l3proto_ipv6_unregister_fn);
+#endif /* CONFIG_IPV6 */
diff --git a/net/openvswitch/Kconfig b/net/openvswitch/Kconfig
index 89da9512ec1e..ac1cc6e38170 100644
--- a/net/openvswitch/Kconfig
+++ b/net/openvswitch/Kconfig
@@ -8,8 +8,6 @@ config OPENVSWITCH
 	depends on !NF_CONNTRACK || \
 		   (NF_CONNTRACK && ((!NF_DEFRAG_IPV6 || NF_DEFRAG_IPV6) && \
 				     (!NF_NAT || NF_NAT) && \
-				     (!NF_NAT_IPV4 || NF_NAT_IPV4) && \
-				     (!NF_NAT_IPV6 || NF_NAT_IPV6) && \
 				     (!NETFILTER_CONNCOUNT || NETFILTER_CONNCOUNT)))
 	select LIBCRC32C
 	select MPLS
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 35884f836260..def4d28fcbc3 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -745,14 +745,14 @@ static int ovs_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
 	switch (ctinfo) {
 	case IP_CT_RELATED:
 	case IP_CT_RELATED_REPLY:
-		if (IS_ENABLED(CONFIG_NF_NAT_IPV4) &&
+		if (IS_ENABLED(CONFIG_NF_NAT) &&
 		    skb->protocol == htons(ETH_P_IP) &&
 		    ip_hdr(skb)->protocol == IPPROTO_ICMP) {
 			if (!nf_nat_icmp_reply_translation(skb, ct, ctinfo,
 							   hooknum))
 				err = NF_DROP;
 			goto push;
-		} else if (IS_ENABLED(CONFIG_NF_NAT_IPV6) &&
+		} else if (IS_ENABLED(CONFIG_IPV6) &&
 			   skb->protocol == htons(ETH_P_IPV6)) {
 			__be16 frag_off;
 			u8 nexthdr = ipv6_hdr(skb)->nexthdr;
@@ -1673,7 +1673,7 @@ static bool ovs_ct_nat_to_attr(const struct ovs_conntrack_info *info,
 	}
 
 	if (info->range.flags & NF_NAT_RANGE_MAP_IPS) {
-		if (IS_ENABLED(CONFIG_NF_NAT_IPV4) &&
+		if (IS_ENABLED(CONFIG_NF_NAT) &&
 		    info->family == NFPROTO_IPV4) {
 			if (nla_put_in_addr(skb, OVS_NAT_ATTR_IP_MIN,
 					    info->range.min_addr.ip) ||
@@ -1682,7 +1682,7 @@ static bool ovs_ct_nat_to_attr(const struct ovs_conntrack_info *info,
 			     (nla_put_in_addr(skb, OVS_NAT_ATTR_IP_MAX,
 					      info->range.max_addr.ip))))
 				return false;
-		} else if (IS_ENABLED(CONFIG_NF_NAT_IPV6) &&
+		} else if (IS_ENABLED(CONFIG_IPV6) &&
 			   info->family == NFPROTO_IPV6) {
 			if (nla_put_in6_addr(skb, OVS_NAT_ATTR_IP_MIN,
 					     &info->range.min_addr.in6) ||
diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index 5821bdd98d20..e9c860d00416 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -17,8 +17,7 @@ CONFIG_VLAN_8021Q=y
 CONFIG_NETFILTER=y
 CONFIG_NETFILTER_ADVANCED=y
 CONFIG_NF_CONNTRACK=m
-CONFIG_NF_NAT_IPV6=m
-CONFIG_NF_NAT_IPV4=m
+CONFIG_NF_NAT=m
 CONFIG_IP6_NF_IPTABLES=m
 CONFIG_IP_NF_IPTABLES=m
 CONFIG_IP6_NF_NAT=m
-- 
2.11.0


