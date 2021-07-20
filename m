Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB45C07E95
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Jul 2021 10:55:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15FD461165
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Jul 2021 10:55:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238077AbhGTKOm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Jul 2021 06:14:42 -0400
Received: from mail.netfilter.org ([217.70.188.207]:50624 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238265AbhGTKLu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Jul 2021 06:11:50 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id B080460692
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Jul 2021 12:51:55 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: add --define key=value
Date:   Tue, 20 Jul 2021 12:52:20 +0200
Message-Id: <20210720105220.22358-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds a new option to define variables from the command line.

 # cat test.nft
 table netdev x {
        chain y {
                type filter hook ingress devices = $dev priority 0;
                counter accept
        }
 }
 # nft --define dev="{ eth0, eth1 }" -f test.nft

You can only combine it with -f/--filename.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/nft.txt                    |  4 ++
 include/nftables.h             | 11 ++++
 include/nftables/libnftables.h |  2 +
 src/libnftables.c              | 95 ++++++++++++++++++++++++++++++++++
 src/main.c                     | 22 +++++++-
 5 files changed, 133 insertions(+), 1 deletion(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index 46e8dc5366c2..13fe8b1f6671 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -44,6 +44,10 @@ understanding of their meaning. You can get information about options by running
 *--file 'filename'*::
 	Read input from 'filename'. If 'filename' is -, read from stdin.
 
+*-D*::
+*--define 'name=value'*::
+	Define a variable. You can only combine this option with '-f'.
+
 *-i*::
 *--interactive*::
 	Read input from an interactive readline CLI. You can use quit to exit, or use the EOF marker,
diff --git a/include/nftables.h b/include/nftables.h
index f239fcf0e1f4..7b6339053b54 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -100,12 +100,23 @@ struct mnl_socket;
 struct parser_state;
 struct scope;
 
+struct nft_vars {
+	const char	*key;
+	const char	*value;
+};
+
 #define MAX_INCLUDE_DEPTH	16
 
 struct nft_ctx {
 	struct mnl_socket	*nf_sock;
 	char			**include_paths;
 	unsigned int		num_include_paths;
+	struct nft_vars		*vars;
+	struct {
+		const char	*buf;
+		struct list_head indesc_list;
+	} vars_ctx;
+	unsigned int		num_vars;
 	unsigned int		parser_max_errors;
 	unsigned int		debug_mask;
 	struct output_ctx	output;
diff --git a/include/nftables/libnftables.h b/include/nftables/libnftables.h
index 765b20dd71ee..aaf7388e6db2 100644
--- a/include/nftables/libnftables.h
+++ b/include/nftables/libnftables.h
@@ -78,6 +78,8 @@ const char *nft_ctx_get_error_buffer(struct nft_ctx *ctx);
 int nft_ctx_add_include_path(struct nft_ctx *ctx, const char *path);
 void nft_ctx_clear_include_paths(struct nft_ctx *ctx);
 
+int nft_ctx_add_var(struct nft_ctx *ctx, const char *var);
+
 int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf);
 int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename);
 
diff --git a/src/libnftables.c b/src/libnftables.c
index e3b6ff0ae8d3..2b453864281d 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -119,6 +119,43 @@ static void nft_exit(struct nft_ctx *ctx)
 	mark_table_exit(ctx);
 }
 
+EXPORT_SYMBOL(nft_ctx_add_var);
+int nft_ctx_add_var(struct nft_ctx *ctx, const char *var)
+{
+	char *separator = strchr(var, '=');
+	int pcount = ctx->num_vars;
+	struct nft_vars *tmp;
+	const char *value;
+
+	if (!separator)
+		return -1;
+
+	tmp = realloc(ctx->vars, (pcount + 1) * sizeof(struct nft_vars));
+	if (!tmp)
+		return -1;
+
+	*separator = '\0';
+	value = separator + 1;
+
+	ctx->vars = tmp;
+	ctx->vars[pcount].key = xstrdup(var);
+	ctx->vars[pcount].value = xstrdup(value);
+	ctx->num_vars++;
+
+	return 0;
+}
+
+static void nft_ctx_clear_vars(struct nft_ctx *ctx)
+{
+	unsigned int i;
+
+	for (i = 0; i < ctx->num_vars; i++) {
+		xfree(ctx->vars[i].key);
+		xfree(ctx->vars[i].value);
+	}
+	xfree(ctx->vars);
+}
+
 EXPORT_SYMBOL(nft_ctx_add_include_path);
 int nft_ctx_add_include_path(struct nft_ctx *ctx, const char *path)
 {
@@ -178,6 +215,7 @@ struct nft_ctx *nft_ctx_new(uint32_t flags)
 	ctx->flags = flags;
 	ctx->output.output_fp = stdout;
 	ctx->output.error_fp = stderr;
+	init_list_head(&ctx->vars_ctx.indesc_list);
 
 	if (flags == NFT_CTX_DEFAULT)
 		nft_ctx_netlink_init(ctx);
@@ -311,6 +349,7 @@ void nft_ctx_free(struct nft_ctx *ctx)
 	exit_cookie(&ctx->output.error_cookie);
 	iface_cache_release();
 	nft_cache_release(&ctx->cache);
+	nft_ctx_clear_vars(ctx);
 	nft_ctx_clear_include_paths(ctx);
 	scope_free(ctx->top_scope);
 	xfree(ctx->state);
@@ -507,6 +546,47 @@ err:
 	return rc;
 }
 
