Return-Path: <SRS0=uZng=VW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E212C41514
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 09:46:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6402A2190F
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 09:46:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390806AbfGYJqR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 05:46:17 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:37203 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729716AbfGYJqR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 05:46:17 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id EF7F641D25;
        Thu, 25 Jul 2019 17:46:11 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v2 5/5] netfilter: nft_tunnel: support nft_tunnel_obj offload
Date:   Thu, 25 Jul 2019 17:46:09 +0800
Message-Id: <1564047969-26514-6-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564047969-26514-1-git-send-email-wenxu@ucloud.cn>
References: <1564047969-26514-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUNKS0tLS0pDSkpCQ0pZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PVE6TAw*PTg2FFYUDklJLhce
        C1YaC0lVSlVKTk1PS09MQkxJS0hNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlIS003Bg++
X-HM-Tid: 0a6c2886169e2086kuqyef7f641d25
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add nft_tunnel_obj offload for both encap and decap actions

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nft_tunnel.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 0e0a34d..b5b7437 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -633,6 +633,25 @@ static void nft_tunnel_obj_destroy(const struct nft_ctx *ctx,
 		metadata_dst_free(priv->md);
 }
 
+static int nft_tunnel_obj_offload(struct nft_offload_ctx *ctx,
+				  struct nft_flow_rule *flow,
+				  struct nft_object *obj)
+{
+	struct nft_tunnel_obj *priv = nft_obj_data(obj);
+	struct flow_action_entry *entry;
+
+	entry = &flow->rule->action.entries[ctx->num_actions++];
+
+	if (!priv->tunnel_key_release) {
+		entry->id = FLOW_ACTION_TUNNEL_ENCAP;
+		entry->tunnel = &priv->md->u.tun_info;
+	} else {
+		entry->id = FLOW_ACTION_TUNNEL_DECAP;
+	}
+
+	return 0;
+}
+
 static struct nft_object_type nft_tunnel_obj_type;
 static const struct nft_object_ops nft_tunnel_obj_ops = {
 	.type		= &nft_tunnel_obj_type,
@@ -641,6 +660,7 @@ static void nft_tunnel_obj_destroy(const struct nft_ctx *ctx,
 	.init		= nft_tunnel_obj_init,
 	.destroy	= nft_tunnel_obj_destroy,
 	.dump		= nft_tunnel_obj_dump,
+	.offload	= nft_tunnel_obj_offload,
 };
 
 static struct nft_object_type nft_tunnel_obj_type __read_mostly = {
-- 
1.8.3.1

