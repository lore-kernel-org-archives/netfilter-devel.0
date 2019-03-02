Return-Path: <SRS0=Sk6b=RF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3009CC4360F
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:35:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAE3620838
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:35:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbfCBSfS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Mar 2019 13:35:18 -0500
Received: from mail.us.es ([193.147.175.20]:35760 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727034AbfCBSfP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Mar 2019 13:35:15 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7212D1361B0
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:35:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4CE6CDA86C
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:35:11 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 42069DA85D; Sat,  2 Mar 2019 19:35:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4B575DA846;
        Sat,  2 Mar 2019 19:35:08 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 02 Mar 2019 19:35:08 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.223.53])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D291F4265A2F;
        Sat,  2 Mar 2019 19:35:07 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 04/29] netfilter: nat: merge ipv4 and ipv6 masquerade functionality
Date:   Sat,  2 Mar 2019 19:34:32 +0100
Message-Id: <20190302183457.3079-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190302183457.3079-1-pablo@netfilter.org>
References: <20190302183457.3079-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Before:
   text	   data	    bss	    dec	    hex	filename
  13916	   1412	   4128	  19456	   4c00	nf_nat.ko
   4510	    968	      4	   5482	   156a	nf_nat_ipv4.ko
   5146	    944	      8	   6098	   17d2	nf_nat_ipv6.ko

After:
   text	   data	    bss	    dec	    hex	filename
  16566	   1576	   4136	  22278	   5706	nf_nat.ko
   3187	    844	      0	   4031	    fbf	nf_nat_ipv4.ko
   3598	    844	      0	   4442	   115a	nf_nat_ipv6.ko

... so no drastic changes in combined size.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_nat.h              |   6 +-
 net/ipv4/netfilter/Kconfig                  |   7 +-
 net/ipv4/netfilter/Makefile                 |   1 -
 net/ipv4/netfilter/nf_nat_masquerade_ipv4.c | 196 ---------------
 net/ipv6/netfilter/Kconfig                  |  11 +-
 net/ipv6/netfilter/Makefile                 |   1 -
 net/ipv6/netfilter/nf_nat_masquerade_ipv6.c | 240 ------------------
 net/netfilter/Kconfig                       |   3 +
 net/netfilter/Makefile                      |   1 +
 net/netfilter/nf_nat_masquerade.c           | 362 ++++++++++++++++++++++++++++
 10 files changed, 372 insertions(+), 456 deletions(-)
 delete mode 100644 net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
 delete mode 100644 net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
 create mode 100644 net/netfilter/nf_nat_masquerade.c

diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index 8aff77cafb8b..e53b4f9b8b44 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -31,8 +31,7 @@ struct nf_conn;
 /* The structure embedded in the conntrack structure. */
 struct nf_conn_nat {
 	union nf_conntrack_nat_help help;
-#if IS_ENABLED(CONFIG_NF_NAT_MASQUERADE_IPV4) || \
-    IS_ENABLED(CONFIG_NF_NAT_MASQUERADE_IPV6)
+#if IS_ENABLED(CONFIG_NF_NAT_MASQUERADE)
 	int masq_index;
 #endif
 };
