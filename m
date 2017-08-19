From: Eric Leblond <eric@regit.org>
Subject: [PATH nft v2 14/18] libnftables: transaction support
Date: Sat, 19 Aug 2017 17:24:16 +0200
Message-ID: <20170819152420.22563-15-eric@regit.org>
References: <20170819152420.22563-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:33822 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751667AbdHSPdK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Aug 2017 11:33:10 -0400
In-Reply-To: <20170819152420.22563-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add batch support for libnftables. This patch
provides a set of function to handle batch command.

The cinematic is the following:
 * nft_batch_start to allocate the batch structure
 * multiple call to nft_batch_add
 * nft_batch_commit to do the commit to kernel
 * nft_batch_free to free the batch

Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/netlink.h           |   5 +++
 include/nftables/nftables.h |   7 +++
 src/libnftables.c           | 102 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 114 insertions(+)

diff --git a/include/netlink.h b/include/netlink.h
index 0e1d26b..b7f87c0 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -54,6 +54,11 @@ struct netlink_ctx {
 	struct nft_cache	*cache;
 };
 
+struct nft_batch {
+	struct netlink_ctx	nl_ctx;
+	struct nftnl_batch	*batch;
+};
+
 extern struct nftnl_table *alloc_nftnl_table(const struct handle *h);
 extern struct nftnl_chain *alloc_nftnl_chain(const struct handle *h);
 extern struct nftnl_rule *alloc_nftnl_rule(const struct handle *h);
diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
index 935d0db..2ddb38a 100644
--- a/include/nftables/nftables.h
+++ b/include/nftables/nftables.h
@@ -34,4 +34,11 @@ int nft_run_command_from_buffer(struct nft_ctx *nft,
 				char *buf, size_t buflen);
 int nft_run_command_from_filename(struct nft_ctx *nft, const char *filename);
 
+
+struct nft_batch *nft_batch_start(struct nft_ctx *ctx);
+int nft_batch_add(struct nft_ctx *ctx, struct nft_batch *batch,
+		  const char * buf, size_t buflen);
+int nft_batch_commit(struct nft_ctx *ctx, struct nft_batch *batch);
+void nft_batch_free(struct nft_batch *batch);
+
 #endif
diff --git a/src/libnftables.c b/src/libnftables.c
index f0decae..61ed4e5 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -151,3 +151,105 @@ int nft_run_command_from_filename(struct nft_ctx *nft, const char *filename)
 	erec_print_list(stderr, &msgs);
 	return rc;
 }
+
+struct nft_batch *nft_batch_start(struct nft_ctx *nft)
+{
+	uint32_t seqnum;
+	bool batch_supported = netlink_batch_supported(nft->nf_sock, &seqnum);
+	struct nft_batch *batch = NULL;
+
+	if (!batch_supported)
+		return NULL;
+
+	batch = calloc(1, sizeof(*batch));
+	if (batch == NULL)
+		return NULL;
+
+	batch->batch = mnl_batch_init();
+	mnl_batch_begin(batch->batch, mnl_seqnum_alloc(&nft->cache.seqnum));
+
+	batch->nl_ctx.msgs = &nft->output.msgs;
+	batch->nl_ctx.batch = batch->batch;
+	batch->nl_ctx.batch_supported = batch_supported;
+	batch->nl_ctx.octx = &nft->output;
+	batch->nl_ctx.nf_sock = nft->nf_sock;
+	batch->nl_ctx.cache = &nft->cache;
+	init_list_head(&batch->nl_ctx.list);
+	return batch;
+}
+
+int nft_batch_add(struct nft_ctx *nft, struct nft_batch *batch,
+		  const char * buf, size_t buflen)
+{
+	int rc = NFT_EXIT_SUCCESS;
+	int ret = 0;
+	struct parser_state state;
+	LIST_HEAD(msgs);
+	void *scanner;
+	struct cmd *cmd, *next;
+	struct netlink_ctx *ctx = &batch->nl_ctx;
+	uint32_t seqnum;
+
+	parser_init(nft->nf_sock, &nft->cache, &state, &msgs);
+	scanner = scanner_init(&state);
+	scanner_push_buffer(scanner, &indesc_cmdline, buf);
+		
+	ret = nft_parse(scanner, &state);
+	if (ret != 0 || state.nerrs > 0) {
+		rc = NFT_EXIT_FAILURE;
+		goto err1;
+	} 
+
+	list_for_each_entry(cmd, &state.cmds, list) {
+		nft_cmd_expand(cmd);
+		ctx->seqnum = cmd->seqnum = mnl_seqnum_alloc(&seqnum);
+		ret = do_command(ctx, cmd);
+		if (ret < 0)
+			return NFT_EXIT_FAILURE;
+	}
+
+	list_for_each_entry_safe(cmd, next, &state.cmds, list) {
+		list_del(&cmd->list);
+		cmd_free(cmd);
+	}
+err1:
+	scanner_destroy(scanner);
+	erec_print_list(stderr, &msgs);
+	return rc;
+}
+
+int nft_batch_commit(struct nft_ctx *nft, struct nft_batch *batch)
+{
+	int ret = 0;
+	LIST_HEAD(err_list);
+
+	mnl_batch_end(batch->batch, mnl_seqnum_alloc(&nft->cache.seqnum));
+
+	if (!mnl_batch_ready(batch->batch)) {
+		ret = -1;
+		goto out;
+	}
+
+	ret = netlink_batch_send(&batch->nl_ctx, &err_list);
+	if (ret == -1) {
+		struct mnl_err *err, *tmp;
+		list_for_each_entry_safe(err, tmp, &err_list, head) {
+			netlink_io_error(&batch->nl_ctx, NULL,
+					 "Could not process rule: %s",
+					 strerror(err->err));
+			/* multiple errno but let's return one */
+			ret = -err->err;
+			mnl_err_list_free(err);
+		}
+	}
+out:
+	return ret;
+}
+
+void nft_batch_free(struct nft_batch *batch)
+{
+	if (batch == NULL)
+		return;
+	mnl_batch_reset(batch->batch);
+	xfree(batch);
+}
-- 
2.14.1

