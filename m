Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796D1273D8D
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jul 2026 13:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784035174; cv=none; b=IhUCuBsbuS0gEI6ZJBl9V5AB41ejE2JAheJ0bSUs2CGvq7crppZZiL+zLu69Hbf1dCOxYKNfQEU1ZhMuN7MAvKVHW+ACPSzr3lLjGFMpHwjqHU80kCuv/I9AeactQXYlB6SRK8fvEqjLtRq8mAEUIP16PUCirKq86z9dktWcmDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784035174; c=relaxed/simple;
	bh=Yna+6rzK6SMpXh1JEQeS3mwZlXiAWEaLqVDoqhM6tcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hq+na4ka0ij7faOrVHdCvIGuTSOw2AZcRpypAdaH/BlCRs45CN7oUmFwLeFFMm6wFOcbe6e++YklZZgM+jVEVy1LDubibvpfYDguZD4R70kNqBgYuDH/dxQOdNvzyTnC5NgyMC4ppqSsHpqrKvkOKKiULsa0F7qqbiaIpa8xXgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CAF2C6080E; Tue, 14 Jul 2026 15:19:27 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: kadlec@netfilter.org,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH RFC nf-next 11/12] netfilter: ipset: remove last region lock usage
Date: Tue, 14 Jul 2026 15:18:27 +0200
Message-ID: <20260714131828.10685-12-fw@strlen.de>
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

Move lock responsibility into kadt/uadt/flush callbacks and remove the
last .region_lock users.

Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/ipset/ip_set.h    |  8 -------
 net/netfilter/ipset/ip_set_bitmap_gen.h   |  2 ++
 net/netfilter/ipset/ip_set_bitmap_ip.c    | 11 +++++++--
 net/netfilter/ipset/ip_set_bitmap_ipmac.c |  9 ++++++-
 net/netfilter/ipset/ip_set_bitmap_port.c  | 11 +++++++--
 net/netfilter/ipset/ip_set_core.c         | 29 +----------------------
 net/netfilter/ipset/ip_set_hash_gen.h     |  1 -
 net/netfilter/ipset/ip_set_list_set.c     |  7 ++++++
 8 files changed, 36 insertions(+), 42 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 99bc997914f4..3d3129118cf2 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -188,14 +188,6 @@ struct ip_set_type_variant {
 	bool (*same_set)(const struct ip_set *a, const struct ip_set *b);
 	/* Cancel ongoing garbage collectors before destroying the set*/
 	void (*cancel_gc)(struct ip_set *set);
-	/* Region-locking is used */
-	bool region_lock;
-};
-
-struct ip_set_region {
-	spinlock_t lock;	/* Region lock */
-	size_t ext_size;	/* Size of the dynamic extensions */
-	u32 elements;		/* Number of elements vs timeout */
 };
 
 /* Max range where every element is added/deleted in one step */
diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index ca68b6e51214..fb964b5613c3 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -73,11 +73,13 @@ mtype_flush(struct ip_set *set)
 {
 	struct mtype *map = set->data;
 
+	spin_lock_bh(&set->lock);
 	if (set->extensions & IPSET_EXT_DESTROY)
 		mtype_ext_cleanup(set);
 	bitmap_zero(map->members, map->elements);
 	set->elements = 0;
 	set->ext_size = 0;
+	spin_unlock_bh(&set->lock);
 }
 
 /* Calculate the actual memory size of the set data */
diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
index ac7febce074f..247cd1b4f4e1 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -115,6 +115,7 @@ bitmap_ip_kadt(struct ip_set *set, const struct sk_buff *skb,
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct bitmap_ip_adt_elem e = { .id = 0 };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
+	int ret;
 	u32 ip;
 
 	ip = ntohl(ip4addr(skb, opt->flags & IPSET_DIM_ONE_SRC));
@@ -123,7 +124,11 @@ bitmap_ip_kadt(struct ip_set *set, const struct sk_buff *skb,
 
 	e.id = ip_to_id(map, ip);
 
-	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
+	spin_lock_bh(&set->lock);
+	ret = adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
+	spin_unlock_bh(&set->lock);
+
+	return ret;
 }
 
 static int
@@ -178,15 +183,17 @@ bitmap_ip_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (ip < map->first_ip || ip_to > map->last_ip)
 		return -IPSET_ERR_BITMAP_RANGE;
 
+	spin_lock_bh(&set->lock);
 	for (; !before(ip_to, ip); ip += map->hosts) {
 		e.id = ip_to_id(map, ip);
 		ret = adtfn(set, &e, &ext, &ext, flags);
 
 		if (ret && !ip_set_eexist(ret, flags))
-			return ret;
+			break;
 
 		ret = 0;
 	}
+	spin_unlock_bh(&set->lock);
 	return ret;
 }
 
diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 5921fd9d2dca..a7823dcc2f8e 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -214,6 +214,7 @@ bitmap_ipmac_kadt(struct ip_set *set, const struct sk_buff *skb,
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct bitmap_ipmac_adt_elem e = { .id = 0, .add_mac = 1 };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
+	int ret;
 	u32 ip;
 
 	ip = ntohl(ip4addr(skb, opt->flags & IPSET_DIM_ONE_SRC));
@@ -235,7 +236,11 @@ bitmap_ipmac_kadt(struct ip_set *set, const struct sk_buff *skb,
 	if (is_zero_ether_addr(e.ether))
 		return -EINVAL;
 
-	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
+	spin_lock_bh(&set->lock);
+	ret = adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
+	spin_unlock_bh(&set->lock);
+
+	return ret;
 }
 
 static int
@@ -273,7 +278,9 @@ bitmap_ipmac_uadt(struct ip_set *set, struct nlattr *tb[],
 		memcpy(e.ether, nla_data(tb[IPSET_ATTR_ETHER]), ETH_ALEN);
 		e.add_mac = 1;
 	}
+	spin_lock_bh(&set->lock);
 	ret = adtfn(set, &e, &ext, &ext, flags);
+	spin_unlock_bh(&set->lock);
 
 	return ip_set_eexist(ret, flags) ? 0 : ret;
 }
diff --git a/net/netfilter/ipset/ip_set_bitmap_port.c b/net/netfilter/ipset/ip_set_bitmap_port.c
index ca875c982424..2a868a022b41 100644
--- a/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -134,6 +134,7 @@ bitmap_port_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 	__be16 __port;
 	u16 port = 0;
+	int ret;
 
 	if (!ip_set_get_ip_port(skb, opt->family,
 				opt->flags & IPSET_DIM_ONE_SRC, &__port))
@@ -146,7 +147,11 @@ bitmap_port_kadt(struct ip_set *set, const struct sk_buff *skb,
 
 	e.id = port_to_id(map, port);
 
-	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
+	spin_lock_bh(&set->lock);
+	ret = adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
+	spin_unlock_bh(&set->lock);
+
+	return ret;
 }
 
 static int
@@ -194,15 +199,17 @@ bitmap_port_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (port_to > map->last_port)
 		return -IPSET_ERR_BITMAP_RANGE;
 
+	spin_lock_bh(&set->lock);
 	for (; port <= port_to; port++) {
 		e.id = port_to_id(map, port);
 		ret = adtfn(set, &e, &ext, &ext, flags);
 
 		if (ret && !ip_set_eexist(ret, flags))
-			return ret;
+			break;
 
 		ret = 0;
 	}
+	spin_unlock_bh(&set->lock);
 	return ret;
 }
 
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index a5f77f639d2a..bc2434392560 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -722,20 +722,6 @@ ip_set_rcu_get(struct net *net, ip_set_id_t index)
 	return ip_set_dereference_nfnl(inst->ip_set_list)[index];
 }
 
-static inline void
-ip_set_lock(struct ip_set *set)
-{
-	if (!set->variant->region_lock)
-		spin_lock_bh(&set->lock);
-}
-
-static inline void
-ip_set_unlock(struct ip_set *set)
-{
-	if (!set->variant->region_lock)
-		spin_unlock_bh(&set->lock);
-}
-
 int
 ip_set_test(ip_set_id_t index, const struct sk_buff *skb,
 	    const struct xt_action_param *par, struct ip_set_adt_opt *opt)
