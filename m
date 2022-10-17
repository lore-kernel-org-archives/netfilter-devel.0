Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F344C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Oct 2022 11:04:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbiJQLE3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Oct 2022 07:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiJQLEW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2022 07:04:22 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0B66CE44
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2022 04:04:21 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 11/16] src: add geneve matching support
Date:   Mon, 17 Oct 2022 13:04:03 +0200
Message-Id: <20221017110408.742223-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221017110408.742223-1-pablo@netfilter.org>
References: <20221017110408.742223-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add support for GENEVE vni and (ether) type header field.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/proto.h    | 13 +++++++++++++
 src/parser_bison.y | 32 +++++++++++++++++++++++++++++---
 src/proto.c        | 28 ++++++++++++++++++++++++++++
 src/scanner.l      |  2 ++
 4 files changed, 72 insertions(+), 3 deletions(-)

diff --git a/include/proto.h b/include/proto.h
index 4b0c71467638..c2c973f383cf 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -97,6 +97,7 @@ enum proto_desc_id {
 	PROTO_DESC_VLAN,
 	PROTO_DESC_ETHER,
 	PROTO_DESC_VXLAN,
+	PROTO_DESC_GENEVE,
 	PROTO_DESC_GRE,
 	__PROTO_DESC_MAX
 };
@@ -397,6 +398,17 @@ enum vxlan_hdr_fields {
 	VXLANHDR_FLAGS,
 };
 
+struct gnvhdr {
+	uint16_t flags;
+	uint16_t type;
+	uint32_t vni;
+};
+enum geneve_hdr_fields {
+	GNVHDR_INVALID,
+	GNVHDR_VNI,
+	GNVHDR_TYPE,
+};
+
 struct grehdr {
 	uint16_t flags;
 	uint16_t protocol;
@@ -410,6 +422,7 @@ enum gre_hdr_fields {
 };
 
 extern const struct proto_desc proto_vxlan;
+extern const struct proto_desc proto_geneve;
 extern const struct proto_desc proto_gre;
 
 extern const struct proto_desc proto_icmp;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 9273a09a3727..99bb17e7fb07 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -444,6 +444,8 @@ int nft_lex(void *, void *, void *);
 
 %token GRE			"gre"
 
+%token GENEVE			"geneve"
+
 %token SCTP			"sctp"
 %token CHUNK			"chunk"
 %token DATA			"data"
@@ -902,9 +904,12 @@ int nft_lex(void *, void *, void *);
 %type <val>			tcpopt_field_maxseg	tcpopt_field_mptcp	tcpopt_field_sack	 tcpopt_field_tsopt	tcpopt_field_window
 %type <tcp_kind_field>		tcp_hdr_option_kind_and_field
 
-%type <expr>			inner_eth_expr inner_inet_expr inner_expr vxlan_hdr_expr gre_hdr_expr
-%destructor { expr_free($$); }	inner_eth_expr inner_inet_expr inner_expr vxlan_hdr_expr gre_hdr_expr
-%type <val>			vxlan_hdr_field gre_hdr_field
+%type <expr>			inner_eth_expr inner_inet_expr inner_expr
+%destructor { expr_free($$); }	inner_eth_expr inner_inet_expr inner_expr
+
+%type <expr>			vxlan_hdr_expr geneve_hdr_expr gre_hdr_expr
+%destructor { expr_free($$); }	vxlan_hdr_expr geneve_hdr_expr gre_hdr_expr
+%type <val>			vxlan_hdr_field geneve_hdr_field gre_hdr_field
 
 %type <stmt>			optstrip_stmt
 %destructor { stmt_free($$); }	optstrip_stmt
@@ -5329,6 +5334,7 @@ payload_expr		:	payload_raw_expr
 			|	sctp_hdr_expr
 			|	th_hdr_expr
 			|	vxlan_hdr_expr
+			|	geneve_hdr_expr
 			|	gre_hdr_expr
 			;
 
@@ -5626,6 +5632,26 @@ vxlan_hdr_field		:	VNI			{ $$ = VXLANHDR_VNI; }
 			|	FLAGS			{ $$ = VXLANHDR_FLAGS; }
 			;
 
+geneve_hdr_expr		:	GENEVE	geneve_hdr_field
+			{
+				struct expr *expr;
+
+				expr = payload_expr_alloc(&@$, &proto_geneve, $2);
+				expr->payload.inner_desc = &proto_geneve;
+				$$ = expr;
+			}
+			|	GENEVE	inner_expr
+			{
+				$$ = $2;
+				$$->location = @$;
+				$$->payload.inner_desc = &proto_geneve;
+			}
+			;
+
+geneve_hdr_field	:	VNI			{ $$ = GNVHDR_VNI; }
+			|	TYPE			{ $$ = GNVHDR_TYPE; }
+			;
+
 gre_hdr_expr		:	GRE	gre_hdr_field	close_scope_gre
 			{
 				$$ = payload_expr_alloc(&@$, &proto_gre, $2);
diff --git a/src/proto.c b/src/proto.c
index 3bb4ae74a439..0986a3800000 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -90,6 +90,7 @@ int proto_find_num(const struct proto_desc *base,
 
 static const struct proto_desc *inner_protocols[] = {
 	&proto_vxlan,
+	&proto_geneve,
 	&proto_gre,
 };
 
@@ -542,6 +543,7 @@ const struct proto_desc proto_udp = {
 	},
 	.protocols	= {
 		PROTO_LINK(0,	&proto_vxlan),
+		PROTO_LINK(0,	&proto_geneve),
 	},
 };
 
@@ -1215,6 +1217,32 @@ const struct proto_desc proto_vxlan = {
 	},
 };
 
+/*
+ * GENEVE
+ */
+
+const struct proto_desc proto_geneve = {
+	.name		= "geneve",
+	.id		= PROTO_DESC_GENEVE,
+	.base		= PROTO_BASE_INNER_HDR,
+	.templates	= {
+		[GNVHDR_TYPE]	= HDR_TYPE("type", &ethertype_type, struct gnvhdr, type),
+		[GNVHDR_VNI]	= HDR_BITFIELD("vni", &integer_type, (4 * BITS_PER_BYTE), 24),
+	},
+	.protocols	= {
+		PROTO_LINK(__constant_htons(ETH_P_IP),		&proto_ip),
+		PROTO_LINK(__constant_htons(ETH_P_ARP),		&proto_arp),
+		PROTO_LINK(__constant_htons(ETH_P_IPV6),	&proto_ip6),
+		PROTO_LINK(__constant_htons(ETH_P_8021Q),	&proto_vlan),
+	},
+	.inner		= {
+		.hdrsize	= sizeof(struct gnvhdr),
+		.flags		= NFT_INNER_HDRSIZE | NFT_INNER_LL | NFT_INNER_NH | NFT_INNER_TH,
+		.type		= NFT_INNER_GENEVE,
+	},
+};
+
+
 /*
  * Dummy protocol for netdev tables.
  */
diff --git a/src/scanner.l b/src/scanner.l
index 06ca4059f266..cc5b9c43233f 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -624,6 +624,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "vxlan"			{ return VXLAN; }
 "vni"			{ return VNI; }
 
+"geneve"		{ return GENEVE; }
+
 "gre"			{ scanner_push_start_cond(yyscanner, SCANSTATE_GRE); return GRE; }
 
 "tcp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_TCP); return TCP; }
-- 
2.30.2

