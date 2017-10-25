From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH] libnftables: Get rid of explicit cache flushes
Date: Wed, 25 Oct 2017 13:40:29 +0200
Message-ID: <20171025114029.22043-1-phil@nwl.cc>
References: <20171025092515.GB350@salvia>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:37746 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750747AbdJYLkn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2017 07:40:43 -0400
In-Reply-To: <20171025092515.GB350@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In the past, CLI as a potentially long running process had to make sure
it kept it's cache up to date with kernel's rule set. A simple test case
is this:

| shell a		|	shell b
|			|	# nft -i
| # nft add table ip t	|
|			|	nft> list ruleset
|			|	table ip t {
|			|	}
| # nft flush ruleset	|
|			|	nft> list ruleset
|			|	nft>

In order to make sure interactive CLI wouldn't incorrectly list the
table again in the second 'list' command, it immediately flushed it's
cache after every command execution.

This patch eliminates the need for that by making cache updates depend
on kernel's generation ID: A cache update stores the current rule set's
ID in struct nft_cache, consecutive calls to cache_update() compare that
stored value to the current generation ID received from kernel - if the
stored value is zero (i.e. no previous cache update did happen) or if it
doesn't match the kernel's value (i.e. cache is outdated) the cache is
flushed and fully initialized again.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/mnl.h               |  2 +-
 include/netlink.h           |  2 +-
 include/nftables.h          |  2 +-
 include/nftables/nftables.h |  2 --
 src/cli.c                   |  1 -
 src/libnftables.c           |  9 ++-------
 src/mnl.c                   |  4 +++-
 src/netlink.c               |  4 ++--
 src/rule.c                  | 12 +++++++-----
 9 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index 3df71467c1080..84c362a23bd79 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -15,7 +15,7 @@ struct mnl_socket *netlink_open_sock(void);
 void netlink_close_sock(struct mnl_socket *nf_sock);
 
 uint32_t mnl_seqnum_alloc(uint32_t *seqnum);
-void mnl_genid_get(struct mnl_socket *nf_sock, uint32_t seqnum);
+uint16_t mnl_genid_get(struct mnl_socket *nf_sock, uint32_t seqnum);
 
 struct mnl_err {
 	struct list_head	head;
diff --git a/include/netlink.h b/include/netlink.h
index 2ca6f345b6ac9..b30c05f833554 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -191,7 +191,7 @@ extern void netlink_dump_obj(struct nftnl_obj *nlo, struct netlink_ctx *ctx);
 
 extern int netlink_batch_send(struct netlink_ctx *ctx, struct list_head *err_list);
 
-extern void netlink_genid_get(struct mnl_socket *nf_sock, uint32_t seqnum);
+extern uint16_t netlink_genid_get(struct mnl_socket *nf_sock, uint32_t seqnum);
 extern void netlink_restart(struct mnl_socket *nf_sock);
 #define netlink_abi_error()	\
 	__netlink_abi_error(__FILE__, __LINE__, strerror(errno));
diff --git a/include/nftables.h b/include/nftables.h
index 97a0436693cfa..d69079fe03e3a 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -16,7 +16,7 @@ struct output_ctx {
 };
 
 struct nft_cache {
-	bool			initialized;
+	uint16_t		genid;
 	struct list_head	list;
 	uint32_t		seqnum;
 };
diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
index 449f9e4ee879c..4211be76e6e40 100644
--- a/include/nftables/nftables.h
+++ b/include/nftables/nftables.h
@@ -70,8 +70,6 @@ FILE *nft_ctx_set_output(struct nft_ctx *ctx, FILE *fp);
 int nft_ctx_add_include_path(struct nft_ctx *ctx, const char *path);
 void nft_ctx_clear_include_paths(struct nft_ctx *ctx);
 
-void nft_ctx_flush_cache(struct nft_ctx *ctx);
-
 int nft_run_cmd_from_buffer(struct nft_ctx *nft, char *buf, size_t buflen);
 int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename);
 
