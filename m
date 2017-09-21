From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH] main: Fix for return of uninitialized variable in nft_run_cmd_from_filename()
Date: Thu, 21 Sep 2017 15:10:39 +0200
Message-ID: <20170921131039.2927-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:43842 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751550AbdIUNKv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Sep 2017 09:10:51 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If scanner_read_file() failed, the function would return an
uninitialized value.

Fixes: 3db28321b64a6 ("src: add nft_run_cmd_*() functions")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/main.c b/src/main.c
index 702ef30237b3b..8e7b586d347cc 100644
--- a/src/main.c
+++ b/src/main.c
@@ -351,8 +351,10 @@ static int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 
 	parser_init(nft->nf_sock, &nft->cache, &state, &msgs, nft->debug_mask);
 	scanner = scanner_init(&state);
-	if (scanner_read_file(scanner, filename, &internal_location) < 0)
+	if (scanner_read_file(scanner, filename, &internal_location) < 0) {
+		rc = NFT_EXIT_FAILURE;
 		goto err;
+	}
 
 	if (nft_run(nft, nft->nf_sock, scanner, &state, &msgs) != 0)
 		rc = NFT_EXIT_FAILURE;
-- 
2.13.1

