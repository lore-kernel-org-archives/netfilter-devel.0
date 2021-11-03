Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0C03C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Nov 2021 19:46:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A85D061053
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Nov 2021 19:46:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhKCTtT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Nov 2021 15:49:19 -0400
Received: from mail.netfilter.org ([217.70.188.207]:35742 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbhKCTtT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Nov 2021 15:49:19 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 72C546079F
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Nov 2021 20:44:46 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: raw payload match and mangle on inner header / payload data
Date:   Wed,  3 Nov 2021 20:46:37 +0100
Message-Id: <20211103194637.114623-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds support to match on inner header / payload data:

 # nft add rule x y @ih,32,32 0x14000000 counter

you can also mangle payload data:

 # nft add rule x y @ih,32,32 set 0x14000000 counter

This update triggers a checksum update at the layer 4 header via
csum_flags, mangling odd bytes is also aligned to 16-bits.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/proto.h         | 1 +
 src/evaluate.c          | 3 +++
 src/netlink_linearize.c | 5 +++--
 src/parser_bison.y      | 2 ++
 src/proto.c             | 1 +
 src/scanner.l           | 1 +
 6 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/proto.h b/include/proto.h
index 580e409028bc..a04240a5de81 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -18,6 +18,7 @@ enum proto_bases {
 	PROTO_BASE_LL_HDR,
 	PROTO_BASE_NETWORK_HDR,
 	PROTO_BASE_TRANSPORT_HDR,
+	PROTO_BASE_INNER_HDR,
 	__PROTO_BASE_MAX
 };
 #define PROTO_BASE_MAX		(__PROTO_BASE_MAX - 1)
diff --git a/src/evaluate.c b/src/evaluate.c
index 6a8c396f33c4..a268b3cb9ee2 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2446,6 +2446,9 @@ static bool stmt_evaluate_payload_need_csum(const struct expr *payload)
 {
 	const struct proto_desc *desc;
 
+	if (payload->payload.base == PROTO_BASE_INNER_HDR)
+		return true;
+
 	desc = payload->payload.desc;
 
 	return desc && desc->checksum_key;
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 454b9ba3fbc7..111102fd4334 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1028,8 +1028,9 @@ static void netlink_gen_payload_stmt(struct netlink_linearize_ctx *ctx,
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_PAYLOAD_CSUM_OFFSET,
 				   csum_off / BITS_PER_BYTE);
 	}
-	if (expr->payload.base == PROTO_BASE_NETWORK_HDR && desc &&
-	    payload_needs_l4csum_update_pseudohdr(expr, desc))
+	if ((expr->payload.base == PROTO_BASE_NETWORK_HDR && desc &&
+	     payload_needs_l4csum_update_pseudohdr(expr, desc)) ||
+	    expr->payload.base == PROTO_BASE_INNER_HDR)
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_PAYLOAD_FLAGS,
 				   NFT_PAYLOAD_L4CSUM_PSEUDOHDR);
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 65fd35a36cde..eb89a58989e2 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -318,6 +318,7 @@ int nft_lex(void *, void *, void *);
 %token LL_HDR			"ll"
 %token NETWORK_HDR		"nh"
 %token TRANSPORT_HDR		"th"
+%token INNER_HDR		"ih"
 
 %token BRIDGE			"bridge"
 
@@ -5260,6 +5261,7 @@ payload_raw_expr	:	AT	payload_base_spec	COMMA	NUM	COMMA	NUM
 payload_base_spec	:	LL_HDR		{ $$ = PROTO_BASE_LL_HDR; }
 			|	NETWORK_HDR	{ $$ = PROTO_BASE_NETWORK_HDR; }
 			|	TRANSPORT_HDR	{ $$ = PROTO_BASE_TRANSPORT_HDR; }
+			|	INNER_HDR	{ $$ = PROTO_BASE_INNER_HDR; }
 			;
 
 eth_hdr_expr		:	ETHER	eth_hdr_field	close_scope_eth
diff --git a/src/proto.c b/src/proto.c
index 2b61e0ba47fd..2a8ca63f3c46 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -35,6 +35,7 @@ const char *proto_base_tokens[] = {
 	[PROTO_BASE_LL_HDR]		= "ll",
 	[PROTO_BASE_NETWORK_HDR]	= "nh",
 	[PROTO_BASE_TRANSPORT_HDR]	= "th",
+	[PROTO_BASE_INNER_HDR]		= "ih",
 };
 
 const struct proto_hdr_template proto_unknown_template =
diff --git a/src/scanner.l b/src/scanner.l
index 6cc7778dd85e..5d263f9dc8b1 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -414,6 +414,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "ll"			{ return LL_HDR; }
 "nh"			{ return NETWORK_HDR; }
 "th"			{ return TRANSPORT_HDR; }
+"ih"			{ return INNER_HDR; }
 
 "bridge"		{ return BRIDGE; }
 
-- 
2.30.2

