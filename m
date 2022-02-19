Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A42B0C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Feb 2022 13:29:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbiBSN3Y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 08:29:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbiBSN3X (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 08:29:23 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D89E673E6
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 05:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=aPqVnts1aWRVz5ADXgONSZFY7Yu83WiyJTLQp37ZmK0=; b=Vv4TB9ddBoEI+Keh++ZoFQho4m
        Tp/8oKYCToEOLlmSkZOx+8k5GIY1aBLGESG3muhjU/0yCLSL0nbbXD3UKTqCBSDz7so03d5aLv2nA
        42q/ggU9SvveTZHU96sjq+iROPMMnAPA01J0E1X1aq5cvFXfloZ/1YhREVb2BAj6O6JTBY0XXfQdp
        O8KzeJjcnz+JAQlPDAVc3K9YkRjZ7G5CLB7ruzub7kId1BJSzjPYeR2VTIptwzx0yWn0U4MbPiUgT
        y1r3c+unPJvSESoHFbfhz4MhowGzbXuQHS3nakDOHahBdG5puKTzxLEvYflb4itFVGa3yQhVBUaLR
        83d0ST3A==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nLPnI-0002XY-EY; Sat, 19 Feb 2022 14:29:01 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 15/26] scanner: type: Move to own scope
Date:   Sat, 19 Feb 2022 14:28:03 +0100
Message-Id: <20220219132814.30823-16-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220219132814.30823-1-phil@nwl.cc>
References: <20220219132814.30823-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

As a side-effect, this fixes for use of 'classid' as set data type.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/parser.h   |  1 +
 src/parser_bison.y | 65 +++++++++++++++++++++++-----------------------
 src/scanner.l      | 15 ++++++++---
 3 files changed, 45 insertions(+), 36 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 30ddef0326fae..072fea24eb0bd 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -43,6 +43,7 @@ enum startcond_type {
 	PARSER_SC_SCTP,
 	PARSER_SC_SECMARK,
 	PARSER_SC_TCP,
+	PARSER_SC_TYPE,
 	PARSER_SC_VLAN,
 	PARSER_SC_CMD_LIST,
 	PARSER_SC_EXPR_AH,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index eb4ac1a603206..c8fb154353924 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -958,6 +958,7 @@ close_scope_sctp_chunk	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_S
 close_scope_secmark	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_SECMARK); };
 close_scope_socket	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_SOCKET); }
 close_scope_tcp		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_TCP); };
+close_scope_type	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_TYPE); };
 close_scope_th		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_TH); };
 close_scope_udp		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_UDP); };
 close_scope_udplite	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_UDPLITE); };
@@ -1918,7 +1919,7 @@ set_block_alloc		:	/* empty */
 set_block		:	/* empty */	{ $$ = $<set>-1; }
 			|	set_block	common_block
 			|	set_block	stmt_separator
-			|	set_block	TYPE		data_type_expr	stmt_separator
+			|	set_block	TYPE		data_type_expr	stmt_separator	close_scope_type
 			{
 				$1->key = $3;
 				$$ = $1;
@@ -2012,7 +2013,7 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 			}
 			|	map_block	TYPE
 						data_type_expr	COLON	data_type_expr
-						stmt_separator
+						stmt_separator	close_scope_type
 			{
 				$1->key = $3;
 				$1->data = $5;
@@ -2022,7 +2023,7 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 			}
 			|	map_block	TYPE
 						data_type_expr	COLON	INTERVAL	data_type_expr
-						stmt_separator
+						stmt_separator	close_scope_type
 			{
 				$1->key = $3;
 				$1->data = $6;
@@ -2056,7 +2057,7 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 			}
 			|	map_block	TYPE
 						data_type_expr	COLON	map_block_obj_type
