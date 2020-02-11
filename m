Return-Path: <SRS0=wrU5=37=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4784C35242
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Feb 2020 20:23:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E95020708
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Feb 2020 20:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731718AbgBKUXU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Feb 2020 15:23:20 -0500
Received: from correo.us.es ([193.147.175.20]:39198 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731810AbgBKUXT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Feb 2020 15:23:19 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8A134EBAC3
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Feb 2020 21:23:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7B280DA707
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Feb 2020 21:23:19 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 70C6DDA703; Tue, 11 Feb 2020 21:23:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7D780DA70E;
        Tue, 11 Feb 2020 21:23:17 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 11 Feb 2020 21:23:17 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 54F8A42EF9E0;
        Tue, 11 Feb 2020 21:23:17 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fasnacht@protonmail.ch
Subject: [PATCH nft 3/4] scanner: call scanner_push_indesc() after scanner_push_file()
Date:   Tue, 11 Feb 2020 21:23:07 +0100
Message-Id: <20200211202308.90575-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200211202308.90575-1-pablo@netfilter.org>
References: <20200211202308.90575-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Just a preparation patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/scanner.l | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/src/scanner.l b/src/scanner.l
index 56f6e9956791..9584f61c489c 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -707,19 +707,16 @@ static void scanner_pop_buffer(yyscan_t scanner)
 	scanner_pop_indesc(state);
 }
 
-static void scanner_push_file(struct nft_ctx *nft, void *scanner,
-			      FILE *f, const char *filename,
-			      const struct location *loc)
+static struct input_descriptor *
+scanner_push_file(struct nft_ctx *nft, void *scanner, FILE *f,
+		  const char *filename, const struct location *loc)
 {
-	struct parser_state *state = yyget_extra(scanner);
-	struct input_descriptor *indesc;
 	YY_BUFFER_STATE b;
 
 	b = yy_create_buffer(f, YY_BUF_SIZE, scanner);
 	yypush_buffer_state(b, scanner);
 
-	indesc = indesc_file_alloc(f, filename, loc);
-	scanner_push_indesc(state, indesc);
+	return indesc_file_alloc(f, filename, loc);
 }
 
 static FILE *include_file(struct nft_ctx *nft, void *scanner,
@@ -805,6 +802,7 @@ static int include_glob(struct nft_ctx *nft, void *scanner, const char *pattern,
 
 		/* reverse alphabetical order due to stack */
 		for (i = glob_data.gl_pathc; i > 0; i--) {
+			struct input_descriptor *indesc;
 
 			path = glob_data.gl_pathv[i-1];
 
@@ -817,7 +815,8 @@ static int include_glob(struct nft_ctx *nft, void *scanner, const char *pattern,
 			if (!f)
 				goto err;
 
-			scanner_push_file(nft, scanner, f, path, loc);
+			indesc = scanner_push_file(nft, scanner, f, path, loc);
+			scanner_push_indesc(state, indesc);
 		}
 
 		globfree(&glob_data);
@@ -852,13 +851,17 @@ err:
 int scanner_read_file(struct nft_ctx *nft, const char *filename,
 		      const struct location *loc)
 {
+	struct parser_state *state = yyget_extra(nft->scanner);
+	struct input_descriptor *indesc;
 	FILE *f;
 
 	f = include_file(nft, nft->scanner, filename, loc);
 	if (!f)
 		return -1;
 
-	scanner_push_file(nft, nft->scanner, f, filename, loc);
+	indesc = scanner_push_file(nft, nft->scanner, f, filename, loc);
+	scanner_push_indesc(state, indesc);
+
 	return 0;
 }
 
-- 
2.11.0

