Return-Path: <SRS0=xcdV=XD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95204C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Sep 2019 14:23:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 744312082C
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Sep 2019 14:23:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729024AbfIHOXk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 8 Sep 2019 10:23:40 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:4393 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728893AbfIHOXk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 8 Sep 2019 10:23:40 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 4EFF05C16DD;
        Sun,  8 Sep 2019 22:22:09 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v6 7/8] netfilter: nft_objref: add nft_objref_type offload
Date:   Sun,  8 Sep 2019 22:22:07 +0800
Message-Id: <1567952528-24421-8-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567952528-24421-1-git-send-email-wenxu@ucloud.cn>
References: <1567952528-24421-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSktOQkJCQ0lMSENPQk5ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MQg6CAw5OTg8SDVNAxFIOS1P
        DRwKCj5VSlVKTk1MQk5JTklCSE1LVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhKSk83Bg++
X-HM-Tid: 0a6d1140e7b42087kuqy4eff05c16dd
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

support offload for nft_objref_type

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v6: rebase to the master

 include/net/netfilter/nf_tables.h |  4 ++++
 net/netfilter/nft_objref.c        | 14 ++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 3d9e66a..498f662 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1128,6 +1128,7 @@ struct nft_object_type {
  *	@destroy: release existing stateful object
  *	@dump: netlink dump stateful object
  *	@update: update stateful object
+ *	@update: offload stateful object
  */
 struct nft_object_ops {
 	void				(*eval)(struct nft_object *obj,
@@ -1144,6 +1145,9 @@ struct nft_object_ops {
 						bool reset);
 	void				(*update)(struct nft_object *obj,
 						  struct nft_object *newobj);
+	int				(*offload)(struct nft_offload_ctx *ctx,
+						   struct nft_flow_rule *flow,
+						   struct nft_object *obj);
 	const struct nft_object_type	*type;
 };
 
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index bfd18d2..4a70972 100644
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
@@ -91,6 +104,7 @@ static void nft_objref_activate(const struct nft_ctx *ctx,
 	.activate	= nft_objref_activate,
 	.deactivate	= nft_objref_deactivate,
 	.dump		= nft_objref_dump,
+	.offload	= nft_objref_offload,
 };
 
 struct nft_objref_map {
-- 
1.8.3.1

