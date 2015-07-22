From: Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH nf-next v3 2/3] netfilter: nf_conntrack: add direction support for zones
Date: Wed, 22 Jul 2015 12:54:47 +0200
Message-ID: <338f336fc3feb79b2a4ceb9756ae38b1d082a00d.1437561897.git.daniel@iogearbox.net>
References: <cover.1437561897.git.daniel@iogearbox.net>
Cc: tgraf@suug.ch, challa@noironetworks.com,
	netfilter-devel@vger.kernel.org,
	Daniel Borkmann <daniel@iogearbox.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:41628 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933776AbbGVKyy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jul 2015 06:54:54 -0400
In-Reply-To: <cover.1437561897.git.daniel@iogearbox.net>
In-Reply-To: <cover.1437561897.git.daniel@iogearbox.net>
References: <cover.1437561897.git.daniel@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This work adds a direction parameter to netfilter zones, so identity
separation can be performed only in original/reply or both directions
(default). This basically opens up the possibility of doing NAT with
conflicting IP address/port tuples from multiple, isolated tenants
on a host (e.g. from a netns) without requiring each tenant to NAT
twice resp. to use its own dedicated IP address to SNAT to, meaning
overlapping tuples can be made unique with the zone identifier in
original direction, where the NAT engine will then allocate a unique
tuple in the commonly shared default zone for the reply direction.
In some restricted, local DNAT cases, also port redirection could be
used for making the reply traffic unique w/o requiring SNAT.

The consensus we've reached and discussed at NFWS and since the initial
implementation [1] was to directly integrate the direction meta data
into the existing zones infrastructure, as opposed to the ct->mark
approach we proposed initially.

As we pass the nf_conntrack_zone object directly around, we don't have
to touch all call-sites, but only those, that contain equality checks
of zones. Thus, based on the current direction (original or reply),
we either return the actual id, or the default NF_CT_DEFAULT_ZONE_ID.
CT expectations are direction-agnostic entities when expectations are
being compared among themselves, so we can only used the identifier
in this case.

Note that zone identifiers can not be included into the hash mix
anymore as they don't contain a "stable" value that would be equal
for both directions at all times, f.e. if only zone->id would
unconditionally be xor'ed into the table slot hash, then replies won't
find the corresponding conntracking entry anymore.

If no particular direction is specified when configuring zones, the
behaviour is exactly as we expect currently (both directions).

Support has been added for the CT netlink interface as well as the
x_tables raw CT target, which both already offer existing interfaces
to user space for the configuration of zones.

Below a minimal, simplified collision example (script in [2]) with
netperf sessions:

  +--- tenant-1 ---+   mark := 1
  |    netperf     |--+
  +----------------+  |                CT zone := mark [ORIGINAL]
   [ip,sport] := X   +--------------+  +--- gateway ---+
                     | mark routing |--|     SNAT      |-- ... +
                     +--------------+  +---------------+       |
  +--- tenant-2 ---+  |                                     ~~~|~~~
  |    netperf     |--+                +-----------+           |
  +----------------+   mark := 2       | netserver |------ ... +
   [ip,sport] := X                     +-----------+
                                        [ip,port] := Y
On the gateway netns, example:

  iptables -t raw -A PREROUTING -j CT --zone mark --zone-dir ORIGINAL
  iptables -t nat -A POSTROUTING -o <dev> -j SNAT --to-source <ip> --random-fully

  iptables -t mangle -A PREROUTING -m conntrack --ctdir ORIGINAL -j CONNMARK --save-mark
  iptables -t mangle -A POSTROUTING -m conntrack --ctdir REPLY -j CONNMARK --restore-mark

conntrack -L from gateway netns:

  netperf -H 10.1.1.2 -t TCP_STREAM -l60 -p12865,5555 from each tenant netns

  tcp 6 431995 ESTABLISHED src=40.1.1.1 dst=10.1.1.2 sport=5555 dport=12865
                           src=10.1.1.2 dst=10.1.1.1 sport=12865 dport=1024
               [ASSURED] mark=1 secctx=system_u:object_r:unlabeled_t:s0
                         zone=1 use=1 zone-dir=original

  tcp 6 431994 ESTABLISHED src=40.1.1.1 dst=10.1.1.2 sport=5555 dport=12865
                           src=10.1.1.2 dst=10.1.1.1 sport=12865 dport=5555
               [ASSURED] mark=2 secctx=system_u:object_r:unlabeled_t:s0
                         zone=2 use=1 zone-dir=original

  tcp 6 299 ESTABLISHED src=40.1.1.1 dst=10.1.1.2 sport=39438 dport=33768
                        src=10.1.1.2 dst=10.1.1.1 sport=33768 dport=39438
               [ASSURED] mark=1 secctx=system_u:object_r:unlabeled_t:s0
                         zone=1 use=1 zone-dir=original

  tcp 6 300 ESTABLISHED src=40.1.1.1 dst=10.1.1.2 sport=32889 dport=40206
                        src=10.1.1.2 dst=10.1.1.1 sport=40206 dport=32889
               [ASSURED] mark=2 secctx=system_u:object_r:unlabeled_t:s0
                         zone=2 use=2 zone-dir=original

