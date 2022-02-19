Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FE75C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Feb 2022 13:29:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234261AbiBSNaB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 08:30:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238414AbiBSNaB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 08:30:01 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5181385941
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 05:29:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1exHof7VHRjg/CdGcqJNgLQIznkWANtVJmcKnn8LbC0=; b=SQFiH1ZAyR0i2FFC6h+h7UpwUj
        irPJ9r/SPAyp1JkjQsdDM2tPtfln3Emy3TzlLy0LLOFPVFqt666xFMnjwNLcqQbJA7a0MhI4XNuMj
        PqS6R+1zoYPoVvS6PbmTO+Ggw8sLxZB349lJZDaMvHCqcxGOPQg401UDWN2j9HhXwhowod60gWjSV
        wk73jcnAgXkT2ekAPnb3E2KQEhTnrlzsdRxMkJ+ZenzDFt9LY1FVS2Cy9Q7as3NFZ96EimB6JOkcB
        qIQpu+eUfoueuBNwMeXYtHiIUmg69jx4ZXAO8STek9Ve7x3i0mK9UMXkr99DTjkpu45SKlbgAdFSf
        gJ8q8oKg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nLPnw-0002aF-Nm; Sat, 19 Feb 2022 14:29:40 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 18/26] scanner: reset: move to own Scope
Date:   Sat, 19 Feb 2022 14:28:06 +0100
Message-Id: <20220219132814.30823-19-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220219132814.30823-1-phil@nwl.cc>
References: <20220219132814.30823-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Isolate two more keywords shared with list command.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/parser.h   | 1 +
 src/parser_bison.y | 7 ++++---
 src/scanner.l      | 9 ++++++---
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 09499f08119bf..0601b410a8458 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -47,6 +47,7 @@ enum startcond_type {
 	PARSER_SC_VLAN,
 	PARSER_SC_CMD_LIST,
 	PARSER_SC_CMD_MONITOR,
+	PARSER_SC_CMD_RESET,
 	PARSER_SC_EXPR_AH,
 	PARSER_SC_EXPR_COMP,
 	PARSER_SC_EXPR_DCCP,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 6965872a760f1..99b52cf41d25d 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -953,6 +953,7 @@ close_scope_numgen	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_NUMGE
 close_scope_osf		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_OSF); };
 close_scope_quota	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_QUOTA); };
 close_scope_queue	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_QUEUE); };
+close_scope_reset	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CMD_RESET); };
 close_scope_rt		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_RT); };
 close_scope_sctp	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_SCTP); };
 close_scope_sctp_chunk	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_SCTP_CHUNK); };
@@ -1048,7 +1049,7 @@ base_cmd		:	/* empty */	add_cmd		{ $$ = $1; }
 			|	DELETE		delete_cmd	{ $$ = $2; }
 			|	GET		get_cmd		{ $$ = $2; }
 			|	LIST		list_cmd	close_scope_list	{ $$ = $2; }
-			|	RESET		reset_cmd	{ $$ = $2; }
+			|	RESET		reset_cmd	close_scope_reset	{ $$ = $2; }
 			|	FLUSH		flush_cmd	{ $$ = $2; }
 			|	RENAME		rename_cmd	{ $$ = $2; }
 			|       IMPORT          import_cmd      { $$ = $2; }
@@ -3397,7 +3398,7 @@ reject_opts		:       /* empty */
 				$<stmt>0->reject.expr = $3;
 				datatype_set($<stmt>0->reject.expr, &icmpx_code_type);
 			}
-			|	WITH	TCP	close_scope_tcp RESET
+			|	WITH	TCP	close_scope_tcp RESET close_scope_reset
 			{
 				$<stmt>0->reject.type = NFT_REJECT_TCP_RST;
 			}
@@ -4761,7 +4762,7 @@ keyword_expr		:	ETHER   close_scope_eth { $$ = symbol_value(&@$, "ether"); }
 			|	DNAT			{ $$ = symbol_value(&@$, "dnat"); }
 			|	SNAT			{ $$ = symbol_value(&@$, "snat"); }
 			|	ECN			{ $$ = symbol_value(&@$, "ecn"); }
-			|	RESET			{ $$ = symbol_value(&@$, "reset"); }
+			|	RESET	close_scope_reset	{ $$ = symbol_value(&@$, "reset"); }
 			|	ORIGINAL		{ $$ = symbol_value(&@$, "original"); }
 			|	REPLY			{ $$ = symbol_value(&@$, "reply"); }
 			|	LABEL			{ $$ = symbol_value(&@$, "label"); }
diff --git a/src/scanner.l b/src/scanner.l
index ea369c0775025..8725295a210cb 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -213,6 +213,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_VLAN
 %s SCANSTATE_CMD_LIST
 %s SCANSTATE_CMD_MONITOR
+%s SCANSTATE_CMD_RESET
 %s SCANSTATE_EXPR_AH
 %s SCANSTATE_EXPR_COMP
 %s SCANSTATE_EXPR_DCCP
@@ -340,7 +341,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "delete"		{ return DELETE; }
 "get"			{ return GET; }
 "list"			{ scanner_push_start_cond(yyscanner, SCANSTATE_CMD_LIST); return LIST; }
-"reset"			{ return RESET; }
+"reset"			{ scanner_push_start_cond(yyscanner, SCANSTATE_CMD_RESET); return RESET; }
 "flush"			{ return FLUSH; }
 "rename"		{ return RENAME; }
 "import"                { return IMPORT; }
@@ -384,8 +385,10 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 <SCANSTATE_COUNTER,SCANSTATE_CT,SCANSTATE_LIMIT>"packets"		{ return PACKETS; }
 <SCANSTATE_COUNTER,SCANSTATE_CT,SCANSTATE_LIMIT,SCANSTATE_QUOTA>"bytes"	{ return BYTES; }
 
-"counters"		{ return COUNTERS; }
-"quotas"		{ return QUOTAS; }
+<SCANSTATE_CMD_LIST,SCANSTATE_CMD_RESET>{
+	"counters"		{ return COUNTERS; }
+	"quotas"		{ return QUOTAS; }
+}
 
 "log"			{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_LOG); return LOG; }
 "prefix"		{ return PREFIX; }
-- 
2.34.1

