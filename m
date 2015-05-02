From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 29/34] netfilter: ipset: Fix hashing for ipv6 sets
Date: Sat,  2 May 2015 19:28:18 +0200
Message-ID: <1430587703-3387-30-git-send-email-kadlec@blackhole.kfki.hu>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:51400 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbbEBR2K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2015 13:28:10 -0400
In-Reply-To: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Sergey Popovich <popovich_sergei@mail.ua>

HKEY_DATALEN remains defined after first inclusion
of ip_set_hash_gen.h, so it is incorrectly reused
for IPv6 code.

Undefine HKEY_DATALEN in ip_set_hash_gen.h at the end.

Also remove some useless defines of HKEY_DATALEN in
ip_set_hash_{ip{,mark,port},netiface}.c as ip_set_hash_gen.h
defines it correctly for such set types anyway.

Signed-off-by: Sergey Popovich <popovich_sergei@mail.ua>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_gen.h      | 2 ++
 net/netfilter/ipset/ip_set_hash_ip.c       | 1 -
 net/netfilter/ipset/ip_set_hash_ipmark.c   | 3 ---
 net/netfilter/ipset/ip_set_hash_ipport.c   | 3 ---
 net/netfilter/ipset/ip_set_hash_netiface.c | 1 -
 5 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index d2c7362..b00b44b 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1325,3 +1325,5 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 	return 0;
 }
 #endif /* IP_SET_EMIT_CREATE */
+
+#undef HKEY_DATALEN
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index e2e2820..99ea053 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -205,7 +205,6 @@ hash_ip6_data_next(struct hash_ip4_elem *next, const struct hash_ip6_elem *e)
 
 #undef MTYPE
 #undef HOST_MASK
-#undef HKEY_DATALEN
 
 #define MTYPE		hash_ip6
 #define HOST_MASK	128
diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ipset/ip_set_hash_ipmark.c
index da82cc8..c7d61f3 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -78,7 +78,6 @@ hash_ipmark4_data_next(struct hash_ipmark4_elem *next,
 
 #define MTYPE           hash_ipmark4
 #define HOST_MASK       32
-#define HKEY_DATALEN	sizeof(struct hash_ipmark4_elem)
 #include "ip_set_hash_gen.h"
 
 static int
@@ -201,11 +200,9 @@ hash_ipmark6_data_next(struct hash_ipmark4_elem *next,
 
 #undef MTYPE
 #undef HOST_MASK
-#undef HKEY_DATALEN
 
 #define MTYPE		hash_ipmark6
 #define HOST_MASK	128
-#define HKEY_DATALEN	sizeof(struct hash_ipmark6_elem)
 #define	IP_SET_EMIT_CREATE
 #include "ip_set_hash_gen.h"
 
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index 650ab31..702882b 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -85,7 +85,6 @@ hash_ipport4_data_next(struct hash_ipport4_elem *next,
 
 #define MTYPE           hash_ipport4
 #define HOST_MASK       32
-#define HKEY_DATALEN	sizeof(struct hash_ipport4_elem)
 #include "ip_set_hash_gen.h"
 
 static int
@@ -239,11 +238,9 @@ hash_ipport6_data_next(struct hash_ipport4_elem *next,
 
 #undef MTYPE
 #undef HOST_MASK
-#undef HKEY_DATALEN
 
 #define MTYPE		hash_ipport6
 #define HOST_MASK	128
-#define HKEY_DATALEN	sizeof(struct hash_ipport6_elem)
 #define	IP_SET_EMIT_CREATE
 #include "ip_set_hash_gen.h"
 
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index a480eca..3e7f12a 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -355,7 +355,6 @@ hash_netiface6_data_next(struct hash_netiface4_elem *next,
 
 #undef MTYPE
 #undef HOST_MASK
-#undef HKEY_DATALEN
 
 #define MTYPE		hash_netiface6
 #define HOST_MASK	128
-- 
1.8.5.1

