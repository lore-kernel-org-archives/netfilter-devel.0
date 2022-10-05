Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B19C8C43217
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Oct 2022 22:48:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiJEWsl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Oct 2022 18:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiJEWsk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Oct 2022 18:48:40 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2C22A60525
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Oct 2022 15:48:39 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] src: add ipip support
Date:   Thu,  6 Oct 2022 00:48:33 +0200
Message-Id: <20221005224833.24056-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221005224833.24056-1-pablo@netfilter.org>
References: <20221005224833.24056-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This generates an implicit dependency on NFT_META_L4PROTO for IPPROTO_IP.
This does _not_ generate a dependendy for NFT_META_PROTOCOL on 0x800 (ip)
because the tunnel protocol driver "ip6tnl" in the tree uses IPPROTO_IP
for IPv4 over IPv6 (ipip6).

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/proto.h           |  2 ++
 src/netlink_delinearize.c |  4 ++++
 src/parser_bison.y        | 22 ++++++++++++++++++++--
 src/proto.c               | 18 ++++++++++++++++++
 src/scanner.l             |  1 +
 5 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/include/proto.h b/include/proto.h
index 2a82c385c330..14e25e0aefa4 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -98,6 +98,7 @@ enum proto_desc_id {
 	PROTO_DESC_ETHER,
 	PROTO_DESC_VXLAN,
 	PROTO_DESC_GRE,
+	PROTO_DESC_IPIP,
 	__PROTO_DESC_MAX
 };
 #define PROTO_DESC_MAX	(__PROTO_DESC_MAX - 1)
@@ -410,6 +411,7 @@ enum gre_hdr_fields {
 
 extern const struct proto_desc proto_vxlan;
 extern const struct proto_desc proto_gre;
+extern const struct proto_desc proto_ipip;
 
 extern const struct proto_desc proto_icmp;
 extern const struct proto_desc proto_igmp;
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 68185d477cc1..d411ae8e37c5 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1980,6 +1980,10 @@ static bool meta_outer_may_dependency_kill(struct rule_pp_ctx *ctx,
 		if (expr->left->payload.inner_desc == &proto_gre)
 			return true;
 		break;
+	case IPPROTO_IPIP:
+		if (expr->left->payload.inner_desc == &proto_ipip)
+			return true;
+		break;
 	default:
 		break;
 	}
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 52fb17a83879..ca7e14b7d613 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -432,6 +432,7 @@ int nft_lex(void *, void *, void *);
 %token VNI			"vni"
 
 %token GRE			"gre"
+%token IPIP			"ipip"
 
 %token SCTP			"sctp"
 %token CHUNK			"chunk"
@@ -891,8 +892,8 @@ int nft_lex(void *, void *, void *);
 %type <val>			tcpopt_field_maxseg	tcpopt_field_mptcp	tcpopt_field_sack	 tcpopt_field_tsopt	tcpopt_field_window
 %type <tcp_kind_field>		tcp_hdr_option_kind_and_field
 
-%type <expr>			inner_eth_expr inner_inet_expr inner_expr vxlan_hdr_expr gre_hdr_expr
-%destructor { expr_free($$); }	inner_eth_expr inner_inet_expr inner_expr vxlan_hdr_expr gre_hdr_expr
+%type <expr>			inner_eth_expr inner_inet_expr inner_expr vxlan_hdr_expr gre_hdr_expr ipip_hdr_expr
+%destructor { expr_free($$); }	inner_eth_expr inner_inet_expr inner_expr vxlan_hdr_expr gre_hdr_expr ipip_hdr_expr
 %type <val>			vxlan_hdr_field gre_hdr_field
 
 %type <stmt>			optstrip_stmt
@@ -4849,6 +4850,15 @@ primary_rhs_expr	:	symbol_expr		{ $$ = $1; }
 			|	GRE
 			{
 				uint8_t data = IPPROTO_GRE;
+
+				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
+							 BYTEORDER_HOST_ENDIAN,
+							 sizeof(data) * BITS_PER_BYTE, &data);
+			}
+			|	IPIP
+			{
+				uint8_t data = IPPROTO_IPIP;
+
 				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
 							 BYTEORDER_HOST_ENDIAN,
 							 sizeof(data) * BITS_PER_BYTE, &data);
