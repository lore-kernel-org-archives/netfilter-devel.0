Return-Path: <SRS0=xcdV=XD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB409C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Sep 2019 17:32:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA5E920863
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Sep 2019 17:32:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729734AbfIHRcP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 8 Sep 2019 13:32:15 -0400
Received: from correo.us.es ([193.147.175.20]:34024 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbfIHRcP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 8 Sep 2019 13:32:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 11DE4DA710
        for <netfilter-devel@vger.kernel.org>; Sun,  8 Sep 2019 19:32:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 04C6EB7FFE
        for <netfilter-devel@vger.kernel.org>; Sun,  8 Sep 2019 19:32:09 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EEB11B7FFB; Sun,  8 Sep 2019 19:32:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C5458DA72F;
        Sun,  8 Sep 2019 19:32:06 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 08 Sep 2019 19:32:06 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A41F34251480;
        Sun,  8 Sep 2019 19:32:06 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     wenxu@ucloud.cn
Subject: [PATCH nf-next] netfilter: nft_{fwd,dup}_netdev: add offload support
Date:   Sun,  8 Sep 2019 19:32:05 +0200
Message-Id: <20190908173205.7044-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds support for packet mirroring and redirection. The
nft_fwd_dup_netdev_offload() function configures the flow_action object
for the fwd and the dup actions.

Extend nft_flow_rule_destroy() to release the net_device object when the
flow_rule object is released, since nft_fwd_dup_netdev_offload() bumps
the net_device reference counter.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_dup_netdev.h     |  6 ++++++
 include/net/netfilter/nf_tables_offload.h |  3 ++-
 net/netfilter/nf_dup_netdev.c             | 21 +++++++++++++++++++++
 net/netfilter/nf_tables_api.c             |  2 +-
 net/netfilter/nf_tables_offload.c         | 17 ++++++++++++++++-
 net/netfilter/nft_dup_netdev.c            | 12 ++++++++++++
 net/netfilter/nft_fwd_netdev.c            | 12 ++++++++++++
 7 files changed, 70 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_dup_netdev.h b/include/net/netfilter/nf_dup_netdev.h
index 181672672160..b175d271aec9 100644
--- a/include/net/netfilter/nf_dup_netdev.h
+++ b/include/net/netfilter/nf_dup_netdev.h
@@ -7,4 +7,10 @@
 void nf_dup_netdev_egress(const struct nft_pktinfo *pkt, int oif);
 void nf_fwd_netdev_egress(const struct nft_pktinfo *pkt, int oif);
 
+struct nft_offload_ctx;
+struct nft_flow_rule;
+
+int nft_fwd_dup_netdev_offload(struct nft_offload_ctx *ctx,
+			       struct nft_flow_rule *flow,
+			       enum flow_action_id id, int oif);
 #endif
diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index 6de896ebcf30..ddd048be4330 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -26,6 +26,7 @@ struct nft_offload_ctx {
 		u8				protonum;
 	} dep;
 	unsigned int				num_actions;
+	struct net				*net;
 	struct nft_offload_reg			regs[NFT_REG32_15 + 1];
 };
 
@@ -61,7 +62,7 @@ struct nft_flow_rule {
 #define NFT_OFFLOAD_F_ACTION	(1 << 0)
 
 struct nft_rule;
-struct nft_flow_rule *nft_flow_rule_create(const struct nft_rule *rule);
+struct nft_flow_rule *nft_flow_rule_create(struct net *net, const struct nft_rule *rule);
 void nft_flow_rule_destroy(struct nft_flow_rule *flow);
 int nft_flow_rule_offload_commit(struct net *net);
 
diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index 5a35ef08c3cb..e51dd1ec2d5b 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -10,6 +10,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_offload.h>
 #include <net/netfilter/nf_dup_netdev.h>
 
 static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev)
@@ -50,5 +51,25 @@ void nf_dup_netdev_egress(const struct nft_pktinfo *pkt, int oif)
 }
 EXPORT_SYMBOL_GPL(nf_dup_netdev_egress);
 
+int nft_fwd_dup_netdev_offload(struct nft_offload_ctx *ctx,
+			       struct nft_flow_rule *flow,
+			       enum flow_action_id id, int oif)
+{
+	struct flow_action_entry *entry;
+	struct net_device *dev;
+
+	/* nft_flow_rule_destroy() releases the reference on this device. */
+	dev = dev_get_by_index(ctx->net, oif);
+	if (!dev)
+		return -EOPNOTSUPP;
+
+	entry = &flow->rule->action.entries[ctx->num_actions++];
+	entry->id = id;
+	entry->dev = dev;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nft_fwd_dup_netdev_offload);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index efd0c97cc2a3..c6f59ef96017 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2853,7 +2853,7 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 		return nft_table_validate(net, table);
 
 	if (chain->flags & NFT_CHAIN_HW_OFFLOAD) {
-		flow = nft_flow_rule_create(rule);
+		flow = nft_flow_rule_create(net, rule);
 		if (IS_ERR(flow))
 			return PTR_ERR(flow);
 
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 8abf193f8012..239cb781ad13 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -28,7 +28,8 @@ static struct nft_flow_rule *nft_flow_rule_alloc(int num_actions)
 	return flow;
 }
 
