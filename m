From: Eric Leblond <eric@regit.org>
Subject: [nft PATCH 6/7] scanner: free filename when destroying scanner
Date: Tue, 11 Jul 2017 00:32:54 +0200
Message-ID: <20170710223255.29885-7-eric@regit.org>
References: <20170710223255.29885-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:41162 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754928AbdGJWdT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jul 2017 18:33:19 -0400
In-Reply-To: <20170710223255.29885-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

To be able to do so we duplicate the name in the indesc if it is
set.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/erec.c    |  5 +++++
 src/scanner.l | 11 +++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/src/erec.c b/src/erec.c
index eacdd97..439add9 100644
--- a/src/erec.c
+++ b/src/erec.c
@@ -39,6 +39,8 @@ static void input_descriptor_destroy(const struct input_descriptor *indesc)
 	    indesc->location.indesc->type != INDESC_INTERNAL) {
 		input_descriptor_destroy(indesc->location.indesc);
 	}
+	if (indesc->name)
+		xfree(indesc->name);
 	xfree(indesc);
 }
 
@@ -53,6 +55,9 @@ static struct input_descriptor *input_descriptor_dup(const struct input_descript
 	    indesc->location.indesc->type != INDESC_INTERNAL)
 		dup_indesc->location.indesc = input_descriptor_dup(indesc->location.indesc);
 
+	if (indesc->name)
+		dup_indesc->name = xstrdup(indesc->name);
+
 	return dup_indesc;
 }
 
diff --git a/src/scanner.l b/src/scanner.l
index 86a03f3..7d5437f 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -835,6 +835,7 @@ void scanner_push_buffer(void *scanner, const struct input_descriptor *indesc,
 	state->indesc = &state->indescs[state->indesc_idx++];
 	memcpy(state->indesc, indesc, sizeof(*state->indesc));
 	state->indesc->data = buffer;
+	state->indesc->name = NULL;
 
 	b = yy_scan_string(buffer, scanner);
 	assert(b != NULL);
@@ -858,9 +859,15 @@ void scanner_destroy(struct parser_state *scanner)
 {
 	struct parser_state *state = yyget_extra(scanner);
 
-	/* Can't free indesc name - locations might still be in use */
-	while (state->indesc_idx--)
+	do {
+		struct input_descriptor *inpdesc =
+			&state->indescs[state->indesc_idx];
+		if (inpdesc && inpdesc->name) {
+			xfree(inpdesc->name);
+			inpdesc->name = NULL;
+		}
 		yypop_buffer_state(scanner);
+	} while (state->indesc_idx--);
 
 	yylex_destroy(scanner);
 }
-- 
2.13.2

