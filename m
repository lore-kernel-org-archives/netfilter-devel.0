Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14371C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Mar 2022 13:55:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbiCCN4R (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Mar 2022 08:56:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbiCCN4Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Mar 2022 08:56:16 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273E718BA45
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Mar 2022 05:55:31 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nPlvV-0001YY-MG; Thu, 03 Mar 2022 14:55:29 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [RFC v3 nf-next 15/15] netfilter: conntrack: remove unconfirmed list
Date:   Thu,  3 Mar 2022 14:54:19 +0100
Message-Id: <20220303135419.10837-16-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220303135419.10837-1-fw@strlen.de>
References: <20220303135419.10837-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It has no function anymore and can be removed.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack.h |  1 -
 include/net/netns/conntrack.h        |  6 ----
 net/netfilter/nf_conntrack_core.c    | 54 ++--------------------------
 net/netfilter/nf_conntrack_netlink.c | 44 +----------------------
 4 files changed, 3 insertions(+), 102 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index c823f0e33dcc..096b898860d6 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -101,7 +101,6 @@ struct nf_conn {
 	/* Have we seen traffic both ways yet? (bitset) */
 	unsigned long status;
 
-	u16		cpu;
 	u16		local_origin:1;
 	possible_net_t ct_net;
 
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index dd1d096b2ada..22d8d1909a3b 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -93,11 +93,6 @@ struct nf_ip_net {
 #endif
 };
 
-struct ct_pcpu {
-	spinlock_t		lock;
-	struct hlist_nulls_head unconfirmed;
-};
-
 struct netns_ct {
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	bool ecache_dwork_pending;
@@ -109,7 +104,6 @@ struct netns_ct {
 	u8			sysctl_tstamp;
 	u8			sysctl_checksum;
 
-	struct ct_pcpu __percpu *pcpu_lists;
 	struct ip_conntrack_stat __percpu *stat;
 	struct nf_ip_net	nf_ct_proto;
 #if defined(CONFIG_NF_CONNTRACK_LABELS)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 3c89f8fd2203..1a16acd47fe9 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -512,35 +512,6 @@ clean_from_lists(struct nf_conn *ct)
 	nf_ct_remove_expectations(ct);
 }
 
-/* must be called with local_bh_disable */
-static void nf_ct_add_to_unconfirmed_list(struct nf_conn *ct)
-{
-	struct ct_pcpu *pcpu;
-
-	/* add this conntrack to the (per cpu) unconfirmed list */
-	ct->cpu = smp_processor_id();
-	pcpu = per_cpu_ptr(nf_ct_net(ct)->ct.pcpu_lists, ct->cpu);
-
-	spin_lock(&pcpu->lock);
-	hlist_nulls_add_head(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode,
-			     &pcpu->unconfirmed);
-	spin_unlock(&pcpu->lock);
-}
-
-/* must be called with local_bh_disable */
-static void nf_ct_del_from_unconfirmed_list(struct nf_conn *ct)
-{
-	struct ct_pcpu *pcpu;
-
-	/* We overload first tuple to link into unconfirmed list.*/
-	pcpu = per_cpu_ptr(nf_ct_net(ct)->ct.pcpu_lists, ct->cpu);
-
-	spin_lock(&pcpu->lock);
-	BUG_ON(hlist_nulls_unhashed(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode));
-	hlist_nulls_del_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode);
-	spin_unlock(&pcpu->lock);
-}
-
 #define NFCT_ALIGN(len)	(((len) + NFCT_INFOMASK) & ~NFCT_INFOMASK)
 
 /* Released via nf_ct_destroy() */
@@ -620,9 +591,6 @@ void nf_ct_destroy(struct nf_conntrack *nfct)
 	 */
 	nf_ct_remove_expectations(ct);
 
-	if (unlikely(!nf_ct_is_confirmed(ct)))
-		nf_ct_del_from_unconfirmed_list(ct);
-
 	local_bh_enable();
 
 	if (ct->master)
@@ -1235,7 +1203,6 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	 * user context, else we insert an already 'dead' hash, blocking
 	 * further use of that particular connection -JM.
 	 */
-	nf_ct_del_from_unconfirmed_list(ct);
 	ct->status |= IPS_CONFIRMED;
 
 	if (unlikely(nf_ct_is_dying(ct))) {
@@ -1752,9 +1719,8 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 	if (!exp)
 		__nf_ct_try_assign_helper(ct, tmpl, GFP_ATOMIC);
 
-	/* Now it is inserted into the unconfirmed list, set refcount to 1. */
+	/* Now it is going to be associated with an sk_buff, set refcount to 1. */
 	refcount_set(&ct->ct_general.use, 1);
-	nf_ct_add_to_unconfirmed_list(ct);
 
 	local_bh_enable();
 
@@ -2546,7 +2512,6 @@ void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
 		nf_conntrack_ecache_pernet_fini(net);
 		nf_conntrack_expect_pernet_fini(net);
 		free_percpu(net->ct.stat);
-		free_percpu(net->ct.pcpu_lists);
 	}
 }
 
@@ -2757,26 +2722,14 @@ int nf_conntrack_init_net(struct net *net)
 {
 	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 	int ret = -ENOMEM;
-	int cpu;
 
 	BUILD_BUG_ON(IP_CT_UNTRACKED == IP_CT_NUMBER);
 	BUILD_BUG_ON_NOT_POWER_OF_2(CONNTRACK_LOCKS);
 	atomic_set(&cnet->count, 0);
 
-	net->ct.pcpu_lists = alloc_percpu(struct ct_pcpu);
-	if (!net->ct.pcpu_lists)
-		goto err_stat;
-
-	for_each_possible_cpu(cpu) {
-		struct ct_pcpu *pcpu = per_cpu_ptr(net->ct.pcpu_lists, cpu);
-
-		spin_lock_init(&pcpu->lock);
-		INIT_HLIST_NULLS_HEAD(&pcpu->unconfirmed, UNCONFIRMED_NULLS_VAL);
-	}
-
 	net->ct.stat = alloc_percpu(struct ip_conntrack_stat);
 	if (!net->ct.stat)
-		goto err_pcpu_lists;
+		return ret;
 
 	ret = nf_conntrack_expect_pernet_init(net);
 	if (ret < 0)
@@ -2792,8 +2745,5 @@ int nf_conntrack_init_net(struct net *net)
 
 err_expect:
 	free_percpu(net->ct.stat);
-err_pcpu_lists:
-	free_percpu(net->ct.pcpu_lists);
-err_stat:
 	return ret;
 }
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 51e387e8da85..fef48ee86d6d 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1752,49 +1752,7 @@ static int ctnetlink_dump_one_entry(struct sk_buff *skb,
 static int
 ctnetlink_dump_unconfirmed(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	struct ctnetlink_list_dump_ctx *ctx = (void *)cb->ctx;
-	struct nf_conn *ct, *last;
-	struct nf_conntrack_tuple_hash *h;
-	struct hlist_nulls_node *n;
-	struct net *net = sock_net(skb->sk);
-	int res, cpu;
-
-	if (ctx->done)
-		return 0;
-
-	last = ctx->last;
-
-	for (cpu = ctx->cpu; cpu < nr_cpu_ids; cpu++) {
-		struct ct_pcpu *pcpu;
-
-		if (!cpu_possible(cpu))
-			continue;
-
-		pcpu = per_cpu_ptr(net->ct.pcpu_lists, cpu);
-		spin_lock_bh(&pcpu->lock);
-restart:
-		hlist_nulls_for_each_entry(h, n, &pcpu->unconfirmed, hnnode) {
-			ct = nf_ct_tuplehash_to_ctrack(h);
-
-			res = ctnetlink_dump_one_entry(skb, cb, ct, false);
-			if (res < 0) {
-				ctx->cpu = cpu;
-				spin_unlock_bh(&pcpu->lock);
-				goto out;
-			}
-		}
-		if (ctx->last) {
-			ctx->last = NULL;
-			goto restart;
-		}
-		spin_unlock_bh(&pcpu->lock);
-	}
-	ctx->done = true;
-out:
-	if (last)
-		nf_ct_put(last);
-
-	return skb->len;
+	return 0;
 }
 
 static int
-- 
2.34.1

