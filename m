From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 2/3] netfilter: ipset: Fix "don't update counters" mode when counters used at the matching
Date: Sat,  6 Jan 2018 16:36:08 +0100
Message-ID: <1515252969-26094-3-git-send-email-kadlec@blackhole.kfki.hu>
References: <1515252969-26094-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:51224 "EHLO smtp1.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753279AbeAFPnm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Jan 2018 10:43:42 -0500
In-Reply-To: <1515252969-26094-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The matching of the counters was not taken into account, fixed.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set.h         |   6 ++
 include/linux/netfilter/ipset/ip_set_counter.h |  25 ++++--
 net/netfilter/ipset/ip_set_bitmap_gen.h        |   9 +-
 net/netfilter/ipset/ip_set_core.c              |  25 ++++++
 net/netfilter/ipset/ip_set_hash_gen.h          |  37 +++-----
 net/netfilter/ipset/ip_set_list_set.c          |  21 ++---
 net/netfilter/xt_set.c                         | 119 +++++++++----------------
 7 files changed, 114 insertions(+), 128 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 8e42253..34fc80f 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -122,6 +122,8 @@ struct ip_set_ext {
 	u64 bytes;
 	char *comment;
 	u32 timeout;
+	u8 packets_op;
+	u8 bytes_op;
 };
 
 struct ip_set;
@@ -339,6 +341,10 @@ extern int ip_set_get_extensions(struct ip_set *set, struct nlattr *tb[],
 				 struct ip_set_ext *ext);
 extern int ip_set_put_extensions(struct sk_buff *skb, const struct ip_set *set,
 				 const void *e, bool active);
+extern bool ip_set_match_extensions(struct ip_set *set,
+				    const struct ip_set_ext *ext,
+				    struct ip_set_ext *mext,
+				    u32 flags, void *data);
 
 static inline int
 ip_set_get_hostipaddr4(struct nlattr *nla, u32 *ipaddr)
diff --git a/include/linux/netfilter/ipset/ip_set_counter.h b/include/linux/netfilter/ipset/ip_set_counter.h
index bb6fba4..3d33a2c 100644
--- a/include/linux/netfilter/ipset/ip_set_counter.h
+++ b/include/linux/netfilter/ipset/ip_set_counter.h
@@ -34,20 +34,33 @@ ip_set_get_packets(const struct ip_set_counter *counter)
 	return (u64)atomic64_read(&(counter)->packets);
 }
 
+static inline bool
+ip_set_match_counter(u64 counter, u64 match, u8 op)
+{
+	switch (op) {
+	case IPSET_COUNTER_NONE:
+		return true;
+	case IPSET_COUNTER_EQ:
+		return counter == match;
+	case IPSET_COUNTER_NE:
+		return counter != match;
+	case IPSET_COUNTER_LT:
+		return counter < match;
+	case IPSET_COUNTER_GT:
+		return counter > match;
+	}
+	return false;
+}
+
 static inline void
 ip_set_update_counter(struct ip_set_counter *counter,
-		      const struct ip_set_ext *ext,
-		      struct ip_set_ext *mext, u32 flags)
+		      const struct ip_set_ext *ext, u32 flags)
 {
 	if (ext->packets != ULLONG_MAX &&
 	    !(flags & IPSET_FLAG_SKIP_COUNTER_UPDATE)) {
 		ip_set_add_bytes(ext->bytes, counter);
 		ip_set_add_packets(ext->packets, counter);
 	}
-	if (flags & IPSET_FLAG_MATCH_COUNTERS) {
-		mext->packets = ip_set_get_packets(counter);
-		mext->bytes = ip_set_get_bytes(counter);
-	}
 }
 
 static inline bool
diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index 8afe882..257ca39 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -127,14 +127,7 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 
 	if (ret <= 0)
 		return ret;
