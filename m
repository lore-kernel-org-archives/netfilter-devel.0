Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A68049659
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Apr 2025 15:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744731898; cv=none; b=Q8YIGlEhKIAadDLHR9XejXAS4ncmj1P3vIeScSG8BTufxpAU7s9ME68vRruffcAO1ZMomCFjfQoS7Yq1yKXJ20LoFwqVaBrAyaR0etqzUfNR4S7Ld18rZ7ZAkCExuwZWP/uycw5uFFKBiZmjNExsXAbYhyfiMJCdMRWL3MagXRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744731898; c=relaxed/simple;
	bh=xKzcVHA8GxdlzKHU9SvK3i2n5KTYVF8ZRwtTGAbSalI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=URMUAHRmDWw1SYQGCWfaKm3pG8ChsPqUZ/oxEZpBF/78azQ9hrCvObPHkc247B3Wysy1RpRSZl3RzuZ1Htqo3E4ZB93Kowu23WXIXb5HL3YF19OqKub6EuT2AY5GBV7dH9OYPqGNezZk4snezv2QzffdzV1u/x8f8IwDNXQtKsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=IIdGdjMJ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="IIdGdjMJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hoKUJGiXzGRxLaCuRa2sjR6c7e9DzwzUBZXq0gm4pBU=; b=IIdGdjMJSr7iZcH+43xvHWeBWg
	70TaasMVto7eY+FW+bMGZWvatk6k2oAJq6MTreSiWLkgz/Y3wP3GRGhjzvbCFs0TwDIg3RmTM3E2B
	UMB6zeKUnTJ/ZUaNGp/YZ/lAEEuMTeTk5hoifP/5rzBuLAdtqEgQf4DHGmkehJWlZLBGx7no0KYIL
	hlcy2g7uecG8Smt+NcOF/7DDW/He1xcTX6Ag3sSfFj6kmUC1hqWb692A/cVruzGfrN8Q/UvpCu6+P
	Bcb8LbyuHxMyKEfnBVEl/M+JQdJxr7fbFDqfVH4OiWvab04i3ETQgKeFt/6BogYBnCWVwJZ6R0+LU
	m72rcrrA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1u4iSt-000000004xe-0ccp;
	Tue, 15 Apr 2025 17:44:47 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v6 01/12] netfilter: nf_tables: Introduce functions freeing nft_hook objects
Date: Tue, 15 Apr 2025 17:44:29 +0200
Message-ID: <20250415154440.22371-2-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250415154440.22371-1-phil@nwl.cc>
References: <20250415154440.22371-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pointless wrappers around kfree() for now, prep work for an embedded
list of nf_hook_ops.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v3:
- Move function declarations up and use the wrapper in
  nft_netdev_unregister_hooks(), too.
---
 net/netfilter/nf_tables_api.c | 38 ++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a133e1c175ce..0e7cfbd3cf60 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -323,6 +323,16 @@ static int nft_netdev_register_hooks(struct net *net,
 	return err;
 }
 
+static void nft_netdev_hook_free(struct nft_hook *hook)
+{
+	kfree(hook);
+}
+
+static void nft_netdev_hook_free_rcu(struct nft_hook *hook)
+{
+	kfree_rcu(hook, rcu);
+}
+
 static void nft_netdev_unregister_hooks(struct net *net,
 					struct list_head *hook_list,
 					bool release_netdev)
@@ -333,7 +343,7 @@ static void nft_netdev_unregister_hooks(struct net *net,
 		nf_unregister_net_hook(net, &hook->ops);
 		if (release_netdev) {
 			list_del(&hook->list);
-			kfree_rcu(hook, rcu);
+			nft_netdev_hook_free_rcu(hook);
 		}
 	}
 }
@@ -2253,7 +2263,7 @@ void nf_tables_chain_destroy(struct nft_chain *chain)
 			list_for_each_entry_safe(hook, next,
 						 &basechain->hook_list, list) {
 				list_del_rcu(&hook->list);
-				kfree_rcu(hook, rcu);
+				nft_netdev_hook_free_rcu(hook);
 			}
 		}
 		module_put(basechain->type->owner);
