Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1107DC433E6
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 13:24:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEDF664ED1
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 13:24:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233533AbhCKNYD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 08:24:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233540AbhCKNXl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 08:23:41 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC54DC061574
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Mar 2021 05:23:40 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lKLHv-0003h1-Hx; Thu, 11 Mar 2021 14:23:39 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 05/12] scanner: add ether scope
Date:   Thu, 11 Mar 2021 14:23:06 +0100
Message-Id: <20210311132313.24403-6-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210311132313.24403-1-fw@strlen.de>
References: <20210311132313.24403-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

just like previous change: useless as-is, but prepares
for removal of saddr/daddr from INITIAL scope.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/parser.h   |  1 +
 src/parser_bison.y | 11 ++++++-----
 src/scanner.l      |  3 ++-
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index e338713dad32..cdc5fd094af5 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -29,6 +29,7 @@ struct parser_state {
 enum startcond_type {
 	PARSER_SC_BEGIN,
 	PARSER_SC_CT,
+	PARSER_SC_ETH,
 	PARSER_SC_IP,
 	PARSER_SC_IP6,
 	PARSER_SC_EXPR_FIB,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 74ab69dd8820..9cfa336643e5 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -862,6 +862,7 @@ opt_newline		:	NEWLINE
 			;
 
 close_scope_ct		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CT); };
+close_scope_eth		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_ETH); };
 close_scope_fib		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_FIB); };
 close_scope_hash	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_HASH); };
 close_scope_ip		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_IP); };
@@ -3015,7 +3016,7 @@ log_flags		:	TCP	log_flags_tcp
 			{
 				$$ = NF_LOG_UID;
 			}
-			|	ETHER
+			|	ETHER	close_scope_eth
 			{
 				$$ = NF_LOG_MACDECODE;
 			}
@@ -4539,7 +4540,7 @@ boolean_expr		:	boolean_keys
 			}
 			;
 
-keyword_expr		:	ETHER                   { $$ = symbol_value(&@$, "ether"); }
+keyword_expr		:	ETHER   close_scope_eth { $$ = symbol_value(&@$, "ether"); }
 			|	IP	close_scope_ip  { $$ = symbol_value(&@$, "ip"); }
 			|	IP6	close_scope_ip6 { $$ = symbol_value(&@$, "ip6"); }
 			|	VLAN			{ $$ = symbol_value(&@$, "vlan"); }
@@ -5080,7 +5081,7 @@ payload_base_spec	:	LL_HDR		{ $$ = PROTO_BASE_LL_HDR; }
 			|	TRANSPORT_HDR	{ $$ = PROTO_BASE_TRANSPORT_HDR; }
 			;
 
-eth_hdr_expr		:	ETHER	eth_hdr_field
+eth_hdr_expr		:	ETHER	eth_hdr_field	close_scope_eth
 			{
 				$$ = payload_expr_alloc(&@$, &proto_eth, $2);
 			}
@@ -5114,8 +5115,8 @@ arp_hdr_field		:	HTYPE		{ $$ = ARPHDR_HRD; }
 			|	HLEN		{ $$ = ARPHDR_HLN; }
 			|	PLEN		{ $$ = ARPHDR_PLN; }
 			|	OPERATION	{ $$ = ARPHDR_OP; }
-			|	SADDR ETHER	{ $$ = ARPHDR_SADDR_ETHER; }
-			|	DADDR ETHER	{ $$ = ARPHDR_DADDR_ETHER; }
+			|	SADDR ETHER	close_scope_eth	{ $$ = ARPHDR_SADDR_ETHER; }
+			|	DADDR ETHER	close_scope_eth { $$ = ARPHDR_DADDR_ETHER; }
 			|	SADDR IP	close_scope_ip	{ $$ = ARPHDR_SADDR_IP; }
 			|	DADDR IP	close_scope_ip	{ $$ = ARPHDR_DADDR_IP; }
 			;
diff --git a/src/scanner.l b/src/scanner.l
index c78f34b625c2..b1b03b951263 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -197,6 +197,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %option warn
 %option stack
 %s SCANSTATE_CT
+%s SCANSTATE_ETH
 %s SCANSTATE_IP
 %s SCANSTATE_IP6
 %s SCANSTATE_EXPR_FIB
@@ -393,7 +394,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "bridge"		{ return BRIDGE; }
 
-"ether"			{ return ETHER; }
+"ether"			{ scanner_push_start_cond(yyscanner, SCANSTATE_ETH); return ETHER; }
 "saddr"			{ return SADDR; }
 "daddr"			{ return DADDR; }
 "type"			{ return TYPE; }
-- 
2.26.2

