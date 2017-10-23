From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2 3/4] cli: Use nft_run_cmd_from_buffer()
Date: Mon, 23 Oct 2017 17:33:18 +0200
Message-ID: <20171023153319.13415-4-phil@nwl.cc>
References: <20171023153319.13415-1-phil@nwl.cc>
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:60832 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932102AbdJWPdf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Oct 2017 11:33:35 -0400
In-Reply-To: <20171023153319.13415-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Make CLI code adhere to intended libnftables API by not open coding what
nft_run_cmd_from_buffer() does. This way, nft_run() has no users outside
of src/libnftables.c anymore and therefore can become static.

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
 include/cli.h      |  6 ++----
 include/nftables.h |  7 -------
 src/cli.c          | 21 ++-------------------
 src/libnftables.c  |  6 +++---
 src/main.c         |  5 ++---
 5 files changed, 9 insertions(+), 36 deletions(-)

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
diff --git a/include/nftables.h b/include/nftables.h
index eb39dbd1487dd..98d619a3ab8d2 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -103,13 +103,6 @@ struct input_descriptor {
 	off_t				line_offset;
 };
 
-struct parser_state;
-struct mnl_socket;
-
-int nft_run(struct nft_ctx *nft, struct mnl_socket *nf_sock,
-	    void *scanner, struct parser_state *state,
-	    struct list_head *msgs);
-
 void ct_label_table_init(void);
 void mark_table_init(void);
 void gmp_init(void);
diff --git a/src/cli.c b/src/cli.c
index 3174cfed05a7d..37351f2f8b04f 100644
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
@@ -134,11 +126,7 @@ static void cli_complete(char *line)
 	xfree(line);
 	line = s;
 
-	parser_init(cli_nf_sock, &cli_nft->cache, state, &msgs,
-		    cli_nft->debug_mask, &cli_nft->output);
-	scanner_push_buffer(scanner, &indesc_cli, line);
-	nft_run(cli_nft, cli_nf_sock, scanner, state, &msgs);
-	erec_print_list(&cli_nft->output, &msgs, cli_nft->debug_mask);
+	nft_run_cmd_from_buffer(cli_nft, line, len + 2);
 	xfree(line);
 	nft_ctx_flush_cache(cli_nft);
 }
@@ -148,12 +136,10 @@ static char **cli_completion(const char *text, int start, int end)
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
@@ -170,9 +156,6 @@ int cli_init(struct nft_ctx *nft, struct mnl_socket *nf_sock,
 	read_history(histfile);
 	history_set_pos(history_length);
 
-	state	= _state;
-	scanner = scanner_init(state);
-
 	while (!eof)
 		rl_callback_read_char();
 	return 0;
diff --git a/src/libnftables.c b/src/libnftables.c
index d34e52759e947..51a87dc34bc60 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -75,9 +75,9 @@ out:
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
index b9938c9cd86e6..a28564172e9a0 100644
--- a/src/main.c
+++ b/src/main.c
@@ -20,7 +20,7 @@
 
 #include <nftables/nftables.h>
 #include <utils.h>
-#include <parser.h>
+#include <nftables.h>
 #include <cli.h>
 
 static struct nft_ctx *nft;
@@ -169,7 +169,6 @@ int main(int argc, char * const *argv)
 	char *buf = NULL, *filename = NULL;
 	unsigned int len;
 	bool interactive = false;
-	struct parser_state state;
 	int i, val, rc;
 
 	nft = nft_ctx_new(NFT_CTX_DEFAULT);
@@ -273,7 +272,7 @@ int main(int argc, char * const *argv)
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

