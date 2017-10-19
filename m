From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 7/7] libnftables: Add remaining getters and setters
Date: Thu, 19 Oct 2017 10:18:47 +0200
Message-ID: <20171019081847.16171-8-phil@nwl.cc>
References: <20171019081847.16171-1-phil@nwl.cc>
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:49392 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751908AbdJSITA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2017 04:19:00 -0400
In-Reply-To: <20171019081847.16171-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Provide API functions for remaining context settings changed by main.c,
then hide struct nft_ctx definition from applications. This allows us to
later change data structures internally without risk of breaking
applications.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/nftables.h          | 27 +++++++++++++++++++++
 include/nftables/nftables.h | 41 ++++++++++---------------------
 src/libnftables.c           | 59 +++++++++++++++++++++++++++++++++++++++++++++
 src/main.c                  | 18 +++++++++-----
 4 files changed, 111 insertions(+), 34 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index a633e1a2cc2e2..ad72383303bdb 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -6,6 +6,33 @@
 #include <utils.h>
 #include <nftables/nftables.h>
 
+struct nft_cache {
+	bool			initialized;
+	struct list_head	list;
+	uint32_t		seqnum;
+};
+
+struct output_ctx {
+	unsigned int numeric;
+	unsigned int stateless;
+	unsigned int ip2name;
+	unsigned int handle;
+	unsigned int echo;
+	FILE *output_fp;
+};
+
+struct nft_ctx {
+	struct mnl_socket	*nf_sock;
+	char			**include_paths;
+	unsigned int		num_include_paths;
+	unsigned int		parser_max_errors;
+	unsigned int		debug_mask;
+	struct output_ctx	output;
+	bool			check;
+	struct nft_cache	cache;
+	uint32_t		flags;
+};
+
 struct input_descriptor;
 struct location {
 	const struct input_descriptor		*indesc;
diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
index a752f20d74132..2bc3061457257 100644
--- a/include/nftables/nftables.h
+++ b/include/nftables/nftables.h
@@ -9,34 +9,7 @@
 #ifndef LIB_NFTABLES_H
 #define LIB_NFTABLES_H
 
-struct mnl_socket;
-
-struct nft_cache {
-	bool			initialized;
-	struct list_head	list;
-	uint32_t		seqnum;
-};
-
-struct output_ctx {
-	unsigned int numeric;
-	unsigned int stateless;
-	unsigned int ip2name;
-	unsigned int handle;
-	unsigned int echo;
-	FILE *output_fp;
-};
-
-struct nft_ctx {
-	struct mnl_socket	*nf_sock;
-	char			**include_paths;
-	unsigned int		num_include_paths;
-	unsigned int		parser_max_errors;
-	unsigned int		debug_mask;
-	struct output_ctx	output;
-	bool			check;
-	struct nft_cache	cache;
-	uint32_t		flags;
-};
+struct nft_ctx;
 
 enum debug_level {
 	DEBUG_SCANNER		= 0x1,
@@ -78,6 +51,18 @@ FILE *nft_ctx_set_output(struct nft_ctx *ctx, FILE *fp);
 void nft_ctx_set_dry_run(struct nft_ctx *ctx, bool dry);
 int nft_ctx_add_include_path(struct nft_ctx *ctx, const char *path);
 void nft_ctx_clear_include_paths(struct nft_ctx *ctx);
+enum numeric_level nft_ctx_output_get_numeric(struct nft_ctx *ctx);
+void nft_ctx_output_set_numeric(struct nft_ctx *ctx, enum numeric_level level);
+bool nft_ctx_output_get_stateless(struct nft_ctx *ctx);
+void nft_ctx_output_set_stateless(struct nft_ctx *ctx, bool val);
+bool nft_ctx_output_get_ip2name(struct nft_ctx *ctx);
+void nft_ctx_output_set_ip2name(struct nft_ctx *ctx, bool val);
+unsigned int nft_ctx_output_get_debug(struct nft_ctx *ctx);
+void nft_ctx_output_set_debug(struct nft_ctx *ctx, unsigned int mask);
+bool nft_ctx_output_get_handle(struct nft_ctx *ctx);
+void nft_ctx_output_set_handle(struct nft_ctx *ctx, bool val);
+bool nft_ctx_output_get_echo(struct nft_ctx *ctx);
+void nft_ctx_output_set_echo(struct nft_ctx *ctx, bool val);
 
 void nft_ctx_flush_cache(struct nft_ctx *ctx);
 
diff --git a/src/libnftables.c b/src/libnftables.c
index 2f4275c9a0a94..925c96d1272a3 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -206,6 +206,65 @@ void nft_ctx_set_dry_run(struct nft_ctx *ctx, bool dry)
 	ctx->check = dry;
 }
 
+enum numeric_level nft_ctx_output_get_numeric(struct nft_ctx *ctx)
+{
+	return ctx->output.numeric;
+}
+
+void nft_ctx_output_set_numeric(struct nft_ctx *ctx, enum numeric_level level)
+{
+	ctx->output.numeric = level;
+}
+
+bool nft_ctx_output_get_stateless(struct nft_ctx *ctx)
+{
+	return ctx->output.stateless;
+}
+
+void nft_ctx_output_set_stateless(struct nft_ctx *ctx, bool val)
+{
+	ctx->output.stateless = val;
+}
+
+bool nft_ctx_output_get_ip2name(struct nft_ctx *ctx)
+{
+	return ctx->output.ip2name;
+}
+
+void nft_ctx_output_set_ip2name(struct nft_ctx *ctx, bool val)
+{
+	ctx->output.ip2name = val;
+}
+
+unsigned int nft_ctx_output_get_debug(struct nft_ctx *ctx)
+{
+	return ctx->debug_mask;
+}
+void nft_ctx_output_set_debug(struct nft_ctx *ctx, unsigned int mask)
+{
+	ctx->debug_mask = mask;
+}
+
+bool nft_ctx_output_get_handle(struct nft_ctx *ctx)
+{
+	return ctx->output.handle;
+}
+
+void nft_ctx_output_set_handle(struct nft_ctx *ctx, bool val)
+{
+	ctx->output.handle = val;
+}
+
+bool nft_ctx_output_get_echo(struct nft_ctx *ctx)
+{
+	return ctx->output.echo;
+}
+
+void nft_ctx_output_set_echo(struct nft_ctx *ctx, bool val)
+{
+	ctx->output.echo = val;
+}
+
 static const struct input_descriptor indesc_cmdline = {
 	.type	= INDESC_BUFFER,
 	.name	= "<cmdline>",
diff --git a/src/main.c b/src/main.c
index de5c115757f44..c65966bcf5995 100644
--- a/src/main.c
+++ b/src/main.c
@@ -169,6 +169,8 @@ int main(int argc, char * const *argv)
 	unsigned int len;
 	bool interactive = false;
 	int i, val, rc;
+	enum numeric_level numeric;
+	unsigned int debug_mask;
 
 	nft = nft_ctx_new(NFT_CTX_DEFAULT);
 	nft_ctx_set_output(nft, stdout);
@@ -204,20 +206,23 @@ int main(int argc, char * const *argv)
 			}
 			break;
 		case OPT_NUMERIC:
-			if (++nft->output.numeric > NUMERIC_ALL) {
+			numeric = nft_ctx_output_get_numeric(nft);
+			if (numeric == NUMERIC_ALL) {
 				fprintf(stderr, "Too many numeric options "
 						"used, max. %u\n",
 					NUMERIC_ALL);
 				exit(NFT_EXIT_FAILURE);
 			}
+			nft_ctx_output_set_numeric(nft, numeric + 1);
 			break;
 		case OPT_STATELESS:
-			nft->output.stateless++;
+			nft_ctx_output_set_stateless(nft, true);
 			break;
 		case OPT_IP2NAME:
-			nft->output.ip2name++;
+			nft_ctx_output_set_ip2name(nft, true);
 			break;
 		case OPT_DEBUG:
+			debug_mask = nft_ctx_output_get_debug(nft);
 			for (;;) {
 				unsigned int i;
 				char *end;
@@ -229,7 +234,7 @@ int main(int argc, char * const *argv)
 				for (i = 0; i < array_size(debug_param); i++) {
 					if (strcmp(debug_param[i].name, optarg))
 						continue;
-					nft->debug_mask |= debug_param[i].level;
+					debug_mask |= debug_param[i].level;
 					break;
 				}
 
@@ -243,12 +248,13 @@ int main(int argc, char * const *argv)
 					break;
 				optarg = end + 1;
 			}
+			nft_ctx_output_set_debug(nft, debug_mask);
 			break;
 		case OPT_HANDLE_OUTPUT:
-			nft->output.handle++;
+			nft_ctx_output_set_handle(nft, true);
 			break;
 		case OPT_ECHO:
-			nft->output.echo++;
+			nft_ctx_output_set_echo(nft, true);
 			break;
 		case OPT_INVALID:
 			exit(NFT_EXIT_FAILURE);
-- 
2.13.1

