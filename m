From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 12/22] netfilter: ipset: Remove redundant mtype_expire() arguments
Date: Thu, 10 Nov 2016 13:57:46 +0100
Message-ID: <1478782676-9770-13-git-send-email-kadlec@blackhole.kfki.hu>
References: <1478782676-9770-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:36182 "EHLO smtp1.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932985AbcKJM6C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Nov 2016 07:58:02 -0500
In-Reply-To: <1478782676-9770-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove redundant parameters nets_length and dsize, because
they can be get from other parameters.

Ported from a patch proposed by Sergey Popovich <popovich_sergei@mail.ua>.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 0746405..c4877b6 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -465,14 +465,15 @@ struct htype {
 
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
@@ -539,7 +540,7 @@ struct htype {
 
 	pr_debug("called\n");
 	spin_lock_bh(&set->lock);
-	mtype_expire(set, h, NLEN(set->family), set->dsize);
+	mtype_expire(set, h);
 	spin_unlock_bh(&set->lock);
 
 	h->gc.expires = jiffies + IPSET_GC_PERIOD(set->timeout) * HZ;
@@ -715,7 +716,7 @@ struct htype {
 	if (set->elements >= h->maxelem) {
 		if (SET_WITH_TIMEOUT(set))
 			/* FIXME: when set is full, we slow down here */
-			mtype_expire(set, h, NLEN(set->family), set->dsize);
+			mtype_expire(set, h);
 		if (set->elements >= h->maxelem && SET_WITH_FORCEADD(set))
 			forceadd = true;
 	}
-- 
1.8.5.1

