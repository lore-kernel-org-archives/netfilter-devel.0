Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C69A3019D6;
	Sun, 18 Oct 2026 00:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792285021; cv=none; b=lOxYDytmigXHUObvodagA1s9LQJq2QPzmQQWt0aOY81M8Sw9WMxRdIfmwuZYxidCeTV9EuMXrmvbUEP52ETJz+826ihk/35O8kh5p9KV5bGgmbD8T5l1KrvLK0mXj9eRAVyCzrVQ/y+u/hf3VcaBdCv8B2q80pBxIin4D8TL49w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792285021; c=relaxed/simple;
	bh=3jqv3Rq7u4yrHk36M9K2O+8rR9uhXOuB0ufChCnj2n4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okDDKfDLqNLZr9+WuRB3BgGnm34sKc89BIM4jxUFKyISlk8GLjUk8dZzfRYLJqctTbQMZehz0U0UvP7EKtHaXbDSbXQjkn6x/rj14mdPcRrNdCHDx50uwgngrQTAPzKpBjWt9hgufadPSmP/OsGMyyRqKbtKOFDI5tRsb9jCn/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=n46ZnVgc; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="n46ZnVgc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792285017;
	bh=gKlSvCY7t9oDKjgOxia2J5hBJ71Dl1SGpIgZZ4aqLs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n46ZnVgcusN3FEzv/f2NA1fpoUe4qhi6E2sv2/thy7lCePXId8S2Ex4+UggRwQSxp
	 rX4mvk3J6K03sTYnVFLhFYdv5+/R0PRMY7aHrXlRWTWZZYxSE1KgxM8yENSPIAaCG6
	 mxptnVXx2MRZBkQ04rPjdI2TsLntdmJZeO7mfM2u+TTZz/VJxKtRlKWr37oXkoT25U
	 35PcTUxpgMaBEjuqLELks8937bdCLD+n4p/8b5s6mTGX5CVQZENgsfIzcEh9Lo6yok
	 UESV6yhx2r9WYedcx+wwZS0x2lg1IYHEEjARs/ApcqANU+bVtaFTgtkXzo9Sn3MUOS
	 IGjtzffnYdNqQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D5CFC60079;
	Sun, 18 Oct 2026 02:56:56 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 07/15] netfilter: nf_tables: switch chain_types array to rcu
Date: Sun, 18 Oct 2026 02:56:30 +0200
Message-ID: <20261018005638.1776148-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261018005638.1776148-1-pablo@netfilter.org>
References: <20261018005638.1776148-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

LLM quote:
 The global chain_type array is cleared under the nfnetlink subsystem
 mutex, but transaction processing reads it while holding only the pernet
 transaction mutex.
 nf_tables_chain_type_lookup() and nft_chain_parse_hook() dereference
 type->name/hook_mask before try_module_get(type->owner).

 Concurrent unloading of a separate provider such as nft_chain_nat can
 unregister and free its static nft_chain_type while a transaction is
 in the unprotected interval, causing a module-memory use-after-free.

LLM finding, not observed in practice.  Move this under RCU and grab the
module owner earlier.

Both nft_chain_route and nft_chain_filter are built into nf_tables.ko:
only nft_chain_nat needs an extra synchronize_rcu().

Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 94 ++++++++++++++++++++++++-----------
 net/netfilter/nft_chain_nat.c |  1 +
 2 files changed, 65 insertions(+), 30 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b59628e6240c..59ac623e6805 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1036,32 +1036,67 @@ static inline u64 nf_tables_alloc_handle(struct nft_table *table)
 	return ++table->hgenerator;
 }
 
-static const struct nft_chain_type *chain_type[NFPROTO_NUMPROTO][NFT_CHAIN_T_MAX];
+static const struct nft_chain_type __rcu *chain_type[NFPROTO_NUMPROTO][NFT_CHAIN_T_MAX];
 
 static const struct nft_chain_type *
-__nft_chain_type_get(u8 family, enum nft_chain_types type)
+__nft_chain_type_peek(u8 family, enum nft_chain_types type)
 {
 	if (family >= NFPROTO_NUMPROTO ||
 	    type >= NFT_CHAIN_T_MAX)
 		return NULL;
 
-	return chain_type[family][type];
+	return rcu_dereference_check(chain_type[family][type],
+				     lockdep_nfnl_is_held(NFNL_SUBSYS_NFTABLES));
 }
 
