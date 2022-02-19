Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3374C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Feb 2022 13:29:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234333AbiBSN3p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 08:29:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234261AbiBSN3o (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 08:29:44 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83ED975C0D
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 05:29:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=b91L/O3MBiY2awj9yu2j53rBo1oJiQBHNQXmsdQEqL0=; b=LDXjL9B2QUiqxJUj8BBMUVBeW+
        Myq9iwJeuA1wCfp30aKB3HzCoGz3nh98K4iq+w7BnhiB5o5ZBTYuMo8CtPg1Kg2aHCSjqj30Sgrn/
        7ZSzARpueXrayw30SsLl/ifRoXIu+GyMv/LNNp12HdXZ2nSo05miYtFQiR66vCkrw3vSCnl9ogCRB
        ufzGx4UDOOeU6vZ82zr5KRrfjKV3IDIDQdetp15e7kZpD6Q8EWq7XiELFvlK+YyTYhi5j9Fvl3nz9
        2bKV1q/+0Zus6C5yRGTa9/fzqHE8/3ZDEhjJTjGeeSMTK0G4MKiVO/Wmos2orhPJV2ec3Ssb81C66
        to5PhEdQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nLPng-0002Z7-0I; Sat, 19 Feb 2022 14:29:24 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 07/26] scanner: tcp: Move to own scope
Date:   Sat, 19 Feb 2022 14:27:55 +0100
Message-Id: <20220219132814.30823-8-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220219132814.30823-1-phil@nwl.cc>
References: <20220219132814.30823-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Apart from header fields, this isolates TCP option types and
fields, too.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_bison.y |  2 +-
 src/scanner.l      | 60 +++++++++++++++++++++++++++-------------------
 2 files changed, 36 insertions(+), 26 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 6340bda6cc585..55f3b2bc35bec 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -942,13 +942,13 @@ close_scope_list	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CMD_LIST); }
 close_scope_limit	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_LIMIT); };
 close_scope_numgen	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_NUMGEN); };
 close_scope_quota	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_QUOTA); };
-close_scope_tcp		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_TCP); }
 close_scope_queue	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_QUEUE); };
 close_scope_rt		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_RT); };
 close_scope_sctp	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_SCTP); };
 close_scope_sctp_chunk	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_SCTP_CHUNK); };
 close_scope_secmark	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_SECMARK); };
 close_scope_socket	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_SOCKET); }
+close_scope_tcp		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_TCP); };
 
 close_scope_log		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_STMT_LOG); }
 
diff --git a/src/scanner.l b/src/scanner.l
index a584b5fba39b4..95dcd0330bd3e 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -468,30 +468,46 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 	"ptr"			{ return PTR; }
 	"value"			{ return VALUE; }
+
+	"option"		{ return OPTION; }
+	"options"		{ return OPTIONS; }
 }
 
 <SCANSTATE_TCP>{
-"echo"			{ return ECHO; }
-"eol"			{ return EOL; }
-"fastopen"		{ return FASTOPEN; }
-"mptcp"			{ return MPTCP; }
-"md5sig"		{ return MD5SIG; }
-"subtype"		{ return SUBTYPE; }
-"nop"			{ return NOP; }
-"noop"			{ return NOP; }
-"sack"			{ return SACK; }
-"sack0"			{ return SACK0; }
-"sack1"			{ return SACK1; }
-"sack2"			{ return SACK2; }
-"sack3"			{ return SACK3; }
-"time"			{ return TIME; }
+	/* tcp header fields */
+	"ackseq"		{ return ACKSEQ; }
+	"doff"			{ return DOFF; }
+	"window"		{ return WINDOW; }
+	"urgptr"		{ return URGPTR; }
+
+	/* tcp option types */
+	"echo"			{ return ECHO; }
+	"eol"			{ return EOL; }
+	"maxseg"		{ return MSS; }
+	"mss"			{ return MSS; }
+	"nop"			{ return NOP; }
+	"noop"			{ return NOP; }
+	"sack"			{ return SACK; }
+	"sack0"			{ return SACK0; }
+	"sack1"			{ return SACK1; }
+	"sack2"			{ return SACK2; }
+	"sack3"			{ return SACK3; }
+	"fastopen"		{ return FASTOPEN; }
+	"mptcp"			{ return MPTCP; }
+	"md5sig"		{ return MD5SIG; }
+
+	/* tcp option fields */
+	"left"			{ return LEFT; }
+	"right"			{ return RIGHT; }
+	"count"			{ return COUNT; }
+	"tsval"			{ return TSVAL; }
+	"tsecr"			{ return TSECR; }
+	"subtype"		{ return SUBTYPE; }
 
-"count"			{ return COUNT; }
-"left"			{ return LEFT; }
-"right"			{ return RIGHT; }
-"tsval"			{ return TSVAL; }
-"tsecr"			{ return TSECR; }
+	"options"		{ return OPTIONS; }
+	"option"		{ return OPTION; }
 }
+"time"			{ return TIME; }
 "maxseg"		{ return MSS; }
 "mss"			{ return MSS; }
 "sack-permitted"	{ return SACK_PERM; }
@@ -540,11 +556,6 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "port"			{ return PORT; }
 
 "tcp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_TCP); return TCP; }
-"ackseq"		{ return ACKSEQ; }
-"doff"			{ return DOFF; }
-"window"		{ return WINDOW; }
-"urgptr"		{ return URGPTR; }
-"option"		{ return OPTION; }
 
 "dccp"			{ return DCCP; }
 
@@ -688,7 +699,6 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "notrack"		{ return NOTRACK; }
 
-"options"		{ return OPTIONS; }
 "all"			{ return ALL; }
 
 "xml"			{ return XML; }
-- 
2.34.1

