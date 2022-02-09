Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBD09C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Feb 2022 16:11:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236646AbiBIQLd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Feb 2022 11:11:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236647AbiBIQLd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Feb 2022 11:11:33 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99A3C05CB82
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Feb 2022 08:11:35 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nHpZ8-0004VL-9M; Wed, 09 Feb 2022 17:11:34 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 7/7] netfilter: conntrack: remove the percpu dying list
Date:   Wed,  9 Feb 2022 17:10:57 +0100
Message-Id: <20220209161057.30688-8-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209161057.30688-1-fw@strlen.de>
References: <20220209161057.30688-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Its no longer needed. Entries that need event redelivery are placed
on the new pernet dying list.

The advantage is that there is no need to take additional spinlock on
conntrack removal unless event redelivery failed or the conntrack entry
was never added to the table in the first place (confirmed bit not set).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netns/conntrack.h        |  1 -
 net/netfilter/nf_conntrack_core.c    | 35 ++++------------------------
 net/netfilter/nf_conntrack_ecache.c  |  1 -
 net/netfilter/nf_conntrack_netlink.c | 21 ++++-------------
 4 files changed, 9 insertions(+), 49 deletions(-)

diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index 3bb62e938fa9..dd1d096b2ada 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -96,7 +96,6 @@ struct nf_ip_net {
 struct ct_pcpu {
 	spinlock_t		lock;
 	struct hlist_nulls_head unconfirmed;
-	struct hlist_nulls_head dying;
 };
 
 struct netns_ct {
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 7eefcfa55fc2..9ca862bc5d7d 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -512,21 +512,6 @@ clean_from_lists(struct nf_conn *ct)
 	nf_ct_remove_expectations(ct);
 }
 
-/* must be called with local_bh_disable */
-static void nf_ct_add_to_dying_list(struct nf_conn *ct)
-{
-	struct ct_pcpu *pcpu;
-
-	/* add this conntrack to the (per cpu) dying list */
-	ct->cpu = smp_processor_id();
-	pcpu = per_cpu_ptr(nf_ct_net(ct)->ct.pcpu_lists, ct->cpu);
-
-	spin_lock(&pcpu->lock);
-	hlist_nulls_add_head(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode,
-			     &pcpu->dying);
-	spin_unlock(&pcpu->lock);
-}
-
 /* must be called with local_bh_disable */
 static void nf_ct_add_to_unconfirmed_list(struct nf_conn *ct)
 {
@@ -543,11 +528,11 @@ static void nf_ct_add_to_unconfirmed_list(struct nf_conn *ct)
 }
 
 /* must be called with local_bh_disable */
-static void nf_ct_del_from_dying_or_unconfirmed_list(struct nf_conn *ct)
+static void nf_ct_del_from_unconfirmed_list(struct nf_conn *ct)
 {
 	struct ct_pcpu *pcpu;
 
-	/* We overload first tuple to link into unconfirmed or dying list.*/
+	/* We overload first tuple to link into unconfirmed list.*/
 	pcpu = per_cpu_ptr(nf_ct_net(ct)->ct.pcpu_lists, ct->cpu);
 
 	spin_lock(&pcpu->lock);
@@ -635,7 +620,8 @@ void nf_ct_destroy(struct nf_conntrack *nfct)
 	 */
 	nf_ct_remove_expectations(ct);
 
-	nf_ct_del_from_dying_or_unconfirmed_list(ct);
+	if (unlikely(!nf_ct_is_confirmed(ct)))
+		nf_ct_del_from_unconfirmed_list(ct);
 
 	local_bh_enable();
 
@@ -673,23 +659,18 @@ static void nf_ct_delete_from_lists(struct nf_conn *ct)
 	local_bh_disable();
 
 	__nf_ct_delete_from_lists(ct);
-	nf_ct_add_to_dying_list(ct);
 
 	local_bh_enable();
 }
 
 static void nf_ct_add_to_ecache_list(struct nf_conn *ct)
 {
-#ifdef CONFIG_NF_CONNTRACK_EVENTS
 	struct nf_conntrack_net *cnet = nf_ct_pernet(nf_ct_net(ct));
 
 	spin_lock(&cnet->ecache.dying_lock);
 	hlist_nulls_add_head_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode,
 				 &cnet->ecache.dying_list);
 	spin_unlock(&cnet->ecache.dying_lock);
-#else
-	nf_ct_add_to_dying_list(ct);
-#endif
 }
 
 bool nf_ct_delete(struct nf_conn *ct, u32 portid, int report)
