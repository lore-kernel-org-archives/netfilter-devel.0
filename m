Return-Path: <SRS0=xcdV=XD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D53FC4332F
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Sep 2019 14:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 354B82082C
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Sep 2019 14:22:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbfIHOW1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 8 Sep 2019 10:22:27 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:4205 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727866AbfIHOW0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 8 Sep 2019 10:22:26 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 5D3B65C16E1;
        Sun,  8 Sep 2019 22:22:09 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v6 8/8] netfilter: nft_tunnel: support nft_tunnel_obj offload
Date:   Sun,  8 Sep 2019 22:22:08 +0800
Message-Id: <1567952528-24421-9-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567952528-24421-1-git-send-email-wenxu@ucloud.cn>
References: <1567952528-24421-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSktOQkJCQ0lMSENPQk5ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Kyo6FCo5STg1SDVLORMPOSka
        DEJPCSlVSlVKTk1MQk5JTklCT0pNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlJQkg3Bg++
X-HM-Tid: 0a6d1140e7ee2087kuqy5d3b65c16e1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add nft_tunnel_obj offload for both encap and decap actions

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v6: no change

 net/netfilter/nft_tunnel.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index aa3dc52..b47838d 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -669,6 +669,25 @@ static void nft_tunnel_obj_destroy(const struct nft_ctx *ctx,
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
@@ -677,6 +696,7 @@ static void nft_tunnel_obj_destroy(const struct nft_ctx *ctx,
 	.init		= nft_tunnel_obj_init,
 	.destroy	= nft_tunnel_obj_destroy,
 	.dump		= nft_tunnel_obj_dump,
+	.offload	= nft_tunnel_obj_offload,
 };
 
 static struct nft_object_type nft_tunnel_obj_type __read_mostly = {
-- 
1.8.3.1

