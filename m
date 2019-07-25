Return-Path: <SRS0=uZng=VW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2AB6C76190
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 04:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81B5E22ADA
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 04:09:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfGYEJ4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 00:09:56 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:4035 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbfGYEJ4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 00:09:56 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id A0C5541AB9;
        Thu, 25 Jul 2019 12:09:49 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 5/5] netfilter: nft_tunnel: support nft_tunnel_obj offload
Date:   Thu, 25 Jul 2019 12:09:41 +0800
Message-Id: <1564027781-24882-6-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564027781-24882-1-git-send-email-wenxu@ucloud.cn>
References: <1564027781-24882-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSENJS0tLS0NDTUJKTEpZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Kz46Ejo5Kzg2FFYKGRk6PBMB
        ShgaCkpVSlVKTk1PS0lMTENCTUJMVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlIS0s3Bg++
X-HM-Tid: 0a6c275221672086kuqya0c5541ab9
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
index 1a979e7..a61d0a7 100644
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

