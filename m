From: dsahern@kernel.org
Subject: [PATCH RFC/RFT net-next 03/17] net/ipv4: wrappers for arp table references
Date: Tue, 17 Jul 2018 05:06:37 -0700
Message-ID: <20180717120651.15748-4-dsahern@kernel.org>
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

Create a helper, ipv4_neigh_table, for retrieving a reference to the arp
table. Add additional wrappers for commonly used neigh_* functions to
avoid propagating the ipv4_neigh_table lookup all over the code.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/arp.h | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/include/net/arp.h b/include/net/arp.h
index 977aabfcdc03..7b503bedd9fb 100644
--- a/include/net/arp.h
+++ b/include/net/arp.h
@@ -10,6 +10,29 @@
 
 extern struct neigh_table arp_tbl;
 
+static inline struct neigh_table *ipv4_neigh_table(struct net *net)
+{
+	return neigh_find_table(net, AF_INET);
+}
+
+static inline struct neighbour *ipv4_neigh_create(struct net_device *dev,
+						  const void *pkey)
+{
+	return neigh_create(ipv4_neigh_table(dev_net(dev)), pkey, dev);
+}
+
+static inline struct neighbour *ipv4_neigh_create_noref(struct net_device *dev,
+							const void *pkey)
+{
+	return __neigh_create(ipv4_neigh_table(dev_net(dev)), pkey, dev, false);
+}
+
+static inline struct neighbour *ipv4_neigh_lookup(struct net_device *dev,
+						  void *key)
+{
+	return neigh_lookup(ipv4_neigh_table(dev_net(dev)), key, dev);
+}
+
 static inline u32 arp_hashfn(const void *pkey, const struct net_device *dev, u32 *hash_rnd)
 {
 	u32 key = *(const u32 *)pkey;
@@ -23,7 +46,8 @@ static inline struct neighbour *__ipv4_neigh_lookup_noref(struct net_device *dev
 	if (dev->flags & (IFF_LOOPBACK | IFF_POINTOPOINT))
 		key = INADDR_ANY;
 
-	return ___neigh_lookup_noref(&arp_tbl, neigh_key_eq32, arp_hashfn, &key, dev);
+	return ___neigh_lookup_noref(ipv4_neigh_table(dev_net(dev)),
+				     neigh_key_eq32, arp_hashfn, &key, dev);
 }
 
 static inline struct neighbour *__ipv4_neigh_lookup(struct net_device *dev, u32 key)
-- 
2.11.0
