Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CB81C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Feb 2022 13:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbiBSN33 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 08:29:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbiBSN32 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 08:29:28 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8996BDED
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 05:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qrQCj+miLXHejhNniQfXh0+NrBuSl/ENIRhqFj2z62E=; b=orJO6DxEXPEZcfEakTzLS14Mxz
        /1Ae5uCRb4BbXe6xl5c+7CtDjVz+AMjpbg4PZraAmLwjQIgKoMQtfqXUEHiSJGmHMwAUGbVvE/c99
        GG28Qnqk6wLRuZ02QaULAz5yDqx7N+3wt54qhdAYSQ+4ZILkZ98pi9kOWHXtyiEcZ4wuM5m5VH1mH
        e+d50zWmlBqpQo1XDnls7QB8H5Xhm0KCjdOW1irQ8mSHzNM8rAPJChDyE+O2d6hULcOeFIVmOBGVx
        8u1fxj5U2yJFlv/s3QivZ8anuNpUUBbbmXMmF7mRUoQXDf5LYxJpDszn1uMyBW2Q+YiLglrf4OCCh
        kVk6xu7A==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nLPnQ-0002Xr-2e; Sat, 19 Feb 2022 14:29:08 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 25/26] scanner: meta: Move to own scope
Date:   Sat, 19 Feb 2022 14:28:13 +0100
Message-Id: <20220219132814.30823-26-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220219132814.30823-1-phil@nwl.cc>
References: <20220219132814.30823-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This allows to isolate 'length' and 'protocol' keywords shared by other
scopes as well.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/parser.h   | 1 +
 src/parser_bison.y | 9 +++++----
 src/scanner.l      | 7 ++++---
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 0dcc30be64780..bc42229c1a83b 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -41,6 +41,7 @@ enum startcond_type {
 	PARSER_SC_IP,
 	PARSER_SC_IP6,
 	PARSER_SC_LIMIT,
+	PARSER_SC_META,
 	PARSER_SC_POLICY,
 	PARSER_SC_QUOTA,
 	PARSER_SC_SCTP,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index c6f5d4947356c..cd6f22ef8e915 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -951,6 +951,7 @@ close_scope_import	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CMD_IMPORT
 close_scope_ipsec	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_IPSEC); };
 close_scope_list	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CMD_LIST); };
 close_scope_limit	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_LIMIT); };
+close_scope_meta	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_META); };
 close_scope_mh		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_MH); };
 close_scope_monitor	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CMD_MONITOR); };
 close_scope_nat		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_STMT_NAT); };
@@ -4912,7 +4913,7 @@ chain_expr		:	variable_expr
 			}
 			;
 
-meta_expr		:	META	meta_key
+meta_expr		:	META	meta_key	close_scope_meta
 			{
 				$$ = meta_expr_alloc(&@$, $2);
 			}
@@ -4920,7 +4921,7 @@ meta_expr		:	META	meta_key
 			{
 				$$ = meta_expr_alloc(&@$, $1);
 			}
-			|	META	STRING
+			|	META	STRING	close_scope_meta
 			{
 				struct error_record *erec;
 				unsigned int key;
@@ -4973,7 +4974,7 @@ meta_key_unqualified	:	MARK		{ $$ = NFT_META_MARK; }
 			|       HOUR		{ $$ = NFT_META_TIME_HOUR; }
 			;
 
-meta_stmt		:	META	meta_key	SET	stmt_expr
+meta_stmt		:	META	meta_key	SET	stmt_expr	close_scope_meta
 			{
 				switch ($2) {
 				case NFT_META_SECMARK:
@@ -4997,7 +4998,7 @@ meta_stmt		:	META	meta_key	SET	stmt_expr
 			{
 				$$ = meta_stmt_alloc(&@$, $1, $3);
 			}
-			|	META	STRING	SET	stmt_expr
+			|	META	STRING	SET	stmt_expr	close_scope_meta
 			{
 				struct error_record *erec;
 				unsigned int key;
diff --git a/src/scanner.l b/src/scanner.l
index 8d4907dc1fdfe..be01c6f3b3bc6 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -207,6 +207,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_IP
 %s SCANSTATE_IP6
 %s SCANSTATE_LIMIT
+%s SCANSTATE_META
 %s SCANSTATE_POLICY
 %s SCANSTATE_QUOTA
 %s SCANSTATE_SCTP
@@ -503,14 +504,14 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"dscp"			{ return DSCP; }
 }
 "ecn"			{ return ECN; }
-"length"		{ return LENGTH; }
+<SCANSTATE_EXPR_UDP,SCANSTATE_IP,SCANSTATE_IP6,SCANSTATE_META,SCANSTATE_TCP,SCANSTATE_SCTP,SCANSTATE_EXPR_SCTP_CHUNK>"length"		{ return LENGTH; }
 <SCANSTATE_EXPR_FRAG,SCANSTATE_IP>{
 	"frag-off"		{ return FRAG_OFF; }
 }
 <SCANSTATE_EXPR_OSF,SCANSTATE_IP>{
 	"ttl"			{ return TTL; }
 }
-"protocol"		{ return PROTOCOL; }
+<SCANSTATE_CT,SCANSTATE_IP,SCANSTATE_META,SCANSTATE_TYPE>"protocol"		{ return PROTOCOL; }
 <SCANSTATE_EXPR_MH,SCANSTATE_EXPR_UDP,SCANSTATE_EXPR_UDPLITE,SCANSTATE_ICMP,SCANSTATE_IGMP,SCANSTATE_IP,SCANSTATE_SCTP,SCANSTATE_TCP>{
 	"checksum"		{ return CHECKSUM; }
 }
@@ -688,7 +689,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "mh"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_MH); return MH; }
 
-"meta"			{ return META; }
+"meta"			{ scanner_push_start_cond(yyscanner, SCANSTATE_META); return META; }
 "mark"			{ return MARK; }
 "iif"			{ return IIF; }
 "iifname"		{ return IIFNAME; }
-- 
2.34.1

