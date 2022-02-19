Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00878C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Feb 2022 13:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242352AbiBSNbH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 08:31:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241982AbiBSNbF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 08:31:05 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E441488B32
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 05:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GPv0gR7E0KU52DQFX3rooezU7y8iIY2TPUYYpsfS8i4=; b=pc9KjIx8oKOY6oLLsYQ5RnIwJx
        +Uuil8P2mupWbhgW9lA4A+WXw3IjXTBmXolwK+y8D+8oxEq8G9q4yBepvAUsY5F1/E/OdW+Q+JICZ
        9xcDRrL72M6t2zg2RxWcanXj+/XyZPmC9aYTKNxokPYkGS+W5aZMS0Z12Gz6Wk0e9SJKVirIAPCAg
        sWZ1hWpjazWxipYFLY5Hfd08UybXy6w1fxQcFos1O8BavM5IRyzKB5/mDND1gfU3qIeu0Ys0nLwkh
        ltJjfT98N13DVuhLjlxICckQExiood5oHY+LSZD0AnZ4bO/aoeW5PJiopuKyQybp/q+bpqRh3gFGL
        aCQse07A==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nLPoz-0002f4-D1; Sat, 19 Feb 2022 14:30:45 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 08/26] scanner: synproxy: Move to own scope
Date:   Sat, 19 Feb 2022 14:27:56 +0100
Message-Id: <20220219132814.30823-9-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220219132814.30823-1-phil@nwl.cc>
References: <20220219132814.30823-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Quite a few keywords are shared with PARSER_SC_TCP.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/parser.h   |  1 +
 src/parser_bison.y | 15 ++++++++-------
 src/scanner.l      | 20 +++++++++++++-------
 3 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 16e02a1ffe129..0e75bad482075 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -55,6 +55,7 @@ enum startcond_type {
 	PARSER_SC_EXPR_SOCKET,
 
 	PARSER_SC_STMT_LOG,
+	PARSER_SC_STMT_SYNPROXY,
 };
 
 struct mnl_socket;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 55f3b2bc35bec..937bb410fa779 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -951,6 +951,7 @@ close_scope_socket	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_SOCKE
 close_scope_tcp		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_TCP); };
 
 close_scope_log		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_STMT_LOG); }
+close_scope_synproxy	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_STMT_SYNPROXY); }
 
 common_block		:	INCLUDE		QUOTED_STRING	stmt_separator
 			{
@@ -1151,11 +1152,11 @@ add_cmd			:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_SECMARK, &$2, &@$, $3);
 			}
-			|	SYNPROXY	obj_spec	synproxy_obj	synproxy_config
+			|	SYNPROXY	obj_spec	synproxy_obj	synproxy_config	close_scope_synproxy
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_SYNPROXY, &$2, &@$, $3);
 			}
-			|	SYNPROXY	obj_spec	synproxy_obj	'{' synproxy_block '}'
+			|	SYNPROXY	obj_spec	synproxy_obj	'{' synproxy_block '}'	close_scope_synproxy
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_SYNPROXY, &$2, &@$, $3);
 			}
@@ -1252,7 +1253,7 @@ create_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_SECMARK, &$2, &@$, $3);
 			}
-			|	SYNPROXY	obj_spec	synproxy_obj	synproxy_config
+			|	SYNPROXY	obj_spec	synproxy_obj	synproxy_config	close_scope_synproxy
 			{
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_SYNPROXY, &$2, &@$, $3);
 			}
@@ -1341,7 +1342,7 @@ delete_cmd		:	TABLE		table_or_id_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SECMARK, &$2, &@$, NULL);
 			}
-			|	SYNPROXY	obj_or_id_spec
+			|	SYNPROXY	obj_or_id_spec	close_scope_synproxy
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SYNPROXY, &$2, &@$, NULL);
 			}
@@ -1437,7 +1438,7 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SYNPROXYS, &$3, &@$, NULL);
 			}
-			|	SYNPROXY	obj_spec
+			|	SYNPROXY	obj_spec	close_scope_synproxy
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_SYNPROXY, &$2, &@$, NULL);
 			}
@@ -1793,7 +1794,7 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 			}
 			|	table_block	SYNPROXY	obj_identifier
 					obj_block_alloc '{'	synproxy_block	'}'
-					stmt_separator
+					stmt_separator	close_scope_synproxy
 			{
 				$4->location = @3;
 				$4->type = NFT_OBJECT_SYNPROXY;
@@ -2828,7 +2829,7 @@ stmt			:	verdict_stmt
 			|	fwd_stmt
 			|	set_stmt
 			|	map_stmt
-			|	synproxy_stmt
+			|	synproxy_stmt	close_scope_synproxy
 			|	chain_stmt
 			;
 
diff --git a/src/scanner.l b/src/scanner.l
index 95dcd0330bd3e..01cb501cb8cb3 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -221,6 +221,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_EXPR_SOCKET
 
 %s SCANSTATE_STMT_LOG
+%s SCANSTATE_STMT_SYNPROXY
 
 %%
 
@@ -492,6 +493,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"sack1"			{ return SACK1; }
 	"sack2"			{ return SACK2; }
 	"sack3"			{ return SACK3; }
+	"sack-permitted"	{ return SACK_PERM; }
+	"sack-perm"		{ return SACK_PERM; }
+	"timestamp"		{ return TIMESTAMP; }
 	"fastopen"		{ return FASTOPEN; }
 	"mptcp"			{ return MPTCP; }
 	"md5sig"		{ return MD5SIG; }
@@ -508,11 +512,6 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"option"		{ return OPTION; }
 }
 "time"			{ return TIME; }
-"maxseg"		{ return MSS; }
-"mss"			{ return MSS; }
-"sack-permitted"	{ return SACK_PERM; }
-"sack-perm"		{ return SACK_PERM; }
-"timestamp"		{ return TIMESTAMP; }
 
 "icmp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_ICMP); return ICMP; }
 "icmpv6"		{ scanner_push_start_cond(yyscanner, SCANSTATE_ICMP); return ICMP6; }
@@ -694,8 +693,15 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "osf"			{ return OSF; }
 
-"synproxy"		{ return SYNPROXY; }
-"wscale"		{ return WSCALE; }
+"synproxy"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_SYNPROXY); return SYNPROXY; }
+<SCANSTATE_STMT_SYNPROXY>{
+	"wscale"		{ return WSCALE; }
+	"maxseg"		{ return MSS; }
+	"mss"			{ return MSS; }
+	"timestamp"		{ return TIMESTAMP; }
+	"sack-permitted"	{ return SACK_PERM; }
+	"sack-perm"		{ return SACK_PERM; }
+}
 
 "notrack"		{ return NOTRACK; }
 
-- 
2.34.1

