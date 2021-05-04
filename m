Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78B7EC433ED
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 May 2021 17:02:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61A7A613C1
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 May 2021 17:02:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbhEDRCz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 May 2021 13:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbhEDRCy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 May 2021 13:02:54 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9863C061574
        for <netfilter-devel@vger.kernel.org>; Tue,  4 May 2021 10:01:59 -0700 (PDT)
Received: from localhost ([::1]:42760 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1ldyQn-0008Co-Gg; Tue, 04 May 2021 19:01:57 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/3] scanner: sctp: Move to own scope
Date:   Tue,  4 May 2021 19:01:46 +0200
Message-Id: <20210504170148.25226-1-phil@nwl.cc>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This isolates only "vtag" token for now.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/parser.h   | 1 +
 src/parser_bison.y | 5 +++--
 src/scanner.l      | 8 ++++++--
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index d890ab223c524..e3f48078385bb 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -38,6 +38,7 @@ enum startcond_type {
 	PARSER_SC_IP6,
 	PARSER_SC_LIMIT,
 	PARSER_SC_QUOTA,
+	PARSER_SC_SCTP,
 	PARSER_SC_SECMARK,
 	PARSER_SC_VLAN,
 	PARSER_SC_EXPR_FIB,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index cc477e65672a7..411c788c0fc25 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -876,6 +876,7 @@ close_scope_numgen	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_NUMGE
 close_scope_quota	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_QUOTA); };
 close_scope_queue	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_QUEUE); };
 close_scope_rt		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_RT); };
+close_scope_sctp	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_SCTP); };
 close_scope_secmark	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_SECMARK); };
 close_scope_socket	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_SOCKET); }
 
@@ -4640,7 +4641,7 @@ primary_rhs_expr	:	symbol_expr		{ $$ = $1; }
 							 BYTEORDER_HOST_ENDIAN,
 							 sizeof(data) * BITS_PER_BYTE, &data);
 			}
-			|	SCTP
+			|	SCTP	close_scope_sctp
 			{
 				uint8_t data = IPPROTO_SCTP;
 				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
@@ -5366,7 +5367,7 @@ dccp_hdr_field		:	SPORT		{ $$ = DCCPHDR_SPORT; }
 			|	TYPE		{ $$ = DCCPHDR_TYPE; }
 			;
 
-sctp_hdr_expr		:	SCTP	sctp_hdr_field
+sctp_hdr_expr		:	SCTP	sctp_hdr_field	close_scope_sctp
 			{
 				$$ = payload_expr_alloc(&@$, &proto_sctp, $2);
 			}
diff --git a/src/scanner.l b/src/scanner.l
index a9232db8978e7..35603e5e9c884 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -204,6 +204,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_IP6
 %s SCANSTATE_LIMIT
 %s SCANSTATE_QUOTA
+%s SCANSTATE_SCTP
 %s SCANSTATE_SECMARK
 %s SCANSTATE_VLAN
 %s SCANSTATE_EXPR_FIB
@@ -524,8 +525,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "dccp"			{ return DCCP; }
 
-"sctp"			{ return SCTP; }
-"vtag"			{ return VTAG; }
+"sctp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_SCTP); return SCTP; }
+
+<SCANSTATE_SCTP>{
+	"vtag"			{ return VTAG; }
+}
 
 "rt"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_RT); return RT; }
 "rt0"			{ return RT0; }
-- 
2.31.0

