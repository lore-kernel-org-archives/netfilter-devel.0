Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41B941B34C;
	Wed,  8 Jul 2026 14:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783519432; cv=none; b=YGi1knf3DkafsBHdpKw0pfhRCI+OpuNIj+C76a4FYCS4iL7ya6pi0lI/EHXs/h8yAkPOINV3HkuJaP9a7k4+KbWsw27TCg8fwMMU79s5ps7a2PmVHhWemQ+HkraF0+wpN6TNsRZfDjFE8WovWNQp3Vnx9KgAaga+9Y1kXxCSNgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783519432; c=relaxed/simple;
	bh=MXzpv+CWixMan6pgnEZURnqUp96SjhTEp2DVQXMxC08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFqR1cV4U4AqQ/YI7OHdLSfKSNuL/wCBONnHW0c6Cb+K8p2nqrXWUD27a7snumvNTvt+kzH53Hg7KPxCDcjECW3nDTD1IPyo65R87AkhTYFN+3dWDyeS150zNxZOcDDOBBX4v9+fAs/65PKAET8SrUKA0Vx4ndzWd8UNjWS0gZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1D1456059E; Wed, 08 Jul 2026 16:03:49 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 07/17] netfilter: ipset: exclude gc when resize is in progress
Date: Wed,  8 Jul 2026 16:02:59 +0200
Message-ID: <20260708140309.19633-8-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260708140309.19633-1-fw@strlen.de>
References: <20260708140309.19633-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jozsef Kadlecsik <kadlec@netfilter.org>

Zhengchuan Liang and Eulgyu Kim reported that because resize
does not copy the comment extension into the resized set but
uses it's pointer, ongoing gc can free the extension in the
original set which then results stale pointer in the resized
one. The proposed patch was to recreate the extensions for
every element in the resized set. It is both expensive and
wastes memory, so better exclude gc when resizing in progress
detected: resizing will destroy the original set anyway,
so doing gc on it is unnecessary.

Introduce a new spinlock to exclude parallel gc and resize.
Because we just set and check a bool value, there's no need
for the parameter to be atomic_t and rename it for better
readability.

Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Reported by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported by: Eulgyu Kim <eulgyukim@snu.ac.kr>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 31 +++++++++++++++++----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index c9a071766243..8104dbac02fa 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -75,12 +75,13 @@ struct hbucket {
 struct htable_gc {
 	struct delayed_work dwork;
 	struct ip_set *set;	/* Set the gc belongs to */
+	spinlock_t lock;	/* Lock to exclude gc and resize */
 	u32 region;		/* Last gc run position */
 };
 
 /* The hash table: the table size stored here in order to make resizing easy */
 struct htable {
-	atomic_t ref;		/* References for resizing */
+	bool resizing;		/* Mark ongoing resize */
 	atomic_t uref;		/* References for dumping and gc */
 	u8 htable_bits;		/* size of hash table == 2^htable_bits */
 	u32 maxelem;		/* Maxelem per region */
@@ -582,9 +583,12 @@ mtype_gc(struct work_struct *work)
 	if (next_run < HZ/10)
 		next_run = HZ/10;
 
-	mtype_gc_do(set, h, t, r);
+	spin_lock_bh(&gc->lock);
+	if (!t->resizing)
+		mtype_gc_do(set, h, t, r);
+	spin_unlock_bh(&gc->lock);
 
-	if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
+	if (atomic_dec_and_test(&t->uref) && t->resizing) {
 		pr_debug("Table destroy after resize by expire: %p\n", t);
 		mtype_ahash_destroy(set, t, false);
 	}
@@ -672,11 +676,13 @@ mtype_resize(struct ip_set *set, bool retried)
 		spin_lock_init(&t->hregion[i].lock);
 
 	/* There can't be another parallel resizing,
-	 * but dumping, gc, kernel side add/del are possible
+	 * but dumping and kernel side add/del are possible
 	 */
 	orig = ipset_dereference_bh_nfnl(h->table);
-	atomic_set(&orig->ref, 1);
 	atomic_inc(&orig->uref);
+	spin_lock_bh(&h->gc.lock);
+	orig->resizing = true;
+	spin_unlock_bh(&h->gc.lock);
 	pr_debug("attempt to resize set %s from %u to %u, t %p\n",
 		 set->name, orig->htable_bits, htable_bits, orig);
 	for (r = 0; r < ahash_numof_locks(orig->htable_bits); r++) {
@@ -792,7 +798,9 @@ mtype_resize(struct ip_set *set, bool retried)
 
 cleanup:
 	rcu_read_unlock_bh();
-	atomic_set(&orig->ref, 0);
+	spin_lock_bh(&h->gc.lock);
+	orig->resizing = false;
+	spin_unlock_bh(&h->gc.lock);
 	atomic_dec(&orig->uref);
 	mtype_ahash_destroy(set, t, false);
 	if (ret == -EAGAIN)
@@ -1000,7 +1008,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	ret = 0;
 resize:
 	spin_unlock_bh(&t->hregion[r].lock);
-	if (atomic_read(&t->ref) && ext->target) {
+	if (t->resizing && ext && ext->target) {
 		/* Resize is in process and kernel side add, save values */
 		struct mtype_resize_ad *x;
 
@@ -1027,7 +1035,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 unlock:
 	spin_unlock_bh(&t->hregion[r].lock);
 out:
-	if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
+	if (atomic_dec_and_test(&t->uref) && t->resizing) {
 		pr_debug("Table destroy after resize by add: %p\n", t);
 		mtype_ahash_destroy(set, t, false);
 	}
@@ -1090,7 +1098,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 #endif
 		ip_set_ext_destroy(set, data);
 
-		if (atomic_read(&t->ref) && ext->target) {
+		if (t->resizing && ext && ext->target) {
 			/* Resize is in process and kernel side del,
 			 * save values
 			 */
@@ -1141,7 +1149,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		list_add(&x->list, &h->ad);
 		spin_unlock_bh(&set->lock);
 	}
-	if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
+	if (atomic_dec_and_test(&t->uref) && t->resizing) {
 		pr_debug("Table destroy after resize by del: %p\n", t);
 		mtype_ahash_destroy(set, t, false);
 	}
@@ -1350,7 +1358,7 @@ mtype_uref(struct ip_set *set, struct netlink_callback *cb, bool start)
 		rcu_read_unlock_bh();
 	} else if (cb->args[IPSET_CB_PRIVATE]) {
 		t = (struct htable *)cb->args[IPSET_CB_PRIVATE];
-		if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
+		if (atomic_dec_and_test(&t->uref) && t->resizing) {
 			pr_debug("Table destroy after resize "
 				 " by dump: %p\n", t);
 			mtype_ahash_destroy(set, t, false);
@@ -1590,6 +1598,7 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 		return -ENOMEM;
 	}
 	h->gc.set = set;
+	spin_lock_init(&h->gc.lock);
 	for (i = 0; i < ahash_numof_locks(hbits); i++)
 		spin_lock_init(&t->hregion[i].lock);
 	h->maxelem = maxelem;
-- 
2.54.0

