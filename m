Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 672AAC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Feb 2022 13:29:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbiBSN3k (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 08:29:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234333AbiBSN3j (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 08:29:39 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AEA670CCF
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 05:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EGqj2mfkIpy4JEQZtah0+CSAkB9QLxMNv/gVkQWJ5X8=; b=fVFK8PlsgzI+ViMZJN+1GjzDoo
        nc+dkZ85F1zENumvMh9kuwv6FRXyzC2H93Py873E7N1vNQHCW18/hbHoRRXX0X77OEBLeoUCEefYC
        Dpu0l94lJxVUI6iQv7Q2OYi26Z/BODEI9PwhuMGd+5jvhkoKB16zvwlXBLm3foAQvzEaVOHrfdvwB
        pi+WxSJX6p6TcygLtCTDjMGg9ushQU8xsmdahMA1jLmr4tLq1go0jGh0oa1We2j/duovXaB+3Jwk9
        RwmpSmG1tJ4ZaxQK2JBI/KO+eJVMX/q6tE9bK7+kyIoNIg4bLQrZ9DkB2nWK7UK4xYJ5COB/ZHwYr
        C0bpelxA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nLPna-0002Yf-MW; Sat, 19 Feb 2022 14:29:18 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 26/26] scanner: dup, fwd, tproxy: Move to own scopes
Date:   Sat, 19 Feb 2022 14:28:14 +0100
Message-Id: <20220219132814.30823-27-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220219132814.30823-1-phil@nwl.cc>
References: <20220219132814.30823-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With these three scopes in place, keyword 'to' may be isolated.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/parser.h   |  3 +++
 src/parser_bison.y |  9 ++++++---
 src/scanner.l      | 11 +++++++----
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index bc42229c1a83b..f32154cca44d3 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -75,10 +75,13 @@ enum startcond_type {
 	PARSER_SC_EXPR_UDP,
 	PARSER_SC_EXPR_UDPLITE,
 
+	PARSER_SC_STMT_DUP,
+	PARSER_SC_STMT_FWD,
 	PARSER_SC_STMT_LOG,
 	PARSER_SC_STMT_NAT,
 	PARSER_SC_STMT_REJECT,
 	PARSER_SC_STMT_SYNPROXY,
+	PARSER_SC_STMT_TPROXY,
 };
 
 struct mnl_socket;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index cd6f22ef8e915..7856b3f222780 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -934,12 +934,14 @@ close_scope_ct		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CT); };
 close_scope_counter	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_COUNTER); };
 close_scope_dccp	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_DCCP); };
 close_scope_dst		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_DST); };
+close_scope_dup		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_STMT_DUP); };
 close_scope_esp		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_ESP); };
 close_scope_eth		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_ETH); };
 close_scope_export	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CMD_EXPORT); };
 close_scope_fib		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_FIB); };
 close_scope_flags	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_FLAGS); };
 close_scope_frag	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_FRAG); };
+close_scope_fwd		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_STMT_FWD); };
 close_scope_hash	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_HASH); };
 close_scope_hbh		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_HBH); };
 close_scope_ip		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_IP); };
@@ -968,6 +970,7 @@ close_scope_sctp_chunk	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_S
 close_scope_secmark	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_SECMARK); };
 close_scope_socket	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_SOCKET); }
 close_scope_tcp		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_TCP); };
+close_scope_tproxy	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_STMT_TPROXY); };
 close_scope_type	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_TYPE); };
 close_scope_th		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_TH); };
 close_scope_udp		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_UDP); };
@@ -2843,13 +2846,13 @@ stmt			:	verdict_stmt
 			|	log_stmt	close_scope_log
 			|	reject_stmt	close_scope_reject
 			|	nat_stmt	close_scope_nat
-			|	tproxy_stmt
+			|	tproxy_stmt	close_scope_tproxy
 			|	queue_stmt
 			|	ct_stmt
 			|	masq_stmt	close_scope_nat
 			|	redir_stmt	close_scope_nat
-			|	dup_stmt
-			|	fwd_stmt
+			|	dup_stmt	close_scope_dup
+			|	fwd_stmt	close_scope_fwd
 			|	set_stmt
 			|	map_stmt
 			|	synproxy_stmt	close_scope_synproxy
diff --git a/src/scanner.l b/src/scanner.l
index be01c6f3b3bc6..fd1cf059a608f 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -241,10 +241,13 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_EXPR_UDP
 %s SCANSTATE_EXPR_UDPLITE
 
+%s SCANSTATE_STMT_DUP
+%s SCANSTATE_STMT_FWD
 %s SCANSTATE_STMT_LOG
 %s SCANSTATE_STMT_NAT
 %s SCANSTATE_STMT_REJECT
 %s SCANSTATE_STMT_SYNPROXY
+%s SCANSTATE_STMT_TPROXY
 
 %%
 
@@ -328,7 +331,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"cgroupv2"		{ return CGROUPV2; }
 	"level"			{ return LEVEL; }
 }
-"tproxy"		{ return TPROXY; }
+"tproxy"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_TPROXY); return TPROXY; }
 
 "accept"		{ return ACCEPT; }
 "drop"			{ return DROP; }
@@ -336,7 +339,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "jump"			{ return JUMP; }
 "goto"			{ return GOTO; }
 "return"		{ return RETURN; }
-"to"			{ return TO; }
+<SCANSTATE_EXPR_QUEUE,SCANSTATE_STMT_DUP,SCANSTATE_STMT_FWD,SCANSTATE_STMT_NAT,SCANSTATE_STMT_TPROXY,SCANSTATE_FLAGS,SCANSTATE_IP,SCANSTATE_IP6>"to"			{ return TO; } /* XXX: SCANSTATE_FLAGS and SCANSTATE_IP here are workarounds */
 
 "inet"			{ return INET; }
 "netdev"		{ return NETDEV; }
@@ -759,8 +762,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"mod"		{ return MOD; }
 	"offset"	{ return OFFSET; }
 }
-"dup"			{ return DUP; }
-"fwd"			{ return FWD; }
+"dup"			{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_DUP); return DUP; }
+"fwd"			{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_FWD); return FWD; }
 
 "fib"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_FIB); return FIB; }
 
-- 
2.34.1

