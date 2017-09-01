From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/3] src: move nf_sock into nft_ctx structure
Date: Fri,  1 Sep 2017 12:14:05 +0200
Message-ID: <1504260847-5408-1-git-send-email-pablo@netfilter.org>
Cc: phil@nwl.cc, eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34312 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751730AbdIAKOR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Sep 2017 06:14:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CC797190F7F
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Sep 2017 12:13:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BB95F2DC69
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Sep 2017 12:13:52 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The idea is to provide a simplistic API for non-netlink wise people.
Add a field in struct nft_ctx to store the socket.

The advanced API that we're planning will just simply leave this unset,
since netlink IO will be exposed.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Eric: Still pending the specific interface to print. As I said, I would prefer
       functions with stricting typing. I think after this you have the simple
       API that you need.

 include/nftables.h |  3 +++
 src/main.c         | 26 +++++++++++---------------
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index 256b06ee33fc..5035567a75fd 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -38,7 +38,10 @@ struct nft_cache {
 	uint32_t		seqnum;
 };
 
+struct mnl_socket;
+
 struct nft_ctx {
+	struct mnl_socket	*nf_sock;
 	const char		*include_paths[INCLUDE_PATHS_MAX];
 	unsigned int		num_include_paths;
 	unsigned int		parser_max_errors;
diff --git a/src/main.c b/src/main.c
index eecd430a2e3f..a891832ec5d6 100644
--- a/src/main.c
+++ b/src/main.c
@@ -305,7 +305,6 @@ static void nft_ctx_free(const struct nft_ctx *ctx)
 }
 
 static int nft_run_cmd_from_buffer(struct nft_ctx *nft,
-				   struct mnl_socket *nf_sock,
 				   char *buf, size_t buflen)
 {
 	int rc = NFT_EXIT_SUCCESS;
@@ -313,11 +312,11 @@ static int nft_run_cmd_from_buffer(struct nft_ctx *nft,
 	LIST_HEAD(msgs);
 	void *scanner;
 
-	parser_init(nf_sock, &nft->cache, &state, &msgs, nft->debug_mask);
+	parser_init(nft->nf_sock, &nft->cache, &state, &msgs, nft->debug_mask);
 	scanner = scanner_init(&state);
 	scanner_push_buffer(scanner, &indesc_cmdline, buf);
 
-	if (nft_run(nft, nf_sock, scanner, &state, &msgs) != 0)
+	if (nft_run(nft, nft->nf_sock, scanner, &state, &msgs) != 0)
 		rc = NFT_EXIT_FAILURE;
 
 	erec_print_list(stderr, &msgs, nft->debug_mask);
@@ -326,26 +325,24 @@ static int nft_run_cmd_from_buffer(struct nft_ctx *nft,
 	return rc;
 }
 
-static int nft_run_cmd_from_filename(struct nft_ctx *nft,
-				     struct mnl_socket *nf_sock,
-				     const char *filename)
+static int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 {
 	struct parser_state state;
 	LIST_HEAD(msgs);
 	void *scanner;
 	int rc;
 
-	rc = cache_update(nf_sock, &nft->cache, CMD_INVALID, &msgs,
+	rc = cache_update(nft->nf_sock, &nft->cache, CMD_INVALID, &msgs,
 			  nft->debug_mask);
 	if (rc < 0)
 		return NFT_EXIT_FAILURE;
 
-	parser_init(nf_sock, &nft->cache, &state, &msgs, nft->debug_mask);
+	parser_init(nft->nf_sock, &nft->cache, &state, &msgs, nft->debug_mask);
 	scanner = scanner_init(&state);
 	if (scanner_read_file(scanner, filename, &internal_location) < 0)
 		goto err;
 
-	if (nft_run(nft, nf_sock, scanner, &state, &msgs) != 0)
+	if (nft_run(nft, nft->nf_sock, scanner, &state, &msgs) != 0)
 		rc = NFT_EXIT_FAILURE;
 err:
 	erec_print_list(stderr, &msgs, nft->debug_mask);
@@ -359,13 +356,12 @@ int main(int argc, char * const *argv)
 	char *buf = NULL, *filename = NULL;
 	unsigned int len;
 	bool interactive = false;
-	struct mnl_socket *nf_sock;
 	struct parser_state state;
 	int i, val, rc;
 
 	nft = nft_ctx_new();
 
-	nf_sock = netlink_open_sock();
+	nft->nf_sock = netlink_open_sock();
 	while (1) {
 		val = getopt_long(argc, argv, OPTSTRING, options, NULL);
 		if (val == -1)
@@ -460,11 +456,11 @@ int main(int argc, char * const *argv)
 				strcat(buf, " ");
 		}
 		strcat(buf, "\n");
-		rc = nft_run_cmd_from_buffer(nft, nf_sock, buf, len + 2);
+		rc = nft_run_cmd_from_buffer(nft, buf, len + 2);
 	} else if (filename != NULL) {
-		rc = nft_run_cmd_from_filename(nft, nf_sock, filename);
+		rc = nft_run_cmd_from_filename(nft, filename);
 	} else if (interactive) {
-		if (cli_init(nft, nf_sock, &state) < 0) {
+		if (cli_init(nft, nft->nf_sock, &state) < 0) {
 			fprintf(stderr, "%s: interactive CLI not supported in this build\n",
 				argv[0]);
 			exit(NFT_EXIT_FAILURE);
@@ -476,7 +472,7 @@ int main(int argc, char * const *argv)
 	}
 
 	xfree(buf);
-	netlink_close_sock(nf_sock);
+	netlink_close_sock(nft->nf_sock);
 	nft_ctx_free(nft);
 
 	return rc;
-- 
2.1.4

