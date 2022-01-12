Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 101ACC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jan 2022 00:34:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347260AbiALAeO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Jan 2022 19:34:14 -0500
Received: from mail.netfilter.org ([217.70.188.207]:47918 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236299AbiALAeO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Jan 2022 19:34:14 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 626C86468E
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jan 2022 01:31:21 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/4] src: do not use the nft_cache_filter object from mnl.c
Date:   Wed, 12 Jan 2022 01:33:58 +0100
Message-Id: <20220112003401.332999-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220112003401.332999-1-pablo@netfilter.org>
References: <20220112003401.332999-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pass the table and chain strings to mnl_nft_rule_dump() instead.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/mnl.h |  2 +-
 src/cache.c   |  9 ++++++++-
 src/mnl.c     | 12 +++++-------
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index b006192cf7b2..a4abe1ae3242 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -34,7 +34,7 @@ int mnl_nft_rule_del(struct netlink_ctx *ctx, struct cmd *cmd);
 int mnl_nft_rule_replace(struct netlink_ctx *ctx, struct cmd *cmd);
 
 struct nftnl_rule_list *mnl_nft_rule_dump(struct netlink_ctx *ctx, int family,
-					  const struct nft_cache_filter *filter);
+					  const char *table, const char *chain);
 
 int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		      unsigned int flags);
diff --git a/src/cache.c b/src/cache.c
index 6494e4743f8d..6ca6bbc6645b 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -478,8 +478,15 @@ static int rule_cache_init(struct netlink_ctx *ctx, const struct handle *h,
 			   const struct nft_cache_filter *filter)
 {
 	struct nftnl_rule_list *rule_cache;
+	const char *table;
+	const char *chain;
 
-	rule_cache = mnl_nft_rule_dump(ctx, h->family, filter);
+	if (filter) {
+		table = filter->list.table;
+		chain = filter->list.chain;
+	}
+
+	rule_cache = mnl_nft_rule_dump(ctx, h->family, table, chain);
 	if (rule_cache == NULL) {
 		if (errno == EINTR)
 			return -1;
diff --git a/src/mnl.c b/src/mnl.c
index 5413f8658f9b..6be991a4827c 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -654,7 +654,7 @@ err_free:
 }
 
 struct nftnl_rule_list *mnl_nft_rule_dump(struct netlink_ctx *ctx, int family,
-					  const struct nft_cache_filter *filter)
+					  const char *table, const char *chain)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nftnl_rule_list *nlr_list;
@@ -662,16 +662,14 @@ struct nftnl_rule_list *mnl_nft_rule_dump(struct netlink_ctx *ctx, int family,
 	struct nlmsghdr *nlh;
 	int ret;
 
-	if (filter && filter->list.table) {
+	if (table) {
 		nlr = nftnl_rule_alloc();
 		if (!nlr)
 			memory_allocation_error();
 
-		nftnl_rule_set_str(nlr, NFTNL_RULE_TABLE,
-				   filter->list.table);
-		if (filter->list.chain)
-			nftnl_rule_set_str(nlr, NFTNL_RULE_CHAIN,
-					   filter->list.chain);
+		nftnl_rule_set_str(nlr, NFTNL_RULE_TABLE, table);
+		if (chain)
+			nftnl_rule_set_str(nlr, NFTNL_RULE_CHAIN, chain);
 	}
 
 	nlr_list = nftnl_rule_list_alloc();
-- 
2.30.2

