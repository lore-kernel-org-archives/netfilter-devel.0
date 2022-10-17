Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E65B5C43217
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Oct 2022 11:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbiJQLEa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Oct 2022 07:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbiJQLEX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2022 07:04:23 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 94AC460E1
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2022 04:04:22 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 14/16] src: add gretap support
Date:   Mon, 17 Oct 2022 13:04:06 +0200
Message-Id: <20221017110408.742223-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221017110408.742223-1-pablo@netfilter.org>
References: <20221017110408.742223-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/proto.h           |  2 ++
 src/netlink_delinearize.c |  3 ++-
 src/parser_bison.y        | 13 +++++++++++--
 src/proto.c               | 19 +++++++++++++++++++
 src/scanner.l             |  1 +
 5 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/include/proto.h b/include/proto.h
index c2c973f383cf..3a20ff8c4071 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -99,6 +99,7 @@ enum proto_desc_id {
 	PROTO_DESC_VXLAN,
 	PROTO_DESC_GENEVE,
 	PROTO_DESC_GRE,
+	PROTO_DESC_GRETAP,
 	__PROTO_DESC_MAX
 };
 #define PROTO_DESC_MAX	(__PROTO_DESC_MAX - 1)
@@ -424,6 +425,7 @@ enum gre_hdr_fields {
 extern const struct proto_desc proto_vxlan;
 extern const struct proto_desc proto_geneve;
 extern const struct proto_desc proto_gre;
+extern const struct proto_desc proto_gretap;
 
 extern const struct proto_desc proto_icmp;
 extern const struct proto_desc proto_igmp;
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index fbabb7d2203d..7ce693472641 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1977,7 +1977,8 @@ static bool meta_outer_may_dependency_kill(struct rule_pp_ctx *ctx,
 
 	switch (l4proto) {
 	case IPPROTO_GRE:
-		if (expr->payload.inner_desc == &proto_gre)
+		if (expr->payload.inner_desc == &proto_gre ||
+		    expr->payload.inner_desc == &proto_gretap)
 			return true;
 		break;
 	default:
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 99bb17e7fb07..5a66b43cb205 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -443,6 +443,7 @@ int nft_lex(void *, void *, void *);
 %token VNI			"vni"
 
 %token GRE			"gre"
+%token GRETAP			"gretap"
 
 %token GENEVE			"geneve"
 
@@ -907,8 +908,8 @@ int nft_lex(void *, void *, void *);
 %type <expr>			inner_eth_expr inner_inet_expr inner_expr
 %destructor { expr_free($$); }	inner_eth_expr inner_inet_expr inner_expr
 
-%type <expr>			vxlan_hdr_expr geneve_hdr_expr gre_hdr_expr
-%destructor { expr_free($$); }	vxlan_hdr_expr geneve_hdr_expr gre_hdr_expr
+%type <expr>			vxlan_hdr_expr geneve_hdr_expr gre_hdr_expr gretap_hdr_expr
+%destructor { expr_free($$); }	vxlan_hdr_expr geneve_hdr_expr gre_hdr_expr gretap_hdr_expr
 %type <val>			vxlan_hdr_field geneve_hdr_field gre_hdr_field
 
 %type <stmt>			optstrip_stmt
@@ -5336,6 +5337,7 @@ payload_expr		:	payload_raw_expr
 			|	vxlan_hdr_expr
 			|	geneve_hdr_expr
 			|	gre_hdr_expr
+			|	gretap_hdr_expr
 			;
 
 payload_raw_expr	:	AT	payload_base_spec	COMMA	NUM	COMMA	NUM	close_scope_at
@@ -5668,6 +5670,13 @@ gre_hdr_field		:	HDRVERSION		{ $$ = GREHDR_VERSION;	}
 			|	PROTOCOL		{ $$ = GREHDR_PROTOCOL; }
 			;
 
+gretap_hdr_expr		:	GRETAP	close_scope_gre inner_expr
+			{
+				$$ = $3;
+				$$->payload.inner_desc = &proto_gretap;
+			}
+			;
+
 optstrip_stmt		:	RESET	TCP	OPTION	tcp_hdr_option_type	close_scope_tcp
 			{
 				$$ = optstrip_stmt_alloc(&@$, tcpopt_expr_alloc(&@$,
diff --git a/src/proto.c b/src/proto.c
index 0986a3800000..edf99e840c0c 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -92,6 +92,7 @@ static const struct proto_desc *inner_protocols[] = {
 	&proto_vxlan,
 	&proto_geneve,
 	&proto_gre,
+	&proto_gretap,
 };
 
 const struct proto_desc *proto_find_inner(uint32_t type, uint32_t hdrsize,
@@ -796,6 +797,20 @@ const struct proto_desc proto_gre = {
 	},
 };
 
+const struct proto_desc proto_gretap = {
+	.name		= "gretap",
+	.id		= PROTO_DESC_GRETAP,
+	.base		= PROTO_BASE_TRANSPORT_HDR,
+	.templates	= {
+		[0] = PROTO_META_TEMPLATE("l4proto", &inet_protocol_type, NFT_META_L4PROTO, 8),
+	},
+	.inner		= {
+		.hdrsize	= sizeof(struct grehdr),
+		.flags		= NFT_INNER_LL | NFT_INNER_NH | NFT_INNER_TH,
+		.type		= NFT_INNER_GENEVE + 2,
+	},
+};
+
 #define IPHDR_FIELD(__name, __member) \
 	HDR_FIELD(__name, struct iphdr, __member)
 #define IPHDR_ADDR(__name, __member) \
@@ -820,6 +835,7 @@ const struct proto_desc proto_ip = {
 		PROTO_LINK(IPPROTO_DCCP,	&proto_dccp),
 		PROTO_LINK(IPPROTO_SCTP,	&proto_sctp),
 		PROTO_LINK(IPPROTO_GRE,		&proto_gre),
+		PROTO_LINK(IPPROTO_GRE,		&proto_gretap),
 	},
 	.templates	= {
 		[0]	= PROTO_META_TEMPLATE("l4proto", &inet_protocol_type, NFT_META_L4PROTO, 8),
@@ -947,6 +963,7 @@ const struct proto_desc proto_ip6 = {
 		PROTO_LINK(IPPROTO_IGMP,	&proto_igmp),
 		PROTO_LINK(IPPROTO_ICMPV6,	&proto_icmp6),
 		PROTO_LINK(IPPROTO_GRE,		&proto_gre),
+		PROTO_LINK(IPPROTO_GRE,		&proto_gretap),
 	},
 	.templates	= {
 		[0]	= PROTO_META_TEMPLATE("l4proto", &inet_protocol_type, NFT_META_L4PROTO, 8),
@@ -1013,6 +1030,7 @@ const struct proto_desc proto_inet_service = {
 		PROTO_LINK(IPPROTO_IGMP,	&proto_igmp),
 		PROTO_LINK(IPPROTO_ICMPV6,	&proto_icmp6),
 		PROTO_LINK(IPPROTO_GRE,		&proto_gre),
+		PROTO_LINK(IPPROTO_GRE,		&proto_gretap),
 	},
 	.templates	= {
 		[0]	= PROTO_META_TEMPLATE("l4proto", &inet_protocol_type, NFT_META_L4PROTO, 8),
@@ -1281,6 +1299,7 @@ static const struct proto_desc *proto_definitions[PROTO_DESC_MAX + 1] = {
 	[PROTO_DESC_ETHER]	= &proto_eth,
 	[PROTO_DESC_VXLAN]	= &proto_vxlan,
 	[PROTO_DESC_GRE]	= &proto_gre,
+	[PROTO_DESC_GRETAP]	= &proto_gretap,
 };
 
 const struct proto_desc *proto_find_desc(enum proto_desc_id desc_id)
diff --git a/src/scanner.l b/src/scanner.l
index cc5b9c43233f..0ef9a1a5c9fd 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -627,6 +627,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "geneve"		{ return GENEVE; }
 
 "gre"			{ scanner_push_start_cond(yyscanner, SCANSTATE_GRE); return GRE; }
+"gretap"		{ scanner_push_start_cond(yyscanner, SCANSTATE_GRE); return GRETAP; }
 
 "tcp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_TCP); return TCP; }
 
-- 
2.30.2

