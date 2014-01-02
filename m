From: Eric Leblond <eric@regit.org>
Subject: [PATCH 2/2] netfilter: nftables: introduce ct_set module
Date: Thu,  2 Jan 2014 10:12:56 +0100
Message-ID: <1388653976-30802-3-git-send-email-eric@regit.org>
References: <1388653976-30802-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:54809 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaABJNU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jan 2014 04:13:20 -0500
In-Reply-To: <1388653976-30802-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This module is a port of iptables CT target. It allows
user to setup connection tracking for selected packets.

The context is not containing information about layer 4
so it is necessary to ask to userspace explicitely for
which layer 4 protocol the connection template has to be
created. This is the reason why the  NFTA_CT_SET_PROTO
field has been introduced.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/uapi/linux/netfilter/nf_tables.h |  36 +++++
 net/netfilter/Kconfig                    |   5 +
 net/netfilter/Makefile                   |   1 +
 net/netfilter/nft_ct_set.c               | 262 +++++++++++++++++++++++++++++++
 4 files changed, 304 insertions(+)
 create mode 100644 net/netfilter/nft_ct_set.c

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index aa86a152..96bde79 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -707,6 +707,42 @@ enum nft_reject_attributes {
 #define NFTA_REJECT_MAX		(__NFTA_REJECT_MAX - 1)
 
 /**
+ * enum nft_ct_set_attributes - nf_tables ct_set expression netlink attributes
+ *
+ * @NFTA_CT_SET_PROTO: layer 4 protocol
+ * @NFTA_CT_SET_FLAGS: flags for connection as NOTRACK for example
+ * @NFTA_CT_SET_HELPER: protocol helper to link with matching connections
+ * @NFTA_CT_SET_CTEVENTS: only generate the specified conntrack events
+ * @NFTA_CT_SET_EXPEVENTS: only generate the specified expectation events
+ * @NFTA_CT_SET_ZONEID: assign packet to sone id
+ * @NFTA_CT_SET_TIMEOUT: use timeout policy for the connection
+ *
+ */
+enum nft_ct_set_attributes {
+	NFTA_CT_SET_UNSPEC,
+	NFTA_CT_SET_PROTO,
+	NFTA_CT_SET_FLAGS,
+	NFTA_CT_SET_HELPER,
+	NFTA_CT_SET_CTEVENTS,
+	NFTA_CT_SET_EXPEVENTS,
+	NFTA_CT_SET_ZONEID,
+	NFTA_CT_SET_TIMEOUT,
+	__NFTA_CT_SET_MAX
+};
+#define NFTA_CT_SET_MAX		(__NFTA_CT_SET_MAX - 1)
+
+/**
+ * enum nft_ct_set_flags - nf_tables ct_set flags
+ *
+ * @NFT_CT_SET_F_NOTRACK: do not track this connection
+ */
+enum nft_ct_set_flags {
+
+enum nft_ct_set_flags {
+	NFT_CT_SET_F_NOTRACK = 0x1,
+};
+
+/**
  * enum nft_nat_types - nf_tables nat expression NAT types
  *
  * @NFT_NAT_SNAT: source NAT
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index a1dec61..448c389 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -430,6 +430,11 @@ config NFT_CT
 	depends on NF_CONNTRACK
 	tristate "Netfilter nf_tables conntrack module"
 
+config NFT_CT_SET
+	depends on NF_TABLES
+	depends on NF_CONNTRACK
+	tristate "Netfilter nf_tables conntrack setup module"
+
 config NFT_RBTREE
 	depends on NF_TABLES
 	tristate "Netfilter nf_tables rbtree set module"
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 39e4a7b..f50c501 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -74,6 +74,7 @@ obj-$(CONFIG_NFT_COMPAT)	+= nft_compat.o
 obj-$(CONFIG_NFT_EXTHDR)	+= nft_exthdr.o
 obj-$(CONFIG_NFT_META)		+= nft_meta.o
 obj-$(CONFIG_NFT_CT)		+= nft_ct.o
+obj-$(CONFIG_NFT_CT_SET)	+= nft_ct_set.o
 obj-$(CONFIG_NFT_LIMIT)		+= nft_limit.o
 obj-$(CONFIG_NFT_NAT)		+= nft_nat.o
 obj-$(CONFIG_NFT_QUEUE)		+= nft_queue.o
diff --git a/net/netfilter/nft_ct_set.c b/net/netfilter/nft_ct_set.c
new file mode 100644
index 0000000..93e862d
--- /dev/null
+++ b/net/netfilter/nft_ct_set.c
@@ -0,0 +1,262 @@
+/*
+ * Copyright (c) 2014 Eric Leblond <eric@regit.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netlink.h>
+#include <linux/rculist_nulls.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_ct_set.h>
+
+struct nft_ct_set {
+	__u16	flags;
+	__u16	zoneid;
+	__u32	ct_events;
+	__u32	exp_events;
+	char	*helper;
+	char	*timeout;
+
+	/* Used internally by the kernel */
+	struct nf_conn	*ct __attribute__((aligned(8)));
+	__u16	proto;
+};
+
+static void nft_ct_set_eval(const struct nft_expr *expr,
+			   struct nft_data data[NFT_REG_MAX + 1],
+			   const struct nft_pktinfo *pkt)
+{
+	struct nft_ct_set *priv = nft_expr_priv(expr);
+	struct nf_conn *ct;
+
+	if (pkt->skb->nfct != NULL)
+		return;
+
+	if (priv->flags & NFT_CT_SET_F_NOTRACK)
+		ct = nf_ct_untracked_get();
+	else
+		ct = priv->ct;
+
+	atomic_inc(&ct->ct_general.use);
+	pkt->skb->nfct = &ct->ct_general;
+	pkt->skb->nfctinfo = IP_CT_NEW;
+}
+
+static const struct nla_policy nft_ct_set_policy[NFTA_CT_SET_MAX + 1] = {
+	[NFTA_CT_SET_FLAGS]	= { .type = NLA_U16 },
+	[NFTA_CT_SET_HELPER]	= { .type = NLA_STRING },
+	[NFTA_CT_SET_CTEVENTS]	= { .type = NLA_U32 },
+	[NFTA_CT_SET_EXPEVENTS]	= { .type = NLA_U32 },
+	[NFTA_CT_SET_ZONEID]	= { .type = NLA_U16 },
+	[NFTA_CT_SET_TIMEOUT]	= { .type = NLA_STRING },
+};
+
+static int nft_ct_set_init(const struct nft_ctx *ctx,
+			   const struct nft_expr *expr,
+			   const struct nlattr * const tb[])
+{
+	struct nft_ct_set *priv = nft_expr_priv(expr);
+	const struct nlattr *nla;
+	struct nf_conntrack_tuple t;
+	struct nf_conn *ct;
+	int ret = -EOPNOTSUPP;
+
+
+	if (tb[NFTA_CT_SET_PROTO] != NULL)
+		priv->proto = ntohs(nla_get_be16(tb[NFTA_CT_SET_PROTO]));
+	else
+		return -EINVAL;
+
+	if (tb[NFTA_CT_SET_FLAGS] != NULL)
+		priv->flags = ntohs(nla_get_be16(tb[NFTA_CT_SET_FLAGS]));
+
+	if (priv->flags & NFT_CT_SET_F_NOTRACK) {
+		ct = NULL;
+		goto out;
+	}
+
+	if (tb[NFTA_CT_SET_HELPER] != NULL) {
+		nla = tb[NFTA_CT_SET_HELPER];
+		priv->helper = kmalloc(nla_len(nla) + 1, GFP_KERNEL);
+		if (priv->helper == NULL)
+			return -ENOMEM;
+		nla_strlcpy(priv->helper, nla, nla_len(nla) + 1);
+	}
+
+	if (tb[NFTA_CT_SET_CTEVENTS] != NULL)
+		priv->ct_events = ntohl(nla_get_be32(tb[NFTA_CT_SET_CTEVENTS]));
+
+	if (tb[NFTA_CT_SET_EXPEVENTS] != NULL)
+		priv->exp_events =
+			ntohl(nla_get_be32(tb[NFTA_CT_SET_EXPEVENTS]));
+
+	if (tb[NFTA_CT_SET_ZONEID] != NULL) {
+#ifndef CONFIG_NF_CONNTRACK_ZONES
+		goto err1;
+#endif
+		priv->zoneid = ntohs(nla_get_be16(tb[NFTA_CT_SET_ZONEID]));
+	}
+
+	if (tb[NFTA_CT_SET_TIMEOUT] != NULL) {
+#ifndef CONFIG_NF_CONNTRACK_TIMEOUT
+		goto err1;
+#endif
+		nla = tb[NFTA_CT_SET_TIMEOUT];
+		priv->timeout = kmalloc(nla_len(nla) + 1, GFP_KERNEL);
+		if (priv->timeout == NULL) {
+			ret = -ENOMEM;
+			goto err1;
+		}
+		nla_strlcpy(priv->timeout, nla, nla_len(nla) + 1);
+	}
+
+	ret = nf_ct_l3proto_try_module_get(ctx->afi->family);
+	if (ret < 0)
+		goto err1;
+
+	memset(&t, 0, sizeof(t));
+	ct = nf_conntrack_alloc(ctx->net, priv->zoneid, &t, &t, GFP_KERNEL);
+	ret = PTR_ERR(ct);
+	if (IS_ERR(ct))
+		goto err2;
+
+	ret = 0;
+	if ((priv->ct_events || priv->exp_events) &&
+	    !nf_ct_ecache_ext_add(ct, priv->ct_events, priv->exp_events,
+				  GFP_KERNEL)) {
+		ret = -EINVAL;
+		goto err3;
+	}
+
+	if (priv->helper) {
+		ret = nf_ct_set_helper(ct, priv->helper, priv->proto,
+				       ctx->afi->family);
+		if (ret < 0)
+			goto err3;
+	}
+
+	if (priv->timeout) {
+		ret = nf_ct_set_timeout(ct, priv->proto, ctx->afi->family,
+					priv->timeout);
+		if (ret < 0)
+			goto err3;
+	}
+
+	__set_bit(IPS_TEMPLATE_BIT, &ct->status);
+	__set_bit(IPS_CONFIRMED_BIT, &ct->status);
+
+	/* Overload tuple linked list to put us in template list. */
+	hlist_nulls_add_head_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode,
+				 &ctx->net->ct.tmpl);
+
+out:
+	priv->ct = ct;
+	return 0;
+
+err3:
+	nf_conntrack_free(ct);
+err2:
+	nf_ct_l3proto_module_put(ctx->afi->family);
+
+err1:
+	if (priv->helper)
+		kfree(priv->helper);
+	if (priv->timeout)
+		kfree(priv->timeout);
+	return ret;
+}
+
+static int nft_ct_set_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	const struct nft_ct_set *priv = nft_expr_priv(expr);
+
+	if (nla_put_be16(skb, NFTA_CT_SET_FLAGS, htons(priv->flags)) ||
+	    nla_put_be16(skb, NFTA_CT_SET_ZONEID, htons(priv->zoneid)) ||
+	    nla_put_be16(skb, NFTA_CT_SET_PROTO, htons(priv->proto)) ||
+	    nla_put_be32(skb, NFTA_CT_SET_CTEVENTS, htons(priv->ct_events)) ||
+	    nla_put_be32(skb, NFTA_CT_SET_EXPEVENTS, htons(priv->exp_events)))
+		goto nla_put_failure;
+	if (priv->helper)
+		if (nla_put_string(skb, NFTA_CT_SET_HELPER, priv->helper))
+			goto nla_put_failure;
+	if (priv->timeout)
+		if (nla_put_string(skb, NFTA_CT_SET_TIMEOUT, priv->timeout))
+			goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+
+static void nft_ct_set_destroy(const struct nft_expr *expr) {
+	struct nft_ct_set *priv = nft_expr_priv(expr);
+	struct nf_conn_help *help;
+	struct nf_conn *ct = NULL;
+
+	if (priv->helper)
+		kfree(priv->helper);
+
+	if (priv->timeout)
+		kfree(priv->timeout);
+
+	ct = priv->ct;
+	if (ct) {
+		help = nfct_help(ct);
+		if (help)
+			module_put(help->helper->me);
+
+		/* FIXME */
+#if 0
+		nf_ct_l3proto_module_put(par->family);
+#endif
+
+		nf_ct_destroy_timeout(ct);
+		nf_ct_put(priv->ct);
+	}
+}
+
+static struct nft_expr_type nft_ct_set_type;
+static const struct nft_expr_ops nft_ct_set_ops = {
+	.type		= &nft_ct_set_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_ct_set)),
+	.eval		= nft_ct_set_eval,
+	.init		= nft_ct_set_init,
+	.dump		= nft_ct_set_dump,
+	.destroy	= nft_ct_set_destroy,
+};
+
+static struct nft_expr_type nft_ct_set_type __read_mostly = {
+	.name		= "ct_set",
+	.ops		= &nft_ct_set_ops,
+	.policy		= nft_ct_set_policy,
+	.maxattr	= NFTA_CT_SET_MAX,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nft_ct_set_module_init(void)
+{
+	return nft_register_expr(&nft_ct_set_type);
+}
+
+static void __exit nft_ct_set_module_exit(void)
+{
+	nft_unregister_expr(&nft_ct_set_type);
+}
+
+module_init(nft_ct_set_module_init);
+module_exit(nft_ct_set_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Eric Leblond <eric@regit.org>");
+MODULE_ALIAS_NFT_EXPR("ct_set");
-- 
1.8.5.2

