From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 18/34] netfilter: ipset: Return ipset error instead of bool
Date: Sat,  2 May 2015 19:28:07 +0200
Message-ID: <1430587703-3387-19-git-send-email-kadlec@blackhole.kfki.hu>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:36971 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbbEBR2H (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2015 13:28:07 -0400
In-Reply-To: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Sergey Popovich <popovich_sergei@mail.ua>

Statement ret = func1() || func2() returns 0 when both func1()
and func2() return 0, or 1 if func1() or func2() returns non-zero.

However in our case func1() and func2() returns error code on
failure, so it seems good to propagate such error codes, rather
than returning 1 in case of failure.

Signed-off-by: Sergey Popovich <popovich_sergei@mail.ua>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_bitmap_ip.c       |  7 +++++--
 net/netfilter/ipset/ip_set_bitmap_ipmac.c    |  7 +++++--
 net/netfilter/ipset/ip_set_hash_ip.c         | 14 ++++++++++----
 net/netfilter/ipset/ip_set_hash_ipmark.c     | 14 ++++++++++----
 net/netfilter/ipset/ip_set_hash_ipport.c     | 14 ++++++++++----
 net/netfilter/ipset/ip_set_hash_ipportip.c   | 14 ++++++++++----
 net/netfilter/ipset/ip_set_hash_ipportnet.c  | 14 ++++++++++----
 net/netfilter/ipset/ip_set_hash_net.c        | 14 ++++++++++----
 net/netfilter/ipset/ip_set_hash_netiface.c   | 14 ++++++++++----
 net/netfilter/ipset/ip_set_hash_netnet.c     | 24 ++++++++++++++++++------
 net/netfilter/ipset/ip_set_hash_netport.c    | 14 ++++++++++----
 net/netfilter/ipset/ip_set_hash_netportnet.c | 24 ++++++++++++++++++------
 12 files changed, 126 insertions(+), 48 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
index 487513b..f078c4e 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -149,8 +149,11 @@ bitmap_ip_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
-	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP], &ip) ||
-	      ip_set_get_extensions(set, tb, &ext);
+	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP], &ip);
+	if (ret)
+		return ret;
+
+	ret = ip_set_get_extensions(set, tb, &ext);
 	if (ret)
 		return ret;
 
diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 8f3f1cd..392ba6d 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -258,8 +258,11 @@ bitmap_ipmac_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
-	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP], &ip) ||
-	      ip_set_get_extensions(set, tb, &ext);
+	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP], &ip);
+	if (ret)
+		return ret;
+
+	ret = ip_set_get_extensions(set, tb, &ext);
 	if (ret)
 		return ret;
 
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index 7bf17e6..db41e29 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -120,8 +120,11 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
-	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP], &ip) ||
-	      ip_set_get_extensions(set, tb, &ext);
+	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP], &ip);
+	if (ret)
+		return ret;
+
+	ret = ip_set_get_extensions(set, tb, &ext);
 	if (ret)
 		return ret;
 
@@ -258,8 +261,11 @@ hash_ip6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
-	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip) ||
-	      ip_set_get_extensions(set, tb, &ext);
+	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip);
+	if (ret)
+		return ret;
+
+	ret = ip_set_get_extensions(set, tb, &ext);
 	if (ret)
 		return ret;
 
diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ipset/ip_set_hash_ipmark.c
index 94c9c25..ee87c6a 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -122,8 +122,11 @@ hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
-	ret = ip_set_get_ipaddr4(tb[IPSET_ATTR_IP], &e.ip) ||
-	      ip_set_get_extensions(set, tb, &ext);
+	ret = ip_set_get_ipaddr4(tb[IPSET_ATTR_IP], &e.ip);
+	if (ret)
+		return ret;
+
+	ret = ip_set_get_extensions(set, tb, &ext);
 	if (ret)
 		return ret;
 
@@ -255,8 +258,11 @@ hash_ipmark6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
-	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip) ||
-	      ip_set_get_extensions(set, tb, &ext);
+	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip);
+	if (ret)
+		return ret;
+
+	ret = ip_set_get_extensions(set, tb, &ext);
 	if (ret)
 		return ret;
 
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index 8553d09..93431d3 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -131,8 +131,11 @@ hash_ipport4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
-	ret = ip_set_get_ipaddr4(tb[IPSET_ATTR_IP], &e.ip) ||
-	      ip_set_get_extensions(set, tb, &ext);
+	ret = ip_set_get_ipaddr4(tb[IPSET_ATTR_IP], &e.ip);
+	if (ret)
+		return ret;
+
+	ret = ip_set_get_extensions(set, tb, &ext);
 	if (ret)
 		return ret;
 
@@ -298,8 +301,11 @@ hash_ipport6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
-	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip) ||
-	      ip_set_get_extensions(set, tb, &ext);
+	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip);
+	if (ret)
+		return ret;
+
+	ret = ip_set_get_extensions(set, tb, &ext);
 	if (ret)
 		return ret;
 
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/ipset/ip_set_hash_ipportip.c
index 961ea56..a13c26d 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -133,8 +133,11 @@ hash_ipportip4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
-	ret = ip_set_get_ipaddr4(tb[IPSET_ATTR_IP], &e.ip) ||
-	      ip_set_get_extensions(set, tb, &ext);
+	ret = ip_set_get_ipaddr4(tb[IPSET_ATTR_IP], &e.ip);
+	if (ret)
+		return ret;
+
+	ret = ip_set_get_extensions(set, tb, &ext);
 	if (ret)
 		return ret;
 
