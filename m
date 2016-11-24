From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: trigger layer 4 checksum when pseudoheader fields are modified
Date: Thu, 24 Nov 2016 12:12:33 +0100
Message-ID: <1479985953-6607-1-git-send-email-pablo@netfilter.org>
Cc: nevola@gmail.com, dalegaard@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48174 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964851AbcKXLMn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2016 06:12:43 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8037E16B283
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 12:12:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6FF1EA7D50
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 12:12:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E731CA7D5A
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 12:12:37 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch sets the NFT_PAYLOAD_L4CSUM_PSEUDOHDR when any of the
pseudoheader fields are modified. This implicitly enables stateless NAT,
that can be useful under some circuntances.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_tables.h |  6 ++++++
 include/proto.h                     |  2 ++
 src/netlink_linearize.c             | 17 +++++++++++++++++
 src/proto.c                         |  6 ++++++
 4 files changed, 31 insertions(+)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 14e5f619167e..f030e59aa2ec 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -659,6 +659,10 @@ enum nft_payload_csum_types {
 	NFT_PAYLOAD_CSUM_INET,
 };
 
+enum nft_payload_csum_flags {
+	NFT_PAYLOAD_L4CSUM_PSEUDOHDR = (1 << 0),
+};
+
 /**
  * enum nft_payload_attributes - nf_tables payload expression netlink attributes
  *
@@ -669,6 +673,7 @@ enum nft_payload_csum_types {
  * @NFTA_PAYLOAD_SREG: source register to load data from (NLA_U32: nft_registers)
  * @NFTA_PAYLOAD_CSUM_TYPE: checksum type (NLA_U32)
  * @NFTA_PAYLOAD_CSUM_OFFSET: checksum offset relative to base (NLA_U32)
+ * @NFTA_PAYLOAD_CSUM_FLAGS: checksum flags (NLA_U32)
  */
 enum nft_payload_attributes {
 	NFTA_PAYLOAD_UNSPEC,
@@ -679,6 +684,7 @@ enum nft_payload_attributes {
 	NFTA_PAYLOAD_SREG,
 	NFTA_PAYLOAD_CSUM_TYPE,
 	NFTA_PAYLOAD_CSUM_OFFSET,
+	NFTA_PAYLOAD_CSUM_FLAGS,
 	__NFTA_PAYLOAD_MAX
 };
 #define NFTA_PAYLOAD_MAX	(__NFTA_PAYLOAD_MAX - 1)
diff --git a/include/proto.h b/include/proto.h
index 4fa54a74b00c..01188ab6eee4 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -73,6 +73,7 @@ struct proto_hdr_template {
  * @length:	total size of the header, in bits
  * @protocols:	link to upper layer protocol descriptions indexed by protocol value
  * @templates:	header templates
+ * @pseudohdr:  header fields that are part of upper layer checksum pseudoheader
  */
 struct proto_desc {
 	const char			*name;
@@ -89,6 +90,7 @@ struct proto_desc {
 		uint8_t				order[PROTO_HDRS_MAX];
 		uint32_t			filter;
 	}				format;
+	unsigned int			pseudohdr[PROTO_HDRS_MAX];
 
 };
 
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 0072dca091ea..281f600e05ae 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -725,6 +725,18 @@ static void netlink_gen_verdict_stmt(struct netlink_linearize_ctx *ctx,
 	return netlink_gen_expr(ctx, stmt->expr, NFT_REG_VERDICT);
 }
 
+static bool payload_needs_l4csum_update_pseudohdr(const struct expr *expr,
+						  const struct proto_desc *desc)
+{
+	int i;
+
+	for (i = 0; i < PROTO_HDRS_MAX; i++) {
+		if (payload_hdr_field(expr) == desc->pseudohdr[i])
+			return true;
+	}
+	return false;
+}
+
 static void netlink_gen_payload_stmt(struct netlink_linearize_ctx *ctx,
 				     const struct stmt *stmt)
 {
@@ -758,6 +770,11 @@ static void netlink_gen_payload_stmt(struct netlink_linearize_ctx *ctx,
 				   NFT_PAYLOAD_CSUM_INET);
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_PAYLOAD_CSUM_OFFSET,
 				   csum_off / BITS_PER_BYTE);
+
+		if (expr->payload.base == PROTO_BASE_NETWORK_HDR &&
+		    payload_needs_l4csum_update_pseudohdr(expr, desc))
+			nftnl_expr_set_u32(nle, NFTNL_EXPR_PAYLOAD_FLAGS,
+					   NFT_PAYLOAD_L4CSUM_PSEUDOHDR);
 	}
 
 	nftnl_rule_add_expr(ctx->nlr, nle);
diff --git a/src/proto.c b/src/proto.c
index df5439ccda3c..8930bed65891 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -616,6 +616,9 @@ const struct proto_desc proto_ip = {
 		.filter	= (1 << IPHDR_VERSION)  | (1 << IPHDR_HDRLENGTH) |
 			  (1 << IPHDR_FRAG_OFF),
 	},
+	.pseudohdr	= {
+		IPHDR_SADDR, IPHDR_DADDR, IPHDR_PROTOCOL, IPHDR_LENGTH,
+	},
 };
 
 /*
@@ -721,6 +724,9 @@ const struct proto_desc proto_ip6 = {
 		},
 		.filter	= (1 << IP6HDR_VERSION),
 	},
+	.pseudohdr	= {
+		IP6HDR_SADDR, IP6HDR_DADDR, IP6HDR_NEXTHDR, IP6HDR_LENGTH,
+	},
 };
 
 /*
-- 
2.1.4