Taking this further, test script in [2] creates 200 tenants and runs
original-tuple colliding netperf sessions each. A conntrack -L dump in
the gateway netns also confirms 200 overlapping entries, all in ESTABLISHED
state as expected.

I also did run various other tests with some permutations of the script,
to mention some: SNAT in random/random-fully/persistent mode, no zones (no
overlaps), static zones (original, reply, both directions), etc.

  [1] http://thread.gmane.org/gmane.comp.security.firewalls.netfilter.devel/57412/
  [2] https://paste.fedoraproject.org/242835/65657871/

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 include/net/netfilter/nf_conntrack_zones.h         | 30 +++++++++-
 include/uapi/linux/netfilter/nfnetlink_conntrack.h |  9 +++
 include/uapi/linux/netfilter/xt_CT.h               |  6 +-
 net/ipv4/netfilter/nf_defrag_ipv4.c                |  8 ++-
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c          |  8 ++-
 net/netfilter/nf_conntrack_core.c                  | 52 +++++++++---------
 net/netfilter/nf_conntrack_expect.c                |  6 +-
 net/netfilter/nf_conntrack_netlink.c               | 64 ++++++++++++++++++----
 net/netfilter/nf_conntrack_standalone.c            |  9 ++-
 net/netfilter/nf_nat_core.c                        | 13 ++---
 net/netfilter/xt_CT.c                              | 16 +++++-
 net/sched/act_connmark.c                           |  1 +
 12 files changed, 167 insertions(+), 55 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_zones.h b/include/net/netfilter/nf_conntrack_zones.h
index 0788bb0..bef0539 100644
--- a/include/net/netfilter/nf_conntrack_zones.h
+++ b/include/net/netfilter/nf_conntrack_zones.h
@@ -1,10 +1,17 @@
 #ifndef _NF_CONNTRACK_ZONES_H
 #define _NF_CONNTRACK_ZONES_H
 
+#include <linux/netfilter/nf_conntrack_tuple_common.h>
+
 #define NF_CT_DEFAULT_ZONE_ID	0
 
+#define NF_CT_ORIG_DIR		(1 << IP_CT_DIR_ORIGINAL)
+#define NF_CT_REPL_DIR		(1 << IP_CT_DIR_REPLY)
+#define NF_CT_DEFAULT_DIR	(NF_CT_ORIG_DIR | NF_CT_REPL_DIR)
+
 struct nf_conntrack_zone {
 	u16	id;
+	u16	dir;
 };
 
 extern const struct nf_conntrack_zone nf_ct_zone_dflt;
@@ -29,8 +36,29 @@ nf_ct_zone_tmpl(const struct nf_conn *tmpl)
 	return tmpl ? nf_ct_zone(tmpl) : &nf_ct_zone_dflt;
 }
 
+static inline bool nf_ct_zone_matches_dir(const struct nf_conntrack_zone *zone,
+					  enum ip_conntrack_dir dir)
+{
+	return zone->dir & (1 << dir);
+}
+
+static inline u16 nf_ct_zone_id(const struct nf_conntrack_zone *zone,
+				enum ip_conntrack_dir dir)
+{
+	return nf_ct_zone_matches_dir(zone, dir) ?
+	       zone->id : NF_CT_DEFAULT_ZONE_ID;
+}
+
 static inline bool nf_ct_zone_equal(const struct nf_conn *a,
-				    const struct nf_conntrack_zone *b)
+				    const struct nf_conntrack_zone *b,
+				    enum ip_conntrack_dir dir)
+{
+	return nf_ct_zone_id(nf_ct_zone(a), dir) ==
+	       nf_ct_zone_id(b, dir);
+}
+
+static inline bool nf_ct_zone_equal_any(const struct nf_conn *a,
+					const struct nf_conntrack_zone *b)
 {
 	return nf_ct_zone(a)->id == b->id;
 }
diff --git a/include/uapi/linux/netfilter/nfnetlink_conntrack.h b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
index acad6c5..95841a5 100644
--- a/include/uapi/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
@@ -53,6 +53,7 @@ enum ctattr_type {
 	CTA_MARK_MASK,
 	CTA_LABELS,
 	CTA_LABELS_MASK,
+	CTA_DIR,
 	__CTA_MAX
 };
 #define CTA_MAX (__CTA_MAX - 1)
