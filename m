Return-Path: <SRS0=wrU5=37=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED1A4C352A3
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Feb 2020 20:23:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9EAF20708
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Feb 2020 20:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731812AbgBKUXV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Feb 2020 15:23:21 -0500
Received: from correo.us.es ([193.147.175.20]:39214 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731807AbgBKUXU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Feb 2020 15:23:20 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 270C5EBACB
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Feb 2020 21:23:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1786CDA709
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Feb 2020 21:23:20 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0D2E2DA705; Tue, 11 Feb 2020 21:23:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F1F12DA701;
        Tue, 11 Feb 2020 21:23:17 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 11 Feb 2020 21:23:17 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id CE4C742EF9E0;
        Tue, 11 Feb 2020 21:23:17 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fasnacht@protonmail.ch
Subject: [PATCH nft 4/4] scanner: multi-level input file stack for glob
Date:   Tue, 11 Feb 2020 21:23:08 +0100
Message-Id: <20200211202308.90575-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200211202308.90575-1-pablo@netfilter.org>
References: <20200211202308.90575-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch updates indesc_list to become an array of stacks. Each stack
represents the files that have been included at this depth.

The scanner_add_indesc() function adds the indesc to this depth, this is
called in case the user specifies wildcards.

Otherwise, the scanner_push_indesc() function for regular inclusion.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/list.h     | 30 +++++++++++++++++++++++++++++
 include/parser.h   |  3 +--
 src/parser_bison.y |  5 ++++-
 src/scanner.l      | 55 ++++++++++++++++++++++++++++++++++++++++--------------
 4 files changed, 76 insertions(+), 17 deletions(-)

diff --git a/include/list.h b/include/list.h
index 75d292124010..29f5ca739632 100644
--- a/include/list.h
+++ b/include/list.h
@@ -22,6 +22,17 @@ struct list_head {
 	struct list_head *next, *prev;
 };
 
+/**
+ * list_is_first -- tests whether @list is the first entry in list @head
+ * @list: the entry to test
+ * @head: the head of the list
+ */
+static inline int list_is_first(const struct list_head *list,
+				const struct list_head *head)
+{
+	return list->prev == head;
+}
+
 #define LIST_HEAD_INIT(name) { &(name), &(name) }
 
 #define LIST_HEAD(name) \
@@ -623,3 +634,22 @@ static inline void hlist_add_after(struct hlist_node *n,
 	     pos = n)
 
 #endif
+
+/**
+ * list_prev_entry - get the prev element in list
+ * @pos:        the type * to cursor
+ * @member:     the name of the list_head within the struct.
+ */
+#define list_prev_entry(pos, member) \
+	list_entry((pos)->member.prev, typeof(*(pos)), member)
+
+/**
+ * list_last_entry - get the last element from a list
+ * @ptr:        the list head to take the element from.
+ * @type:       the type of the struct this is embedded in.
+ * @member:     the name of the list_head within the struct.
+ *
+ * Note, that list is expected to be not empty.
+ */
+#define list_last_entry(ptr, type, member) \
+	list_entry((ptr)->prev, type, member)
diff --git a/include/parser.h b/include/parser.h
index 949284d9466c..d24133059203 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -15,9 +15,8 @@
 
 struct parser_state {
 	struct input_descriptor		*indesc;
-	struct input_descriptor		*indescs[MAX_INCLUDE_DEPTH];
 	unsigned int			indesc_idx;
-	struct list_head		indesc_list;
+	struct list_head		indesc_list[MAX_INCLUDE_DEPTH];
 
 	struct list_head		*msgs;
 	unsigned int			nerrs;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index f5d7026a8574..216126472687 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -45,11 +45,14 @@ void parser_init(struct nft_ctx *nft, struct parser_state *state,
 		 struct list_head *msgs, struct list_head *cmds,
 		 struct scope *top_scope)
 {
+	int i;
+
 	memset(state, 0, sizeof(*state));
 	state->msgs = msgs;
 	state->cmds = cmds;
 	state->scopes[0] = scope_init(top_scope, NULL);
-	init_list_head(&state->indesc_list);
+	for (i = 0; i < MAX_INCLUDE_DEPTH; i++)
+		init_list_head(&state->indesc_list[i]);
 }
 
 static void yyerror(struct location *loc, struct nft_ctx *nft, void *scanner,
diff --git a/src/scanner.l b/src/scanner.l
index 9584f61c489c..9a6734dd4ec4 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -681,22 +681,44 @@ indesc_file_alloc(FILE *f, const char *filename, const struct location *loc)
 	return indesc;
 }
 
+static inline struct list_head *indesc_list(struct parser_state *state)
+{
+	return &state->indesc_list[state->indesc_idx];
+}
+
 static void scanner_push_indesc(struct parser_state *state,
 				struct input_descriptor *indesc)
 {
-	state->indescs[state->indesc_idx] = indesc;
-	state->indesc = state->indescs[state->indesc_idx++];
-	list_add_tail(&indesc->list, &state->indesc_list);
+	state->indesc = indesc;
+	list_add_tail(&indesc->list, indesc_list(state));
+	state->indesc_idx++;
+}
+
+static void scanner_add_indesc(struct parser_state *state,
+			       struct input_descriptor *indesc)
+{
+	state->indesc = indesc;
+	list_add_tail(&indesc->list, indesc_list(state));
 }
 
 static void scanner_pop_indesc(struct parser_state *state)
 {
-	state->indesc_idx--;
+	if (list_empty(indesc_list(state)))
+		state->indesc_idx--;
 
-	if (state->indesc_idx > 0)
-		state->indesc = state->indescs[state->indesc_idx - 1];
-	else
+	if (state->indesc_idx == 0) {
 		state->indesc = NULL;
+		return;
+	}
+
+	if (list_is_first(&state->indesc->list, indesc_list(state))) {
+		state->indesc_idx--;
+		state->indesc =
+			list_last_entry(indesc_list(state),
+					struct input_descriptor, list);
+	} else {
+		state->indesc = list_prev_entry(state->indesc, list);
+	}
 }
 
 static void scanner_pop_buffer(yyscan_t scanner)
@@ -816,8 +838,10 @@ static int include_glob(struct nft_ctx *nft, void *scanner, const char *pattern,
 				goto err;
 
 			indesc = scanner_push_file(nft, scanner, f, path, loc);
-			scanner_push_indesc(state, indesc);
+			scanner_add_indesc(state, indesc);
 		}
+		if (glob_data.gl_pathc)
+			state->indesc_idx++;
 
 		globfree(&glob_data);
 
@@ -962,14 +986,17 @@ static void input_descriptor_destroy(const struct input_descriptor *indesc)
 static void input_descriptor_list_destroy(struct parser_state *state)
 {
 	struct input_descriptor *indesc, *next;
+	int i;
 
-	list_for_each_entry_safe(indesc, next, &state->indesc_list, list) {
-		if (indesc->f) {
-			fclose(indesc->f);
-			indesc->f = NULL;
+	for (i = 0; i < MAX_INCLUDE_DEPTH; i++) {
+		list_for_each_entry_safe(indesc, next, &state->indesc_list[i], list) {
+			if (indesc->f) {
+				fclose(indesc->f);
+				indesc->f = NULL;
+			}
+			list_del(&indesc->list);
+			input_descriptor_destroy(indesc);
 		}
-		list_del(&indesc->list);
-		input_descriptor_destroy(indesc);
 	}
 }
 
-- 
2.11.0

