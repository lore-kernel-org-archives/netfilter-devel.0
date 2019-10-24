Return-Path: <SRS0=5AJI=YR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72C8BCA9EAF
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 10:35:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5101C2084C
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 10:35:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438873AbfJXKfl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Oct 2019 06:35:41 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:45046 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407888AbfJXKfk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Oct 2019 06:35:40 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 8E17C41A4E;
        Thu, 24 Oct 2019 18:35:36 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 5/5] netfilter: nft_tunnel: add nft_tunnel_get_offload support
Date:   Thu, 24 Oct 2019 18:35:36 +0800
Message-Id: <1571913336-13431-6-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571913336-13431-1-git-send-email-wenxu@ucloud.cn>
References: <1571913336-13431-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSENIS0tLS0pNSUpJT01ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MRw6LTo4Djg2MR5DA01NPw9C
        C0tPCQpVSlVKTkxKQkpISEhNTUJKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhCSE03Bg++
X-HM-Tid: 0a6dfd5607152086kuqy8e17c41a4e
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add tunnel meta match offload. Currently support for NFT_TUNNEL_ID
NFT_TUNNEL_IPV4_SRC/DST and NFT_TUNNEL_IPV6_SRC/DST

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/net/netfilter/nf_tables_offload.h |  5 ++++
 net/netfilter/nft_tunnel.c                | 41 +++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index 03cf585..f99653b 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -45,6 +45,11 @@ struct nft_flow_key {
 	struct flow_dissector_key_ip			ip;
 	struct flow_dissector_key_vlan			vlan;
 	struct flow_dissector_key_eth_addrs		eth_addrs;
+	struct flow_dissector_key_keyid			enc_key_id;
+	union {
+		struct flow_dissector_key_ipv4_addrs	enc_ipv4;
+		struct flow_dissector_key_ipv6_addrs	enc_ipv6;
+	};
 } __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
 
 struct nft_flow_match {
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 0a3005d..abfff56 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -11,6 +11,7 @@
 #include <net/ip_tunnels.h>
 #include <net/vxlan.h>
 #include <net/erspan.h>
+#include <net/netfilter/nf_tables_offload.h>
 
 struct nft_tunnel {
 	enum nft_tunnel_keys	key:8;
@@ -192,6 +193,45 @@ static int nft_tunnel_get_dump(struct sk_buff *skb,
 	return -1;
 }
 
+static int nft_tunnel_get_offload(struct nft_offload_ctx *ctx,
+				  struct nft_flow_rule *flow,
+				  const struct nft_expr *expr)
+{
+	const struct nft_tunnel *priv = nft_expr_priv(expr);
+	struct nft_offload_reg *reg = &ctx->regs[priv->dreg];
+
+	if (priv->mode == NFT_TUNNEL_MODE_TX)
+		return -EOPNOTSUPP;
+
+	switch (priv->key) {
+	case NFT_TUNNEL_ID:
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_ENC_KEYID, enc_key_id,
+				  keyid, sizeof(__u32), reg);
+		break;
+	case NFT_TUNNEL_IPV4_SRC:
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS, enc_ipv4,
+				  src, sizeof(__u32), reg);
+		break;
+	case NFT_TUNNEL_IPV4_DST:
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS, enc_ipv4,
+				  dst, sizeof(__u32), reg);
+		break;
+	case NFT_TUNNEL_IPV6_SRC:
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS, enc_ipv6,
+				  src, sizeof(struct in6_addr), reg);
+		break;
+	case NFT_TUNNEL_IPV6_DST:
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS, enc_ipv6,
+				  dst, sizeof(struct in6_addr), reg);
+		break;
+	case NFT_TUNNEL_PATH:
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static struct nft_expr_type nft_tunnel_type;
 static const struct nft_expr_ops nft_tunnel_get_ops = {
 	.type		= &nft_tunnel_type,
@@ -199,6 +239,7 @@ static int nft_tunnel_get_dump(struct sk_buff *skb,
 	.eval		= nft_tunnel_get_eval,
 	.init		= nft_tunnel_get_init,
 	.dump		= nft_tunnel_get_dump,
+	.offload	= nft_tunnel_get_offload,
 };
 
 static struct nft_expr_type nft_tunnel_type __read_mostly = {
-- 
1.8.3.1

