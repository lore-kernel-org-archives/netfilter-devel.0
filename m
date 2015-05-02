From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 20/34] netfilter: ipset: Check extensions attributes before getting extensions.
Date: Sat,  2 May 2015 19:28:09 +0200
Message-ID: <1430587703-3387-21-git-send-email-kadlec@blackhole.kfki.hu>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:36704 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbbEBR2I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2015 13:28:08 -0400
In-Reply-To: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Sergey Popovich <popovich_sergei@mail.ua>

Make all extensions attributes checks within ip_set_get_extensions()
and reduce number of duplicated code.

Signed-off-by: Sergey Popovich <popovich_sergei@mail.ua>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_bitmap_ip.c       |  8 +-------
 net/netfilter/ipset/ip_set_bitmap_ipmac.c    |  8 +-------
 net/netfilter/ipset/ip_set_bitmap_port.c     |  8 +-------
 net/netfilter/ipset/ip_set_core.c            | 10 ++++++++++
 net/netfilter/ipset/ip_set_hash_ip.c         | 14 +-------------
 net/netfilter/ipset/ip_set_hash_ipmark.c     | 14 +-------------
 net/netfilter/ipset/ip_set_hash_ipport.c     | 14 +-------------
 net/netfilter/ipset/ip_set_hash_ipportip.c   | 14 +-------------
 net/netfilter/ipset/ip_set_hash_ipportnet.c  | 14 +-------------
 net/netfilter/ipset/ip_set_hash_mac.c        |  8 +-------
 net/netfilter/ipset/ip_set_hash_net.c        | 16 ++--------------
 net/netfilter/ipset/ip_set_hash_netiface.c   | 16 ++--------------
 net/netfilter/ipset/ip_set_hash_netnet.c     | 16 ++--------------
 net/netfilter/ipset/ip_set_hash_netport.c    | 16 ++--------------
 net/netfilter/ipset/ip_set_hash_netportnet.c | 16 ++--------------
 net/netfilter/ipset/ip_set_list_set.c        |  8 +-------
 16 files changed, 30 insertions(+), 170 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
index f078c4e..a080516 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -137,13 +137,7 @@ bitmap_ip_uadt(struct ip_set *set, struct nlattr *tb[],
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	int ret = 0;
 
-	if (unlikely(!tb[IPSET_ATTR_IP] ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES)   ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBMARK) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBPRIO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBQUEUE)))
+	if (unlikely(!tb[IPSET_ATTR_IP]))
 		return -IPSET_ERR_PROTOCOL;
 
 	if (tb[IPSET_ATTR_LINENO])
diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 392ba6d..5c3bb34 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -246,13 +246,7 @@ bitmap_ipmac_uadt(struct ip_set *set, struct nlattr *tb[],
 	u32 ip = 0;
 	int ret = 0;
 
-	if (unlikely(!tb[IPSET_ATTR_IP] ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES)   ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBMARK) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBPRIO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBQUEUE)))
+	if (unlikely(!tb[IPSET_ATTR_IP]))
 		return -IPSET_ERR_PROTOCOL;
 
 	if (tb[IPSET_ATTR_LINENO])
diff --git a/net/netfilter/ipset/ip_set_bitmap_port.c b/net/netfilter/ipset/ip_set_bitmap_port.c
index e69619a..d61a9f7 100644
--- a/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -137,13 +137,7 @@ bitmap_port_uadt(struct ip_set *set, struct nlattr *tb[],
 	int ret = 0;
 
 	if (unlikely(!ip_set_attr_netorder(tb, IPSET_ATTR_PORT) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PORT_TO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES)   ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBMARK) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBPRIO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBQUEUE)))
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PORT_TO)))
 		return -IPSET_ERR_PROTOCOL;
 
 	if (tb[IPSET_ATTR_LINENO])
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 3010252..eeaa9a0 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -383,6 +383,7 @@ ip_set_elem_len(struct ip_set *set, struct nlattr *tb[], size_t len)
 	}
 	return offset;
 }
+
 EXPORT_SYMBOL_GPL(ip_set_elem_len);
 
 int
