Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF4C1E230B
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Oct 2024 09:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730281513; cv=none; b=F0qA9XuboqGH3mmjZeZFlbk+vK3B/kGRKOiLv0OyxjnEX3/j+bJB4gwyQYEjNttn3U7LodCz4PBtY7x9oJHNDeqwnWWlu+aof3ThVFb5A17ueMZxTDEdgI2lYbaD7vSOVWIHPzL1Xd5xn08lxrgQ292wz9AFRxEk581PJPu3m4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730281513; c=relaxed/simple;
	bh=pYyctc1xPQXOhaaLfzU/AKDry39/Djl3pF7x+sPndeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=puuGNk+REU2/iJQuV+jD1CaZgU+OaPBzRkGHcq9E5nF39Wo35hnnbGy7hYTrHOb8ZQNQw+oMrn/1hYqzIih++jvtYBOkxXGK4XcM8uTus0+aI8WmAeuDwsp9dUbmxV+uOH5KxAl5vp1uMdn5Ok2WhspLqz3tBLGeaPI4ypx+x0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1t65GH-0000le-7M; Wed, 30 Oct 2024 10:45:09 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf-next 2/7] netfilter: nf_tables: avoid false-positive lockdep splats with sets
Date: Wed, 30 Oct 2024 10:40:39 +0100
Message-ID: <20241030094053.13118-3-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241030094053.13118-1-fw@strlen.de>
References: <20241030094053.13118-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Same as previous patch.  All set handling functions here can be called
with transaction mutex held (but not the rcu read lock).

The transaction mutex prevents concurrent add/delete, so this is fine.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 80c285ac7e07..a51731d76401 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3986,7 +3986,8 @@ int nft_set_catchall_validate(const struct nft_ctx *ctx, struct nft_set *set)
 	struct nft_set_ext *ext;
 	int ret = 0;
 
-	list_for_each_entry_rcu(catchall, &set->catchall_list, list) {
+	list_for_each_entry_rcu(catchall, &set->catchall_list, list,
+				lockdep_commit_lock_is_held(ctx->net)) {
 		ext = nft_set_elem_ext(set, catchall->elem);
 		if (!nft_set_elem_active(ext, dummy_iter.genmask))
 			continue;
@@ -4459,7 +4460,8 @@ static const struct nla_policy nft_set_desc_policy[NFTA_SET_DESC_MAX + 1] = {
 	[NFTA_SET_DESC_CONCAT]		= NLA_POLICY_NESTED_ARRAY(nft_concat_policy),
 };
 
-static struct nft_set *nft_set_lookup(const struct nft_table *table,
+static struct nft_set *nft_set_lookup(const struct net *net,
+				      const struct nft_table *table,
 				      const struct nlattr *nla, u8 genmask)
 {
 	struct nft_set *set;
@@ -4467,7 +4469,8 @@ static struct nft_set *nft_set_lookup(const struct nft_table *table,
 	if (nla == NULL)
 		return ERR_PTR(-EINVAL);
 
-	list_for_each_entry_rcu(set, &table->sets, list) {
+	list_for_each_entry_rcu(set, &table->sets, list,
+				lockdep_commit_lock_is_held(net)) {
 		if (!nla_strcmp(nla, set->name) &&
 		    nft_active_genmask(set, genmask))
 			return set;
@@ -4517,7 +4520,7 @@ struct nft_set *nft_set_lookup_global(const struct net *net,
 {
 	struct nft_set *set;
 
-	set = nft_set_lookup(table, nla_set_name, genmask);
+	set = nft_set_lookup(net, table, nla_set_name, genmask);
 	if (IS_ERR(set)) {
 		if (!nla_set_id)
 			return set;
@@ -4893,7 +4896,7 @@ static int nf_tables_getset(struct sk_buff *skb, const struct nfnl_info *info,
 	if (!nla[NFTA_SET_TABLE])
 		return -EINVAL;
 
-	set = nft_set_lookup(table, nla[NFTA_SET_NAME], genmask);
+	set = nft_set_lookup(net, table, nla[NFTA_SET_NAME], genmask);
 	if (IS_ERR(set)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_SET_NAME]);
 		return PTR_ERR(set);
@@ -5229,7 +5232,7 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 
 	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
-	set = nft_set_lookup(table, nla[NFTA_SET_NAME], genmask);
+	set = nft_set_lookup(net, table, nla[NFTA_SET_NAME], genmask);
 	if (IS_ERR(set)) {
 		if (PTR_ERR(set) != -ENOENT) {
 			NL_SET_BAD_ATTR(extack, nla[NFTA_SET_NAME]);
@@ -5431,7 +5434,7 @@ static int nf_tables_delset(struct sk_buff *skb, const struct nfnl_info *info,
 		set = nft_set_lookup_byhandle(table, attr, genmask);
 	} else {
 		attr = nla[NFTA_SET_NAME];
-		set = nft_set_lookup(table, attr, genmask);
+		set = nft_set_lookup(net, table, attr, genmask);
 	}
 
 	if (IS_ERR(set)) {
@@ -5495,7 +5498,8 @@ static int nft_set_catchall_bind_check(const struct nft_ctx *ctx,
 	struct nft_set_ext *ext;
 	int ret = 0;
 
-	list_for_each_entry_rcu(catchall, &set->catchall_list, list) {
+	list_for_each_entry_rcu(catchall, &set->catchall_list, list,
+				lockdep_commit_lock_is_held(ctx->net)) {
 		ext = nft_set_elem_ext(set, catchall->elem);
 		if (!nft_set_elem_active(ext, genmask))
 			continue;
@@ -6261,7 +6265,7 @@ static int nft_set_dump_ctx_init(struct nft_set_dump_ctx *dump_ctx,
 		return PTR_ERR(table);
 	}
 
-	set = nft_set_lookup(table, nla[NFTA_SET_ELEM_LIST_SET], genmask);
+	set = nft_set_lookup(net, table, nla[NFTA_SET_ELEM_LIST_SET], genmask);
 	if (IS_ERR(set)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_SET_ELEM_LIST_SET]);
 		return PTR_ERR(set);
@@ -7493,7 +7497,8 @@ static int nft_set_catchall_flush(const struct nft_ctx *ctx,
 	struct nft_set_ext *ext;
 	int ret = 0;
 
-	list_for_each_entry_rcu(catchall, &set->catchall_list, list) {
+	list_for_each_entry_rcu(catchall, &set->catchall_list, list,
+				lockdep_commit_lock_is_held(ctx->net)) {
 		ext = nft_set_elem_ext(set, catchall->elem);
 		if (!nft_set_elem_active(ext, genmask))
 			continue;
@@ -7543,7 +7548,7 @@ static int nf_tables_delsetelem(struct sk_buff *skb,
 		return PTR_ERR(table);
 	}
 
-	set = nft_set_lookup(table, nla[NFTA_SET_ELEM_LIST_SET], genmask);
+	set = nft_set_lookup(net, table, nla[NFTA_SET_ELEM_LIST_SET], genmask);
 	if (IS_ERR(set)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_SET_ELEM_LIST_SET]);
 		return PTR_ERR(set);
-- 
2.45.2

