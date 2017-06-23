From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH nft 1/2] src: add new generic context structure nft_ctx
Date: Fri, 23 Jun 2017 18:38:24 +0200
Message-ID: <20170623163825.2066-1-pablombg@gmail.com>
Cc: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36100 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751488AbdFWQkV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Jun 2017 12:40:21 -0400
Received: by mail-wr0-f195.google.com with SMTP id 77so13766588wrb.3
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Jun 2017 09:40:20 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The new structure nft_ctx is meant to be used as a generic container of
context information.

This is a preparatory patch. So at the moment the struct just carry
output_ctx on his path through main.c and cli.c.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 include/cli.h      |  4 ++--
 include/nftables.h |  8 ++++++--
 src/cli.c          |  8 ++++----
 src/main.c         | 24 ++++++++++++------------
 4 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/include/cli.h b/include/cli.h
index 1ae1237..6894f9d 100644
--- a/include/cli.h
+++ b/include/cli.h
@@ -5,9 +5,9 @@
 
 struct parser_state;
 #ifdef HAVE_LIBREADLINE
-extern int cli_init(struct parser_state *state, struct output_ctx *octx);
+extern int cli_init(struct nft_ctx *nft, struct parser_state *state);
 #else
-static inline int cli_init(struct parser_state *state, struct output_ctx *octx)
+static inline int cli_init(struct nft_ctx *nft, struct parser_state *state)
 {
         return -1;
 }
diff --git a/include/nftables.h b/include/nftables.h
index 9e10be0..dbd4637 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -31,6 +31,10 @@ struct output_ctx {
 	unsigned int handle;
 };
 
+struct nft_ctx {
+	struct output_ctx	output;
+};
+
 extern unsigned int max_errors;
 extern unsigned int debug_level;
 extern const char *include_paths[INCLUDE_PATHS_MAX];
@@ -110,7 +114,7 @@ struct input_descriptor {
 
 struct parser_state;
 
-int nft_run(void *scanner, struct parser_state *state, struct list_head *msgs,
-	     struct output_ctx *octx);
+int nft_run(struct nft_ctx *nft, void *scanner, struct parser_state *state,
+	    struct list_head *msgs);
 
 #endif /* NFTABLES_NFTABLES_H */
diff --git a/src/cli.c b/src/cli.c
index c62e2a1..7cd2f45 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -39,7 +39,7 @@ static const struct input_descriptor indesc_cli = {
 };
 
 static struct parser_state *state;
-static struct output_ctx cli_octx;
+static struct nft_ctx cli_nft;
 static void *scanner;
 
 static char histfile[PATH_MAX];
@@ -130,7 +130,7 @@ static void cli_complete(char *line)
 
 	parser_init(state, &msgs);
 	scanner_push_buffer(scanner, &indesc_cli, line);
-	nft_run(scanner, state, &msgs, &cli_octx);
+	nft_run(&cli_nft, scanner, state, &msgs);
 	erec_print_list(stdout, &msgs);
 	xfree(line);
 	cache_release();
@@ -168,11 +168,11 @@ void __fmtstring(1, 0) cli_display(const char *fmt, va_list ap)
 	rl_forced_update_display();
 }
 
-int cli_init(struct parser_state *_state, struct output_ctx *octx)
+int cli_init(struct nft_ctx *nft, struct parser_state *_state)
 {
 	const char *home;
 
-	cli_octx = *octx;
+	cli_nft = *nft;
 	rl_readline_name = "nft";
 	rl_instream  = stdin;
 	rl_outstream = stdout;
diff --git a/src/main.c b/src/main.c
index 918ad4b..16a01f3 100644
--- a/src/main.c
+++ b/src/main.c
@@ -28,7 +28,7 @@
 #include <iface.h>
 #include <cli.h>
 
-static struct output_ctx octx;
+static struct nft_ctx nft;
 unsigned int max_errors = 10;
 #ifdef DEBUG
 unsigned int debug_level;
@@ -176,7 +176,7 @@ static const struct input_descriptor indesc_cmdline = {
 };
 
 static int nft_netlink(struct parser_state *state, struct list_head *msgs,
-			struct output_ctx *octx)
+		       struct nft_ctx *nft)
 {
 	struct nftnl_batch *batch;
 	struct netlink_ctx ctx;
@@ -196,7 +196,7 @@ static int nft_netlink(struct parser_state *state, struct list_head *msgs,
 		ctx.seqnum = cmd->seqnum = mnl_seqnum_alloc();
 		ctx.batch = batch;
 		ctx.batch_supported = batch_supported;
-		ctx.octx = octx;
+		ctx.octx = &nft->output;
 		init_list_head(&ctx.list);
 		ret = do_command(&ctx, cmd);
 		if (ret < 0)
@@ -230,8 +230,8 @@ out:
 	return ret;
 }
 
-int nft_run(void *scanner, struct parser_state *state, struct list_head *msgs,
-	    struct output_ctx *octx)
+int nft_run(struct nft_ctx *nft, void *scanner, struct parser_state *state,
+	    struct list_head *msgs)
 {
 	struct cmd *cmd, *next;
 	int ret;
@@ -245,7 +245,7 @@ int nft_run(void *scanner, struct parser_state *state, struct list_head *msgs,
 	list_for_each_entry(cmd, &state->cmds, list)
 		nft_cmd_expand(cmd);
 
-	ret = nft_netlink(state, msgs, octx);
+	ret = nft_netlink(state, msgs, nft);
 err1:
 	list_for_each_entry_safe(cmd, next, &state->cmds, list) {
 		list_del(&cmd->list);
@@ -294,7 +294,7 @@ int main(int argc, char * const *argv)
 			include_paths[num_include_paths++] = optarg;
 			break;
 		case OPT_NUMERIC:
-			if (++octx.numeric > NUMERIC_ALL) {
+			if (++nft.output.numeric > NUMERIC_ALL) {
 				fprintf(stderr, "Too many numeric options "
 						"used, max. %u\n",
 					NUMERIC_ALL);
@@ -302,10 +302,10 @@ int main(int argc, char * const *argv)
 			}
 			break;
 		case OPT_STATELESS:
-			octx.stateless++;
+			nft.output.stateless++;
 			break;
 		case OPT_IP2NAME:
-			octx.ip2name++;
+			nft.output.ip2name++;
 			break;
 #ifdef DEBUG
 		case OPT_DEBUG:
@@ -337,7 +337,7 @@ int main(int argc, char * const *argv)
 			break;
 #endif
 		case OPT_HANDLE_OUTPUT:
-			octx.handle++;
+			nft.output.handle++;
 			break;
 		case OPT_INVALID:
 			exit(NFT_EXIT_FAILURE);
@@ -368,7 +368,7 @@ int main(int argc, char * const *argv)
 		if (scanner_read_file(scanner, filename, &internal_location) < 0)
 			goto out;
 	} else if (interactive) {
-		if (cli_init(&state, &octx) < 0) {
+		if (cli_init(&nft, &state) < 0) {
 			fprintf(stderr, "%s: interactive CLI not supported in this build\n",
 				argv[0]);
 			exit(NFT_EXIT_FAILURE);
@@ -379,7 +379,7 @@ int main(int argc, char * const *argv)
 		exit(NFT_EXIT_FAILURE);
 	}
 
-	if (nft_run(scanner, &state, &msgs, &octx) != 0)
+	if (nft_run(&nft, scanner, &state, &msgs) != 0)
 		rc = NFT_EXIT_FAILURE;
 out:
 	scanner_destroy(scanner);
-- 
2.11.0