@@ -390,6 +391,15 @@ ip_set_get_extensions(struct ip_set *set, struct nlattr *tb[],
 		      struct ip_set_ext *ext)
 {
 	u64 fullmark;
+
+	if (unlikely(!ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES) ||
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBMARK) ||
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBPRIO) ||
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBQUEUE)))
+		return -IPSET_ERR_PROTOCOL;
+
 	if (tb[IPSET_ATTR_TIMEOUT]) {
 		if (!SET_WITH_TIMEOUT(set))
 			return -IPSET_ERR_TIMEOUT;
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index db41e29..3ad61fe 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -108,13 +108,7 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 	u32 ip = 0, ip_to = 0, hosts;
 	int ret = 0;
 
-	if (unlikely(!tb[IPSET_ATTR_IP] ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES)   ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBMARK) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBPRIO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBQUEUE)))
+	if (unlikely(!tb[IPSET_ATTR_IP]))
 		return -IPSET_ERR_PROTOCOL;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -248,12 +242,6 @@ hash_ip6_uadt(struct ip_set *set, struct nlattr *tb[],
 	int ret;
 
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBMARK) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBPRIO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBQUEUE) ||
 		     tb[IPSET_ATTR_IP_TO] ||
 		     tb[IPSET_ATTR_CIDR]))
 		return -IPSET_ERR_PROTOCOL;
diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ipset/ip_set_hash_ipmark.c
index ee87c6a..0bf56aa 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -110,13 +110,7 @@ hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
 	int ret;
 
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
-		     !ip_set_attr_netorder(tb, IPSET_ATTR_MARK) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBMARK) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBPRIO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBQUEUE)))
+		     !ip_set_attr_netorder(tb, IPSET_ATTR_MARK)))
 		return -IPSET_ERR_PROTOCOL;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -245,12 +239,6 @@ hash_ipmark6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
 		     !ip_set_attr_netorder(tb, IPSET_ATTR_MARK) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBMARK) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBPRIO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBQUEUE) ||
 		     tb[IPSET_ATTR_IP_TO] ||
 		     tb[IPSET_ATTR_CIDR]))
 		return -IPSET_ERR_PROTOCOL;
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index 93431d3..0178d15 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -119,13 +119,7 @@ hash_ipport4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
 		     !ip_set_attr_netorder(tb, IPSET_ATTR_PORT) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PORT_TO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBMARK) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBPRIO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBQUEUE)))
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PORT_TO)))
 		return -IPSET_ERR_PROTOCOL;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -288,12 +282,6 @@ hash_ipport6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
 		     !ip_set_attr_netorder(tb, IPSET_ATTR_PORT) ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PORT_TO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBMARK) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBPRIO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBQUEUE) ||
 		     tb[IPSET_ATTR_IP_TO] ||
 		     tb[IPSET_ATTR_CIDR]))
 		return -IPSET_ERR_PROTOCOL;
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/ipset/ip_set_hash_ipportip.c
index a13c26d..bd4f7cb 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -121,13 +121,7 @@ hash_ipportip4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
 		     !ip_set_attr_netorder(tb, IPSET_ATTR_PORT) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PORT_TO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBMARK) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBPRIO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBQUEUE)))
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PORT_TO)))
 		return -IPSET_ERR_PROTOCOL;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -296,12 +290,6 @@ hash_ipportip6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
 		     !ip_set_attr_netorder(tb, IPSET_ATTR_PORT) ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PORT_TO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBMARK) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBPRIO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBQUEUE) ||
 		     tb[IPSET_ATTR_IP_TO] ||
 		     tb[IPSET_ATTR_CIDR]))
 		return -IPSET_ERR_PROTOCOL;
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index c40e1f3..8662f19 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -176,13 +176,7 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
 		     !ip_set_attr_netorder(tb, IPSET_ATTR_PORT) ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PORT_TO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBMARK) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBPRIO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBQUEUE)))
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS)))
 		return -IPSET_ERR_PROTOCOL;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -432,13 +426,7 @@ hash_ipportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
 		     !ip_set_attr_netorder(tb, IPSET_ATTR_PORT) ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PORT_TO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBMARK) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBPRIO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBQUEUE) ||
 		     tb[IPSET_ATTR_IP_TO] ||
 		     tb[IPSET_ATTR_CIDR]))
 		return -IPSET_ERR_PROTOCOL;
