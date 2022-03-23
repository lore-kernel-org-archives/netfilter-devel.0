Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5AF4C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Mar 2022 13:23:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242342AbiCWNYk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Mar 2022 09:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244277AbiCWNYk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Mar 2022 09:24:40 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51351EECA
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Mar 2022 06:23:06 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nX0x7-00016z-A9; Wed, 23 Mar 2022 14:23:05 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v3 14/16] netfilter: conntrack: remove __nf_ct_unconfirmed_destroy
Date:   Wed, 23 Mar 2022 14:22:12 +0100
Message-Id: <20220323132214.6700-15-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220323132214.6700-1-fw@strlen.de>
References: <20220323132214.6700-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Its not needed anymore:

A. If entry is totally new, then the rcu-protected resource
must already have been removed from global visibility before call
to nf_ct_iterate_destroy.

B. If entry was allocated before, but is not yet in the hash table
   (uncofirmed case), genid gets incremented and synchronize_rcu() call
   makes sure access has completed.

C. Next attempt to peek at extension area will fail for unconfirmed
  conntracks, because ext->genid != genid.

D. Conntracks in the hash are iterated as before.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c   | 46 ++++++++---------------------
 net/netfilter/nf_conntrack_helper.c |  5 ----
 net/netfilter/nfnetlink_cttimeout.c |  1 -
 3 files changed, 13 insertions(+), 39 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 76310940cbd7..7b4b3f5db959 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2457,34 +2457,6 @@ static int iter_net_only(struct nf_conn *i, void *data)
 	return d->iter(i, d->data);
 }
 
-static void
-__nf_ct_unconfirmed_destroy(struct net *net)
-{
-	int cpu;
-
-	for_each_possible_cpu(cpu) {
-		struct nf_conntrack_tuple_hash *h;
-		struct hlist_nulls_node *n;
-		struct ct_pcpu *pcpu;
-
-		pcpu = per_cpu_ptr(net->ct.pcpu_lists, cpu);
-
-		spin_lock_bh(&pcpu->lock);
-		hlist_nulls_for_each_entry(h, n, &pcpu->unconfirmed, hnnode) {
-			struct nf_conn *ct;
-
-			ct = nf_ct_tuplehash_to_ctrack(h);
-
-			/* we cannot call iter() on unconfirmed list, the
-			 * owning cpu can reallocate ct->ext at any time.
-			 */
-			set_bit(IPS_DYING_BIT, &ct->status);
-		}
-		spin_unlock_bh(&pcpu->lock);
-		cond_resched();
-	}
-}
-
 void nf_ct_iterate_cleanup_net(struct net *net,
 			       int (*iter)(struct nf_conn *i, void *data),
 			       void *data, u32 portid, int report)
@@ -2527,26 +2499,34 @@ nf_ct_iterate_destroy(int (*iter)(struct nf_conn *i, void *data), void *data)
 
 		if (atomic_read(&cnet->count) == 0)
 			continue;
-		__nf_ct_unconfirmed_destroy(net);
 		nf_queue_nf_hook_drop(net);
 	}
 	up_read(&net_rwsem);
 
 	/* Need to wait for netns cleanup worker to finish, if its
 	 * running -- it might have deleted a net namespace from
-	 * the global list, so our __nf_ct_unconfirmed_destroy() might
-	 * not have affected all namespaces.
+	 * the global list, so hook drop above might not have
+	 * affected all namespaces.
 	 */
 	net_ns_barrier();
 
-	/* a conntrack could have been unlinked from unconfirmed list
-	 * before we grabbed pcpu lock in __nf_ct_unconfirmed_destroy().
+	/* a skb w. unconfirmed conntrack could have been reinjected just
+	 * before we called nf_queue_nf_hook_drop().
+	 *
 	 * This makes sure its inserted into conntrack table.
 	 */
 	synchronize_net();
 
 	nf_ct_ext_bump_genid();
 	nf_ct_iterate_cleanup(iter, data, 0, 0);
+
+	/* Another cpu might be in a rcu read section with
+	 * rcu protected pointer cleared in iter callback
+	 * or hidden via nf_ct_ext_bump_genid() above.
+	 *
+	 * Wait until those are done.
+	 */
+	synchronize_rcu();
 }
 EXPORT_SYMBOL_GPL(nf_ct_iterate_destroy);
 
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 8dec42ec603e..c12a87ebc3ee 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -468,11 +468,6 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 
 	nf_ct_expect_iterate_destroy(expect_iter_me, NULL);
 	nf_ct_iterate_destroy(unhelp, me);
-
-	/* Maybe someone has gotten the helper already when unhelp above.
-	 * So need to wait it.
-	 */
-	synchronize_rcu();
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
 
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 5d49fbeabd86..17fe12bfb6b0 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -675,7 +675,6 @@ static void __exit cttimeout_exit(void)
 	RCU_INIT_POINTER(nf_ct_timeout_hook, NULL);
 
 	nf_ct_iterate_destroy(untimeout, NULL);
-	synchronize_rcu();
 }
 
 module_init(cttimeout_init);
-- 
2.34.1

