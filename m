Return-Path: <SRS0=lxoE=WR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC093C3A59E
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 04:56:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C21FE22DD3
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 04:56:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbfHUE4r (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Aug 2019 00:56:47 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:18879 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbfHUE4r (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Aug 2019 00:56:47 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 1352C410B2;
        Wed, 21 Aug 2019 12:56:42 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v5 2/2] netfilter: nft_fwd_netdev: add fw_netdev action support
Date:   Wed, 21 Aug 2019 12:56:39 +0800
Message-Id: <1566363399-30976-3-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1566363399-30976-1-git-send-email-wenxu@ucloud.cn>
References: <1566363399-30976-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVSk9KS0tLSUxLQ09ITkpZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PzY6HBw4Azg0Fz88Qx4iPgo#
        DS8aCjhVSlVKTk1NSE1IT0tJSkxNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlMSE03Bg++
X-HM-Tid: 0a6cb288bf732086kuqy1352c410b2
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

fwd_netdev action offload:
nft --debug=netlink add rule netdev firewall aclout ip daddr 10.0.1.7 fwd to eth0

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v5: no offload_actions callback

 net/netfilter/nft_fwd_netdev.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 61b7f93..8c52765 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -15,6 +15,7 @@
 #include <net/netfilter/nf_dup_netdev.h>
 #include <net/neighbour.h>
 #include <net/ip.h>
+#include <net/netfilter/nf_tables_offload.h>
 
 struct nft_fwd_netdev {
 	enum nft_registers	sreg_dev:8;
@@ -63,6 +64,30 @@ static int nft_fwd_netdev_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
+static int nft_fwd_netdev_offload(struct nft_offload_ctx *ctx,
+				  struct nft_flow_rule *flow,
+				  const struct nft_expr *expr)
+{
+	const struct nft_fwd_netdev *priv = nft_expr_priv(expr);
+	struct nft_offload_reg *reg = &ctx->regs[priv->sreg_dev];
+	const struct nft_data *data = &reg->data;
+	struct flow_action_entry *entry;
+	struct net_device *dev;
+	int oif = -1;
+
+	entry = &flow->rule->action.entries[ctx->num_actions++];
+
+	memcpy(&oif, data->data, sizeof(oif));
+	dev = __dev_get_by_index(ctx->net, oif);
+	if (!dev)
+		return -EOPNOTSUPP;
+
+	entry->id = FLOW_ACTION_REDIRECT;
+	entry->dev = dev;
+
+	return 0;
+}
+
 struct nft_fwd_neigh {
 	enum nft_registers	sreg_dev:8;
 	enum nft_registers	sreg_addr:8;
@@ -194,6 +219,7 @@ static int nft_fwd_neigh_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	.eval		= nft_fwd_netdev_eval,
 	.init		= nft_fwd_netdev_init,
 	.dump		= nft_fwd_netdev_dump,
+	.offload	= nft_fwd_netdev_offload,
 };
 
 static const struct nft_expr_ops *
-- 
1.8.3.1

