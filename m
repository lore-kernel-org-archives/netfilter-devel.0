From: dsahern@kernel.org
Subject: [PATCH RFC/RFT net-next 05/17] net/ipv6: wrappers for neighbor table references
Date: Tue, 17 Jul 2018 05:06:39 -0700
Message-ID: <20180717120651.15748-6-dsahern@kernel.org>
References: <20180717120651.15748-1-dsahern@kernel.org>
Cc: nikita.leshchenko@oracle.com, roopa@cumulusnetworks.com,
        stephen@networkplumber.org, idosch@mellanox.com, jiri@mellanox.com,
        saeedm@mellanox.com, alex.aring@gmail.com,
        linux-wpan@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>
To: netdev@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180717120651.15748-1-dsahern@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Create a helper, ipv6_neigh_table, for retrieving a reference to the ipv6
neighbor table. Add additional wrappers for commonly used neigh_* functions
to avoid propagating the ipv6_neigh_table lookup all over the code.

For ipv6, the neighbor table may not exist (e.g., IPv6 not enabled at
build time or the module is not loaded) so NULL checks are needed before
use.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/ndisc.h | 69 +++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 65 insertions(+), 4 deletions(-)

diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index ddfbb591e2c5..078951ac54fd 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -374,17 +374,70 @@ static inline u32 ndisc_hashfn(const void *pkey, const struct net_device *dev, _
 		(p32[3] * hash_rnd[3]));
 }
 
-static inline struct neighbour *__ipv6_neigh_lookup_noref(struct net_device *dev, const void *pkey)
+static inline struct neigh_table *ipv6_neigh_table(struct net *net)
 {
-	return ___neigh_lookup_noref(&nd_tbl, neigh_key_eq128, ndisc_hashfn, pkey, dev);
+	return neigh_find_table(net, AF_INET6);
 }
 
-static inline struct neighbour *__ipv6_neigh_lookup(struct net_device *dev, const void *pkey)
+static inline struct neighbour *ipv6_neigh_create(struct net_device *dev,
+						  const void *pkey,
+						  bool want_ref)
+{
+	struct neigh_table *tbl = ipv6_neigh_table(dev_net(dev));
+	struct neighbour *n = NULL;
+
+	if (tbl)
+		n = __neigh_create(tbl, pkey, dev, want_ref);
+
+	return n;
+}
+
+static inline struct neighbour *ipv6_neigh_lookup(struct net_device *dev,
+						  const void *pkey)
+{
+	struct neigh_table *tbl = ipv6_neigh_table(dev_net(dev));
+	struct neighbour *n = NULL;
+
+	if (tbl)
+		n = neigh_lookup(tbl, pkey, dev);
+
+	return n;
+}
+
+static inline struct neighbour *__ipv6_neigh_lookup(struct net_device *dev,
+						    const void *pkey, int creat)
+{
+	struct neigh_table *tbl = ipv6_neigh_table(dev_net(dev));
+	struct neighbour *n = NULL;
+
+	if (tbl)
+		n = __neigh_lookup(tbl, pkey, dev, creat);
+
+	return n;
+}
+
+static inline
+struct neighbour *___ipv6_neigh_lookup_noref(struct net_device *dev,
+					     const void *pkey)
+{
+	struct neigh_table *tbl = ipv6_neigh_table(dev_net(dev));
+	struct neighbour *n = NULL;
+
+	if (tbl)
+		n = ___neigh_lookup_noref(tbl, neigh_key_eq128, ndisc_hashfn,
+					  pkey, dev);
+
+	return n;
+}
+
+static inline
+struct neighbour *__ipv6_neigh_lookup_noref(struct net_device *dev,
+					    const void *pkey)
 {
 	struct neighbour *n;
 
 	rcu_read_lock_bh();
-	n = __ipv6_neigh_lookup_noref(dev, pkey);
+	n = ___ipv6_neigh_lookup_noref(dev, pkey);
 	if (n && !refcount_inc_not_zero(&n->refcnt))
 		n = NULL;
 	rcu_read_unlock_bh();
@@ -409,6 +462,14 @@ static inline void __ipv6_confirm_neigh(struct net_device *dev,
 	rcu_read_unlock_bh();
 }
 
+static inline struct pneigh_entry *ipv6_pneigh_lookup(struct net *net,
+						      const void *key,
+						      struct net_device *dev,
+						      int creat)
+{
+	return pneigh_lookup(ipv6_neigh_table(net), net, key, dev, creat);
+}
+
 int ndisc_init(void);
 int ndisc_late_init(void);
 
-- 
2.11.0
