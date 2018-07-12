From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/2] ipv6: remove dependency of nf_defrag_ipv6 on ipv6 module
Date: Thu, 12 Jul 2018 16:35:46 +0200
Message-ID: <20180712143547.2194-1-fw@strlen.de>
Cc: <netdev@vger.kernel.org>, arnd@arndb.de,
        Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

IPV6=m
DEFRAG_IPV6=m
CONNTRACK=y yields:

net/netfilter/nf_conntrack_proto.o: In function `nf_ct_netns_do_get':
net/netfilter/nf_conntrack_proto.c:802: undefined reference to `nf_defrag_ipv6_enable'
net/netfilter/nf_conntrack_proto.o:(.rodata+0x640): undefined reference to `nf_conntrack_l4proto_icmpv6'

Setting DEFRAG_IPV6=y causes undefined references to ip6_rhash_params
ip6_frag_init and ip6_expire_frag_queue so it would be needed to force
IPV6=y too.

This patch gets rid of the 'followup linker error' by removing
the dependency of ipv6.ko symbols from netfilter ipv6 defrag.

Shared code is placed into a header, then used from both.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/ipv6.h                        |  28 --------
 include/net/ipv6_frag.h                   | 102 ++++++++++++++++++++++++++++++
 net/ipv6/netfilter/nf_conntrack_reasm.c   |  17 +++--
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c |   3 +-
 net/ipv6/reassembly.c                     |  92 ++-------------------------
 net/openvswitch/conntrack.c               |   1 +
 6 files changed, 123 insertions(+), 120 deletions(-)
 create mode 100644 include/net/ipv6_frag.h

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 16475c269749..0012c0a6c86e 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -561,34 +561,6 @@ static inline bool ipv6_prefix_equal(const struct in6_addr *addr1,
 }
 #endif
 
-struct inet_frag_queue;
-
-enum ip6_defrag_users {
-	IP6_DEFRAG_LOCAL_DELIVER,
-	IP6_DEFRAG_CONNTRACK_IN,
-	__IP6_DEFRAG_CONNTRACK_IN	= IP6_DEFRAG_CONNTRACK_IN + USHRT_MAX,
-	IP6_DEFRAG_CONNTRACK_OUT,
-	__IP6_DEFRAG_CONNTRACK_OUT	= IP6_DEFRAG_CONNTRACK_OUT + USHRT_MAX,
-	IP6_DEFRAG_CONNTRACK_BRIDGE_IN,
-	__IP6_DEFRAG_CONNTRACK_BRIDGE_IN = IP6_DEFRAG_CONNTRACK_BRIDGE_IN + USHRT_MAX,
-};
-
-void ip6_frag_init(struct inet_frag_queue *q, const void *a);
-extern const struct rhashtable_params ip6_rhash_params;
-
-/*
- *	Equivalent of ipv4 struct ip
- */
-struct frag_queue {
-	struct inet_frag_queue	q;
-
-	int			iif;
-	__u16			nhoffset;
-	u8			ecn;
-};
-
-void ip6_expire_frag_queue(struct net *net, struct frag_queue *fq);
-
 static inline bool ipv6_addr_any(const struct in6_addr *a)
 {
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
diff --git a/include/net/ipv6_frag.h b/include/net/ipv6_frag.h
new file mode 100644
index 000000000000..ff3be4ca9471
--- /dev/null
+++ b/include/net/ipv6_frag.h
@@ -0,0 +1,102 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _IPV6_FRAG_H
+#define _IPV6_FRAG_H
+#include <linux/kernel.h>
+#include <net/addrconf.h>
+#include <net/ipv6.h>
+#include <net/inet_frag.h>
+
+enum ip6_defrag_users {
+	IP6_DEFRAG_LOCAL_DELIVER,
+	IP6_DEFRAG_CONNTRACK_IN,
+	__IP6_DEFRAG_CONNTRACK_IN	= IP6_DEFRAG_CONNTRACK_IN + USHRT_MAX,
+	IP6_DEFRAG_CONNTRACK_OUT,
+	__IP6_DEFRAG_CONNTRACK_OUT	= IP6_DEFRAG_CONNTRACK_OUT + USHRT_MAX,
+	IP6_DEFRAG_CONNTRACK_BRIDGE_IN,
+	__IP6_DEFRAG_CONNTRACK_BRIDGE_IN = IP6_DEFRAG_CONNTRACK_BRIDGE_IN + USHRT_MAX,
+};
+
+/*
+ *	Equivalent of ipv4 struct ip
+ */
+struct frag_queue {
+	struct inet_frag_queue	q;
+
+	int			iif;
+	__u16			nhoffset;
+	u8			ecn;
+};
+
+static inline void ip6frag_init(struct inet_frag_queue *q, const void *a)
+{
+	struct frag_queue *fq = container_of(q, struct frag_queue, q);
+	const struct frag_v6_compare_key *key = a;
+
+	q->key.v6 = *key;
+	fq->ecn = 0;
+}
+
+static inline u32 ip6frag_key_hashfn(const void *data, u32 len, u32 seed)
+{
+	return jhash2(data,
+		      sizeof(struct frag_v6_compare_key) / sizeof(u32), seed);
+}
+
+static inline u32 ip6frag_obj_hashfn(const void *data, u32 len, u32 seed)
+{
+	const struct inet_frag_queue *fq = data;
+
+	return jhash2((const u32 *)&fq->key.v6,
+		      sizeof(struct frag_v6_compare_key) / sizeof(u32), seed);
+}
+
+static inline int
+ip6frag_obj_cmpfn(struct rhashtable_compare_arg *arg, const void *ptr)
+{
+	const struct frag_v6_compare_key *key = arg->key;
+	const struct inet_frag_queue *fq = ptr;
+
+	return !!memcmp(&fq->key, key, sizeof(*key));
+}
+
+static inline void
+ip6frag_expire_frag_queue(struct net *net, struct frag_queue *fq)
+{
+	struct net_device *dev = NULL;
+	struct sk_buff *head;
+
+	rcu_read_lock();
+	spin_lock(&fq->q.lock);
+
+	if (fq->q.flags & INET_FRAG_COMPLETE)
+		goto out;
+
+	inet_frag_kill(&fq->q);
+
+	dev = dev_get_by_index_rcu(net, fq->iif);
+	if (!dev)
+		goto out;
+
+	__IP6_INC_STATS(net, __in6_dev_get(dev), IPSTATS_MIB_REASMFAILS);
+	__IP6_INC_STATS(net, __in6_dev_get(dev), IPSTATS_MIB_REASMTIMEOUT);
+
+	/* Don't send error if the first segment did not arrive. */
+	head = fq->q.fragments;
+	if (!(fq->q.flags & INET_FRAG_FIRST_IN) || !head)
+		goto out;
+
+	head->dev = dev;
+	skb_get(head);
+	spin_unlock(&fq->q.lock);
+
+	icmpv6_send(head, ICMPV6_TIME_EXCEED, ICMPV6_EXC_FRAGTIME, 0);
+	kfree_skb(head);
+	goto out_rcu_unlock;
+
+out:
+	spin_unlock(&fq->q.lock);
+out_rcu_unlock:
+	rcu_read_unlock();
+	inet_frag_put(&fq->q);
+}
+#endif
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 5e0332014c17..a44156b54ec9 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -33,9 +33,8 @@
 
 #include <net/sock.h>
 #include <net/snmp.h>
-#include <net/inet_frag.h>
+#include <net/ipv6_frag.h>
 
-#include <net/ipv6.h>
 #include <net/protocol.h>
 #include <net/transp_v6.h>
 #include <net/rawv6.h>
@@ -151,7 +150,7 @@ static void nf_ct_frag6_expire(struct timer_list *t)
 	fq = container_of(frag, struct frag_queue, q);
 	net = container_of(fq->q.net, struct net, nf_frag.frags);
 
-	ip6_expire_frag_queue(net, fq);
+	ip6frag_expire_frag_queue(net, fq);
 }
 
 /* Creation primitives. */
@@ -622,16 +621,24 @@ static struct pernet_operations nf_ct_net_ops = {
 	.exit = nf_ct_net_exit,
 };
 
+static const struct rhashtable_params nfct_rhash_params = {
+	.head_offset		= offsetof(struct inet_frag_queue, node),
+	.hashfn			= ip6frag_key_hashfn,
+	.obj_hashfn		= ip6frag_obj_hashfn,
+	.obj_cmpfn		= ip6frag_obj_cmpfn,
+	.automatic_shrinking	= true,
+};
+
 int nf_ct_frag6_init(void)
 {
 	int ret = 0;
 
-	nf_frags.constructor = ip6_frag_init;
+	nf_frags.constructor = ip6frag_init;
 	nf_frags.destructor = NULL;
 	nf_frags.qsize = sizeof(struct frag_queue);
 	nf_frags.frag_expire = nf_ct_frag6_expire;
 	nf_frags.frags_cache_name = nf_frags_cache_name;
-	nf_frags.rhash_params = ip6_rhash_params;
+	nf_frags.rhash_params = nfct_rhash_params;
 	ret = inet_frags_init(&nf_frags);
 	if (ret)
 		goto out;
diff --git a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
index e631be25337e..72dd3e202375 100644
--- a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
+++ b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
@@ -14,8 +14,7 @@
 #include <linux/skbuff.h>
 #include <linux/icmp.h>
 #include <linux/sysctl.h>
-#include <net/ipv6.h>
-#include <net/inet_frag.h>
+#include <net/ipv6_frag.h>
 
 #include <linux/netfilter_ipv6.h>
 #include <linux/netfilter_bridge.h>
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index b939b94e7e91..6edd2ac8ae4b 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -57,7 +57,7 @@
 #include <net/rawv6.h>
 #include <net/ndisc.h>
 #include <net/addrconf.h>
-#include <net/inet_frag.h>
+#include <net/ipv6_frag.h>
 #include <net/inet_ecn.h>
 
 static const char ip6_frag_cache_name[] = "ip6-frags";
@@ -72,61 +72,6 @@ static struct inet_frags ip6_frags;
 static int ip6_frag_reasm(struct frag_queue *fq, struct sk_buff *prev,
 			  struct net_device *dev);
 
-void ip6_frag_init(struct inet_frag_queue *q, const void *a)
-{
-	struct frag_queue *fq = container_of(q, struct frag_queue, q);
-	const struct frag_v6_compare_key *key = a;
-
-	q->key.v6 = *key;
-	fq->ecn = 0;
-}
-EXPORT_SYMBOL(ip6_frag_init);
-
-void ip6_expire_frag_queue(struct net *net, struct frag_queue *fq)
-{
-	struct net_device *dev = NULL;
-	struct sk_buff *head;
-
-	rcu_read_lock();
-	spin_lock(&fq->q.lock);
-
-	if (fq->q.flags & INET_FRAG_COMPLETE)
-		goto out;
-
-	inet_frag_kill(&fq->q);
-
-	dev = dev_get_by_index_rcu(net, fq->iif);
-	if (!dev)
-		goto out;
-
-	__IP6_INC_STATS(net, __in6_dev_get(dev), IPSTATS_MIB_REASMFAILS);
-	__IP6_INC_STATS(net, __in6_dev_get(dev), IPSTATS_MIB_REASMTIMEOUT);
-
-	/* Don't send error if the first segment did not arrive. */
-	head = fq->q.fragments;
-	if (!(fq->q.flags & INET_FRAG_FIRST_IN) || !head)
-		goto out;
-
-	/* But use as source device on which LAST ARRIVED
-	 * segment was received. And do not use fq->dev
-	 * pointer directly, device might already disappeared.
-	 */
-	head->dev = dev;
-	skb_get(head);
-	spin_unlock(&fq->q.lock);
-
-	icmpv6_send(head, ICMPV6_TIME_EXCEED, ICMPV6_EXC_FRAGTIME, 0);
-	kfree_skb(head);
-	goto out_rcu_unlock;
-
-out:
-	spin_unlock(&fq->q.lock);
-out_rcu_unlock:
-	rcu_read_unlock();
-	inet_frag_put(&fq->q);
-}
-EXPORT_SYMBOL(ip6_expire_frag_queue);
-
 static void ip6_frag_expire(struct timer_list *t)
 {
 	struct inet_frag_queue *frag = from_timer(frag, t, timer);
@@ -136,7 +81,7 @@ static void ip6_frag_expire(struct timer_list *t)
 	fq = container_of(frag, struct frag_queue, q);
 	net = container_of(fq->q.net, struct net, ipv6.frags);
 
-	ip6_expire_frag_queue(net, fq);
+	ip6frag_expire_frag_queue(net, fq);
 }
 
 static struct frag_queue *
@@ -696,42 +641,19 @@ static struct pernet_operations ip6_frags_ops = {
 	.exit = ipv6_frags_exit_net,
 };
 
-static u32 ip6_key_hashfn(const void *data, u32 len, u32 seed)
-{
-	return jhash2(data,
-		      sizeof(struct frag_v6_compare_key) / sizeof(u32), seed);
-}
-
-static u32 ip6_obj_hashfn(const void *data, u32 len, u32 seed)
-{
-	const struct inet_frag_queue *fq = data;
-
-	return jhash2((const u32 *)&fq->key.v6,
-		      sizeof(struct frag_v6_compare_key) / sizeof(u32), seed);
-}
-
-static int ip6_obj_cmpfn(struct rhashtable_compare_arg *arg, const void *ptr)
-{
-	const struct frag_v6_compare_key *key = arg->key;
-	const struct inet_frag_queue *fq = ptr;
-
-	return !!memcmp(&fq->key, key, sizeof(*key));
-}
-
-const struct rhashtable_params ip6_rhash_params = {
+static const struct rhashtable_params ip6_rhash_params = {
 	.head_offset		= offsetof(struct inet_frag_queue, node),
-	.hashfn			= ip6_key_hashfn,
-	.obj_hashfn		= ip6_obj_hashfn,
-	.obj_cmpfn		= ip6_obj_cmpfn,
+	.hashfn			= ip6frag_key_hashfn,
+	.obj_hashfn		= ip6frag_obj_hashfn,
+	.obj_cmpfn		= ip6frag_obj_cmpfn,
 	.automatic_shrinking	= true,
 };
-EXPORT_SYMBOL(ip6_rhash_params);
 
 int __init ipv6_frag_init(void)
 {
 	int ret;
 
-	ip6_frags.constructor = ip6_frag_init;
+	ip6_frags.constructor = ip6frag_init;
 	ip6_frags.destructor = NULL;
 	ip6_frags.qsize = sizeof(struct frag_queue);
 	ip6_frags.frag_expire = ip6_frag_expire;
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index e05bd3e53f0f..3ede65344e4d 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -26,6 +26,7 @@
 #include <net/netfilter/nf_conntrack_seqadj.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
+#include <net/ipv6_frag.h>
 
 #ifdef CONFIG_NF_NAT_NEEDED
 #include <linux/netfilter/nf_nat.h>
-- 
2.16.4