diff --git a/net/netfilter/ipset/ip_set_hash_mac.c b/net/netfilter/ipset/ip_set_hash_mac.c
index cb59dd9..3b4f579 100644
--- a/net/netfilter/ipset/ip_set_hash_mac.c
+++ b/net/netfilter/ipset/ip_set_hash_mac.c
@@ -102,13 +102,7 @@ hash_mac4_uadt(struct ip_set *set, struct nlattr *tb[],
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	int ret;
 
-	if (unlikely(!tb[IPSET_ATTR_ETHER] ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES)   ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBMARK) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBPRIO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBQUEUE)))
+	if (unlikely(!tb[IPSET_ATTR_ETHER]))
 		return -IPSET_ERR_PROTOCOL;
 
 	if (tb[IPSET_ATTR_LINENO])
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/ip_set_hash_net.c
index 8bc768d..16ddce3 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -147,13 +147,7 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 	int ret;
 
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBMARK) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBPRIO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBQUEUE)))
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS)))
 		return -IPSET_ERR_PROTOCOL;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -319,13 +313,7 @@ hash_net6_uadt(struct ip_set *set, struct nlattr *tb[],
 	int ret;
 
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBMARK) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBPRIO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBQUEUE)))
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS)))
 		return -IPSET_ERR_PROTOCOL;
 	if (unlikely(tb[IPSET_ATTR_IP_TO]))
 		return -IPSET_ERR_HASH_RANGE_UNSUPPORTED;
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index 0408695..b885476 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -207,13 +207,7 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
 		     !tb[IPSET_ATTR_IFACE] ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBMARK) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBPRIO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBQUEUE)))
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS)))
 		return -IPSET_ERR_PROTOCOL;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -421,13 +415,7 @@ hash_netiface6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
 		     !tb[IPSET_ATTR_IFACE] ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBMARK) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBPRIO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBQUEUE)))
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS)))
 		return -IPSET_ERR_PROTOCOL;
 	if (unlikely(tb[IPSET_ATTR_IP_TO]))
 		return -IPSET_ERR_HASH_RANGE_UNSUPPORTED;
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset/ip_set_hash_netnet.c
index b8858f2..10da0b6 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -169,13 +169,7 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	e.cidr[0] = e.cidr[1] = HOST_MASK;
 	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBMARK) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBPRIO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBQUEUE)))
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS)))
 		return -IPSET_ERR_PROTOCOL;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -400,13 +394,7 @@ hash_netnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	e.cidr[0] = e.cidr[1] = HOST_MASK;
 	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBMARK) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBPRIO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBQUEUE)))
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS)))
 		return -IPSET_ERR_PROTOCOL;
 	if (unlikely(tb[IPSET_ATTR_IP_TO] || tb[IPSET_ATTR_IP2_TO]))
 		return -IPSET_ERR_HASH_RANGE_UNSUPPORTED;
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
index fc4b6bf..0efaf5b 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -169,13 +169,7 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
 		     !ip_set_attr_netorder(tb, IPSET_ATTR_PORT) ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PORT_TO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBMARK) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBPRIO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBQUEUE)))
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS)))
 		return -IPSET_ERR_PROTOCOL;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -390,13 +384,7 @@ hash_netport6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
 		     !ip_set_attr_netorder(tb, IPSET_ATTR_PORT) ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PORT_TO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBMARK) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBPRIO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBQUEUE)))
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS)))
 		return -IPSET_ERR_PROTOCOL;
 	if (unlikely(tb[IPSET_ATTR_IP_TO]))
 		return -IPSET_ERR_HASH_RANGE_UNSUPPORTED;
diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
index 6d3edc3..e7dda56 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -187,13 +187,7 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
 		     !ip_set_attr_netorder(tb, IPSET_ATTR_PORT) ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PORT_TO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBMARK) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBPRIO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBQUEUE)))
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS)))
 		return -IPSET_ERR_PROTOCOL;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -466,13 +460,7 @@ hash_netportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
 		     !ip_set_attr_netorder(tb, IPSET_ATTR_PORT) ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PORT_TO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBMARK) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBPRIO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBQUEUE)))
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS)))
 		return -IPSET_ERR_PROTOCOL;
 	if (unlikely(tb[IPSET_ATTR_IP_TO] || tb[IPSET_ATTR_IP2_TO]))
 		return -IPSET_ERR_HASH_RANGE_UNSUPPORTED;
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index f71b8e5..898c197 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -358,13 +358,7 @@ list_set_uadt(struct ip_set *set, struct nlattr *tb[],
 	int ret = 0;
 
 	if (unlikely(!tb[IPSET_ATTR_NAME] ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBMARK) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBPRIO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBQUEUE)))
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS)))
 		return -IPSET_ERR_PROTOCOL;
 
 	if (tb[IPSET_ATTR_LINENO])
-- 
1.8.5.1

