Return-Path: <SRS0=uZng=VW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 756CAC7618B
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 13:34:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B0D622BF5
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 13:34:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfGYNeT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 09:34:19 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:52406 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388197AbfGYNeS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 09:34:18 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 4CFDE41D76;
        Thu, 25 Jul 2019 21:34:06 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v2 03/11] netfilter: nf_tables_offload: split nft_offload_reg to match and action type
Date:   Thu, 25 Jul 2019 21:33:58 +0800
Message-Id: <1564061644-31189-4-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564061644-31189-1-git-send-email-wenxu@ucloud.cn>
References: <1564061644-31189-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVS0lJS0tLSEpJQ0tOSkNZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MU06Aio4DTgxMksPKhwZNAEP
        LVEaCzJVSlVKTk1PS01KTU9NT0pNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUNLSUw3Bg++
X-HM-Tid: 0a6c2956bdf62086kuqy4cfde41d76
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Currently the nft_offload_reg is only can be used for match condition.
Can not be used for action. Add nft_offload_reg_type to make nft_offload_reg
can be used for action also.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/net/netfilter/nf_tables_offload.h | 20 +++++++++++++++++-
 net/netfilter/nft_cmp.c                   | 10 ++++-----
 net/netfilter/nft_meta.c                  |  6 ++++--
 net/netfilter/nft_payload.c               | 34 ++++++++++++++++++++-----------
 4 files changed, 50 insertions(+), 20 deletions(-)

diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index 275d014..82e3936 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -4,7 +4,13 @@
 #include <net/flow_offload.h>
 #include <net/netfilter/nf_tables.h>
 
-struct nft_offload_reg {
+enum nft_offload_reg_type {
+	NFT_OFFLOAD_REG_UNSPEC	= 0,
+	NFT_OFFLOAD_REG_MATCH,
+	NFT_OFFLOAD_REG_ACTION,
+};
+
+struct nft_offload_match {
 	u32		key;
 	u32		len;
 	u32		base_offset;
@@ -12,6 +18,18 @@ struct nft_offload_reg {
 	struct nft_data	mask;
 };
 
+struct nft_offload_action {
+	struct nft_data	data;
+};
+
+struct nft_offload_reg {
+	enum nft_offload_reg_type type;
+	union {
+		struct nft_offload_match match;
+		struct nft_offload_action action;
+	};
+};
+
 enum nft_offload_dep_type {
 	NFT_OFFLOAD_DEP_UNSPEC	= 0,
 	NFT_OFFLOAD_DEP_NETWORK,
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index bd173b1..ee38cba 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -116,14 +116,14 @@ static int __nft_cmp_offload(struct nft_offload_ctx *ctx,
 	u8 *mask = (u8 *)&flow->match.mask;
 	u8 *key = (u8 *)&flow->match.key;
 
-	if (priv->op != NFT_CMP_EQ)
+	if (priv->op != NFT_CMP_EQ || reg->type != NFT_OFFLOAD_REG_MATCH)
 		return -EOPNOTSUPP;
 
-	memcpy(key + reg->offset, &priv->data, priv->len);
-	memcpy(mask + reg->offset, &reg->mask, priv->len);
+	memcpy(key + reg->match.offset, &priv->data, priv->len);
+	memcpy(mask + reg->match.offset, &reg->match.mask, priv->len);
 
-	flow->match.dissector.used_keys |= BIT(reg->key);
-	flow->match.dissector.offset[reg->key] = reg->base_offset;
+	flow->match.dissector.used_keys |= BIT(reg->match.key);
+	flow->match.dissector.offset[reg->match.key] = reg->match.base_offset;
 
 	nft_offload_update_dependency(ctx, &priv->data, priv->len);
 
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index f1b1d94..6bb5ba6 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -498,15 +498,17 @@ static int nft_meta_get_offload(struct nft_offload_ctx *ctx,
 	const struct nft_meta *priv = nft_expr_priv(expr);
 	struct nft_offload_reg *reg = &ctx->regs[priv->dreg];
 
+	reg->type = NFT_OFFLOAD_REG_MATCH;
+
 	switch (priv->key) {
 	case NFT_META_PROTOCOL:
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_BASIC, basic, n_proto,
-				  sizeof(__u16), reg);
+				  sizeof(__u16), &reg->match);
 		nft_offload_set_dependency(ctx, NFT_OFFLOAD_DEP_NETWORK);
 		break;
 	case NFT_META_L4PROTO:
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_BASIC, basic, ip_proto,
-				  sizeof(__u8), reg);
+				  sizeof(__u8), &reg->match);
 		nft_offload_set_dependency(ctx, NFT_OFFLOAD_DEP_TRANSPORT);
 		break;
 	default:
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 22a80eb..36efa1c 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -159,14 +159,16 @@ static int nft_payload_offload_ll(struct nft_offload_ctx *ctx,
 {
 	struct nft_offload_reg *reg = &ctx->regs[priv->dreg];
 
+	reg->type = NFT_OFFLOAD_REG_MATCH;
+
 	switch (priv->offset) {
 	case offsetof(struct ethhdr, h_source):
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_ETH_ADDRS, eth_addrs,
-				  src, ETH_ALEN, reg);
+				  src, ETH_ALEN, &reg->match);
 		break;
 	case offsetof(struct ethhdr, h_dest):
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_ETH_ADDRS, eth_addrs,
-				  dst, ETH_ALEN, reg);
+				  dst, ETH_ALEN, &reg->match);
 		break;
 	}
 
