Return-Path: <SRS0=tNyb=UE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E89C28CC6
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jun 2019 16:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 513CF20872
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jun 2019 16:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbfFEQrC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jun 2019 12:47:02 -0400
Received: from mail.us.es ([193.147.175.20]:58380 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728667AbfFEQrB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jun 2019 12:47:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AC8C5DA708
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Jun 2019 18:46:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 99195DA711
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Jun 2019 18:46:59 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 983DBDA70F; Wed,  5 Jun 2019 18:46:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 69497DA70D;
        Wed,  5 Jun 2019 18:46:57 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 05 Jun 2019 18:46:57 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3D48B4265A31;
        Wed,  5 Jun 2019 18:46:57 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc, fw@strlen.de
Subject: [PATCH nft 1/4] src: dynamic input_descriptor allocation
Date:   Wed,  5 Jun 2019 18:46:49 +0200
Message-Id: <20190605164652.20199-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190605164652.20199-1-pablo@netfilter.org>
References: <20190605164652.20199-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch introduces the input descriptor list, that stores the
existing input descriptor objects. These objects are now dynamically
allocated and release from scanner_destroy() path.

Follow up patches that decouple the parsing and the evaluation phases
require this for error reporting as described by b14572f72aac ("erec:
Fix input descriptors for included files"), this patch partially reverts
such partial.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/nftables.h |  1 +
 include/parser.h   |  3 ++-
 src/erec.c         | 35 +-----------------------------
 src/parser_bison.y |  1 +
 src/scanner.l      | 63 ++++++++++++++++++++++++++++++++++++------------------
 5 files changed, 47 insertions(+), 56 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index bb9bb2091716..af2c1ea16cfb 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -165,6 +165,7 @@ enum input_descriptor_types {
  * @line_offset:	offset of the current line to the beginning
  */
 struct input_descriptor {
+	struct list_head		list;
 	struct location			location;
 	enum input_descriptor_types	type;
 	const char			*name;
diff --git a/include/parser.h b/include/parser.h
index 8e57899eb1a3..a5ae802b288a 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -15,8 +15,9 @@
 
 struct parser_state {
 	struct input_descriptor		*indesc;
-	struct input_descriptor		indescs[MAX_INCLUDE_DEPTH];
+	struct input_descriptor		*indescs[MAX_INCLUDE_DEPTH];
 	unsigned int			indesc_idx;
+	struct list_head		indesc_list;
 
 	struct list_head		*msgs;
 	unsigned int			nerrs;
diff --git a/src/erec.c b/src/erec.c
index cf543a980bc0..c550a596b38c 100644
--- a/src/erec.c
+++ b/src/erec.c
@@ -34,50 +34,17 @@ static const char * const error_record_names[] = {
 	[EREC_ERROR]		= "Error"
 };
 
-static void input_descriptor_destroy(const struct input_descriptor *indesc)
-{
-	if (indesc->location.indesc &&
-	    indesc->location.indesc->type != INDESC_INTERNAL) {
-		input_descriptor_destroy(indesc->location.indesc);
-	}
-	if (indesc->name)
-		xfree(indesc->name);
-	xfree(indesc);
-}
-
-static struct input_descriptor *input_descriptor_dup(const struct input_descriptor *indesc)
-{
-	struct input_descriptor *dup_indesc;
-
-	dup_indesc = xmalloc(sizeof(struct input_descriptor));
-	*dup_indesc = *indesc;
-
-	if (indesc->location.indesc &&
-	    indesc->location.indesc->type != INDESC_INTERNAL)
-		dup_indesc->location.indesc = input_descriptor_dup(indesc->location.indesc);
-
-	if (indesc->name)
-		dup_indesc->name = xstrdup(indesc->name);
-
-	return dup_indesc;
-}
-
 void erec_add_location(struct error_record *erec, const struct location *loc)
 {
 	assert(erec->num_locations < EREC_LOCATIONS_MAX);
 	erec->locations[erec->num_locations] = *loc;
-	erec->locations[erec->num_locations].indesc = input_descriptor_dup(loc->indesc);
+	erec->locations[erec->num_locations].indesc = loc->indesc;
 	erec->num_locations++;
 }
 
 void erec_destroy(struct error_record *erec)
 {
-	unsigned int i;
-
 	xfree(erec->msg);
-	for (i = 0; i < erec->num_locations; i++) {
-		input_descriptor_destroy(erec->locations[i].indesc);
-	}
 	xfree(erec);
 }
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 62e76fe617c8..2a39db3148ef 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -50,6 +50,7 @@ void parser_init(struct nft_ctx *nft, struct parser_state *state,
 	state->scopes[0] = scope_init(&state->top_scope, NULL);
 	state->ectx.nft = nft;
 	state->ectx.msgs = msgs;
+	init_list_head(&state->indesc_list);
 }
 
 static void yyerror(struct location *loc, struct nft_ctx *nft, void *scanner,
diff --git a/src/scanner.l b/src/scanner.l
index 558bf9209853..d1f6e8799834 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -59,12 +59,12 @@
 static void scanner_pop_buffer(yyscan_t scanner);
 
 
-static void init_pos(struct parser_state *state)
+static void init_pos(struct input_descriptor *indesc)
 {
-	state->indesc->lineno		= 1;
-	state->indesc->column		= 1;
-	state->indesc->token_offset	= 0;
-	state->indesc->line_offset 	= 0;
+	indesc->lineno		= 1;
+	indesc->column		= 1;
+	indesc->token_offset	= 0;
+	indesc->line_offset 	= 0;
 }
 
 static void update_pos(struct parser_state *state, struct location *loc,
@@ -656,13 +656,14 @@ static void scanner_pop_buffer(yyscan_t scanner)
 	struct parser_state *state = yyget_extra(scanner);
 
 	yypop_buffer_state(scanner);
-	state->indesc = &state->indescs[--state->indesc_idx - 1];
+	state->indesc = state->indescs[--state->indesc_idx];
 }
 
 static struct error_record *scanner_push_file(struct nft_ctx *nft, void *scanner,
 					      const char *filename, const struct location *loc)
 {
 	struct parser_state *state = yyget_extra(scanner);
+	struct input_descriptor *indesc;
 	YY_BUFFER_STATE b;
 
 	if (state->indesc_idx == MAX_INCLUDE_DEPTH)
@@ -672,12 +673,18 @@ static struct error_record *scanner_push_file(struct nft_ctx *nft, void *scanner
 	b = yy_create_buffer(nft->f[state->indesc_idx], YY_BUF_SIZE, scanner);
 	yypush_buffer_state(b, scanner);
 
-	state->indesc = &state->indescs[state->indesc_idx++];
+	indesc = xzalloc(sizeof(struct input_descriptor));
+
 	if (loc != NULL)
-		state->indesc->location = *loc;
-	state->indesc->type	= INDESC_FILE;
-	state->indesc->name	= xstrdup(filename);
-	init_pos(state);
+		indesc->location = *loc;
+	indesc->type	= INDESC_FILE;
+	indesc->name	= xstrdup(filename);
+	init_pos(indesc);
+
+	state->indescs[state->indesc_idx] = indesc;
+	state->indesc = state->indescs[state->indesc_idx++];
+	list_add_tail(&indesc->list, &state->indesc_list);
+
 	return NULL;
 }
 
@@ -874,39 +881,52 @@ void scanner_push_buffer(void *scanner, const struct input_descriptor *indesc,
 	struct parser_state *state = yyget_extra(scanner);
 	YY_BUFFER_STATE b;
 
-	state->indesc = &state->indescs[state->indesc_idx++];
+	state->indesc = xzalloc(sizeof(struct input_descriptor));
+	state->indescs[state->indesc_idx] = state->indesc;
+	state->indesc_idx++;
+
 	memcpy(state->indesc, indesc, sizeof(*state->indesc));
 	state->indesc->data = buffer;
 	state->indesc->name = NULL;
+	list_add_tail(&state->indesc->list, &state->indesc_list);
 
 	b = yy_scan_string(buffer, scanner);
 	assert(b != NULL);
-	init_pos(state);
+	init_pos(state->indesc);
 }
 
 void *scanner_init(struct parser_state *state)
 {
 	yyscan_t scanner;
 
-	state->indesc = state->indescs;
-
 	yylex_init_extra(state, &scanner);
 	yyset_out(NULL, scanner);
 
 	return scanner;
 }
 
+static void input_descriptor_destroy(const struct input_descriptor *indesc)
+{
+	if (indesc->name)
+		xfree(indesc->name);
+	xfree(indesc);
+}
+
+static void input_descriptor_list_destroy(struct parser_state *state)
+{
+	struct input_descriptor *indesc, *next;
+
+	list_for_each_entry_safe(indesc, next, &state->indesc_list, list) {
+		list_del(&indesc->list);
+		input_descriptor_destroy(indesc);
+	}
+}
+
 void scanner_destroy(struct nft_ctx *nft)
 {
 	struct parser_state *state = yyget_extra(nft->scanner);
 
 	do {
-		struct input_descriptor *inpdesc =
-			&state->indescs[state->indesc_idx];
-		if (inpdesc && inpdesc->name) {
-			xfree(inpdesc->name);
-			inpdesc->name = NULL;
-		}
 		yypop_buffer_state(nft->scanner);
 
 		if (nft->f[state->indesc_idx]) {
@@ -915,5 +935,6 @@ void scanner_destroy(struct nft_ctx *nft)
 		}
 	} while (state->indesc_idx--);
 
+	input_descriptor_list_destroy(state);
 	yylex_destroy(nft->scanner);
 }
-- 
2.11.0

