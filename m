Return-Path: <SRS0=qEnH=WK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5FC3C32753
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 10:16:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B397205F4
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 10:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbfHNKQv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 06:16:51 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:55410 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727220AbfHNKQv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 06:16:51 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id A7A1F41BBB;
        Wed, 14 Aug 2019 18:16:49 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v4 03/12] netfilter: nft_fwd_netdev: add fw_netdev action support
Date:   Wed, 14 Aug 2019 18:16:39 +0800
Message-Id: <1565777808-28735-4-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1565777808-28735-1-git-send-email-wenxu@ucloud.cn>
References: <1565777808-28735-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUlDQkJCQkxJSE9IT09ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MhA6USo5CTg0HzkPKDAVCD89
        A04aCVFVSlVKTk1OTExMQ0tCTENLVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlMTU43Bg++
X-HM-Tid: 0a6c8fa151282086kuqya7a1f41bbb
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

fwd_netdev action offload:
nft --debug=netlink add rule netdev firewall aclout ip daddr 10.0.1.7 fwd to eth0

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v4: no change

 net/netfilter/nft_fwd_netdev.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 61b7f93..c5af66b 100644
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
@@ -194,6 +219,8 @@ static int nft_fwd_neigh_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	.eval		= nft_fwd_netdev_eval,
 	.init		= nft_fwd_netdev_init,
 	.dump		= nft_fwd_netdev_dump,
+	.offload	= nft_fwd_netdev_offload,
+	.offload_actions = nft_offload_action,
 };
 
 static const struct nft_expr_ops *
-- 
1.8.3.1