-	if (SET_WITH_TIMEOUT(set) &&
-	    ip_set_timeout_expired(ext_timeout(x, set)))
-		return 0;
-	if (SET_WITH_COUNTER(set))
-		ip_set_update_counter(ext_counter(x, set), ext, mext, flags);
-	if (SET_WITH_SKBINFO(set))
-		ip_set_get_skbinfo(ext_skbinfo(x, set), ext, mext, flags);
-	return 1;
+	return ip_set_match_extensions(set, ext, mext, flags, x);
 }
 
 static int
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 89b4445..e002990 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -472,6 +472,31 @@ ip_set_put_extensions(struct sk_buff *skb, const struct ip_set *set,
 }
 EXPORT_SYMBOL_GPL(ip_set_put_extensions);
 
+bool
+ip_set_match_extensions(struct ip_set *set, const struct ip_set_ext *ext,
+			struct ip_set_ext *mext, u32 flags, void *data)
+{
+	if (SET_WITH_TIMEOUT(set) &&
+	    ip_set_timeout_expired(ext_timeout(data, set)))
+		return false;
+	if (SET_WITH_COUNTER(set)) {
+		struct ip_set_counter *counter = ext_counter(data, set);
+
+		if (flags & IPSET_FLAG_MATCH_COUNTERS &&
+		    !(ip_set_match_counter(ip_set_get_packets(counter),
+				mext->packets, mext->packets_op) &&
+		      ip_set_match_counter(ip_set_get_bytes(counter),
+				mext->bytes, mext->bytes_op)))
+			return false;
+		ip_set_update_counter(counter, ext, flags);
+	}
+	if (SET_WITH_SKBINFO(set))
+		ip_set_get_skbinfo(ext_skbinfo(data, set),
+				   ext, mext, flags);
+	return true;
+}
+EXPORT_SYMBOL_GPL(ip_set_match_extensions);
+
 /* Creating/destroying/renaming/swapping affect the existence and
  * the properties of a set. All of these can be executed from userspace
  * only and serialized by the nfnl mutex indirectly from nfnetlink.
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 8ef079d..bbad940 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -917,12 +917,9 @@ static inline int
 mtype_data_match(struct mtype_elem *data, const struct ip_set_ext *ext,
 		 struct ip_set_ext *mext, struct ip_set *set, u32 flags)
 {
-	if (SET_WITH_COUNTER(set))
-		ip_set_update_counter(ext_counter(data, set),
-				      ext, mext, flags);
-	if (SET_WITH_SKBINFO(set))
-		ip_set_get_skbinfo(ext_skbinfo(data, set),
-				   ext, mext, flags);
+	if (!ip_set_match_extensions(set, ext, mext, flags, data))
+		return 0;
+	/* nomatch entries return -ENOTEMPTY */
 	return mtype_do_data_match(data);
 }
 
@@ -941,9 +938,9 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 	struct mtype_elem *data;
 #if IPSET_NET_COUNT == 2
 	struct mtype_elem orig = *d;
-	int i, j = 0, k;
+	int ret, i, j = 0, k;
 #else
-	int i, j = 0;
+	int ret, i, j = 0;
 #endif
 	u32 key, multi = 0;
 
@@ -969,18 +966,13 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 			data = ahash_data(n, i, set->dsize);
 			if (!mtype_data_equal(data, d, &multi))
 				continue;
-			if (SET_WITH_TIMEOUT(set)) {
-				if (!ip_set_timeout_expired(
-						ext_timeout(data, set)))
-					return mtype_data_match(data, ext,
-								mext, set,
-								flags);
+			ret = mtype_data_match(data, ext, mext, set, flags);
+			if (ret != 0)
+				return ret;
 #ifdef IP_SET_HASH_WITH_MULTI
-				multi = 0;
+			/* No match, reset multiple match flag */
+			multi = 0;
 #endif
-			} else
-				return mtype_data_match(data, ext,
-							mext, set, flags);
 		}
 #if IPSET_NET_COUNT == 2
 		}
@@ -1027,12 +1019,11 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		if (!test_bit(i, n->used))
 			continue;
 		data = ahash_data(n, i, set->dsize);
