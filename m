From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 27/39] netfilter: ipset: Remove redundant mtype_expire() arguments
Date: Sun, 13 Nov 2016 23:25:21 +0100
Message-ID: <1479075933-4491-28-git-send-email-pablo@netfilter.org>
References: <1479075933-4491-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1479075933-4491-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Remove redundant parameters nets_length and dsize, because
they can be get from other parameters.

Ported from a patch proposed by Sergey Popovich <popovich_sergei@mail.ua>.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 0746405a1d14..c4877b6de74f 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -465,14 +465,15 @@ mtype_same_set(const struct ip_set *a, const struct ip_set *b)
 
 /* Delete expired elements from the hashtable */
 static void
-mtype_expire(struct ip_set *set, struct htype *h, u8 nets_length, size_t dsize)
+mtype_expire(struct ip_set *set, struct htype *h)
 {
 	struct htable *t;
 	struct hbucket *n, *tmp;
 	struct mtype_elem *data;
 	u32 i, j, d;
+	size_t dsize = set->dsize;
 #ifdef IP_SET_HASH_WITH_NETS
-	u8 k;
+	u8 k, nets_length = NLEN(set->family);
 #endif
 
 	t = ipset_dereference_protected(h->table, set);
@@ -539,7 +540,7 @@ mtype_gc(unsigned long ul_set)
 
 	pr_debug("called\n");
 	spin_lock_bh(&set->lock);
-	mtype_expire(set, h, NLEN(set->family), set->dsize);
+	mtype_expire(set, h);
 	spin_unlock_bh(&set->lock);
 
 	h->gc.expires = jiffies + IPSET_GC_PERIOD(set->timeout) * HZ;
@@ -715,7 +716,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	if (set->elements >= h->maxelem) {
 		if (SET_WITH_TIMEOUT(set))
 			/* FIXME: when set is full, we slow down here */
-			mtype_expire(set, h, NLEN(set->family), set->dsize);
+			mtype_expire(set, h);
 		if (set->elements >= h->maxelem && SET_WITH_FORCEADD(set))
 			forceadd = true;
 	}
-- 
2.1.4
