From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH] Keep cache in struct nft_ctx
Date: Tue, 22 Aug 2017 14:40:04 +0200
Message-ID: <20170822124004.23724-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:53137 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932615AbdHVMkR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Aug 2017 08:40:17 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is preliminary work for Eric's libnftables patchset.

Cc: Eric Leblond <eric@regit.org>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/cli.h      |  4 ++--
 include/nftables.h | 13 +++++++------
 src/cli.c          | 14 ++++++--------
 src/main.c         | 24 +++++++++++-------------
 4 files changed, 26 insertions(+), 29 deletions(-)

diff --git a/include/cli.h b/include/cli.h
index 40fc63ead5b45..3ae1c459bce2d 100644
--- a/include/cli.h
+++ b/include/cli.h
@@ -6,10 +6,10 @@
 struct parser_state;
 #ifdef HAVE_LIBREADLINE
 extern int cli_init(struct nft_ctx *nft, struct mnl_socket *nf_sock,
-		    struct nft_cache *cache, struct parser_state *state);
+		    struct parser_state *state);
 #else
 static inline int cli_init(struct nft_ctx *nft, struct mnl_socket *nf_sock,
-			   struct nft_cache *cache, struct parser_state *state)
+			   struct parser_state *state)
 {
         return -1;
 }
diff --git a/include/nftables.h b/include/nftables.h
index a457aba62ee80..994b5111176c9 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -32,17 +32,18 @@ struct output_ctx {
 	unsigned int echo;
 };
 
-struct nft_ctx {
-	struct output_ctx	output;
-	bool			check;
-};
-
 struct nft_cache {
 	bool			initialized;
 	struct list_head	list;
 	uint32_t		seqnum;
 };
 
+struct nft_ctx {
+	struct output_ctx	output;
+	bool			check;
+	struct nft_cache	cache;
+};
+
 extern unsigned int max_errors;
 extern unsigned int debug_level;
 extern const char *include_paths[INCLUDE_PATHS_MAX];
@@ -124,7 +125,7 @@ struct parser_state;
 struct mnl_socket;
 
 int nft_run(struct nft_ctx *nft, struct mnl_socket *nf_sock,
-	    struct nft_cache *cache, void *scanner, struct parser_state *state,
+	    void *scanner, struct parser_state *state,
 	    struct list_head *msgs);
 
 void ct_label_table_init(void);
diff --git a/src/cli.c b/src/cli.c
index d0ca9afbbdb10..4f05f276542e9 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -41,9 +41,8 @@ static const struct input_descriptor indesc_cli = {
 };
 
 static struct parser_state *state;
-static struct nft_ctx cli_nft;
+static struct nft_ctx *cli_nft;
 static struct mnl_socket *cli_nf_sock;
-static struct nft_cache *cli_cache;
 static void *scanner;
 static char histfile[PATH_MAX];
 static char *multiline;
@@ -135,12 +134,12 @@ static void cli_complete(char *line)
 	xfree(line);
 	line = s;
 
-	parser_init(cli_nf_sock, cli_cache, state, &msgs);
+	parser_init(cli_nf_sock, &cli_nft->cache, state, &msgs);
 	scanner_push_buffer(scanner, &indesc_cli, line);
-	nft_run(&cli_nft, cli_nf_sock, cli_cache, scanner, state, &msgs);
+	nft_run(cli_nft, cli_nf_sock, scanner, state, &msgs);
 	erec_print_list(stdout, &msgs);
 	xfree(line);
-	cache_release(cli_cache);
+	cache_release(&cli_nft->cache);
 	iface_cache_release();
 }
 
