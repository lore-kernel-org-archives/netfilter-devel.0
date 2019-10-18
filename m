Return-Path: <SRS0=5/AD=YL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A6E7CA9EA1
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Oct 2019 10:02:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 607B621D7C
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Oct 2019 10:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437609AbfJRKC5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Oct 2019 06:02:57 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:10943 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389081AbfJRKC4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Oct 2019 06:02:56 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id DECF941B39;
        Fri, 18 Oct 2019 18:02:48 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_tables: add vlan support
Date:   Fri, 18 Oct 2019 18:02:48 +0800
Message-Id: <1571392968-1263-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVJTEJCQkJCTEpIQ0JMTFlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PBg6Sxw6Sjg#DxkrMBNIFj8t
        VhgwC0lVSlVKTkxKSEJJQk1CS0lJVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUxISUw3Bg++
X-HM-Tid: 0a6dde51d8db2086kuqydecf941b39
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch implements the vlan expr type that can be used to
configure vlan tci and vlan proto

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/uapi/linux/netfilter/nf_tables.h |  24 +++++
 net/netfilter/Kconfig                    |   6 ++
 net/netfilter/Makefile                   |   1 +
 net/netfilter/nft_vlan.c                 | 152 +++++++++++++++++++++++++++++++
 4 files changed, 183 insertions(+)
 create mode 100644 net/netfilter/nft_vlan.c

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 81fed16..eb2e635 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1796,4 +1796,28 @@ enum nft_tunnel_attributes {
 };
 #define NFTA_TUNNEL_MAX	(__NFTA_TUNNEL_MAX - 1)
 
+enum nft_vlan_action {
+	NFT_VLAN_ACTION_PUSH,
+	NFT_VLAN_ACTION_POP,
+	NFT_VLAN_ACTION_MODIFY,
+	__NFT_VLAN_ACTION_MAX
+};
+#define NFT_VLAN_ACTION_MAX	(__NFT_VLAN_ACTION_MAX - 1)
+
+/**
+ * enum nft_vlan_attributes - nf_tables vlan expression netlink attributes
+ *
+ * @NFTA_VLAN_ACTION: vlan data item to load (NLA_U32: nft_vlan_action)
+ * @NFTA_VLAN_SREG: source register (NLA_U16)
+ * @NFTA_VLAN_SREG2: source register (NLA_U16)
+ */
+enum nft_vlan_attributes {
+	NFTA_VLAN_UNSPEC,
+	NFTA_VLAN_ACTION,
+	NFTA_VLAN_SREG,
+	NFTA_VLAN_SREG2,
+	__NFTA_VLAN_MAX
+};
+#define NFTA_VLAN_MAX		(__NFTA_VLAN_MAX - 1)
+
 #endif /* _LINUX_NF_TABLES_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 91efae8..6583f30 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -556,6 +556,12 @@ config NFT_TUNNEL
 	  This option adds the "tunnel" expression that you can use to set
 	  tunneling policies.
 
+config NFT_VLAN
+	tristate "Netfilter nf_tables vlan module"
+	help
+	  This option adds the "vlan" expression that you can use to set
+	  vlan policies.
+
 config NFT_OBJREF
 	tristate "Netfilter nf_tables stateful object reference module"
 	help
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 4fc075b..e91f93e 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -111,6 +111,7 @@ obj-$(CONFIG_NFT_OSF)		+= nft_osf.o
 obj-$(CONFIG_NFT_TPROXY)	+= nft_tproxy.o
 obj-$(CONFIG_NFT_XFRM)		+= nft_xfrm.o
 obj-$(CONFIG_NFT_SYNPROXY)	+= nft_synproxy.o
+obj-$(CONFIG_NFT_VLAN)		+= nft_vlan.o
 
 obj-$(CONFIG_NFT_NAT)		+= nft_chain_nat.o
 
