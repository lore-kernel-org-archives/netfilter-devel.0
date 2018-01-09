From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH 1/2] src: Print handle attribute in chains
Date: Wed, 10 Jan 2018 00:29:01 +0530
Message-ID: <5c89bb2dd4af12a952bc3931a93bdb7803d47587.1515521150.git.harshasharmaiitr@gmail.com>
References: <cover.1515521149.git.harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, harshasharmaiitr@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:42318 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932310AbeAIS7g (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Jan 2018 13:59:36 -0500
Received: by mail-pg0-f66.google.com with SMTP id q67so8598232pga.9
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Jan 2018 10:59:36 -0800 (PST)
In-Reply-To: <cover.1515521149.git.harshasharmaiitr@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Print handle attribute in chains when listing via '-a' option.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 src/rule.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index e875816..7d66c22 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -694,7 +694,10 @@ static void chain_print(const struct chain *chain, struct output_ctx *octx)
 		rule_print(rule, octx);
 		nft_print(octx, "\n");
 	}
-	nft_print(octx, "\t}\n");
+	nft_print(octx, "\t}");
+	if (octx->handle > 0)
+		nft_print(octx, " # handle %" PRIu64, chain->handle.handle.id);
+	nft_print(octx, "\n");
 }
 
 void chain_print_plain(const struct chain *chain, struct output_ctx *octx)
-- 
2.11.0

