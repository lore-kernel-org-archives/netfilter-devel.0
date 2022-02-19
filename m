Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3254C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Feb 2022 13:28:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237208AbiBSN2x (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 08:28:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234934AbiBSN2x (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 08:28:53 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33441011
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 05:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KVin//oUsjmwUmMiuQ9LiZpxjKMqw2f4cEd4pFrTbEw=; b=OijmflnmZX0DwLaFGRZR0pHZdN
        0AVlsHhJxV44jhpifCgKpiNs6C6m68vQYugsl5D5DtLUQnEXKpoMSMiNsBkpR9JXNmilYcE38rvS2
        KEGDOw5q4tWIdyAhmh+ESbBd1j0A9sY6m+7wo1mAGhmAfYlFm9EgMX8mxw3yOFoNNUeaJOIV/XGyY
        Ld1bazEtdqk8ScbbKSRaajNBIis+Oje0WzCh+m5ljhUuWgS1g3A4vNvLLMrBlJw4BDEQFmxH5Be1U
        7MQlFJdPWykGFBOTH5cxF3LlXTNV588eb7LMotwCiTCF1RSuUFBJsHymkrylz9b0viayUMZrRTIFA
        7Gd21kXw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nLPmr-0002Vz-By; Sat, 19 Feb 2022 14:28:33 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 19/26] scanner: import, export: Move to own scopes
Date:   Sat, 19 Feb 2022 14:28:07 +0100
Message-Id: <20220219132814.30823-20-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220219132814.30823-1-phil@nwl.cc>
References: <20220219132814.30823-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In theory, one could use a common scope for both import and export
commands, their parameters are identical.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/parser.h   |  2 ++
 src/parser_bison.y |  6 ++++--
 src/scanner.l      | 14 +++++++++-----
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 0601b410a8458..090fd78871a6e 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -45,6 +45,8 @@ enum startcond_type {
 	PARSER_SC_TCP,
 	PARSER_SC_TYPE,
 	PARSER_SC_VLAN,
+	PARSER_SC_CMD_EXPORT,
+	PARSER_SC_CMD_IMPORT,
 	PARSER_SC_CMD_LIST,
 	PARSER_SC_CMD_MONITOR,
 	PARSER_SC_CMD_RESET,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 99b52cf41d25d..22e953eaf77e6 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -935,6 +935,7 @@ close_scope_dccp	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_DCCP);
 close_scope_dst		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_DST); };
 close_scope_esp		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_ESP); };
 close_scope_eth		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_ETH); };
+close_scope_export	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CMD_EXPORT); };
 close_scope_fib		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_FIB); };
 close_scope_frag	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_FRAG); };
 close_scope_hash	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_HASH); };
@@ -944,6 +945,7 @@ close_scope_ip6		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_IP6); };
 close_scope_vlan	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_VLAN); };
 close_scope_icmp	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_ICMP); };
 close_scope_igmp	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_IGMP); };
+close_scope_import	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CMD_IMPORT); };
 close_scope_ipsec	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_IPSEC); };
 close_scope_list	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CMD_LIST); };
 close_scope_limit	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_LIMIT); };
@@ -1052,8 +1054,8 @@ base_cmd		:	/* empty */	add_cmd		{ $$ = $1; }
 			|	RESET		reset_cmd	close_scope_reset	{ $$ = $2; }
 			|	FLUSH		flush_cmd	{ $$ = $2; }
 			|	RENAME		rename_cmd	{ $$ = $2; }
-			|       IMPORT          import_cmd      { $$ = $2; }
-			|	EXPORT		export_cmd	{ $$ = $2; }
+			|       IMPORT          import_cmd	close_scope_import	{ $$ = $2; }
+			|	EXPORT		export_cmd	close_scope_export	{ $$ = $2; }
 			|	MONITOR		monitor_cmd	close_scope_monitor	{ $$ = $2; }
 			|	DESCRIBE	describe_cmd	{ $$ = $2; }
 			;
diff --git a/src/scanner.l b/src/scanner.l
index 8725295a210cb..97545b7057ab7 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -211,6 +211,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_TCP
 %s SCANSTATE_TYPE
 %s SCANSTATE_VLAN
+%s SCANSTATE_CMD_EXPORT
+%s SCANSTATE_CMD_IMPORT
 %s SCANSTATE_CMD_LIST
 %s SCANSTATE_CMD_MONITOR
 %s SCANSTATE_CMD_RESET
@@ -344,8 +346,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "reset"			{ scanner_push_start_cond(yyscanner, SCANSTATE_CMD_RESET); return RESET; }
 "flush"			{ return FLUSH; }
 "rename"		{ return RENAME; }
-"import"                { return IMPORT; }
-"export"		{ return EXPORT; }
+"import"                { scanner_push_start_cond(yyscanner, SCANSTATE_CMD_IMPORT); return IMPORT; }
+"export"		{ scanner_push_start_cond(yyscanner, SCANSTATE_CMD_EXPORT); return EXPORT; }
 "monitor"		{ scanner_push_start_cond(yyscanner, SCANSTATE_CMD_MONITOR); return MONITOR; }
 
 "position"		{ return POSITION; }
@@ -759,9 +761,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "all"			{ return ALL; }
 
-"xml"			{ return XML; }
-"json"			{ return JSON; }
-"vm"                    { return VM; }
+<SCANSTATE_CMD_EXPORT,SCANSTATE_CMD_IMPORT,SCANSTATE_CMD_MONITOR>{
+	"xml"			{ return XML; }
+	"json"			{ return JSON; }
+	"vm"                    { return VM; }
+}
 
 "exists"		{ return EXISTS; }
 "missing"		{ return MISSING; }
-- 
2.34.1