diff --git a/src/cli.c b/src/cli.c
index 37351f2f8b04f..ec4d2a6f2046d 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -128,7 +128,6 @@ static void cli_complete(char *line)
 
 	nft_run_cmd_from_buffer(cli_nft, line, len + 2);
 	xfree(line);
-	nft_ctx_flush_cache(cli_nft);
 }
 
 static char **cli_completion(const char *text, int start, int end)
diff --git a/src/libnftables.c b/src/libnftables.c
index 5ef5532c7f075..0d04ec21d57d3 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -174,18 +174,13 @@ struct nft_ctx *nft_ctx_new(uint32_t flags)
 	return ctx;
 }
 
-void nft_ctx_flush_cache(struct nft_ctx *ctx)
-{
-	iface_cache_release();
-	cache_release(&ctx->cache);
-}
-
 void nft_ctx_free(struct nft_ctx *ctx)
 {
 	if (ctx->nf_sock)
 		netlink_close_sock(ctx->nf_sock);
 
-	nft_ctx_flush_cache(ctx);
+	iface_cache_release();
+	cache_release(&ctx->cache);
 	nft_ctx_clear_include_paths(ctx);
 	xfree(ctx);
 	nft_exit();
diff --git a/src/mnl.c b/src/mnl.c
index 8db2a1847ec51..3be6ebaf1f682 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -94,7 +94,7 @@ static int genid_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
-void mnl_genid_get(struct mnl_socket *nf_sock, uint32_t seqnum)
+uint16_t mnl_genid_get(struct mnl_socket *nf_sock, uint32_t seqnum)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct mnl_ctx ctx = {
@@ -106,6 +106,8 @@ void mnl_genid_get(struct mnl_socket *nf_sock, uint32_t seqnum)
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETGEN, AF_UNSPEC, 0, seqnum);
 	/* Skip error checking, old kernels sets res_id field to zero. */
 	nft_mnl_talk(&ctx, nlh, nlh->nlmsg_len, genid_cb, NULL);
+
+	return nft_genid;
 }
 
 static int check_genid(const struct nlmsghdr *nlh)
diff --git a/src/netlink.c b/src/netlink.c
index abc22504f877a..845eeeffd7387 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -75,9 +75,9 @@ void netlink_restart(struct mnl_socket *nf_sock)
 	nf_sock = netlink_open_sock();
 }
 
-void netlink_genid_get(struct mnl_socket *nf_sock, uint32_t seqnum)
+uint16_t netlink_genid_get(struct mnl_socket *nf_sock, uint32_t seqnum)
 {
-	mnl_genid_get(nf_sock, seqnum);
+	return mnl_genid_get(nf_sock, seqnum);
 }
 
 void __noreturn __netlink_abi_error(const char *file, int line,
diff --git a/src/rule.c b/src/rule.c
index 948478c96bda2..6a322167b8265 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -153,12 +153,14 @@ int cache_update(struct mnl_socket *nf_sock, struct nft_cache *cache,
 		 enum cmd_ops cmd, struct list_head *msgs, bool debug,
 		 struct output_ctx *octx)
 {
+	uint16_t genid;
 	int ret;
 
-	if (cache->initialized)
-		return 0;
 replay:
-	netlink_genid_get(nf_sock, cache->seqnum++);
+	genid = netlink_genid_get(nf_sock, cache->seqnum++);
+	if (genid && genid == cache->genid)
+		return 0;
+	cache_release(cache);
 	ret = cache_init(nf_sock, cache, cmd, msgs, debug, octx);
 	if (ret < 0) {
 		cache_release(cache);
@@ -168,7 +170,7 @@ replay:
 		}
 		return -1;
 	}
-	cache->initialized = true;
+	cache->genid = genid;
 	return 0;
 }
 
@@ -185,7 +187,7 @@ void cache_flush(struct list_head *table_list)
 void cache_release(struct nft_cache *cache)
 {
 	cache_flush(&cache->list);
-	cache->initialized = false;
+	cache->genid = 0;
 }
 
 /* internal ID to uniquely identify a set in the batch */
-- 
2.13.1

