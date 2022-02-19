Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB91CC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Feb 2022 13:30:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242259AbiBSNaS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 08:30:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241080AbiBSNaR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 08:30:17 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B37488B32
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 05:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9K6YQCzgwQwRvKoqW/6cryZEULi2jcaPW/IBbqsjrXQ=; b=n6ghnZwcbPfTl3nqsD9thLTeEr
        4a1JzkbbEQPCcV4NraeRROMMU9/E+sf83jyRzUReOTR/efO0UtkEUbDCbZW0nH1ikZDqtLbt6HggU
        d4o/w5GgsnBz15ySKWvJXRzBtayP+pURXT0tYG0tN2cIh2IKg79r63R+EpUS19in4M7bM/rctF+yV
        ZpLeamldGT0xIXF657UYlkunyzDyLrj6n3k/x2/KP6wFdEG9ZvWlxr59d2MqtADB24JDn2GSFFWcO
        p8lmEUPUfU39JMiZRiFZd6dC+0CriEyyIPgl+1AZWZbz6xWRUHtHGRypXOqtjQPISFKo9u2FB+l2X
        qMijT3AA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nLPoC-0002bF-OB; Sat, 19 Feb 2022 14:29:56 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 17/26] scanner: monitor: Move to own Scope
Date:   Sat, 19 Feb 2022 14:28:05 +0100
Message-Id: <20220219132814.30823-18-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220219132814.30823-1-phil@nwl.cc>
References: <20220219132814.30823-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Some keywords are shared with list command.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/parser.h   |  1 +
 src/parser_bison.y |  3 ++-
 src/scanner.l      | 17 +++++++++++------
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 072fea24eb0bd..09499f08119bf 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -46,6 +46,7 @@ enum startcond_type {
 	PARSER_SC_TYPE,
 	PARSER_SC_VLAN,
 	PARSER_SC_CMD_LIST,
+	PARSER_SC_CMD_MONITOR,
 	PARSER_SC_EXPR_AH,
 	PARSER_SC_EXPR_COMP,
 	PARSER_SC_EXPR_DCCP,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index a4f98e59e282a..6965872a760f1 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -948,6 +948,7 @@ close_scope_ipsec	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_IPSEC)
 close_scope_list	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CMD_LIST); };
 close_scope_limit	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_LIMIT); };
 close_scope_mh		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_MH); };
+close_scope_monitor	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CMD_MONITOR); };
 close_scope_numgen	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_NUMGEN); };
 close_scope_osf		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_OSF); };
 close_scope_quota	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_QUOTA); };
@@ -1052,7 +1053,7 @@ base_cmd		:	/* empty */	add_cmd		{ $$ = $1; }
 			|	RENAME		rename_cmd	{ $$ = $2; }
 			|       IMPORT          import_cmd      { $$ = $2; }
 			|	EXPORT		export_cmd	{ $$ = $2; }
-			|	MONITOR		monitor_cmd	{ $$ = $2; }
+			|	MONITOR		monitor_cmd	close_scope_monitor	{ $$ = $2; }
 			|	DESCRIBE	describe_cmd	{ $$ = $2; }
 			;
 
diff --git a/src/scanner.l b/src/scanner.l
index 6975d9f226ef2..ea369c0775025 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -212,6 +212,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_TYPE
 %s SCANSTATE_VLAN
 %s SCANSTATE_CMD_LIST
+%s SCANSTATE_CMD_MONITOR
 %s SCANSTATE_EXPR_AH
 %s SCANSTATE_EXPR_COMP
 %s SCANSTATE_EXPR_DCCP
@@ -289,23 +290,27 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "describe"		{ return DESCRIBE; }
 
+<SCANSTATE_CMD_LIST,SCANSTATE_CMD_MONITOR>{
+	"chains"		{ return CHAINS; }
+	"sets"			{ return SETS; }
+	"tables"		{ return TABLES; }
+}
+<SCANSTATE_CMD_MONITOR>{
+	"rules"			{ return RULES; }
+	"trace"			{ return TRACE; }
+}
 "hook"			{ return HOOK; }
 "device"		{ return DEVICE; }
 "devices"		{ return DEVICES; }
 "table"			{ return TABLE; }
-"tables"		{ return TABLES; }
 "chain"			{ return CHAIN; }
-"chains"		{ return CHAINS; }
 "rule"			{ return RULE; }
-"rules"			{ return RULES; }
-"sets"			{ return SETS; }
 "set"			{ return SET; }
 "element"		{ return ELEMENT; }
 "map"			{ return MAP; }
 "flowtable"		{ return FLOWTABLE; }
 "handle"		{ return HANDLE; }
 "ruleset"		{ return RULESET; }
-"trace"			{ return TRACE; }
 
 "socket"		{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_SOCKET); return SOCKET; }
 <SCANSTATE_EXPR_SOCKET>{
@@ -340,7 +345,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "rename"		{ return RENAME; }
 "import"                { return IMPORT; }
 "export"		{ return EXPORT; }
-"monitor"		{ return MONITOR; }
+"monitor"		{ scanner_push_start_cond(yyscanner, SCANSTATE_CMD_MONITOR); return MONITOR; }
 
 "position"		{ return POSITION; }
 "index"			{ return INDEX; }
-- 
2.34.1

