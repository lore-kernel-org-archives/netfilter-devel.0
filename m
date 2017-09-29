From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 2/2] main: Drop stdout hack to expose nft_print() implementation issues
Date: Fri, 29 Sep 2017 13:26:22 +0200
Message-ID: <20170929112622.11686-3-phil@nwl.cc>
References: <20170929112622.11686-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:37552 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751590AbdI2L0e (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2017 07:26:34 -0400
In-Reply-To: <20170929112622.11686-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This was helpful when testing nft_print() implementation, but breaks
'nft --help' output. Also, with this in place typical printf-debugging
would have to use stderr at all times which is confusing at least.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/src/main.c b/src/main.c
index 6d2422ffeccf9..fc79cfaa30e0c 100644
--- a/src/main.c
+++ b/src/main.c
@@ -415,11 +415,9 @@ int main(int argc, char * const *argv)
 	bool interactive = false;
 	struct parser_state state;
 	int i, val, rc;
-	FILE *outfp = fdopen(dup(STDOUT_FILENO), "w");
 
 	nft = nft_ctx_new(NFT_CTX_DEFAULT);
-	nft_ctx_set_output(nft, outfp);
-	close(STDOUT_FILENO);
+	nft_ctx_set_output(nft, stdout);
 
 	while (1) {
 		val = getopt_long(argc, argv, OPTSTRING, options, NULL);
-- 
2.13.1

