Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABFD1C04A6A
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 15:47:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbjHBPr3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 11:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234228AbjHBPr1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 11:47:27 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36571718
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Aug 2023 08:47:25 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qRE4J-0005Oe-PU; Wed, 02 Aug 2023 17:47:23 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] parser: allow ct timeouts to use time_spec values
Date:   Wed,  2 Aug 2023 17:47:14 +0200
Message-ID: <20230802154717.19030-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

For some reason the parser only allows raw numbers (seconds)
for ct timeouts, e.g.

ct timeout ttcp {
	protocol tcp;
	policy = { syn_sent : 3, ...

Also permit time_spec, e.g. "established : 5d".
Print the nicer time formats on output, but retain
raw numbers support on input for compatibility.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/stateful-objects.txt                               |  2 +-
 src/parser_bison.y                                     | 10 +++++++---
 src/rule.c                                             |  9 ++++++---
 tests/shell/testcases/listing/0013objects_0            |  2 +-
 .../testcases/nft-f/dumps/0017ct_timeout_obj_0.nft     |  2 +-
 5 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/doc/stateful-objects.txt b/doc/stateful-objects.txt
index e3c79220811f..00d3c5f10463 100644
--- a/doc/stateful-objects.txt
+++ b/doc/stateful-objects.txt
@@ -94,7 +94,7 @@ table ip filter {
 	ct timeout customtimeout {
 		protocol tcp;
 		l3proto ip
-		policy = { established: 120, close: 20 }
+		policy = { established: 2m, close: 20s }
 	}
 
 	chain output {
diff --git a/src/parser_bison.y b/src/parser_bison.y
index ef5011c1d723..36172713470a 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -673,7 +673,7 @@ int nft_lex(void *, void *, void *);
 %type <string>			identifier type_identifier string comment_spec
 %destructor { xfree($$); }	identifier type_identifier string comment_spec
 
-%type <val>			time_spec quota_used
+%type <val>			time_spec time_spec_or_num_s quota_used
 
 %type <expr>			data_type_expr data_type_atom_expr
 %destructor { expr_free($$); }  data_type_expr data_type_atom_expr
@@ -2790,6 +2790,11 @@ time_spec		:	STRING
 			}
 			;
 
+/* compatibility kludge to allow either 60, 60s, 1m, ... */
+time_spec_or_num_s	:	NUM
+			|	time_spec { $$ = $1 / 1000u; }
+			;
+
 family_spec		:	/* empty */		{ $$ = NFPROTO_IPV4; }
 			|	family_spec_explicit
 			;
@@ -4812,8 +4817,7 @@ timeout_states		:	timeout_state
 			}
 			;
 
-timeout_state		:	STRING	COLON	NUM
-
+timeout_state		:	STRING	COLON	time_spec_or_num_s
 			{
 				struct timeout_state *ts;
 
diff --git a/src/rule.c b/src/rule.c
index 4e60c1e63656..99c4f0bb8b00 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1684,11 +1684,14 @@ static void print_proto_timeout_policy(uint8_t l4, const uint32_t *timeout,
 	nft_print(octx, "%s%spolicy = { ", opts->tab, opts->tab);
 	for (i = 0; i < timeout_protocol[l4].array_size; i++) {
 		if (timeout[i] != timeout_protocol[l4].dflt_timeout[i]) {
+			uint64_t timeout_ms;
+
 			if (comma)
 				nft_print(octx, ", ");
-			nft_print(octx, "%s : %u",
-				  timeout_protocol[l4].state_to_name[i],
-				  timeout[i]);
+			timeout_ms = timeout[i] * 1000u;
+			nft_print(octx, "%s : ",
+				  timeout_protocol[l4].state_to_name[i]);
+			time_print(timeout_ms, octx);
 			comma = true;
 		}
 	}
diff --git a/tests/shell/testcases/listing/0013objects_0 b/tests/shell/testcases/listing/0013objects_0
index 4d39143d9ce0..c81b94e20f65 100755
--- a/tests/shell/testcases/listing/0013objects_0
+++ b/tests/shell/testcases/listing/0013objects_0
@@ -15,7 +15,7 @@ EXPECTED="table ip test {
 	ct timeout cttime {
 		protocol udp
 		l3proto ip
-		policy = { unreplied : 15, replied : 12 }
+		policy = { unreplied : 15s, replied : 12s }
 	}
 
 	ct expectation ctexpect {
diff --git a/tests/shell/testcases/nft-f/dumps/0017ct_timeout_obj_0.nft b/tests/shell/testcases/nft-f/dumps/0017ct_timeout_obj_0.nft
index 7cff1ed5f21c..c5d9649e4038 100644
--- a/tests/shell/testcases/nft-f/dumps/0017ct_timeout_obj_0.nft
+++ b/tests/shell/testcases/nft-f/dumps/0017ct_timeout_obj_0.nft
@@ -2,7 +2,7 @@ table ip filter {
 	ct timeout cttime {
 		protocol tcp
 		l3proto ip
-		policy = { established : 123, close : 12 }
+		policy = { established : 2m3s, close : 12s }
 	}
 
 	chain c {
-- 
2.41.0

