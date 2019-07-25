Return-Path: <SRS0=uZng=VW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE4DEC41517
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 04:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A538722AED
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 04:09:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbfGYEJ5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 00:09:57 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:3945 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbfGYEJ4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 00:09:56 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 9117941AB2;
        Thu, 25 Jul 2019 12:09:49 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 4/5] netfilter: nft_objref: add nft_objref_type offload
Date:   Thu, 25 Jul 2019 12:09:40 +0800
Message-Id: <1564027781-24882-5-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564027781-24882-1-git-send-email-wenxu@ucloud.cn>
References: <1564027781-24882-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUlDS0tLS09PQ0lJTUJZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6ME06EDo6KDg1NlYeTiJJPBRK
        SxMKCiFVSlVKTk1PS0lMTENCTUhMVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlDTkg3Bg++
X-HM-Tid: 0a6c275221262086kuqy9117941ab2
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

support offload for nft_objref_type

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/net/netfilter/nf_tables.h |  3 +++
 net/netfilter/nft_objref.c        | 15 +++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 9285df2..d6f96c0 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1122,6 +1122,9 @@ struct nft_object_ops {
 	int				(*dump)(struct sk_buff *skb,
 						struct nft_object *obj,
 						bool reset);
+	int				(*offload)(struct nft_offload_ctx *ctx,
+						   struct nft_flow_rule *flow,
+						   struct nft_object *obj);
 	const struct nft_object_type	*type;
 };
 
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index bfd18d2..f71cf76 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -10,6 +10,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_offload.h>
 
 #define nft_objref_priv(expr)	*((struct nft_object **)nft_expr_priv(expr))
 
@@ -82,6 +83,18 @@ static void nft_objref_activate(const struct nft_ctx *ctx,
 	obj->use++;
 }
 
+static int nft_objref_offload(struct nft_offload_ctx *ctx,
+			      struct nft_flow_rule *flow,
+			      const struct nft_expr *expr)
+{
+	struct nft_object *obj = nft_objref_priv(expr);
+
+	if (obj->ops->offload)
+		return obj->ops->offload(ctx, flow, obj);
+	else
+		return -EOPNOTSUPP;
+}
+
 static struct nft_expr_type nft_objref_type;
 static const struct nft_expr_ops nft_objref_ops = {
 	.type		= &nft_objref_type,
@@ -91,6 +104,8 @@ static void nft_objref_activate(const struct nft_ctx *ctx,
 	.activate	= nft_objref_activate,
 	.deactivate	= nft_objref_deactivate,
 	.dump		= nft_objref_dump,
+	.offload	= nft_objref_offload,
+	.offload_actions = nft_offload_action,
 };
 
 struct nft_objref_map {
-- 
1.8.3.1

