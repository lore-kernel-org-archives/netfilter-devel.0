From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH] tests: Use the system errors in test_xml.
Date: Wed, 11 Jun 2014 17:50:47 +0200
Message-ID: <1402501851-22208-3-git-send-email-anarey@gmail.com>
References: <1402501851-22208-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:48089 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbaFKPvP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:51:15 -0400
Received: by mail-wi0-f170.google.com with SMTP id cc10so3686202wib.1
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Jun 2014 08:51:14 -0700 (PDT)
In-Reply-To: <1402501851-22208-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add the use of system errors (nft_parse_perror) in test_xml to know which
node is not found.

Example:
parsing xmlfiles/75-ruleset.xml: FAILED (Invalid argument)
fail : Node "flags" not found

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 tests/nft-parsing-test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index 2a15109..5eff0b9 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -177,6 +177,7 @@ failparsing:
 	fclose(fp);
 	printf("parsing %s: ", filename);
 	printf("\033[31mFAILED\e[0m (%s)\n", strerror(errno));
+	nft_parse_perror("fail", err);
 	return -1;
 }
 
-- 
2.0.0

