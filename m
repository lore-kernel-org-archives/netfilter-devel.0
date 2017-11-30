From: Florian Westphal <fw@strlen.de>
Subject: [PATCH ipset nf-next] netfilter: ipset: add resched points during set listing
Date: Thu, 30 Nov 2017 21:08:05 +0100
Message-ID: <20171130200805.2895-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37174 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750849AbdK3UIL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Nov 2017 15:08:11 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When sets are extremely large we can get softlockup during ipset -L.
We could fix this by adding cond_resched_rcu() at the right location
during iteration, but this only works if RCU nesting depth is 1.

At this time entire variant->list() is called under under rcu_read_lock_bh.
This used to be a read_lock_bh() but as rcu doesn't really lock anything,
it does not appear to be needed, so remove it (ipset increments set
reference count before this, so a set deletion should not be possible).

Reported-by: Li Shuang <shuali@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipset/ip_set_bitmap_gen.h | 1 +
 net/netfilter/ipset/ip_set_core.c       | 2 --
 net/netfilter/ipset/ip_set_hash_gen.h   | 1 +
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index 5ca18f07683b5..8afe882f846d5 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -227,6 +227,7 @@ mtype_list(const struct ip_set *set,
 	rcu_read_lock();
 	for (; cb->args[IPSET_CB_ARG0] < map->elements;
 	     cb->args[IPSET_CB_ARG0]++) {
+		cond_resched_rcu();
 		id = cb->args[IPSET_CB_ARG0];
 		x = get_ext(set, map, id);
 		if (!test_bit(id, map->members) ||
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 1f3c03b3bebf2..89b44458a7613 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1388,9 +1388,7 @@ ip_set_dump_start(struct sk_buff *skb, struct netlink_callback *cb)
 				set->variant->uref(set, cb, true);
 			/* fall through */
 		default:
-			rcu_read_lock_bh();
 			ret = set->variant->list(set, skb, cb);
-			rcu_read_unlock_bh();
 			if (!cb->args[IPSET_CB_ARG0])
 				/* Set is done, proceed with next one */
 				goto next_set;
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index efffc8eabafea..8ef079db7d347 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1143,6 +1143,7 @@ mtype_list(const struct ip_set *set,
 	rcu_read_lock();
 	for (; cb->args[IPSET_CB_ARG0] < jhash_size(t->htable_bits);
 	     cb->args[IPSET_CB_ARG0]++) {
+		cond_resched_rcu();
 		incomplete = skb_tail_pointer(skb);
 		n = rcu_dereference(hbucket(t, cb->args[IPSET_CB_ARG0]));
 		pr_debug("cb->arg bucket: %lu, t %p n %p\n",
-- 
2.14.3