-struct nft_flow_rule *nft_flow_rule_create(const struct nft_rule *rule)
+struct nft_flow_rule *nft_flow_rule_create(struct net *net,
+					   const struct nft_rule *rule)
 {
 	struct nft_offload_ctx *ctx;
 	struct nft_flow_rule *flow;
@@ -54,6 +55,7 @@ struct nft_flow_rule *nft_flow_rule_create(const struct nft_rule *rule)
 		err = -ENOMEM;
 		goto err_out;
 	}
+	ctx->net = net;
 	ctx->dep.type = NFT_OFFLOAD_DEP_UNSPEC;
 
 	while (expr->ops && expr != nft_expr_last(rule)) {
@@ -80,6 +82,19 @@ struct nft_flow_rule *nft_flow_rule_create(const struct nft_rule *rule)
 
 void nft_flow_rule_destroy(struct nft_flow_rule *flow)
 {
+	struct flow_action_entry *entry;
+	int i;
+
+	flow_action_for_each(i, entry, &flow->rule->action) {
+		switch (entry->id) {
+		case FLOW_ACTION_REDIRECT:
+		case FLOW_ACTION_MIRRED:
+			dev_put(entry->dev);
+			break;
+		default:
+			break;
+		}
+	}
 	kfree(flow->rule);
 	kfree(flow);
 }
diff --git a/net/netfilter/nft_dup_netdev.c b/net/netfilter/nft_dup_netdev.c
index c6052fdd2c40..c2e78c160fd7 100644
--- a/net/netfilter/nft_dup_netdev.c
+++ b/net/netfilter/nft_dup_netdev.c
@@ -10,6 +10,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_offload.h>
 #include <net/netfilter/nf_dup_netdev.h>
 
 struct nft_dup_netdev {
@@ -56,6 +57,16 @@ static int nft_dup_netdev_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
+static int nft_dup_netdev_offload(struct nft_offload_ctx *ctx,
+				  struct nft_flow_rule *flow,
+				  const struct nft_expr *expr)
+{
+	const struct nft_dup_netdev *priv = nft_expr_priv(expr);
+	int oif = ctx->regs[priv->sreg_dev].data.data[0];
+
+	return nft_fwd_dup_netdev_offload(ctx, flow, FLOW_ACTION_MIRRED, oif);
+}
+
 static struct nft_expr_type nft_dup_netdev_type;
 static const struct nft_expr_ops nft_dup_netdev_ops = {
 	.type		= &nft_dup_netdev_type,
@@ -63,6 +74,7 @@ static const struct nft_expr_ops nft_dup_netdev_ops = {
 	.eval		= nft_dup_netdev_eval,
 	.init		= nft_dup_netdev_init,
 	.dump		= nft_dup_netdev_dump,
+	.offload	= nft_dup_netdev_offload,
 };
 
 static struct nft_expr_type nft_dup_netdev_type __read_mostly = {
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 61b7f93ac681..aba11c2333f3 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -12,6 +12,7 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_offload.h>
 #include <net/netfilter/nf_dup_netdev.h>
 #include <net/neighbour.h>
 #include <net/ip.h>
@@ -63,6 +64,16 @@ static int nft_fwd_netdev_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
+static int nft_fwd_netdev_offload(struct nft_offload_ctx *ctx,
+				  struct nft_flow_rule *flow,
+				  const struct nft_expr *expr)
+{
+	const struct nft_fwd_netdev *priv = nft_expr_priv(expr);
+	int oif = ctx->regs[priv->sreg_dev].data.data[0];
+
+	return nft_fwd_dup_netdev_offload(ctx, flow, FLOW_ACTION_REDIRECT, oif);
+}
+
 struct nft_fwd_neigh {
 	enum nft_registers	sreg_dev:8;
 	enum nft_registers	sreg_addr:8;
@@ -194,6 +205,7 @@ static const struct nft_expr_ops nft_fwd_netdev_ops = {
 	.eval		= nft_fwd_netdev_eval,
 	.init		= nft_fwd_netdev_init,
 	.dump		= nft_fwd_netdev_dump,
+	.offload	= nft_fwd_netdev_offload,
 };
 
 static const struct nft_expr_ops *
-- 
2.11.0