-		if (mtype_data_equal(data, d, &multi) &&
-		    !(SET_WITH_TIMEOUT(set) &&
-		      ip_set_timeout_expired(ext_timeout(data, set)))) {
-			ret = mtype_data_match(data, ext, mext, set, flags);
+		if (!mtype_data_equal(data, d, &multi))
+			continue;
+		ret = mtype_data_match(data, ext, mext, set, flags);
+		if (ret != 0)
 			goto out;
-		}
 	}
 out:
 	return ret;
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index e864681..072a658 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -55,8 +55,9 @@ list_set_ktest(struct ip_set *set, const struct sk_buff *skb,
 	       struct ip_set_adt_opt *opt, const struct ip_set_ext *ext)
 {
 	struct list_set *map = set->data;
+	struct ip_set_ext *mext = &opt->ext;
 	struct set_elem *e;
-	u32 cmdflags = opt->cmdflags;
+	u32 flags = opt->cmdflags;
 	int ret;
 
 	/* Don't lookup sub-counters at all */
@@ -64,21 +65,11 @@ list_set_ktest(struct ip_set *set, const struct sk_buff *skb,
 	if (opt->cmdflags & IPSET_FLAG_SKIP_SUBCOUNTER_UPDATE)
 		opt->cmdflags &= ~IPSET_FLAG_SKIP_COUNTER_UPDATE;
 	list_for_each_entry_rcu(e, &map->members, list) {
-		if (SET_WITH_TIMEOUT(set) &&
-		    ip_set_timeout_expired(ext_timeout(e, set)))
-			continue;
 		ret = ip_set_test(e->id, skb, par, opt);
-		if (ret > 0) {
-			if (SET_WITH_COUNTER(set))
-				ip_set_update_counter(ext_counter(e, set),
-						      ext, &opt->ext,
-						      cmdflags);
-			if (SET_WITH_SKBINFO(set))
-				ip_set_get_skbinfo(ext_skbinfo(e, set),
-						   ext, &opt->ext,
-						   cmdflags);
-			return ret;
-		}
+		if (ret <= 0)
+			continue;
+		if (ip_set_match_extensions(set, ext, mext, flags, e))
+			return 1;
 	}
 	return 0;
 }
diff --git a/net/netfilter/xt_set.c b/net/netfilter/xt_set.c
index 6428570..16b6b11 100644
--- a/net/netfilter/xt_set.c
+++ b/net/netfilter/xt_set.c
@@ -39,13 +39,17 @@ match_set(ip_set_id_t index, const struct sk_buff *skb,
 	return inv;
 }
 
-#define ADT_OPT(n, f, d, fs, cfs, t)	\
-struct ip_set_adt_opt n = {		\
-	.family	= f,			\
-	.dim = d,			\
-	.flags = fs,			\
-	.cmdflags = cfs,		\
-	.ext.timeout = t,		\
+#define ADT_OPT(n, f, d, fs, cfs, t, p, b, po, bo)	\
+struct ip_set_adt_opt n = {				\
+	.family	= f,					\
+	.dim = d,					\
+	.flags = fs,					\
+	.cmdflags = cfs,				\
+	.ext.timeout = t,				\
+	.ext.packets = p,				\
+	.ext.bytes = b,					\
+	.ext.packets_op = po,				\
+	.ext.bytes_op = bo,				\
 }
 
 /* Revision 0 interface: backward compatible with netfilter/iptables */
@@ -56,7 +60,8 @@ set_match_v0(const struct sk_buff *skb, struct xt_action_param *par)
 	const struct xt_set_info_match_v0 *info = par->matchinfo;
 
 	ADT_OPT(opt, xt_family(par), info->match_set.u.compat.dim,
-		info->match_set.u.compat.flags, 0, UINT_MAX);
+		info->match_set.u.compat.flags, 0, UINT_MAX,
+		0, 0, 0, 0);
 
 	return match_set(info->match_set.index, skb, par, &opt,
 			 info->match_set.u.compat.flags & IPSET_INV_MATCH);
@@ -119,7 +124,8 @@ set_match_v1(const struct sk_buff *skb, struct xt_action_param *par)
 	const struct xt_set_info_match_v1 *info = par->matchinfo;
 
 	ADT_OPT(opt, xt_family(par), info->match_set.dim,
-		info->match_set.flags, 0, UINT_MAX);
+		info->match_set.flags, 0, UINT_MAX,
+		0, 0, 0, 0);
 
 	if (opt.flags & IPSET_RETURN_NOMATCH)
 		opt.cmdflags |= IPSET_FLAG_RETURN_NOMATCH;