@@ -61,8 +60,7 @@ static inline bool nf_nat_oif_changed(unsigned int hooknum,
 				      struct nf_conn_nat *nat,
 				      const struct net_device *out)
 {
-#if IS_ENABLED(CONFIG_NF_NAT_MASQUERADE_IPV4) || \
-    IS_ENABLED(CONFIG_NF_NAT_MASQUERADE_IPV6)
+#if IS_ENABLED(CONFIG_NF_NAT_MASQUERADE)
 	return nat && nat->masq_index && hooknum == NF_INET_POST_ROUTING &&
 	       CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL &&
 	       nat->masq_index != out->ifindex;
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 80f72cc5ca8d..db05a835748a 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -106,9 +106,6 @@ config NF_NAT_IPV4
 
 if NF_NAT_IPV4
 
-config NF_NAT_MASQUERADE_IPV4
-	bool
-
 if NF_TABLES
 config NFT_CHAIN_NAT_IPV4
 	depends on NF_TABLES_IPV4
@@ -123,7 +120,7 @@ config NFT_MASQ_IPV4
 	tristate "IPv4 masquerading support for nf_tables"
 	depends on NF_TABLES_IPV4
 	depends on NFT_MASQ
-	select NF_NAT_MASQUERADE_IPV4
+	select NF_NAT_MASQUERADE
 	help
 	  This is the expression that provides IPv4 masquerading support for
 	  nf_tables.
@@ -276,7 +273,7 @@ if IP_NF_NAT
 
 config IP_NF_TARGET_MASQUERADE
 	tristate "MASQUERADE target support"
-	select NF_NAT_MASQUERADE_IPV4
+	select NF_NAT_MASQUERADE
 	default m if NETFILTER_ADVANCED=n
 	help
 	  Masquerading is a special case of NAT: all outgoing connections are
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index fd7122e0e2c9..ddeb35ab8bdb 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -4,7 +4,6 @@
 #
 
 nf_nat_ipv4-y		:= nf_nat_l3proto_ipv4.o
-nf_nat_ipv4-$(CONFIG_NF_NAT_MASQUERADE_IPV4) += nf_nat_masquerade_ipv4.o
 obj-$(CONFIG_NF_NAT_IPV4) += nf_nat_ipv4.o
 
 # defrag
diff --git a/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c b/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
deleted file mode 100644
index 41327bb99093..000000000000
--- a/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
+++ /dev/null
@@ -1,196 +0,0 @@
-/* (C) 1999-2001 Paul `Rusty' Russell
- * (C) 2002-2006 Netfilter Core Team <coreteam@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/types.h>
-#include <linux/atomic.h>
-#include <linux/inetdevice.h>
-#include <linux/ip.h>
-#include <linux/timer.h>
-#include <linux/netfilter.h>
-#include <net/protocol.h>
-#include <net/ip.h>
-#include <net/checksum.h>
-#include <net/route.h>
-#include <linux/netfilter_ipv4.h>
-#include <linux/netfilter/x_tables.h>
-#include <net/netfilter/nf_nat.h>
-#include <net/netfilter/ipv4/nf_nat_masquerade.h>
-
-unsigned int
-nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
-		       const struct nf_nat_range2 *range,
-		       const struct net_device *out)
-{
-	struct nf_conn *ct;
-	struct nf_conn_nat *nat;
-	enum ip_conntrack_info ctinfo;
-	struct nf_nat_range2 newrange;
-	const struct rtable *rt;
-	__be32 newsrc, nh;
-
-	WARN_ON(hooknum != NF_INET_POST_ROUTING);
-
-	ct = nf_ct_get(skb, &ctinfo);
-
-	WARN_ON(!(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
-			 ctinfo == IP_CT_RELATED_REPLY)));
-
-	/* Source address is 0.0.0.0 - locally generated packet that is
-	 * probably not supposed to be masqueraded.
-	 */
-	if (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.ip == 0)
-		return NF_ACCEPT;
-
-	rt = skb_rtable(skb);
-	nh = rt_nexthop(rt, ip_hdr(skb)->daddr);
-	newsrc = inet_select_addr(out, nh, RT_SCOPE_UNIVERSE);
-	if (!newsrc) {
-		pr_info("%s ate my IP address\n", out->name);
-		return NF_DROP;
-	}
-
-	nat = nf_ct_nat_ext_add(ct);
-	if (nat)
-		nat->masq_index = out->ifindex;
-
-	/* Transfer from original range. */
-	memset(&newrange.min_addr, 0, sizeof(newrange.min_addr));
-	memset(&newrange.max_addr, 0, sizeof(newrange.max_addr));
-	newrange.flags       = range->flags | NF_NAT_RANGE_MAP_IPS;
-	newrange.min_addr.ip = newsrc;
-	newrange.max_addr.ip = newsrc;
-	newrange.min_proto   = range->min_proto;
-	newrange.max_proto   = range->max_proto;
-
-	/* Hand modified range to generic setup. */
-	return nf_nat_setup_info(ct, &newrange, NF_NAT_MANIP_SRC);
-}
-EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv4);
-
-static int device_cmp(struct nf_conn *i, void *ifindex)
-{
-	const struct nf_conn_nat *nat = nfct_nat(i);
-
-	if (!nat)
-		return 0;
-	if (nf_ct_l3num(i) != NFPROTO_IPV4)
-		return 0;
-	return nat->masq_index == (int)(long)ifindex;
-}
-
-static int masq_device_event(struct notifier_block *this,
-			     unsigned long event,
-			     void *ptr)
-{
-	const struct net_device *dev = netdev_notifier_info_to_dev(ptr);
-	struct net *net = dev_net(dev);
-
-	if (event == NETDEV_DOWN) {
-		/* Device was downed.  Search entire table for
-		 * conntracks which were associated with that device,
-		 * and forget them.
-		 */
-		WARN_ON(dev->ifindex == 0);
-
-		nf_ct_iterate_cleanup_net(net, device_cmp,
-					  (void *)(long)dev->ifindex, 0, 0);
-	}
-
-	return NOTIFY_DONE;
-}
-
-static int inet_cmp(struct nf_conn *ct, void *ptr)
-{
-	struct in_ifaddr *ifa = (struct in_ifaddr *)ptr;
-	struct net_device *dev = ifa->ifa_dev->dev;
-	struct nf_conntrack_tuple *tuple;
-
-	if (!device_cmp(ct, (void *)(long)dev->ifindex))
-		return 0;
-
-	tuple = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
-
-	return ifa->ifa_address == tuple->dst.u3.ip;
-}
-
-static int masq_inet_event(struct notifier_block *this,
-			   unsigned long event,
-			   void *ptr)
-{
-	struct in_device *idev = ((struct in_ifaddr *)ptr)->ifa_dev;
-	struct net *net = dev_net(idev->dev);
-
-	/* The masq_dev_notifier will catch the case of the device going
-	 * down.  So if the inetdev is dead and being destroyed we have
-	 * no work to do.  Otherwise this is an individual address removal
-	 * and we have to perform the flush.
-	 */
-	if (idev->dead)
-		return NOTIFY_DONE;
-
-	if (event == NETDEV_DOWN)
-		nf_ct_iterate_cleanup_net(net, inet_cmp, ptr, 0, 0);
-
-	return NOTIFY_DONE;
-}
-
-static struct notifier_block masq_dev_notifier = {
-	.notifier_call	= masq_device_event,
-};
-
-static struct notifier_block masq_inet_notifier = {
-	.notifier_call	= masq_inet_event,
-};
-
-static int masq_refcnt;
-static DEFINE_MUTEX(masq_mutex);
-
-int nf_nat_masquerade_ipv4_register_notifier(void)
-{
-	int ret = 0;
-
-	mutex_lock(&masq_mutex);
-	/* check if the notifier was already set */
-	if (++masq_refcnt > 1)
-		goto out_unlock;
-
-	/* Register for device down reports */
-	ret = register_netdevice_notifier(&masq_dev_notifier);
-	if (ret)
-		goto err_dec;
-	/* Register IP address change reports */
-	ret = register_inetaddr_notifier(&masq_inet_notifier);
-	if (ret)
-		goto err_unregister;
-
-	mutex_unlock(&masq_mutex);
-	return ret;
-
-err_unregister:
-	unregister_netdevice_notifier(&masq_dev_notifier);
-err_dec:
-	masq_refcnt--;
-out_unlock:
-	mutex_unlock(&masq_mutex);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv4_register_notifier);
-
-void nf_nat_masquerade_ipv4_unregister_notifier(void)
-{
-	mutex_lock(&masq_mutex);
-	/* check if the notifier still has clients */
-	if (--masq_refcnt > 0)
-		goto out_unlock;
-
-	unregister_netdevice_notifier(&masq_dev_notifier);
-	unregister_inetaddr_notifier(&masq_inet_notifier);
-out_unlock:
-	mutex_unlock(&masq_mutex);
-}
-EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv4_unregister_notifier);
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 339d0762b027..f57fc99e9a04 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -44,7 +44,7 @@ config NFT_CHAIN_NAT_IPV6
 config NFT_MASQ_IPV6
 	tristate "IPv6 masquerade support for nf_tables"
 	depends on NFT_MASQ
