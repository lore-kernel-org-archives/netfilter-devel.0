From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 3/3] src: add nft_ctx_netlink_init()
Date: Fri,  1 Sep 2017 12:14:07 +0200
Message-ID: <1504260847-5408-3-git-send-email-pablo@netfilter.org>
References: <1504260847-5408-1-git-send-email-pablo@netfilter.org>
Cc: phil@nwl.cc, eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34346 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751730AbdIAKOU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Sep 2017 06:14:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 97CCF190F86
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Sep 2017 12:13:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 89940909BB
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Sep 2017 12:13:55 +0200 (CEST)
In-Reply-To: <1504260847-5408-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add these two new functions to set up netlink sockets in the global
context structure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/main.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/src/main.c b/src/main.c
index a891832ec5d6..fce9bfeca100 100644
--- a/src/main.c
+++ b/src/main.c
@@ -298,12 +298,20 @@ static struct nft_ctx *nft_ctx_new(void)
 
 static void nft_ctx_free(const struct nft_ctx *ctx)
 {
+	if (ctx->nf_sock)
+		netlink_close_sock(ctx->nf_sock);
+
 	iface_cache_release();
 	cache_release(&nft->cache);
 	xfree(ctx);
 	nft_exit();
 }
 
+static void nft_ctx_netlink_init(struct nft_ctx *ctx)
+{
+	ctx->nf_sock = netlink_open_sock();
+}
+
 static int nft_run_cmd_from_buffer(struct nft_ctx *nft,
 				   char *buf, size_t buflen)
 {
@@ -361,7 +369,8 @@ int main(int argc, char * const *argv)
 
 	nft = nft_ctx_new();
 
-	nft->nf_sock = netlink_open_sock();
+	nft_ctx_netlink_init(nft);
+
 	while (1) {
 		val = getopt_long(argc, argv, OPTSTRING, options, NULL);
 		if (val == -1)
@@ -472,7 +481,6 @@ int main(int argc, char * const *argv)
 	}
 
 	xfree(buf);
-	netlink_close_sock(nft->nf_sock);
 	nft_ctx_free(nft);
 
 	return rc;
-- 
2.1.4

