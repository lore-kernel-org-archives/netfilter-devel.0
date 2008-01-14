From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC] generic CONNTRACK target
Date: Mon, 14 Jan 2008 17:29:37 +0100
Message-ID: <478B8DF1.3060503@netfilter.org>
References: <478B8B74.3070903@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010704060007060300040603"
Cc: Phil Oester <kernel@linuxace.com>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33677 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751342AbYANQ37 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jan 2008 11:29:59 -0500
In-Reply-To: <478B8B74.3070903@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010704060007060300040603
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Pablo Neira Ayuso wrote:
> Attached an untested RFC patch [...]

I forgot to attach the patch...

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------010704060007060300040603
Content-Type: text/x-patch;
 name="rfc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="rfc.patch"

[RFC] Introduce the generic conntrack target

This patch implements the generic CONNTRACK target which merges
CONNMARK, CONNSECMARK, NOTRACK and TIMEOUT into a single target. Also,
This patch introduces the volatile events marking to make ctnetlink ignore
certain events.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/include/linux/netfilter/nf_conntrack_common.h
===================================================================
--- net-2.6.git.orig/include/linux/netfilter/nf_conntrack_common.h	2008-01-02 03:43:36.000000000 +0100
+++ net-2.6.git/include/linux/netfilter/nf_conntrack_common.h	2008-01-02 04:54:29.000000000 +0100
@@ -73,6 +73,10 @@ enum ip_conntrack_status {
 	/* Connection has fixed timeout. */
 	IPS_FIXED_TIMEOUT_BIT = 10,
 	IPS_FIXED_TIMEOUT = (1 << IPS_FIXED_TIMEOUT_BIT),
+
+	/* Connection has a manually configured timeout. */
+	IPS_MANUAL_TIMEOUT_BIT = 11,
+	IPS_MANUAL_TIMEOUT = (1 << IPS_MANUAL_TIMEOUT_BIT),
 };
 
 /* Connection tracking event bits */
@@ -137,6 +141,10 @@ enum ip_conntrack_events
 	/* Secmark is set */
 	IPCT_SECMARK_BIT = 14,
 	IPCT_SECMARK = (1 << IPCT_SECMARK_BIT),
+
+	/* These events has been set as volatile (via iptables) */
+	IPCT_VOLATILE_BIT = 15,
+	IPCT_VOLATILE = (1 << IPCT_VOLATILE_BIT),
 };
 
 enum ip_conntrack_expect_events {
Index: net-2.6.git/include/net/netfilter/nf_conntrack.h
===================================================================
--- net-2.6.git.orig/include/net/netfilter/nf_conntrack.h	2008-01-02 03:43:36.000000000 +0100
+++ net-2.6.git/include/net/netfilter/nf_conntrack.h	2008-01-02 03:47:52.000000000 +0100
@@ -88,6 +88,10 @@ struct nf_conn_help {
 	unsigned int expecting;
 };
 
+/* nf_conn feature for manual timeouts via iptables */
+struct nf_conn_timeout {
+	u_int32_t       timeout;
+};
 
 #include <net/netfilter/ipv4/nf_conntrack_ipv4.h>
 #include <net/netfilter/ipv6/nf_conntrack_ipv6.h>
Index: net-2.6.git/include/net/netfilter/nf_conntrack_extend.h
===================================================================
--- net-2.6.git.orig/include/net/netfilter/nf_conntrack_extend.h	2008-01-02 03:43:36.000000000 +0100
+++ net-2.6.git/include/net/netfilter/nf_conntrack_extend.h	2008-01-02 03:48:45.000000000 +0100
@@ -7,11 +7,13 @@ enum nf_ct_ext_id
 {
 	NF_CT_EXT_HELPER,
 	NF_CT_EXT_NAT,
+	NF_CT_EXT_TIMEOUT,
 	NF_CT_EXT_NUM,
 };
 
 #define NF_CT_EXT_HELPER_TYPE struct nf_conn_help
 #define NF_CT_EXT_NAT_TYPE struct nf_conn_nat
+#define NF_CT_EXT_TIMEOUT_TYPE struct nf_conn_timeout
 
 /* Extensions: optional stuff which isn't permanently in struct. */
 struct nf_ct_ext {
@@ -82,4 +84,10 @@ struct nf_ct_ext_type
 
 int nf_ct_extend_register(struct nf_ct_ext_type *type);
 void nf_ct_extend_unregister(struct nf_ct_ext_type *type);
+
+static inline struct nf_conn_timeout *nfct_timeout(const struct nf_conn *ct)
+{
+	return nf_ct_ext_find(ct, NF_CT_EXT_TIMEOUT);
+}
+
 #endif /* _NF_CONNTRACK_EXTEND_H */
Index: net-2.6.git/net/netfilter/Kconfig
===================================================================
--- net-2.6.git.orig/net/netfilter/Kconfig	2008-01-02 03:43:36.000000000 +0100
+++ net-2.6.git/net/netfilter/Kconfig	2008-01-02 05:00:44.000000000 +0100
@@ -420,6 +420,30 @@ config NETFILTER_XT_TARGET_CONNSECMARK
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_TARGET_CONNTRACK
+	tristate '"CONNTRACK" target support'
+	depends on NETFILTER_XTABLES
+	depends on NF_CONNTRACK
+	default m if NETFILTER_ADVANCED=n
+	help
+	  The generic CONNTRACK target:
+	  a) allows you to manipulate the connection mark value. Similar
+	  to the MARK target, but affects the connection mark value rather
+	  than the packet mark value.
+	  b) allows you to copy security markings from packets to connections,
+	  and restores security markings from connections to packets (if the
+	  packets are not already marked).  This would normally be used in
+	  conjunction with the SECMARK target.
+	  c) allows you to alter the timeout of specific sessions in the
+	  conntrack/NAT subsystem.  Specific conntracks can be given longer
+	  or shorter timeouts than the global defaults.
+	  d) allows a select rule to specify which packets *not* to enter
+	  the conntrack/NAT subsystem with all the consequences (no ICMP error
+	  tracking, no protocol helpers for the selected packets).
+	  e) allows you to skip ctnetlink events delivery
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NETFILTER_XT_TARGET_TCPMSS
 	tristate '"TCPMSS" target support'
 	depends on NETFILTER_XTABLES && (IPV6 || IPV6=n)