@@ -2345,7 +2355,7 @@ static int nf_tables_parse_netdev_hooks(struct net *net,
 		}
 		if (nft_hook_list_find(hook_list, hook)) {
 			NL_SET_BAD_ATTR(extack, tmp);
-			kfree(hook);
+			nft_netdev_hook_free(hook);
 			err = -EEXIST;
 			goto err_hook;
 		}
@@ -2363,7 +2373,7 @@ static int nf_tables_parse_netdev_hooks(struct net *net,
 err_hook:
 	list_for_each_entry_safe(hook, next, hook_list, list) {
 		list_del(&hook->list);
-		kfree(hook);
+		nft_netdev_hook_free(hook);
 	}
 	return err;
 }
@@ -2506,7 +2516,7 @@ static void nft_chain_release_hook(struct nft_chain_hook *hook)
 
 	list_for_each_entry_safe(h, next, &hook->list, list) {
 		list_del(&h->list);
-		kfree(h);
+		nft_netdev_hook_free(h);
 	}
 	module_put(hook->type->owner);
 }
@@ -2795,7 +2805,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 
 				if (nft_hook_list_find(&basechain->hook_list, h)) {
 					list_del(&h->list);
-					kfree(h);
+					nft_netdev_hook_free(h);
 				}
 			}
 		} else {
@@ -2916,7 +2926,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 			if (unregister)
 				nf_unregister_net_hook(ctx->net, &h->ops);
 			list_del(&h->list);
-			kfree_rcu(h, rcu);
+			nft_netdev_hook_free_rcu(h);
 		}
 		module_put(hook.type->owner);
 	}
@@ -8881,7 +8891,7 @@ static void __nft_unregister_flowtable_net_hooks(struct net *net,
 					    FLOW_BLOCK_UNBIND);
 		if (release_netdev) {
 			list_del(&hook->list);
-			kfree_rcu(hook, rcu);
+			nft_netdev_hook_free_rcu(hook);
 		}
 	}
 }
@@ -8939,7 +8949,7 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 
 		nft_unregister_flowtable_hook(net, flowtable, hook);
 		list_del_rcu(&hook->list);
-		kfree_rcu(hook, rcu);
+		nft_netdev_hook_free_rcu(hook);
 	}
 
 	return err;
@@ -8951,7 +8961,7 @@ static void nft_hooks_destroy(struct list_head *hook_list)
 
 	list_for_each_entry_safe(hook, next, hook_list, list) {
 		list_del_rcu(&hook->list);
-		kfree_rcu(hook, rcu);
+		nft_netdev_hook_free_rcu(hook);
 	}
 }
 
@@ -8975,7 +8985,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 	list_for_each_entry_safe(hook, next, &flowtable_hook.list, list) {
 		if (nft_hook_list_find(&flowtable->hook_list, hook)) {
 			list_del(&hook->list);
-			kfree(hook);
+			nft_netdev_hook_free(hook);
 		}
 	}
 
@@ -9022,7 +9032,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 		if (unregister)
 			nft_unregister_flowtable_hook(ctx->net, flowtable, hook);
 		list_del_rcu(&hook->list);
-		kfree_rcu(hook, rcu);
+		nft_netdev_hook_free_rcu(hook);
 	}
 
 	return err;
@@ -9168,7 +9178,7 @@ static void nft_flowtable_hook_release(struct nft_flowtable_hook *flowtable_hook
 
 	list_for_each_entry_safe(this, next, &flowtable_hook->list, list) {
 		list_del(&this->list);
-		kfree(this);
+		nft_netdev_hook_free(this);
 	}
 }
 
@@ -9531,7 +9541,7 @@ static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
 	flowtable->data.type->free(&flowtable->data);
 	list_for_each_entry_safe(hook, next, &flowtable->hook_list, list) {
 		list_del_rcu(&hook->list);
-		kfree_rcu(hook, rcu);
+		nft_netdev_hook_free_rcu(hook);
 	}
 	kfree(flowtable->name);
 	module_put(flowtable->data.type->owner);
-- 
2.49.0