@@ -161,45 +167,21 @@ set_match_v1_destroy(const struct xt_mtdtor_param *par)
 /* Revision 3 match */
 
 static bool
-match_counter0(u64 counter, const struct ip_set_counter_match0 *info)
-{
-	switch (info->op) {
-	case IPSET_COUNTER_NONE:
-		return true;
-	case IPSET_COUNTER_EQ:
-		return counter == info->value;
-	case IPSET_COUNTER_NE:
-		return counter != info->value;
-	case IPSET_COUNTER_LT:
-		return counter < info->value;
-	case IPSET_COUNTER_GT:
-		return counter > info->value;
-	}
-	return false;
-}
-
-static bool
 set_match_v3(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_set_info_match_v3 *info = par->matchinfo;
-	int ret;
 
 	ADT_OPT(opt, xt_family(par), info->match_set.dim,
-		info->match_set.flags, info->flags, UINT_MAX);
+		info->match_set.flags, info->flags, UINT_MAX,
+		info->packets.value, info->bytes.value,
+		info->packets.op, info->bytes.op);
 
 	if (info->packets.op != IPSET_COUNTER_NONE ||
 	    info->bytes.op != IPSET_COUNTER_NONE)
 		opt.cmdflags |= IPSET_FLAG_MATCH_COUNTERS;
 
-	ret = match_set(info->match_set.index, skb, par, &opt,
-			info->match_set.flags & IPSET_INV_MATCH);
-
-	if (!(ret && opt.cmdflags & IPSET_FLAG_MATCH_COUNTERS))
-		return ret;
-
-	if (!match_counter0(opt.ext.packets, &info->packets))
-		return false;
-	return match_counter0(opt.ext.bytes, &info->bytes);
+	return match_set(info->match_set.index, skb, par, &opt,
+			 info->match_set.flags & IPSET_INV_MATCH);
 }
 
 #define set_match_v3_checkentry	set_match_v1_checkentry
@@ -208,45 +190,21 @@ set_match_v3(const struct sk_buff *skb, struct xt_action_param *par)
 /* Revision 4 match */
 
 static bool
-match_counter(u64 counter, const struct ip_set_counter_match *info)
-{
-	switch (info->op) {
-	case IPSET_COUNTER_NONE:
-		return true;
-	case IPSET_COUNTER_EQ:
-		return counter == info->value;
-	case IPSET_COUNTER_NE:
-		return counter != info->value;
-	case IPSET_COUNTER_LT:
-		return counter < info->value;
-	case IPSET_COUNTER_GT:
-		return counter > info->value;
-	}
-	return false;
-}
-
-static bool
 set_match_v4(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_set_info_match_v4 *info = par->matchinfo;
-	int ret;
 
 	ADT_OPT(opt, xt_family(par), info->match_set.dim,
-		info->match_set.flags, info->flags, UINT_MAX);
+		info->match_set.flags, info->flags, UINT_MAX,
+		info->packets.value, info->bytes.value,
+		info->packets.op, info->bytes.op);
 
 	if (info->packets.op != IPSET_COUNTER_NONE ||
 	    info->bytes.op != IPSET_COUNTER_NONE)
 		opt.cmdflags |= IPSET_FLAG_MATCH_COUNTERS;
 
