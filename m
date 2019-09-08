Return-Path: <SRS0=xcdV=XD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68DD4C4332F
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Sep 2019 14:22:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 494DE2082C
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Sep 2019 14:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729024AbfIHOWW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 8 Sep 2019 10:22:22 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:4201 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729003AbfIHOWV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 8 Sep 2019 10:22:21 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 3F17F5C16DC;
        Sun,  8 Sep 2019 22:22:09 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v6 6/8] netfilter: nft_tunnel: add NFTA_TUNNEL_KEY_RELEASE action
Date:   Sun,  8 Sep 2019 22:22:06 +0800
Message-Id: <1567952528-24421-7-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567952528-24421-1-git-send-email-wenxu@ucloud.cn>
References: <1567952528-24421-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSktOQkJCQ0lMSENPQk5ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Pio6Cxw6EzgwAzUhORMMORo4
        Dj4wCStVSlVKTk1MQk5JTklCSEtJVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhCQ0k3Bg++
X-HM-Tid: 0a6d1140e7732087kuqy3f17f5c16dc
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add new NFTA_TUNNEL_KEY_RELEASE action for future offload
feature

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v6: no change

 include/uapi/linux/netfilter/nf_tables.h |  1 +
 net/netfilter/nft_tunnel.c               | 24 +++++++++++++++++++++---
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 49fcb27..7ed66fa 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1765,6 +1765,7 @@ enum nft_tunnel_key_attributes {
 	NFTA_TUNNEL_KEY_SPORT,
 	NFTA_TUNNEL_KEY_DPORT,
 	NFTA_TUNNEL_KEY_OPTS,
+	NFTA_TUNNEL_KEY_RELEASE,
 	__NFTA_TUNNEL_KEY_MAX
 };
 #define NFTA_TUNNEL_KEY_MAX	(__NFTA_TUNNEL_KEY_MAX - 1)
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 018ec27..aa3dc52 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -247,6 +247,7 @@ struct nft_tunnel_opts {
 struct nft_tunnel_obj {
 	struct metadata_dst	*md;
 	struct nft_tunnel_opts	opts;
+	bool tunnel_key_release;
 };
 
 static const struct nla_policy nft_tunnel_ip_policy[NFTA_TUNNEL_KEY_IP_MAX + 1] = {
@@ -431,6 +432,7 @@ static int nft_tunnel_obj_opts_init(const struct nft_ctx *ctx,
 	[NFTA_TUNNEL_KEY_TOS]	= { .type = NLA_U8, },
 	[NFTA_TUNNEL_KEY_TTL]	= { .type = NLA_U8, },
 	[NFTA_TUNNEL_KEY_OPTS]	= { .type = NLA_NESTED, },
+	[NFTA_TUNNEL_KEY_RELEASE]	= { .type = NLA_U8, },
 };
 
 static int nft_tunnel_obj_init(const struct nft_ctx *ctx,
@@ -442,6 +444,12 @@ static int nft_tunnel_obj_init(const struct nft_ctx *ctx,
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
 
@@ -524,8 +532,11 @@ static inline void nft_tunnel_obj_eval(struct nft_object *obj,
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
@@ -627,6 +638,12 @@ static int nft_tunnel_obj_dump(struct sk_buff *skb,
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
@@ -648,7 +665,8 @@ static void nft_tunnel_obj_destroy(const struct nft_ctx *ctx,
 {
 	struct nft_tunnel_obj *priv = nft_obj_data(obj);
 
-	metadata_dst_free(priv->md);
+	if (!priv->tunnel_key_release)
+		metadata_dst_free(priv->md);
 }
 
 static struct nft_object_type nft_tunnel_obj_type;
-- 
1.8.3.1

