Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D655CC47096
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Jun 2021 23:38:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF62C6140A
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Jun 2021 23:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhFCXkY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Jun 2021 19:40:24 -0400
Received: from mail.netfilter.org ([217.70.188.207]:45938 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbhFCXkX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Jun 2021 19:40:23 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 98B37641FD
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Jun 2021 01:37:29 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_tables: add last expression
Date:   Fri,  4 Jun 2021 01:38:31 +0200
Message-Id: <20210603233831.21962-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a new optional expression that allows you to know when last match on
a given rule / set element.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 13 ++++
 net/netfilter/Kconfig                    |  6 ++
 net/netfilter/Makefile                   |  1 +
 net/netfilter/nft_last.c                 | 94 ++++++++++++++++++++++++
 4 files changed, 114 insertions(+)
 create mode 100644 net/netfilter/nft_last.c

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 19715e2679d1..1c5814e3b2b2 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1195,6 +1195,19 @@ enum nft_counter_attributes {
 };
 #define NFTA_COUNTER_MAX	(__NFTA_COUNTER_MAX - 1)
 
+/**
+ * enum nft_last_attributes - nf_tables last expression netlink attributes
+ *
+ * @NFTA_LAST_MSECS: number of bytes (NLA_U64)
+ */
+enum nft_last_attributes {
+	NFTA_LAST_UNSPEC,
+	NFTA_LAST_MSECS,
+	NFTA_LAST_PAD,
+	__NFTA_LAST_MAX
+};
+#define NFTA_LAST_MAX	(__NFTA_LAST_MAX - 1)
+
 /**
  * enum nft_log_attributes - nf_tables log expression netlink attributes
  *
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 172d74560632..cf113cbfb69e 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -509,6 +509,12 @@ config NFT_CONNLIMIT
 	  This option adds the "connlimit" expression that you can use to
 	  ratelimit rule matchings per connections.
 
+config NFT_LAST
+	tristate "Netfilter nf_tables last module"
+	help
+	  This option adds the "last" expression that you can use to know
+	  when this rule has matched last time.
+
 config NFT_LOG
 	tristate "Netfilter nf_tables log module"
 	help
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index e80e010354b1..60204c6542e7 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -100,6 +100,7 @@ obj-$(CONFIG_NFT_REJECT_INET)	+= nft_reject_inet.o
 obj-$(CONFIG_NFT_REJECT_NETDEV)	+= nft_reject_netdev.o
 obj-$(CONFIG_NFT_TUNNEL)	+= nft_tunnel.o
 obj-$(CONFIG_NFT_COUNTER)	+= nft_counter.o
+obj-$(CONFIG_NFT_LAST)		+= nft_last.o
 obj-$(CONFIG_NFT_LOG)		+= nft_log.o
 obj-$(CONFIG_NFT_MASQ)		+= nft_masq.o
 obj-$(CONFIG_NFT_REDIR)		+= nft_redir.o
diff --git a/net/netfilter/nft_last.c b/net/netfilter/nft_last.c
new file mode 100644
index 000000000000..14b3aa27d4c4
--- /dev/null
+++ b/net/netfilter/nft_last.c
@@ -0,0 +1,94 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/seqlock.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables.h>
+
+struct nft_last_priv {
+	unsigned long last_jiffies;
+};
+
+static const struct nla_policy nft_last_policy[NFTA_LAST_MAX + 1] = {
+	[NFTA_LAST_MSECS] = { .type = NLA_U64 },
+};
+
+static int nft_last_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
+			 const struct nlattr * const tb[])
+{
+	struct nft_last_priv *priv = nft_expr_priv(expr);
+	u64 last;
+	int err;
+
+	if (tb[NFTA_LAST_MSECS]) {
+		err = nf_msecs_to_jiffies64(tb[NFTA_LAST_MSECS], &last);
+		if (err < 0)
+			return err;
+
+		priv->last_jiffies = (unsigned long)last;
+	}
+
+	return 0;
+}
+
+static void nft_last_eval(const struct nft_expr *expr,
+			  struct nft_regs *regs, const struct nft_pktinfo *pkt)
+{
+	struct nft_last_priv *priv = nft_expr_priv(expr);
+
+	priv->last_jiffies = jiffies;
+}
+
+static int nft_last_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	struct nft_last_priv *priv = nft_expr_priv(expr);
+
+	if (nla_put_be64(skb, NFTA_LAST_MSECS,
+			 nf_jiffies64_to_msecs(priv->last_jiffies),
+			 NFTA_LAST_PAD))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static struct nft_expr_type nft_last_type;
+static const struct nft_expr_ops nft_last_ops = {
+	.type		= &nft_last_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_last_priv)),
+	.eval		= nft_last_eval,
+	.init		= nft_last_init,
+	.dump		= nft_last_dump,
+};
+
+static struct nft_expr_type nft_last_type __read_mostly = {
+	.name		= "last",
+	.ops		= &nft_last_ops,
+	.policy		= nft_last_policy,
+	.maxattr	= NFTA_LAST_MAX,
+	.flags		= NFT_EXPR_STATEFUL,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nft_last_module_init(void)
+{
+	return nft_register_expr(&nft_last_type);
+}
+
+static void __exit nft_last_module_exit(void)
+{
+	nft_unregister_expr(&nft_last_type);
+}
+
+module_init(nft_last_module_init);
+module_exit(nft_last_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
+MODULE_ALIAS_NFT_EXPR("last");
+MODULE_DESCRIPTION("nftables last expression support");
-- 
2.20.1

