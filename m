From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 04/15] netfilter: ipset: Move often used IPv6 address masking function to header file
Date: Tue,  9 Apr 2013 21:09:47 +0200
Message-ID: <1365534598-23877-5-git-send-email-kadlec@blackhole.kfki.hu>
References: <1365534598-23877-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:59779 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935589Ab3DITKB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:10:01 -0400
In-Reply-To: <1365534598-23877-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/pfxlen.h      |    9 +++++++++
 net/netfilter/ipset/ip_set_hash_ip.c        |    9 ---------
 net/netfilter/ipset/ip_set_hash_ipportnet.c |    9 ---------
 net/netfilter/ipset/ip_set_hash_net.c       |    9 ---------
 net/netfilter/ipset/ip_set_hash_netiface.c  |    9 ---------
 net/netfilter/ipset/ip_set_hash_netport.c   |    9 ---------
 6 files changed, 9 insertions(+), 45 deletions(-)

diff --git a/include/linux/netfilter/ipset/pfxlen.h b/include/linux/netfilter/ipset/pfxlen.h
index 199fd11..1afbb94 100644
--- a/include/linux/netfilter/ipset/pfxlen.h
+++ b/include/linux/netfilter/ipset/pfxlen.h
@@ -41,4 +41,13 @@ do {						\
 	to = from | ~ip_set_hostmask(cidr);	\
 } while (0)
 
+static inline void
+ip6_netmask(union nf_inet_addr *ip, u8 prefix)
+{
+	ip->ip6[0] &= ip_set_netmask6(prefix)[0];
+	ip->ip6[1] &= ip_set_netmask6(prefix)[1];
+	ip->ip6[2] &= ip_set_netmask6(prefix)[2];
+	ip->ip6[3] &= ip_set_netmask6(prefix)[3];
+}
+
 #endif /*_PFXLEN_H */
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index b7d4cb4..c486ad2 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -255,15 +255,6 @@ hash_ip6_data_zero_out(struct hash_ip6_elem *elem)
 	ipv6_addr_set(&elem->ip.in6, 0, 0, 0, 0);
 }
 
-static inline void
-ip6_netmask(union nf_inet_addr *ip, u8 prefix)
-{
-	ip->ip6[0] &= ip_set_netmask6(prefix)[0];
-	ip->ip6[1] &= ip_set_netmask6(prefix)[1];
-	ip->ip6[2] &= ip_set_netmask6(prefix)[2];
-	ip->ip6[3] &= ip_set_netmask6(prefix)[3];
-}
-
 static bool
 hash_ip6_data_list(struct sk_buff *skb, const struct hash_ip6_elem *data)
 {
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index b4836c8..352f8b4 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -446,15 +446,6 @@ hash_ipportnet6_data_zero_out(struct hash_ipportnet6_elem *elem)
 }
 
 static inline void
-ip6_netmask(union nf_inet_addr *ip, u8 prefix)
-{
-	ip->ip6[0] &= ip_set_netmask6(prefix)[0];
-	ip->ip6[1] &= ip_set_netmask6(prefix)[1];
-	ip->ip6[2] &= ip_set_netmask6(prefix)[2];
-	ip->ip6[3] &= ip_set_netmask6(prefix)[3];
-}
-
-static inline void
 hash_ipportnet6_data_netmask(struct hash_ipportnet6_elem *elem, u8 cidr)
 {
 	ip6_netmask(&elem->ip2, cidr);
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/ip_set_hash_net.c
index 6dbe0af..370947c 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -343,15 +343,6 @@ hash_net6_data_zero_out(struct hash_net6_elem *elem)
 }
 
 static inline void
-ip6_netmask(union nf_inet_addr *ip, u8 prefix)
-{
-	ip->ip6[0] &= ip_set_netmask6(prefix)[0];
-	ip->ip6[1] &= ip_set_netmask6(prefix)[1];
-	ip->ip6[2] &= ip_set_netmask6(prefix)[2];
-	ip->ip6[3] &= ip_set_netmask6(prefix)[3];
-}
-
-static inline void
 hash_net6_data_netmask(struct hash_net6_elem *elem, u8 cidr)
 {
 	ip6_netmask(&elem->ip, cidr);
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index 2481620..dd9843e 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -529,15 +529,6 @@ hash_netiface6_data_zero_out(struct hash_netiface6_elem *elem)
 }
 
 static inline void
-ip6_netmask(union nf_inet_addr *ip, u8 prefix)
-{
-	ip->ip6[0] &= ip_set_netmask6(prefix)[0];
-	ip->ip6[1] &= ip_set_netmask6(prefix)[1];
-	ip->ip6[2] &= ip_set_netmask6(prefix)[2];
-	ip->ip6[3] &= ip_set_netmask6(prefix)[3];
-}
-
-static inline void
 hash_netiface6_data_netmask(struct hash_netiface6_elem *elem, u8 cidr)
 {
 	ip6_netmask(&elem->ip, cidr);
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
index 57b0550..cd1d3c1 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -407,15 +407,6 @@ hash_netport6_data_zero_out(struct hash_netport6_elem *elem)
 }
 
 static inline void
-ip6_netmask(union nf_inet_addr *ip, u8 prefix)
-{
-	ip->ip6[0] &= ip_set_netmask6(prefix)[0];
-	ip->ip6[1] &= ip_set_netmask6(prefix)[1];
-	ip->ip6[2] &= ip_set_netmask6(prefix)[2];
-	ip->ip6[3] &= ip_set_netmask6(prefix)[3];
-}
-
-static inline void
 hash_netport6_data_netmask(struct hash_netport6_elem *elem, u8 cidr)
 {
 	ip6_netmask(&elem->ip, cidr);
-- 
1.7.0.4

