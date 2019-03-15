Return-Path: <SRS0=WWTr=RS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B925C43381
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Mar 2019 10:55:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AC6D21871
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Mar 2019 10:55:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbfCOKzK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Mar 2019 06:55:10 -0400
Received: from mail.us.es ([193.147.175.20]:35740 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728948AbfCOKzJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Mar 2019 06:55:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AF516F26FA
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2019 11:55:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 956B2DA84E
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2019 11:55:06 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 92C52DA797; Fri, 15 Mar 2019 11:55:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B5D30DA84E;
        Fri, 15 Mar 2019 11:55:02 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 15 Mar 2019 11:55:02 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8FCBE4265A2F;
        Fri, 15 Mar 2019 11:55:02 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     vaclav.zindulka@tlapnet.cz
Subject: [PATCH nft] src: file descriptor leak in include_file()
Date:   Fri, 15 Mar 2019 11:54:59 +0100
Message-Id: <20190315105459.15066-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

File that contains the ruleset is never closed, track open files through
the nft_ctx object and close them accordingly.

Reported-by: Václav Zindulka <vaclav.zindulka@tlapnet.cz>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/nftables.h |  3 +++
 include/parser.h   |  7 ++++---
 src/libnftables.c  |  6 +++---
 src/scanner.l      | 36 ++++++++++++++++++++----------------
 4 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index 5c0292615b3f..b17a16a4adef 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -86,6 +86,8 @@ struct nft_cache {
 struct mnl_socket;
 struct parser_state;
 
+#define MAX_INCLUDE_DEPTH	16
+
 struct nft_ctx {
 	struct mnl_socket	*nf_sock;
 	char			**include_paths;
@@ -99,6 +101,7 @@ struct nft_ctx {
 	struct parser_state	*state;
 	void			*scanner;
 	void			*json_root;
+	FILE			*f[MAX_INCLUDE_DEPTH];
 };
 
 enum nftables_exit_codes {
diff --git a/include/parser.h b/include/parser.h
index ea41ca038a02..bd2d08c8b7c6 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -3,8 +3,8 @@
 
 #include <list.h>
 #include <rule.h> // FIXME
+#include <nftables.h>
 
-#define MAX_INCLUDE_DEPTH		16
 #define TABSIZE				8
 
 #define YYLTYPE				struct location
@@ -36,9 +36,10 @@ extern void parser_init(struct nft_ctx *nft, struct parser_state *state,
 extern int nft_parse(struct nft_ctx *ctx, void *, struct parser_state *state);
 
 extern void *scanner_init(struct parser_state *state);
-extern void scanner_destroy(void *scanner);
+extern void scanner_destroy(struct nft_ctx *nft, void *scanner);
 
-extern int scanner_read_file(void *scanner, const char *filename,
+extern int scanner_read_file(struct nft_ctx *nft, void *scanner,
+			     const char *filename,
 			     const struct location *loc);
 extern int scanner_include_file(struct nft_ctx *ctx, void *scanner,
 				const char *filename,
diff --git a/src/libnftables.c b/src/libnftables.c
index 2271d270fd57..62ddb0dd5991 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -364,7 +364,7 @@ static int nft_parse_bison_filename(struct nft_ctx *nft, const char *filename,
 
 	parser_init(nft, nft->state, msgs, cmds);
 	nft->scanner = scanner_init(nft->state);
-	if (scanner_read_file(nft->scanner, filename, &internal_location) < 0)
+	if (scanner_read_file(nft, nft->scanner, filename, &internal_location) < 0)
 		return -1;
 
 	ret = nft_parse(nft, nft->scanner, nft->state);
@@ -405,7 +405,7 @@ err:
 	}
 	iface_cache_release();
 	if (nft->scanner) {
-		scanner_destroy(nft->scanner);
+		scanner_destroy(nft, nft->scanner);
 		nft->scanner = NULL;
 	}
 	free(nlbuf);
@@ -449,7 +449,7 @@ err:
 	}
 	iface_cache_release();
 	if (nft->scanner) {
-		scanner_destroy(nft->scanner);
+		scanner_destroy(nft, nft->scanner);
 		nft->scanner = NULL;
 	}
 
diff --git a/src/scanner.l b/src/scanner.l
index 6f83aa1198cc..0de635f5bdc9 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -659,19 +659,17 @@ static void scanner_pop_buffer(yyscan_t scanner)
 	state->indesc = &state->indescs[--state->indesc_idx - 1];
 }
 
-static struct error_record *scanner_push_file(void *scanner, const char *filename,
-					      FILE *f, const struct location *loc)
+static struct error_record *scanner_push_file(struct nft_ctx *nft, void *scanner,
+					      const char *filename, const struct location *loc)
 {
 	struct parser_state *state = yyget_extra(scanner);
 	YY_BUFFER_STATE b;
 
-	if (state->indesc_idx == MAX_INCLUDE_DEPTH) {
-		fclose(f);
+	if (state->indesc_idx == MAX_INCLUDE_DEPTH)
 		return error(loc, "Include nested too deeply, max %u levels",
 			     MAX_INCLUDE_DEPTH);
-	}
 
-	b = yy_create_buffer(f, YY_BUF_SIZE, scanner);
+	b = yy_create_buffer(nft->f[state->indesc_idx], YY_BUF_SIZE, scanner);
 	yypush_buffer_state(b, scanner);
 
 	state->indesc = &state->indescs[state->indesc_idx++];
@@ -683,8 +681,8 @@ static struct error_record *scanner_push_file(void *scanner, const char *filenam
 	return NULL;
 }
 
-static int include_file(void *scanner, const char *filename,
-			const struct location *loc)
+static int include_file(struct nft_ctx *nft, void *scanner,
+			const char *filename, const struct location *loc)
 {
 	struct parser_state *state = yyget_extra(scanner);
 	struct error_record *erec;
@@ -696,8 +694,9 @@ static int include_file(void *scanner, const char *filename,
 			     filename, strerror(errno));
 		goto err;
 	}
+	nft->f[state->indesc_idx] = f;
 
-	erec = scanner_push_file(scanner, filename, f, loc);
+	erec = scanner_push_file(nft, scanner, filename, loc);
 	if (erec != NULL)
 		goto err;
 	return 0;
@@ -706,7 +705,7 @@ err:
 	return -1;
 }
 
-static int include_glob(void *scanner, const char *pattern,
+static int include_glob(struct nft_ctx *nft, void *scanner, const char *pattern,
 			const struct location *loc)
 {
 	struct parser_state *state = yyget_extra(scanner);
@@ -770,7 +769,7 @@ static int include_glob(void *scanner, const char *pattern,
 			if (len == 0 || path[len - 1] == '/')
 				continue;
 
-			ret = include_file(scanner, path, loc);
+			ret = include_file(nft, scanner, path, loc);
 			if (ret != 0)
 				goto err;
 		}
@@ -804,10 +803,10 @@ err:
 	return -1;
 }
 
-int scanner_read_file(void *scanner, const char *filename,
+int scanner_read_file(struct nft_ctx *nft, void *scanner, const char *filename,
 		      const struct location *loc)
 {
-	return include_file(scanner, filename, loc);
+	return include_file(nft, scanner, filename, loc);
 }
 
 static bool search_in_include_path(const char *filename)
@@ -837,7 +836,7 @@ int scanner_include_file(struct nft_ctx *nft, void *scanner,
 				return -1;
 			}
 
-			ret = include_glob(scanner, buf, loc);
+			ret = include_glob(nft, scanner, buf, loc);
 
 			/* error was already handled */
 			if (ret == -1)
@@ -852,7 +851,7 @@ int scanner_include_file(struct nft_ctx *nft, void *scanner,
 		}
 	} else {
 		/* an absolute path (starts with '/') */
-		ret = include_glob(scanner, filename, loc);
+		ret = include_glob(nft, scanner, filename, loc);
 	}
 
 	/* handle the case where no file was found */
@@ -897,7 +896,7 @@ void *scanner_init(struct parser_state *state)
 	return scanner;
 }
 
-void scanner_destroy(void *scanner)
+void scanner_destroy(struct nft_ctx *nft, void *scanner)
 {
 	struct parser_state *state = yyget_extra(scanner);
 
@@ -909,6 +908,11 @@ void scanner_destroy(void *scanner)
 			inpdesc->name = NULL;
 		}
 		yypop_buffer_state(scanner);
+
+		if (nft->f[state->indesc_idx]) {
+			fclose(nft->f[state->indesc_idx]);
+			nft->f[state->indesc_idx] = NULL;
+		}
 	} while (state->indesc_idx--);
 
 	yylex_destroy(scanner);
-- 
2.11.0

