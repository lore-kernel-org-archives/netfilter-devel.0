Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84848C433E9
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 13:24:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50F6B64ECD
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 13:24:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbhCKNYF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 08:24:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233544AbhCKNXx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 08:23:53 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90251C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Mar 2021 05:23:53 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lKLI8-0003hM-10; Thu, 11 Mar 2021 14:23:52 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 08/12] scanner: vlan: move to own scope
Date:   Thu, 11 Mar 2021 14:23:09 +0100
Message-Id: <20210311132313.24403-9-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210311132313.24403-1-fw@strlen.de>
References: <20210311132313.24403-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

ID needs to remain exposed as its used by ct, icmp, icmp6 and so on.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/parser.h   | 1 +
 src/parser_bison.y | 5 +++--
 src/scanner.l      | 9 ++++++---
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 38039677cd1d..889f9418a864 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -33,6 +33,7 @@ enum startcond_type {
 	PARSER_SC_ETH,
 	PARSER_SC_IP,
 	PARSER_SC_IP6,
+	PARSER_SC_VLAN,
 	PARSER_SC_EXPR_FIB,
 	PARSER_SC_EXPR_HASH,
 	PARSER_SC_EXPR_IPSEC,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index a22f61c4c99b..a6ce506bf5b5 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -868,6 +868,7 @@ close_scope_fib		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_FIB); }
 close_scope_hash	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_HASH); };
 close_scope_ip		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_IP); };
 close_scope_ip6		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_IP6); };
+close_scope_vlan	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_VLAN); };
 close_scope_ipsec	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_IPSEC); };
 close_scope_numgen	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_NUMGEN); };
 close_scope_queue	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_QUEUE); };
@@ -4544,7 +4545,7 @@ boolean_expr		:	boolean_keys
 keyword_expr		:	ETHER   close_scope_eth { $$ = symbol_value(&@$, "ether"); }
 			|	IP	close_scope_ip  { $$ = symbol_value(&@$, "ip"); }
 			|	IP6	close_scope_ip6 { $$ = symbol_value(&@$, "ip6"); }
-			|	VLAN			{ $$ = symbol_value(&@$, "vlan"); }
+			|	VLAN	close_scope_vlan { $$ = symbol_value(&@$, "vlan"); }
 			|	ARP	close_scope_arp { $$ = symbol_value(&@$, "arp"); }
 			|	DNAT			{ $$ = symbol_value(&@$, "dnat"); }
 			|	SNAT			{ $$ = symbol_value(&@$, "snat"); }
@@ -5093,7 +5094,7 @@ eth_hdr_field		:	SADDR		{ $$ = ETHHDR_SADDR; }
 			|	TYPE		{ $$ = ETHHDR_TYPE; }
 			;
 
-vlan_hdr_expr		:	VLAN	vlan_hdr_field
+vlan_hdr_expr		:	VLAN	vlan_hdr_field	close_scope_vlan
 			{
 				$$ = payload_expr_alloc(&@$, &proto_vlan, $2);
 			}
diff --git a/src/scanner.l b/src/scanner.l
index 728b2c79b395..b664a794184f 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -201,6 +201,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_ETH
 %s SCANSTATE_IP
 %s SCANSTATE_IP6
+%s SCANSTATE_VLAN
 %s SCANSTATE_EXPR_FIB
 %s SCANSTATE_EXPR_HASH
 %s SCANSTATE_EXPR_IPSEC
@@ -403,10 +404,12 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "type"			{ return TYPE; }
 "typeof"		{ return TYPEOF; }
 
-"vlan"			{ return VLAN; }
+"vlan"			{ scanner_push_start_cond(yyscanner, SCANSTATE_VLAN); return VLAN; }
 "id"			{ return ID; }
-"cfi"			{ return CFI; }
-"pcp"			{ return PCP; }
+<SCANSTATE_VLAN>{
+	"cfi"		{ return CFI; }
+	"pcp"		{ return PCP; }
+}
 
 "arp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_ARP); return ARP; }
 <SCANSTATE_ARP>{
-- 
2.26.2

