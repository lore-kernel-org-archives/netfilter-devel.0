Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AE6EC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Feb 2022 13:30:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237325AbiBSNbA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 08:31:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241982AbiBSNbA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 08:31:00 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FBF88B32
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 05:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wrTqTSEhceKduVsWG2Soc1y7WT5NwOvXt2fjb+pWCZU=; b=Zu2xnXvJGQ+3fNMeli0JyQkX2o
        5Z5efHtHKMUSLAedSZ/RFiU3EZQ/DoUDNpFg7g1E+LNrxMzHq12vSGGTBSF5kJLnJAbgagLGADgQL
        L9whgr+eJRl5lgqZ6Mkw+J0vQzqOBSnYf1ulRGVVJQW3zsrAS8UTIgBoxIfyN1AfFr5Ar7q9Ax1lV
        bwHvT7sOqrVffreWKxeSRPLLC/oTTsnJbpuwpXSnK68Tv3IZp0gOsvm8+E40ttVR6HKPQka3QtLYJ
        TWcFPBgaGiGwb5/BNutTRClBlkWMq1lPEXOUjbPhnDyBKRR89ILdU+EWosWd0emCGy+HnXJszKUjS
        TBwYlemw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nLPot-0002ea-Nw; Sat, 19 Feb 2022 14:30:40 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 05/26] scanner: icmp{,v6}: Move to own scope
Date:   Sat, 19 Feb 2022 14:27:53 +0100
Message-Id: <20220219132814.30823-6-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220219132814.30823-1-phil@nwl.cc>
References: <20220219132814.30823-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Unify the two, header fields are almost identical.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/parser.h   |  1 +
 src/parser_bison.y | 13 +++++++------
 src/scanner.l      | 19 +++++++++++--------
 3 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index cb7d12a36edb0..ba955c9160581 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -34,6 +34,7 @@ enum startcond_type {
 	PARSER_SC_CT,
 	PARSER_SC_COUNTER,
 	PARSER_SC_ETH,
+	PARSER_SC_ICMP,
 	PARSER_SC_IP,
 	PARSER_SC_IP6,
 	PARSER_SC_LIMIT,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index d67d16b8bc8c7..ca5140ade098e 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -935,6 +935,7 @@ close_scope_hash	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_HASH);
 close_scope_ip		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_IP); };
 close_scope_ip6		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_IP6); };
 close_scope_vlan	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_VLAN); };
+close_scope_icmp	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_ICMP); };
 close_scope_ipsec	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_IPSEC); };
 close_scope_list	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CMD_LIST); };
 close_scope_limit	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_LIMIT); };
@@ -3340,7 +3341,7 @@ reject_opts		:       /* empty */
 				$<stmt>0->reject.type = -1;
 				$<stmt>0->reject.icmp_code = -1;
 			}
-			|	WITH	ICMP	TYPE	reject_with_expr
+			|	WITH	ICMP	TYPE	reject_with_expr close_scope_icmp
 			{
 				$<stmt>0->reject.family = NFPROTO_IPV4;
 				$<stmt>0->reject.type = NFT_REJECT_ICMP_UNREACH;
@@ -3354,7 +3355,7 @@ reject_opts		:       /* empty */
 				$<stmt>0->reject.expr = $3;
 				datatype_set($<stmt>0->reject.expr, &icmp_code_type);
 			}
-			|	WITH	ICMP6	TYPE	reject_with_expr
+			|	WITH	ICMP6	TYPE	reject_with_expr close_scope_icmp
 			{
 				$<stmt>0->reject.family = NFPROTO_IPV6;
 				$<stmt>0->reject.type = NFT_REJECT_ICMP_UNREACH;
@@ -4789,7 +4790,7 @@ primary_rhs_expr	:	symbol_expr		{ $$ = $1; }
 							 BYTEORDER_HOST_ENDIAN,
 							 sizeof(data) * BITS_PER_BYTE, &data);
 			}
-			|	ICMP
+			|	ICMP	close_scope_icmp
 			{
 				uint8_t data = IPPROTO_ICMP;
 				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
@@ -4803,7 +4804,7 @@ primary_rhs_expr	:	symbol_expr		{ $$ = $1; }
 							 BYTEORDER_HOST_ENDIAN,
 							 sizeof(data) * BITS_PER_BYTE, &data);
 			}
-			|	ICMP6
+			|	ICMP6	close_scope_icmp
 			{
 				uint8_t data = IPPROTO_ICMPV6;
 				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
@@ -5379,7 +5380,7 @@ ip_option_field		:	TYPE		{ $$ = IPOPT_FIELD_TYPE; }
 			|	ADDR		{ $$ = IPOPT_FIELD_ADDR_0; }
 			;
 
-icmp_hdr_expr		:	ICMP	icmp_hdr_field
+icmp_hdr_expr		:	ICMP	icmp_hdr_field	close_scope_icmp
 			{
 				$$ = payload_expr_alloc(&@$, &proto_icmp, $2);
 			}
@@ -5422,7 +5423,7 @@ ip6_hdr_field		:	HDRVERSION	{ $$ = IP6HDR_VERSION; }
 			|	SADDR		{ $$ = IP6HDR_SADDR; }
 			|	DADDR		{ $$ = IP6HDR_DADDR; }
 			;
-icmp6_hdr_expr		:	ICMP6	icmp6_hdr_field
+icmp6_hdr_expr		:	ICMP6	icmp6_hdr_field	close_scope_icmp
 			{
 				$$ = payload_expr_alloc(&@$, &proto_icmp6, $2);
 			}
diff --git a/src/scanner.l b/src/scanner.l
index 9a189ec391328..e8ec352f88698 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -200,6 +200,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_CT
 %s SCANSTATE_COUNTER
 %s SCANSTATE_ETH
+%s SCANSTATE_ICMP
 %s SCANSTATE_IP
 %s SCANSTATE_IP6
 %s SCANSTATE_LIMIT
@@ -496,11 +497,16 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "sack-perm"		{ return SACK_PERM; }
 "timestamp"		{ return TIMESTAMP; }
 
-"icmp"			{ return ICMP; }
-"code"			{ return CODE; }
+"icmp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_ICMP); return ICMP; }
+"icmpv6"		{ scanner_push_start_cond(yyscanner, SCANSTATE_ICMP); return ICMP6; }
+<SCANSTATE_ICMP>{
+	"gateway"		{ return GATEWAY; }
+	"code"			{ return CODE; }
+	"param-problem"		{ return PPTR; }
+	"max-delay"		{ return MAXDELAY; }
+	"mtu"			{ return MTU; }
+}
 "sequence"		{ return SEQUENCE; }
-"gateway"		{ return GATEWAY; }
-"mtu"			{ return MTU; }
 
 "igmp"			{ return IGMP; }
 "mrt"			{ return MRT; }
@@ -513,10 +519,6 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 }
 "nexthdr"		{ return NEXTHDR; }
 
-"icmpv6"		{ return ICMP6; }
-"param-problem"		{ return PPTR; }
-"max-delay"		{ return MAXDELAY; }
-
 "ah"			{ return AH; }
 "reserved"		{ return RESERVED; }
 "spi"			{ return SPI; }
@@ -631,6 +633,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"classid"		{ return CLASSID; }
 	"nexthop"		{ return NEXTHOP; }
 	"seg-left"		{ return SEG_LEFT; }
+	"mtu"			{ return MTU; }
 }
 
 "ct"			{ scanner_push_start_cond(yyscanner, SCANSTATE_CT); return CT; }
-- 
2.34.1

