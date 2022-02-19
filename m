Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6DE7C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Feb 2022 13:29:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234934AbiBSN3v (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 08:29:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234261AbiBSN3t (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 08:29:49 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90BC7B540
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 05:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zqPZsq7zusXhb/el4K0wednnAiu6/SHCjgy9HVYHYfI=; b=HihrMPDVCVbGHySvSh792YI2LY
        lseBT8fHnsT690Ce+y3JoqRpTTkodwX+U16QXkd335WNH2JhqR9IvBt6HlvpnGtjSwQ5mDQnrpxcH
        0SMVhf+8vyB7eQH1B6OyYjgWVEGvgzWb/hzTr4viiiXS5AcE/5rBircdC/WHSyzjy1LV4/2qMuCv2
        LjQg7t7s+r3eGPxs/dNtOGXiDQxczgEmL/1tTUgNzDW/GRUFp1TtJ2eI42B+FqO+K/IF10Y+7/j4n
        pnyIurRz535S2l3DUgqwzKDrZkJ0KtHA8PL+TUJJE/9KrhIWwbjkzi/j+EqbqwU7j3zZb2xMHiEPN
        6+SugmBQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nLPnl-0002ZR-AL; Sat, 19 Feb 2022 14:29:29 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 14/26] scanner: dst, frag, hbh, mh: Move to own scopes
Date:   Sat, 19 Feb 2022 14:28:02 +0100
Message-Id: <20220219132814.30823-15-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220219132814.30823-1-phil@nwl.cc>
References: <20220219132814.30823-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These are the remaining IPv6 extension header expressions, only rt
expression was scoped already.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/parser.h   |  4 ++++
 src/parser_bison.y | 20 ++++++++++++--------
 src/scanner.l      | 36 +++++++++++++++++++++++++-----------
 3 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 7283a6e065289..30ddef0326fae 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -48,10 +48,14 @@ enum startcond_type {
 	PARSER_SC_EXPR_AH,
 	PARSER_SC_EXPR_COMP,
 	PARSER_SC_EXPR_DCCP,
+	PARSER_SC_EXPR_DST,
 	PARSER_SC_EXPR_ESP,
 	PARSER_SC_EXPR_FIB,
+	PARSER_SC_EXPR_FRAG,
 	PARSER_SC_EXPR_HASH,
+	PARSER_SC_EXPR_HBH,
 	PARSER_SC_EXPR_IPSEC,
+	PARSER_SC_EXPR_MH,
 	PARSER_SC_EXPR_NUMGEN,
 	PARSER_SC_EXPR_OSF,
 	PARSER_SC_EXPR_QUEUE,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 71530591d3994..eb4ac1a603206 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -932,10 +932,13 @@ close_scope_comp	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_COMP);
 close_scope_ct		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CT); };
 close_scope_counter	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_COUNTER); };
 close_scope_dccp	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_DCCP); };
+close_scope_dst		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_DST); };
 close_scope_esp		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_ESP); };
 close_scope_eth		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_ETH); };
 close_scope_fib		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_FIB); };
+close_scope_frag	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_FRAG); };
 close_scope_hash	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_HASH); };
+close_scope_hbh		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_HBH); };
 close_scope_ip		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_IP); };
 close_scope_ip6		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_IP6); };
 close_scope_vlan	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_VLAN); };
@@ -944,6 +947,7 @@ close_scope_igmp	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_IGMP); };
 close_scope_ipsec	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_IPSEC); };
 close_scope_list	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CMD_LIST); };
 close_scope_limit	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_LIMIT); };
+close_scope_mh		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_MH); };
 close_scope_numgen	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_NUMGEN); };
 close_scope_osf		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_OSF); };
 close_scope_quota	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_QUOTA); };
@@ -5765,7 +5769,7 @@ exthdr_expr		:	hbh_hdr_expr
 			|	mh_hdr_expr
 			;
 
-hbh_hdr_expr		:	HBH	hbh_hdr_field
+hbh_hdr_expr		:	HBH	hbh_hdr_field	close_scope_hbh
 			{
 				$$ = exthdr_expr_alloc(&@$, &exthdr_hbh, $2);
 			}
@@ -5823,7 +5827,7 @@ rt4_hdr_field		:	LAST_ENT	{ $$ = RT4HDR_LASTENT; }
 			}
 			;
 
-frag_hdr_expr		:	FRAG	frag_hdr_field
+frag_hdr_expr		:	FRAG	frag_hdr_field	close_scope_frag
 			{
 				$$ = exthdr_expr_alloc(&@$, &exthdr_frag, $2);
 			}
@@ -5837,7 +5841,7 @@ frag_hdr_field		:	NEXTHDR		{ $$ = FRAGHDR_NEXTHDR; }
 			|	ID		{ $$ = FRAGHDR_ID; }
 			;
 
-dst_hdr_expr		:	DST	dst_hdr_field
+dst_hdr_expr		:	DST	dst_hdr_field	close_scope_dst
 			{
 				$$ = exthdr_expr_alloc(&@$, &exthdr_dst, $2);
 			}
@@ -5847,7 +5851,7 @@ dst_hdr_field		:	NEXTHDR		{ $$ = DSTHDR_NEXTHDR; }
 			|	HDRLENGTH	{ $$ = DSTHDR_HDRLENGTH; }
 			;
 
-mh_hdr_expr		:	MH	mh_hdr_field
+mh_hdr_expr		:	MH	mh_hdr_field	close_scope_mh
 			{
 				$$ = exthdr_expr_alloc(&@$, &exthdr_mh, $2);
 			}
