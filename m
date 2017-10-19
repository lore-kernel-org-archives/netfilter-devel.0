From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 4/7] cli: Use nft_run_cmd_from_buffer()
Date: Thu, 19 Oct 2017 10:18:44 +0200
Message-ID: <20171019081847.16171-5-phil@nwl.cc>
References: <20171019081847.16171-1-phil@nwl.cc>
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:49414 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751937AbdJSITK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2017 04:19:10 -0400
In-Reply-To: <20171019081847.16171-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This simplifies CLI code and allows to reduce libnftables API by not
exporting nft_run().

Since nft_run_cmd_from_buffer() takes care of scanner initialization and
libmnl socket passed to cli_init() is present as nft_ctx field as well,
signature of cli_init() can be reduced to just take nft_ctx pointer as
single argument.

Note that this change introduces two (possibly unwanted) side-effects:

* Input descriptor passed to scanner_push_buffer() is changed from the
  CLI-specific one to the one used by nft_run_cmd_from_buffer().

In practice though, this doesn't make a difference: input descriptor
types INDESC_CLI and INDESC_BUFFER are treated equally by erec_print().
Also, scanner_push_buffer() NULLs input descriptor name, so that is not
used at all in latter code.

* Error messages are printed to stderr instead of cli_nft->output.

This could be fixed by introducing an 'error_output' field in nft_ctx
for nft_run_cmd_from_buffer() to use when printing error messages.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/cli.h               |  6 ++----
 include/nftables/nftables.h |  5 -----
 src/cli.c                   | 24 +++---------------------
 src/libnftables.c           |  6 +++---
 src/main.c                  |  3 +--
 5 files changed, 9 insertions(+), 35 deletions(-)

diff --git a/include/cli.h b/include/cli.h
index 3ae1c459bce2d..3780e0917969d 100644
--- a/include/cli.h
+++ b/include/cli.h
@@ -5,11 +5,9 @@
 
 struct parser_state;
 #ifdef HAVE_LIBREADLINE
-extern int cli_init(struct nft_ctx *nft, struct mnl_socket *nf_sock,
-		    struct parser_state *state);
+extern int cli_init(struct nft_ctx *nft);
 #else
-static inline int cli_init(struct nft_ctx *nft, struct mnl_socket *nf_sock,
-			   struct parser_state *state)
+static inline int cli_init(struct nft_ctx *nft)
 {
         return -1;
 }
diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
index fbc6fd4252a97..b91219d423df9 100644
--- a/include/nftables/nftables.h
+++ b/include/nftables/nftables.h
@@ -9,7 +9,6 @@
 #ifndef LIB_NFTABLES_H
 #define LIB_NFTABLES_H
 
-struct parser_state;
 struct mnl_socket;
 
 struct nft_cache {
@@ -79,10 +78,6 @@ void nft_ctx_free(struct nft_ctx *ctx);
 FILE *nft_ctx_set_output(struct nft_ctx *ctx, FILE *fp);
 void nft_ctx_flush_cache(struct nft_ctx *ctx);
 
-int nft_run(struct nft_ctx *nft, struct mnl_socket *nf_sock,
-	    void *scanner, struct parser_state *state,
-	    struct list_head *msgs);
-
 int nft_run_cmd_from_buffer(struct nft_ctx *nft, char *buf, size_t buflen);
 int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename);
 
diff --git a/src/cli.c b/src/cli.c
index cadc3af6e8034..37351f2f8b04f 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -35,15 +35,7 @@
 
 #define CMDLINE_HISTFILE	".nft.history"
 
-static const struct input_descriptor indesc_cli = {
-	.type	= INDESC_CLI,
-	.name   = "<cli>",
-};
-
-static struct parser_state *state;
 static struct nft_ctx *cli_nft;
-static struct mnl_socket *cli_nf_sock;
-static void *scanner;
 static char histfile[PATH_MAX];
 static char *multiline;
 static bool eof;
@@ -134,14 +126,9 @@ static void cli_complete(char *line)
 	xfree(line);
 	line = s;
 
-	parser_init(cli_nf_sock, &cli_nft->cache, state, &msgs,
-		    cli_nft->debug_mask, &cli_nft->output);
-	scanner_push_buffer(scanner, &indesc_cli, line);
-	nft_run(cli_nft, cli_nf_sock, scanner, state, &msgs);
-	erec_print_list(&cli_nft->output, &msgs, cli_nft->debug_mask);
+	nft_run_cmd_from_buffer(cli_nft, line, len + 2);
 	xfree(line);
-	cache_release(&cli_nft->cache);
-	iface_cache_release();
+	nft_ctx_flush_cache(cli_nft);
 }
 
 static char **cli_completion(const char *text, int start, int end)
@@ -149,12 +136,10 @@ static char **cli_completion(const char *text, int start, int end)
 	return NULL;
 }
 
-int cli_init(struct nft_ctx *nft, struct mnl_socket *nf_sock,
-	     struct parser_state *_state)
+int cli_init(struct nft_ctx *nft)
 {
 	const char *home;
 
-	cli_nf_sock = nf_sock;
 	cli_nft = nft;
 	rl_readline_name = "nft";
 	rl_instream  = stdin;
@@ -171,9 +156,6 @@ int cli_init(struct nft_ctx *nft, struct mnl_socket *nf_sock,
 	read_history(histfile);
 	history_set_pos(history_length);
 
-	state	= _state;
-	scanner = scanner_init(state);
-
 	while (!eof)
 		rl_callback_read_char();
 	return 0;
diff --git a/src/libnftables.c b/src/libnftables.c
index 0de50c854d572..d88c299c3647e 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -74,9 +74,9 @@ out:
 	return ret;
 }
 
-int nft_run(struct nft_ctx *nft, struct mnl_socket *nf_sock,
-	    void *scanner, struct parser_state *state,
-	    struct list_head *msgs)
+static int nft_run(struct nft_ctx *nft, struct mnl_socket *nf_sock,
+		   void *scanner, struct parser_state *state,
+		   struct list_head *msgs)
 {
 	struct cmd *cmd, *next;
 	int ret;
diff --git a/src/main.c b/src/main.c
index a7da460f28ca5..3c107181305c7 100644
--- a/src/main.c
+++ b/src/main.c
@@ -168,7 +168,6 @@ int main(int argc, char * const *argv)
 	char *buf = NULL, *filename = NULL;
 	unsigned int len;
 	bool interactive = false;
-	struct parser_state state;
 	int i, val, rc;
 
 	nft = nft_ctx_new(NFT_CTX_DEFAULT);
@@ -272,7 +271,7 @@ int main(int argc, char * const *argv)
 	} else if (filename != NULL) {
 		rc = nft_run_cmd_from_filename(nft, filename);
 	} else if (interactive) {
-		if (cli_init(nft, nft->nf_sock, &state) < 0) {
+		if (cli_init(nft) < 0) {
 			fprintf(stderr, "%s: interactive CLI not supported in this build\n",
 				argv[0]);
 			exit(NFT_EXIT_FAILURE);
-- 
2.13.1

