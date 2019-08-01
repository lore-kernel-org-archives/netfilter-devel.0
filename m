Return-Path: <SRS0=uSEi=V5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4626AC19759
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Aug 2019 14:01:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2682B205F4
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Aug 2019 14:01:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731414AbfHAOBg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Aug 2019 10:01:36 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:22707 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731334AbfHAOBf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 10:01:35 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id BAD0A41633;
        Thu,  1 Aug 2019 22:01:27 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v3 2/9] netfilter: nf_tables_offload: add offload_actions callback
Date:   Thu,  1 Aug 2019 22:01:19 +0800
Message-Id: <1564668086-16260-3-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564668086-16260-1-git-send-email-wenxu@ucloud.cn>
References: <1564668086-16260-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVS0pJS0tLS0NIQklISE9ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MVE6Ejo6MDg#HE88PSo4IwMa
        FxQKCzJVSlVKTk1PTU1DS0NMQ05LVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhDTEI3Bg++
X-HM-Tid: 0a6c4d7c4de12086kuqybad0a41633
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

There will be zero one or serval actions for some expr. such as
payload set and immediate. The one payload set action maybe split
to several offload entries. And only NFT_REG_VERDICT immediate
action has 1 offload entry

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v3: no change

 include/net/netfilter/nf_tables.h         | 7 ++++++-
 include/net/netfilter/nf_tables_offload.h | 2 --
 net/netfilter/nf_tables_offload.c         | 4 ++--
 net/netfilter/nft_immediate.c             | 2 +-
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 9b62456..9285df2 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -785,7 +785,7 @@ struct nft_expr_ops {
 	int				(*offload)(struct nft_offload_ctx *ctx,
 						   struct nft_flow_rule *flow,
 						   const struct nft_expr *expr);
-	u32				offload_flags;
+	int				(*offload_actions)(const struct nft_expr *expr);
 	const struct nft_expr_type	*type;
 	void				*data;
 };
@@ -794,6 +794,11 @@ struct nft_expr_ops {
 #define NFT_EXPR_SIZE(size)		(sizeof(struct nft_expr) + \
 					 ALIGN(size, __alignof__(struct nft_expr)))
 
+static inline int nft_offload_action(const struct nft_expr *expr)
+{
+	return 1;
+}
+
 /**
  *	struct nft_expr - nf_tables expression
  *
diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index ad61958..275d014 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -58,8 +58,6 @@ struct nft_flow_rule {
 	struct flow_rule	*rule;
 };
 
-#define NFT_OFFLOAD_F_ACTION	(1 << 0)
-
 struct nft_rule;
 struct nft_flow_rule *nft_flow_rule_create(struct net *net, const struct nft_rule *rule);
 void nft_flow_rule_destroy(struct nft_flow_rule *flow);
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 5c1fef7..33543f5 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -42,8 +42,8 @@ struct nft_flow_rule *nft_flow_rule_create(struct net *net, const struct nft_rul
 
 	expr = nft_expr_first(rule);
 	while (expr->ops && expr != nft_expr_last(rule)) {
-		if (expr->ops->offload_flags & NFT_OFFLOAD_F_ACTION)
-			num_actions++;
+		if (expr->ops->offload_actions)
+			num_actions += expr->ops->offload_actions(expr);
 
 		expr = nft_expr_next(expr);
 	}
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index ca2ae4b..391f699 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -163,7 +163,7 @@ static int nft_immediate_offload(struct nft_offload_ctx *ctx,
 	.dump		= nft_immediate_dump,
 	.validate	= nft_immediate_validate,
 	.offload	= nft_immediate_offload,
-	.offload_flags	= NFT_OFFLOAD_F_ACTION,
+	.offload_actions = nft_offload_action,
 };
 
 struct nft_expr_type nft_imm_type __read_mostly = {
-- 
1.8.3.1