Index: net-2.6.git/net/netfilter/Makefile
===================================================================
--- net-2.6.git.orig/net/netfilter/Makefile	2008-01-02 03:43:36.000000000 +0100
+++ net-2.6.git/net/netfilter/Makefile	2008-01-02 03:44:04.000000000 +0100
@@ -41,6 +41,7 @@ obj-$(CONFIG_NETFILTER_XTABLES) += x_tab
 obj-$(CONFIG_NETFILTER_XT_TARGET_CLASSIFY) += xt_CLASSIFY.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CONNMARK) += xt_CONNMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CONNSECMARK) += xt_CONNSECMARK.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_CONNTRACK) += xt_CONNTRACK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_DSCP) += xt_DSCP.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_MARK) += xt_MARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NFLOG) += xt_NFLOG.o
Index: net-2.6.git/net/netfilter/nf_conntrack_core.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nf_conntrack_core.c	2008-01-02 03:43:36.000000000 +0100
+++ net-2.6.git/net/netfilter/nf_conntrack_core.c	2008-01-02 03:44:04.000000000 +0100
@@ -781,6 +781,10 @@ void __nf_ct_refresh_acct(struct nf_conn
 		return;
 	}
 
+	/* This conntrack has a manual timeout set via iptables */
+	if (test_bit(IPS_MANUAL_TIMEOUT_BIT, &ct->status) && nfct_timeout(ct))
+		extra_jiffies = nfct_timeout(ct)->timeout;
+
 	/* If not in hash table, timer will not be active yet */
 	if (!nf_ct_is_confirmed(ct)) {
 		ct->timeout.expires = extra_jiffies;
Index: net-2.6.git/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2008-01-02 03:43:36.000000000 +0100
+++ net-2.6.git/net/netfilter/nf_conntrack_netlink.c	2008-01-02 04:55:38.000000000 +0100
@@ -4,7 +4,7 @@
  * (C) 2001 by Jay Schulist <jschlst@samba.org>
  * (C) 2002-2006 by Harald Welte <laforge@gnumonks.org>
  * (C) 2003 by Patrick Mchardy <kaber@trash.net>
- * (C) 2005-2007 by Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2005-2008 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
  * Initial connection tracking via netlink development funded and
  * generally made possible by Network Robots, Inc. (www.networkrobots.com)
@@ -427,6 +427,9 @@ static int ctnetlink_conntrack_event(str
 	if (ct == &nf_conntrack_untracked)
 		return NOTIFY_DONE;
 
+	if (events & IPCT_VOLATILE)
+		return NOTIFY_DONE;
+
 	if (events & IPCT_DESTROY) {
 		type = IPCTNL_MSG_CT_DELETE;
 		group = NFNLGRP_CONNTRACK_DESTROY;
Index: net-2.6.git/net/netfilter/xt_CONNTRACK.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ net-2.6.git/net/netfilter/xt_CONNTRACK.c	2008-01-02 05:03:23.000000000 +0100
@@ -0,0 +1,304 @@
+/*
+ * (C) 2008 Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Based on the following previous works:
+ * 	CONNMARK target:	Henrik Nordstrom <hno@marasystems.com>
+ * 	NOTRACK target:		Jeremy Kerr <jk@ozlabs.org>
+ * 	CONNSECMARK target:	James Morris <jmorris@redhat.com>
+ * 	TIMEOUT target:		Phil Oester <kernel@linuxace.com>
+ */
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_CONNTRACK.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_extend.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
+
+#define PFX "xt_CONNTRACK: "
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
+MODULE_DESCRIPTION("ip[6]tables CONNTRACK module");
+MODULE_ALIAS("ipt_CONNTRACK");
+MODULE_ALIAS("ip6t_CONNTRACK");
+
+#define CT_TG_MASK(x) (x->data_0)
+#define CT_TG_MARK(x) (x->data_1)
+
+static void mark_set(struct sk_buff *skb,
+		     struct nf_conn *ct,
+		     const struct xt_conntrack_tg_info *info)
+{
+	u_int32_t newmark;
+
+	newmark = (ct->mark & ~CT_TG_MASK(info)) | CT_TG_MARK(info);
+	if (newmark != ct->mark) {
+		ct->mark = newmark;
+		nf_conntrack_event_cache(IPCT_MARK, skb);
+	}
+}
+
+static void mark_save(struct sk_buff *skb,
+		      struct nf_conn *ct,
+		      const struct xt_conntrack_tg_info *info)
+{
+	u_int32_t newmark;
+
+	newmark = (ct->mark & ~CT_TG_MASK(info)) |
+		  (skb->mark & CT_TG_MASK(info));
+	if (ct->mark != newmark) {
+		ct->mark = newmark;
+		nf_conntrack_event_cache(IPCT_MARK, skb);
+	}
+}
+
+static void mark_restore(struct sk_buff *skb,
+			 struct nf_conn *ct,
+			 const struct xt_conntrack_tg_info *info)
+{
+	u_int32_t mark, diff;
+
+	mark = skb->mark;
+	diff = (ct->mark ^ mark) & CT_TG_MASK(info);
+	skb->mark = mark ^ diff;
+}
+
+static void secmark_save(struct sk_buff *skb,
+			 struct nf_conn *ct,
+			 const struct xt_conntrack_tg_info *info)
+{
+	if (skb->secmark && !ct->secmark) {
+		ct->secmark = skb->secmark;
+		nf_conntrack_event_cache(IPCT_SECMARK, skb);
+	}
+}
+
+static void secmark_restore(struct sk_buff *skb,
+			    struct nf_conn *ct,
+			    const struct xt_conntrack_tg_info *info)
+{
+	if (!skb->secmark && ct->secmark)
+		skb->secmark = ct->secmark;
+}
+
+static void notrack(struct sk_buff *skb,
+		    struct nf_conn *ct,
+		    const struct xt_conntrack_tg_info *info)
+{
+	/* Previously seen (loopback)? Ignore. */
+	if (skb->nfct != NULL)
+		return;
+
+	/* Attach fake conntrack entry.
+	 * If there is a real ct entry correspondig to this packet,
+	 * it'll hang aroun till timing out. We don't deal with it
+	 * for performance reasons. JK */
+	skb->nfct = &nf_conntrack_untracked.ct_general;
+	skb->nfctinfo = IP_CT_NEW;
+	nf_conntrack_get(skb->nfct);
+}
+
+#define CT_TG_TIMEOUT(x) (x->data_0)
+
+static void manual_timeout(struct sk_buff *skb,
+			   struct nf_conn *ct,
+			   const struct xt_conntrack_tg_info *info)
+{
+	struct nf_conn_timeout *timeout_ext;
+
+	timeout_ext = nfct_timeout(ct);
+	if (!timeout_ext) {
+		timeout_ext = nf_ct_ext_add(ct, NF_CT_EXT_TIMEOUT, GFP_ATOMIC);
+		if (timeout_ext == NULL) {
+			pr_debug("failed to add TIMEOUT extension\n");
+			return;
+		}
+	}
+	timeout_ext->timeout = CT_TG_TIMEOUT(info) * HZ;
+	set_bit(IPS_MANUAL_TIMEOUT_BIT, &ct->status);
+}
+
+static void volatile_events(struct sk_buff *skb,
+				  struct nf_conn *ct,
+				  const struct xt_conntrack_tg_info *info)
+{
+	nf_conntrack_event_cache(IPCT_VOLATILE, skb);
+}
+
+typedef void (*ct_tg_array)(struct sk_buff *skb,
+			    struct nf_conn *ct,
+			    const struct xt_conntrack_tg_info *info);
+
+ct_tg_array conntrack_tg_array[CONNTRACK_TG_MAX] = {
+	[CONNTRACK_TG_MARK_SET]			= mark_set,
+	[CONNTRACK_TG_MARK_SAVE]		= mark_save,
+	[CONNTRACK_TG_MARK_RESTORE]		= mark_restore,
+	[CONNTRACK_TG_SECMARK_SAVE]		= secmark_save,
+	[CONNTRACK_TG_SECMARK_RESTORE]		= secmark_restore,
+	[CONNTRACK_TG_NOTRACK]			= notrack,
+	[CONNTRACK_TG_MANUAL_TIMEOUT]		= manual_timeout,
+	[CONNTRACK_TG_VOLATILE_EVENTS]		= volatile_events,
+};
+
+static unsigned int
+conntrack_tg(struct sk_buff *skb, const struct net_device *in,
+             const struct net_device *out, unsigned int hooknum,
+             const struct xt_target *target, const void *targinfo)
+{
+	struct nf_conn *ct;
+	enum ip_conntrack_info ctinfo;
+	const struct xt_conntrack_tg_info *info = targinfo;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct)
+		return XT_CONTINUE;
+
+	if (ct == &nf_conntrack_untracked)
+		return XT_CONTINUE;
+
+	conntrack_tg_array[info->mode](skb, ct, info);
+
+	return XT_CONTINUE;
+}
+
+static bool
+conntrack_tg_check(const char *tablename, const void *entry,
+                   const struct xt_target *target, void *targinfo,
+                   unsigned int hook_mask)
+{
+	const struct xt_conntrack_tg_info *info = targinfo;
+
+	switch(info->mode) {
+	case CONNTRACK_TG_MARK_SET:
+	case CONNTRACK_TG_MARK_SAVE:
+	case CONNTRACK_TG_MARK_RESTORE:
+	case CONNTRACK_TG_SECMARK_SAVE:
+	case CONNTRACK_TG_SECMARK_RESTORE:
+	case CONNTRACK_TG_MANUAL_TIMEOUT:
+	case CONNTRACK_TG_VOLATILE_EVENTS:
+		if (strcmp(tablename, "mangle") != 0) {
+			printk(KERN_INFO PFX "use mode %hu in table "
+					     "`mangle\'\n", info->mode);
+			return false;
+		}
+		break;
+	case CONNTRACK_TG_NOTRACK:
+		if (strcmp(tablename, "raw") != 0) {
+			printk(KERN_INFO PFX "use mode: %hu in table "
+					     "`raw\'\n", info->mode);
+			return false;
+		}
+		break;
+	default:
+		printk(KERN_INFO PFX "unsupported mode: %hu\n", info->mode);
+		return false;
+	}
+
+	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
+		printk(KERN_WARNING "can't load conntrack support for "
+				    "proto=%u\n", target->family);
+		return false;
+	}
+	return true;
+}
+
+static void
+conntrack_tg_destroy(const struct xt_target *target, void *targinfo)
+{
+	nf_ct_l3proto_module_put(target->family);
+}
+
+static struct xt_target conntrack_tg_mangle_reg[] __read_mostly = {
+	{
+		.name		= "CONNTRACK",
+		.family		= AF_INET,
+		.checkentry	= conntrack_tg_check,
+		.destroy	= conntrack_tg_destroy,
+		.target		= conntrack_tg,
+		.targetsize	= sizeof(struct xt_conntrack_tg_info),
+		.table		= "mangle",
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "CONNTRACK",
+		.family		= AF_INET6,
+		.checkentry	= conntrack_tg_check,
+		.destroy	= conntrack_tg_destroy,
+		.target		= conntrack_tg,
+		.targetsize	= sizeof(struct xt_conntrack_tg_info),
+		.table		= "mangle",
+		.me		= THIS_MODULE,
+	},
+};
+
+static struct xt_target conntrack_tg_raw_reg[] __read_mostly = {
+	{
+		.name		= "CONNTRACK",
+		.family		= AF_INET,
+		.checkentry	= conntrack_tg_check,
+		.destroy	= conntrack_tg_destroy,
+		.target		= conntrack_tg,
+		.targetsize	= sizeof(struct xt_conntrack_tg_info),
+		.table		= "raw",
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "CONNTRACK",
+		.family		= AF_INET6,
+		.checkentry	= conntrack_tg_check,
+		.destroy	= conntrack_tg_destroy,
+		.target		= conntrack_tg,
+		.targetsize	= sizeof(struct xt_conntrack_tg_info),
+		.table		= "raw",
+		.me		= THIS_MODULE,
+	},
+};
+
+static struct nf_ct_ext_type timeout_extend __read_mostly = {
+	.len		= sizeof(struct nf_conn_timeout),
+	.align		= __alignof__(struct nf_conn_timeout),
+	.id		= NF_CT_EXT_TIMEOUT,
+};
+
+static int __init conntrack_tg_init(void)
+{
+	int ret;
+
+	ret = nf_ct_extend_register(&timeout_extend);
+	if (ret < 0) {
+		printk(KERN_ERR PFX "unable to register extension\n");
+		return ret;
+	}
+
+	ret = xt_register_targets(conntrack_tg_mangle_reg,
+				  ARRAY_SIZE(conntrack_tg_mangle_reg));
+	if (ret < 0)
+		nf_ct_extend_unregister(&timeout_extend);
+
+	ret = xt_register_targets(conntrack_tg_raw_reg,
+				  ARRAY_SIZE(conntrack_tg_raw_reg));
+	if (ret < 0) {
+		nf_ct_extend_unregister(&timeout_extend);
+		xt_unregister_targets(conntrack_tg_mangle_reg,
+				      ARRAY_SIZE(conntrack_tg_mangle_reg));
+	}
+
+	return ret;
+}
+
+static void __exit conntrack_tg_exit(void)
+{
+	nf_ct_extend_unregister(&timeout_extend);
+	xt_unregister_targets(conntrack_tg_mangle_reg,
+			      ARRAY_SIZE(conntrack_tg_mangle_reg));
+	xt_unregister_targets(conntrack_tg_raw_reg,
+			      ARRAY_SIZE(conntrack_tg_raw_reg));
+}
+
+module_init(conntrack_tg_init);
+module_exit(conntrack_tg_exit);
Index: net-2.6.git/include/linux/netfilter/xt_CONNTRACK.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ net-2.6.git/include/linux/netfilter/xt_CONNTRACK.h	2008-01-02 05:03:40.000000000 +0100
@@ -0,0 +1,22 @@
+#ifndef _XT_CONNTRACK_H_target
+#define _XT_CONNTRACK_H_target
+
+enum {
+	CONNTRACK_TG_MARK_SET = 0,
+	CONNTRACK_TG_MARK_SAVE,
+	CONNTRACK_TG_MARK_RESTORE,
+	CONNTRACK_TG_SECMARK_SAVE,
+	CONNTRACK_TG_SECMARK_RESTORE,
+	CONNTRACK_TG_NOTRACK,
+	CONNTRACK_TG_MANUAL_TIMEOUT,
+	CONNTRACK_TG_VOLATILE_EVENTS,
+	CONNTRACK_TG_MAX
+};
+
+struct xt_conntrack_tg_info {
+	u_int32_t mode;
+	u_int32_t data_0;
+	u_int32_t data_1;
+};
+
+#endif /*_XT_CONNTRACK_H_target */

--------------010704060007060300040603--
