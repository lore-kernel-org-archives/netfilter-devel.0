Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD67AC4332B
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 13:24:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7924664FA0
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 13:24:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbhCKNYE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 08:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233542AbhCKNXp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 08:23:45 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12770C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Mar 2021 05:23:45 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lKLHz-0003h8-NR; Thu, 11 Mar 2021 14:23:43 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 06/12] scanner: arp: move to own scope
Date:   Thu, 11 Mar 2021 14:23:07 +0100
Message-Id: <20210311132313.24403-7-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210311132313.24403-1-fw@strlen.de>
References: <20210311132313.24403-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

allows to move the arp specific tokens out of the INITIAL scope.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/parser.h   |  1 +
 src/parser_bison.y |  7 ++++---
 src/scanner.l      | 15 +++++++++------
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index cdc5fd094af5..38039677cd1d 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -28,6 +28,7 @@ struct parser_state {
 
 enum startcond_type {
 	PARSER_SC_BEGIN,
+	PARSER_SC_ARP,
 	PARSER_SC_CT,
 	PARSER_SC_ETH,
 	PARSER_SC_IP,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 9cfa336643e5..a22f61c4c99b 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -861,6 +861,7 @@ opt_newline		:	NEWLINE
 		 	|	/* empty */
 			;
 
+close_scope_arp		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_ARP); };
 close_scope_ct		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CT); };
 close_scope_eth		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_ETH); };
 close_scope_fib		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_FIB); };
@@ -2431,7 +2432,7 @@ family_spec		:	/* empty */		{ $$ = NFPROTO_IPV4; }
 family_spec_explicit	:	IP	close_scope_ip 	{ $$ = NFPROTO_IPV4; }
 			|	IP6	close_scope_ip6 { $$ = NFPROTO_IPV6; }
 			|	INET			{ $$ = NFPROTO_INET; }
-			|	ARP			{ $$ = NFPROTO_ARP; }
+			|	ARP	close_scope_arp { $$ = NFPROTO_ARP; }
 			|	BRIDGE			{ $$ = NFPROTO_BRIDGE; }
 			|	NETDEV			{ $$ = NFPROTO_NETDEV; }
 			;
@@ -4544,7 +4545,7 @@ keyword_expr		:	ETHER   close_scope_eth { $$ = symbol_value(&@$, "ether"); }
 			|	IP	close_scope_ip  { $$ = symbol_value(&@$, "ip"); }
 			|	IP6	close_scope_ip6 { $$ = symbol_value(&@$, "ip6"); }
 			|	VLAN			{ $$ = symbol_value(&@$, "vlan"); }
-			|	ARP			{ $$ = symbol_value(&@$, "arp"); }
+			|	ARP	close_scope_arp { $$ = symbol_value(&@$, "arp"); }
 			|	DNAT			{ $$ = symbol_value(&@$, "dnat"); }
 			|	SNAT			{ $$ = symbol_value(&@$, "snat"); }
 			|	ECN			{ $$ = symbol_value(&@$, "ecn"); }
@@ -5104,7 +5105,7 @@ vlan_hdr_field		:	ID		{ $$ = VLANHDR_VID; }
 			|	TYPE		{ $$ = VLANHDR_TYPE; }
 			;
 
-arp_hdr_expr		:	ARP	arp_hdr_field
+arp_hdr_expr		:	ARP	arp_hdr_field	close_scope_arp
 			{
 				$$ = payload_expr_alloc(&@$, &proto_arp, $2);
 			}
diff --git a/src/scanner.l b/src/scanner.l
index b1b03b951263..509b1b0d77a2 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -196,6 +196,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %option nodefault
 %option warn
 %option stack
+%s SCANSTATE_ARP
 %s SCANSTATE_CT
 %s SCANSTATE_ETH
 %s SCANSTATE_IP
@@ -405,12 +406,14 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "cfi"			{ return CFI; }
 "pcp"			{ return PCP; }
 
-"arp"			{ return ARP; }
-"htype"			{ return HTYPE; }
-"ptype"			{ return PTYPE; }
-"hlen"			{ return HLEN; }
-"plen"			{ return PLEN; }
-"operation"		{ return OPERATION; }
+"arp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_ARP); return ARP; }
+<SCANSTATE_ARP>{
+	"htype"			{ return HTYPE; }
+	"ptype"			{ return PTYPE; }
+	"hlen"			{ return HLEN; }
+	"plen"			{ return PLEN; }
+	"operation"		{ return OPERATION; }
+}
 
 "ip"			{ scanner_push_start_cond(yyscanner, SCANSTATE_IP); return IP; }
 "version"		{ return HDRVERSION; }
-- 
2.26.2

