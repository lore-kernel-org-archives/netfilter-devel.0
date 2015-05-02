From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 23/34] netfilter: ipset: Permit CIDR equal to the host address CIDR in IPv6
Date: Sat,  2 May 2015 19:28:12 +0200
Message-ID: <1430587703-3387-24-git-send-email-kadlec@blackhole.kfki.hu>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:51380 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbbEBR2I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2015 13:28:08 -0400
In-Reply-To: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Sergey Popovich <popovich_sergei@mail.ua>

Permit userspace to supply CIDR length equal to the host address CIDR
length in netlink message. Prohibit any other CIDR length for IPv6
variant of the set.

Also return -IPSET_ERR_HASH_RANGE_UNSUPPORTED instead of generic
-IPSET_ERR_PROTOCOL in IPv6 variant of hash:ip,port,net when
IPSET_ATTR_IP_TO attribute is given.

Signed-off-by: Sergey Popovich <popovich_sergei@mail.ua>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_ip.c        | 11 ++++++++---
 net/netfilter/ipset/ip_set_hash_ipmark.c    | 11 ++++++++---
 net/netfilter/ipset/ip_set_hash_ipport.c    | 11 ++++++++---
 net/netfilter/ipset/ip_set_hash_ipportip.c  | 11 ++++++++---
 net/netfilter/ipset/ip_set_hash_ipportnet.c |  9 ++++++---
 5 files changed, 38 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index 6916097..6f6005b 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -241,10 +241,15 @@ hash_ip6_uadt(struct ip_set *set, struct nlattr *tb[],
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	int ret;
 
-	if (unlikely(!tb[IPSET_ATTR_IP] ||
-		     tb[IPSET_ATTR_IP_TO] ||
-		     tb[IPSET_ATTR_CIDR]))
+	if (unlikely(!tb[IPSET_ATTR_IP]))
 		return -IPSET_ERR_PROTOCOL;
+	if (unlikely(tb[IPSET_ATTR_IP_TO]))
+		return -IPSET_ERR_HASH_RANGE_UNSUPPORTED;
+	if (unlikely(tb[IPSET_ATTR_CIDR])) {
+		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
+		if (cidr != HOST_MASK)
+			return -IPSET_ERR_INVALID_CIDR;
+	}
 
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ipset/ip_set_hash_ipmark.c
index 0095df2..ebb1c47 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -238,10 +238,15 @@ hash_ipmark6_uadt(struct ip_set *set, struct nlattr *tb[],
 	int ret;
 
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
-		     !ip_set_attr_netorder(tb, IPSET_ATTR_MARK) ||
-		     tb[IPSET_ATTR_IP_TO] ||
-		     tb[IPSET_ATTR_CIDR]))
+		     !ip_set_attr_netorder(tb, IPSET_ATTR_MARK)))
 		return -IPSET_ERR_PROTOCOL;
+	if (unlikely(tb[IPSET_ATTR_IP_TO]))
+		return -IPSET_ERR_HASH_RANGE_UNSUPPORTED;
+	if (unlikely(tb[IPSET_ATTR_CIDR])) {
+		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
+		if (cidr != HOST_MASK)
+			return -IPSET_ERR_INVALID_CIDR;
+	}
 
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index 0a0d55f..2a4222b 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -278,10 +278,15 @@ hash_ipport6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (unlikely(!tb[IPSET_ATTR_IP] ||
 		     !ip_set_attr_netorder(tb, IPSET_ATTR_PORT) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PORT_TO) ||
-		     tb[IPSET_ATTR_IP_TO] ||
-		     tb[IPSET_ATTR_CIDR]))
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PORT_TO)))
 		return -IPSET_ERR_PROTOCOL;
+	if (unlikely(tb[IPSET_ATTR_IP_TO]))
+		return -IPSET_ERR_HASH_RANGE_UNSUPPORTED;
+	if (unlikely(tb[IPSET_ATTR_CIDR])) {
+		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
+		if (cidr != HOST_MASK)
+			return -IPSET_ERR_INVALID_CIDR;
+	}
 
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/ipset/ip_set_hash_ipportip.c
index 52bd8e8..f9f124b 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -286,10 +286,15 @@ hash_ipportip6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
 		     !ip_set_attr_netorder(tb, IPSET_ATTR_PORT) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PORT_TO) ||
-		     tb[IPSET_ATTR_IP_TO] ||
-		     tb[IPSET_ATTR_CIDR]))
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PORT_TO)))
 		return -IPSET_ERR_PROTOCOL;
+	if (unlikely(tb[IPSET_ATTR_IP_TO]))
+		return -IPSET_ERR_HASH_RANGE_UNSUPPORTED;
+	if (unlikely(tb[IPSET_ATTR_CIDR])) {
+		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
+		if (cidr != HOST_MASK)
+			return -IPSET_ERR_INVALID_CIDR;
+	}
 
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index f895339..eea1e80 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -423,12 +423,15 @@ hash_ipportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
 		     !ip_set_attr_netorder(tb, IPSET_ATTR_PORT) ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PORT_TO) ||
-		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS) ||
-		     tb[IPSET_ATTR_IP_TO] ||
-		     tb[IPSET_ATTR_CIDR]))
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS)))
 		return -IPSET_ERR_PROTOCOL;
 	if (unlikely(tb[IPSET_ATTR_IP_TO]))
 		return -IPSET_ERR_HASH_RANGE_UNSUPPORTED;
+	if (unlikely(tb[IPSET_ATTR_CIDR])) {
+		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
+		if (cidr != HOST_MASK)
+			return -IPSET_ERR_INVALID_CIDR;
+	}
 
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
-- 
1.8.5.1

