From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 6/8] netfilter: ipset: Log warning when a hash type of set gets full
Date: Sat, 14 Jan 2012 17:38:59 +0100
Message-ID: <1326559141-26783-7-git-send-email-kadlec@blackhole.kfki.hu>
References: <1326559141-26783-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:46921 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755539Ab2ANQjV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Jan 2012 11:39:21 -0500
In-Reply-To: <1326559141-26783-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If the set is full, the SET target cannot add more elements.
Log warning so that the admin got notified about it.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set_ahash.h |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set_ahash.h b/include/linux/netfilter/ipset/ip_set_ahash.h
index b89fb79..bd1fc8d 100644
--- a/include/linux/netfilter/ipset/ip_set_ahash.h
+++ b/include/linux/netfilter/ipset/ip_set_ahash.h
@@ -353,9 +353,12 @@ retry:
 	htable_bits++;
 	pr_debug("attempt to resize set %s from %u to %u, t %p\n",
 		 set->name, orig->htable_bits, htable_bits, orig);
-	if (!htable_bits)
+	if (!htable_bits) {
 		/* In case we have plenty of memory :-) */
+		pr_warning("Cannot increase the hashsize of set %s further\n",
+			   set->name);
 		return -IPSET_ERR_HASH_FULL;
+	}
 	t = ip_set_alloc(sizeof(*t)
 			 + jhash_size(htable_bits) * sizeof(struct hbucket));
 	if (!t)
@@ -407,8 +410,12 @@ type_pf_add(struct ip_set *set, void *value, u32 timeout, u32 flags)
 	int i, ret = 0;
 	u32 key, multi = 0;
 
-	if (h->elements >= h->maxelem)
+	if (h->elements >= h->maxelem) {
+		if (net_ratelimit())
+			pr_warning("Set %s is full, maxelem %u reached\n",
+				   set->name, h->maxelem);
 		return -IPSET_ERR_HASH_FULL;
+	}
 
 	rcu_read_lock_bh();
 	t = rcu_dereference_bh(h->table);
@@ -790,9 +797,12 @@ type_pf_tresize(struct ip_set *set, bool retried)
 retry:
 	ret = 0;
 	htable_bits++;
-	if (!htable_bits)
+	if (!htable_bits) {
 		/* In case we have plenty of memory :-) */
+		pr_warning("Cannot increase the hashsize of set %s further\n",
+			   set->name);
 		return -IPSET_ERR_HASH_FULL;
+	}
 	t = ip_set_alloc(sizeof(*t)
 			 + jhash_size(htable_bits) * sizeof(struct hbucket));
 	if (!t)
@@ -843,8 +853,12 @@ type_pf_tadd(struct ip_set *set, void *value, u32 timeout, u32 flags)
 	if (h->elements >= h->maxelem)
 		/* FIXME: when set is full, we slow down here */
 		type_pf_expire(h);
-	if (h->elements >= h->maxelem)
+	if (h->elements >= h->maxelem) {
+		if (net_ratelimit())
+			pr_warning("Set %s is full, maxelem %u reached\n",
+				   set->name, h->maxelem);
 		return -IPSET_ERR_HASH_FULL;
+	}
 
 	rcu_read_lock_bh();
 	t = rcu_dereference_bh(h->table);
-- 
1.7.0.4

