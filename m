From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATH nft v2 05/18] libnftables: add nft_run_command_from_buffer
Date: Thu, 24 Aug 2017 17:49:24 +0200
Message-ID: <20170824154924.GA24860@salvia>
References: <20170819152420.22563-1-eric@regit.org>
 <20170819152420.22563-6-eric@regit.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="FL5UXtIhxfXey3p5"
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:58464 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751840AbdHXPtt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2017 11:49:49 -0400
Content-Disposition: inline
In-Reply-To: <20170819152420.22563-6-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Attaching a revamped version, it is collapsing your patch 5 and 6.

We still have to agree on what to do with the netlink socket. I know
you don't want to open it from the client side.

The only way I find to do this is to - yick - add a flag to
nft_ctx_new().

--FL5UXtIhxfXey3p5
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-src-add-nft_run_cmd_-functions.patch"

>From d9583a782e96d4c2310c00b4cb6a511b2bd99471 Mon Sep 17 00:00:00 2001
From: Eric Leblond <eric@regit.org>
Date: Thu, 24 Aug 2017 17:46:01 +0200
Subject: [PATCH] src: add nft_run_cmd_*() functions

Add new function to read nftables command from a file and buffer, that
we can expose as library.

Joint work with Pablo Neira.

Signed-off-by: Eric Leblond <eric@regit.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/main.c | 74 +++++++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 54 insertions(+), 20 deletions(-)

diff --git a/src/main.c b/src/main.c
index 1b986ae4ed12..0cad4d2412e8 100644
--- a/src/main.c
+++ b/src/main.c
@@ -300,6 +300,58 @@ static void nft_ctx_free(const struct nft_ctx *ctx)
 	xfree(ctx);
 }
 
+static int nft_run_cmd_from_buffer(struct nft_ctx *nft,
+				   struct mnl_socket *nf_sock,
+				   char *buf, size_t buflen)
+{
+	int rc = NFT_EXIT_SUCCESS;
+	struct parser_state state;
+	LIST_HEAD(msgs);
+	void *scanner;
+
+	parser_init(nf_sock, &nft->cache, &state, &msgs, nft->debug_mask);
+	scanner = scanner_init(&state);
+	scanner_push_buffer(scanner, &indesc_cmdline, buf);
+
+	if (nft_run(nft, nf_sock, scanner, &state, &msgs) != 0)
+		rc = NFT_EXIT_FAILURE;
+
+	scanner_destroy(scanner);
+	erec_print_list(stderr, &msgs, nft->debug_mask);
+	cache_release(&nft->cache);
+
+	return rc;
+}
+
+static int nft_run_cmd_from_filename(struct nft_ctx *nft,
+				     struct mnl_socket *nf_sock,
+				     const char *filename)
+{
+	struct parser_state state;
+	LIST_HEAD(msgs);
+	void *scanner;
+	int rc;
+
+	rc = cache_update(nf_sock, &nft->cache, CMD_INVALID, &msgs,
+			  nft->debug_mask);
+	if (rc < 0)
+		return NFT_EXIT_FAILURE;
+
+	parser_init(nf_sock, &nft->cache, &state, &msgs, nft->debug_mask);
+	scanner = scanner_init(&state);
+	if (scanner_read_file(scanner, filename, &internal_location) < 0)
+		goto err;
+
+	if (nft_run(nft, nf_sock, scanner, &state, &msgs) != 0)
+		rc = NFT_EXIT_FAILURE;
+err:
+	scanner_destroy(scanner);
+	erec_print_list(stderr, &msgs, nft->debug_mask);
+	cache_release(&nft->cache);
+
+	return rc;
+}
+
 int main(int argc, char * const *argv)
 {
 	struct parser_state state;
@@ -410,21 +462,9 @@ int main(int argc, char * const *argv)
 				strcat(buf, " ");
 		}
 		strcat(buf, "\n");
-		parser_init(nf_sock, &nft->cache, &state, &msgs,
-			    nft->debug_mask);
-		scanner = scanner_init(&state);
-		scanner_push_buffer(scanner, &indesc_cmdline, buf);
+		rc = nft_run_cmd_from_buffer(nft, nf_sock, buf, len + 2);
 	} else if (filename != NULL) {
-		rc = cache_update(nf_sock, &nft->cache, CMD_INVALID, &msgs,
-				  nft->debug_mask);
-		if (rc < 0)
-			return rc;
-
-		parser_init(nf_sock, &nft->cache, &state, &msgs,
-			    nft->debug_mask);
-		scanner = scanner_init(&state);
-		if (scanner_read_file(scanner, filename, &internal_location) < 0)
-			goto out;
+		rc = nft_run_cmd_from_filename(nft, nf_sock, filename);
 	} else if (interactive) {
 		if (cli_init(nft, nf_sock, &state) < 0) {
 			fprintf(stderr, "%s: interactive CLI not supported in this build\n",
@@ -437,13 +477,7 @@ int main(int argc, char * const *argv)
 		exit(NFT_EXIT_FAILURE);
 	}
 
-	if (nft_run(nft, nf_sock, scanner, &state, &msgs) != 0)
-		rc = NFT_EXIT_FAILURE;
-out:
-	scanner_destroy(scanner);
-	erec_print_list(stderr, &msgs, nft->debug_mask);
 	xfree(buf);
-	cache_release(&nft->cache);
 	iface_cache_release();
 	netlink_close_sock(nf_sock);
 	nft_ctx_free(nft);
-- 
2.1.4


--FL5UXtIhxfXey3p5--