-	select NF_NAT_MASQUERADE_IPV6
+	select NF_NAT_MASQUERADE
 	help
 	  This is the expression that provides IPv4 masquerading support for
 	  nf_tables.
@@ -116,13 +116,6 @@ config NF_NAT_IPV6
 	  forms of full Network Address Port Translation. This can be
 	  controlled by iptables or nft.
 
-if NF_NAT_IPV6
-
-config NF_NAT_MASQUERADE_IPV6
-	bool
-
-endif # NF_NAT_IPV6
-
 config IP6_NF_IPTABLES
 	tristate "IP6 tables support (required for filtering)"
 	depends on INET && IPV6
@@ -324,7 +317,7 @@ if IP6_NF_NAT
 
 config IP6_NF_TARGET_MASQUERADE
 	tristate "MASQUERADE target support"
-	select NF_NAT_MASQUERADE_IPV6
+	select NF_NAT_MASQUERADE
 	help
 	  Masquerading is a special case of NAT: all outgoing connections are
 	  changed to seem to come from a particular interface's address, and
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index 9ea43d5256e0..a7b18d13e056 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -12,7 +12,6 @@ obj-$(CONFIG_IP6_NF_SECURITY) += ip6table_security.o
 obj-$(CONFIG_IP6_NF_NAT) += ip6table_nat.o
 
 nf_nat_ipv6-y		:= nf_nat_l3proto_ipv6.o
