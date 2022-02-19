Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EB47C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Feb 2022 13:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238397AbiBSNaX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 08:30:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238175AbiBSNaX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 08:30:23 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF89A88B32
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 05:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EIESz+jYuXkXbEGjlbvGIN+K1xD54DEfl7lIzJGzqJQ=; b=Sko9sYaDmKEZYF5SDOyYu6e/dR
        bmN4dI5D2Zy+xzKeNXqH4tQAMIZ4E8tq0XMhrmYSknM9ypsoit/647GpZHnHJ4+RYSd2C7iuRBGxc
        OPGTzB84SVwlPLAdG56cts/mQnCOrbd3LXBNxj9kTJWmIKGMtHf6gC4UdUSoVnGvXXDbb7AWjwYyl
        yojOVyzsAgtK/5J1sWqWNvqlY3yUX4Uf1IglQrbUi8pRJWRyqY0WsLeEYpl6jcESQWvuLwAPmknFf
        bspcb9b2VpQMoLdzJFX0cnF3uNwsxM4FcUsO3yngvEFLpA05h2cQ8kB4pnxLoUcqPvKD7h67jmXM4
        /jYPQXdw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nLPoI-0002ca-2E; Sat, 19 Feb 2022 14:30:02 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 24/26] scanner: at: Move to own scope
Date:   Sat, 19 Feb 2022 14:28:12 +0100
Message-Id: <20220219132814.30823-25-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220219132814.30823-1-phil@nwl.cc>
References: <20220219132814.30823-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Modification of raw TCP option rule is a bit more complicated to avoid
pushing tcp_hdr_option_type into the introduced scope by accident.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/parser.h   |  1 +
 src/parser_bison.y | 15 ++++++++-------
 src/scanner.l      |  9 ++++++---
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 0ff0ecfbad9ac..0dcc30be64780 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -31,6 +31,7 @@ struct parser_state {
 enum startcond_type {
 	PARSER_SC_BEGIN,
 	PARSER_SC_ARP,
+	PARSER_SC_AT,
 	PARSER_SC_CT,
 	PARSER_SC_COUNTER,
 	PARSER_SC_ETH,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 679579fc75742..c6f5d4947356c 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -928,6 +928,7 @@ opt_newline		:	NEWLINE
 
 close_scope_ah		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_AH); };
 close_scope_arp		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_ARP); };
+close_scope_at		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_AT); };
 close_scope_comp	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_COMP); };
 close_scope_ct		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CT); };
 close_scope_counter	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_COUNTER); };
@@ -4041,7 +4042,7 @@ set_ref_expr		:	set_ref_symbol_expr
 			|	variable_expr
 			;
 
-set_ref_symbol_expr	:	AT	identifier
+set_ref_symbol_expr	:	AT	identifier	close_scope_at
 			{
 				$$ = symbol_expr_alloc(&@$, SYMBOL_SET,
 						       current_scope(state),
@@ -5014,11 +5015,11 @@ meta_stmt		:	META	meta_key	SET	stmt_expr
 			{
 				$$ = notrack_stmt_alloc(&@$);
 			}
-			|	FLOW	OFFLOAD	AT string
+			|	FLOW	OFFLOAD	AT string	close_scope_at
 			{
 				$$ = flow_offload_stmt_alloc(&@$, $4);
 			}
-			|	FLOW	ADD	AT string
+			|	FLOW	ADD	AT string	close_scope_at
 			{
 				$$ = flow_offload_stmt_alloc(&@$, $4);
 			}
@@ -5291,7 +5292,7 @@ payload_expr		:	payload_raw_expr
 			|	th_hdr_expr
 			;
 
-payload_raw_expr	:	AT	payload_base_spec	COMMA	NUM	COMMA	NUM
+payload_raw_expr	:	AT	payload_base_spec	COMMA	NUM	COMMA	NUM	close_scope_at
 			{
 				$$ = payload_expr_alloc(&@$, NULL, 0);
 				payload_init_raw($$, $2, $4, $6);
@@ -5533,10 +5534,10 @@ tcp_hdr_expr		:	TCP	tcp_hdr_field
 			{
 				$$ = tcpopt_expr_alloc(&@$, $3.kind, $3.field);
 			}
-			|	TCP	OPTION	AT tcp_hdr_option_type	COMMA	NUM	COMMA	NUM
+			|	TCP	OPTION	AT	close_scope_at	tcp_hdr_option_type	COMMA	NUM	COMMA	NUM
 			{
-				$$ = tcpopt_expr_alloc(&@$, $4, 0);
-				tcpopt_init_raw($$, $4, $6, $8, 0);
+				$$ = tcpopt_expr_alloc(&@$, $5, 0);
+				tcpopt_init_raw($$, $5, $7, $9, 0);
 			}
 			;
 
diff --git a/src/scanner.l b/src/scanner.l
index 078bcc7084eba..8d4907dc1fdfe 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -197,6 +197,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %option warn
 %option stack
 %s SCANSTATE_ARP
+%s SCANSTATE_AT
 %s SCANSTATE_CT
 %s SCANSTATE_COUNTER
 %s SCANSTATE_ETH
@@ -283,7 +284,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "/"			{ return SLASH; }
 "-"			{ return DASH; }
 "*"			{ return ASTERISK; }
-"@"			{ return AT; }
+"@"			{ scanner_push_start_cond(yyscanner, SCANSTATE_AT); return AT; }
 "$"			{ return '$'; }
 "="			{ return '='; }
 "vmap"			{ return VMAP; }
@@ -456,8 +457,10 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"port"			{ return PORT; }
 }
 
-"ll"			{ return LL_HDR; }
-"nh"			{ return NETWORK_HDR; }
+<SCANSTATE_AT>{
+	"ll"			{ return LL_HDR; }
+	"nh"			{ return NETWORK_HDR; }
+}
 "th"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_TH); return TRANSPORT_HDR; }
 
 "bridge"		{ return BRIDGE; }
-- 
2.34.1