@@ -1011,7 +992,6 @@ static int __nf_ct_resolve_clash(struct sk_buff *skb,
 		nf_conntrack_get(&ct->ct_general);
 
 		nf_ct_acct_merge(ct, ctinfo, loser_ct);
-		nf_ct_add_to_dying_list(loser_ct);
 		nf_ct_put(loser_ct);
 		nf_ct_set(skb, ct, ctinfo);
 
@@ -1144,7 +1124,6 @@ nf_ct_resolve_clash(struct sk_buff *skb, struct nf_conntrack_tuple_hash *h,
 		return ret;
 
 drop:
-	nf_ct_add_to_dying_list(loser_ct);
 	NF_CT_STAT_INC(net, drop);
 	NF_CT_STAT_INC(net, insert_failed);
 	return NF_DROP;
@@ -1211,10 +1190,9 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	 * user context, else we insert an already 'dead' hash, blocking
 	 * further use of that particular connection -JM.
 	 */
-	nf_ct_del_from_dying_or_unconfirmed_list(ct);
+	nf_ct_del_from_unconfirmed_list(ct);
 
 	if (unlikely(nf_ct_is_dying(ct))) {
-		nf_ct_add_to_dying_list(ct);
 		NF_CT_STAT_INC(net, insert_failed);
 		goto dying;
 	}
@@ -1238,7 +1216,6 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 			goto out;
 		if (chainlen++ > max_chainlen) {
 chaintoolong:
-			nf_ct_add_to_dying_list(ct);
 			NF_CT_STAT_INC(net, chaintoolong);
 			NF_CT_STAT_INC(net, insert_failed);
 			ret = NF_DROP;
@@ -2752,7 +2729,6 @@ void nf_conntrack_init_end(void)
  * We need to use special "null" values, not used in hash table
  */
 #define UNCONFIRMED_NULLS_VAL	((1<<30)+0)
-#define DYING_NULLS_VAL		((1<<30)+1)
 
 int nf_conntrack_init_net(struct net *net)
 {
@@ -2773,7 +2749,6 @@ int nf_conntrack_init_net(struct net *net)
 
 		spin_lock_init(&pcpu->lock);
 		INIT_HLIST_NULLS_HEAD(&pcpu->unconfirmed, UNCONFIRMED_NULLS_VAL);
-		INIT_HLIST_NULLS_HEAD(&pcpu->dying, DYING_NULLS_VAL);
 	}
 
 	net->ct.stat = alloc_percpu(struct ip_conntrack_stat);
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 5c8918857dfc..7a948d23c44f 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -95,7 +95,6 @@ static enum retry_state ecache_work_evict_list(struct nf_conntrack_net *cnet)
 	hlist_nulls_for_each_entry_safe(h, n, &evicted_list, hnnode) {
 		struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
 
-		hlist_nulls_add_fake(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode);
 		hlist_nulls_del_rcu(&ct->tuplehash[IP_CT_DIR_REPLY].hnnode);
 		nf_ct_put(ct);
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 831e717c5847..1ff37e8f7838 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -62,7 +62,6 @@ struct ctnetlink_list_dump_ctx {
 	struct nf_conn *last;
 	unsigned int cpu;
 	bool done;
-	bool retrans_done;
 };
 
 static int ctnetlink_dump_tuples_proto(struct sk_buff *skb,
@@ -1751,13 +1750,12 @@ static int ctnetlink_dump_one_entry(struct sk_buff *skb,
 }
 
 static int
-ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying)
+ctnetlink_dump_unconfirmed(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct ctnetlink_list_dump_ctx *ctx = (void *)cb->ctx;
 	struct nf_conn *ct, *last;
 	struct nf_conntrack_tuple_hash *h;
 	struct hlist_nulls_node *n;
-	struct hlist_nulls_head *list;
 	struct net *net = sock_net(skb->sk);
 	int res, cpu;
 
@@ -1774,12 +1772,11 @@ ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying
 
 		pcpu = per_cpu_ptr(net->ct.pcpu_lists, cpu);
 		spin_lock_bh(&pcpu->lock);
-		list = dying ? &pcpu->dying : &pcpu->unconfirmed;
 restart:
-		hlist_nulls_for_each_entry(h, n, list, hnnode) {
+		hlist_nulls_for_each_entry(h, n, &pcpu->unconfirmed, hnnode) {
 			ct = nf_ct_tuplehash_to_ctrack(h);
 
-			res = ctnetlink_dump_one_entry(skb, cb, ct, dying);
+			res = ctnetlink_dump_one_entry(skb, cb, ct, false);
 			if (res < 0) {
 				ctx->cpu = cpu;
 				spin_unlock_bh(&pcpu->lock);
@@ -1810,9 +1807,6 @@ ctnetlink_dump_dying(struct sk_buff *skb, struct netlink_callback *cb)
 	struct nf_conntrack_tuple_hash *h;
 	struct hlist_nulls_node *n;
 
-	if (ctx->retrans_done)
-		return ctnetlink_dump_list(skb, cb, true);
-
 	ctx->last = NULL;
 	ecache_net = nf_conn_pernet_ecache(net);
 	spin_lock_bh(&ecache_net->dying_lock);
@@ -1836,11 +1830,10 @@ ctnetlink_dump_dying(struct sk_buff *skb, struct netlink_callback *cb)
 		last = NULL;
 	}
 
-	ctx->retrans_done = true;
 	spin_unlock_bh(&ecache_net->dying_lock);
 	nf_ct_put(last);
 
-	return ctnetlink_dump_list(skb, cb, true);
+	return skb->len;
 }
 
 static int ctnetlink_get_ct_dying(struct sk_buff *skb,
@@ -1858,12 +1851,6 @@ static int ctnetlink_get_ct_dying(struct sk_buff *skb,
 	return -EOPNOTSUPP;
 }
 
-static int
-ctnetlink_dump_unconfirmed(struct sk_buff *skb, struct netlink_callback *cb)
-{
-	return ctnetlink_dump_list(skb, cb, false);
-}
-
 static int ctnetlink_get_ct_unconfirmed(struct sk_buff *skb,
 					const struct nfnl_info *info,
 					const struct nlattr * const cda[])
-- 
2.34.1

