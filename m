Return-Path: <SRS0=UIY/=ZM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B587C432C3
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 13:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D91F222519
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 13:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730136AbfKTNTG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Nov 2019 08:19:06 -0500
Received: from correo.us.es ([193.147.175.20]:49306 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730129AbfKTNTF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Nov 2019 08:19:05 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E675C130E46
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 14:19:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D77ABDA8E8
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 14:19:00 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D6B93DA7B6; Wed, 20 Nov 2019 14:19:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D5CF8DA4CA
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 14:18:58 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 20 Nov 2019 14:18:58 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id BBA5642EE38F
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 14:18:58 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 6/7] netfilter: nf_tables: add decapsulation support
Date:   Wed, 20 Nov 2019 14:18:53 +0100
Message-Id: <20191120131854.308740-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191120131854.308740-1-pablo@netfilter.org>
References: <20191120131854.308740-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds support for the decapsulation infrastructure, including
VLAN support for this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |  16 +++++
 net/netfilter/Kconfig                    |   6 ++
 net/netfilter/Makefile                   |   1 +
 net/netfilter/nft_encap.c                | 119 +++++++++++++++++++++++++++++++
 4 files changed, 142 insertions(+)
 create mode 100644 net/netfilter/nft_encap.c

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 93326a544184..07aa6bba1548 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1629,6 +1629,22 @@ enum nft_xfrm_keys {
 };
 #define NFT_XFRM_KEY_MAX (__NFT_XFRM_KEY_MAX - 1)
 
+enum nft_encap_type {
+	NFT_ENCAP_VLAN	= 0,
+};
+
+/**
+ * enum nft_decap_attributes - nf_tables decapsulation expression netlink attributes
+ *
+ * @NFTA_DECAP_TYPE: decapsulation type (NLA_U32)
+ */
+enum nft_decap_attributes {
+	NFTA_DECAP_UNSPEC,
+	NFTA_DECAP_TYPE,
+	__NFTA_DECAP_MAX,
+};
+#define NFTA_DECAP_MAX	(__NFTA_DECAP_MAX - 1)
+
 /**
  * enum nft_trace_attributes - nf_tables trace netlink attributes
  *
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 91efae88e8c2..573ea56aecfe 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -489,6 +489,12 @@ config NFT_CT
 	  This option adds the "ct" expression that you can use to match
 	  connection tracking information such as the flow state.
 
+config NFT_ENCAP
+	tristate "Netfilter nf_tables encapsulation/decapsulation module"
+	help
+	  This option adds the encapsulation expression used to decapsulate
+	  and to encapsulate packets through VLAN.
+
 config NFT_FLOW_OFFLOAD
 	depends on NF_CONNTRACK && NF_FLOW_TABLE
 	tristate "Netfilter nf_tables hardware flow offload module"
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 5e9b2eb24349..66befd2ac11d 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -89,6 +89,7 @@ obj-$(CONFIG_NFT_COMPAT)	+= nft_compat.o
 obj-$(CONFIG_NFT_CONNLIMIT)	+= nft_connlimit.o
 obj-$(CONFIG_NFT_NUMGEN)	+= nft_numgen.o
 obj-$(CONFIG_NFT_CT)		+= nft_ct.o
+obj-$(CONFIG_NFT_ENCAP)		+= nft_encap.o
 obj-$(CONFIG_NFT_FLOW_OFFLOAD)	+= nft_flow_offload.o
 obj-$(CONFIG_NFT_LIMIT)		+= nft_limit.o
 obj-$(CONFIG_NFT_NAT)		+= nft_nat.o
diff --git a/net/netfilter/nft_encap.c b/net/netfilter/nft_encap.c
new file mode 100644
index 000000000000..657a62e4c283
--- /dev/null
+++ b/net/netfilter/nft_encap.c
@@ -0,0 +1,119 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_core.h>
+#include <net/netfilter/nf_tables.h>
+
+struct nft_decap {
+	enum nft_encap_type	type;
+};
+
+void nft_decap_eval(const struct nft_expr *expr,
+		    struct nft_regs *regs,
+		    const struct nft_pktinfo *pkt)
+{
+	const struct nft_decap *priv = nft_expr_priv(expr);
+	int err;
+
+	switch (priv->type) {
+	case NFT_ENCAP_VLAN:
+		err = skb_vlan_pop(pkt->skb);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		err = -1;
+	}
+
+	if (err < 0)
+		goto decap_error;
+
+	return;
+decap_error:
+	regs->verdict.code = NFT_BREAK;
+}
+
+static const struct nla_policy nft_decap_policy[NFTA_DECAP_MAX + 1] = {
+	[NFTA_DECAP_TYPE]	= { .type = NLA_U32 },
+};
+
+static int nft_decap_init(const struct nft_ctx *ctx,
+			  const struct nft_expr *expr,
+			  const struct nlattr * const tb[])
+{
+	struct nft_decap *priv = nft_expr_priv(expr);
+
+	if (!tb[NFTA_DECAP_TYPE])
+		return -EINVAL;
+
+	priv->type = ntohl(nla_get_be32(tb[NFTA_DECAP_TYPE]));
+	switch (priv->type) {
+	case NFT_ENCAP_VLAN:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int nft_decap_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	const struct nft_decap *priv = nft_expr_priv(expr);
+
+	if (nla_put_be32(skb, NFTA_DECAP_TYPE, htonl(priv->type)))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static int nft_decap_validate(const struct nft_ctx *ctx,
+			      const struct nft_expr *expr,
+			      const struct nft_data **data)
+{
+	if (ctx->family != NFPROTO_NETDEV)
+		return -EOPNOTSUPP;
+
+	return nft_chain_validate_hooks(ctx->chain, 1 << NF_NETDEV_INGRESS);
+}
+
+static struct nft_expr_type nft_decap_type;
+static const struct nft_expr_ops nft_decap_ops = {
+	.type		= &nft_decap_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_decap)),
+	.eval		= nft_decap_eval,
+	.init		= nft_decap_init,
+	.dump		= nft_decap_dump,
+	.validate	= nft_decap_validate,
+};
+
+static struct nft_expr_type nft_decap_type __read_mostly = {
+	.name		= "decap",
+	.ops		= &nft_decap_ops,
+	.policy		= nft_decap_policy,
+	.maxattr	= NFTA_DECAP_MAX,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nft_encap_netdev_module_init(void)
+{
+	return nft_register_expr(&nft_decap_type);
+}
+
+static void __exit nft_encap_netdev_module_exit(void)
+{
+	nft_unregister_expr(&nft_decap_type);
+}
+
+module_init(nft_encap_netdev_module_init);
+module_exit(nft_encap_netdev_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
+MODULE_ALIAS_NFT_AF_EXPR(5, "decap");
-- 
2.11.0

