Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E794B5221F0
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Sep 2026 18:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788548052; cv=none; b=Sy0IYixtcC4JOrSzLwz8njDtVHO8zfpHKQH5WAOMLIPILEQM6GhqX0c2XP314VTvN5juVxdAluufmFMLnJamCUoHA0EbZUupdbAfXunb1JhdOzmqAdb6ZxKJJqNrwi5tPSTrfN1pFDxIAJIhWW2uDl33MyO4ukM2a861HmfoRzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788548052; c=relaxed/simple;
	bh=4iTEDBT+ITu+XlPTqft2fGemXLd3iwTcWgcfeLwUzJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gna6Nc9iJzYIiZzWpbujSs451MvK5D2+EMkmVFDh5WVfeycrdPO0vvDg+zaNTH5plcgeE31wr+QsqH4OZtdhh7ibhT+A97OrLxS9/ifYw2rTkIZuNiAPUZHQUMoDZwMTqP4y2U5P5AtdX/beTVYVBAaLvjlA+RlN5GT2b9a/gMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D73206035B; Fri, 04 Sep 2026 20:54:07 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v4 08/13] netfilter: ipset: remove last region lock usage
Date: Fri,  4 Sep 2026 20:53:16 +0200
Message-ID: <20260904185321.30313-9-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904185321.30313-1-fw@strlen.de>
References: <20260904185321.30313-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move lock responsibility into kadt/uadt/flush callbacks and remove the
last .region_lock users.  Keep bitmap types IPSET_TEST lockless, this
is called from xt_set / datapath.

Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/ipset/ip_set.h    |  8 -------
 net/netfilter/ipset/ip_set_bitmap_gen.h   |  2 ++
 net/netfilter/ipset/ip_set_bitmap_ip.c    | 14 +++++++++--
 net/netfilter/ipset/ip_set_bitmap_ipmac.c | 13 +++++++++-
 net/netfilter/ipset/ip_set_bitmap_port.c  | 14 +++++++++--
 net/netfilter/ipset/ip_set_core.c         | 29 +----------------------
 net/netfilter/ipset/ip_set_hash_gen.h     |  1 -
 net/netfilter/ipset/ip_set_list_set.c     |  7 ++++++
 8 files changed, 46 insertions(+), 42 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index c46864cc6623..37cfda517c1b 100644
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
index d6a7e6604542..0b6dd2e13433 100644
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
 	DEBUG_NET_WARN_ON_ONCE(atomic64_read(&set->ext_size) > 0);
+	spin_unlock_bh(&set->lock);
 }
 
 /* Calculate the actual memory size of the set data */
diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
index ac7febce074f..9307c89d2837 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -115,6 +115,7 @@ bitmap_ip_kadt(struct ip_set *set, const struct sk_buff *skb,
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct bitmap_ip_adt_elem e = { .id = 0 };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
+	int ret;
 	u32 ip;
 
 	ip = ntohl(ip4addr(skb, opt->flags & IPSET_DIM_ONE_SRC));
@@ -123,7 +124,14 @@ bitmap_ip_kadt(struct ip_set *set, const struct sk_buff *skb,
 
 	e.id = ip_to_id(map, ip);
 
-	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
+	if (adt == IPSET_TEST)
+		return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
+
+	spin_lock_bh(&set->lock);
+	ret = adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
+	spin_unlock_bh(&set->lock);
+
+	return ret;
 }
 
 static int
@@ -178,15 +186,17 @@ bitmap_ip_uadt(struct ip_set *set, struct nlattr *tb[],
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
index 5921fd9d2dca..720650d0c3f1 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -214,6 +214,7 @@ bitmap_ipmac_kadt(struct ip_set *set, const struct sk_buff *skb,
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct bitmap_ipmac_adt_elem e = { .id = 0, .add_mac = 1 };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
+	int ret;
 	u32 ip;
 
 	ip = ntohl(ip4addr(skb, opt->flags & IPSET_DIM_ONE_SRC));
@@ -235,7 +236,14 @@ bitmap_ipmac_kadt(struct ip_set *set, const struct sk_buff *skb,
 	if (is_zero_ether_addr(e.ether))
 		return -EINVAL;
 
-	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
+	if (adt == IPSET_TEST)
+		return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
+
+	spin_lock_bh(&set->lock);
+	ret = adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
+	spin_unlock_bh(&set->lock);
+
+	return ret;
 }
 
 static int
@@ -273,7 +281,10 @@ bitmap_ipmac_uadt(struct ip_set *set, struct nlattr *tb[],
 		memcpy(e.ether, nla_data(tb[IPSET_ATTR_ETHER]), ETH_ALEN);
 		e.add_mac = 1;
 	}
+
+	spin_lock_bh(&set->lock);
 	ret = adtfn(set, &e, &ext, &ext, flags);
+	spin_unlock_bh(&set->lock);
 
 	return ip_set_eexist(ret, flags) ? 0 : ret;
 }
diff --git a/net/netfilter/ipset/ip_set_bitmap_port.c b/net/netfilter/ipset/ip_set_bitmap_port.c
index ca875c982424..ea644bd420c5 100644
--- a/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -134,6 +134,7 @@ bitmap_port_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 	__be16 __port;
 	u16 port = 0;
+	int ret;
 
 	if (!ip_set_get_ip_port(skb, opt->family,
 				opt->flags & IPSET_DIM_ONE_SRC, &__port))
@@ -146,7 +147,14 @@ bitmap_port_kadt(struct ip_set *set, const struct sk_buff *skb,
 
 	e.id = port_to_id(map, port);
 
-	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
+	if (adt == IPSET_TEST)
+		return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
+
+	spin_lock_bh(&set->lock);
+	ret = adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
+	spin_unlock_bh(&set->lock);
+
+	return ret;
 }
 
 static int
@@ -194,15 +202,17 @@ bitmap_port_uadt(struct ip_set *set, struct nlattr *tb[],
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
index 0a86a170ba90..339726b33342 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -730,20 +730,6 @@ ip_set_rcu_get(struct net *net, ip_set_id_t index)
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
@@ -763,9 +749,7 @@ ip_set_test(ip_set_id_t index, const struct sk_buff *skb,
 	if (ret == -EAGAIN) {
 		/* Type requests element to be completed */
 		pr_debug("element must be completed, ADD is triggered\n");
-		ip_set_lock(set);
 		set->variant->kadt(set, skb, par, IPSET_ADD, opt);
-		ip_set_unlock(set);
 		ret = 1;
 	} else {
 		/* --return-nomatch: invert matched element */
@@ -794,9 +778,7 @@ ip_set_add(ip_set_id_t index, const struct sk_buff *skb,
 	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
 		return -IPSET_ERR_TYPE_MISMATCH;
 
-	ip_set_lock(set);
 	ret = set->variant->kadt(set, skb, par, IPSET_ADD, opt);
-	ip_set_unlock(set);
 
 	return ret;
 }
@@ -807,7 +789,6 @@ ip_set_del(ip_set_id_t index, const struct sk_buff *skb,
 	   const struct xt_action_param *par, struct ip_set_adt_opt *opt)
 {
 	struct ip_set *set = ip_set_rcu_get(xt_net(par), index);
-	int ret = 0;
 
 	BUG_ON(!set);
 	pr_debug("set %s, index %u\n", set->name, index);
@@ -816,11 +797,7 @@ ip_set_del(ip_set_id_t index, const struct sk_buff *skb,
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
 
@@ -1311,9 +1288,7 @@ ip_set_flush_set(struct ip_set *set)
 {
 	pr_debug("set: %s\n",  set->name);
 
-	ip_set_lock(set);
 	set->variant->flush(set);
-	ip_set_unlock(set);
 }
 
 static int ip_set_flush(struct sk_buff *skb, const struct nfnl_info *info,
@@ -1767,9 +1742,7 @@ call_ad(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 			__ip_set_put_netlink(set);
 		}
 
-		ip_set_lock(set);
 		ret = set->variant->uadt(set, tb, adt, &lineno, flags, retried);
-		ip_set_unlock(set);
 		retried = true;
 	} while (ret == -ERANGE ||
 		 (ret == -EAGAIN &&
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 4efc93333aef..b6614ddb9e78 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1313,7 +1313,6 @@ static const struct ip_set_type_variant mtype_variant = {
 	.resize	= NULL,
 	.same_set = mtype_same_set,
 	.cancel_gc = mtype_cancel_gc,
-	.region_lock = true,
 };
 
 #ifdef IP_SET_EMIT_CREATE
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index f070088742d6..738f14a73684 100644
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
@@ -401,10 +403,13 @@ list_set_uadt(struct ip_set *set, struct nlattr *tb[],
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
@@ -421,9 +426,11 @@ list_set_flush(struct ip_set *set)
 	struct list_set *map = set->data;
 	struct set_elem *e, *n;
 
+	spin_lock_bh(&set->lock);
 	list_for_each_entry_safe(e, n, &map->members, list)
 		list_set_del(set, e);
 	DEBUG_NET_WARN_ON_ONCE(set->elements > 0);
+	spin_unlock_bh(&set->lock);
 }
 
 static void
-- 
2.55.0

