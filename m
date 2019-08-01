Return-Path: <SRS0=uSEi=V5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84B55C433FF
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Aug 2019 14:01:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65133205F4
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Aug 2019 14:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731461AbfHAOBi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Aug 2019 10:01:38 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:22893 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730581AbfHAOBh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 10:01:37 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 2293741790;
        Thu,  1 Aug 2019 22:01:28 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v3 6/9] netfilter: nft_tunnel: support tunnel meta match offload
Date:   Thu,  1 Aug 2019 22:01:23 +0800
Message-Id: <1564668086-16260-7-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564668086-16260-1-git-send-email-wenxu@ucloud.cn>
References: <1564668086-16260-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSU5KS0tLS09NTEhLS09ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Ohw6Lio*Fzg*SU8wFylMI00O
        CyFPCR9VSlVKTk1PTU1DS0NDSkNOVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhOQ0s3Bg++
X-HM-Tid: 0a6c4d7c4f5a2086kuqy2293741790
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add tunnel meta match offload. Currently support for NFT_TUNNEL_ID
NFT_TUNNEL_SRC_IP and NFT_TUNNEL_DST_IP

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v3: set data on dest

 include/net/netfilter/nf_tables_offload.h |  2 ++
 net/netfilter/nft_tunnel.c                | 33 +++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index 275d014..df76981 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -44,6 +44,8 @@ struct nft_flow_key {
 	struct flow_dissector_key_ip			ip;
 	struct flow_dissector_key_vlan			vlan;
 	struct flow_dissector_key_eth_addrs		eth_addrs;
+	struct flow_dissector_key_keyid         enc_key_id;
+	struct flow_dissector_key_ipv4_addrs	enc_ipv4;
 } __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
 
 struct nft_flow_match {
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index e218163..f0190bc 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -11,6 +11,7 @@
 #include <net/ip_tunnels.h>
 #include <net/vxlan.h>
 #include <net/erspan.h>
+#include <net/netfilter/nf_tables_offload.h>
 
 struct nft_tunnel {
 	enum nft_tunnel_keys	key:8;
@@ -149,6 +150,37 @@ static int nft_tunnel_get_dump(struct sk_buff *skb,
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
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_ENC_KEYID, enc_key_id, keyid,
+				  sizeof(__u32), reg);
+		break;
+	case NFT_TUNNEL_SRC_IP:
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS, enc_ipv4, src,
+				  sizeof(__u32), reg);
+		break;
+	case NFT_TUNNEL_DST_IP:
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS, enc_ipv4, dst,
+				  sizeof(__u32), reg);
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
@@ -156,6 +188,7 @@ static int nft_tunnel_get_dump(struct sk_buff *skb,
 	.eval		= nft_tunnel_get_eval,
 	.init		= nft_tunnel_get_init,
 	.dump		= nft_tunnel_get_dump,
+	.offload	= nft_tunnel_get_offload,
 };
 
 static struct nft_expr_type nft_tunnel_type __read_mostly = {
-- 
1.8.3.1

