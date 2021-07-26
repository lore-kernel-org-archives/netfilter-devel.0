Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1500C4338F
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Jul 2021 14:48:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6D1560EB2
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Jul 2021 14:48:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbhGZOIV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Jul 2021 10:08:21 -0400
Received: from mail.netfilter.org ([217.70.188.207]:32840 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233206AbhGZOIU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jul 2021 10:08:20 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id F05CA642A3
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jul 2021 16:48:18 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] parser_bison: parse number as reject icmp code
Date:   Mon, 26 Jul 2021 16:48:41 +0200
Message-Id: <20210726144841.26272-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extend parser to accept a numeric icmp code, instead of bailing out:

 # nft add rule inet filter input reject with icmpx type 3
 Error: syntax error, unexpected number, expecting string
 add rule inet filter input reject with icmpx type 3
                                                   ^

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1555
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y                  | 37 +++++++++++++----------------
 tests/py/inet/reject.t              |  1 +
 tests/py/inet/reject.t.payload.inet |  4 ++++
 tests/py/ip/reject.t                |  1 +
 tests/py/ip/reject.t.payload        |  4 ++++
 tests/py/ip6/reject.t               |  1 +
 tests/py/ip6/reject.t.payload.ip6   |  4 ++++
 7 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index b9b3d026a4ee..79b5aef24512 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -705,8 +705,8 @@ int nft_lex(void *, void *, void *);
 
 %type <stmt>			queue_stmt queue_stmt_alloc	queue_stmt_compat
 %destructor { stmt_free($$); }	queue_stmt queue_stmt_alloc	queue_stmt_compat
-%type <expr>			queue_stmt_expr_simple queue_stmt_expr
-%destructor { expr_free($$); }	queue_stmt_expr_simple queue_stmt_expr
+%type <expr>			queue_stmt_expr_simple queue_stmt_expr reject_with_expr
+%destructor { expr_free($$); }	queue_stmt_expr_simple queue_stmt_expr reject_with_expr
 %type <val>			queue_stmt_flags queue_stmt_flag
 %type <stmt>			dup_stmt
 %destructor { stmt_free($$); }	dup_stmt
@@ -3298,42 +3298,39 @@ reject_stmt_alloc	:	_REJECT
 			}
 			;
 
+reject_with_expr	:	STRING
+			{
+				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
+						       current_scope(state), $1);
+				xfree($1);
+			}
+			|	integer_expr	{ $$ = $1; }
+			;
+
 reject_opts		:       /* empty */
 			{
 				$<stmt>0->reject.type = -1;
 				$<stmt>0->reject.icmp_code = -1;
 			}
-			|	WITH	ICMP	TYPE	STRING
+			|	WITH	ICMP	TYPE	reject_with_expr
 			{
 				$<stmt>0->reject.family = NFPROTO_IPV4;
 				$<stmt>0->reject.type = NFT_REJECT_ICMP_UNREACH;
-				$<stmt>0->reject.expr =
-					symbol_expr_alloc(&@$, SYMBOL_VALUE,
-							  current_scope(state),
-							  $4);
+				$<stmt>0->reject.expr = $4;
 				datatype_set($<stmt>0->reject.expr, &icmp_code_type);
-				xfree($4);
 			}
-			|	WITH	ICMP6	TYPE	STRING
+			|	WITH	ICMP6	TYPE	reject_with_expr
 			{
 				$<stmt>0->reject.family = NFPROTO_IPV6;
 				$<stmt>0->reject.type = NFT_REJECT_ICMP_UNREACH;
-				$<stmt>0->reject.expr =
-					symbol_expr_alloc(&@$, SYMBOL_VALUE,
-							  current_scope(state),
-							  $4);
+				$<stmt>0->reject.expr = $4;
 				datatype_set($<stmt>0->reject.expr, &icmpv6_code_type);
-				xfree($4);
 			}