-nf_nat_ipv6-$(CONFIG_NF_NAT_MASQUERADE_IPV6) += nf_nat_masquerade_ipv6.o
 obj-$(CONFIG_NF_NAT_IPV6) += nf_nat_ipv6.o
 
 # defrag
diff --git a/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c b/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
deleted file mode 100644
index fd313b726263..000000000000
--- a/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
+++ /dev/null
@@ -1,240 +0,0 @@
-/*
- * Copyright (c) 2011 Patrick McHardy <kaber@trash.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * Based on Rusty Russell's IPv6 MASQUERADE target. Development of IPv6
- * NAT funded by Astaro.
- */
-
-#include <linux/kernel.h>
-#include <linux/atomic.h>
-#include <linux/netdevice.h>
-#include <linux/ipv6.h>
-#include <linux/netfilter.h>
-#include <linux/netfilter_ipv6.h>
-#include <net/netfilter/nf_nat.h>
-#include <net/addrconf.h>
-#include <net/ipv6.h>
-#include <net/netfilter/ipv6/nf_nat_masquerade.h>
-
-#define MAX_WORK_COUNT	16
-
-static atomic_t v6_worker_count;
-
-static int
-nat_ipv6_dev_get_saddr(struct net *net, const struct net_device *dev,
-		       const struct in6_addr *daddr, unsigned int srcprefs,
-		       struct in6_addr *saddr)
-{
-#ifdef CONFIG_IPV6_MODULE
-	const struct nf_ipv6_ops *v6_ops = nf_get_ipv6_ops();
-
-	if (!v6_ops)
-		return -EHOSTUNREACH;
-
-	return v6_ops->dev_get_saddr(net, dev, daddr, srcprefs, saddr);
-#else
-	return ipv6_dev_get_saddr(net, dev, daddr, srcprefs, saddr);
-#endif
-}
-
-unsigned int
-nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
-		       const struct net_device *out)
-{
-	enum ip_conntrack_info ctinfo;
-	struct nf_conn_nat *nat;
-	struct in6_addr src;
-	struct nf_conn *ct;
-	struct nf_nat_range2 newrange;
-
-	ct = nf_ct_get(skb, &ctinfo);
-	WARN_ON(!(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
-			 ctinfo == IP_CT_RELATED_REPLY)));
-
-	if (nat_ipv6_dev_get_saddr(nf_ct_net(ct), out,
-				   &ipv6_hdr(skb)->daddr, 0, &src) < 0)
-		return NF_DROP;
-
-	nat = nf_ct_nat_ext_add(ct);
-	if (nat)
-		nat->masq_index = out->ifindex;
-
-	newrange.flags		= range->flags | NF_NAT_RANGE_MAP_IPS;
-	newrange.min_addr.in6	= src;
-	newrange.max_addr.in6	= src;
-	newrange.min_proto	= range->min_proto;
-	newrange.max_proto	= range->max_proto;
-
-	return nf_nat_setup_info(ct, &newrange, NF_NAT_MANIP_SRC);
-}
-EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv6);
-
-static int device_cmp(struct nf_conn *ct, void *ifindex)
-{
-	const struct nf_conn_nat *nat = nfct_nat(ct);
-
-	if (!nat)
-		return 0;
-	if (nf_ct_l3num(ct) != NFPROTO_IPV6)
-		return 0;
-	return nat->masq_index == (int)(long)ifindex;
-}
-
-static int masq_device_event(struct notifier_block *this,
-			     unsigned long event, void *ptr)
-{
-	const struct net_device *dev = netdev_notifier_info_to_dev(ptr);
-	struct net *net = dev_net(dev);
-
-	if (event == NETDEV_DOWN)
-		nf_ct_iterate_cleanup_net(net, device_cmp,
-					  (void *)(long)dev->ifindex, 0, 0);
-
-	return NOTIFY_DONE;
-}
-
-static struct notifier_block masq_dev_notifier = {
-	.notifier_call	= masq_device_event,
-};
-
-struct masq_dev_work {
-	struct work_struct work;
-	struct net *net;
-	struct in6_addr addr;
-	int ifindex;
-};
-
-static int inet_cmp(struct nf_conn *ct, void *work)
-{
-	struct masq_dev_work *w = (struct masq_dev_work *)work;
-	struct nf_conntrack_tuple *tuple;
-
-	if (!device_cmp(ct, (void *)(long)w->ifindex))
-		return 0;
-
-	tuple = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
-
-	return ipv6_addr_equal(&w->addr, &tuple->dst.u3.in6);
-}
-
-static void iterate_cleanup_work(struct work_struct *work)
-{
-	struct masq_dev_work *w;
-
-	w = container_of(work, struct masq_dev_work, work);
-
-	nf_ct_iterate_cleanup_net(w->net, inet_cmp, (void *)w, 0, 0);
-
-	put_net(w->net);
-	kfree(w);
-	atomic_dec(&v6_worker_count);
-	module_put(THIS_MODULE);
-}
-
-/* ipv6 inet notifier is an atomic notifier, i.e. we cannot
- * schedule.
- *
- * Unfortunately, nf_ct_iterate_cleanup_net can run for a long
- * time if there are lots of conntracks and the system
- * handles high softirq load, so it frequently calls cond_resched
- * while iterating the conntrack table.
- *
- * So we defer nf_ct_iterate_cleanup_net walk to the system workqueue.
- *
- * As we can have 'a lot' of inet_events (depending on amount
- * of ipv6 addresses being deleted), we also need to add an upper
- * limit to the number of queued work items.
- */
-static int masq_inet6_event(struct notifier_block *this,
-			    unsigned long event, void *ptr)
-{
-	struct inet6_ifaddr *ifa = ptr;
-	const struct net_device *dev;
-	struct masq_dev_work *w;
-	struct net *net;
-
-	if (event != NETDEV_DOWN ||
-	    atomic_read(&v6_worker_count) >= MAX_WORK_COUNT)
-		return NOTIFY_DONE;
-
-	dev = ifa->idev->dev;
-	net = maybe_get_net(dev_net(dev));
-	if (!net)
-		return NOTIFY_DONE;
-
-	if (!try_module_get(THIS_MODULE))
-		goto err_module;
-
-	w = kmalloc(sizeof(*w), GFP_ATOMIC);
-	if (w) {
-		atomic_inc(&v6_worker_count);
-
-		INIT_WORK(&w->work, iterate_cleanup_work);
-		w->ifindex = dev->ifindex;
-		w->net = net;
-		w->addr = ifa->addr;
-		schedule_work(&w->work);
-
-		return NOTIFY_DONE;
-	}
-
-	module_put(THIS_MODULE);
- err_module:
-	put_net(net);
-	return NOTIFY_DONE;
-}
-
-static struct notifier_block masq_inet6_notifier = {
-	.notifier_call	= masq_inet6_event,
-};
-
-static int masq_refcnt;
-static DEFINE_MUTEX(masq_mutex);
-
-int nf_nat_masquerade_ipv6_register_notifier(void)
-{
-	int ret = 0;
-
-	mutex_lock(&masq_mutex);
-	/* check if the notifier is already set */
-	if (++masq_refcnt > 1)
-		goto out_unlock;
-
-	ret = register_netdevice_notifier(&masq_dev_notifier);
-	if (ret)
-		goto err_dec;
-
-	ret = register_inet6addr_notifier(&masq_inet6_notifier);
-	if (ret)
-		goto err_unregister;
-
-	mutex_unlock(&masq_mutex);
-	return ret;
-
-err_unregister:
-	unregister_netdevice_notifier(&masq_dev_notifier);
-err_dec:
-	masq_refcnt--;
-out_unlock:
-	mutex_unlock(&masq_mutex);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv6_register_notifier);
-
-void nf_nat_masquerade_ipv6_unregister_notifier(void)
-{
-	mutex_lock(&masq_mutex);
-	/* check if the notifier still has clients */
-	if (--masq_refcnt > 0)
-		goto out_unlock;
-
-	unregister_inet6addr_notifier(&masq_inet6_notifier);
-	unregister_netdevice_notifier(&masq_dev_notifier);
-out_unlock:
-	mutex_unlock(&masq_mutex);
-}
-EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv6_unregister_notifier);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index fefd63a243f2..5a753cec005b 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -431,6 +431,9 @@ config NF_NAT_TFTP
 config NF_NAT_REDIRECT
 	bool
 