+/**
+ * nft_chain_type_get - look up a chain type by family and id
+ * @family: netlink family
+ * @type:   chain type (enum nft_chain_types)
+ *
+ * Return: chain type with a held module ref, or NULL.
+ */
+static const struct nft_chain_type *
+nft_chain_type_get(u8 family, enum nft_chain_types type)
+{
+	const struct nft_chain_type *t;
+
+	rcu_read_lock();
+	t = __nft_chain_type_peek(family, type);
+
+	if (t && !try_module_get(t->owner))
+		t = NULL;
+
+	rcu_read_unlock();
+	return t;
+}
+
+/**
+ * __nf_tables_chain_type_lookup - look up a chain type by name
+ * @nla:    nlattr containing the chain-type name
+ * @family: netlink family
+ *
+ * Return: matching chain type with a held module ref, or NULL.
+ */
 static const struct nft_chain_type *
 __nf_tables_chain_type_lookup(const struct nlattr *nla, u8 family)
 {
-	const struct nft_chain_type *type;
+	const struct nft_chain_type *type = NULL, *t;
 	int i;
 
+	rcu_read_lock();
 	for (i = 0; i < NFT_CHAIN_T_MAX; i++) {
-		type = __nft_chain_type_get(family, i);
-		if (!type)
+		t = __nft_chain_type_peek(family, i);
+		if (!t)
 			continue;
-		if (!nla_strcmp(nla, type->name))
-			return type;
+
+		if (!nla_strcmp(nla, t->name) && try_module_get(t->owner)) {
+			type = t;
+			break;
+		}
 	}
-	return NULL;
+	rcu_read_unlock();
+	return type;
 }
 
 struct nft_module_request {
@@ -1837,11 +1872,11 @@ static void nf_tables_table_destroy(struct nft_table *table)
 void nft_register_chain_type(const struct nft_chain_type *ctype)
 {
 	nfnl_lock(NFNL_SUBSYS_NFTABLES);
-	if (WARN_ON(__nft_chain_type_get(ctype->family, ctype->type))) {
+	if (WARN_ON(__nft_chain_type_peek(ctype->family, ctype->type))) {
 		nfnl_unlock(NFNL_SUBSYS_NFTABLES);
 		return;
 	}
-	chain_type[ctype->family][ctype->type] = ctype;
+	rcu_assign_pointer(chain_type[ctype->family][ctype->type], ctype);
 	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
 }
 EXPORT_SYMBOL_GPL(nft_register_chain_type);
@@ -1849,7 +1884,7 @@ EXPORT_SYMBOL_GPL(nft_register_chain_type);
 void nft_unregister_chain_type(const struct nft_chain_type *ctype)
 {
 	nfnl_lock(NFNL_SUBSYS_NFTABLES);
-	chain_type[ctype->family][ctype->type] = NULL;
+	RCU_INIT_POINTER(chain_type[ctype->family][ctype->type], NULL);
 	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
 }
 EXPORT_SYMBOL_GPL(nft_unregister_chain_type);
@@ -2581,10 +2616,6 @@ static int nft_chain_parse_hook(struct net *net,
 		hook->num = ntohl(nla_get_be32(ha[NFTA_HOOK_HOOKNUM]));
 		hook->priority = ntohl(nla_get_be32(ha[NFTA_HOOK_PRIORITY]));
 
-		type = __nft_chain_type_get(family, NFT_CHAIN_T_DEFAULT);
-		if (!type)
-			return -EOPNOTSUPP;
-
 		if (nla[NFTA_CHAIN_TYPE]) {
 			type = nf_tables_chain_type_lookup(net, nla[NFTA_CHAIN_TYPE],
 							   family, true);
@@ -2592,13 +2623,19 @@ static int nft_chain_parse_hook(struct net *net,
 				NL_SET_BAD_ATTR(extack, nla[NFTA_CHAIN_TYPE]);
 				return PTR_ERR(type);
 			}
+		} else {
+			type = nft_chain_type_get(family, NFT_CHAIN_T_DEFAULT);
+			if (!type)
+				return -EOPNOTSUPP;
 		}
+
+		err = -EOPNOTSUPP;
 		if (hook->num >= NFT_MAX_HOOKS || !(type->hook_mask & (1 << hook->num)))
-			return -EOPNOTSUPP;
+			goto out_put_type;
 
 		if (type->type == NFT_CHAIN_T_NAT &&
 		    hook->priority <= NF_IP_PRI_CONNTRACK)
-			return -EOPNOTSUPP;
+			goto out_put_type;
 	} else {
 		if (ha[NFTA_HOOK_HOOKNUM]) {
 			hook->num = ntohl(nla_get_be32(ha[NFTA_HOOK_HOOKNUM]));
@@ -2620,30 +2657,27 @@ static int nft_chain_parse_hook(struct net *net,
 			}
 		} else {
 			type = basechain->type;
+			__module_get(type->owner);
 		}
 	}
 
-	if (!try_module_get(type->owner)) {
-		if (nla[NFTA_CHAIN_TYPE])
-			NL_SET_BAD_ATTR(extack, nla[NFTA_CHAIN_TYPE]);
-		return -ENOENT;
-	}
-
 	hook->type = type;
 
 	INIT_LIST_HEAD(&hook->list);
 	if (nft_base_chain_netdev(family, hook->num)) {
 		err = nft_chain_parse_netdev(net, ha, &hook->list, extack, flags);
-		if (err < 0) {
-			module_put(type->owner);
-			return err;
-		}
+		if (err < 0)
+			goto out_put_type;
 	} else if (ha[NFTA_HOOK_DEV] || ha[NFTA_HOOK_DEVS]) {
-		module_put(type->owner);
-		return -EOPNOTSUPP;
+		err = -EOPNOTSUPP;
+		goto out_put_type;
 	}
 
 	return 0;
+
+out_put_type:
+	module_put(type->owner);
+	return err;
 }
 
 static void nft_chain_release_hook(struct nft_chain_hook *hook)
diff --git a/net/netfilter/nft_chain_nat.c b/net/netfilter/nft_chain_nat.c
index 40e230d8b712..1133f79d8d25 100644
--- a/net/netfilter/nft_chain_nat.c
+++ b/net/netfilter/nft_chain_nat.c
@@ -131,6 +131,7 @@ static void __exit nft_chain_nat_exit(void)
 #ifdef CONFIG_NF_TABLES_INET
 	nft_unregister_chain_type(&nft_chain_nat_inet);
 #endif
+	synchronize_rcu();
 }
 
 module_init(nft_chain_nat_init);
-- 
2.47.3