@@ -306,8 +309,11 @@ hash_ipportip6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
-	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip) ||
-	      ip_set_get_extensions(set, tb, &ext);
+	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip);
+	if (ret)
+		return ret;
+
+	ret = ip_set_get_extensions(set, tb, &ext);
 	if (ret)
 		return ret;
 
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index d50e2ca..c40e1f3 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -188,8 +188,11 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
-	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP], &ip) ||
-	      ip_set_get_extensions(set, tb, &ext);
+	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP], &ip);
+	if (ret)
+		return ret;
+
+	ret = ip_set_get_extensions(set, tb, &ext);
 	if (ret)
 		return ret;
 
@@ -445,8 +448,11 @@ hash_ipportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
-	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip) ||
-	      ip_set_get_extensions(set, tb, &ext);
+	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip);
+	if (ret)
+		return ret;
+
+	ret = ip_set_get_extensions(set, tb, &ext);
 	if (ret)
 		return ret;
 
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/ip_set_hash_net.c
index 1cdc8c8..8bc768d 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -159,8 +159,11 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
-	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP], &ip) ||
-	      ip_set_get_extensions(set, tb, &ext);
+	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP], &ip);
+	if (ret)
+		return ret;
+
+	ret = ip_set_get_extensions(set, tb, &ext);
 	if (ret)
 		return ret;
 
@@ -330,8 +333,11 @@ hash_net6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
-	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip) ||
-	      ip_set_get_extensions(set, tb, &ext);
+	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip);
+	if (ret)
+		return ret;
+
+	ret = ip_set_get_extensions(set, tb, &ext);
 	if (ret)
 		return ret;
 
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index 2631c42..0408695 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -219,8 +219,11 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
-	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP], &ip) ||
-	      ip_set_get_extensions(set, tb, &ext);
+	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP], &ip);
+	if (ret)
+		return ret;
+
+	ret = ip_set_get_extensions(set, tb, &ext);
 	if (ret)
 		return ret;
 
@@ -432,8 +435,11 @@ hash_netiface6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
-	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip) ||
-	      ip_set_get_extensions(set, tb, &ext);
+	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip);
+	if (ret)
+		return ret;
+
+	ret = ip_set_get_extensions(set, tb, &ext);
 	if (ret)
 		return ret;
 
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset/ip_set_hash_netnet.c
index 1dc4878..b8858f2 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -181,9 +181,15 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
-	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP], &ip) ||
-	      ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP2], &ip2_from) ||
-	      ip_set_get_extensions(set, tb, &ext);
+	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP], &ip);
+	if (ret)
+		return ret;
+
+	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP2], &ip2_from);
+	if (ret)
+		return ret;
+
+	ret = ip_set_get_extensions(set, tb, &ext);
 	if (ret)
 		return ret;
 
@@ -408,9 +414,15 @@ hash_netnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
-	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip[0]) ||
-	      ip_set_get_ipaddr6(tb[IPSET_ATTR_IP2], &e.ip[1]) ||
-	      ip_set_get_extensions(set, tb, &ext);
+	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip[0]);
+	if (ret)
+		return ret;
+
+	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP2], &e.ip[1]);
+	if (ret)
+		return ret;
+
+	ret = ip_set_get_extensions(set, tb, &ext);
 	if (ret)
 		return ret;
 
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
index 8563cb0..fc4b6bf 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -181,8 +181,11 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
-	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP], &ip) ||
-	      ip_set_get_extensions(set, tb, &ext);
+	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP], &ip);
+	if (ret)
+		return ret;
+
+	ret = ip_set_get_extensions(set, tb, &ext);
 	if (ret)
 		return ret;
 
@@ -401,8 +404,11 @@ hash_netport6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
-	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip) ||
-	      ip_set_get_extensions(set, tb, &ext);
+	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip);
+	if (ret)
+		return ret;
+
+	ret = ip_set_get_extensions(set, tb, &ext);
 	if (ret)
 		return ret;
 
diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
index 61663c6..6d3edc3 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -199,9 +199,15 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
-	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP], &ip) ||
-	      ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP2], &ip2_from) ||
-	      ip_set_get_extensions(set, tb, &ext);
+	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP], &ip);
+	if (ret)
+		return ret;
+
+	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP2], &ip2_from);
+	if (ret)
+		return ret;
+
+	ret = ip_set_get_extensions(set, tb, &ext);
 	if (ret)
 		return ret;
 
@@ -474,9 +480,15 @@ hash_netportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
-	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip[0]) ||
-	      ip_set_get_ipaddr6(tb[IPSET_ATTR_IP2], &e.ip[1]) ||
-	      ip_set_get_extensions(set, tb, &ext);
+	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip[0]);
+	if (ret)
+		return ret;
+
+	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP2], &e.ip[1]);
+	if (ret)
+		return ret;
+
+	ret = ip_set_get_extensions(set, tb, &ext);
 	if (ret)
 		return ret;
 
-- 
1.8.5.1