-			|	WITH	ICMPX	TYPE	STRING
+			|	WITH	ICMPX	TYPE	reject_with_expr
 			{
 				$<stmt>0->reject.type = NFT_REJECT_ICMPX_UNREACH;
-				$<stmt>0->reject.expr =
-					symbol_expr_alloc(&@$, SYMBOL_VALUE,
-							  current_scope(state),
-							  $4);
+				$<stmt>0->reject.expr = $4;
 				datatype_set($<stmt>0->reject.expr, &icmpx_code_type);
-				xfree($4);
 			}
 			|	WITH	TCP	RESET
 			{
diff --git a/tests/py/inet/reject.t b/tests/py/inet/reject.t
index a9ecd2ea0308..bae8fc2ecdb1 100644
--- a/tests/py/inet/reject.t
+++ b/tests/py/inet/reject.t
@@ -25,6 +25,7 @@ reject with icmpx type host-unreachable;ok
 reject with icmpx type no-route;ok
 reject with icmpx type admin-prohibited;ok
 reject with icmpx type port-unreachable;ok;reject
+reject with icmpx type 3;ok;reject with icmpx type admin-prohibited
 
 meta nfproto ipv4 reject with icmp type host-unreachable;ok;reject with icmp type host-unreachable
 meta nfproto ipv6 reject with icmpv6 type no-route;ok;reject with icmpv6 type no-route
diff --git a/tests/py/inet/reject.t.payload.inet b/tests/py/inet/reject.t.payload.inet
index 3f2202824b8c..be6ad3943f12 100644
--- a/tests/py/inet/reject.t.payload.inet
+++ b/tests/py/inet/reject.t.payload.inet
@@ -104,6 +104,10 @@ inet test-inet input
 inet test-inet input
   [ reject type 2 code 1 ]
 
+# reject with icmpx type 3
+inet test-inet input
+  [ reject type 2 code 3 ]
+
 # meta nfproto ipv4 reject with icmp type host-unreachable
 inet test-inet input
   [ meta load nfproto => reg 1 ]
diff --git a/tests/py/ip/reject.t b/tests/py/ip/reject.t
index cc5561a0bcc0..74a5a04101bf 100644
--- a/tests/py/ip/reject.t
+++ b/tests/py/ip/reject.t
@@ -10,6 +10,7 @@ reject with icmp type port-unreachable;ok;reject
 reject with icmp type net-prohibited;ok
 reject with icmp type host-prohibited;ok
 reject with icmp type admin-prohibited;ok
+reject with icmp type 3;ok;reject
 mark 0x80000000 reject with tcp reset;ok;meta mark 0x80000000 reject with tcp reset
 
 reject with icmp type no-route;fail
diff --git a/tests/py/ip/reject.t.payload b/tests/py/ip/reject.t.payload
index 07e4cc8d71a0..80fc5042e421 100644
--- a/tests/py/ip/reject.t.payload
+++ b/tests/py/ip/reject.t.payload
@@ -30,6 +30,10 @@ ip test-ip4 output
 ip test-ip4 output
   [ reject type 0 code 13 ]
 
+# reject with icmp type 3
+ip test-ip4 output
+  [ reject type 0 code 3 ]
+
 # mark 0x80000000 reject with tcp reset
 ip test-ip4 output
   [ meta load l4proto => reg 1 ]
diff --git a/tests/py/ip6/reject.t b/tests/py/ip6/reject.t
index 7fa04eecc974..79f3d5577f8f 100644
--- a/tests/py/ip6/reject.t
+++ b/tests/py/ip6/reject.t
@@ -9,6 +9,7 @@ reject with icmpv6 type addr-unreachable;ok
 reject with icmpv6 type port-unreachable;ok;reject
 reject with icmpv6 type policy-fail;ok
 reject with icmpv6 type reject-route;ok
+reject with icmpv6 type 3;ok;reject with icmpv6 type addr-unreachable
 mark 0x80000000 reject with tcp reset;ok;meta mark 0x80000000 reject with tcp reset
 
 reject with icmpv6 type host-unreachable;fail
diff --git a/tests/py/ip6/reject.t.payload.ip6 b/tests/py/ip6/reject.t.payload.ip6
index dd4491ae47a8..9f90734efd73 100644
--- a/tests/py/ip6/reject.t.payload.ip6
+++ b/tests/py/ip6/reject.t.payload.ip6
@@ -26,6 +26,10 @@ ip6 test-ip6 output
 ip6 test-ip6 output
   [ reject type 0 code 6 ]
 
+# reject with icmpv6 type 3
+ip6 test-ip6 output
+  [ reject type 0 code 3 ]
+
 # mark 0x80000000 reject with tcp reset
 ip6 test-ip6 output
   [ meta load l4proto => reg 1 ]
-- 
2.20.1

