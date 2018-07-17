From: dsahern@kernel.org
Subject: [PATCH RFC/RFT net-next 09/17] net: Remove arp_tbl and nd_tbl from headers
Date: Tue, 17 Jul 2018 05:06:43 -0700
Message-ID: <20180717120651.15748-10-dsahern@kernel.org>
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

No more users at this point.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/arp.h   | 3 ---
 include/net/ndisc.h | 2 --
 2 files changed, 5 deletions(-)

diff --git a/include/net/arp.h b/include/net/arp.h
index 7b503bedd9fb..fae3561db10b 100644
--- a/include/net/arp.h
+++ b/include/net/arp.h
@@ -7,9 +7,6 @@
 #include <linux/hash.h>
 #include <net/neighbour.h>
 
-
-extern struct neigh_table arp_tbl;
-
 static inline struct neigh_table *ipv4_neigh_table(struct net *net)
 {
 	return neigh_find_table(net, AF_INET);
diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index 078951ac54fd..6fc58a61acdd 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -72,8 +72,6 @@ struct net_proto_family;
 struct sk_buff;
 struct prefix_info;
 
-extern struct neigh_table nd_tbl;
-
 struct nd_msg {
         struct icmp6hdr	icmph;
         struct in6_addr	target;
-- 
2.11.0
