Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A94320E305;
	Wed,  6 Nov 2024 23:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730936806; cv=none; b=bgJG5vnqnQCknpE038T79fVzfKmL7DHvIchlbBhNuWOifn3B6F36mVomBIoRYMrkYufCmomunsiT1wDMywMJsyF9igInTPMmL7lpIwe+bLFMbZNBE0ctWeW5ztgQuq60GO7FtseiG5xCR96nlPutEdS6sLWMYlQdf9xsw7D4Ueg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730936806; c=relaxed/simple;
	bh=s2uMFqYfZw4cZRLKB4QAB/WB93KA64y+fuCGv46XHVU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eGBMt9G+iVSPuHssfkIQEZpl38MHCmMkeUguhIHbVG58llwPkx5CeuKt73LpZGNzfqBKH2eJzFlulkfZuGy90LrwG4fIDOFEWl7slaQp7MpAfhhbwxZcOya3JHquNklBxo/CTdU9UpW9xQ6gacq+S9u/MDCgX90ICRpPHfR2oPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 06/11] netfilter: nf_tables: avoid false-positive lockdep splats with sets
Date: Thu,  7 Nov 2024 00:46:20 +0100
Message-Id: <20241106234625.168468-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241106234625.168468-1-pablo@netfilter.org>
References: <20241106234625.168468-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Same as previous patch.  All set handling functions here can be called
with transaction mutex held (but not the rcu read lock).

The transaction mutex prevents concurrent add/delete, so this is fine.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.30.2

