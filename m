Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED4BC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Feb 2022 13:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237789AbiBSN27 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 08:28:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234934AbiBSN27 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 08:28:59 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3101011
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 05:28:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wDon2AXzQCT0UJdisSETDmkgImkLncQSxDDGjqMpbX4=; b=Hmpbp/iYWtUjtFTeSb1Wdfgk4g
        e6LvGyHIHBUVzZAxaudcDJyWyVFt49+vO+BBOTC4p/Hp7SXoVX9L6y6GQiXp2o4RckuG7MQdjzHWn
        cPLfjZgdAbGdgBg9XTS3j69Kn/mWjLIzAh8JX9i4t/wfMoYdLFNAaeRnLz0mPmZgW6LM/ZrCadI9I
        kKFY2eXca8X4pPEnOWvo+udntsslklpILYs+2FYaTRS5rEApG/zkR2kH/eMe/4XiwwpFwfhlHaMT8
        z21QGlHfA+AVZKVro1dyjDV1jgMRPO9zV4+0EVRwGdoDSpQo0qXr09VT/4AYrAyz8FhH1gE6DXeaU
        8d6kOhYw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nLPmw-0002WQ-Lu; Sat, 19 Feb 2022 14:28:38 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 13/26] scanner: ah, esp: Move to own scopes
Date:   Sat, 19 Feb 2022 14:28:01 +0100
Message-Id: <20220219132814.30823-14-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220219132814.30823-1-phil@nwl.cc>
References: <20220219132814.30823-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

They share 'sequence' keyword with icmp and tcp expressions.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/parser.h   |  2 ++
 src/parser_bison.y | 10 ++++++----
 src/scanner.l      | 12 ++++++++----
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 82402dbc54a70..7283a6e065289 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -45,8 +45,10 @@ enum startcond_type {
 	PARSER_SC_TCP,
 	PARSER_SC_VLAN,
 	PARSER_SC_CMD_LIST,
+	PARSER_SC_EXPR_AH,
 	PARSER_SC_EXPR_COMP,
 	PARSER_SC_EXPR_DCCP,
+	PARSER_SC_EXPR_ESP,
 	PARSER_SC_EXPR_FIB,
 	PARSER_SC_EXPR_HASH,
 	PARSER_SC_EXPR_IPSEC,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 2deee99394999..71530591d3994 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -926,11 +926,13 @@ opt_newline		:	NEWLINE
 		 	|	/* empty */
 			;
 
+close_scope_ah		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_AH); };
 close_scope_arp		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_ARP); };
 close_scope_comp	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_COMP); };
 close_scope_ct		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CT); };
 close_scope_counter	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_COUNTER); };
 close_scope_dccp	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_DCCP); };
+close_scope_esp		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_ESP); };
 close_scope_eth		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_ETH); };
 close_scope_fib		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_FIB); };
 close_scope_hash	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_HASH); };
@@ -4784,14 +4786,14 @@ primary_rhs_expr	:	symbol_expr		{ $$ = $1; }
 							 BYTEORDER_HOST_ENDIAN,
 							 sizeof(data) * BITS_PER_BYTE, &data);
 			}
-			|	ESP
+			|	ESP	close_scope_esp
 			{
 				uint8_t data = IPPROTO_ESP;
 				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
 							 BYTEORDER_HOST_ENDIAN,
 							 sizeof(data) * BITS_PER_BYTE, &data);
 			}
-			|	AH
+			|	AH	close_scope_ah
 			{
 				uint8_t data = IPPROTO_AH;
 				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
@@ -5447,7 +5449,7 @@ icmp6_hdr_field		:	TYPE		{ $$ = ICMP6HDR_TYPE; }
 			|	MAXDELAY	{ $$ = ICMP6HDR_MAXDELAY; }
 			;
 
-auth_hdr_expr		:	AH	auth_hdr_field
+auth_hdr_expr		:	AH	auth_hdr_field	close_scope_ah
 			{
 				$$ = payload_expr_alloc(&@$, &proto_ah, $2);
 			}
@@ -5460,7 +5462,7 @@ auth_hdr_field		:	NEXTHDR		{ $$ = AHHDR_NEXTHDR; }
 			|	SEQUENCE	{ $$ = AHHDR_SEQUENCE; }
 			;
 
-esp_hdr_expr		:	ESP	esp_hdr_field
+esp_hdr_expr		:	ESP	esp_hdr_field	close_scope_esp
 			{
 				$$ = payload_expr_alloc(&@$, &proto_esp, $2);
 			}
diff --git a/src/scanner.l b/src/scanner.l
index 65640ebbf40eb..7c4d8b7f904c4 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -211,8 +211,10 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_TCP
 %s SCANSTATE_VLAN
 %s SCANSTATE_CMD_LIST
+%s SCANSTATE_EXPR_AH
 %s SCANSTATE_EXPR_COMP
 %s SCANSTATE_EXPR_DCCP
+%s SCANSTATE_EXPR_ESP
 %s SCANSTATE_EXPR_FIB
 %s SCANSTATE_EXPR_HASH
 %s SCANSTATE_EXPR_IPSEC
@@ -532,7 +534,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"max-delay"		{ return MAXDELAY; }
 	"mtu"			{ return MTU; }
 }
-"sequence"		{ return SEQUENCE; }
+<SCANSTATE_EXPR_AH,SCANSTATE_EXPR_ESP,SCANSTATE_ICMP,SCANSTATE_TCP>{
+	"sequence"		{ return SEQUENCE; }
+}
 
 "igmp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_IGMP); return IGMP; }
 <SCANSTATE_IGMP>{
@@ -548,11 +552,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 }
 "nexthdr"		{ return NEXTHDR; }
 
-"ah"			{ return AH; }
+"ah"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_AH); return AH; }
 "reserved"		{ return RESERVED; }
-"spi"			{ return SPI; }
+<SCANSTATE_EXPR_AH,SCANSTATE_EXPR_ESP,SCANSTATE_EXPR_IPSEC>"spi"			{ return SPI; }
 
-"esp"			{ return ESP; }
+"esp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_ESP); return ESP; }
 
 "comp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_COMP); return COMP; }
 <SCANSTATE_EXPR_COMP>{
-- 
2.34.1

