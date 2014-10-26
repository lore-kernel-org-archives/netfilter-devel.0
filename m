From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nf_tables PATCH] netfilter: nft_compat: fix wrong target lookup in
 nft_target_select_ops()
Date: Sun, 26 Oct 2014 12:22:40 +0100
Message-ID: <20141026112133.9114.98321.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:45942 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751049AbaJZLWv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 Oct 2014 07:22:51 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The code looks for an already loaded target, and the correct list to search
is nft_target_list, not nft_match_list.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
NOTE: Compile-tested only.

 net/netfilter/nft_compat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 7e2683c..4f28109 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -611,7 +611,7 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	family = ctx->afi->family;
 
 	/* Re-use the existing target if it's already loaded. */
-	list_for_each_entry(nft_target, &nft_match_list, head) {
+	list_for_each_entry(nft_target, &nft_target_list, head) {
 		struct xt_target *target = nft_target->ops.data;
 
 		if (strcmp(target->name, tg_name) == 0 &&

