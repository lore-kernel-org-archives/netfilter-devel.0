Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2837C13B2A4
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Aug 2024 08:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724662505; cv=none; b=jSXPx/5HSq8XTokV8rsEpbqtDrbMEFfwJiexb3pIjmph+UTSIGmXZ+qaE1Sp3vTGSpbWeDlB+gc340AxTg5pZMn1S0sROaNYtuj6oR11FuUjqjZZVCYmrMiMYkgXgYzMGvw24eSS4FaF3DANVO0ARa+27Lt3weDf77qOXq1ERGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724662505; c=relaxed/simple;
	bh=7fDneFaDUTRH8gtvCyJ3jQwQ6ljUM8h84UV7wIhluEQ=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QHf8OMj0DSOHZkw+lkDgnVvq1MeqCG3sIaqWRLaWqF4T3GT7vUCWFZDwzwbkENGciwO26MFBKlxQKIHVwlxA9ZuteK5/HdxyJ70ZZQeTu5l78Kc9gn1b9g8RYnDTV2cl9fFp5m4IjZPXrPX0jVxuWJzFKlxOy/sphgK0F1KAxlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 3/7] cache: add filtering support for objects
Date: Mon, 26 Aug 2024 10:54:51 +0200
Message-Id: <20240826085455.163392-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240826085455.163392-1-pablo@netfilter.org>
References: <20240826085455.163392-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, full ruleset flag is set on to fetch objects.

Follow a similar approach to these patches from Phil:

 de961b930660 ("cache: Filter set list on server side") and
 cb4b07d0b628 ("cache: Support filtering for a specific flowtable")

in preparation to update the reset command to use the cache
infrastructure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: remove check for if (filter) when evaluating cache requirements,
    filter must be present in reset command, add assert().

 include/cache.h |   2 +
 src/cache.c     | 100 +++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 89 insertions(+), 13 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index 44e8430ce1fd..c72bedf542dc 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -54,8 +54,10 @@ struct nft_cache_filter {
 		uint32_t	family;
 		const char	*table;
 		const char	*chain;
+		const char	*obj;
 		const char	*set;
 		const char	*ft;
+		int		obj_type;
 		uint64_t	rule_handle;
 	} list;
 
diff --git a/src/cache.c b/src/cache.c
index 082fd30b462d..3849a4640416 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -190,6 +190,22 @@ static unsigned int evaluate_cache_rename(struct cmd *cmd, unsigned int flags)
 	return flags;
 }
 
+static void obj_filter_setup(const struct cmd *cmd, unsigned int *flags,
+			     struct nft_cache_filter *filter, int type)
+{
+	assert(filter);
+
+	if (cmd->handle.family)
+		filter->list.family = cmd->handle.family;
+	if (cmd->handle.table.name)
+		filter->list.table = cmd->handle.table.name;
+	if (cmd->handle.obj.name)
+		filter->list.obj = cmd->handle.obj.name;
+
+	filter->list.obj_type = type;
+	*flags |= NFT_CACHE_TABLE | NFT_CACHE_OBJECT;
+}
+
 static unsigned int evaluate_cache_list(struct nft_ctx *nft, struct cmd *cmd,
 					unsigned int flags,
 					struct nft_cache_filter *filter)
