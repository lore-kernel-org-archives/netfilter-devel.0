From: dsahern@kernel.org
Subject: [PATCH RFC/RFT net-next 10/17] net: Add key_len to neighbor constructor
Date: Tue, 17 Jul 2018 05:06:44 -0700
Message-ID: <20180717120651.15748-11-dsahern@kernel.org>
References: <20180717120651.15748-1-dsahern@kernel.org>
Cc: nikita.leshchenko@oracle.com, roopa@cumulusnetworks.com,
        stephen@networkplumber.org, idosch@mellanox.com, jiri@mellanox.com,
        saeedm@mellanox.com, alex.aring@gmail.com,
        linux-wpan@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180717120651.15748-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Allows arp_constructor to not reference the arp_tbl directly.
ndisc_constructor assumes key length. Could do the same with arp.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/neighbour.h | 3 ++-
 net/core/neighbour.c    | 3 ++-
 net/decnet/dn_neigh.c   | 4 ++--
 net/ipv4/arp.c          | 6 +++---
 net/ipv6/ndisc.c        | 4 ++--
 5 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 5bc4d79b4b3a..6cf9ce16eac8 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -198,7 +198,8 @@ struct neigh_table {
 					const struct net_device *dev,
 					__u32 *hash_rnd);
 	bool			(*key_eq)(const struct neighbour *, const void *pkey);
-	int			(*constructor)(struct neighbour *);
+	int			(*constructor)(struct neighbour *,
+					       unsigned int key_len);
 	int			(*pconstructor)(struct pneigh_entry *);
 	void			(*pdestructor)(struct pneigh_entry *);
 	void			(*proxy_redo)(struct sk_buff *skb);
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index e8630f9de24a..41841d8e4ea4 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -505,7 +505,8 @@ struct neighbour *__neigh_create(struct neigh_table *tbl, const void *pkey,
 	dev_hold(dev);
 
 	/* Protocol specific setup. */
-	if (tbl->constructor &&	(error = tbl->constructor(n)) < 0) {
+	if (tbl->constructor &&
+	    (error = tbl->constructor(n, tbl->key_len)) < 0) {
 		rc = ERR_PTR(error);
 		goto out_neigh_release;
 	}
diff --git a/net/decnet/dn_neigh.c b/net/decnet/dn_neigh.c
index 94b306f6d551..74112777beb0 100644
--- a/net/decnet/dn_neigh.c
+++ b/net/decnet/dn_neigh.c
@@ -49,7 +49,7 @@
 #include <net/dn_neigh.h>
 #include <net/dn_route.h>
 
-static int dn_neigh_construct(struct neighbour *);
+static int dn_neigh_construct(struct neighbour *, unsigned int key_len);
 static void dn_neigh_error_report(struct neighbour *, struct sk_buff *);
 static int dn_neigh_output(struct neighbour *neigh, struct sk_buff *skb);
 
@@ -108,7 +108,7 @@ struct neigh_table dn_neigh_table = {
 	.gc_thresh3 =			1024,
 };
 
-static int dn_neigh_construct(struct neighbour *neigh)
+static int dn_neigh_construct(struct neighbour *neigh, unsigned int key_len)
 {
 	struct net_device *dev = neigh->dev;
 	struct dn_neigh *dn = container_of(neigh, struct dn_neigh, n);
diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index fd4a380da9bb..7b27faefa01b 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -125,7 +125,7 @@
  */
 static u32 arp_hash(const void *pkey, const struct net_device *dev, __u32 *hash_rnd);
 static bool arp_key_eq(const struct neighbour *n, const void *pkey);
-static int arp_constructor(struct neighbour *neigh);
+static int arp_constructor(struct neighbour *neigh, unsigned int key_len);
 static void arp_solicit(struct neighbour *neigh, struct sk_buff *skb);
 static void arp_error_report(struct neighbour *neigh, struct sk_buff *skb);
 static void parp_redo(struct sk_buff *skb);
@@ -221,7 +221,7 @@ static bool arp_key_eq(const struct neighbour *neigh, const void *pkey)
 	return neigh_key_eq32(neigh, pkey);
 }
 
-static int arp_constructor(struct neighbour *neigh)
+static int arp_constructor(struct neighbour *neigh, unsigned int key_len)
 {
 	__be32 addr;
 	struct net_device *dev = neigh->dev;
@@ -230,7 +230,7 @@ static int arp_constructor(struct neighbour *neigh)
 	u32 inaddr_any = INADDR_ANY;
 
 	if (dev->flags & (IFF_LOOPBACK | IFF_POINTOPOINT))
-		memcpy(neigh->primary_key, &inaddr_any, arp_tbl.key_len);
+		memcpy(neigh->primary_key, &inaddr_any, key_len);
 
 	addr = *(__be32 *)neigh->primary_key;
 	rcu_read_lock();
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 14b925f36099..5103d8641b04 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -77,7 +77,7 @@ static u32 ndisc_hash(const void *pkey,
 		      const struct net_device *dev,
 		      __u32 *hash_rnd);
 static bool ndisc_key_eq(const struct neighbour *neigh, const void *pkey);
-static int ndisc_constructor(struct neighbour *neigh);
+static int ndisc_constructor(struct neighbour *neigh, unsigned int key_len);
 static void ndisc_solicit(struct neighbour *neigh, struct sk_buff *skb);
 static void ndisc_error_report(struct neighbour *neigh, struct sk_buff *skb);
 static int pndisc_constructor(struct pneigh_entry *n);
@@ -319,7 +319,7 @@ static bool ndisc_key_eq(const struct neighbour *n, const void *pkey)
 	return neigh_key_eq128(n, pkey);
 }
 
-static int ndisc_constructor(struct neighbour *neigh)
+static int ndisc_constructor(struct neighbour *neigh, unsigned int key_len)
 {
 	struct in6_addr *addr = (struct in6_addr *)&neigh->primary_key;
 	struct net_device *dev = neigh->dev;
-- 
2.11.0
