Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58AF220E30A;
	Wed,  6 Nov 2024 23:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730936806; cv=none; b=clU/t3F0JGwkE7dS6UECFnBK2UOV9tXHvmXeNb0hjegmQTaNVIduR8LeG4rqs1uyc0bHh7go1Dm3iYXTczxnfdC5IJ9reIphTxMEjD2OGUxiTEiFhDlLqOw64IkFHvBnV/X82pt3g0D6hzmnd3oty5VSXMH+VIJkgvYExMA3Xvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730936806; c=relaxed/simple;
	bh=tG/UEHqDnU7D7MBpfiHNvAQu+F7UHCvZXQYbSfrk7H8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NZVFnwp8uTm9DrfXbM0NiJnuEZQ7S2sn7MKWfGO6cW09/4SqzIbJhXccbRwqvKVWOAaJ6jZKHvnaeLJOc74r6uU1jo7Pnm8kf1W95jnG8UdGY/EG6x27quc29Bcv+0GdRrOSCM4fH2BWSAHxGMBah2Hao2ZF4Eh+e7MNcFwndUA=
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
Subject: [PATCH net-next 07/11] netfilter: nf_tables: avoid false-positive lockdep splats with flowtables
Date: Thu,  7 Nov 2024 00:46:21 +0100
Message-Id: <20241106234625.168468-8-pablo@netfilter.org>
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

The transaction mutex prevents concurrent add/delete, its ok to iterate
those lists outside of rcu read side critical sections.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  3 ++-
 net/netfilter/nf_tables_api.c     | 15 +++++++++------
 net/netfilter/nft_flow_offload.c  |  4 ++--
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 91ae20cb7648..c1513bd14568 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1463,7 +1463,8 @@ struct nft_flowtable {
 	struct nf_flowtable		data;
 };
 
-struct nft_flowtable *nft_flowtable_lookup(const struct nft_table *table,
+struct nft_flowtable *nft_flowtable_lookup(const struct net *net,
+					   const struct nft_table *table,
 					   const struct nlattr *nla,
 					   u8 genmask);
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a51731d76401..9e367e134691 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8378,12 +8378,14 @@ static const struct nla_policy nft_flowtable_policy[NFTA_FLOWTABLE_MAX + 1] = {
 	[NFTA_FLOWTABLE_FLAGS]		= { .type = NLA_U32 },
 };
 
-struct nft_flowtable *nft_flowtable_lookup(const struct nft_table *table,
+struct nft_flowtable *nft_flowtable_lookup(const struct net *net,
+					   const struct nft_table *table,
 					   const struct nlattr *nla, u8 genmask)
 {
 	struct nft_flowtable *flowtable;
 
-	list_for_each_entry_rcu(flowtable, &table->flowtables, list) {
+	list_for_each_entry_rcu(flowtable, &table->flowtables, list,
+				lockdep_commit_lock_is_held(net)) {
 		if (!nla_strcmp(nla, flowtable->name) &&
 		    nft_active_genmask(flowtable, genmask))
 			return flowtable;
@@ -8739,7 +8741,7 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
 		return PTR_ERR(table);
 	}
 
-	flowtable = nft_flowtable_lookup(table, nla[NFTA_FLOWTABLE_NAME],
+	flowtable = nft_flowtable_lookup(net, table, nla[NFTA_FLOWTABLE_NAME],
 					 genmask);
 	if (IS_ERR(flowtable)) {
 		err = PTR_ERR(flowtable);
@@ -8933,7 +8935,7 @@ static int nf_tables_delflowtable(struct sk_buff *skb,
 		flowtable = nft_flowtable_lookup_byhandle(table, attr, genmask);
 	} else {
 		attr = nla[NFTA_FLOWTABLE_NAME];
-		flowtable = nft_flowtable_lookup(table, attr, genmask);
+		flowtable = nft_flowtable_lookup(net, table, attr, genmask);
 	}
 
 	if (IS_ERR(flowtable)) {
@@ -9003,7 +9005,8 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 	if (!hook_list)
 		hook_list = &flowtable->hook_list;
 
-	list_for_each_entry_rcu(hook, hook_list, list) {
+	list_for_each_entry_rcu(hook, hook_list, list,
+				lockdep_commit_lock_is_held(net)) {
 		if (nla_put_string(skb, NFTA_DEVICE_NAME, hook->ops.dev->name))
 			goto nla_put_failure;
 	}
@@ -9145,7 +9148,7 @@ static int nf_tables_getflowtable(struct sk_buff *skb,
 		return PTR_ERR(table);
 	}
 
-	flowtable = nft_flowtable_lookup(table, nla[NFTA_FLOWTABLE_NAME],
+	flowtable = nft_flowtable_lookup(net, table, nla[NFTA_FLOWTABLE_NAME],
 					 genmask);
 	if (IS_ERR(flowtable)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_FLOWTABLE_NAME]);
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 2f732fae5a83..65199c23c75c 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -409,8 +409,8 @@ static int nft_flow_offload_init(const struct nft_ctx *ctx,
 	if (!tb[NFTA_FLOW_TABLE_NAME])
 		return -EINVAL;
 
-	flowtable = nft_flowtable_lookup(ctx->table, tb[NFTA_FLOW_TABLE_NAME],
-					 genmask);
+	flowtable = nft_flowtable_lookup(ctx->net, ctx->table,
+					 tb[NFTA_FLOW_TABLE_NAME], genmask);
 	if (IS_ERR(flowtable))
 		return PTR_ERR(flowtable);
 
-- 
2.30.2

