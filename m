Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C957AC433DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 13:24:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80C8364ECD
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 13:24:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbhCKNYC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 08:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233509AbhCKNXc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 08:23:32 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E13C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Mar 2021 05:23:32 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lKLHn-0003gg-1g; Thu, 11 Mar 2021 14:23:31 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 03/12] scanner: ip6: move to own scope
Date:   Thu, 11 Mar 2021 14:23:04 +0100
Message-Id: <20210311132313.24403-4-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210311132313.24403-1-fw@strlen.de>
References: <20210311132313.24403-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

move flowlabel and hoplimit.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/parser.h   |  1 +
 src/parser_bison.y | 21 +++++++++++----------
 src/scanner.l      |  9 ++++++---
 3 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index a778cb59c2c9..586a984875c4 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -30,6 +30,7 @@ enum startcond_type {
 	PARSER_SC_BEGIN,
 	PARSER_SC_CT,
 	PARSER_SC_IP,
+	PARSER_SC_IP6,
 	PARSER_SC_EXPR_HASH,
 	PARSER_SC_EXPR_IPSEC,
 	PARSER_SC_EXPR_NUMGEN,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index ba15366cb3db..9ef2602e22bd 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -864,6 +864,7 @@ opt_newline		:	NEWLINE
 close_scope_ct		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CT); };
 close_scope_hash	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_HASH); };
 close_scope_ip		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_IP); };
+close_scope_ip6		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_IP6); };
 close_scope_ipsec	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_IPSEC); };
 close_scope_numgen	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_NUMGEN); };
 close_scope_queue	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_QUEUE); };
@@ -2426,11 +2427,11 @@ family_spec		:	/* empty */		{ $$ = NFPROTO_IPV4; }
 			;
 
 family_spec_explicit	:	IP	close_scope_ip 	{ $$ = NFPROTO_IPV4; }
-			|	IP6		{ $$ = NFPROTO_IPV6; }
-			|	INET		{ $$ = NFPROTO_INET; }
-			|	ARP		{ $$ = NFPROTO_ARP; }
-			|	BRIDGE		{ $$ = NFPROTO_BRIDGE; }
-			|	NETDEV		{ $$ = NFPROTO_NETDEV; }
+			|	IP6	close_scope_ip6 { $$ = NFPROTO_IPV6; }
+			|	INET			{ $$ = NFPROTO_INET; }
+			|	ARP			{ $$ = NFPROTO_ARP; }
+			|	BRIDGE			{ $$ = NFPROTO_BRIDGE; }
+			|	NETDEV			{ $$ = NFPROTO_NETDEV; }
 			;
 
 table_spec		:	family_spec	identifier
@@ -4539,7 +4540,7 @@ boolean_expr		:	boolean_keys
 
 keyword_expr		:	ETHER                   { $$ = symbol_value(&@$, "ether"); }
 			|	IP	close_scope_ip  { $$ = symbol_value(&@$, "ip"); }
-			|	IP6			{ $$ = symbol_value(&@$, "ip6"); }
+			|	IP6	close_scope_ip6 { $$ = symbol_value(&@$, "ip6"); }
 			|	VLAN			{ $$ = symbol_value(&@$, "vlan"); }
 			|	ARP			{ $$ = symbol_value(&@$, "arp"); }
 			|	DNAT			{ $$ = symbol_value(&@$, "dnat"); }
@@ -4894,7 +4895,7 @@ hash_expr		:	JHASH		expr	MOD	NUM	SEED	NUM	offset_opt	close_scope_hash
 			;
 
 nf_key_proto		:	IP	close_scope_ip { $$ = NFPROTO_IPV4; }
-			|	IP6		{ $$ = NFPROTO_IPV6; }
+			|	IP6	close_scope_ip6 { $$ = NFPROTO_IPV6; }
 			;
 
 rt_expr			:	RT	rt_key	close_scope_rt
@@ -4975,8 +4976,8 @@ ct_key_dir		:	SADDR		{ $$ = NFT_CT_SRC; }
 
 ct_key_proto_field	:	IP	SADDR	close_scope_ip { $$ = NFT_CT_SRC_IP; }
 			|	IP	DADDR	close_scope_ip { $$ = NFT_CT_DST_IP; }
-			|	IP6	SADDR	{ $$ = NFT_CT_SRC_IP6; }
-			|	IP6	DADDR	{ $$ = NFT_CT_DST_IP6; }
+			|	IP6	SADDR	close_scope_ip6	{ $$ = NFT_CT_SRC_IP6; }
+			|	IP6	DADDR	close_scope_ip6 { $$ = NFT_CT_DST_IP6; }
 			;
 
 ct_key_dir_optional	:	BYTES		{ $$ = NFT_CT_BYTES; }
@@ -5187,7 +5188,7 @@ igmp_hdr_field		:	TYPE		{ $$ = IGMPHDR_TYPE; }
 			|	GROUP		{ $$ = IGMPHDR_GROUP; }
 			;
 
-ip6_hdr_expr		:	IP6	ip6_hdr_field
+ip6_hdr_expr		:	IP6	ip6_hdr_field	close_scope_ip6
 			{
 				$$ = payload_expr_alloc(&@$, &proto_ip6, $2);
 			}
diff --git a/src/scanner.l b/src/scanner.l
index 262945064e80..15d1beca601d 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -198,6 +198,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %option stack
 %s SCANSTATE_CT
 %s SCANSTATE_IP
+%s SCANSTATE_IP6
 %s SCANSTATE_EXPR_HASH
 %s SCANSTATE_EXPR_IPSEC
 %s SCANSTATE_EXPR_NUMGEN
@@ -462,11 +463,13 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "igmp"			{ return IGMP; }
 "mrt"			{ return MRT; }
 
-"ip6"			{ return IP6; }
+"ip6"			{ scanner_push_start_cond(yyscanner, SCANSTATE_IP6); return IP6; }
 "priority"		{ return PRIORITY; }
-"flowlabel"		{ return FLOWLABEL; }
+<SCANSTATE_IP6>{
+	"flowlabel"		{ return FLOWLABEL; }
+	"hoplimit"		{ return HOPLIMIT; }
+}
 "nexthdr"		{ return NEXTHDR; }
-"hoplimit"		{ return HOPLIMIT; }
 
 "icmpv6"		{ return ICMP6; }
 "param-problem"		{ return PPTR; }
-- 
2.26.2

