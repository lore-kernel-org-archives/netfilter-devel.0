Return-Path: <SRS0=uZng=VW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CDAAC7618B
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 09:46:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D25902190F
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 09:46:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390809AbfGYJqU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 05:46:20 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:37351 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729719AbfGYJqT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 05:46:19 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id B17D14117E;
        Thu, 25 Jul 2019 17:46:11 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v2 3/5] netfilter: nft_tunnel: add NFTA_TUNNEL_KEY_RELEASE action
Date:   Thu, 25 Jul 2019 17:46:07 +0800
Message-Id: <1564047969-26514-4-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564047969-26514-1-git-send-email-wenxu@ucloud.cn>
References: <1564047969-26514-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSklNQkJCTEhOQ0hJSUpZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OTI6LSo4Njg4IlYfDkhJLhRD
        FkwaCypVSlVKTk1PS09MQkxKQ05JVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhCQk43Bg++
X-HM-Tid: 0a6c288615a62086kuqyb17d14117e
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add new NFTA_TUNNEL_KEY_RELEASE action for future offload
feature

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/uapi/linux/netfilter/nf_tables.h |  1 +
 net/netfilter/nft_tunnel.c               | 24 +++++++++++++++++++++---
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 173690a..4489b66 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1758,6 +1758,7 @@ enum nft_tunnel_key_attributes {
 	NFTA_TUNNEL_KEY_SPORT,
 	NFTA_TUNNEL_KEY_DPORT,
 	NFTA_TUNNEL_KEY_OPTS,
+	NFTA_TUNNEL_KEY_RELEASE,
 	__NFTA_TUNNEL_KEY_MAX
 };
 #define NFTA_TUNNEL_KEY_MAX	(__NFTA_TUNNEL_KEY_MAX - 1)
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 900c94f..0e0a34d 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -211,6 +211,7 @@ struct nft_tunnel_opts {
 struct nft_tunnel_obj {
 	struct metadata_dst	*md;
 	struct nft_tunnel_opts	opts;
+	bool tunnel_key_release;
 };
 
 static const struct nla_policy nft_tunnel_ip_policy[NFTA_TUNNEL_KEY_IP_MAX + 1] = {
@@ -395,6 +396,7 @@ static int nft_tunnel_obj_opts_init(const struct nft_ctx *ctx,
 	[NFTA_TUNNEL_KEY_TOS]	= { .type = NLA_U8, },
 	[NFTA_TUNNEL_KEY_TTL]	= { .type = NLA_U8, },
 	[NFTA_TUNNEL_KEY_OPTS]	= { .type = NLA_NESTED, },
+	[NFTA_TUNNEL_KEY_RELEASE]	= { .type = NLA_U8, },
 };
 
 static int nft_tunnel_obj_init(const struct nft_ctx *ctx,
@@ -406,6 +408,12 @@ static int nft_tunnel_obj_init(const struct nft_ctx *ctx,
 	struct metadata_dst *md;
 	int err;
 
+	if (tb[NFTA_TUNNEL_KEY_RELEASE]) {
+		priv->tunnel_key_release = !!nla_get_u8(tb[NFTA_TUNNEL_KEY_RELEASE]);
+		if (priv->tunnel_key_release)
+			return 0;
+	}
+
 	if (!tb[NFTA_TUNNEL_KEY_ID])
 		return -EINVAL;
 
@@ -488,8 +496,11 @@ static inline void nft_tunnel_obj_eval(struct nft_object *obj,
 	struct sk_buff *skb = pkt->skb;
 
 	skb_dst_drop(skb);
-	dst_hold((struct dst_entry *) priv->md);
-	skb_dst_set(skb, (struct dst_entry *) priv->md);
+
+	if (!priv->tunnel_key_release) {
+		dst_hold((struct dst_entry *)priv->md);
+		skb_dst_set(skb, (struct dst_entry *)priv->md);
+	}
 }
 
 static int nft_tunnel_ip_dump(struct sk_buff *skb, struct ip_tunnel_info *info)
@@ -591,6 +602,12 @@ static int nft_tunnel_obj_dump(struct sk_buff *skb,
 	struct nft_tunnel_obj *priv = nft_obj_data(obj);
 	struct ip_tunnel_info *info = &priv->md->u.tun_info;
 
+	if (priv->tunnel_key_release) {
+		if (nla_put_u8(skb, NFTA_TUNNEL_KEY_RELEASE, 1))
+			goto nla_put_failure;
+		return 0;
+	}
+
 	if (nla_put_be32(skb, NFTA_TUNNEL_KEY_ID,
 			 tunnel_id_to_key32(info->key.tun_id)) ||
 	    nft_tunnel_ip_dump(skb, info) < 0 ||
@@ -612,7 +629,8 @@ static void nft_tunnel_obj_destroy(const struct nft_ctx *ctx,
 {
 	struct nft_tunnel_obj *priv = nft_obj_data(obj);
 
-	metadata_dst_free(priv->md);
+	if (!priv->tunnel_key_release)
+		metadata_dst_free(priv->md);
 }
 
 static struct nft_object_type nft_tunnel_obj_type;
-- 
1.8.3.1

