Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3A03C43217
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Dec 2021 13:12:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346737AbhLBNPl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 08:15:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232871AbhLBNPg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 08:15:36 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE877C06175A
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Dec 2021 05:12:13 -0800 (PST)
Received: from localhost ([::1]:37986 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mslsi-0001W1-6J; Thu, 02 Dec 2021 14:12:12 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 1/5] cache: Filter tables on kernel side
Date:   Thu,  2 Dec 2021 14:11:32 +0100
Message-Id: <20211202131136.29242-2-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211202131136.29242-1-phil@nwl.cc>
References: <20211202131136.29242-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead of requesting a dump of all tables and filtering the data in
user space, construct a non-dump request if filter contains a table so
kernel returns only that single table.

This should improve nft performance in rulesets with many tables
present.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Expect possible ENOENT reply from kernel, it is not an error in this
  context.
---
 include/mnl.h     |  2 +-
 include/netlink.h |  3 ++-
 src/cache.c       |  9 +--------
 src/mnl.c         | 22 +++++++++++++++++++---
 src/netlink.c     | 12 ++++++++++--
 5 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index 68ec80cd22821..344030f306940 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -50,7 +50,7 @@ int mnl_nft_table_add(struct netlink_ctx *ctx, struct cmd *cmd,
 int mnl_nft_table_del(struct netlink_ctx *ctx, struct cmd *cmd);
 
 struct nftnl_table_list *mnl_nft_table_dump(struct netlink_ctx *ctx,
-					    int family);
+					    int family, const char *table);
 
 int mnl_nft_set_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		    unsigned int flags);
diff --git a/include/netlink.h b/include/netlink.h
index a692edcdb5bf2..0e439061e3800 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -135,7 +135,8 @@ extern int netlink_list_chains(struct netlink_ctx *ctx, const struct handle *h);
 extern struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
 					       const struct nftnl_chain *nlc);
 
-extern int netlink_list_tables(struct netlink_ctx *ctx, const struct handle *h);
+extern int netlink_list_tables(struct netlink_ctx *ctx, const struct handle *h,
+			       const struct nft_cache_filter *filter);
 extern struct table *netlink_delinearize_table(struct netlink_ctx *ctx,
 					       const struct nftnl_table *nlt);
 
diff --git a/src/cache.c b/src/cache.c
index 6d20716d73110..66da2b3475732 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -772,19 +772,12 @@ static int cache_init_tables(struct netlink_ctx *ctx, struct handle *h,
 	struct table *table, *next;
 	int ret;
 
-	ret = netlink_list_tables(ctx, h);
+	ret = netlink_list_tables(ctx, h, filter);
 	if (ret < 0)
 		return -1;
 
 	list_for_each_entry_safe(table, next, &ctx->list, list) {
 		list_del(&table->list);
-
-		if (filter && filter->list.table &&
-		    (filter->list.family != table->handle.family ||
-		     strcmp(filter->list.table, table->handle.table.name))) {
-			table_free(table);
-			continue;
-		}
 		table_cache_add(table, cache);
 	}
 
diff --git a/src/mnl.c b/src/mnl.c
index 23348e1393bce..21b98e34ed176 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1016,10 +1016,12 @@ err_free:
 }
 
 struct nftnl_table_list *mnl_nft_table_dump(struct netlink_ctx *ctx,
-					    int family)
+					    int family, const char *table)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nftnl_table_list *nlt_list;
+	struct nftnl_table *nlt = NULL;
+	int flags = NLM_F_DUMP;
 	struct nlmsghdr *nlh;
 	int ret;
 
@@ -1027,11 +1029,25 @@ struct nftnl_table_list *mnl_nft_table_dump(struct netlink_ctx *ctx,
 	if (nlt_list == NULL)
 		return NULL;
 
+	if (table) {
+		nlt = nftnl_table_alloc();
+		if (!nlt)
+			memory_allocation_error();
+
+		nftnl_table_set_u32(nlt, NFTNL_TABLE_FAMILY, family);
+		nftnl_table_set_str(nlt, NFTNL_TABLE_NAME, table);
+		flags = NLM_F_ACK;
+	}
+
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, family,
-				    NLM_F_DUMP, ctx->seqnum);
+				    flags, ctx->seqnum);
+	if (nlt) {
+		nftnl_table_nlmsg_build_payload(nlh, nlt);
+		nftnl_table_free(nlt);
+	}
 
 	ret = nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, table_cb, nlt_list);
-	if (ret < 0)
+	if (ret < 0 && errno != ENOENT)
 		goto err;
 
 	return nlt_list;
diff --git a/src/netlink.c b/src/netlink.c
index ab90d0c05acaf..f74c0383a0db3 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -664,11 +664,19 @@ static int list_table_cb(struct nftnl_table *nlt, void *arg)
 	return 0;
 }
 
-int netlink_list_tables(struct netlink_ctx *ctx, const struct handle *h)
+int netlink_list_tables(struct netlink_ctx *ctx, const struct handle *h,
+			const struct nft_cache_filter *filter)
 {
 	struct nftnl_table_list *table_cache;
+	uint32_t family = h->family;
+	const char *table = NULL;
 
-	table_cache = mnl_nft_table_dump(ctx, h->family);
+	if (filter) {
+		family = filter->list.family;
+		table = filter->list.table;
+	}
+
+	table_cache = mnl_nft_table_dump(ctx, family, table);
 	if (table_cache == NULL) {
 		if (errno == EINTR)
 			return -1;
-- 
2.33.0

