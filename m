From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 1/3] netfilter: ipset: use swap macro instead of _manually_ swapping values
Date: Sat,  6 Jan 2018 16:36:07 +0100
Message-ID: <1515252969-26094-2-git-send-email-kadlec@blackhole.kfki.hu>
References: <1515252969-26094-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:51225 "EHLO smtp1.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753355AbeAFPnm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Jan 2018 10:43:42 -0500
In-Reply-To: <1515252969-26094-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>

Make use of the swap macro and remove unnecessary variables tmp.
This makes the code easier to read and maintain.

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_bitmap_ip.c    | 8 ++------
 net/netfilter/ipset/ip_set_bitmap_ipmac.c | 8 ++------
 net/netfilter/ipset/ip_set_bitmap_port.c  | 8 ++------
 3 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
index d8975a0..488d6d0 100644
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
index 4c279fb..c00b6a2 100644
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
index 7f9bbd7..b561ca8 100644
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
2.1.4