+config NF_NAT_MASQUERADE
+	bool
+
 config NETFILTER_SYNPROXY
 	tristate
 
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index e66067befa42..c7910706f8dd 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -56,6 +56,7 @@ obj-$(CONFIG_NF_LOG_NETDEV) += nf_log_netdev.o
 
 obj-$(CONFIG_NF_NAT) += nf_nat.o
 nf_nat-$(CONFIG_NF_NAT_REDIRECT) += nf_nat_redirect.o
+nf_nat-$(CONFIG_NF_NAT_MASQUERADE) += nf_nat_masquerade.o
 
 # NAT helpers
 obj-$(CONFIG_NF_NAT_AMANDA) += nf_nat_amanda.o
diff --git a/net/netfilter/nf_nat_masquerade.c b/net/netfilter/nf_nat_masquerade.c
new file mode 100644
index 000000000000..86fa4dcc63c5
--- /dev/null
+++ b/net/netfilter/nf_nat_masquerade.c
@@ -0,0 +1,362 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/types.h>
+#include <linux/atomic.h>
+#include <linux/inetdevice.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/netfilter_ipv6.h>
+
+#include <net/netfilter/ipv4/nf_nat_masquerade.h>
+#include <net/netfilter/ipv6/nf_nat_masquerade.h>
+
+static DEFINE_MUTEX(masq_mutex);
+static unsigned int masq_refcnt __read_mostly;
+
+unsigned int
+nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
+		       const struct nf_nat_range2 *range,
+		       const struct net_device *out)
+{
+	struct nf_conn *ct;
+	struct nf_conn_nat *nat;
+	enum ip_conntrack_info ctinfo;
+	struct nf_nat_range2 newrange;
+	const struct rtable *rt;
+	__be32 newsrc, nh;
+
+	WARN_ON(hooknum != NF_INET_POST_ROUTING);
+
+	ct = nf_ct_get(skb, &ctinfo);
+
+	WARN_ON(!(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
+			 ctinfo == IP_CT_RELATED_REPLY)));
+
+	/* Source address is 0.0.0.0 - locally generated packet that is
+	 * probably not supposed to be masqueraded.
+	 */
+	if (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.ip == 0)
+		return NF_ACCEPT;
+
+	rt = skb_rtable(skb);
+	nh = rt_nexthop(rt, ip_hdr(skb)->daddr);
+	newsrc = inet_select_addr(out, nh, RT_SCOPE_UNIVERSE);
+	if (!newsrc) {
+		pr_info("%s ate my IP address\n", out->name);
+		return NF_DROP;
+	}
+
+	nat = nf_ct_nat_ext_add(ct);
+	if (nat)
+		nat->masq_index = out->ifindex;
+
+	/* Transfer from original range. */
+	memset(&newrange.min_addr, 0, sizeof(newrange.min_addr));
+	memset(&newrange.max_addr, 0, sizeof(newrange.max_addr));
+	newrange.flags       = range->flags | NF_NAT_RANGE_MAP_IPS;
+	newrange.min_addr.ip = newsrc;
+	newrange.max_addr.ip = newsrc;
+	newrange.min_proto   = range->min_proto;
+	newrange.max_proto   = range->max_proto;
+
+	/* Hand modified range to generic setup. */
+	return nf_nat_setup_info(ct, &newrange, NF_NAT_MANIP_SRC);
+}
+EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv4);
+
+static int device_cmp(struct nf_conn *i, void *ifindex)
+{
+	const struct nf_conn_nat *nat = nfct_nat(i);
+
+	if (!nat)
+		return 0;
+	return nat->masq_index == (int)(long)ifindex;
+}
+
+static int masq_device_event(struct notifier_block *this,
+			     unsigned long event,
+			     void *ptr)
+{
+	const struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct net *net = dev_net(dev);
+
+	if (event == NETDEV_DOWN) {
+		/* Device was downed.  Search entire table for
+		 * conntracks which were associated with that device,
+		 * and forget them.
+		 */
+
+		nf_ct_iterate_cleanup_net(net, device_cmp,
+					  (void *)(long)dev->ifindex, 0, 0);
+	}
+
+	return NOTIFY_DONE;
+}
+
+static int inet_cmp(struct nf_conn *ct, void *ptr)
+{
+	struct in_ifaddr *ifa = (struct in_ifaddr *)ptr;
+	struct net_device *dev = ifa->ifa_dev->dev;
+	struct nf_conntrack_tuple *tuple;
+
+	if (!device_cmp(ct, (void *)(long)dev->ifindex))
+		return 0;
+
+	tuple = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
+
+	return ifa->ifa_address == tuple->dst.u3.ip;
+}
+
+static int masq_inet_event(struct notifier_block *this,
+			   unsigned long event,
+			   void *ptr)
+{
+	struct in_device *idev = ((struct in_ifaddr *)ptr)->ifa_dev;
+	struct net *net = dev_net(idev->dev);
+
+	/* The masq_dev_notifier will catch the case of the device going
+	 * down.  So if the inetdev is dead and being destroyed we have
+	 * no work to do.  Otherwise this is an individual address removal
+	 * and we have to perform the flush.
+	 */
+	if (idev->dead)
+		return NOTIFY_DONE;
+
+	if (event == NETDEV_DOWN)
+		nf_ct_iterate_cleanup_net(net, inet_cmp, ptr, 0, 0);
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block masq_dev_notifier = {
+	.notifier_call	= masq_device_event,
+};
+
+static struct notifier_block masq_inet_notifier = {
+	.notifier_call	= masq_inet_event,
+};
+
+int nf_nat_masquerade_ipv4_register_notifier(void)
+{
+	int ret = 0;
+
+	mutex_lock(&masq_mutex);
+	/* check if the notifier was already set */
+	if (++masq_refcnt > 1)
+		goto out_unlock;
+
+	/* Register for device down reports */
+	ret = register_netdevice_notifier(&masq_dev_notifier);
+	if (ret)
+		goto err_dec;
+	/* Register IP address change reports */
+	ret = register_inetaddr_notifier(&masq_inet_notifier);
+	if (ret)
+		goto err_unregister;
+
+	mutex_unlock(&masq_mutex);
+	return ret;
+
+err_unregister:
+	unregister_netdevice_notifier(&masq_dev_notifier);
+err_dec:
+	masq_refcnt--;
+out_unlock:
+	mutex_unlock(&masq_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv4_register_notifier);
+
+void nf_nat_masquerade_ipv4_unregister_notifier(void)
+{
+	mutex_lock(&masq_mutex);
+	/* check if the notifier still has clients */
+	if (--masq_refcnt > 0)
+		goto out_unlock;
+
+	unregister_netdevice_notifier(&masq_dev_notifier);
+	unregister_inetaddr_notifier(&masq_inet_notifier);
+out_unlock:
+	mutex_unlock(&masq_mutex);
+}
+EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv4_unregister_notifier);
+
+#if IS_ENABLED(CONFIG_IPV6)
+static atomic_t v6_worker_count __read_mostly;
+
+static int
+nat_ipv6_dev_get_saddr(struct net *net, const struct net_device *dev,
+		       const struct in6_addr *daddr, unsigned int srcprefs,
+		       struct in6_addr *saddr)
+{
+#ifdef CONFIG_IPV6_MODULE
+	const struct nf_ipv6_ops *v6_ops = nf_get_ipv6_ops();
+
+	if (!v6_ops)
+		return -EHOSTUNREACH;
+
+	return v6_ops->dev_get_saddr(net, dev, daddr, srcprefs, saddr);
+#else
+	return ipv6_dev_get_saddr(net, dev, daddr, srcprefs, saddr);
+#endif
+}
+
+unsigned int
+nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
+		       const struct net_device *out)
+{
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn_nat *nat;
+	struct in6_addr src;
+	struct nf_conn *ct;
+	struct nf_nat_range2 newrange;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	WARN_ON(!(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
+			 ctinfo == IP_CT_RELATED_REPLY)));
+
+	if (nat_ipv6_dev_get_saddr(nf_ct_net(ct), out,
+				   &ipv6_hdr(skb)->daddr, 0, &src) < 0)
+		return NF_DROP;
+
+	nat = nf_ct_nat_ext_add(ct);
+	if (nat)
+		nat->masq_index = out->ifindex;
+
+	newrange.flags		= range->flags | NF_NAT_RANGE_MAP_IPS;
+	newrange.min_addr.in6	= src;
+	newrange.max_addr.in6	= src;
+	newrange.min_proto	= range->min_proto;
+	newrange.max_proto	= range->max_proto;
+
+	return nf_nat_setup_info(ct, &newrange, NF_NAT_MANIP_SRC);
+}
+EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv6);
+
+struct masq_dev_work {
+	struct work_struct work;
+	struct net *net;
+	struct in6_addr addr;
+	int ifindex;
+};
+
+static int inet6_cmp(struct nf_conn *ct, void *work)
+{
+	struct masq_dev_work *w = (struct masq_dev_work *)work;
+	struct nf_conntrack_tuple *tuple;
+
+	if (!device_cmp(ct, (void *)(long)w->ifindex))
+		return 0;
+
+	tuple = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
+
+	return ipv6_addr_equal(&w->addr, &tuple->dst.u3.in6);
+}
+
+static void iterate_cleanup_work(struct work_struct *work)
+{
+	struct masq_dev_work *w;
+
+	w = container_of(work, struct masq_dev_work, work);
+
+	nf_ct_iterate_cleanup_net(w->net, inet6_cmp, (void *)w, 0, 0);
+
+	put_net(w->net);
+	kfree(w);
+	atomic_dec(&v6_worker_count);
+	module_put(THIS_MODULE);
+}
+
+/* atomic notifier; can't call nf_ct_iterate_cleanup_net (it can sleep).
+ *
+ * Defer it to the system workqueue.
+ *
+ * As we can have 'a lot' of inet_events (depending on amount of ipv6
+ * addresses being deleted), we also need to limit work item queue.
+ */
+static int masq_inet6_event(struct notifier_block *this,
+			    unsigned long event, void *ptr)
+{
+	struct inet6_ifaddr *ifa = ptr;
+	const struct net_device *dev;
+	struct masq_dev_work *w;
+	struct net *net;
+
+	if (event != NETDEV_DOWN || atomic_read(&v6_worker_count) >= 16)
+		return NOTIFY_DONE;
+
+	dev = ifa->idev->dev;
+	net = maybe_get_net(dev_net(dev));
+	if (!net)
+		return NOTIFY_DONE;
+
+	if (!try_module_get(THIS_MODULE))
+		goto err_module;
+
+	w = kmalloc(sizeof(*w), GFP_ATOMIC);
+	if (w) {
+		atomic_inc(&v6_worker_count);
+
+		INIT_WORK(&w->work, iterate_cleanup_work);
+		w->ifindex = dev->ifindex;
+		w->net = net;
+		w->addr = ifa->addr;
+		schedule_work(&w->work);
+
+		return NOTIFY_DONE;
+	}
+
+	module_put(THIS_MODULE);
+ err_module:
+	put_net(net);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block masq_inet6_notifier = {
+	.notifier_call	= masq_inet6_event,
+};
+
+int nf_nat_masquerade_ipv6_register_notifier(void)
+{
+	int ret = 0;
+
+	mutex_lock(&masq_mutex);
+	/* check if the notifier is already set */
+	if (++masq_refcnt > 1)
+		goto out_unlock;
+
+	ret = register_netdevice_notifier(&masq_dev_notifier);
+	if (ret)
+		goto err_dec;
+
+	ret = register_inet6addr_notifier(&masq_inet6_notifier);
+	if (ret)
+		goto err_unregister;
+
+	mutex_unlock(&masq_mutex);
+	return ret;
+
+err_unregister:
+	unregister_netdevice_notifier(&masq_dev_notifier);
+err_dec:
+	masq_refcnt--;
+out_unlock:
+	mutex_unlock(&masq_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv6_register_notifier);
+
+void nf_nat_masquerade_ipv6_unregister_notifier(void)
+{
+	mutex_lock(&masq_mutex);
+	/* check if the notifier still has clients */
+	if (--masq_refcnt > 0)
+		goto out_unlock;
+
+	unregister_inet6addr_notifier(&masq_inet6_notifier);
+	unregister_netdevice_notifier(&masq_dev_notifier);
+out_unlock:
+	mutex_unlock(&masq_mutex);
+}
+EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv6_unregister_notifier);
+#endif
-- 
2.11.0


