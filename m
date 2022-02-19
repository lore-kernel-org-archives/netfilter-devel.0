Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0BEEC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Feb 2022 13:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235681AbiBSN2o (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 08:28:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234934AbiBSN2n (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 08:28:43 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF6C1011
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 05:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XaDaCSpAid+vQ5X1EsebL4Kx7ouHm76fZBLu5mzTiw0=; b=GgXaYU+QPPat67bQ7ofWGDHb1a
        ++UFeZz99q4EuBNEUC5S9+vtIrTskEz1ldUadOpzjn5ic00ztYckeBt4JjQQqC3oXcYKsP1/Cvjn0
        Cnw5UIH6AM4dzfGHDd3bjxcorcJE1jVIvXLVMeBgo3PTkgxNZ2E4exrS1rk6G9JVmKdMSS3+3xS9w
        KehOQxL5PciQNgAOg43/UpUtiWGIAbrxNCBtepcf23ijx3ZlW2cOGVM42jJNouLSMWP/Bkyk2I83P
        63Zg61FUFeZ0wy1G/WgcjG/7q+jBs4vKQtT1iS66EIixdq17nKjzcp7DMJl9fFY8EkPZV9FugjAzK
        TfLcz2BA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nLPmg-0002VU-Ni; Sat, 19 Feb 2022 14:28:22 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 11/26] scanner: dccp, th: Move to own scopes
Date:   Sat, 19 Feb 2022 14:27:59 +0100
Message-Id: <20220219132814.30823-12-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220219132814.30823-1-phil@nwl.cc>
References: <20220219132814.30823-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With them in place, heavily shared keywords 'sport' and 'dport' may be
isolated.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/parser.h   |  2 ++
 src/parser_bison.y | 10 ++++++----
 src/scanner.l      | 14 ++++++++++----
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index e80a7753ea715..ab372ad0bae88 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -46,6 +46,7 @@ enum startcond_type {
 	PARSER_SC_VLAN,
 	PARSER_SC_CMD_LIST,
 	PARSER_SC_EXPR_COMP,
+	PARSER_SC_EXPR_DCCP,
 	PARSER_SC_EXPR_FIB,
 	PARSER_SC_EXPR_HASH,
 	PARSER_SC_EXPR_IPSEC,
@@ -54,6 +55,7 @@ enum startcond_type {
 	PARSER_SC_EXPR_RT,
 	PARSER_SC_EXPR_SCTP_CHUNK,
 	PARSER_SC_EXPR_SOCKET,
+	PARSER_SC_EXPR_TH,
 	PARSER_SC_EXPR_UDP,
 	PARSER_SC_EXPR_UDPLITE,
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 39789b30f41ab..adfaa460caf36 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -930,6 +930,7 @@ close_scope_arp		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_ARP); };
 close_scope_comp	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_COMP); };
 close_scope_ct		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CT); };
 close_scope_counter	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_COUNTER); };
+close_scope_dccp	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_DCCP); };
 close_scope_eth		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_ETH); };
 close_scope_fib		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_FIB); };
 close_scope_hash	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_HASH); };
@@ -950,6 +951,7 @@ close_scope_sctp_chunk	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_S
 close_scope_secmark	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_SECMARK); };
 close_scope_socket	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_SOCKET); }
 close_scope_tcp		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_TCP); };
+close_scope_th		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_TH); };
 close_scope_udp		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_UDP); };
 close_scope_udplite	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_UDPLITE); };
 
@@ -4823,7 +4825,7 @@ primary_rhs_expr	:	symbol_expr		{ $$ = $1; }
 							 BYTEORDER_HOST_ENDIAN,
 							 sizeof(data) * BITS_PER_BYTE, &data);
 			}
