From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 21/34] netfilter: ipset: Check IPSET_ATTR_PORT only once
Date: Sat,  2 May 2015 19:28:10 +0200
Message-ID: <1430587703-3387-22-git-send-email-kadlec@blackhole.kfki.hu>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:36986 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbbEBR2J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2015 13:28:09 -0400
In-Reply-To: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Sergey Popovich <popovich_sergei@mail.ua>

We do not need to check tb[IPSET_ATTR_PORT] != NULL before
retrieving port, as this attribute is known to exist due to
ip_set_attr_netorder() returning true only when attribute
exists and it is in network byte order.

Signed-off-by: Sergey Popovich <popovich_sergei@mail.ua>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_ipport.c     | 10 ++--------
 net/netfilter/ipset/ip_set_hash_ipportip.c   | 10 ++--------
 net/netfilter/ipset/ip_set_hash_ipportnet.c  | 10 ++--------
 net/netfilter/ipset/ip_set_hash_netport.c    | 10 ++--------
 net/netfilter/ipset/ip_set_hash_netportnet.c | 10 ++--------
 5 files changed, 10 insertions(+), 40 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index 0178d15..254a629 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -133,10 +133,7 @@ hash_ipport4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (ret)
 		return ret;
 
-	if (tb[IPSET_ATTR_PORT])
-		e.port = nla_get_be16(tb[IPSET_ATTR_PORT]);
-	else
-		return -IPSET_ERR_PROTOCOL;
+	e.port = nla_get_be16(tb[IPSET_ATTR_PORT]);
 
 	if (tb[IPSET_ATTR_PROTO]) {
 		e.proto = nla_get_u8(tb[IPSET_ATTR_PROTO]);
@@ -297,10 +294,7 @@ hash_ipport6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (ret)
 		return ret;
 
-	if (tb[IPSET_ATTR_PORT])
-		e.port = nla_get_be16(tb[IPSET_ATTR_PORT]);
-	else
-		return -IPSET_ERR_PROTOCOL;
+	e.port = nla_get_be16(tb[IPSET_ATTR_PORT]);
 
 	if (tb[IPSET_ATTR_PROTO]) {
 		e.proto = nla_get_u8(tb[IPSET_ATTR_PROTO]);
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/ipset/ip_set_hash_ipportip.c
index bd4f7cb..e323b95 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -139,10 +139,7 @@ hash_ipportip4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (ret)
 		return ret;
 
-	if (tb[IPSET_ATTR_PORT])
-		e.port = nla_get_be16(tb[IPSET_ATTR_PORT]);
-	else
-		return -IPSET_ERR_PROTOCOL;
+	e.port = nla_get_be16(tb[IPSET_ATTR_PORT]);
 
 	if (tb[IPSET_ATTR_PROTO]) {
 		e.proto = nla_get_u8(tb[IPSET_ATTR_PROTO]);
@@ -309,10 +306,7 @@ hash_ipportip6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (ret)
 		return ret;
 
-	if (tb[IPSET_ATTR_PORT])
-		e.port = nla_get_be16(tb[IPSET_ATTR_PORT]);
-	else
-		return -IPSET_ERR_PROTOCOL;
+	e.port = nla_get_be16(tb[IPSET_ATTR_PORT]);
 
 	if (tb[IPSET_ATTR_PROTO]) {
 		e.proto = nla_get_u8(tb[IPSET_ATTR_PROTO]);
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index 8662f19..37dad02 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -201,10 +201,7 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 		e.cidr = cidr - 1;
 	}
 
-	if (tb[IPSET_ATTR_PORT])
-		e.port = nla_get_be16(tb[IPSET_ATTR_PORT]);
-	else
-		return -IPSET_ERR_PROTOCOL;
+	e.port = nla_get_be16(tb[IPSET_ATTR_PORT]);
 
 	if (tb[IPSET_ATTR_PROTO]) {
 		e.proto = nla_get_u8(tb[IPSET_ATTR_PROTO]);
@@ -457,10 +454,7 @@ hash_ipportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	ip6_netmask(&e.ip2, e.cidr + 1);
 
-	if (tb[IPSET_ATTR_PORT])
-		e.port = nla_get_be16(tb[IPSET_ATTR_PORT]);
-	else
-		return -IPSET_ERR_PROTOCOL;
+	e.port = nla_get_be16(tb[IPSET_ATTR_PORT]);
 
 	if (tb[IPSET_ATTR_PROTO]) {
 		e.proto = nla_get_u8(tb[IPSET_ATTR_PROTO]);
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
index 0efaf5b..38bf122 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -190,10 +190,7 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 		e.cidr = cidr - 1;
 	}
 
-	if (tb[IPSET_ATTR_PORT])
-		e.port = nla_get_be16(tb[IPSET_ATTR_PORT]);
-	else
-		return -IPSET_ERR_PROTOCOL;
+	e.port = nla_get_be16(tb[IPSET_ATTR_PORT]);
 
 	if (tb[IPSET_ATTR_PROTO]) {
 		e.proto = nla_get_u8(tb[IPSET_ATTR_PROTO]);
@@ -408,10 +405,7 @@ hash_netport6_uadt(struct ip_set *set, struct nlattr *tb[],
 	}
 	ip6_netmask(&e.ip, e.cidr + 1);
 
-	if (tb[IPSET_ATTR_PORT])
-		e.port = nla_get_be16(tb[IPSET_ATTR_PORT]);
-	else
-		return -IPSET_ERR_PROTOCOL;
+	e.port = nla_get_be16(tb[IPSET_ATTR_PORT]);
 
 	if (tb[IPSET_ATTR_PROTO]) {
 		e.proto = nla_get_u8(tb[IPSET_ATTR_PROTO]);
diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
index e7dda56..0ff0ae9 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -219,10 +219,7 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 		e.cidr[1] = cidr;
 	}
 
-	if (tb[IPSET_ATTR_PORT])
-		e.port = nla_get_be16(tb[IPSET_ATTR_PORT]);
-	else
-		return -IPSET_ERR_PROTOCOL;
+	e.port = nla_get_be16(tb[IPSET_ATTR_PORT]);
 
 	if (tb[IPSET_ATTR_PROTO]) {
 		e.proto = nla_get_u8(tb[IPSET_ATTR_PROTO]);
@@ -493,10 +490,7 @@ hash_netportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 	ip6_netmask(&e.ip[0], e.cidr[0]);
 	ip6_netmask(&e.ip[1], e.cidr[1]);
 
-	if (tb[IPSET_ATTR_PORT])
-		e.port = nla_get_be16(tb[IPSET_ATTR_PORT]);
-	else
-		return -IPSET_ERR_PROTOCOL;
+	e.port = nla_get_be16(tb[IPSET_ATTR_PORT]);
 
 	if (tb[IPSET_ATTR_PROTO]) {
 		e.proto = nla_get_u8(tb[IPSET_ATTR_PROTO]);
-- 
1.8.5.1

