Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA618C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Jul 2022 08:05:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbiGPIF4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 16 Jul 2022 04:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiGPIFz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 16 Jul 2022 04:05:55 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BCA4C3DBF7
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Jul 2022 01:05:54 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] parser_bison: bail out on too long names
Date:   Sat, 16 Jul 2022 10:05:49 +0200
Message-Id: <20220716080549.162980-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If user specifies a too long object name, bail out.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 93 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index ae14eb1a690b..c1ca15b49b81 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1533,6 +1533,13 @@ basehook_spec		:	ruleset_spec
 			|	ruleset_spec    basehook_device_name
 			{
 				if ($2) {
+					if (strlen($2) > NFT_NAME_MAXLEN) {
+						erec_queue(error(&@2, "name too long, %d characters maximum allowed",
+								 NFT_NAME_MAXLEN),
+							   state->msgs);
+						xfree($2);
+						YYERROR;
+					}
 					$1.obj.name = $2;
 					$1.obj.location = @2;
 				}
@@ -2597,6 +2604,13 @@ table_spec		:	family_spec	identifier
 				$$.family	= $1;
 				$$.table.location = @2;
 				$$.table.name	= $2;
+				if (strlen($2) > NFT_NAME_MAXLEN) {
+					erec_queue(error(&@2, "name too long, %d characters maximum allowed",
+							 NFT_NAME_MAXLEN),
+						   state->msgs);
+					xfree($2);
+					YYERROR;
+				}
 			}
 			;
 
@@ -2614,6 +2628,13 @@ chain_spec		:	table_spec	identifier
 				$$		= $1;
 				$$.chain.name	= $2;
 				$$.chain.location = @2;
+				if (strlen($2) > NFT_NAME_MAXLEN) {
+					erec_queue(error(&@2, "name too long, %d characters maximum allowed",
+							 NFT_NAME_MAXLEN),
+						   state->msgs);
+					xfree($2);
+					YYERROR;
+				}
 			}
 			;
 
@@ -2630,6 +2651,13 @@ chain_identifier	:	identifier
 				memset(&$$, 0, sizeof($$));
 				$$.chain.name		= $1;
 				$$.chain.location	= @1;
+				if (strlen($1) > NFT_NAME_MAXLEN) {
+					erec_queue(error(&@1, "name too long, %d characters maximum allowed",
+							 NFT_NAME_MAXLEN),
+						   state->msgs);
+					xfree($1);
+					YYERROR;
+				}
 			}
 			;
 
@@ -2638,6 +2666,13 @@ set_spec		:	table_spec	identifier
 				$$		= $1;
 				$$.set.name	= $2;
 				$$.set.location	= @2;
+				if (strlen($$.set.name) > NFT_NAME_MAXLEN) {
+					erec_queue(error(&@2, "name too long, %d characters maximum allowed",
+							 NFT_NAME_MAXLEN),
+						   state->msgs);
+					xfree($2);
+					YYERROR;
+				}
 			}
 			;
 
@@ -2654,6 +2689,13 @@ set_identifier		:	identifier
 				memset(&$$, 0, sizeof($$));
 				$$.set.name	= $1;
 				$$.set.location	= @1;
+				if (strlen($$.set.name) > NFT_NAME_MAXLEN) {
+					erec_queue(error(&@1, "name too long, %d characters maximum allowed",
+							 NFT_NAME_MAXLEN),
+						   state->msgs);
+					xfree($1);
+					YYERROR;
+				}
 			}
 			;
 
@@ -2662,6 +2704,13 @@ flowtable_spec		:	table_spec	identifier
 				$$			= $1;
 				$$.flowtable.name	= $2;
 				$$.flowtable.location	= @2;
+				if (strlen($2) > NFT_NAME_MAXLEN) {
+					erec_queue(error(&@2, "name too long, %d characters maximum allowed",
+							 NFT_NAME_MAXLEN),
+						   state->msgs);
+					xfree($2);
+					YYERROR;
+				}
 			}
 			;
 
@@ -2678,6 +2727,13 @@ flowtable_identifier	:	identifier
 				memset(&$$, 0, sizeof($$));
 				$$.flowtable.name	= $1;
 				$$.flowtable.location	= @1;
+				if (strlen($1) > NFT_NAME_MAXLEN) {
+					erec_queue(error(&@1, "name too long, %d characters maximum allowed",
+							 NFT_NAME_MAXLEN),
+						   state->msgs);
+					xfree($1);
+					YYERROR;
+				}
 			}
 			;
 
@@ -2686,6 +2742,13 @@ obj_spec		:	table_spec	identifier
 				$$		= $1;
 				$$.obj.name	= $2;
 				$$.obj.location	= @2;
+				if (strlen($2) > NFT_NAME_MAXLEN) {
+					erec_queue(error(&@2, "name too long, %d characters maximum allowed",
+							 NFT_NAME_MAXLEN),
+						   state->msgs);
+					xfree($2);
+					YYERROR;
+				}
 			}
 			;
 
@@ -2702,6 +2765,13 @@ obj_identifier		:	identifier
 				memset(&$$, 0, sizeof($$));
 				$$.obj.name		= $1;
 				$$.obj.location		= @1;
+				if (strlen($1) > NFT_NAME_MAXLEN) {
+					erec_queue(error(&@1, "name too long, %d characters maximum allowed",
+							 NFT_NAME_MAXLEN),
+						   state->msgs);
+					xfree($1);
+					YYERROR;
+				}
 			}
 			;
 
@@ -3980,6 +4050,13 @@ flow_stmt_opts		:	flow_stmt_opt
 flow_stmt_opt		:	TABLE			identifier
 			{
 				$<stmt>0->meter.name = $2;
+				if (strlen($2) > NFT_NAME_MAXLEN) {
+					erec_queue(error(&@2, "name too long, %d characters maximum allowed",
+							 NFT_NAME_MAXLEN),
+						   state->msgs);
+					xfree($2);
+					YYERROR;
+				}
 			}
 			;
 
@@ -3991,6 +4068,14 @@ meter_stmt_alloc	:	METER	identifier		'{' meter_key_expr stmt '}'
 				$$->meter.key  = $4;
 				$$->meter.stmt = $5;
 				$$->location  = @$;
+
+				if (strlen($2) > NFT_NAME_MAXLEN) {
+					erec_queue(error(&@2, "name too long, %d characters maximum allowed",
+							 NFT_NAME_MAXLEN),
+						   state->msgs);
+					xfree($2);
+					YYERROR;
+				}
 			}
 			|	METER	identifier	SIZE	NUM	'{' meter_key_expr stmt '}'
 			{
@@ -4000,6 +4085,14 @@ meter_stmt_alloc	:	METER	identifier		'{' meter_key_expr stmt '}'
 				$$->meter.key  = $6;
 				$$->meter.stmt = $7;
 				$$->location  = @$;
+
+				if (strlen($2) > NFT_NAME_MAXLEN) {
+					erec_queue(error(&@2, "name too long, %d characters maximum allowed",
+							 NFT_NAME_MAXLEN),
+						   state->msgs);
+					xfree($2);
+					YYERROR;
+				}
 			}
 			;
 
-- 
2.30.2