@@ -179,18 +181,20 @@ static int nft_payload_offload_ip(struct nft_offload_ctx *ctx,
 {
 	struct nft_offload_reg *reg = &ctx->regs[priv->dreg];
 
+	reg->type = NFT_OFFLOAD_REG_MATCH;
+
 	switch (priv->offset) {
 	case offsetof(struct iphdr, saddr):
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4, src,
-				  sizeof(struct in_addr), reg);
+				  sizeof(struct in_addr), &reg->match);
 		break;
 	case offsetof(struct iphdr, daddr):
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4, dst,
-				  sizeof(struct in_addr), reg);
+				  sizeof(struct in_addr), &reg->match);
 		break;
 	case offsetof(struct iphdr, protocol):
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_BASIC, basic, ip_proto,
-				  sizeof(__u8), reg);
+				  sizeof(__u8), &reg->match);
 		nft_offload_set_dependency(ctx, NFT_OFFLOAD_DEP_TRANSPORT);
 		break;
 	default:
@@ -206,18 +210,20 @@ static int nft_payload_offload_ip6(struct nft_offload_ctx *ctx,
 {
 	struct nft_offload_reg *reg = &ctx->regs[priv->dreg];
 
+	reg->type = NFT_OFFLOAD_REG_MATCH;
+
 	switch (priv->offset) {
 	case offsetof(struct ipv6hdr, saddr):
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV6_ADDRS, ipv6, src,
-				  sizeof(struct in6_addr), reg);
+				  sizeof(struct in6_addr), &reg->match);
 		break;
 	case offsetof(struct ipv6hdr, daddr):
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV6_ADDRS, ipv6, dst,
-				  sizeof(struct in6_addr), reg);
+				  sizeof(struct in6_addr), &reg->match);
 		break;
 	case offsetof(struct ipv6hdr, nexthdr):
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_BASIC, basic, ip_proto,
-				  sizeof(__u8), reg);
+				  sizeof(__u8), &reg->match);
 		nft_offload_set_dependency(ctx, NFT_OFFLOAD_DEP_TRANSPORT);
 		break;
 	default:
@@ -253,14 +259,16 @@ static int nft_payload_offload_tcp(struct nft_offload_ctx *ctx,
 {
 	struct nft_offload_reg *reg = &ctx->regs[priv->dreg];
 
+	reg->type = NFT_OFFLOAD_REG_MATCH;
+
 	switch (priv->offset) {
 	case offsetof(struct tcphdr, source):
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_PORTS, tp, src,
-				  sizeof(__be16), reg);
+				  sizeof(__be16), &reg->match);
 		break;
 	case offsetof(struct tcphdr, dest):
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_PORTS, tp, dst,
-				  sizeof(__be16), reg);
+				  sizeof(__be16), &reg->match);
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -275,14 +283,16 @@ static int nft_payload_offload_udp(struct nft_offload_ctx *ctx,
 {
 	struct nft_offload_reg *reg = &ctx->regs[priv->dreg];
 
+	reg->type = NFT_OFFLOAD_REG_MATCH;
+
 	switch (priv->offset) {
 	case offsetof(struct udphdr, source):
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_PORTS, tp, src,
-				  sizeof(__be16), reg);
+				  sizeof(__be16), &reg->match);
 		break;
 	case offsetof(struct udphdr, dest):
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_PORTS, tp, dst,
-				  sizeof(__be16), reg);
+				  sizeof(__be16), &reg->match);
 		break;
 	default:
 		return -EOPNOTSUPP;
-- 
1.8.3.1

