Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D871C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Nov 2021 11:09:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 466A461A38
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Nov 2021 11:09:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234702AbhKPLMk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Nov 2021 06:12:40 -0500
Received: from mail.netfilter.org ([217.70.188.207]:37244 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234711AbhKPLMj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Nov 2021 06:12:39 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 18641607F4
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Nov 2021 12:07:37 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] parser: allow for string raw payload base
Date:   Tue, 16 Nov 2021 12:09:37 +0100
Message-Id: <20211116110937.630891-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Remove new 'ih' token, allow to represent the raw payload base with a
string instead.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 13 +++++++++++--
 src/scanner.l      |  1 -
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index eb89a58989e2..81d75ecb2fe8 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -318,7 +318,6 @@ int nft_lex(void *, void *, void *);
 %token LL_HDR			"ll"
 %token NETWORK_HDR		"nh"
 %token TRANSPORT_HDR		"th"
-%token INNER_HDR		"ih"
 
 %token BRIDGE			"bridge"
 
@@ -5261,7 +5260,17 @@ payload_raw_expr	:	AT	payload_base_spec	COMMA	NUM	COMMA	NUM
 payload_base_spec	:	LL_HDR		{ $$ = PROTO_BASE_LL_HDR; }
 			|	NETWORK_HDR	{ $$ = PROTO_BASE_NETWORK_HDR; }
 			|	TRANSPORT_HDR	{ $$ = PROTO_BASE_TRANSPORT_HDR; }
-			|	INNER_HDR	{ $$ = PROTO_BASE_INNER_HDR; }
+			|	STRING
+			{
+				if (!strcmp($1, "ih")) {
+					$$ = PROTO_BASE_INNER_HDR;
+				} else {
+					erec_queue(error(&@1, "unknown raw payload base"), state->msgs);
+					xfree($1);
+					YYERROR;
+				}
+				xfree($1);
+			}
 			;
 
 eth_hdr_expr		:	ETHER	eth_hdr_field	close_scope_eth
diff --git a/src/scanner.l b/src/scanner.l
index 5d263f9dc8b1..6cc7778dd85e 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -414,7 +414,6 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "ll"			{ return LL_HDR; }
 "nh"			{ return NETWORK_HDR; }
 "th"			{ return TRANSPORT_HDR; }
-"ih"			{ return INNER_HDR; }
 
 "bridge"		{ return BRIDGE; }
 
-- 
2.30.2

