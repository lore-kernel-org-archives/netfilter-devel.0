Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFBD9C4338F
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Aug 2021 14:01:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C4D860F35
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Aug 2021 14:01:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233568AbhHIOCJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Aug 2021 10:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233165AbhHIOCI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Aug 2021 10:02:08 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E3BBC0613D3
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Aug 2021 07:01:48 -0700 (PDT)
Received: from localhost ([::1]:48434 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mD5qb-00076s-Si; Mon, 09 Aug 2021 16:01:45 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: [nft PATCH RFC] scanner: nat: Move to own scope
Date:   Mon,  9 Aug 2021 16:01:41 +0200
Message-Id: <20210809140141.18976-1-phil@nwl.cc>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Unify nat, masquerade and redirect statements, they widely share their
syntax.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
This seemingly valid change breaks the parser with this rule:

| snat ip prefix to ip saddr map { 10.141.11.0/24 : 192.168.2.0/24 }

Problem is that 'prefix' is not in SC_IP and close_scope_ip called from
parser_bison.y:5067 is not sufficient. I assumed explicit scope closing
would eliminate this lookahead problem. Did I find a proof against the
concept or is there a bug in my patch?

Thanks, Phil
---
 include/parser.h   |  1 +
 src/parser_bison.y | 13 +++++++------
 src/scanner.l      | 19 +++++++++++--------
 3 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index e8635b4c0feb7..5bb45fc4380e4 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -52,6 +52,7 @@ enum startcond_type {
 	PARSER_SC_EXPR_SOCKET,
 
 	PARSER_SC_STMT_LOG,
+	PARSER_SC_STMT_NAT,
 };
 
 struct mnl_socket;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 83f0250a87449..2634b90c559b9 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -924,6 +924,7 @@ close_scope_vlan	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_VLAN); };
 close_scope_ipsec	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_IPSEC); };
 close_scope_list	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CMD_LIST); };
 close_scope_limit	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_LIMIT); };
+close_scope_nat		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_STMT_NAT); };
 close_scope_numgen	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_NUMGEN); };
 close_scope_quota	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_QUOTA); };
 close_scope_queue	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_QUEUE); };
@@ -2793,12 +2794,12 @@ stmt			:	verdict_stmt
 			|	meta_stmt
 			|	log_stmt	close_scope_log
 			|	reject_stmt
-			|	nat_stmt
+			|	nat_stmt	close_scope_nat
 			|	tproxy_stmt
 			|	queue_stmt
 			|	ct_stmt
-			|	masq_stmt
-			|	redir_stmt
+			|	masq_stmt	close_scope_nat
+			|	redir_stmt	close_scope_nat
 			|	dup_stmt
 			|	fwd_stmt
 			|	set_stmt
@@ -4708,8 +4709,8 @@ keyword_expr		:	ETHER   close_scope_eth { $$ = symbol_value(&@$, "ether"); }
 			|	IP6	close_scope_ip6 { $$ = symbol_value(&@$, "ip6"); }
 			|	VLAN	close_scope_vlan { $$ = symbol_value(&@$, "vlan"); }
 			|	ARP	close_scope_arp { $$ = symbol_value(&@$, "arp"); }
-			|	DNAT			{ $$ = symbol_value(&@$, "dnat"); }
-			|	SNAT			{ $$ = symbol_value(&@$, "snat"); }
+			|	DNAT	close_scope_nat	{ $$ = symbol_value(&@$, "dnat"); }
+			|	SNAT	close_scope_nat	{ $$ = symbol_value(&@$, "snat"); }
 			|	ECN			{ $$ = symbol_value(&@$, "ecn"); }
 			|	RESET			{ $$ = symbol_value(&@$, "reset"); }
 			|	ORIGINAL		{ $$ = symbol_value(&@$, "original"); }
@@ -4798,7 +4799,7 @@ primary_rhs_expr	:	symbol_expr		{ $$ = $1; }
 							 BYTEORDER_HOST_ENDIAN,
 							 sizeof(data) * BITS_PER_BYTE, &data);
 			}
-			|	REDIRECT
+			|	REDIRECT	close_scope_nat
 			{
 				uint8_t data = ICMP_REDIRECT;
 				$$ = constant_expr_alloc(&@$, &icmp_type_type,
diff --git a/src/scanner.l b/src/scanner.l
index 6cc7778dd85e1..f1e0162b0ae5e 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -218,6 +218,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_EXPR_SOCKET
 
 %s SCANSTATE_STMT_LOG
+%s SCANSTATE_STMT_NAT
 
 %%
 
@@ -366,7 +367,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "quotas"		{ return QUOTAS; }
 
 "log"			{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_LOG); return LOG; }
-"prefix"		{ return PREFIX; }
+<SCANSTATE_STMT_LOG,SCANSTATE_STMT_NAT>"prefix"		{ return PREFIX; }
 "group"			{ return GROUP; }
 <SCANSTATE_STMT_LOG>{
 	"snaplen"		{ return SNAPLEN; }
@@ -403,13 +404,16 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "with"			{ return WITH; }
 "icmpx"			{ return ICMPX; }
 
-"snat"			{ return SNAT; }
-"dnat"			{ return DNAT; }
-"masquerade"		{ return MASQUERADE; }
-"redirect"		{ return REDIRECT; }
+"snat"			{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_NAT); return SNAT; }
+"dnat"			{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_NAT); return DNAT; }
+"masquerade"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_NAT); return MASQUERADE; }
+"redirect"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_NAT); return REDIRECT; }
 "random"		{ return RANDOM; }
-"fully-random"		{ return FULLY_RANDOM; }
-"persistent"		{ return PERSISTENT; }
+<SCANSTATE_STMT_NAT>{
+	"fully-random"		{ return FULLY_RANDOM; }
+	"persistent"		{ return PERSISTENT; }
+	"port"			{ return PORT; }
+}
 
 "ll"			{ return LL_HDR; }
 "nh"			{ return NETWORK_HDR; }
@@ -523,7 +527,6 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "udplite"		{ return UDPLITE; }
 "sport"			{ return SPORT; }
 "dport"			{ return DPORT; }
-"port"			{ return PORT; }
 
 "tcp"			{ return TCP; }
 "ackseq"		{ return ACKSEQ; }
-- 
2.32.0

