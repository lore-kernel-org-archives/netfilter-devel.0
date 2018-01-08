From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 50/52] netfilter: ipset: use swap macro instead of _manually_ swapping values
Date: Mon,  8 Jan 2018 21:19:58 +0100
Message-ID: <20180108202000.12989-51-pablo@netfilter.org>
References: <20180108202000.12989-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180108202000.12989-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>

Make use of the swap macro and remove unnecessary variables tmp.
This makes the code easier to read and maintain.

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_bitmap_ip.c    | 8 ++------
 net/netfilter/ipset/ip_set_bitmap_ipmac.c | 8 ++------
 net/netfilter/ipset/ip_set_bitmap_port.c  | 8 ++------
 3 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
index d8975a0b4282..488d6d05c65c 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -263,12 +263,8 @@ bitmap_ip_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
 		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP_TO], &last_ip);
 		if (ret)
 			return ret;
-		if (first_ip > last_ip) {
-			u32 tmp = first_ip;
-
-			first_ip = last_ip;
-			last_ip = tmp;
-		}
+		if (first_ip > last_ip)
+			swap(first_ip, last_ip);
 	} else if (tb[IPSET_ATTR_CIDR]) {
 		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
 
diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 4c279fbd2d5d..c00b6a2e8e3c 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -337,12 +337,8 @@ bitmap_ipmac_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
 		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP_TO], &last_ip);
 		if (ret)
 			return ret;
-		if (first_ip > last_ip) {
-			u32 tmp = first_ip;
-
-			first_ip = last_ip;
-			last_ip = tmp;
-		}
+		if (first_ip > last_ip)
+			swap(first_ip, last_ip);
 	} else if (tb[IPSET_ATTR_CIDR]) {
 		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
 
diff --git a/net/netfilter/ipset/ip_set_bitmap_port.c b/net/netfilter/ipset/ip_set_bitmap_port.c
index 7f9bbd7c98b5..b561ca8b3659 100644
--- a/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -238,12 +238,8 @@ bitmap_port_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
 
 	first_port = ip_set_get_h16(tb[IPSET_ATTR_PORT]);
 	last_port = ip_set_get_h16(tb[IPSET_ATTR_PORT_TO]);
-	if (first_port > last_port) {
-		u16 tmp = first_port;
-
-		first_port = last_port;
-		last_port = tmp;
-	}
+	if (first_port > last_port)
+		swap(first_port, last_port);
 
 	elements = last_port - first_port + 1;
 	set->dsize = ip_set_elem_len(set, tb, 0, 0);
-- 
2.11.0
