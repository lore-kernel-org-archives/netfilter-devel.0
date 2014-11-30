From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 01/14] netfilter: ipset: Support updating extensions when the set is full
Date: Sun, 30 Nov 2014 19:56:52 +0100
Message-ID: <1417373825-3734-2-git-send-email-kadlec@blackhole.kfki.hu>
References: <1417373825-3734-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:55033 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbaK3S4K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Nov 2014 13:56:10 -0500
In-Reply-To: <1417373825-3734-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When the set was full (hash type and maxelem reached), it was not
possible to update the extension part of already existing elements.
The patch removes this limitation. (Fixes netfilter bugzilla id 880.)

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 40 +++++++++++++++--------------------
 1 file changed, 17 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index fee7c64e..a12ee04 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -633,29 +633,6 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	bool flag_exist = flags & IPSET_FLAG_EXIST;
 	u32 key, multi = 0;
 
-	if (h->elements >= h->maxelem && SET_WITH_FORCEADD(set)) {
-		rcu_read_lock_bh();
-		t = rcu_dereference_bh(h->table);
-		key = HKEY(value, h->initval, t->htable_bits);
-		n = hbucket(t,key);
-		if (n->pos) {
-			/* Choosing the first entry in the array to replace */
-			j = 0;
-			goto reuse_slot;
-		}
-		rcu_read_unlock_bh();
-	}
-	if (SET_WITH_TIMEOUT(set) && h->elements >= h->maxelem)
-		/* FIXME: when set is full, we slow down here */
-		mtype_expire(set, h, NLEN(set->family), set->dsize);
-
-	if (h->elements >= h->maxelem) {
-		if (net_ratelimit())
-			pr_warn("Set %s is full, maxelem %u reached\n",
-				set->name, h->maxelem);
-		return -IPSET_ERR_HASH_FULL;
-	}
-
 	rcu_read_lock_bh();
 	t = rcu_dereference_bh(h->table);
 	key = HKEY(value, h->initval, t->htable_bits);
@@ -680,6 +657,23 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		    j != AHASH_MAX(h) + 1)
 			j = i;
 	}
+	if (h->elements >= h->maxelem && SET_WITH_FORCEADD(set) && n->pos) {
+		/* Choosing the first entry in the array to replace */
+		j = 0;
+		goto reuse_slot;
+	}
+	if (SET_WITH_TIMEOUT(set) && h->elements >= h->maxelem)
+		/* FIXME: when set is full, we slow down here */
+		mtype_expire(set, h, NLEN(set->family), set->dsize);
+
+	if (h->elements >= h->maxelem) {
+		if (net_ratelimit())
+			pr_warn("Set %s is full, maxelem %u reached\n",
+				set->name, h->maxelem);
+		ret = -IPSET_ERR_HASH_FULL;
+		goto out;
+	}
+
 reuse_slot:
 	if (j != AHASH_MAX(h) + 1) {
 		/* Fill out reused slot */
-- 
1.8.5.1

