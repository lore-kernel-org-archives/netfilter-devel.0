Return-Path: <SRS0=zMD2=26=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A70D9C33CA1
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Jan 2020 17:21:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 876DA2067D
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Jan 2020 17:21:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387864AbgAIRVZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Jan 2020 12:21:25 -0500
Received: from correo.us.es ([193.147.175.20]:58610 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731620AbgAIRVY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Jan 2020 12:21:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 88CF5E8D81
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2020 18:21:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7A1BEDA709
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2020 18:21:22 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6FDD6DA702; Thu,  9 Jan 2020 18:21:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6ED16DA711
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2020 18:21:20 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 09 Jan 2020 18:21:20 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 5A29B42EE38E
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2020 18:21:20 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/3] main: split parsing from libnftables initialization
Date:   Thu,  9 Jan 2020 18:21:14 +0100
Message-Id: <20200109172115.229723-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200109172115.229723-1-pablo@netfilter.org>
References: <20200109172115.229723-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Parse options first, then initialize the nft context object.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/main.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/src/main.c b/src/main.c
index 6ab1b89f4dd5..0f2b57cbacbb 100644
--- a/src/main.c
+++ b/src/main.c
@@ -247,18 +247,14 @@ static bool nft_options_check(int argc, char * const argv[])
 
 int main(int argc, char * const *argv)
 {
-	char *buf = NULL, *filename = NULL;
-	unsigned int output_flags = 0;
-	bool interactive = false;
-	unsigned int debug_mask;
-	unsigned int len;
+	char *buf = NULL, *filename = NULL, *includepath = NULL;
+	unsigned int output_flags = 0, debug_mask = 0, len;
+	bool interactive = false, dry_run = false;
 	int i, val, rc;
 
 	if (!nft_options_check(argc, argv))
 		exit(EXIT_FAILURE);
 
-	nft = nft_ctx_new(NFT_CTX_DEFAULT);
-
 	while (1) {
 		val = getopt_long(argc, argv, OPTSTRING, options, NULL);
 		if (val == -1)
@@ -273,7 +269,7 @@ int main(int argc, char * const *argv)
 			       PACKAGE_NAME, PACKAGE_VERSION, RELEASE_NAME);
 			exit(EXIT_SUCCESS);
 		case OPT_CHECK:
-			nft_ctx_set_dry_run(nft, true);
+			dry_run = true;
 			break;
 		case OPT_FILE:
 			filename = optarg;
@@ -282,12 +278,7 @@ int main(int argc, char * const *argv)
 			interactive = true;
 			break;
 		case OPT_INCLUDEPATH:
-			if (nft_ctx_add_include_path(nft, optarg)) {
-				fprintf(stderr,
-					"Failed to add include path '%s'\n",
-					optarg);
-				exit(EXIT_FAILURE);
-			}
+			includepath = optarg;
 			break;
 		case OPT_NUMERIC:
 			output_flags |= NFT_CTX_OUTPUT_NUMERIC_ALL;
@@ -302,7 +293,6 @@ int main(int argc, char * const *argv)
 			output_flags |= NFT_CTX_OUTPUT_SERVICE;
 			break;
 		case OPT_DEBUG:
-			debug_mask = nft_ctx_output_get_debug(nft);
 			for (;;) {
 				unsigned int i;
 				char *end;
@@ -328,7 +318,6 @@ int main(int argc, char * const *argv)
 					break;
 				optarg = end + 1;
 			}
-			nft_ctx_output_set_debug(nft, debug_mask);
 			break;
 		case OPT_HANDLE_OUTPUT:
 			output_flags |= NFT_CTX_OUTPUT_HANDLE;
@@ -364,6 +353,14 @@ int main(int argc, char * const *argv)
 		}
 	}
 
+	nft = nft_ctx_new(NFT_CTX_DEFAULT);
+	if (includepath && nft_ctx_add_include_path(nft, includepath) < 0) {
+		fprintf(stderr, "Failed to add include path '%s'\n", optarg);
+		exit(EXIT_FAILURE);
+	}
+
+	nft_ctx_set_dry_run(nft, dry_run);
+	nft_ctx_output_set_debug(nft, debug_mask);
 	nft_ctx_output_set_flags(nft, output_flags);
 
 	if (optind != argc) {
-- 
2.11.0

