Return-Path: <SRS0=UCZI=XI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D141C4CEC5
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 15:03:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE19C20830
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 15:03:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390557AbfIMPDc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Sep 2019 11:03:32 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:47521 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390433AbfIMPDc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Sep 2019 11:03:32 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id DB30A41634;
        Fri, 13 Sep 2019 23:03:11 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v6 5/8] netfilter: nft_tunnel: support tunnel meta match offload
Date:   Fri, 13 Sep 2019 23:03:07 +0800
Message-Id: <1568386990-29660-6-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568386990-29660-1-git-send-email-wenxu@ucloud.cn>
References: <1568386990-29660-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVS05DQkJCQ0JNS09CTllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MjY6GRw6Azg6TCswPzEcDxgD
        DSpPCw9VSlVKTk1DSENNQkJKQkhCVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhDQkM3Bg++
X-HM-Tid: 0a6d2b2647222086kuqydb30a41634
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add tunnel meta match offload. Currently support for NFT_TUNNEL_ID
NFT_TUNNEL_SRC_IP and NFT_TUNNEL_DST_IP

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/net/netfilter/nf_tables_offload.h |  5 ++++
 net/netfilter/nft_tunnel.c                | 41 +++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index ddd048b..a07e18b 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -45,6 +45,11 @@ struct nft_flow_key {
 	struct flow_dissector_key_ip			ip;
 	struct flow_dissector_key_vlan			vlan;
 	struct flow_dissector_key_eth_addrs		eth_addrs;
+	struct flow_dissector_key_keyid         enc_key_id;
+	union {
+		struct flow_dissector_key_ipv4_addrs	enc_ipv4;
+		struct flow_dissector_key_ipv6_addrs	enc_ipv6;
+	};
 } __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
 
 struct nft_flow_match {
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index f128b28..68ca894 100644
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
+	case NFT_TUNNEL_IP_SRC:
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS, enc_ipv4,
+				  src, sizeof(__u32), reg);
+		break;
+	case NFT_TUNNEL_IP_DST:
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS, enc_ipv4,
+				  dst, sizeof(__u32), reg);
+		break;
+	case NFT_TUNNEL_IP6_SRC:
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS, enc_ipv6,
+				  src, sizeof(struct in6_addr), reg);
+		break;
+	case NFT_TUNNEL_IP6_DST:
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