+static int load_cmdline_vars(struct nft_ctx *ctx, struct list_head *msgs)
+{
+	unsigned int bufsize, ret, i, offset = 0;
+	LIST_HEAD(cmds);
+	char *buf;
+	int rc;
+
+	if (ctx->num_vars == 0)
+		return 0;
+
+	bufsize = 1024;
+	buf = xzalloc(bufsize + 1);
+	for (i = 0; i < ctx->num_vars; i++) {
+retry:
+		ret = snprintf(buf + offset, bufsize - offset,
+			       "define %s=%s; ",
+			       ctx->vars[i].key, ctx->vars[i].value);
+		if (ret >= bufsize - offset) {
+			bufsize *= 2;
+			buf = xrealloc(buf, bufsize + 1);
+			goto retry;
+		}
+		offset += ret;
+	}
+	snprintf(buf + offset, bufsize - offset, "\n");
+
+	rc = nft_parse_bison_buffer(ctx, buf, msgs, &cmds);
+
+	assert(list_empty(&cmds));
+	/* Stash the buffer that contains the variable definitions and zap the
+	 * list of input descriptor before releasing the scanner state,
+	 * otherwise error reporting path walks over released objects.
+	 */
+	ctx->vars_ctx.buf = buf;
+	list_splice_init(&ctx->state->indesc_list, &ctx->vars_ctx.indesc_list);
+	scanner_destroy(ctx);
+	ctx->scanner = NULL;
+
+	return rc;
+}
+
 EXPORT_SYMBOL(nft_run_cmd_from_filename);
 int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 {
@@ -515,6 +595,10 @@ int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename)
 	LIST_HEAD(msgs);
 	LIST_HEAD(cmds);
 
+	rc = load_cmdline_vars(nft, &msgs);
+	if (rc < 0)
+		goto err;
+
 	if (!strcmp(filename, "-"))
 		filename = "/dev/stdin";
 
@@ -548,6 +632,17 @@ err:
 		scanner_destroy(nft);
 		nft->scanner = NULL;
 	}
+	if (!list_empty(&nft->vars_ctx.indesc_list)) {
+		struct input_descriptor *indesc, *next;
+
+		list_for_each_entry_safe(indesc, next, &nft->vars_ctx.indesc_list, list) {
+			if (indesc->name)
+				xfree(indesc->name);
+
+			xfree(indesc);
+		}
+	}
+	xfree(nft->vars_ctx.buf);
 
 	if (!rc &&
 	    nft_output_json(&nft->output) &&
diff --git a/src/main.c b/src/main.c
index 8c47064459ec..21096fc7398b 100644
--- a/src/main.c
+++ b/src/main.c
@@ -32,6 +32,7 @@ enum opt_indices {
         /* Ruleset input handling */
 	IDX_FILE,
 #define IDX_RULESET_INPUT_START	IDX_FILE
+	IDX_DEFINE,
 	IDX_INTERACTIVE,
         IDX_INCLUDEPATH,
 	IDX_CHECK,
@@ -63,6 +64,7 @@ enum opt_vals {
 	OPT_VERSION_LONG	= 'V',
 	OPT_CHECK		= 'c',
 	OPT_FILE		= 'f',
+	OPT_DEFINE		= 'D',
 	OPT_INTERACTIVE		= 'i',
 	OPT_INCLUDEPATH		= 'I',
 	OPT_JSON		= 'j',
@@ -100,6 +102,8 @@ static const struct nft_opt nft_options[] = {
 				     "Show extended version information"),
 	[IDX_FILE]	    = NFT_OPT("file",			OPT_FILE,		"<filename>",
 				     "Read input from <filename>"),
+	[IDX_DEFINE]	    = NFT_OPT("define",			OPT_DEFINE,		"<name=value>",
+				     "Define variable, e.g. --define foo=1.2.3.4"),
 	[IDX_INTERACTIVE]   = NFT_OPT("interactive",		OPT_INTERACTIVE,	NULL,
 				     "Read input from interactive CLI"),
 	[IDX_INCLUDEPATH]   = NFT_OPT("includepath",		OPT_INCLUDEPATH,	"<directory>",
@@ -332,8 +336,10 @@ static bool nft_options_check(int argc, char * const argv[])
 			} else if (argv[i][1] == 'd' ||
 				   argv[i][1] == 'I' ||
 				   argv[i][1] == 'f' ||
+				   argv[i][1] == 'D' ||
 				   !strcmp(argv[i], "--debug") ||
 				   !strcmp(argv[i], "--includepath") ||
+				   !strcmp(argv[i], "--define") ||
 				   !strcmp(argv[i], "--file")) {
 				skip = true;
 				continue;
@@ -349,10 +355,10 @@ static bool nft_options_check(int argc, char * const argv[])
 int main(int argc, char * const *argv)
 {
 	const struct option *options = get_options();
+	bool interactive = false, define = false;
 	const char *optstring = get_optstring();
 	char *buf = NULL, *filename = NULL;
 	unsigned int output_flags = 0;
-	bool interactive = false;
 	unsigned int debug_mask;
 	unsigned int len;
 	int i, val, rc;
@@ -378,6 +384,15 @@ int main(int argc, char * const *argv)
 		case OPT_VERSION_LONG:
 			show_version();
 			exit(EXIT_SUCCESS);
+		case OPT_DEFINE:
+			if (nft_ctx_add_var(nft, optarg)) {
+				fprintf(stderr,
+					"Failed to define variable '%s'\n",
+					optarg);
+				exit(EXIT_FAILURE);
+			}
+			define = true;
+			break;
 		case OPT_CHECK:
 			nft_ctx_set_dry_run(nft, true);
 			break;
@@ -470,6 +485,11 @@ int main(int argc, char * const *argv)
 		}
 	}
 
+	if (!filename && define) {
+		fprintf(stderr, "Error: -D/--define can only be used with -f/--filename\n");
+		exit(EXIT_FAILURE);
+	}
+
 	nft_ctx_output_set_flags(nft, output_flags);
 
 	if (optind != argc) {
-- 
2.20.1