diff --git a/net/netfilter/nft_vlan.c b/net/netfilter/nft_vlan.c
new file mode 100644
index 0000000..1521b97
--- /dev/null
+++ b/net/netfilter/nft_vlan.c
@@ -0,0 +1,152 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/kernel.h>
+#include <linux/netlink.h>
+#include <linux/module.h>
+#include <linux/if_vlan.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_core.h>
+
+struct nft_vlan {
+	enum nft_vlan_action    action;
+	enum nft_registers	sreg:8;
+	enum nft_registers	sreg2:8;
+};
+
+static void nft_vlan_set_eval(const struct nft_expr *expr,
+			      struct nft_regs *regs,
+			      const struct nft_pktinfo *pkt)
+{
+	const struct nft_vlan *p_vlan = nft_expr_priv(expr);
+	u32 *sreg2 = &regs->data[p_vlan->sreg2];
+	u16 vlan_proto = nft_reg_load16(sreg2);
+	u32 *sreg = &regs->data[p_vlan->sreg];
+	u16 vlan_tci = nft_reg_load16(sreg);
+	struct sk_buff *skb = pkt->skb;
+
+	switch (p_vlan->action) {
+	case NFT_VLAN_ACTION_POP:
+		skb_vlan_pop(skb);
+		break;
+	case NFT_VLAN_ACTION_PUSH: {
+		if (vlan_proto != ETH_P_8021Q && vlan_proto != ETH_P_8021AD)
+			return;
+
+		skb_push_rcsum(skb, skb->mac_len);
+		skb_vlan_push(skb, htons(vlan_proto), vlan_tci & VLAN_VID_MASK);
+		skb_pull_rcsum(skb, skb->mac_len);
+		break;
+	}
+	case NFT_VLAN_ACTION_MODIFY: {
+		u16 tci;
+
+		/* No-op if no vlan tag (either hw-accel or in-payload) */
+		if (!skb_vlan_tagged(skb))
+			return;
+
+		/* extract existing tag (and guarantee no hw-accel tag) */
+		if (skb_vlan_tag_present(skb)) {
+			tci = skb_vlan_tag_get(skb);
+			__vlan_hwaccel_clear_tag(skb);
+		} else {
+			/* in-payload vlan tag, pop it */
+			if (__skb_vlan_pop(skb, &tci))
+				return;
+		}
+
+		/* replace the vid */
+		vlan_tci = vlan_tci | VLAN_VID_MASK;
+		vlan_tci = (tci & ~VLAN_VID_MASK) | vlan_tci;
+
+		/* put updated tci as hwaccel tag */
+		__vlan_hwaccel_put_tag(skb, vlan_proto, vlan_tci);
+		break;
+	}
+	default:
+		WARN_ON(1);
+	}
+}
+
+static const struct nla_policy nft_vlan_policy[NFTA_VLAN_MAX + 1] = {
+	[NFTA_VLAN_ACTION]	= { .type = NLA_U32 },
+	[NFTA_VLAN_SREG]	= { .type = NLA_U32 },
+	[NFTA_VLAN_SREG2]	= { .type = NLA_U32 },
+};
+
+static int nft_vlan_set_init(const struct nft_ctx *ctx,
+			     const struct nft_expr *expr,
+			     const struct nlattr * const tb[])
+{
+	struct nft_vlan *priv = nft_expr_priv(expr);
+	int err;
+
+	priv->action = ntohl(nla_get_be32(tb[NFTA_VLAN_ACTION]));
+	switch (priv->action) {
+	case NFT_VLAN_ACTION_PUSH:
+	case NFT_VLAN_ACTION_POP:
+	case NFT_VLAN_ACTION_MODIFY:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	priv->sreg = nft_parse_register(tb[NFTA_VLAN_SREG]);
+	err = nft_validate_register_load(priv->sreg, sizeof(u16));
+	if (err < 0)
+		return err;
+
+	priv->sreg2 = nft_parse_register(tb[NFTA_VLAN_SREG2]);
+	err = nft_validate_register_load(priv->sreg2, sizeof(u16));
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+static int nft_vlan_set_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	const struct nft_vlan *priv = nft_expr_priv(expr);
+
+	if (nla_put_be32(skb, NFTA_VLAN_ACTION, htonl(priv->action)))
+		goto nla_put_failure;
+	if (nft_dump_register(skb, NFTA_VLAN_SREG, priv->sreg))
+		goto nla_put_failure;
+	if (nft_dump_register(skb, NFTA_VLAN_SREG2, priv->sreg2))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static struct nft_expr_type nft_vlan_type;
+static const struct nft_expr_ops nft_vlan_set_ops = {
+	.type		= &nft_vlan_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_vlan)),
+	.eval		= nft_vlan_set_eval,
+	.init		= nft_vlan_set_init,
+	.dump		= nft_vlan_set_dump,
+};
+
+static struct nft_expr_type nft_vlan_type __read_mostly = {
+	.name		= "vlan",
+	.ops		= &nft_vlan_set_ops,
+	.policy		= nft_vlan_policy,
+	.maxattr	= NFTA_VLAN_MAX,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nft_vlan_module_init(void)
+{
+	return nft_register_expr(&nft_vlan_type);
+}
+
+static void __exit nft_vlan_module_exit(void)
+{
+	nft_unregister_expr(&nft_vlan_type);
+}
+
+module_init(nft_vlan_module_init);
+module_exit(nft_vlan_module_exit);
-- 
1.8.3.1

