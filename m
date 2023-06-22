Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F8A7EB64DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Jun 2023 15:46:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbjFVPqv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Jun 2023 11:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjFVPqu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Jun 2023 11:46:50 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28DD10F6
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Jun 2023 08:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SuKmGyBf0YUho74avx7kM8nAcXvPdCGqpyJAbo7C9Jg=; b=ZGV9ifhbCNqpKF14T+fGr/1y5U
        Wc0aTNU8yYNZ8IRBj3zTA3lblJ8oyYsPx/XkBJLRXZLA2VdlMkwl2gdIdjBjtrePRNYUbLX7Zol0w
        bA6N1yW1fqYMDKDBmIPRUOfrSR2mBd0DjbHs15g7MsFXYJoXARRmB1bWbbYxT2I7n4Zbvl+D6D0qt
        VK0EiSAZ3QEFpExncMz86eZ/oqVpQ4cJFOVarobtX2+d2MYzdzAlS6z+OH8U5R7UxFLtuDCchWRhv
        FP03kywppymfqpXJt6sRjz8r9msTyrrZs7N7mzJtbbyYd5XzjxLlftqPHydWEAl4+pM2+0cjlyg8a
        10nQXUUw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qCMWG-0001sM-9G; Thu, 22 Jun 2023 17:46:48 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/4] main: Call nft_ctx_free() before exiting
Date:   Thu, 22 Jun 2023 17:46:32 +0200
Message-Id: <20230622154634.25862-3-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230622154634.25862-1-phil@nwl.cc>
References: <20230622154634.25862-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Introduce labels for failure and regular exit so all direct exit() calls
after nft_ctx allocation may be replaced by a single goto statement.

Simply drop that return call in interactive branch, code will continue
at 'out' label naturally.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/main.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/src/main.c b/src/main.c
index a1592c1823f49..40dc60c2258cc 100644
--- a/src/main.c
+++ b/src/main.c
@@ -362,10 +362,10 @@ int main(int argc, char * const *argv)
 	bool interactive = false, define = false;
 	const char *optstring = get_optstring();
 	unsigned int output_flags = 0;
+	int i, val, rc = EXIT_SUCCESS;
 	unsigned int debug_mask;
 	char *filename = NULL;
 	unsigned int len;
-	int i, val, rc;
 
 	/* nftables cannot be used with setuid in a safe way. */
 	if (getuid() != geteuid())
@@ -384,20 +384,20 @@ int main(int argc, char * const *argv)
 		switch (val) {
 		case OPT_HELP:
 			show_help(argv[0]);
-			exit(EXIT_SUCCESS);
+			goto out;
 		case OPT_VERSION:
 			printf("%s v%s (%s)\n",
 			       PACKAGE_NAME, PACKAGE_VERSION, RELEASE_NAME);
-			exit(EXIT_SUCCESS);
+			goto out;
 		case OPT_VERSION_LONG:
 			show_version();
-			exit(EXIT_SUCCESS);
+			goto out;
 		case OPT_DEFINE:
 			if (nft_ctx_add_var(nft, optarg)) {
 				fprintf(stderr,
 					"Failed to define variable '%s'\n",
 					optarg);
-				exit(EXIT_FAILURE);
+				goto out_fail;
 			}
 			define = true;
 			break;
@@ -408,7 +408,7 @@ int main(int argc, char * const *argv)
 			if (interactive) {
 				fprintf(stderr,
 					"Error: -i/--interactive and -f/--file options cannot be combined\n");
-				exit(EXIT_FAILURE);
+				goto out_fail;
 			}
 			filename = optarg;
 			break;
@@ -416,7 +416,7 @@ int main(int argc, char * const *argv)
 			if (filename) {
 				fprintf(stderr,
 					"Error: -i/--interactive and -f/--file options cannot be combined\n");
-				exit(EXIT_FAILURE);
+				goto out_fail;
 			}
 			interactive = true;
 			break;
@@ -425,7 +425,7 @@ int main(int argc, char * const *argv)
 				fprintf(stderr,
 					"Failed to add include path '%s'\n",
 					optarg);
-				exit(EXIT_FAILURE);
+				goto out_fail;
 			}
 			break;
 		case OPT_NUMERIC:
@@ -460,7 +460,7 @@ int main(int argc, char * const *argv)
 				if (i == array_size(debug_param)) {
 					fprintf(stderr, "invalid debug parameter `%s'\n",
 						optarg);
-					exit(EXIT_FAILURE);
+					goto out_fail;
 				}
 
 				if (end == NULL)
@@ -480,7 +480,7 @@ int main(int argc, char * const *argv)
 			output_flags |= NFT_CTX_OUTPUT_JSON;
 #else
 			fprintf(stderr, "JSON support not compiled-in\n");
-			exit(EXIT_FAILURE);
+			goto out_fail;
 #endif
 			break;
 		case OPT_GUID:
@@ -502,13 +502,13 @@ int main(int argc, char * const *argv)
 			nft_ctx_set_optimize(nft, 0x1);
 			break;
 		case OPT_INVALID:
-			exit(EXIT_FAILURE);
+			goto out_fail;
 		}
 	}
 
 	if (!filename && define) {
 		fprintf(stderr, "Error: -D/--define can only be used with -f/--filename\n");
-		exit(EXIT_FAILURE);
+		goto out_fail;
 	}
 
 	nft_ctx_output_set_flags(nft, output_flags);
@@ -523,7 +523,7 @@ int main(int argc, char * const *argv)
 		if (buf == NULL) {
 			fprintf(stderr, "%s:%u: Memory allocation failure\n",
 				__FILE__, __LINE__);
-			exit(EXIT_FAILURE);
+			goto out_fail;
 		}
 		for (i = optind; i < argc; i++) {
 			strcat(buf, argv[i]);
@@ -538,15 +538,17 @@ int main(int argc, char * const *argv)
 		if (cli_init(nft) < 0) {
 			fprintf(stderr, "%s: interactive CLI not supported in this build\n",
 				argv[0]);
-			exit(EXIT_FAILURE);
+			goto out_fail;
 		}
-		return EXIT_SUCCESS;
 	} else {
 		fprintf(stderr, "%s: no command specified\n", argv[0]);
-		exit(EXIT_FAILURE);
+		goto out_fail;
 	}
 
+out:
 	nft_ctx_free(nft);
-
 	return rc;
+out_fail:
+	nft_ctx_free(nft);
+	return EXIT_FAILURE;
 }
-- 
2.40.0