-			|	DCCP
+			|	DCCP	close_scope_dccp
 			{
 				uint8_t data = IPPROTO_DCCP;
 				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
@@ -5284,7 +5286,7 @@ payload_raw_expr	:	AT	payload_base_spec	COMMA	NUM	COMMA	NUM
 
 payload_base_spec	:	LL_HDR		{ $$ = PROTO_BASE_LL_HDR; }
 			|	NETWORK_HDR	{ $$ = PROTO_BASE_NETWORK_HDR; }
-			|	TRANSPORT_HDR	{ $$ = PROTO_BASE_TRANSPORT_HDR; }
+			|	TRANSPORT_HDR	close_scope_th	{ $$ = PROTO_BASE_TRANSPORT_HDR; }
 			|	STRING
 			{
 				if (!strcmp($1, "ih")) {
@@ -5610,7 +5612,7 @@ tcpopt_field_maxseg	:	SIZE		{ $$ = TCPOPT_MAXSEG_SIZE; }
 tcpopt_field_mptcp	:	SUBTYPE		{ $$ = TCPOPT_MPTCP_SUBTYPE; }
 			;
 
-dccp_hdr_expr		:	DCCP	dccp_hdr_field
+dccp_hdr_expr		:	DCCP	dccp_hdr_field	close_scope_dccp
 			{
 				$$ = payload_expr_alloc(&@$, &proto_dccp, $2);
 			}
@@ -5738,7 +5740,7 @@ sctp_hdr_field		:	SPORT		{ $$ = SCTPHDR_SPORT; }
 			|	CHECKSUM	{ $$ = SCTPHDR_CHECKSUM; }
 			;
 
-th_hdr_expr		:	TRANSPORT_HDR 	th_hdr_field
+th_hdr_expr		:	TRANSPORT_HDR	th_hdr_field	close_scope_th
 			{
 				$$ = payload_expr_alloc(&@$, &proto_th, $2);
 				if ($$)
diff --git a/src/scanner.l b/src/scanner.l
index d6fb91bd102b2..ed26811c5d906 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -212,6 +212,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_VLAN
 %s SCANSTATE_CMD_LIST
 %s SCANSTATE_EXPR_COMP
+%s SCANSTATE_EXPR_DCCP
 %s SCANSTATE_EXPR_FIB
 %s SCANSTATE_EXPR_HASH
 %s SCANSTATE_EXPR_IPSEC
@@ -220,6 +221,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_EXPR_RT
 %s SCANSTATE_EXPR_SCTP_CHUNK
 %s SCANSTATE_EXPR_SOCKET
+%s SCANSTATE_EXPR_TH
 %s SCANSTATE_EXPR_UDP
 %s SCANSTATE_EXPR_UDPLITE
 
@@ -422,7 +424,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "ll"			{ return LL_HDR; }
 "nh"			{ return NETWORK_HDR; }
-"th"			{ return TRANSPORT_HDR; }
+"th"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_TH); return TRANSPORT_HDR; }
 
 "bridge"		{ return BRIDGE; }
 
@@ -558,13 +560,17 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 <SCANSTATE_EXPR_UDPLITE>{
 	"csumcov"	{ return CSUMCOV; }
 }
-"sport"			{ return SPORT; }
-"dport"			{ return DPORT; }
+<SCANSTATE_EXPR_DCCP,SCANSTATE_SCTP,SCANSTATE_TCP,SCANSTATE_EXPR_TH,SCANSTATE_EXPR_UDP,SCANSTATE_EXPR_UDPLITE>{
+	"sport"			{ return SPORT; }
+}
+<SCANSTATE_CT,SCANSTATE_EXPR_DCCP,SCANSTATE_SCTP,SCANSTATE_TCP,SCANSTATE_EXPR_TH,SCANSTATE_EXPR_UDP,SCANSTATE_EXPR_UDPLITE>{
+	"dport"			{ return DPORT; }
+}
 "port"			{ return PORT; }
 
 "tcp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_TCP); return TCP; }
 
-"dccp"			{ return DCCP; }
+"dccp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_DCCP); return DCCP; }
 
 "sctp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_SCTP); return SCTP; }
 
-- 
2.34.1

