From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH libnftnl] tests: nft-parsing-test: fix warning - ignoring return value of fgets
Date: Fri, 29 Dec 2017 12:59:25 +0530
Message-ID: <20171229072925.15689-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, harshasharmaiitr@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:41628 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754962AbdL2H3y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Dec 2017 02:29:54 -0500
Received: by mail-pl0-f68.google.com with SMTP id g2so22582254pli.8
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Dec 2017 23:29:54 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes compilation warning: ignoring return value of fgets.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 tests/nft-parsing-test.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tests/nft-parsing-test.c b/tests/nft-parsing-test.c
index d25a73e..97f402d 100644
--- a/tests/nft-parsing-test.c
+++ b/tests/nft-parsing-test.c
@@ -80,7 +80,8 @@ static int compare_test(uint32_t type, struct nftnl_ruleset *rs,
 	}
 
 	rewind(fp);
-	fgets(orig, sizeof(orig), fp);
+	if (fgets(orig, sizeof(orig), fp) == NULL)
+		fprintf(stderr, "Error in reading or end of file.\n");
 
 	if (strncmp(orig, out, strlen(out)) == 0) {
 		if (update)
-- 
2.11.0

