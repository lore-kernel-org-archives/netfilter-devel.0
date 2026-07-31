Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF62643C05F;
	Fri, 31 Jul 2026 15:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785511106; cv=none; b=s/eh2fl2hLb6lKw3bH543xnqVEO/1z/SscivTBbaL1iimaNIYaM3B4iKYeWRZ8Ofec4e6tA71fgan8aeN3q5i/91EbGXtFGWkb+S9GJPveEYmQevnoOtPdNM/gSPJ5BveLZEcDlOWOg5r752M1DSLXvUlPjBH5V0YqLQoT1JXJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785511106; c=relaxed/simple;
	bh=fspM7olk39h6rjC94C6P9Acjz9SOQf1RhMfrVaW83mA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=raMMs7EtpGPg0NpibwVrsCoXenUwtSyOE0A1J1hcjyPHDHnyiwe9Y/qs/ZF3pS25/gzK6Vu4atEy+OIxqTEhQFoQmcj9XwJ0kkx2XzvGfvOxH3n1gpc9ZDrDCEIxnsnZb0WqKxkA8F0vaGuj4Bw5lszS/zYI5NhOwVW71SpzGuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jV72W/7y; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jV72W/7y"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 082CC6028C;
	Fri, 31 Jul 2026 17:18:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785511101;
	bh=GIUGNryiT7wJW61mMk1PT86brx2My/4YkJrjt28Hp9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jV72W/7y2r9/SE1hVuHRx6HhGF55so8Sgm/eU0/9po2FYYYHpGf7ju2nTb9Mv9V6Z
	 xldDJEuk69dcknMQZZQguwcThp4CwG7clp87LKnfu9DgT9pxgqE53uIp1Xmek5nHc1
	 8dvJSeywZxIz0GaEj0zTi2YetYhDYBCzlgjlw2eAoDwfTnJ8cHnPZcY1gYiCszz3m1
	 1WwsS+XNMXB+sM8h1p8j1WzlnlLtho3NOQLR75eUjSKkaLKj0HT9byCiLKJRaExsIk
	 KOuONEaAHmk9IaOo4zuTXrQNQqc/QlodRNE9w8MqqeYMxHMbXrWzg59oO6hJb7+C3O
	 OntAtHKzr1R/Q==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 07/10] netfilter: ipset: switch to rcu work
Date: Fri, 31 Jul 2026 17:18:03 +0200
Message-ID: <20260731151806.849724-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260731151806.849724-1-pablo@netfilter.org>
References: <20260731151806.849724-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

In the initial ipset rhashtable conversion RFC series syzbot reported
following splat:

BUG: sleeping function [..] at kernel/irq_work.c:289
in_atomic(): 1, [..]
 irq_work_sync.. kernel/irq_work.c:289
 rhashtable_free_and_destroy.. lib/rhashtable.c:1295
 hash_netport4_destroy.. net/netfilter/ipset/ip_set_hash_gen.h:420
 ip_set_destroy_set_rcu.. net/netfilter/ipset/ip_set_core.c:1169
 rcu_core.. kernel/rcu/tree.c:2897

This is because post-rhashtable-conversion hash implementation needs
to schedule in the destroy callback.  At this time this isn't allowed.

Replace existing call_rcu() based destruction with rcu_work api.