-	ret = match_set(info->match_set.index, skb, par, &opt,
-			info->match_set.flags & IPSET_INV_MATCH);
-
-	if (!(ret && opt.cmdflags & IPSET_FLAG_MATCH_COUNTERS))
-		return ret;
-
-	if (!match_counter(opt.ext.packets, &info->packets))
-		return false;
-	return match_counter(opt.ext.bytes, &info->bytes);
+	return match_set(info->match_set.index, skb, par, &opt,
+			 info->match_set.flags & IPSET_INV_MATCH);
 }
 
 #define set_match_v4_checkentry	set_match_v1_checkentry
@@ -260,9 +218,11 @@ set_target_v0(struct sk_buff *skb, const struct xt_action_param *par)
 	const struct xt_set_info_target_v0 *info = par->targinfo;
 
 	ADT_OPT(add_opt, xt_family(par), info->add_set.u.compat.dim,
-		info->add_set.u.compat.flags, 0, UINT_MAX);
+		info->add_set.u.compat.flags, 0, UINT_MAX,
+		0, 0, 0, 0);
 	ADT_OPT(del_opt, xt_family(par), info->del_set.u.compat.dim,
-		info->del_set.u.compat.flags, 0, UINT_MAX);
+		info->del_set.u.compat.flags, 0, UINT_MAX,
+		0, 0, 0, 0);
 
 	if (info->add_set.index != IPSET_INVALID_ID)
 		ip_set_add(info->add_set.index, skb, par, &add_opt);
@@ -333,9 +293,11 @@ set_target_v1(struct sk_buff *skb, const struct xt_action_param *par)
 	const struct xt_set_info_target_v1 *info = par->targinfo;
 
 	ADT_OPT(add_opt, xt_family(par), info->add_set.dim,
-		info->add_set.flags, 0, UINT_MAX);
+		info->add_set.flags, 0, UINT_MAX,
+		0, 0, 0, 0);
 	ADT_OPT(del_opt, xt_family(par), info->del_set.dim,
-		info->del_set.flags, 0, UINT_MAX);
+		info->del_set.flags, 0, UINT_MAX,
+		0, 0, 0, 0);
 
 	if (info->add_set.index != IPSET_INVALID_ID)
 		ip_set_add(info->add_set.index, skb, par, &add_opt);
@@ -402,9 +364,11 @@ set_target_v2(struct sk_buff *skb, const struct xt_action_param *par)
 	const struct xt_set_info_target_v2 *info = par->targinfo;
 
 	ADT_OPT(add_opt, xt_family(par), info->add_set.dim,
-		info->add_set.flags, info->flags, info->timeout);
+		info->add_set.flags, info->flags, info->timeout,
+		0, 0, 0, 0);
 	ADT_OPT(del_opt, xt_family(par), info->del_set.dim,
-		info->del_set.flags, 0, UINT_MAX);
+		info->del_set.flags, 0, UINT_MAX,
+		0, 0, 0, 0);
 
 	/* Normalize to fit into jiffies */
 	if (add_opt.ext.timeout != IPSET_NO_TIMEOUT &&
@@ -432,11 +396,14 @@ set_target_v3(struct sk_buff *skb, const struct xt_action_param *par)
 	int ret;
 
 	ADT_OPT(add_opt, xt_family(par), info->add_set.dim,
-		info->add_set.flags, info->flags, info->timeout);
+		info->add_set.flags, info->flags, info->timeout,
+		0, 0, 0, 0);
 	ADT_OPT(del_opt, xt_family(par), info->del_set.dim,
-		info->del_set.flags, 0, UINT_MAX);
+		info->del_set.flags, 0, UINT_MAX,
+		0, 0, 0, 0);
 	ADT_OPT(map_opt, xt_family(par), info->map_set.dim,
-		info->map_set.flags, 0, UINT_MAX);
+		info->map_set.flags, 0, UINT_MAX,
+		0, 0, 0, 0);
 
 	/* Normalize to fit into jiffies */
 	if (add_opt.ext.timeout != IPSET_NO_TIMEOUT &&
-- 
2.1.4

