Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 992D3C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Feb 2022 13:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239776AbiBSN3Q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 08:29:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234934AbiBSN3P (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 08:29:15 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A644A5714B
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 05:28:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uL6g0h9gi7vYSSim405/82f0Dxlpsb6ss6zduLBlqR8=; b=i75RwShghnyvHyNUq+tBYFF63K
        cWUhfYow/PCs89c6je4Gsu/WW+DcKPupKzl4xKZWc8HtwZZLBadUHMfpIdGD1fG3hBwv+I7VRsiS/
        4C6mKTDCQJuoK5mZ2AB8szxfG+It0RS/h6J0OMgK1falshIL5n/WgBg7A/rVfgMZCgT4xHoVKWx66
        49UByz7sUSahENGupWwBoomWJpJMokKz29814uLYe/50atEIr0xXZlMtzfQ2WjLBIRtkYJIWxX6S4
        nTFuPSuEuS7vC/MbNzxZAASf2vR1dDS56JYOmjSqD5xVE6ZiWVF+p4gORuNzpV/KLsRbxqYJGHDzh
        uGGtA+6Q==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nLPnC-0002XK-WF; Sat, 19 Feb 2022 14:28:55 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 23/26] scanner: nat: Move to own scope
Date:   Sat, 19 Feb 2022 14:28:11 +0100
Message-Id: <20220219132814.30823-24-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220219132814.30823-1-phil@nwl.cc>
References: <20220219132814.30823-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Unify nat, masquerade and redirect statements, they widely share their
syntax.

Note the workaround of adding "prefix" to SCANSTATE_IP. This is required
to fix for 'snat ip prefix ...' style expressions.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/parser.h   |  1 +
 src/parser_bison.y | 13 +++++++------
 src/scanner.l      | 21 ++++++++++++---------
 3 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 79eadc0d7e52f..0ff0ecfbad9ac 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -74,6 +74,7 @@ enum startcond_type {
 	PARSER_SC_EXPR_UDPLITE,
 
 	PARSER_SC_STMT_LOG,
+	PARSER_SC_STMT_NAT,
 	PARSER_SC_STMT_REJECT,
 	PARSER_SC_STMT_SYNPROXY,
 };
diff --git a/src/parser_bison.y b/src/parser_bison.y
index eca51617e1713..679579fc75742 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -952,6 +952,7 @@ close_scope_list	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CMD_LIST); }
 close_scope_limit	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_LIMIT); };
 close_scope_mh		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_MH); };
 close_scope_monitor	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CMD_MONITOR); };
+close_scope_nat		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_STMT_NAT); };
 close_scope_numgen	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_NUMGEN); };
 close_scope_osf		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_OSF); };
 close_scope_policy	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_POLICY); };
@@ -2839,12 +2840,12 @@ stmt			:	verdict_stmt
 			|	meta_stmt
 			|	log_stmt	close_scope_log
 			|	reject_stmt	close_scope_reject
-			|	nat_stmt
+			|	nat_stmt	close_scope_nat
 			|	tproxy_stmt
 			|	queue_stmt
 			|	ct_stmt
-			|	masq_stmt
-			|	redir_stmt
+			|	masq_stmt	close_scope_nat
+			|	redir_stmt	close_scope_nat
 			|	dup_stmt
 			|	fwd_stmt
 			|	set_stmt
@@ -4764,8 +4765,8 @@ keyword_expr		:	ETHER   close_scope_eth { $$ = symbol_value(&@$, "ether"); }
 			|	IP6	close_scope_ip6 { $$ = symbol_value(&@$, "ip6"); }
 			|	VLAN	close_scope_vlan { $$ = symbol_value(&@$, "vlan"); }
 			|	ARP	close_scope_arp { $$ = symbol_value(&@$, "arp"); }
-			|	DNAT			{ $$ = symbol_value(&@$, "dnat"); }
-			|	SNAT			{ $$ = symbol_value(&@$, "snat"); }
+			|	DNAT	close_scope_nat	{ $$ = symbol_value(&@$, "dnat"); }
+			|	SNAT	close_scope_nat	{ $$ = symbol_value(&@$, "snat"); }
 			|	ECN			{ $$ = symbol_value(&@$, "ecn"); }
 			|	RESET	close_scope_reset	{ $$ = symbol_value(&@$, "reset"); }
 			|	ORIGINAL		{ $$ = symbol_value(&@$, "original"); }
@@ -4854,7 +4855,7 @@ primary_rhs_expr	:	symbol_expr		{ $$ = $1; }
 							 BYTEORDER_HOST_ENDIAN,
 							 sizeof(data) * BITS_PER_BYTE, &data);
 			}
-			|	REDIRECT
+			|	REDIRECT	close_scope_nat
 			{
 				uint8_t data = ICMP_REDIRECT;
 				$$ = constant_expr_alloc(&@$, &icmp_type_type,
diff --git a/src/scanner.l b/src/scanner.l
index b885f84523b97..078bcc7084eba 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -240,6 +240,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_EXPR_UDPLITE
 
 %s SCANSTATE_STMT_LOG
+%s SCANSTATE_STMT_NAT
 %s SCANSTATE_STMT_REJECT
 %s SCANSTATE_STMT_SYNPROXY
 
@@ -403,7 +404,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 }
 
 "log"			{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_LOG); return LOG; }
-"prefix"		{ return PREFIX; }
+<SCANSTATE_STMT_LOG,SCANSTATE_STMT_NAT,SCANSTATE_IP>"prefix"		{ return PREFIX; }
 <SCANSTATE_STMT_LOG>{
 	"snaplen"		{ return SNAPLEN; }
 	"queue-threshold"	{ return QUEUE_THRESHOLD; }
@@ -444,13 +445,16 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"icmpx"			{ return ICMPX; }
 }
 
-"snat"			{ return SNAT; }
-"dnat"			{ return DNAT; }
-"masquerade"		{ return MASQUERADE; }
-"redirect"		{ return REDIRECT; }
+"snat"			{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_NAT); return SNAT; }
+"dnat"			{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_NAT); return DNAT; }
+"masquerade"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_NAT); return MASQUERADE; }
+"redirect"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_NAT); return REDIRECT; }
 "random"		{ return RANDOM; }
-"fully-random"		{ return FULLY_RANDOM; }
-"persistent"		{ return PERSISTENT; }
+<SCANSTATE_STMT_NAT>{
+	"fully-random"		{ return FULLY_RANDOM; }
+	"persistent"		{ return PERSISTENT; }
+	"port"			{ return PORT; }
+}
 
 "ll"			{ return LL_HDR; }
 "nh"			{ return NETWORK_HDR; }
@@ -614,7 +618,6 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 <SCANSTATE_CT,SCANSTATE_EXPR_DCCP,SCANSTATE_SCTP,SCANSTATE_TCP,SCANSTATE_EXPR_TH,SCANSTATE_EXPR_UDP,SCANSTATE_EXPR_UDPLITE>{
 	"dport"			{ return DPORT; }
 }
-"port"			{ return PORT; }
 
 "tcp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_TCP); return TCP; }
 
@@ -668,7 +671,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "rt0"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_RT); return RT0; }
 "rt2"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_RT); return RT2; }
 "srh"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_RT); return RT4; }
-"addr"			{ return ADDR; }
+<SCANSTATE_EXPR_RT,SCANSTATE_STMT_NAT>"addr"			{ return ADDR; }
 
 "hbh"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_HBH); return HBH; }
 
-- 
2.34.1

