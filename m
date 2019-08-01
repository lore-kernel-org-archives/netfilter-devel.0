Return-Path: <SRS0=uSEi=V5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE10C19759
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Aug 2019 14:01:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF900205F4
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Aug 2019 14:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731468AbfHAOBi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Aug 2019 10:01:38 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:22733 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731202AbfHAOBi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 10:01:38 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id ECD3341726;
        Thu,  1 Aug 2019 22:01:27 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v3 4/9] netfilter: nft_payload: add nft_set_payload offload support
Date:   Thu,  1 Aug 2019 22:01:21 +0800
Message-Id: <1564668086-16260-5-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564668086-16260-1-git-send-email-wenxu@ucloud.cn>
References: <1564668086-16260-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVS0JNQkJCTE1PT09JT09ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Ogg6Igw6Hzg6SU8wLSofI0NL
        FSEwCh9VSlVKTk1PTU1DS0NDS05KVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhPTU43Bg++
X-HM-Tid: 0a6c4d7c4ead2086kuqyecd3341726
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

currently payload set only support ll header

nft --debug=netlink add rule netdev firewall aclout ip daddr 10.0.1.7 @ll,0,48
set 0x00002e9ca06e2596 @ll,48,48 set 0xfaffffffffff fwd to eth0

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v3: data from source register

 net/netfilter/nft_payload.c | 56 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 22a80eb..980e4a1 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -562,12 +562,68 @@ static int nft_payload_set_dump(struct sk_buff *skb, const struct nft_expr *expr
 	return -1;
 }
 
+static int nft_payload_set_offload(struct nft_offload_ctx *ctx,
+				   struct nft_flow_rule *flow,
+				   const struct nft_expr *expr)
+{
+	const struct nft_payload_set *priv = nft_expr_priv(expr);
+	struct nft_offload_reg *reg = &ctx->regs[priv->sreg];
+	const struct nft_data *data = &reg->data;
+	struct flow_action_entry *entry;
+	u32 len = priv->len;
+	u32 offset, last;
+	int n_actions, i;
+
+	if (priv->base != NFT_PAYLOAD_LL_HEADER || len > 16)
+		return -EOPNOTSUPP;
+
+	offset = priv->offset;
+	n_actions = len >> 2;
+	last = len & 0x3;
+
+	for (i = 0; i < n_actions; i++) {
+		entry = &flow->rule->action.entries[ctx->num_actions++];
+
+		entry->id = FLOW_ACTION_MANGLE;
+		entry->mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_ETH;
+		entry->mangle.mask = 0;
+		entry->mangle.val = data->data[i];
+		entry->mangle.offset = offset;
+		offset = offset + 4;
+	}
+
+	if (last) {
+		entry = &flow->rule->action.entries[ctx->num_actions++];
+
+		entry->id = FLOW_ACTION_MANGLE;
+		entry->mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_ETH;
+		entry->mangle.mask = ~((1 << (last * 8)) - 1);
+		entry->mangle.val = data->data[i];
+		entry->mangle.offset = offset;
+	}
+
+	return 0;
+}
+
+static int nft_payload_set_offload_actions(const struct nft_expr *expr)
+{
+	const struct nft_payload_set *priv = nft_expr_priv(expr);
+	u32 len = priv->len;
+
+	if (priv->base != NFT_PAYLOAD_LL_HEADER || len > 16)
+		return 0;
+
+	return (len >> 2) + !!(len & 3);
+}
+
 static const struct nft_expr_ops nft_payload_set_ops = {
 	.type		= &nft_payload_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_payload_set)),
 	.eval		= nft_payload_set_eval,
 	.init		= nft_payload_set_init,
 	.dump		= nft_payload_set_dump,
+	.offload	= nft_payload_set_offload,
+	.offload_actions = nft_payload_set_offload_actions,
 };
 
 static const struct nft_expr_ops *
-- 
1.8.3.1

