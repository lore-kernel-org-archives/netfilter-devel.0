Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAC58C4332B
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 13:24:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C247F64ED5
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 13:24:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233525AbhCKNXc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 08:23:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233526AbhCKNX2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 08:23:28 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1751FC061574
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Mar 2021 05:23:28 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lKLHi-0003gZ-PT; Thu, 11 Mar 2021 14:23:26 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 02/12] scanner: ip: move to own scope
Date:   Thu, 11 Mar 2021 14:23:03 +0100
Message-Id: <20210311132313.24403-3-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210311132313.24403-1-fw@strlen.de>
References: <20210311132313.24403-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Move the ip option names (rr, lsrr, ...) out of INITIAL scope.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/parser.h   |  1 +
 src/parser_bison.y | 23 ++++++++++++-----------
 src/scanner.l      | 17 ++++++++++-------
 3 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index be29f400c023..a778cb59c2c9 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -29,6 +29,7 @@ struct parser_state {
 enum startcond_type {
 	PARSER_SC_BEGIN,
 	PARSER_SC_CT,
+	PARSER_SC_IP,
 	PARSER_SC_EXPR_HASH,
 	PARSER_SC_EXPR_IPSEC,
 	PARSER_SC_EXPR_NUMGEN,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 2d2563c823ea..ba15366cb3db 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -863,6 +863,7 @@ opt_newline		:	NEWLINE
 
 close_scope_ct		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CT); };
 close_scope_hash	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_HASH); };
+close_scope_ip		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_IP); };
 close_scope_ipsec	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_IPSEC); };
 close_scope_numgen	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_NUMGEN); };
 close_scope_queue	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_QUEUE); };
@@ -2424,7 +2425,7 @@ family_spec		:	/* empty */		{ $$ = NFPROTO_IPV4; }
 			|	family_spec_explicit
 			;
 
-family_spec_explicit	:	IP		{ $$ = NFPROTO_IPV4; }
+family_spec_explicit	:	IP	close_scope_ip 	{ $$ = NFPROTO_IPV4; }
 			|	IP6		{ $$ = NFPROTO_IPV6; }
 			|	INET		{ $$ = NFPROTO_INET; }
 			|	ARP		{ $$ = NFPROTO_ARP; }
@@ -3004,7 +3005,7 @@ log_flags		:	TCP	log_flags_tcp
 			{
 				$$ = $2;
 			}
-			|	IP	OPTIONS
+			|	IP	OPTIONS	close_scope_ip
 			{
 				$$ = NF_LOG_IPOPT;
 			}
@@ -4537,7 +4538,7 @@ boolean_expr		:	boolean_keys
 			;
 
 keyword_expr		:	ETHER                   { $$ = symbol_value(&@$, "ether"); }
-			|	IP			{ $$ = symbol_value(&@$, "ip"); }
+			|	IP	close_scope_ip  { $$ = symbol_value(&@$, "ip"); }
 			|	IP6			{ $$ = symbol_value(&@$, "ip6"); }
 			|	VLAN			{ $$ = symbol_value(&@$, "vlan"); }
 			|	ARP			{ $$ = symbol_value(&@$, "arp"); }
@@ -4892,7 +4893,7 @@ hash_expr		:	JHASH		expr	MOD	NUM	SEED	NUM	offset_opt	close_scope_hash
 			}
 			;
 
-nf_key_proto		:	IP		{ $$ = NFPROTO_IPV4; }
+nf_key_proto		:	IP	close_scope_ip { $$ = NFPROTO_IPV4; }
 			|	IP6		{ $$ = NFPROTO_IPV6; }
 			;
 
@@ -4972,8 +4973,8 @@ ct_key_dir		:	SADDR		{ $$ = NFT_CT_SRC; }
 			|	ct_key_dir_optional
 			;
 
-ct_key_proto_field	:	IP	SADDR	{ $$ = NFT_CT_SRC_IP; }
-			|	IP	DADDR	{ $$ = NFT_CT_DST_IP; }
+ct_key_proto_field	:	IP	SADDR	close_scope_ip { $$ = NFT_CT_SRC_IP; }
+			|	IP	DADDR	close_scope_ip { $$ = NFT_CT_DST_IP; }
 			|	IP6	SADDR	{ $$ = NFT_CT_SRC_IP6; }
 			|	IP6	DADDR	{ $$ = NFT_CT_DST_IP6; }
 			;
@@ -5113,19 +5114,19 @@ arp_hdr_field		:	HTYPE		{ $$ = ARPHDR_HRD; }
 			|	OPERATION	{ $$ = ARPHDR_OP; }
 			|	SADDR ETHER	{ $$ = ARPHDR_SADDR_ETHER; }
 			|	DADDR ETHER	{ $$ = ARPHDR_DADDR_ETHER; }
-			|	SADDR IP	{ $$ = ARPHDR_SADDR_IP; }
-			|	DADDR IP	{ $$ = ARPHDR_DADDR_IP; }
+			|	SADDR IP	close_scope_ip	{ $$ = ARPHDR_SADDR_IP; }
+			|	DADDR IP	close_scope_ip	{ $$ = ARPHDR_DADDR_IP; }
 			;
 
-ip_hdr_expr		:	IP	ip_hdr_field
+ip_hdr_expr		:	IP	ip_hdr_field	close_scope_ip
 			{
 				$$ = payload_expr_alloc(&@$, &proto_ip, $2);
 			}
-			|	IP	OPTION	ip_option_type ip_option_field
+			|	IP	OPTION	ip_option_type ip_option_field	close_scope_ip
 			{
 				$$ = ipopt_expr_alloc(&@$, $3, $4, 0);
 			}
-			|	IP	OPTION	ip_option_type
+			|	IP	OPTION	ip_option_type close_scope_ip
 			{
 				$$ = ipopt_expr_alloc(&@$, $3, IPOPT_FIELD_TYPE, 0);
 				$$->exthdr.flags = NFT_EXTHDR_F_PRESENT;
diff --git a/src/scanner.l b/src/scanner.l
index 1358f9d01d6a..262945064e80 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -197,6 +197,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %option warn
 %option stack
 %s SCANSTATE_CT
+%s SCANSTATE_IP
 %s SCANSTATE_EXPR_HASH
 %s SCANSTATE_EXPR_IPSEC
 %s SCANSTATE_EXPR_NUMGEN
@@ -408,7 +409,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "plen"			{ return PLEN; }
 "operation"		{ return OPERATION; }
 
-"ip"			{ return IP; }
+"ip"			{ scanner_push_start_cond(yyscanner, SCANSTATE_IP); return IP; }
 "version"		{ return HDRVERSION; }
 "hdrlength"		{ return HDRLENGTH; }
 "dscp"			{ return DSCP; }
@@ -419,13 +420,15 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "protocol"		{ return PROTOCOL; }
 "checksum"		{ return CHECKSUM; }
 
-"lsrr"			{ return LSRR; }
-"rr"			{ return RR; }
-"ssrr"			{ return SSRR; }
-"ra"			{ return RA; }
+<SCANSTATE_IP>{
+	"lsrr"			{ return LSRR; }
+	"rr"			{ return RR; }
+	"ssrr"			{ return SSRR; }
+	"ra"			{ return RA; }
 
-"value"			{ return VALUE; }
-"ptr"			{ return PTR; }
+	"ptr"			{ return PTR; }
+	"value"			{ return VALUE; }
+}
 
 "echo"			{ return ECHO; }
 "eol"			{ return EOL; }
-- 
2.26.2

