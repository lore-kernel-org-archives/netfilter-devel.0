From: Yanchuan Nian <ycnian@gmail.com>
Subject: [nft PATCH] Fix memory leak in nft get operation
Date: Mon, 11 Aug 2014 10:24:24 +0800
Message-ID: <1407723864-18211-1-git-send-email-ycnian@gmail.com>
Cc: netfilter-devel@vger.kernel.org, Yanchuan Nian <ycnian@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:48323 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbaHKCVi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 10 Aug 2014 22:21:38 -0400
Received: by mail-pd0-f181.google.com with SMTP id g10so9890073pdj.40
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Aug 2014 19:21:37 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Some memories are forgotten to release on the error path in get operation.
Just release them. Also, in netlink_get_chain, it's better to return
immediately when a error is detected.

Signed-off-by: Yanchuan Nian <ycnian@gmail.com>
---
 src/netlink.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index e149215..dc7a7c4 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -751,15 +751,17 @@ int netlink_get_chain(struct netlink_ctx *ctx, const struct handle *h,
 
 	nlc = alloc_nft_chain(h);
 	err = mnl_nft_chain_get(nf_sock, nlc, 0);
+	if (err < 0) {
+		nft_chain_free(nlc);
+		return netlink_io_error(ctx, loc,
+					"Could not receive chain from kernel: %s",
+					strerror(errno));
+	}
 
 	chain = netlink_delinearize_chain(ctx, nlc);
 	list_add_tail(&chain->list, &ctx->list);
 	nft_chain_free(nlc);
 
-	if (err < 0)
-		return netlink_io_error(ctx, loc,
-					"Could not receive chain from kernel: %s",
-					strerror(errno));
 	return err;
 }
 
@@ -1218,16 +1220,18 @@ int netlink_get_set(struct netlink_ctx *ctx, const struct handle *h,
 	nls = alloc_nft_set(h);
 	netlink_dump_set(nls);
 	err = mnl_nft_set_get(nf_sock, nls);
-	if (err < 0)
+	if (err < 0) {
+		nft_set_free(nls);
 		return netlink_io_error(ctx, loc,
 					"Could not receive set from kernel: %s",
 					strerror(errno));
+	}
 
 	set = netlink_delinearize_set(ctx, nls);
+	nft_set_free(nls);
 	if (set == NULL)
 		return -1;
 	list_add_tail(&set->list, &ctx->list);
-	nft_set_free(nls);
 
 	return err;
 }
@@ -1415,6 +1419,7 @@ int netlink_get_setelems(struct netlink_ctx *ctx, const struct handle *h,
 
 	err = mnl_nft_setelem_get(nf_sock, nls);
 	if (err < 0) {
+		nft_set_free(nls);
 		if (errno == EINTR)
 			return -1;
 
-- 
1.9.3