@@ -5874,11 +5878,11 @@ exthdr_exists_expr	:	EXTHDR	exthdr_key
 			}
 			;
 
-exthdr_key		:	HBH	{ $$ = IPPROTO_HOPOPTS; }
+exthdr_key		:	HBH	close_scope_hbh	{ $$ = IPPROTO_HOPOPTS; }
 			|	RT	close_scope_rt	{ $$ = IPPROTO_ROUTING; }
-			|	FRAG	{ $$ = IPPROTO_FRAGMENT; }
-			|	DST	{ $$ = IPPROTO_DSTOPTS; }
-			|	MH	{ $$ = IPPROTO_MH; }
+			|	FRAG	close_scope_frag	{ $$ = IPPROTO_FRAGMENT; }
+			|	DST	close_scope_dst	{ $$ = IPPROTO_DSTOPTS; }
+			|	MH	close_scope_mh	{ $$ = IPPROTO_MH; }
 			;
 
 %%
diff --git a/src/scanner.l b/src/scanner.l
index 7c4d8b7f904c4..e632d825f9ed8 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -214,10 +214,14 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_EXPR_AH
 %s SCANSTATE_EXPR_COMP
 %s SCANSTATE_EXPR_DCCP
+%s SCANSTATE_EXPR_DST
 %s SCANSTATE_EXPR_ESP
 %s SCANSTATE_EXPR_FIB
+%s SCANSTATE_EXPR_FRAG
 %s SCANSTATE_EXPR_HASH
+%s SCANSTATE_EXPR_HBH
 %s SCANSTATE_EXPR_IPSEC
+%s SCANSTATE_EXPR_MH
 %s SCANSTATE_EXPR_NUMGEN
 %s SCANSTATE_EXPR_OSF
 %s SCANSTATE_EXPR_QUEUE
@@ -440,7 +444,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "typeof"		{ return TYPEOF; }
 
 "vlan"			{ scanner_push_start_cond(yyscanner, SCANSTATE_VLAN); return VLAN; }
-"id"			{ return ID; }
+<SCANSTATE_CT,SCANSTATE_EXPR_FRAG,SCANSTATE_VLAN,SCANSTATE_IP,SCANSTATE_ICMP>"id"			{ return ID; }
 <SCANSTATE_VLAN>{
 	"cfi"		{ return CFI; }
 	"dei"		{ return DEI; }
@@ -462,16 +466,22 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 <SCANSTATE_IP,SCANSTATE_IP6,SCANSTATE_EXPR_OSF>{
 	"version"		{ return HDRVERSION; }
 }
-"hdrlength"		{ return HDRLENGTH; }
+<SCANSTATE_EXPR_AH,SCANSTATE_EXPR_DST,SCANSTATE_EXPR_HBH,SCANSTATE_EXPR_MH,SCANSTATE_EXPR_RT,SCANSTATE_IP>{
+	"hdrlength"		{ return HDRLENGTH; }
+}
 "dscp"			{ return DSCP; }
 "ecn"			{ return ECN; }
 "length"		{ return LENGTH; }
-"frag-off"		{ return FRAG_OFF; }
+<SCANSTATE_EXPR_FRAG,SCANSTATE_IP>{
+	"frag-off"		{ return FRAG_OFF; }
+}
 <SCANSTATE_EXPR_OSF,SCANSTATE_IP>{
 	"ttl"			{ return TTL; }
 }
 "protocol"		{ return PROTOCOL; }
-"checksum"		{ return CHECKSUM; }
+<SCANSTATE_EXPR_MH,SCANSTATE_EXPR_UDP,SCANSTATE_EXPR_UDPLITE,SCANSTATE_ICMP,SCANSTATE_IGMP,SCANSTATE_IP,SCANSTATE_SCTP,SCANSTATE_TCP>{
+	"checksum"		{ return CHECKSUM; }
+}
 
 <SCANSTATE_IP>{
 	"lsrr"			{ return LSRR; }
@@ -553,7 +563,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "nexthdr"		{ return NEXTHDR; }
 
 "ah"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_AH); return AH; }
-"reserved"		{ return RESERVED; }
+<SCANSTATE_EXPR_AH,SCANSTATE_EXPR_FRAG,SCANSTATE_EXPR_MH,SCANSTATE_TCP>{
+	"reserved"		{ return RESERVED; }
+}
 <SCANSTATE_EXPR_AH,SCANSTATE_EXPR_ESP,SCANSTATE_EXPR_IPSEC>"spi"			{ return SPI; }
 
 "esp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_ESP); return ESP; }
@@ -634,15 +646,17 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "tag"			{ return TAG; }
 "sid"			{ return SID; }
 
-"hbh"			{ return HBH; }
+"hbh"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_HBH); return HBH; }
 
-"frag"			{ return FRAG; }
-"reserved2"		{ return RESERVED2; }
-"more-fragments"	{ return MORE_FRAGMENTS; }
+"frag"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_FRAG); return FRAG; }
+<SCANSTATE_EXPR_FRAG>{
+	"reserved2"		{ return RESERVED2; }
+	"more-fragments"	{ return MORE_FRAGMENTS; }
+}
 
-"dst"			{ return DST; }
+"dst"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_DST); return DST; }
 
-"mh"			{ return MH; }
+"mh"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_MH); return MH; }
 
 "meta"			{ return META; }
 "mark"			{ return MARK; }
-- 
2.34.1

