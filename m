Return-Path: <SRS0=uZng=VW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B392C7618B
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 13:34:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A26C22BF5
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 13:34:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388204AbfGYNeH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 09:34:07 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:52410 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388197AbfGYNeH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 09:34:07 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 6ACAF417C3;
        Thu, 25 Jul 2019 21:34:06 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v2 04/11] netfilter: nft_immediate: add offload support for actions
Date:   Thu, 25 Jul 2019 21:33:59 +0800
Message-Id: <1564061644-31189-5-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564061644-31189-1-git-send-email-wenxu@ucloud.cn>
References: <1564061644-31189-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVS0lJS0tLSEpJQ0tOSkNZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Nkk6Sxw6Qjg#KksBDBEjNFE9
        LCNPCQJVSlVKTk1PS01KTU9NTkpMVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhKQ0I3Bg++
X-HM-Tid: 0a6c2956be702086kuqy6acaf417c3
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Immediate offload support for other action to handle the offload_reg

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nft_immediate.c | 47 +++++++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index 391f699..34facc3 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -130,29 +130,42 @@ static int nft_immediate_offload(struct nft_offload_ctx *ctx,
 				 const struct nft_expr *expr)
 {
 	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
+	const struct nft_data *data = &priv->data;
 	struct flow_action_entry *entry;
-	const struct nft_data *data;
-
-	if (priv->dreg != NFT_REG_VERDICT)
-		return -EOPNOTSUPP;
-
-	entry = &flow->rule->action.entries[ctx->num_actions++];
 
-	data = &priv->data;
-	switch (data->verdict.code) {
-	case NF_ACCEPT:
-		entry->id = FLOW_ACTION_ACCEPT;
-		break;
-	case NF_DROP:
-		entry->id = FLOW_ACTION_DROP;
-		break;
-	default:
-		return -EOPNOTSUPP;
+	if (priv->dreg == NFT_REG_VERDICT) {
+		entry = &flow->rule->action.entries[ctx->num_actions++];
+
+		switch (data->verdict.code) {
+		case NF_ACCEPT:
+			entry->id = FLOW_ACTION_ACCEPT;
+			break;
+		case NF_DROP:
+			entry->id = FLOW_ACTION_DROP;
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
+	} else {
+		struct nft_offload_reg *reg = &ctx->regs[priv->dreg];
+
+		reg->type = NFT_OFFLOAD_REG_ACTION;
+		memcpy(&reg->action.data, data, sizeof(*data));
 	}
 
 	return 0;
 }
 
+static int nft_immediate_offload_actions(const struct nft_expr *expr)
+{
+	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
+
+	if (priv->dreg == NFT_REG_VERDICT)
+		return 1;
+	else
+		return 0;
+}
+
 static const struct nft_expr_ops nft_imm_ops = {
 	.type		= &nft_imm_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_immediate_expr)),
@@ -163,7 +176,7 @@ static int nft_immediate_offload(struct nft_offload_ctx *ctx,
 	.dump		= nft_immediate_dump,
 	.validate	= nft_immediate_validate,
 	.offload	= nft_immediate_offload,
-	.offload_actions = nft_offload_action,
+	.offload_actions = nft_immediate_offload_actions,
 };
 
 struct nft_expr_type nft_imm_type __read_mostly = {
-- 
1.8.3.1

