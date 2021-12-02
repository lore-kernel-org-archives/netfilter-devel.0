Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDBE2C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Dec 2021 13:12:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhLBNPp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 08:15:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354849AbhLBNPW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 08:15:22 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712A9C061757
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Dec 2021 05:11:52 -0800 (PST)
Received: from localhost ([::1]:37962 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mslsM-0001Vc-Mz; Thu, 02 Dec 2021 14:11:50 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 5/5] cache: Support filtering for a specific flowtable
Date:   Thu,  2 Dec 2021 14:11:36 +0100
Message-Id: <20211202131136.29242-6-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211202131136.29242-1-phil@nwl.cc>
References: <20211202131136.29242-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extend nft_cache_filter to hold a flowtable name so 'list flowtable'
command causes fetching the requested flowtable only.

Dump flowtables just once instead of for each table, merely assign
fetched data to tables inside the loop.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Catch ENOENT instead of speculating about error cause.
---
 include/cache.h                               |  1 +
 include/mnl.h                                 |  3 +-
 src/cache.c                                   | 55 ++++++++++++++-----
 src/mnl.c                                     | 14 +++--
 src/netlink.c                                 |  3 +-
 tests/shell/testcases/listing/0020flowtable_0 | 51 +++++++++++++++--
 6 files changed, 103 insertions(+), 24 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index 3a9a5e8197114..d185f3cfeda06 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -54,6 +54,7 @@ struct nft_cache_filter {
 		const char	*table;
 		const char	*chain;
 		const char	*set;
+		const char	*ft;
 	} list;
 
 	struct {
diff --git a/include/mnl.h b/include/mnl.h
index 8659879c17f44..b006192cf7b23 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -77,7 +77,8 @@ int mnl_nft_obj_add(struct netlink_ctx *ctx, struct cmd *cmd,
 int mnl_nft_obj_del(struct netlink_ctx *ctx, struct cmd *cmd, int type);
 
 struct nftnl_flowtable_list *
-mnl_nft_flowtable_dump(struct netlink_ctx *ctx, int family, const char *table);
+mnl_nft_flowtable_dump(struct netlink_ctx *ctx, int family,
+		       const char *table, const char *ft);
 
 int mnl_nft_flowtable_add(struct netlink_ctx *ctx, struct cmd *cmd,
 			  unsigned int flags);
diff --git a/src/cache.c b/src/cache.c
index 38a34ee3c406f..6494e4743f8dd 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -229,6 +229,15 @@ static unsigned int evaluate_cache_list(struct nft_ctx *nft, struct cmd *cmd,
 	case CMD_OBJ_MAPS:
 		flags |= NFT_CACHE_TABLE | NFT_CACHE_SET;
 		break;
+	case CMD_OBJ_FLOWTABLE:
+		if (filter &&
+		    cmd->handle.table.name &&
+		    cmd->handle.flowtable.name) {
+			filter->list.family = cmd->handle.family;
+			filter->list.table = cmd->handle.table.name;
+			filter->list.ft = cmd->handle.flowtable.name;
+		}
+		/* fall through */
 	case CMD_OBJ_FLOWTABLES:
 		flags |= NFT_CACHE_TABLE | NFT_CACHE_FLOWTABLE;
 		break;
@@ -681,10 +690,19 @@ struct ft_cache_dump_ctx {
 static int ft_cache_cb(struct nftnl_flowtable *nlf, void *arg)
 {
 	struct ft_cache_dump_ctx *ctx = arg;
-	const char *ft_name;
 	struct flowtable *ft;
+	const char *ft_table;
+	const char *ft_name;
+	uint32_t ft_family;
 	uint32_t hash;
 
+	ft_family = nftnl_flowtable_get_u32(nlf, NFTNL_FLOWTABLE_FAMILY);
+	ft_table = nftnl_flowtable_get_str(nlf, NFTNL_FLOWTABLE_TABLE);
+
+	if (ft_family != ctx->table->handle.family ||
+	    strcmp(ft_table, ctx->table->handle.table.name))
+		return 0;
+
 	ft = netlink_delinearize_flowtable(ctx->nlctx, nlf);
 	if (!ft)
 		return -1;
@@ -693,6 +711,8 @@ static int ft_cache_cb(struct nftnl_flowtable *nlf, void *arg)
 	hash = djb_hash(ft_name) % NFT_CACHE_HSIZE;
 	cache_add(&ft->cache, &ctx->table->ft_cache, hash);
 
+	nftnl_flowtable_list_del(nlf);
+	nftnl_flowtable_free(nlf);
 	return 0;
 }
 
@@ -708,13 +728,21 @@ static int ft_cache_init(struct netlink_ctx *ctx, struct table *table,
 	return 0;
 }
 
-static struct nftnl_flowtable_list *ft_cache_dump(struct netlink_ctx *ctx,
-						  const struct table *table)
+static struct nftnl_flowtable_list *
+ft_cache_dump(struct netlink_ctx *ctx, const struct nft_cache_filter *filter)
 {
 	struct nftnl_flowtable_list *ft_list;
+	int family = NFPROTO_UNSPEC;
+	const char *table = NULL;
+	const char *ft = NULL;
 
-	ft_list = mnl_nft_flowtable_dump(ctx, table->handle.family,
-					 table->handle.table.name);
+	if (filter) {
+		family = filter->list.family;
+		table = filter->list.table;
+		ft = filter->list.ft;
+	}
+
+	ft_list = mnl_nft_flowtable_dump(ctx, family, table, ft);
 	if (!ft_list) {
                 if (errno == EINTR)
 			return NULL;
@@ -801,6 +829,13 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 			goto cache_fails;
 		}
 	}
+	if (flags & NFT_CACHE_FLOWTABLE_BIT) {
+		ft_list = ft_cache_dump(ctx, filter);
+		if (!ft_list) {
+			ret = -1;
+			goto cache_fails;
+		}
+	}
 
 	list_for_each_entry(table, &ctx->nft->cache.table_cache.list, cache.list) {
 		if (flags & NFT_CACHE_SET_BIT) {
@@ -849,15 +884,7 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 			}
 		}
 		if (flags & NFT_CACHE_FLOWTABLE_BIT) {
-			ft_list = ft_cache_dump(ctx, table);
-			if (!ft_list) {
-				ret = -1;
-				goto cache_fails;
-			}
 			ret = ft_cache_init(ctx, table, ft_list);
-
-			nftnl_flowtable_list_free(ft_list);
-
 			if (ret < 0) {
 				ret = -1;
 				goto cache_fails;
@@ -903,6 +930,8 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 cache_fails:
 	if (set_list)
 		nftnl_set_list_free(set_list);
+	if (ft_list)
+		nftnl_flowtable_list_free(ft_list);
 
 	if (flags & NFT_CACHE_CHAIN_BIT)
 		nftnl_chain_list_free(chain_list);
diff --git a/src/mnl.c b/src/mnl.c
index 47b3ca613e419..5413f8658f9b3 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1826,11 +1826,13 @@ err_free:
 }
 
 struct nftnl_flowtable_list *
-mnl_nft_flowtable_dump(struct netlink_ctx *ctx, int family, const char *table)
+mnl_nft_flowtable_dump(struct netlink_ctx *ctx, int family,
+		       const char *table, const char *ft)
 {
 	struct nftnl_flowtable_list *nln_list;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nftnl_flowtable *n;
+	int flags = NLM_F_DUMP;
 	struct nlmsghdr *nlh;
 	int ret;
 
@@ -1838,10 +1840,14 @@ mnl_nft_flowtable_dump(struct netlink_ctx *ctx, int family, const char *table)
 	if (n == NULL)
 		memory_allocation_error();
 
-	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETFLOWTABLE, family,
-				    NLM_F_DUMP, ctx->seqnum);
 	if (table != NULL)
 		nftnl_flowtable_set_str(n, NFTNL_FLOWTABLE_TABLE, table);
+	if (ft) {
+		nftnl_flowtable_set_str(n, NFTNL_FLOWTABLE_NAME, ft);
+		flags = NLM_F_ACK;
+	}
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETFLOWTABLE, family,
+				    flags, ctx->seqnum);
 	nftnl_flowtable_nlmsg_build_payload(nlh, n);
 	nftnl_flowtable_free(n);
 
@@ -1850,7 +1856,7 @@ mnl_nft_flowtable_dump(struct netlink_ctx *ctx, int family, const char *table)
 		memory_allocation_error();
 
 	ret = nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, flowtable_cb, nln_list);
-	if (ret < 0)
+	if (ret < 0 && errno != ENOENT)
 		goto err;
 
 	return nln_list;
diff --git a/src/netlink.c b/src/netlink.c
index f74c0383a0db3..359d801c29d35 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1721,7 +1721,8 @@ int netlink_list_flowtables(struct netlink_ctx *ctx, const struct handle *h)
 	struct nftnl_flowtable_list *flowtable_cache;
 	int err;
 
-	flowtable_cache = mnl_nft_flowtable_dump(ctx, h->family, h->table.name);
+	flowtable_cache = mnl_nft_flowtable_dump(ctx, h->family,
+						 h->table.name, NULL);
 	if (flowtable_cache == NULL) {
 		if (errno == EINTR)
 			return -1;
diff --git a/tests/shell/testcases/listing/0020flowtable_0 b/tests/shell/testcases/listing/0020flowtable_0
index 2f0a98d16fd38..47488d8ea92a4 100755
--- a/tests/shell/testcases/listing/0020flowtable_0
+++ b/tests/shell/testcases/listing/0020flowtable_0
@@ -2,19 +2,60 @@
 
 # list only the flowtable asked for with table
 
+FLOWTABLES="flowtable f {
+	hook ingress priority filter
+	devices = { lo }
+}
+flowtable f2 {
+	hook ingress priority filter
+	devices = { d0 }
+}"
+
+RULESET="table inet filter {
+	$FLOWTABLES
+}
+table ip filter {
+	$FLOWTABLES
+}"
+
 EXPECTED="table inet filter {
 	flowtable f {
 		hook ingress priority filter
 		devices = { lo }
 	}
 }"
+EXPECTED2="table ip filter {
+	flowtable f2 {
+		hook ingress priority filter
+		devices = { d0 }
+	}
+}"
+EXPECTED3="table ip filter {
+	flowtable f {
+		hook ingress priority filter
+		devices = { lo }
+	}
+	flowtable f2 {
+		hook ingress priority filter
+		devices = { d0 }
+	}
+}"
+
+ip link add d0 type dummy || {
+	echo "Skipping, no dummy interface available"
+	exit 0
+}
+trap "ip link del d0" EXIT
 
 set -e
 
-$NFT -f - <<< "$EXPECTED"
+$NFT -f - <<< "$RULESET"
 
 GET="$($NFT list flowtable inet filter f)"
-if [ "$EXPECTED" != "$GET" ] ; then
-	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
-	exit 1
-fi
+$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+
+GET="$($NFT list flowtable ip filter f2)"
+$DIFF -u <(echo "$EXPECTED2") <(echo "$GET")
+
+GET="$($NFT list flowtables ip)"
+$DIFF -u <(echo "$EXPECTED3") <(echo "$GET")
-- 
2.33.0

