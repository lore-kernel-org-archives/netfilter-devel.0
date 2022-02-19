Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D0AC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Feb 2022 13:29:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240255AbiBSNaM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 08:30:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238175AbiBSNaL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 08:30:11 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A6788B32
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 05:29:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=C6ANBZZTIGRON+3RKNNe56+sE+P2nD5nTK9HmRxJdS0=; b=J4/MYEaTqXbdh5pXCHWvVZEgVx
        1Jrw9AwGuEfz+WztnXgdiJbraCI1sD4n94euJu53daCfE56AF/euM+mSls3vmkDWj7Xl86YumpeJC
        +JvWCLrxKf3diWuYieYRjBrzkFjw+7JG5qq/D+sAO+cArNuExO4vBH8qdOxFi12Ofz92BUsShvzPA
        da98FzkmYJeGcwwdvNoXNAeWSXbGSpBW1uIYxCQyHjZTBFGXsovPh4eyTOoVT+H3JvKJVRzIasDjM
        jQxepaOTwWkYYRtectj59EbXbesxjlz/Kn8WjK8bjqpiq+KN+tEaHs1GqLLBmpBRepoJ9YHDBNuYC
        ZZ6fU4Iw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nLPo7-0002ax-CM; Sat, 19 Feb 2022 14:29:51 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 10/26] scanner: udp{,lite}: Move to own scope
Date:   Sat, 19 Feb 2022 14:27:58 +0100
Message-Id: <20220219132814.30823-11-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220219132814.30823-1-phil@nwl.cc>
References: <20220219132814.30823-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

All used keywords are shared with others, so no separation for now apart
from 'csumcov' which was actually missing from scanner.l.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/parser.h   |  2 ++
 src/parser_bison.y | 12 +++++++-----
 src/scanner.l      |  9 +++++++--
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index c16f210121040..e80a7753ea715 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -54,6 +54,8 @@ enum startcond_type {
 	PARSER_SC_EXPR_RT,
 	PARSER_SC_EXPR_SCTP_CHUNK,
 	PARSER_SC_EXPR_SOCKET,
+	PARSER_SC_EXPR_UDP,
+	PARSER_SC_EXPR_UDPLITE,
 
 	PARSER_SC_STMT_LOG,
 	PARSER_SC_STMT_SYNPROXY,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 7a02eaf88a58f..39789b30f41ab 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -950,6 +950,8 @@ close_scope_sctp_chunk	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_S
 close_scope_secmark	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_SECMARK); };
 close_scope_socket	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_SOCKET); }
 close_scope_tcp		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_TCP); };
+close_scope_udp		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_UDP); };
+close_scope_udplite	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_UDPLITE); };
 
 close_scope_log		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_STMT_LOG); }
 close_scope_synproxy	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_STMT_SYNPROXY); }
@@ -4485,7 +4487,7 @@ ct_cmd_type		:	HELPERS		{ $$ = CMD_OBJ_CT_HELPERS; }
 			;
 
 ct_l4protoname		:	TCP	close_scope_tcp	{ $$ = IPPROTO_TCP; }
-			|	UDP	{ $$ = IPPROTO_UDP; }
+			|	UDP	close_scope_udp	{ $$ = IPPROTO_UDP; }
 			;
 
 ct_helper_config		:	TYPE	QUOTED_STRING	PROTOCOL	ct_l4protoname	stmt_separator
@@ -4765,14 +4767,14 @@ primary_rhs_expr	:	symbol_expr		{ $$ = $1; }
 							 BYTEORDER_HOST_ENDIAN,
 							 sizeof(data) * BITS_PER_BYTE, &data);
 			}
-			|	UDP
+			|	UDP	close_scope_udp
 			{
 				uint8_t data = IPPROTO_UDP;
 				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
 							 BYTEORDER_HOST_ENDIAN,
 							 sizeof(data) * BITS_PER_BYTE, &data);
 			}
-			|	UDPLITE
+			|	UDPLITE	close_scope_udplite
 			{
 				uint8_t data = IPPROTO_UDPLITE;
 				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
@@ -5476,7 +5478,7 @@ comp_hdr_field		:	NEXTHDR		{ $$ = COMPHDR_NEXTHDR; }
 			|	CPI		{ $$ = COMPHDR_CPI; }
 			;
 
-udp_hdr_expr		:	UDP	udp_hdr_field
+udp_hdr_expr		:	UDP	udp_hdr_field	close_scope_udp
 			{
 				$$ = payload_expr_alloc(&@$, &proto_udp, $2);
 			}
@@ -5488,7 +5490,7 @@ udp_hdr_field		:	SPORT		{ $$ = UDPHDR_SPORT; }
 			|	CHECKSUM	{ $$ = UDPHDR_CHECKSUM; }
 			;
 
-udplite_hdr_expr	:	UDPLITE	udplite_hdr_field
+udplite_hdr_expr	:	UDPLITE	udplite_hdr_field	close_scope_udplite
 			{
 				$$ = payload_expr_alloc(&@$, &proto_udplite, $2);
 			}
diff --git a/src/scanner.l b/src/scanner.l
index a27df6c7e3915..d6fb91bd102b2 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -220,6 +220,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_EXPR_RT
 %s SCANSTATE_EXPR_SCTP_CHUNK
 %s SCANSTATE_EXPR_SOCKET
+%s SCANSTATE_EXPR_UDP
+%s SCANSTATE_EXPR_UDPLITE
 
 %s SCANSTATE_STMT_LOG
 %s SCANSTATE_STMT_SYNPROXY
@@ -551,8 +553,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 }
 "flags"			{ return FLAGS; }
 
-"udp"			{ return UDP; }
-"udplite"		{ return UDPLITE; }
+"udp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_UDP); return UDP; }
+"udplite"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_UDPLITE); return UDPLITE; }
+<SCANSTATE_EXPR_UDPLITE>{
+	"csumcov"	{ return CSUMCOV; }
+}
 "sport"			{ return SPORT; }
 "dport"			{ return DPORT; }
 "port"			{ return PORT; }
-- 
2.34.1