@@ -150,13 +149,12 @@ static char **cli_completion(const char *text, int start, int end)
 }
 
 int cli_init(struct nft_ctx *nft, struct mnl_socket *nf_sock,
-	     struct nft_cache *cache, struct parser_state *_state)
+	     struct parser_state *_state)
 {
 	const char *home;
 
 	cli_nf_sock = nf_sock;
-	cli_nft = *nft;
-	cli_cache = cache;
+	cli_nft = nft;
 	rl_readline_name = "nft";
 	rl_instream  = stdin;
 	rl_outstream = stdout;
diff --git a/src/main.c b/src/main.c
index 888395981d42c..b86ae62f13431 100644
--- a/src/main.c
+++ b/src/main.c
@@ -187,7 +187,7 @@ static const struct input_descriptor indesc_cmdline = {
 	.name	= "<cmdline>",
 };
 
-static int nft_netlink(struct nft_ctx *nft, struct nft_cache *cache,
+static int nft_netlink(struct nft_ctx *nft,
 		       struct parser_state *state, struct list_head *msgs,
 		       struct mnl_socket *nf_sock)
 {
@@ -211,7 +211,7 @@ static int nft_netlink(struct nft_ctx *nft, struct nft_cache *cache,
 		ctx.batch_supported = batch_supported;
 		ctx.octx = &nft->output;
 		ctx.nf_sock = nf_sock;
-		ctx.cache = cache;
+		ctx.cache = &nft->cache;
 		init_list_head(&ctx.list);
 		ret = do_command(&ctx, cmd);
 		if (ret < 0)
@@ -247,7 +247,7 @@ out:
 }
 
 int nft_run(struct nft_ctx *nft, struct mnl_socket *nf_sock,
-	    struct nft_cache *cache, void *scanner, struct parser_state *state,
+	    void *scanner, struct parser_state *state,
 	    struct list_head *msgs)
 {
 	struct cmd *cmd, *next;
@@ -262,7 +262,7 @@ int nft_run(struct nft_ctx *nft, struct mnl_socket *nf_sock,
 	list_for_each_entry(cmd, &state->cmds, list)
 		nft_cmd_expand(cmd);
 
-	ret = nft_netlink(nft, cache, state, msgs, nf_sock);
+	ret = nft_netlink(nft, state, msgs, nf_sock);
 err1:
 	list_for_each_entry_safe(cmd, next, &state->cmds, list) {
 		list_del(&cmd->list);
@@ -297,7 +297,6 @@ void nft_exit(void)
 int main(int argc, char * const *argv)
 {
 	struct parser_state state;
-	struct nft_cache cache;
 	void *scanner;
 	LIST_HEAD(msgs);
 	char *buf = NULL, *filename = NULL;
@@ -306,8 +305,7 @@ int main(int argc, char * const *argv)
 	int i, val, rc = NFT_EXIT_SUCCESS;
 	struct mnl_socket *nf_sock;
 
-	memset(&cache, 0, sizeof(cache));
-	init_list_head(&cache.list);
+	init_list_head(&nft.cache.list);
 
 	nft_init();
 	nf_sock = netlink_open_sock();
@@ -407,20 +405,20 @@ int main(int argc, char * const *argv)
 				strcat(buf, " ");
 		}
 		strcat(buf, "\n");
-		parser_init(nf_sock, &cache, &state, &msgs);
+		parser_init(nf_sock, &nft.cache, &state, &msgs);
 		scanner = scanner_init(&state);
 		scanner_push_buffer(scanner, &indesc_cmdline, buf);
 	} else if (filename != NULL) {
-		rc = cache_update(nf_sock, &cache, CMD_INVALID, &msgs);
+		rc = cache_update(nf_sock, &nft.cache, CMD_INVALID, &msgs);
 		if (rc < 0)
 			return rc;
 
-		parser_init(nf_sock, &cache, &state, &msgs);
+		parser_init(nf_sock, &nft.cache, &state, &msgs);
 		scanner = scanner_init(&state);
 		if (scanner_read_file(scanner, filename, &internal_location) < 0)
 			goto out;
 	} else if (interactive) {
-		if (cli_init(&nft, nf_sock, &cache, &state) < 0) {
+		if (cli_init(&nft, nf_sock, &state) < 0) {
 			fprintf(stderr, "%s: interactive CLI not supported in this build\n",
 				argv[0]);
 			exit(NFT_EXIT_FAILURE);
@@ -431,13 +429,13 @@ int main(int argc, char * const *argv)
 		exit(NFT_EXIT_FAILURE);
 	}
 
-	if (nft_run(&nft, nf_sock, &cache, scanner, &state, &msgs) != 0)
+	if (nft_run(&nft, nf_sock, scanner, &state, &msgs) != 0)
 		rc = NFT_EXIT_FAILURE;
 out:
 	scanner_destroy(scanner);
 	erec_print_list(stderr, &msgs);
 	xfree(buf);
-	cache_release(&cache);
+	cache_release(&nft.cache);
 	iface_cache_release();
 	netlink_close_sock(nf_sock);
 	nft_exit();
-- 
2.13.1

