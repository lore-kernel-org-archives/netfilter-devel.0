Return-Path: <SRS0=nYb5=ZV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C51C6C432C0
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Nov 2019 14:32:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A089B21736
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Nov 2019 14:32:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfK2OcF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Nov 2019 09:32:05 -0500
Received: from 195-154-211-226.rev.poneytelecom.eu ([195.154.211.226]:46678
        "EHLO flash.glorub.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfK2OcF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Nov 2019 09:32:05 -0500
Received: from eric by flash.glorub.net with local (Exim 4.89)
        (envelope-from <ejallot@gmail.com>)
        id 1iahJT-0000HV-Da; Fri, 29 Nov 2019 15:32:03 +0100
From:   Eric Jallot <ejallot@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Eric Jallot <ejallot@gmail.com>
Subject: [PATCH v2 nft] scanner: fix out-of-bound memory write in include_file()
Date:   Fri, 29 Nov 2019 15:30:39 +0100
Message-Id: <20191129143039.880-1-ejallot@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Before patch:
 # echo 'include "/tmp/rules.nft"' > /tmp/rules.nft
 # nft -f /tmp/rules.nft
 In file included from /tmp/rules.nft:1:1-25:
                  from /tmp/rules.nft:1:1-25:
 [snip]
                  from /tmp/rules.nft:1:1-25:
 /tmp/rules.nft:1:1-25: Error: Include nested too deeply, max 16 levels
 include "/tmp/rules.nft"
 ^^^^^^^^^^^^^^^^^^^^^^^^^
 double free or corruption (out)
 Aborted (core dumped)

valgrind reports:

==8856== Invalid write of size 8
==8856==    at 0x4E8FCAF: include_file (scanner.l:718)
==8856==    by 0x4E8FEF6: include_glob (scanner.l:793)
==8856==    by 0x4E9985D: scanner_include_file (scanner.l:875)
==8856==    by 0x4E89D7A: nft_parse (parser_bison.y:828)
==8856==    by 0x4E765E1: nft_parse_bison_filename (libnftables.c:394)
==8856==    by 0x4E765E1: nft_run_cmd_from_filename (libnftables.c:497)
==8856==    by 0x40172D: main (main.c:340)

So perform bounds checking on MAX_INCLUDE_DEPTH before writing.

After patch:
 # nft -f /tmp/rules.nft
 In file included from /tmp/rules.nft:1:1-25:
                  from /tmp/rules.nft:1:1-25:
 [snip]
                  from /tmp/rules.nft:1:1-25:
 /tmp/rules.nft:1:1-25: Error: Include nested too deeply, max 16 levels
 include "/tmp/rules.nft"
 ^^^^^^^^^^^^^^^^^^^^^^^^^
 # echo $?
 1

Also:
Update scanner_push_file() function definition accordingly.

Fixes: 32325e3c3fab4 ("libnftables: Store top_scope in struct nft_ctx")
Signed-off-by: Eric Jallot <ejallot@gmail.com>
---
 src/scanner.l | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/src/scanner.l b/src/scanner.l
index 80b5a5f0dafc..d32adf4897ae 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -672,17 +672,13 @@ static void scanner_pop_buffer(yyscan_t scanner)
 	state->indesc = state->indescs[--state->indesc_idx];
 }
 
-static struct error_record *scanner_push_file(struct nft_ctx *nft, void *scanner,
-					      const char *filename, const struct location *loc)
+static void scanner_push_file(struct nft_ctx *nft, void *scanner,
+			      const char *filename, const struct location *loc)
 {
 	struct parser_state *state = yyget_extra(scanner);
 	struct input_descriptor *indesc;
 	YY_BUFFER_STATE b;
 
-	if (state->indesc_idx == MAX_INCLUDE_DEPTH)
-		return error(loc, "Include nested too deeply, max %u levels",
-			     MAX_INCLUDE_DEPTH);
-
 	b = yy_create_buffer(nft->f[state->indesc_idx], YY_BUF_SIZE, scanner);
 	yypush_buffer_state(b, scanner);
 
@@ -697,8 +693,6 @@ static struct error_record *scanner_push_file(struct nft_ctx *nft, void *scanner
 	state->indescs[state->indesc_idx] = indesc;
 	state->indesc = state->indescs[state->indesc_idx++];
 	list_add_tail(&indesc->list, &state->indesc_list);
-
-	return NULL;
 }
 
 static int include_file(struct nft_ctx *nft, void *scanner,
@@ -708,6 +702,12 @@ static int include_file(struct nft_ctx *nft, void *scanner,
 	struct error_record *erec;
 	FILE *f;
 
+	if (state->indesc_idx == MAX_INCLUDE_DEPTH) {
+		erec = error(loc, "Include nested too deeply, max %u levels",
+			     MAX_INCLUDE_DEPTH);
+		goto err;
+	}
+
 	f = fopen(filename, "r");
 	if (f == NULL) {
 		erec = error(loc, "Could not open file \"%s\": %s\n",
@@ -715,10 +715,7 @@ static int include_file(struct nft_ctx *nft, void *scanner,
 		goto err;
 	}
 	nft->f[state->indesc_idx] = f;
-
-	erec = scanner_push_file(nft, scanner, filename, loc);
-	if (erec != NULL)
-		goto err;
+	scanner_push_file(nft, scanner, filename, loc);
 	return 0;
 err:
 	erec_queue(erec, state->msgs);
-- 
2.11.0