@@ -755,9 +741,7 @@ ip_set_test(ip_set_id_t index, const struct sk_buff *skb,
 	if (ret == -EAGAIN) {
 		/* Type requests element to be completed */
 		pr_debug("element must be completed, ADD is triggered\n");
-		ip_set_lock(set);
 		set->variant->kadt(set, skb, par, IPSET_ADD, opt);
-		ip_set_unlock(set);
 		ret = 1;
 	} else {
 		/* --return-nomatch: invert matched element */
@@ -786,9 +770,7 @@ ip_set_add(ip_set_id_t index, const struct sk_buff *skb,
 	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
 		return -IPSET_ERR_TYPE_MISMATCH;
 
-	ip_set_lock(set);
 	ret = set->variant->kadt(set, skb, par, IPSET_ADD, opt);
-	ip_set_unlock(set);
 
 	return ret;
 }
@@ -799,7 +781,6 @@ ip_set_del(ip_set_id_t index, const struct sk_buff *skb,
 	   const struct xt_action_param *par, struct ip_set_adt_opt *opt)
 {
 	struct ip_set *set = ip_set_rcu_get(xt_net(par), index);
-	int ret = 0;
 
 	BUG_ON(!set);
 	pr_debug("set %s, index %u\n", set->name, index);
@@ -808,11 +789,7 @@ ip_set_del(ip_set_id_t index, const struct sk_buff *skb,
 	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
 		return -IPSET_ERR_TYPE_MISMATCH;
 
-	ip_set_lock(set);
-	ret = set->variant->kadt(set, skb, par, IPSET_DEL, opt);
-	ip_set_unlock(set);
-
-	return ret;
+	return set->variant->kadt(set, skb, par, IPSET_DEL, opt);
 }
 EXPORT_SYMBOL_GPL(ip_set_del);
 
@@ -1298,9 +1275,7 @@ ip_set_flush_set(struct ip_set *set)
 {
 	pr_debug("set: %s\n",  set->name);
 
-	ip_set_lock(set);
 	set->variant->flush(set);
-	ip_set_unlock(set);
 }
 
 static int ip_set_flush(struct sk_buff *skb, const struct nfnl_info *info,
@@ -1754,9 +1729,7 @@ call_ad(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 			__ip_set_put_netlink(set);
 		}
 
-		ip_set_lock(set);
 		ret = set->variant->uadt(set, tb, adt, &lineno, flags, retried);
-		ip_set_unlock(set);
 		retried = true;
 	} while (ret == -ERANGE ||
 		 (ret == -EAGAIN &&
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index e615de2e616b..12d3bc5acc81 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -957,7 +957,6 @@ static const struct ip_set_type_variant mtype_variant = {
 	.resize	= NULL,
 	.same_set = mtype_same_set,
 	.cancel_gc = mtype_cancel_gc,
-	.region_lock = true,
 };
 
 #ifdef IP_SET_EMIT_CREATE
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 27bc96458e13..3669b4c9e575 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -119,6 +119,7 @@ list_set_kadt(struct ip_set *set, const struct sk_buff *skb,
 	int ret = -EINVAL;
 
 	rcu_read_lock();
+	spin_lock_bh(&set->lock);
 	switch (adt) {
 	case IPSET_TEST:
 		ret = list_set_ktest(set, skb, par, opt, &ext);
@@ -132,6 +133,7 @@ list_set_kadt(struct ip_set *set, const struct sk_buff *skb,
 	default:
 		break;
 	}
+	spin_unlock_bh(&set->lock);
 	rcu_read_unlock();
 
 	return ret;
@@ -404,10 +406,13 @@ list_set_uadt(struct ip_set *set, struct nlattr *tb[],
 		if (!e.before)
 			e.before = -1;
 	}
+
+	spin_lock_bh(&set->lock);
 	if (adt != IPSET_TEST && SET_WITH_TIMEOUT(set))
 		set_cleanup_entries(set);
 
 	ret = adtfn(set, &e, &ext, &ext, flags);
+	spin_unlock_bh(&set->lock);
 
 finish:
 	if (e.refid != IPSET_INVALID_ID)
@@ -424,10 +429,12 @@ list_set_flush(struct ip_set *set)
 	struct list_set *map = set->data;
 	struct set_elem *e, *n;
 
+	spin_lock_bh(&set->lock);
 	list_for_each_entry_safe(e, n, &map->members, list)
 		list_set_del(set, e);
 	set->elements = 0;
 	set->ext_size = 0;
+	spin_unlock_bh(&set->lock);
 }
 
 static void
-- 
2.54.0