-						stmt_separator
+						stmt_separator	close_scope_type
 			{
 				$1->key = $3;
 				$1->objtype = $5;
@@ -2373,33 +2374,33 @@ type_identifier		:	STRING	{ $$ = $1; }
 			|	CLASSID { $$ = xstrdup("classid"); }
 			;
 
-hook_spec		:	TYPE		STRING		HOOK		STRING		dev_spec	prio_spec
+hook_spec		:	TYPE		close_scope_type	STRING		HOOK		STRING		dev_spec	prio_spec
 			{
-				const char *chain_type = chain_type_name_lookup($2);
+				const char *chain_type = chain_type_name_lookup($3);
 
 				if (chain_type == NULL) {
-					erec_queue(error(&@2, "unknown chain type"),
+					erec_queue(error(&@3, "unknown chain type"),
 						   state->msgs);
-					xfree($2);
+					xfree($3);
 					YYERROR;
 				}
-				$<chain>0->type.loc = @2;
+				$<chain>0->type.loc = @3;
 				$<chain>0->type.str = xstrdup(chain_type);
-				xfree($2);
+				xfree($3);
 
 				$<chain>0->loc = @$;
-				$<chain>0->hook.loc = @4;
-				$<chain>0->hook.name = chain_hookname_lookup($4);
+				$<chain>0->hook.loc = @5;
+				$<chain>0->hook.name = chain_hookname_lookup($5);
 				if ($<chain>0->hook.name == NULL) {
-					erec_queue(error(&@4, "unknown chain hook"),
+					erec_queue(error(&@5, "unknown chain hook"),
 						   state->msgs);
-					xfree($4);
+					xfree($5);
 					YYERROR;
 				}
-				xfree($4);
+				xfree($5);
 
-				$<chain>0->dev_expr	= $5;
-				$<chain>0->priority	= $6;
+				$<chain>0->dev_expr	= $6;
+				$<chain>0->priority	= $7;
 				$<chain>0->flags	|= CHAIN_F_BASECHAIN;
 			}
 			;
@@ -3355,7 +3356,7 @@ reject_opts		:       /* empty */
 				$<stmt>0->reject.type = -1;
 				$<stmt>0->reject.icmp_code = -1;
 			}
-			|	WITH	ICMP	TYPE	reject_with_expr close_scope_icmp
+			|	WITH	ICMP	TYPE	reject_with_expr close_scope_type close_scope_icmp
 			{
 				$<stmt>0->reject.family = NFPROTO_IPV4;
 				$<stmt>0->reject.type = NFT_REJECT_ICMP_UNREACH;
@@ -3369,7 +3370,7 @@ reject_opts		:       /* empty */
 				$<stmt>0->reject.expr = $3;
 				datatype_set($<stmt>0->reject.expr, &icmp_code_type);
 			}
-			|	WITH	ICMP6	TYPE	reject_with_expr close_scope_icmp
+			|	WITH	ICMP6	TYPE	reject_with_expr close_scope_type close_scope_icmp
 			{
 				$<stmt>0->reject.family = NFPROTO_IPV6;
 				$<stmt>0->reject.type = NFT_REJECT_ICMP_UNREACH;
@@ -3383,7 +3384,7 @@ reject_opts		:       /* empty */
 				$<stmt>0->reject.expr = $3;
 				datatype_set($<stmt>0->reject.expr, &icmpv6_code_type);
 			}
-			|	WITH	ICMPX	TYPE	reject_with_expr
+			|	WITH	ICMPX	TYPE	reject_with_expr close_scope_type
 			{
 				$<stmt>0->reject.type = NFT_REJECT_ICMPX_UNREACH;
 				$<stmt>0->reject.expr = $4;
@@ -4094,7 +4095,7 @@ fib_expr		:	FIB	fib_tuple	fib_result	close_scope_fib
 
 fib_result		:	OIF	{ $$ =NFT_FIB_RESULT_OIF; }
 			|	OIFNAME { $$ =NFT_FIB_RESULT_OIFNAME; }
-			|	TYPE	{ $$ =NFT_FIB_RESULT_ADDRTYPE; }
+			|	TYPE	close_scope_type	{ $$ =NFT_FIB_RESULT_ADDRTYPE; }
 			;
 
 fib_flag		:       SADDR	{ $$ = NFTA_FIB_F_SADDR; }
@@ -4499,7 +4500,7 @@ ct_l4protoname		:	TCP	close_scope_tcp	{ $$ = IPPROTO_TCP; }
 			|	UDP	close_scope_udp	{ $$ = IPPROTO_UDP; }
 			;
 
-ct_helper_config		:	TYPE	QUOTED_STRING	PROTOCOL	ct_l4protoname	stmt_separator
+ct_helper_config		:	TYPE	QUOTED_STRING	PROTOCOL	ct_l4protoname	stmt_separator	close_scope_type
 			{
 				struct ct_helper *ct;
 				int ret;
@@ -5315,7 +5316,7 @@ eth_hdr_expr		:	ETHER	eth_hdr_field	close_scope_eth
 
 eth_hdr_field		:	SADDR		{ $$ = ETHHDR_SADDR; }
 			|	DADDR		{ $$ = ETHHDR_DADDR; }
-			|	TYPE		{ $$ = ETHHDR_TYPE; }
+			|	TYPE		close_scope_type	{ $$ = ETHHDR_TYPE; }
 			;
 
 vlan_hdr_expr		:	VLAN	vlan_hdr_field	close_scope_vlan
@@ -5328,7 +5329,7 @@ vlan_hdr_field		:	ID		{ $$ = VLANHDR_VID; }
 			|	CFI		{ $$ = VLANHDR_CFI; }
 			|	DEI		{ $$ = VLANHDR_DEI; }
 			|	PCP		{ $$ = VLANHDR_PCP; }
-			|	TYPE		{ $$ = VLANHDR_TYPE; }
+			|	TYPE		close_scope_type	{ $$ = VLANHDR_TYPE; }
 			;
 
 arp_hdr_expr		:	ARP	arp_hdr_field	close_scope_arp
@@ -5387,7 +5388,7 @@ ip_option_type		:	LSRR		{ $$ = IPOPT_LSRR; }
 			|	RA		{ $$ = IPOPT_RA; }
 			;
 
-ip_option_field		:	TYPE		{ $$ = IPOPT_FIELD_TYPE; }
+ip_option_field		:	TYPE		close_scope_type	{ $$ = IPOPT_FIELD_TYPE; }
 			|	LENGTH		{ $$ = IPOPT_FIELD_LENGTH; }
 			|	VALUE		{ $$ = IPOPT_FIELD_VALUE; }
 			|	PTR		{ $$ = IPOPT_FIELD_PTR; }
@@ -5400,7 +5401,7 @@ icmp_hdr_expr		:	ICMP	icmp_hdr_field	close_scope_icmp
 			}
 			;
 
-icmp_hdr_field		:	TYPE		{ $$ = ICMPHDR_TYPE; }
+icmp_hdr_field		:	TYPE		close_scope_type	{ $$ = ICMPHDR_TYPE; }
 			|	CODE		{ $$ = ICMPHDR_CODE; }
 			|	CHECKSUM	{ $$ = ICMPHDR_CHECKSUM; }
 			|	ID		{ $$ = ICMPHDR_ID; }
@@ -5415,7 +5416,7 @@ igmp_hdr_expr		:	IGMP	igmp_hdr_field	close_scope_igmp
 			}
 			;
 
-igmp_hdr_field		:	TYPE		{ $$ = IGMPHDR_TYPE; }
+igmp_hdr_field		:	TYPE		close_scope_type	{ $$ = IGMPHDR_TYPE; }
 			|	CHECKSUM	{ $$ = IGMPHDR_CHECKSUM; }
 			|	MRT		{ $$ = IGMPHDR_MRT; }
 			|	GROUP		{ $$ = IGMPHDR_GROUP; }
@@ -5443,7 +5444,7 @@ icmp6_hdr_expr		:	ICMP6	icmp6_hdr_field	close_scope_icmp
 			}
 			;
 
-icmp6_hdr_field		:	TYPE		{ $$ = ICMP6HDR_TYPE; }
+icmp6_hdr_field		:	TYPE		close_scope_type	{ $$ = ICMP6HDR_TYPE; }
 			|	CODE		{ $$ = ICMP6HDR_CODE; }
 			|	CHECKSUM	{ $$ = ICMP6HDR_CHECKSUM; }
 			|	PPTR		{ $$ = ICMP6HDR_PPTR; }
@@ -5627,7 +5628,7 @@ dccp_hdr_expr		:	DCCP	dccp_hdr_field	close_scope_dccp
 
 dccp_hdr_field		:	SPORT		{ $$ = DCCPHDR_SPORT; }
 			|	DPORT		{ $$ = DCCPHDR_DPORT; }
-			|	TYPE		{ $$ = DCCPHDR_TYPE; }
+			|	TYPE		close_scope_type	{ $$ = DCCPHDR_TYPE; }
 			;
 
 sctp_chunk_type		:	DATA		{ $$ = SCTP_CHUNK_TYPE_DATA; }
@@ -5650,7 +5651,7 @@ sctp_chunk_type		:	DATA		{ $$ = SCTP_CHUNK_TYPE_DATA; }
 			|	ASCONF		{ $$ = SCTP_CHUNK_TYPE_ASCONF; }
 			;
 
-sctp_chunk_common_field	:	TYPE	{ $$ = SCTP_CHUNK_COMMON_TYPE; }
+sctp_chunk_common_field	:	TYPE	close_scope_type	{ $$ = SCTP_CHUNK_COMMON_TYPE; }
 			|	FLAGS	{ $$ = SCTP_CHUNK_COMMON_FLAGS; }
 			|	LENGTH	{ $$ = SCTP_CHUNK_COMMON_LENGTH; }
 			;
@@ -5787,7 +5788,7 @@ rt_hdr_expr		:	RT	rt_hdr_field	close_scope_rt
 
 rt_hdr_field		:	NEXTHDR		{ $$ = RTHDR_NEXTHDR; }
 			|	HDRLENGTH	{ $$ = RTHDR_HDRLENGTH; }
-			|	TYPE		{ $$ = RTHDR_TYPE; }
+			|	TYPE		close_scope_type	{ $$ = RTHDR_TYPE; }
 			|	SEG_LEFT	{ $$ = RTHDR_SEG_LEFT; }
 			;
 
@@ -5859,7 +5860,7 @@ mh_hdr_expr		:	MH	mh_hdr_field	close_scope_mh
 
 mh_hdr_field		:	NEXTHDR		{ $$ = MHHDR_NEXTHDR; }
 			|	HDRLENGTH	{ $$ = MHHDR_HDRLENGTH; }
-			|	TYPE		{ $$ = MHHDR_TYPE; }
+			|	TYPE		close_scope_type	{ $$ = MHHDR_TYPE; }
 			|	RESERVED	{ $$ = MHHDR_RESERVED; }
 			|	CHECKSUM	{ $$ = MHHDR_CHECKSUM; }
 			;
diff --git a/src/scanner.l b/src/scanner.l
index e632d825f9ed8..eb8c3a130aac9 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -209,6 +209,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_SCTP
 %s SCANSTATE_SECMARK
 %s SCANSTATE_TCP
+%s SCANSTATE_TYPE
 %s SCANSTATE_VLAN
 %s SCANSTATE_CMD_LIST
 %s SCANSTATE_EXPR_AH
@@ -440,7 +441,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"saddr"			{ return SADDR; }
 	"daddr"			{ return DADDR; }
 }