@@ -251,6 +267,37 @@ static unsigned int evaluate_cache_list(struct nft_ctx *nft, struct cmd *cmd,
 	case CMD_OBJ_FLOWTABLES:
 		flags |= NFT_CACHE_TABLE | NFT_CACHE_FLOWTABLE;
 		break;
+	case CMD_OBJ_COUNTER:
+	case CMD_OBJ_COUNTERS:
+		obj_filter_setup(cmd, &flags, filter, NFT_OBJECT_COUNTER);
+		break;
+	case CMD_OBJ_QUOTA:
+	case CMD_OBJ_QUOTAS:
+		obj_filter_setup(cmd, &flags, filter, NFT_OBJECT_QUOTA);
+		break;
+	case CMD_OBJ_CT_HELPER:
+	case CMD_OBJ_CT_HELPERS:
+		obj_filter_setup(cmd, &flags, filter, NFT_OBJECT_CT_HELPER);
+		break;
+	case CMD_OBJ_LIMIT:
+	case CMD_OBJ_LIMITS:
+		obj_filter_setup(cmd, &flags, filter, NFT_OBJECT_LIMIT);
+		break;
+	case CMD_OBJ_CT_TIMEOUT:
+	case CMD_OBJ_CT_TIMEOUTS:
+		obj_filter_setup(cmd, &flags, filter, NFT_OBJECT_CT_TIMEOUT);
+		break;
+	case CMD_OBJ_SECMARK:
+	case CMD_OBJ_SECMARKS:
+		obj_filter_setup(cmd, &flags, filter, NFT_OBJECT_SECMARK);
+		break;
+	case CMD_OBJ_CT_EXPECT:
+		obj_filter_setup(cmd, &flags, filter, NFT_OBJECT_CT_EXPECT);
+		break;
+	case CMD_OBJ_SYNPROXY:
+	case CMD_OBJ_SYNPROXYS:
+		obj_filter_setup(cmd, &flags, filter, NFT_OBJECT_SYNPROXY);
+		break;
 	case CMD_OBJ_RULESET:
 	default:
 		flags |= NFT_CACHE_FULL;
@@ -782,10 +829,19 @@ struct obj_cache_dump_ctx {
 static int obj_cache_cb(struct nftnl_obj *nlo, void *arg)
 {
 	struct obj_cache_dump_ctx *ctx = arg;
+	const char *obj_table;
 	const char *obj_name;
+	uint32_t obj_family;
 	struct obj *obj;
 	uint32_t hash;
 
+	obj_table = nftnl_obj_get_str(nlo, NFTNL_OBJ_TABLE);
+	obj_family = nftnl_obj_get_u32(nlo, NFTNL_OBJ_FAMILY);
+
+	if (obj_family != ctx->table->handle.family ||
+	    strcmp(obj_table, ctx->table->handle.table.name))
+		return 0;
+
 	obj = netlink_delinearize_obj(ctx->nlctx, nlo);
 	if (!obj)
 		return -1;
@@ -794,6 +850,9 @@ static int obj_cache_cb(struct nftnl_obj *nlo, void *arg)
 	hash = djb_hash(obj_name) % NFT_CACHE_HSIZE;
 	cache_add(&obj->cache, &ctx->table->obj_cache, hash);
 
+	nftnl_obj_list_del(nlo);
+	nftnl_obj_free(nlo);
+
 	return 0;
 }
 
@@ -810,13 +869,27 @@ static int obj_cache_init(struct netlink_ctx *ctx, struct table *table,
 }
 
 static struct nftnl_obj_list *obj_cache_dump(struct netlink_ctx *ctx,
-					     const struct table *table)
+					     const struct nft_cache_filter *filter)
 {
 	struct nftnl_obj_list *obj_list;
+	int type = NFT_OBJECT_UNSPEC;
+	int family = NFPROTO_UNSPEC;
+	const char *table = NULL;
+	const char *obj = NULL;
+	bool dump = true;
 
-	obj_list = mnl_nft_obj_dump(ctx, table->handle.family,
-				    table->handle.table.name, NULL,
-				    0, true, false);
+	if (filter) {
+		family = filter->list.family;
+		if (filter->list.table)
+			table = filter->list.table;
+		if (filter->list.obj) {
+			obj = filter->list.obj;
+			dump = false;
+		}
+		if (filter->list.obj_type)
+			type = filter->list.obj_type;
+	}
+	obj_list = mnl_nft_obj_dump(ctx, family, table, obj, type, dump, false);
 	if (!obj_list) {
                 if (errno == EINTR)
 			return NULL;
@@ -1039,7 +1112,7 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 	struct nftnl_flowtable_list *ft_list = NULL;
 	struct nftnl_chain_list *chain_list = NULL;
 	struct nftnl_set_list *set_list = NULL;
-	struct nftnl_obj_list *obj_list;
+	struct nftnl_obj_list *obj_list = NULL;
 	struct table *table;
 	struct set *set;
 	int ret = 0;
@@ -1056,6 +1129,13 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 			goto cache_fails;
 		}
 	}
+	if (flags & NFT_CACHE_OBJECT_BIT) {
+		obj_list = obj_cache_dump(ctx, filter);
+		if (!obj_list) {
+			ret = -1;
+			goto cache_fails;
+		}
+	}
 	if (flags & NFT_CACHE_FLOWTABLE_BIT) {
 		ft_list = ft_cache_dump(ctx, filter);
 		if (!ft_list) {
@@ -1108,15 +1188,7 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 				goto cache_fails;
 		}
 		if (flags & NFT_CACHE_OBJECT_BIT) {
-			obj_list = obj_cache_dump(ctx, table);
-			if (!obj_list) {
-				ret = -1;
-				goto cache_fails;
-			}
 			ret = obj_cache_init(ctx, table, obj_list);
-
-			nftnl_obj_list_free(obj_list);
-
 			if (ret < 0)
 				goto cache_fails;
 		}
@@ -1137,6 +1209,8 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 cache_fails:
 	if (set_list)
 		nftnl_set_list_free(set_list);
+	if (obj_list)
+		nftnl_obj_list_free(obj_list);
 	if (ft_list)
 		nftnl_flowtable_list_free(ft_list);
 
-- 
2.30.2

