From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH] tests: Fix a memory leak
Date: Sun, 13 Apr 2014 20:08:34 +0200
Message-ID: <77e2db7e796774f9155dcc91531dc8a13bea1a94.1397411811.git.anarey@gmail.com>
References: <3a6157fa2be7124bafa2b681acb65eea9be432d2.1397411873.git.anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:56700 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785AbaDMSIv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Apr 2014 14:08:51 -0400
Received: by mail-wi0-f181.google.com with SMTP id hm4so3087649wib.2
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Apr 2014 11:08:50 -0700 (PDT)
In-Reply-To: <3a6157fa2be7124bafa2b681acb65eea9be432d2.1397411873.git.anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Free nft_parse_err struct when there is an error in execute_test function.

It solves the following memory leak shown by valgrind.

==7845== 24 bytes in 1 blocks are still reachable in loss record 1 of 2
==7845==    at 0x4C29590: calloc (vg_replace_malloc.c:618)
==7845==    by 0x401740: execute_test_file (nft-parsing-test.c:249)
==7845==    by 0x400EBB: main (nft-parsing-test.c:330)

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 tests/nft-parsing-test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index 952ffbf..2a15109 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -263,6 +263,7 @@ static int execute_test_file(const char *filename)
 				printf("\033[32mOK\e[0m\n");
 			}
 		}
+		nft_parse_err_free(err);
 		exit(EXIT_FAILURE);
 	}
 	if (strcmp(&filename[len-5], ".json") == 0) {
@@ -273,6 +274,7 @@ static int execute_test_file(const char *filename)
 				printf("\033[32mOK\e[0m\n");
 			}
 		}
+		nft_parse_err_free(err);
 		exit(EXIT_FAILURE);
 	}
 
-- 
1.9.0

