Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67EA91482E9;
	Thu, 11 Apr 2024 11:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712834954; cv=none; b=WjNXa3EQgiMNgK+lvpnqXcqxkZVVbXiFTdYzwUIm31xzCjyL/gDGNqN0uyzwrFThq62OAue5BEP2oJDVvKCODkoiyrgpQmyt3xhMcl/K0fL/oClD29ReNFMoFy3DCGCGfK05sUoqWhO650StXQAVOFUMGjDVN2MjUiBzTi9H+NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712834954; c=relaxed/simple;
	bh=xcG/2d3bav50QLcgjKXe51OwpeOQQ1/DJlMRZJJXZfk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nd0RdcaPd6aZIyV0kD0NQ6cBjVRakfkkrZaGJ8QKUV3cgjC2OZIRo2VrrNOPP6Gq/FE4tOOXpcQo67H2ycV4bk/z1Xlzxmd3Ez14vt57DT9H+B8amV//Bp/LAhOxz8gaQp9i2QZwjpzZEhxaNeJM9nipJF8zWWsXVzDn7qTL0Uk=
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
Subject: [PATCH net 1/7] netfilter: nf_tables: Fix potential data-race in __nft_expr_type_get()
Date: Thu, 11 Apr 2024 13:28:54 +0200
Message-Id: <20240411112900.129414-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240411112900.129414-1-pablo@netfilter.org>
References: <20240411112900.129414-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ziyang Xuan <william.xuanziyang@huawei.com>

nft_unregister_expr() can concurrent with __nft_expr_type_get(),
and there is not any protection when iterate over nf_tables_expressions
list in __nft_expr_type_get(). Therefore, there is potential data-race
of nf_tables_expressions list entry.

Use list_for_each_entry_rcu() to iterate over nf_tables_expressions
list in __nft_expr_type_get(), and use rcu_read_lock() in the caller
nft_expr_type_get() to protect the entire type query process.

Fixes: ef1f7df9170d ("netfilter: nf_tables: expression ops overloading")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d89d77946719..53b8c00863ad 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3060,7 +3060,7 @@ static const struct nft_expr_type *__nft_expr_type_get(u8 family,
 {
 	const struct nft_expr_type *type, *candidate = NULL;
 
-	list_for_each_entry(type, &nf_tables_expressions, list) {
+	list_for_each_entry_rcu(type, &nf_tables_expressions, list) {
 		if (!nla_strcmp(nla, type->name)) {
 			if (!type->family && !candidate)
 				candidate = type;
@@ -3092,9 +3092,13 @@ static const struct nft_expr_type *nft_expr_type_get(struct net *net,
 	if (nla == NULL)
 		return ERR_PTR(-EINVAL);
 
+	rcu_read_lock();
 	type = __nft_expr_type_get(family, nla);
-	if (type != NULL && try_module_get(type->owner))
+	if (type != NULL && try_module_get(type->owner)) {
+		rcu_read_unlock();
 		return type;
+	}
+	rcu_read_unlock();
 
 	lockdep_nfnl_nft_mutex_not_held();
 #ifdef CONFIG_MODULES
-- 
2.30.2

