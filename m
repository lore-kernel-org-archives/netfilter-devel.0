Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DC1239567
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jul 2026 13:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784035162; cv=none; b=LRdhMg1zDmCgN7Wy5XCnc5pyO78R2MWfF7Ju7FqiwOWwC4k8mycXjeHe/he1OlZ4QxSCErD1rZLcKOUmQ3ewlu34urLKkdRGgLhl8W+wIpB5RflNXTq2m7Xn1cYW7lc869Ci6YyPu3aQ+WAVSUL27uduYcdJrP5QQiDDVd4qcis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784035162; c=relaxed/simple;
	bh=eB1VsvHe/QnUcNUX25Nys66yaWAw9QEmyq3Y0JZEQmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UomixT0d1tlRGU69FMNsQNfTdiOThgSWun9XsXEmfS9AzFTaRQYAcASsGtcETxBmM+xjyjN4fH6KcDwz0iY+QZVA6tAE/Y0Ekk0Nxwg7VoWyqdfVmQWiCPD+GQk9f3SgLmYdcwNvdpRJeGdw+MPJJ51GNd0EnpsA2m9m1G+KyE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 46833606E9; Tue, 14 Jul 2026 15:19:19 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: kadlec@netfilter.org,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH RFC nf-next 09/12] netfilter: ipset: use plain rcu_read_lock
Date: Tue, 14 Jul 2026 15:18:25 +0200
Message-ID: <20260714131828.10685-10-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260714131828.10685-1-fw@strlen.de>
References: <20260714131828.10685-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No need to disable/reenable softirqs.

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipset/ip_set_core.c            |  4 +--
 net/netfilter/ipset/ip_set_hash_gen.h        | 27 +++++++++-----------
 net/netfilter/ipset/ip_set_hash_netnet.c     |  8 +++---
 net/netfilter/ipset/ip_set_hash_netportnet.c |  8 +++---
 4 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 3d6a78ad93f5..6ece5cf305fe 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1903,9 +1903,9 @@ static int ip_set_utest(struct sk_buff *skb, const struct nfnl_info *info,
 			     set->type->adt_policy, NULL))
 		return -IPSET_ERR_PROTOCOL;
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	ret = set->variant->uadt(set, tb, IPSET_TEST, &lineno, 0, 0);
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 	/* Userspace can't trigger element to be re-added */
 	if (ret == -EAGAIN)
 		ret = 1;
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index e4d26f064c48..a0f2cd481b82 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -16,9 +16,6 @@
 #define ipset_dereference_nfnl(p)	\
 	rcu_dereference_protected(p,	\
 		lockdep_nfnl_is_held(NFNL_SUBSYS_IPSET))
-#define ipset_dereference_bh_nfnl(p)	\
-	rcu_dereference_bh_check(p, 	\
-		lockdep_nfnl_is_held(NFNL_SUBSYS_IPSET))
 
 struct htable_gc {
 	struct delayed_work dwork;
@@ -533,18 +530,18 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 #endif
 
 	/* Check for an existing entry with the same key */
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	old = rhashtable_lookup(&h->ht, d, mtype_rht_params);
 	if (old) {
 		if (!SET_ELEM_EXPIRED(set, &old->elem)) {
 			if (!flag_exist) {
-				rcu_read_unlock_bh();
+				rcu_read_unlock();
 				return -IPSET_ERR_EXIST;
 			}
 			/* flag_exist: overwrite extensions in-place.
 			 * Hold set->lock to serialize ext_size accounting in
 			 * ip_set_init_comment against concurrent kernel-side adds.
-			 * rcu_read_lock_bh() must remain held to keep old alive.
+			 * rcu_read_lock() must remain held to keep old alive.
 			 */
 			spin_lock_bh(&set->lock);
 #ifdef IP_SET_HASH_WITH_NETS
@@ -564,7 +561,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 				ip_set_timeout_set(ext_timeout(&old->elem, set),
 						   ext->timeout);
 			spin_unlock_bh(&set->lock);
-			rcu_read_unlock_bh();
+			rcu_read_unlock();
 			return 0;
 		}
 		/* Expired entry: remove it to make room */
@@ -575,7 +572,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 			kfree_rcu(old, rcu);
 		}
 	}
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 
 	if (atomic_read(&h->ht.nelems) >= h->maxelem) {
 		if (net_ratelimit())
@@ -629,14 +626,14 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	struct mtype_rht_elem *e;
 	int ret = -IPSET_ERR_EXIST;
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	e = rhashtable_lookup(&h->ht, d, mtype_rht_params);
 	if (!e) {
-		rcu_read_unlock_bh();
+		rcu_read_unlock();
 		return -IPSET_ERR_EXIST;
 	}
 	ret = rhashtable_remove_fast(&h->ht, &e->node, mtype_rht_params);
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 
 	if (ret)
 		return -IPSET_ERR_EXIST;
@@ -679,9 +676,9 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 	u32 multi = 0;
 
 	pr_debug("test by nets\n");
-	nets0 = ipset_dereference_bh_nfnl(h->rnets[0]);
+	nets0 = rcu_dereference(h->rnets[0]);
 #if IPSET_NET_COUNT == 2
-	nets1 = ipset_dereference_bh_nfnl(h->rnets[1]);
+	nets1 = rcu_dereference(h->rnets[1]);
 #endif
 	for (j = 0; j < nets0->len && !multi; j++) {
 		if (!nets0->nets[j].count)
@@ -727,7 +724,7 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	int i;
 #endif
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 #ifdef IP_SET_HASH_WITH_NETS
 	/* If we test an IP address and not a network address,
 	 * try all possible network sizes
@@ -749,7 +746,7 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 
 	ret = mtype_data_match(&e->elem, ext, mext, set, flags);
 out:
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 	return ret;
 }
 
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset/ip_set_hash_netnet.c
index f7c8a1cc30fc..2b874be16f6d 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -149,10 +149,10 @@ hash_netnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct hash_netnet4_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	e.cidr[0] = INIT_CIDR(h->rnets[0], HOST_MASK);
 	e.cidr[1] = INIT_CIDR(h->rnets[1], HOST_MASK);
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 	if (adt == IPSET_TEST)
 		e.ccmp = (HOST_MASK << (sizeof(e.cidr[0]) * 8)) | HOST_MASK;
 
@@ -390,10 +390,10 @@ hash_netnet6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct hash_netnet6_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	e.cidr[0] = INIT_CIDR(h->rnets[0], HOST_MASK);
 	e.cidr[1] = INIT_CIDR(h->rnets[1], HOST_MASK);
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 	if (adt == IPSET_TEST)
 		e.ccmp = (HOST_MASK << (sizeof(u8) * 8)) | HOST_MASK;
 
diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
index 6291532be7a5..ad171b7cd1f5 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -157,10 +157,10 @@ hash_netportnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct hash_netportnet4_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	e.cidr[0] = INIT_CIDR(h->rnets[0], HOST_MASK);
 	e.cidr[1] = INIT_CIDR(h->rnets[1], HOST_MASK);
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 	if (adt == IPSET_TEST)
 		e.ccmp = (HOST_MASK << (sizeof(e.cidr[0]) * 8)) | HOST_MASK;
 
@@ -454,10 +454,10 @@ hash_netportnet6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct hash_netportnet6_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	e.cidr[0] = INIT_CIDR(h->rnets[0], HOST_MASK);
 	e.cidr[1] = INIT_CIDR(h->rnets[1], HOST_MASK);
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 	if (adt == IPSET_TEST)
 		e.ccmp = (HOST_MASK << (sizeof(u8) * 8)) | HOST_MASK;
 
-- 
2.54.0

