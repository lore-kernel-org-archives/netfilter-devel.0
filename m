Return-Path: <SRS0=5AJI=YR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 253DECA9EAF
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 07:53:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0116B2084C
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 07:53:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404708AbfJXHxN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Oct 2019 03:53:13 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:12951 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404960AbfJXHxN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Oct 2019 03:53:13 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 11228419F9;
        Thu, 24 Oct 2019 15:52:46 +0800 (CST)
From:   wenxu@ucloud.cn
To:     fw@strlen.de, pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nft_payload: fix check the match len for offload to hw
Date:   Thu, 24 Oct 2019 15:52:45 +0800
Message-Id: <1571903565-1989-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVIT0lLS0tLS0xNSUJIQllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PBQ6PTo*ODg*Hx4*HCEDUTBJ
        NxMwCTZVSlVKTkxKQktITk1NSUhCVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU9NTUw3Bg++
X-HM-Tid: 0a6dfcc0f12c2086kuqy11228419f9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Offload paylaod rule just according to the base and offset. it should
check the len of the match.

For payoad vlan example
nft --debug=netlink add rule firewall zones vlan id 100
.....
[ payload load 2b @ link header + 0 => reg 1 ]

load 2byte base on ll header and offset 0.

Also can avoid unsupported raw payload match

Fixes: 92ad6325cb89 ("netfilter: nf_tables: add hardware offload support")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nft_payload.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 22a80eb..5cb2d89 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -161,13 +161,21 @@ static int nft_payload_offload_ll(struct nft_offload_ctx *ctx,
 
 	switch (priv->offset) {
 	case offsetof(struct ethhdr, h_source):
+		if (priv->len != ETH_ALEN)
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_ETH_ADDRS, eth_addrs,
 				  src, ETH_ALEN, reg);
 		break;
 	case offsetof(struct ethhdr, h_dest):
+		if (priv->len != ETH_ALEN)
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_ETH_ADDRS, eth_addrs,
 				  dst, ETH_ALEN, reg);
 		break;
+	default:
+		return -EOPNOTSUPP;
 	}
 
 	return 0;
@@ -181,14 +189,23 @@ static int nft_payload_offload_ip(struct nft_offload_ctx *ctx,
 
 	switch (priv->offset) {
 	case offsetof(struct iphdr, saddr):
+		if (priv->len != sizeof(struct in_addr))
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4, src,
 				  sizeof(struct in_addr), reg);
 		break;
 	case offsetof(struct iphdr, daddr):
+		if (priv->len != sizeof(struct in_addr))
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4, dst,
 				  sizeof(struct in_addr), reg);
 		break;
 	case offsetof(struct iphdr, protocol):
+		if (priv->len != sizeof(__u8))
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_BASIC, basic, ip_proto,
 				  sizeof(__u8), reg);
 		nft_offload_set_dependency(ctx, NFT_OFFLOAD_DEP_TRANSPORT);
@@ -208,14 +225,23 @@ static int nft_payload_offload_ip6(struct nft_offload_ctx *ctx,
 
 	switch (priv->offset) {
 	case offsetof(struct ipv6hdr, saddr):
+		if (priv->len != sizeof(struct in6_addr))
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV6_ADDRS, ipv6, src,
 				  sizeof(struct in6_addr), reg);
 		break;
 	case offsetof(struct ipv6hdr, daddr):
+		if (priv->len != sizeof(struct in6_addr))
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV6_ADDRS, ipv6, dst,
 				  sizeof(struct in6_addr), reg);
 		break;
 	case offsetof(struct ipv6hdr, nexthdr):
+		if (priv->len != sizeof(__u8))
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_BASIC, basic, ip_proto,
 				  sizeof(__u8), reg);
 		nft_offload_set_dependency(ctx, NFT_OFFLOAD_DEP_TRANSPORT);
@@ -255,10 +281,16 @@ static int nft_payload_offload_tcp(struct nft_offload_ctx *ctx,
 
 	switch (priv->offset) {
 	case offsetof(struct tcphdr, source):
+		if (priv->len != sizeof(__be16))
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_PORTS, tp, src,
 				  sizeof(__be16), reg);
 		break;
 	case offsetof(struct tcphdr, dest):
+		if (priv->len != sizeof(__be16))
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_PORTS, tp, dst,
 				  sizeof(__be16), reg);
 		break;
@@ -277,10 +309,16 @@ static int nft_payload_offload_udp(struct nft_offload_ctx *ctx,
 
 	switch (priv->offset) {
 	case offsetof(struct udphdr, source):
+		if (priv->len != sizeof(__be16))
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_PORTS, tp, src,
 				  sizeof(__be16), reg);
 		break;
 	case offsetof(struct udphdr, dest):
+		if (priv->len != sizeof(__be16))
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_PORTS, tp, dst,
 				  sizeof(__be16), reg);
 		break;
-- 
1.8.3.1

