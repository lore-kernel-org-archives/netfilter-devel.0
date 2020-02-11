Return-Path: <SRS0=wrU5=37=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C817C3B187
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Feb 2020 20:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E813B20708
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Feb 2020 20:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731814AbgBKUXS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Feb 2020 15:23:18 -0500
Received: from correo.us.es ([193.147.175.20]:39192 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731807AbgBKUXS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Feb 2020 15:23:18 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 33143EBACB
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Feb 2020 21:23:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 25AFDDA705
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Feb 2020 21:23:18 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1B5C7DA710; Tue, 11 Feb 2020 21:23:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 28C5BDA707;
        Tue, 11 Feb 2020 21:23:16 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 11 Feb 2020 21:23:16 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id F111342EF9E0;
        Tue, 11 Feb 2020 21:23:15 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fasnacht@protonmail.ch
Subject: [PATCH nft 1/4] scanner: call scanner_push_file() after scanner_push_file()
Date:   Tue, 11 Feb 2020 21:23:05 +0100
Message-Id: <20200211202308.90575-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200211202308.90575-1-pablo@netfilter.org>
References: <20200211202308.90575-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Update include_file() to return FILE *.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/scanner.l | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/src/scanner.l b/src/scanner.l
index ecf2354e3c2f..fe70df5c18ec 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -714,8 +714,8 @@ static void scanner_push_file(struct nft_ctx *nft, void *scanner,
 	scanner_push_indesc(state, indesc);
 }
 
-static int include_file(struct nft_ctx *nft, void *scanner,
-			const char *filename, const struct location *loc)
+static FILE *include_file(struct nft_ctx *nft, void *scanner,
+			  const char *filename, const struct location *loc)
 {
 	struct parser_state *state = yyget_extra(scanner);
 	struct error_record *erec;
@@ -733,11 +733,11 @@ static int include_file(struct nft_ctx *nft, void *scanner,
 			     filename, strerror(errno));
 		goto err;
 	}
-	scanner_push_file(nft, scanner, f, filename, loc);
-	return 0;
+
+	return f;
 err:
 	erec_queue(erec, state->msgs);
-	return -1;
+	return NULL;
 }
 
 static int include_glob(struct nft_ctx *nft, void *scanner, const char *pattern,
@@ -749,6 +749,7 @@ static int include_glob(struct nft_ctx *nft, void *scanner, const char *pattern,
 	glob_t glob_data;
 	unsigned int i;
 	int flags = 0;
+	FILE *f;
 	int ret;
 	char *p;
 
@@ -804,9 +805,11 @@ static int include_glob(struct nft_ctx *nft, void *scanner, const char *pattern,
 			if (len == 0 || path[len - 1] == '/')
 				continue;
 
-			ret = include_file(nft, scanner, path, loc);
-			if (ret != 0)
+			f = include_file(nft, scanner, path, loc);
+			if (!f)
 				goto err;
+
+			scanner_push_file(nft, scanner, f, path, loc);
 		}
 
 		globfree(&glob_data);
@@ -841,7 +844,14 @@ err:
 int scanner_read_file(struct nft_ctx *nft, const char *filename,
 		      const struct location *loc)
 {
-	return include_file(nft, nft->scanner, filename, loc);
+	FILE *f;
+
+	f = include_file(nft, nft->scanner, filename, loc);
+	if (!f)
+		return -1;
+
+	scanner_push_file(nft, nft->scanner, f, filename, loc);
+	return 0;
 }
 
 static bool search_in_include_path(const char *filename)
-- 
2.11.0

