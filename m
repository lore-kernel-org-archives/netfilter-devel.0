Return-Path: <SRS0=Eqja=WM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74578C3A59C
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Aug 2019 14:45:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 553E9206C1
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Aug 2019 14:45:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbfHPOpE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Aug 2019 10:45:04 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:46180 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727291AbfHPOpD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Aug 2019 10:45:03 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hydTS-0002oG-13; Fri, 16 Aug 2019 16:45:02 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables 4/8] src: parser: add syntax to provide bitsize for non-spcific types
Date:   Fri, 16 Aug 2019 16:42:37 +0200
Message-Id: <20190816144241.11469-5-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190816144241.11469-1-fw@strlen.de>
References: <20190816144241.11469-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This allows creation of sets with string and integer types by
providing the datatype width using a comma, e.g.

"type string, 64" or "integer, 32".

This is mainly intended as a fallback for the upcoming "typeof"
keyword -- if we can't make sense of the kernel provided type
(or its missing entirely), we can then fallback to this format.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y | 18 ++++++++++++++++++
 src/rule.c         | 24 +++++++++++++++++++-----
 2 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index c531ee1d1dd8..ee169fbac194 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1826,6 +1826,24 @@ data_type_atom_expr	:	type_identifier
 							 dtype->size, NULL);
 				xfree($1);
 			}
+			|	type_identifier	COMMA	NUM
+			{
+				const struct datatype *dtype = datatype_lookup_byname($1);
+				if (dtype == NULL) {
+					erec_queue(error(&@1, "unknown datatype %s", $1),
+						   state->msgs);
+					YYERROR;
+				}
+
+				if (dtype->size) {
+					erec_queue(error(&@1, "Datatype %s has a fixed type", $1),
+						   state->msgs);
+					YYERROR;
+				}
+				$$ = constant_expr_alloc(&@1, dtype, dtype->byteorder,
+							 $3, NULL);
+				xfree($1);
+			}
 			;
 
 data_type_expr		:	data_type_atom_expr
diff --git a/src/rule.c b/src/rule.c
index aee08ea12c8b..59369c9082a3 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -436,6 +436,16 @@ const char *set_policy2str(uint32_t policy)
 	}
 }
 
+static void set_print_key(const struct expr *expr, struct output_ctx *octx)
+{
+	const struct datatype *dtype = expr->dtype;
+
+	if (dtype->size)
+		nft_print(octx, " %s", dtype->name);
+	else
+		nft_print(octx, " %s,%d", dtype->name, expr->len);
+}
+
 static void set_print_declaration(const struct set *set,
 				  struct print_fmt_options *opts,
 				  struct output_ctx *octx)
@@ -465,12 +475,16 @@ static void set_print_declaration(const struct set *set,
 	if (nft_output_handle(octx))
 		nft_print(octx, " # handle %" PRIu64, set->handle.handle.id);
 	nft_print(octx, "%s", opts->nl);
-	nft_print(octx, "%s%stype %s",
-		  opts->tab, opts->tab, set->key->dtype->name);
-	if (set_is_datamap(set->flags))
-		nft_print(octx, " : %s", set->data->dtype->name);
-	else if (set_is_objmap(set->flags))
+	nft_print(octx, "%s%stype ",
+		  opts->tab, opts->tab);
+	set_print_key(set->key, octx);
+
+	if (set_is_datamap(set->flags)) {
+		nft_print(octx, " : ");
+		set_print_key(set->data, octx);
+	} else if (set_is_objmap(set->flags)) {
 		nft_print(octx, " : %s", obj_type_name(set->objtype));
+	}
 
 	nft_print(octx, "%s", opts->stmt_separator);
 
-- 
2.21.0