@@ -260,4 +261,12 @@ enum ctattr_expect_stats {
 };
 #define CTA_STATS_EXP_MAX (__CTA_STATS_EXP_MAX - 1)
 
+enum ctattr_dir {
+	CTA_DIR_UNSPEC,
+	CTA_DIR_ORIG,
+	CTA_DIR_REPL,
+	__CTA_DIR_MAX
+};
+#define CTA_DIR_MAX (__CTA_DIR_MAX - 1)
+
 #endif /* _IPCONNTRACK_NETLINK_H */
diff --git a/include/uapi/linux/netfilter/xt_CT.h b/include/uapi/linux/netfilter/xt_CT.h
index 5a688c1..452005f 100644
--- a/include/uapi/linux/netfilter/xt_CT.h
+++ b/include/uapi/linux/netfilter/xt_CT.h
@@ -6,7 +6,11 @@
 enum {
 	XT_CT_NOTRACK		= 1 << 0,
 	XT_CT_NOTRACK_ALIAS	= 1 << 1,
-	XT_CT_MASK		= XT_CT_NOTRACK | XT_CT_NOTRACK_ALIAS,
+	XT_CT_ZONE_DIR_ORIG	= 1 << 2,
+	XT_CT_ZONE_DIR_REPL	= 1 << 3,
+
+	XT_CT_MASK		= XT_CT_NOTRACK | XT_CT_NOTRACK_ALIAS |
+				  XT_CT_ZONE_DIR_ORIG | XT_CT_ZONE_DIR_REPL,
 };
 
 struct xt_ct_target_info {
diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
index ad0501a..5fdd6f6 100644
--- a/net/ipv4/netfilter/nf_defrag_ipv4.c
+++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
@@ -45,8 +45,12 @@ static enum ip_defrag_users nf_ct_defrag_user(unsigned int hooknum,
 {
 	u16 zone_id = NF_CT_DEFAULT_ZONE_ID;
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
-	if (skb->nfct)
-		zone_id = nf_ct_zone((struct nf_conn *)skb->nfct)->id;
+	if (skb->nfct) {
+		enum ip_conntrack_info ctinfo;
+		const struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
+
+		zone_id = nf_ct_zone_id(nf_ct_zone(ct), CTINFO2DIR(ctinfo));
+	}
 #endif
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	if (skb->nf_bridge &&
diff --git a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
index 1749500..f623f06 100644
--- a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
+++ b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
@@ -35,8 +35,12 @@ static enum ip6_defrag_users nf_ct6_defrag_user(unsigned int hooknum,
 {
 	u16 zone_id = NF_CT_DEFAULT_ZONE_ID;
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
-	if (skb->nfct)
-		zone_id = nf_ct_zone((struct nf_conn *)skb->nfct)->id;
+	if (skb->nfct) {
+		enum ip_conntrack_info ctinfo;
+		const struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
+
+		zone_id = nf_ct_zone_id(nf_ct_zone(ct), CTINFO2DIR(ctinfo));
+	}
 #endif
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	if (skb->nf_bridge &&
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 9a04062..8f8e842 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -126,8 +126,7 @@ EXPORT_PER_CPU_SYMBOL(nf_conntrack_untracked);
 unsigned int nf_conntrack_hash_rnd __read_mostly;
 EXPORT_SYMBOL_GPL(nf_conntrack_hash_rnd);
 
-static u32 hash_conntrack_raw(const struct nf_conntrack_tuple *tuple,
-			      const struct nf_conntrack_zone *zone)
+static u32 hash_conntrack_raw(const struct nf_conntrack_tuple *tuple)
 {
 	unsigned int n;
 
@@ -136,7 +135,7 @@ static u32 hash_conntrack_raw(const struct nf_conntrack_tuple *tuple,
 	 * three bytes manually.
 	 */
 	n = (sizeof(tuple->src) + sizeof(tuple->dst.u3)) / sizeof(u32);
-	return jhash2((u32 *)tuple, n, zone->id ^ nf_conntrack_hash_rnd ^
+	return jhash2((u32 *)tuple, n, nf_conntrack_hash_rnd ^
 		      (((__force __u16)tuple->dst.u.all << 16) |
 		      tuple->dst.protonum));
 }
@@ -152,17 +151,15 @@ static u32 hash_bucket(u32 hash, const struct net *net)
 }
 
 static u_int32_t __hash_conntrack(const struct nf_conntrack_tuple *tuple,
-				  const struct nf_conntrack_zone *zone,
 				  unsigned int size)
 {
-	return __hash_bucket(hash_conntrack_raw(tuple, zone), size);
+	return __hash_bucket(hash_conntrack_raw(tuple), size);
 }
 
 static inline u_int32_t hash_conntrack(const struct net *net,
-				       const struct nf_conntrack_zone *zone,
 				       const struct nf_conntrack_tuple *tuple)
 {
-	return __hash_conntrack(tuple, zone, net->ct.htable_size);
+	return __hash_conntrack(tuple, net->ct.htable_size);
 }
 
 bool
@@ -330,20 +327,18 @@ destroy_conntrack(struct nf_conntrack *nfct)
 
 static void nf_ct_delete_from_lists(struct nf_conn *ct)
 {
-	const struct nf_conntrack_zone *zone;
 	struct net *net = nf_ct_net(ct);
 	unsigned int hash, reply_hash;
 	unsigned int sequence;
 
-	zone = nf_ct_zone(ct);
 	nf_ct_helper_destroy(ct);
 
 	local_bh_disable();
 	do {
 		sequence = read_seqcount_begin(&net->ct.generation);
-		hash = hash_conntrack(net, zone,
+		hash = hash_conntrack(net,
 				      &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
-		reply_hash = hash_conntrack(net, zone,
+		reply_hash = hash_conntrack(net,
 					   &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 	} while (nf_conntrack_double_lock(net, hash, reply_hash, sequence));
 
@@ -400,7 +395,7 @@ nf_ct_key_equal(struct nf_conntrack_tuple_hash *h,
 	 * so we need to check that the conntrack is confirmed
 	 */
 	return nf_ct_tuple_equal(tuple, &h->tuple) &&
-	       nf_ct_zone_equal(ct, zone) &&
+	       nf_ct_zone_equal(ct, zone, NF_CT_DIRECTION(h)) &&
 	       nf_ct_is_confirmed(ct);
 }
 
@@ -477,7 +472,7 @@ nf_conntrack_find_get(struct net *net, const struct nf_conntrack_zone *zone,
 		      const struct nf_conntrack_tuple *tuple)
 {
 	return __nf_conntrack_find_get(net, zone, tuple,
-				       hash_conntrack_raw(tuple, zone));
+				       hash_conntrack_raw(tuple));
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_find_get);
 
@@ -508,9 +503,9 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 	local_bh_disable();
 	do {
 		sequence = read_seqcount_begin(&net->ct.generation);
-		hash = hash_conntrack(net, zone,
+		hash = hash_conntrack(net,
 				      &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
-		reply_hash = hash_conntrack(net, zone,
+		reply_hash = hash_conntrack(net,
 					   &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 	} while (nf_conntrack_double_lock(net, hash, reply_hash, sequence));
 
@@ -518,12 +513,14 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 	hlist_nulls_for_each_entry(h, n, &net->ct.hash[hash], hnnode)
 		if (nf_ct_tuple_equal(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
 				      &h->tuple) &&
-		    nf_ct_zone_equal(nf_ct_tuplehash_to_ctrack(h), zone))
+		    nf_ct_zone_equal(nf_ct_tuplehash_to_ctrack(h), zone,
+				     NF_CT_DIRECTION(h)))
 			goto out;
 	hlist_nulls_for_each_entry(h, n, &net->ct.hash[reply_hash], hnnode)
 		if (nf_ct_tuple_equal(&ct->tuplehash[IP_CT_DIR_REPLY].tuple,
 				      &h->tuple) &&
-		    nf_ct_zone_equal(nf_ct_tuplehash_to_ctrack(h), zone))
+		    nf_ct_zone_equal(nf_ct_tuplehash_to_ctrack(h), zone,
+				     NF_CT_DIRECTION(h)))
 			goto out;
 
 	add_timer(&ct->timeout);
@@ -599,7 +596,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 		/* reuse the hash saved before */
 		hash = *(unsigned long *)&ct->tuplehash[IP_CT_DIR_REPLY].hnnode.pprev;
 		hash = hash_bucket(hash, net);
-		reply_hash = hash_conntrack(net, zone,
+		reply_hash = hash_conntrack(net,
 					   &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 
 	} while (nf_conntrack_double_lock(net, hash, reply_hash, sequence));
@@ -631,12 +628,14 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	hlist_nulls_for_each_entry(h, n, &net->ct.hash[hash], hnnode)
 		if (nf_ct_tuple_equal(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
 				      &h->tuple) &&
-		    nf_ct_zone_equal(nf_ct_tuplehash_to_ctrack(h), zone))
+		    nf_ct_zone_equal(nf_ct_tuplehash_to_ctrack(h), zone,
+				     NF_CT_DIRECTION(h)))
 			goto out;
 	hlist_nulls_for_each_entry(h, n, &net->ct.hash[reply_hash], hnnode)
 		if (nf_ct_tuple_equal(&ct->tuplehash[IP_CT_DIR_REPLY].tuple,
 				      &h->tuple) &&
-		    nf_ct_zone_equal(nf_ct_tuplehash_to_ctrack(h), zone))
+		    nf_ct_zone_equal(nf_ct_tuplehash_to_ctrack(h), zone,
+				     NF_CT_DIRECTION(h)))
 			goto out;
 
 	/* Timer relative to confirmation time, not original
@@ -696,7 +695,7 @@ nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
 	unsigned int hash;
 
 	zone = nf_ct_zone(ignored_conntrack);
-	hash = hash_conntrack(net, zone, tuple);
+	hash = hash_conntrack(net, tuple);
 
 	/* Disable BHs the entire time since we need to disable them at
 	 * least once for the stats anyway.
@@ -706,7 +705,7 @@ nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
 		ct = nf_ct_tuplehash_to_ctrack(h);
 		if (ct != ignored_conntrack &&
 		    nf_ct_tuple_equal(tuple, &h->tuple) &&
-		    nf_ct_zone_equal(ct, zone)) {
+		    nf_ct_zone_equal(ct, zone, NF_CT_DIRECTION(h))) {
 			NF_CT_STAT_INC(net, found);
 			rcu_read_unlock_bh();
 			return 1;
@@ -806,7 +805,7 @@ __nf_conntrack_alloc(struct net *net,
 	if (unlikely(!nf_conntrack_hash_rnd)) {
 		init_nf_conntrack_hash_rnd();
 		/* recompute the hash as nf_conntrack_hash_rnd is initialized */
-		hash = hash_conntrack_raw(orig, zone);
+		hash = hash_conntrack_raw(orig);
 	}
 
 	/* We don't want any race condition at early drop stage */
@@ -851,6 +850,7 @@ __nf_conntrack_alloc(struct net *net,
 		if (!nf_ct_zone)
 			goto out_free;
 		nf_ct_zone->id = zone->id;
+		nf_ct_zone->dir = zone->dir;
 	}
 #endif
 	/* Because we use RCU lookups, we set ct_general.use to zero before
@@ -1029,7 +1029,7 @@ resolve_normal_ct(struct net *net, struct nf_conn *tmpl,
 
 	/* look for tuple match */
 	zone = nf_ct_zone_tmpl(tmpl);
-	hash = hash_conntrack_raw(&tuple, zone);
+	hash = hash_conntrack_raw(&tuple);
 	h = __nf_conntrack_find_get(net, zone, &tuple, hash);
 	if (!h) {
 		h = init_conntrack(net, tmpl, &tuple, l3proto, l4proto,
@@ -1282,6 +1282,7 @@ EXPORT_SYMBOL_GPL(__nf_ct_kill_acct);
 /* Built-in default zone used e.g. by modules. */
 const struct nf_conntrack_zone nf_ct_zone_dflt = {
 	.id	= NF_CT_DEFAULT_ZONE_ID,
+	.dir	= NF_CT_DEFAULT_DIR,
 };
 EXPORT_SYMBOL_GPL(nf_ct_zone_dflt);
 
@@ -1593,8 +1594,7 @@ int nf_conntrack_set_hashsize(const char *val, struct kernel_param *kp)
 					struct nf_conntrack_tuple_hash, hnnode);
 			ct = nf_ct_tuplehash_to_ctrack(h);
 			hlist_nulls_del_rcu(&h->hnnode);
-			bucket = __hash_conntrack(&h->tuple, nf_ct_zone(ct),
-						  hashsize);
+			bucket = __hash_conntrack(&h->tuple, hashsize);
 			hlist_nulls_add_head_rcu(&h->hnnode, &hash[bucket]);
 		}
 	}
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 4abee59..f20f30e 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -101,7 +101,7 @@ __nf_ct_expect_find(struct net *net,
 	h = nf_ct_expect_dst_hash(tuple);
 	hlist_for_each_entry_rcu(i, &net->ct.expect_hash[h], hnode) {
 		if (nf_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask) &&
-		    nf_ct_zone_equal(i->master, zone))
+		    nf_ct_zone_equal_any(i->master, zone))
 			return i;
 	}
 	return NULL;
@@ -143,7 +143,7 @@ nf_ct_find_expectation(struct net *net,
 	hlist_for_each_entry(i, &net->ct.expect_hash[h], hnode) {
 		if (!(i->flags & NF_CT_EXPECT_INACTIVE) &&
 		    nf_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask) &&
-		    nf_ct_zone_equal(i->master, zone)) {
+		    nf_ct_zone_equal_any(i->master, zone)) {
 			exp = i;
 			break;
 		}
@@ -231,7 +231,7 @@ static inline int expect_matches(const struct nf_conntrack_expect *a,
 	return a->master == b->master && a->class == b->class &&
 	       nf_ct_tuple_equal(&a->tuple, &b->tuple) &&
 	       nf_ct_tuple_mask_equal(&a->mask, &b->mask) &&
-	       nf_ct_zone_equal(a->master, nf_ct_zone(b->master));
+	       nf_ct_zone_equal_any(a->master, nf_ct_zone(b->master));
 }
 
 /* Generally a bad idea to call this: could have matched already. */
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 86fbe4b..0d389ec 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -454,6 +454,32 @@ nla_put_failure:
 	return -1;
 }
 
+#ifdef CONFIG_NF_CONNTRACK_ZONES
+static u16 ctnetlink_to_dir(u8 ctn_dir)
+{
+	switch (ctn_dir) {
+	case CTA_DIR_ORIG:
+		return NF_CT_ORIG_DIR;
+	case CTA_DIR_REPL:
+		return NF_CT_REPL_DIR;
+	default:
+		return NF_CT_DEFAULT_DIR;
+	}
+}
+#endif
+
+static u8 ctnetlink_from_dir(u16 dir)
+{
+	switch (dir) {
+	case NF_CT_ORIG_DIR:
+		return CTA_DIR_ORIG;
+	case NF_CT_REPL_DIR:
+		return CTA_DIR_REPL;
+	default:
+		return CTA_DIR_UNSPEC;
+	}
+}
+
 static int
 ctnetlink_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 		    struct nf_conn *ct)
@@ -492,6 +518,9 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	if (zone->id != NF_CT_DEFAULT_ZONE_ID &&
 	    nla_put_be16(skb, CTA_ZONE, htons(zone->id)))
 		goto nla_put_failure;
+	if (zone->dir != NF_CT_DEFAULT_DIR &&
+	    nla_put_u8(skb, CTA_DIR, ctnetlink_from_dir(zone->dir)))
+		goto nla_put_failure;
 
 	if (ctnetlink_dump_status(skb, ct) < 0 ||
 	    ctnetlink_dump_timeout(skb, ct) < 0 ||
@@ -601,6 +630,7 @@ ctnetlink_nlmsg_size(const struct nf_conn *ct)
 #endif
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 	       + nla_total_size(sizeof(u_int16_t)) /* CTA_ZONE */
+	       + nla_total_size(sizeof(u_int8_t)) /* CTA_DIR */
 #endif
 	       + ctnetlink_proto_size(ct)
 	       + ctnetlink_label_size(ct)
@@ -676,6 +706,9 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 	if (zone->id != NF_CT_DEFAULT_ZONE_ID &&
 	    nla_put_be16(skb, CTA_ZONE, htons(zone->id)))
 		goto nla_put_failure;
+	if (zone->dir != NF_CT_DEFAULT_DIR &&
+	    nla_put_u8(skb, CTA_DIR, ctnetlink_from_dir(zone->dir)))
+		goto nla_put_failure;
 
 	if (ctnetlink_dump_id(skb, ct) < 0)
 		goto nla_put_failure;
@@ -969,16 +1002,20 @@ ctnetlink_parse_tuple(const struct nlattr * const cda[],
 }
 
 static int
-ctnetlink_parse_zone(const struct nlattr *attr,
+ctnetlink_parse_zone(const struct nlattr *zattr,
+		     const struct nlattr *dattr,
 		     struct nf_conntrack_zone *zone)
 {
 	zone->id = NF_CT_DEFAULT_ZONE_ID;
+	zone->dir = NF_CT_DEFAULT_DIR;
 
 #ifdef CONFIG_NF_CONNTRACK_ZONES
-	if (attr)
-		zone->id = ntohs(nla_get_be16(attr));
+	if (zattr)
+		zone->id = ntohs(nla_get_be16(zattr));
+	if (dattr)
+		zone->dir = ctnetlink_to_dir(nla_get_u8(dattr));
 #else
-	if (attr)
+	if (zattr || dattr)
 		return -EOPNOTSUPP;
 #endif
 	return 0;
@@ -1026,6 +1063,7 @@ static const struct nla_policy ct_nla_policy[CTA_MAX+1] = {
 	[CTA_NAT_SEQ_ADJ_ORIG]  = { .type = NLA_NESTED },
 	[CTA_NAT_SEQ_ADJ_REPLY] = { .type = NLA_NESTED },
 	[CTA_ZONE]		= { .type = NLA_U16 },
+	[CTA_DIR]		= { .type = NLA_U8 },
 	[CTA_MARK_MASK]		= { .type = NLA_U32 },
 	[CTA_LABELS]		= { .type = NLA_BINARY,
 				    .len = NF_CT_LABELS_MAX_SIZE },
@@ -1066,7 +1104,7 @@ ctnetlink_del_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	struct nf_conntrack_zone zone;
 	int err;
 
-	err = ctnetlink_parse_zone(cda[CTA_ZONE], &zone);
+	err = ctnetlink_parse_zone(cda[CTA_ZONE], cda[CTA_DIR], &zone);
 	if (err < 0)
 		return err;
 
@@ -1138,7 +1176,7 @@ ctnetlink_get_conntrack(struct sock *ctnl, struct sk_buff *skb,
 		return netlink_dump_start(ctnl, skb, nlh, &c);
 	}
 
-	err = ctnetlink_parse_zone(cda[CTA_ZONE], &zone);
+	err = ctnetlink_parse_zone(cda[CTA_ZONE], cda[CTA_DIR], &zone);
 	if (err < 0)
 		return err;
 
@@ -1813,7 +1851,7 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	struct nf_conntrack_zone zone;
 	int err;
 
-	err = ctnetlink_parse_zone(cda[CTA_ZONE], &zone);
+	err = ctnetlink_parse_zone(cda[CTA_ZONE], cda[CTA_DIR], &zone);
 	if (err < 0)
 		return err;
 
@@ -2089,6 +2127,7 @@ ctnetlink_nfqueue_build_size(const struct nf_conn *ct)
 #endif
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 	       + nla_total_size(sizeof(u_int16_t)) /* CTA_ZONE */
+	       + nla_total_size(sizeof(u_int8_t)) /* CTA_DIR */
 #endif
 	       + ctnetlink_proto_size(ct)
 	       ;
@@ -2119,6 +2158,9 @@ ctnetlink_nfqueue_build(struct sk_buff *skb, struct nf_conn *ct)
 	if (zone->id != NF_CT_DEFAULT_ZONE_ID &&
 	    nla_put_be16(skb, CTA_ZONE, htons(zone->id)))
 		goto nla_put_failure;
+	if (zone->dir != NF_CT_DEFAULT_DIR &&
+	    nla_put_u8(skb, CTA_DIR, ctnetlink_from_dir(zone->dir)))
+		goto nla_put_failure;
 
 	if (ctnetlink_dump_id(skb, ct) < 0)
 		goto nla_put_failure;
@@ -2629,7 +2671,7 @@ static int ctnetlink_dump_exp_ct(struct sock *ctnl, struct sk_buff *skb,
 	if (err < 0)
 		return err;
 
-	err = ctnetlink_parse_zone(cda[CTA_EXPECT_ZONE], &zone);
+	err = ctnetlink_parse_zone(cda[CTA_EXPECT_ZONE], NULL, &zone);
 	if (err < 0)
 		return err;
 
@@ -2672,7 +2714,7 @@ ctnetlink_get_expect(struct sock *ctnl, struct sk_buff *skb,
 		}
 	}
 
-	err = ctnetlink_parse_zone(cda[CTA_EXPECT_ZONE], &zone);
+	err = ctnetlink_parse_zone(cda[CTA_EXPECT_ZONE], NULL, &zone);
 	if (err < 0)
 		return err;
 
@@ -2743,7 +2785,7 @@ ctnetlink_del_expect(struct sock *ctnl, struct sk_buff *skb,
 
 	if (cda[CTA_EXPECT_TUPLE]) {
 		/* delete a single expect by tuple */
-		err = ctnetlink_parse_zone(cda[CTA_EXPECT_ZONE], &zone);
+		err = ctnetlink_parse_zone(cda[CTA_EXPECT_ZONE], NULL, &zone);
 		if (err < 0)
 			return err;
 
@@ -3030,7 +3072,7 @@ ctnetlink_new_expect(struct sock *ctnl, struct sk_buff *skb,
 	    || !cda[CTA_EXPECT_MASTER])
 		return -EINVAL;
 
-	err = ctnetlink_parse_zone(cda[CTA_EXPECT_ZONE], &zone);
+	err = ctnetlink_parse_zone(cda[CTA_EXPECT_ZONE], NULL, &zone);
 	if (err < 0)
 		return err;
 
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 28c8b2b..b214e91 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -143,7 +143,14 @@ static inline void ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 static void ct_show_zone(struct seq_file *s, const struct nf_conn *ct)
 {
-	seq_printf(s, "zone=%u ", nf_ct_zone(ct)->id);
+	const struct nf_conntrack_zone *zone = nf_ct_zone(ct);
+	static const char * const dir_name[] = {
+		[NF_CT_ORIG_DIR]	= "original",
+		[NF_CT_REPL_DIR]	= "reply",
+		[NF_CT_DEFAULT_DIR]	= "both",
+	};
+
+	seq_printf(s, "zone=%u zone-dir=%s ", zone->id, dir_name[zone->dir]);
 }
 #else
 static inline void ct_show_zone(struct seq_file *s, const struct nf_conn *ct)
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 65ebaf9..5113dfd 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -118,15 +118,13 @@ EXPORT_SYMBOL(nf_xfrm_me_harder);
 
 /* We keep an extra hash for each conntrack, for fast searching. */
 static inline unsigned int
-hash_by_src(const struct net *net,
-	    const struct nf_conntrack_zone *zone,
-	    const struct nf_conntrack_tuple *tuple)
+hash_by_src(const struct net *net, const struct nf_conntrack_tuple *tuple)
 {
 	unsigned int hash;
 
 	/* Original src, to ensure we map it consistently if poss. */
 	hash = jhash2((u32 *)&tuple->src, sizeof(tuple->src) / sizeof(u32),
-		      tuple->dst.protonum ^ zone->id ^ nf_conntrack_hash_rnd);
+		      tuple->dst.protonum ^ nf_conntrack_hash_rnd);
 
 	return reciprocal_scale(hash, net->ct.nat_htable_size);
 }
@@ -194,13 +192,14 @@ find_appropriate_src(struct net *net,
 		     struct nf_conntrack_tuple *result,
 		     const struct nf_nat_range *range)
 {
-	unsigned int h = hash_by_src(net, zone, tuple);
+	unsigned int h = hash_by_src(net, tuple);
 	const struct nf_conn_nat *nat;
 	const struct nf_conn *ct;
 
 	hlist_for_each_entry_rcu(nat, &net->ct.nat_bysource[h], bysource) {
 		ct = nat->ct;
-		if (same_src(ct, tuple) && nf_ct_zone_equal(ct, zone)) {
+		if (same_src(ct, tuple) &&
+		    nf_ct_zone_equal(ct, zone, IP_CT_DIR_ORIGINAL)) {
 			/* Copy source part from reply tuple. */
 			nf_ct_invert_tuplepr(result,
 				       &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
@@ -425,7 +424,7 @@ nf_nat_setup_info(struct nf_conn *ct,
 	if (maniptype == NF_NAT_MANIP_SRC) {
 		unsigned int srchash;
 
-		srchash = hash_by_src(net, nf_ct_zone(ct),
+		srchash = hash_by_src(net,
 				      &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 		spin_lock_bh(&nf_nat_lock);
 		/* nf_conntrack_alter_reply might re-allocate extension aera */
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index e2d7b55..8646075 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -181,6 +181,18 @@ out:
 #endif
 }
 
+static u16 xt_ct_flags_to_dir(const struct xt_ct_target_info_v1 *info)
+{
+	switch (info->flags & (XT_CT_ZONE_DIR_ORIG | XT_CT_ZONE_DIR_REPL)) {
+	case XT_CT_ZONE_DIR_ORIG:
+		return NF_CT_ORIG_DIR;
+	case XT_CT_ZONE_DIR_REPL:
+		return NF_CT_REPL_DIR;
+	default:
+		return NF_CT_DEFAULT_DIR;
+	}
+}
+
 static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 			  struct xt_ct_target_info_v1 *info)
 {
@@ -195,7 +207,8 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 	}
 
 #ifndef CONFIG_NF_CONNTRACK_ZONES
-	if (info->zone)
+	if (info->zone || info->flags & (XT_CT_ZONE_DIR_ORIG |
+					 XT_CT_ZONE_DIR_REPL))
 		goto err1;
 #endif
 
@@ -205,6 +218,7 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 
 	memset(&t, 0, sizeof(t));
 	zone.id = info->zone;
+	zone.dir = xt_ct_flags_to_dir(info);
 
 	ct = nf_conntrack_alloc(par->net, &zone, &t, &t, GFP_KERNEL);
 	ret = PTR_ERR(ct);
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index e67a1bd..25dc890 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -72,6 +72,7 @@ static int tcf_connmark(struct sk_buff *skb, const struct tc_action *a,
 		goto out;
 
 	zone.id = ca->zone;
+	zone.dir = NF_CT_DEFAULT_DIR;
 
 	thash = nf_conntrack_find_get(dev_net(skb->dev), &zone, &tuple);
 	if (!thash)
-- 
1.9.3