-"type"			{ return TYPE; }
+"type"			{ scanner_push_start_cond(yyscanner, SCANSTATE_TYPE); return TYPE; }
 "typeof"		{ return TYPEOF; }
 
 "vlan"			{ scanner_push_start_cond(yyscanner, SCANSTATE_VLAN); return VLAN; }
@@ -469,7 +470,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 <SCANSTATE_EXPR_AH,SCANSTATE_EXPR_DST,SCANSTATE_EXPR_HBH,SCANSTATE_EXPR_MH,SCANSTATE_EXPR_RT,SCANSTATE_IP>{
 	"hdrlength"		{ return HDRLENGTH; }
 }
-"dscp"			{ return DSCP; }
+<SCANSTATE_IP,SCANSTATE_IP6,SCANSTATE_TYPE>{
+	"dscp"			{ return DSCP; }
+}
 "ecn"			{ return ECN; }
 "length"		{ return LENGTH; }
 <SCANSTATE_EXPR_FRAG,SCANSTATE_IP>{
@@ -560,7 +563,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"flowlabel"		{ return FLOWLABEL; }
 	"hoplimit"		{ return HOPLIMIT; }
 }
-"nexthdr"		{ return NEXTHDR; }
+<SCANSTATE_EXPR_AH,SCANSTATE_EXPR_COMP,SCANSTATE_EXPR_DST,SCANSTATE_EXPR_FRAG,SCANSTATE_EXPR_HBH,SCANSTATE_EXPR_MH,SCANSTATE_EXPR_RT,SCANSTATE_IP6>{
+	"nexthdr"		{ return NEXTHDR; }
+}
 
 "ah"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_AH); return AH; }
 <SCANSTATE_EXPR_AH,SCANSTATE_EXPR_FRAG,SCANSTATE_EXPR_MH,SCANSTATE_TCP>{
@@ -681,11 +686,13 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "cgroup"		{ return CGROUP; }
 
 <SCANSTATE_EXPR_RT>{
-	"classid"		{ return CLASSID; }
 	"nexthop"		{ return NEXTHOP; }
 	"seg-left"		{ return SEG_LEFT; }
 	"mtu"			{ return MTU; }
 }
+<SCANSTATE_EXPR_RT,SCANSTATE_TYPE>{
+	"classid"		{ return CLASSID; }
+}
 
 "ct"			{ scanner_push_start_cond(yyscanner, SCANSTATE_CT); return CT; }
 <SCANSTATE_CT>{
-- 
2.34.1