@@ -5310,6 +5320,7 @@ payload_expr		:	payload_raw_expr
 			|	th_hdr_expr
 			|	vxlan_hdr_expr
 			|	gre_hdr_expr
+			|	ipip_hdr_expr
 			;
 
 payload_raw_expr	:	AT	payload_base_spec	COMMA	NUM	COMMA	NUM	close_scope_at
@@ -5625,6 +5636,13 @@ gre_hdr_field		:	FLAGS			{ $$ = GREHDR_FLAGS; }
 			|	PROTOCOL		{ $$ = GREHDR_PROTOCOL; }
 			;
 
+ipip_hdr_expr		:	IPIP	inner_expr
+			{
+				$$ = $2;
+				$$->payload.inner_desc = &proto_ipip;
+			}
+			;
+
 optstrip_stmt		:	RESET	TCP	OPTION	tcp_hdr_option_type	close_scope_tcp
 			{
 				$$ = optstrip_stmt_alloc(&@$, tcpopt_expr_alloc(&@$,
diff --git a/src/proto.c b/src/proto.c
index 10454d405888..72e9e4a542a3 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -91,6 +91,7 @@ int proto_find_num(const struct proto_desc *base,
 static const struct proto_desc *inner_protocols[] = {
 	&proto_vxlan,
 	&proto_gre,
+	&proto_ipip,
 };
 
 const struct proto_desc *proto_find_inner(uint32_t type, uint32_t hdrsize,
@@ -800,6 +801,20 @@ const struct proto_desc proto_gre = {
 #define IPHDR_ADDR(__name, __member) \
 	HDR_TYPE(__name, &ipaddr_type, struct iphdr, __member)
 
+const struct proto_desc proto_ipip = {
+	.name		= "ipip",
+	.id		= PROTO_DESC_IPIP,
+	.base		= PROTO_BASE_TRANSPORT_HDR,
+	.templates	= {
+		[0]	= PROTO_META_TEMPLATE("l4proto", &inet_protocol_type, NFT_META_L4PROTO, 8),
+	},
+	.inner		= {
+		.hdrsize	= 0,
+		.flags		= NFT_INNER_NH | NFT_INNER_TH,
+		.type		= NFT_INNER_GENEVE + 2,
+	},
+};
+
 const struct proto_desc proto_ip = {
 	.name		= "ip",
 	.id		= PROTO_DESC_IP,
@@ -819,6 +834,7 @@ const struct proto_desc proto_ip = {
 		PROTO_LINK(IPPROTO_DCCP,	&proto_dccp),
 		PROTO_LINK(IPPROTO_SCTP,	&proto_sctp),
 		PROTO_LINK(IPPROTO_GRE,		&proto_gre),
+		PROTO_LINK(IPPROTO_IPIP,	&proto_ipip),
 	},
 	.templates	= {
 		[0]	= PROTO_META_TEMPLATE("l4proto", &inet_protocol_type, NFT_META_L4PROTO, 8),
@@ -1011,6 +1027,7 @@ const struct proto_desc proto_inet_service = {
 		PROTO_LINK(IPPROTO_IGMP,	&proto_igmp),
 		PROTO_LINK(IPPROTO_ICMPV6,	&proto_icmp6),
 		PROTO_LINK(IPPROTO_GRE,		&proto_gre),
+		PROTO_LINK(IPPROTO_IPIP,	&proto_ipip),
 	},
 	.templates	= {
 		[0]	= PROTO_META_TEMPLATE("l4proto", &inet_protocol_type, NFT_META_L4PROTO, 8),
@@ -1253,6 +1270,7 @@ static const struct proto_desc *proto_definitions[PROTO_DESC_MAX + 1] = {
 	[PROTO_DESC_ETHER]	= &proto_eth,
 	[PROTO_DESC_VXLAN]	= &proto_vxlan,
 	[PROTO_DESC_GRE]	= &proto_gre,
+	[PROTO_DESC_IPIP]	= &proto_ipip,
 };
 
 const struct proto_desc *proto_find_desc(enum proto_desc_id desc_id)
diff --git a/src/scanner.l b/src/scanner.l
index 2fc4c6c5e64a..b5b42be95689 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -624,6 +624,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "vni"			{ return VNI; }
 
 "gre"			{ return GRE; }
+"ipip"			{ return IPIP; }
 
 "tcp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_TCP); return TCP; }
 
-- 
2.30.2