Also allows to undo split of set destruction and gc work cancelling in
a future patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/ipset/ip_set.h |  4 +--
 net/netfilter/ipset/ip_set_core.c      | 46 ++++++++++++++++----------
 2 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index cadae9b2578f..c46864cc6623 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -244,8 +244,8 @@ extern void ip_set_type_unregister(struct ip_set_type *set_type);
 
 /* A generic IP set */
 struct ip_set {
-	/* For call_cru in destroy */
-	struct rcu_head rcu;
+	/* for set destruction */
+	struct rcu_work rwork;
 	/* The name of the set */
 	char name[IPSET_MAXNAMELEN];
 	/* Lock protecting the set data */
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 822a53a7f502..543851a923d0 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -25,6 +25,7 @@
 static LIST_HEAD(ip_set_type_list);		/* all registered set types */
 static DEFINE_MUTEX(ip_set_type_mutex);		/* protects ip_set_type_list */
 static DEFINE_RWLOCK(ip_set_ref_lock);		/* protects the set refs */
+static struct workqueue_struct *ipset_destroy_wq;
 
 struct ip_set_net {
 	struct ip_set * __rcu *ip_set_list;	/* all individual sets */
@@ -1178,22 +1179,26 @@ ip_set_setname_policy[IPSET_ATTR_CMD_MAX + 1] = {
 				    .len = IPSET_MAXNAMELEN - 1 },
 };
 
-/* In order to return quickly when destroying a single set, it is split
- * into two stages:
- * - Cancel garbage collector
- * - Destroy the set itself via call_rcu()
- */
-
 static void
-ip_set_destroy_set_rcu(struct rcu_head *head)
+destroy_and_free_set(struct ip_set *set)
 {
-	struct ip_set *set = container_of(head, struct ip_set, rcu);
-
 	set->variant->destroy(set);
 	module_put(set->type->me);
 	kfree(set);
 }
 
+/* In order to return quickly when destroying a single set,
+ * destruction is done asynchronously via work queues.
+ */
+static void
+ip_set_destroy_set_work(struct work_struct *work)
+{
+	struct ip_set *set = container_of(to_rcu_work(work),
+					  struct ip_set, rwork);
+
+	destroy_and_free_set(set);
+}
+
 static void
 _destroy_all_sets(struct ip_set_net *inst)
 {
@@ -1283,7 +1288,8 @@ static int ip_set_destroy(struct sk_buff *skb, const struct nfnl_info *info,
 			/* Must wait for flush to be really finished  */
 			rcu_barrier();
 		}
-		call_rcu(&s->rcu, ip_set_destroy_set_rcu);
+		INIT_RCU_WORK(&s->rwork, ip_set_destroy_set_work);
+		queue_rcu_work(ipset_destroy_wq, &s->rwork);
 	}
 	return 0;
 out:
@@ -2421,18 +2427,23 @@ static struct pernet_operations ip_set_net_ops = {
 static int __init
 ip_set_init(void)
 {
-	int ret = register_pernet_subsys(&ip_set_net_ops);
+	int ret;
+
+	ipset_destroy_wq = alloc_ordered_workqueue("ipset_destroy_wq", 0);
+	if (!ipset_destroy_wq)
+		return -ENOMEM;
 
+	ret = register_pernet_subsys(&ip_set_net_ops);
 	if (ret) {
 		pr_err("ip_set: cannot register pernet_subsys.\n");
-		return ret;
+		goto out_wq;
 	}
 
 	ret = nfnetlink_subsys_register(&ip_set_netlink_subsys);
 	if (ret != 0) {
 		pr_err("ip_set: cannot register with nfnetlink.\n");
 		unregister_pernet_subsys(&ip_set_net_ops);
-		return ret;
+		goto out_wq;
 	}
 
 	ret = nf_register_sockopt(&so_set);
@@ -2440,10 +2451,13 @@ ip_set_init(void)
 		pr_err("SO_SET registry failed: %d\n", ret);
 		nfnetlink_subsys_unregister(&ip_set_netlink_subsys);
 		unregister_pernet_subsys(&ip_set_net_ops);
-		return ret;
+		goto out_wq;
 	}
 
 	return 0;
+out_wq:
+	destroy_workqueue(ipset_destroy_wq);
+	return ret;
 }
 
 static void __exit
@@ -2453,9 +2467,7 @@ ip_set_fini(void)
 	nfnetlink_subsys_unregister(&ip_set_netlink_subsys);
 	unregister_pernet_subsys(&ip_set_net_ops);
 
-	/* Wait for call_rcu() in destroy */
-	rcu_barrier();
-
+	destroy_workqueue(ipset_destroy_wq);
 	pr_debug("these are the famous last words\n");
 }
 
-- 
2.47.3

