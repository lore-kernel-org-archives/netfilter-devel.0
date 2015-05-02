From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 26/34] netfilter: ipset: Return bool values instead of int
Date: Sat,  2 May 2015 19:28:15 +0200
Message-ID: <1430587703-3387-27-git-send-email-kadlec@blackhole.kfki.hu>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:36716 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbbEBR2J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2015 13:28:09 -0400
In-Reply-To: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Sergey Popovich <popovich_sergei@mail.ua>

Signed-off-by: Sergey Popovich <popovich_sergei@mail.ua>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_ip.c         | 10 +++++-----
 net/netfilter/ipset/ip_set_hash_ipmark.c     |  8 ++++----
 net/netfilter/ipset/ip_set_hash_ipport.c     |  8 ++++----
 net/netfilter/ipset/ip_set_hash_ipportip.c   |  8 ++++----
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |  8 ++++----
 net/netfilter/ipset/ip_set_hash_mac.c        |  7 ++++++-
 net/netfilter/ipset/ip_set_hash_net.c        |  8 ++++----
 net/netfilter/ipset/ip_set_hash_netiface.c   |  8 ++++----
 net/netfilter/ipset/ip_set_hash_netport.c    |  8 ++++----
 net/netfilter/ipset/ip_set_hash_netportnet.c |  8 ++++----
 10 files changed, 43 insertions(+), 38 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index 9b591e3..5eaf4aab 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -56,15 +56,15 @@ hash_ip4_data_equal(const struct hash_ip4_elem *e1,
 	return e1->ip == e2->ip;
 }
 
-static inline bool
+static bool
 hash_ip4_data_list(struct sk_buff *skb, const struct hash_ip4_elem *e)
 {
 	if (nla_put_ipaddr4(skb, IPSET_ATTR_IP, e->ip))
 		goto nla_put_failure;
-	return 0;
+	return false;
 
 nla_put_failure:
-	return 1;
+	return true;
 }
 
 static inline void
@@ -192,10 +192,10 @@ hash_ip6_data_list(struct sk_buff *skb, const struct hash_ip6_elem *e)
 {
 	if (nla_put_ipaddr6(skb, IPSET_ATTR_IP, &e->ip.in6))
 		goto nla_put_failure;
-	return 0;
+	return false;
 
 nla_put_failure:
-	return 1;
+	return true;
 }
 
 static inline void
diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ipset/ip_set_hash_ipmark.c
index 0fce8ab..7da3638 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -63,10 +63,10 @@ hash_ipmark4_data_list(struct sk_buff *skb,
 	if (nla_put_ipaddr4(skb, IPSET_ATTR_IP, data->ip) ||
 	    nla_put_net32(skb, IPSET_ATTR_MARK, htonl(data->mark)))
 		goto nla_put_failure;
-	return 0;
+	return false;
 
 nla_put_failure:
-	return 1;
+	return true;
 }
 
 static inline void
@@ -187,10 +187,10 @@ hash_ipmark6_data_list(struct sk_buff *skb,
 	if (nla_put_ipaddr6(skb, IPSET_ATTR_IP, &data->ip.in6) ||
 	    nla_put_net32(skb, IPSET_ATTR_MARK, htonl(data->mark)))
 		goto nla_put_failure;
-	return 0;
+	return false;
 
 nla_put_failure:
-	return 1;
+	return true;
 }
 
 static inline void
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index 76de70a..3589cc3 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -69,10 +69,10 @@ hash_ipport4_data_list(struct sk_buff *skb,
 	    nla_put_net16(skb, IPSET_ATTR_PORT, data->port) ||
 	    nla_put_u8(skb, IPSET_ATTR_PROTO, data->proto))
 		goto nla_put_failure;
-	return 0;
+	return false;
 
 nla_put_failure:
-	return 1;
+	return true;
 }
 
 static inline void
@@ -224,10 +224,10 @@ hash_ipport6_data_list(struct sk_buff *skb,
 	    nla_put_net16(skb, IPSET_ATTR_PORT, data->port) ||
 	    nla_put_u8(skb, IPSET_ATTR_PROTO, data->proto))
 		goto nla_put_failure;
-	return 0;
+	return false;
 
 nla_put_failure:
-	return 1;
+	return true;
 }
 
 static inline void
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/ipset/ip_set_hash_ipportip.c
index 5c57bdd..a424693 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -70,10 +70,10 @@ hash_ipportip4_data_list(struct sk_buff *skb,
 	    nla_put_net16(skb, IPSET_ATTR_PORT, data->port) ||
 	    nla_put_u8(skb, IPSET_ATTR_PROTO, data->proto))
 		goto nla_put_failure;
-	return 0;
+	return false;
 
 nla_put_failure:
-	return 1;
+	return true;
 }
 
 static inline void
@@ -233,10 +233,10 @@ hash_ipportip6_data_list(struct sk_buff *skb,
 	    nla_put_net16(skb, IPSET_ATTR_PORT, data->port) ||
 	    nla_put_u8(skb, IPSET_ATTR_PROTO, data->proto))
 		goto nla_put_failure;
-	return 0;
+	return false;
 
 nla_put_failure:
-	return 1;
+	return true;
 }
 
 static inline void
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index a10f44b..14fb731 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -114,10 +114,10 @@ hash_ipportnet4_data_list(struct sk_buff *skb,
 	    (flags &&
 	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS, htonl(flags))))
 		goto nla_put_failure;
-	return 0;
+	return false;
 
 nla_put_failure:
-	return 1;
+	return true;
 }
 
 static inline void
@@ -360,10 +360,10 @@ hash_ipportnet6_data_list(struct sk_buff *skb,
 	    (flags &&
 	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS, htonl(flags))))
 		goto nla_put_failure;
-	return 0;
+	return false;
 
 nla_put_failure:
-	return 1;
+	return true;
 }
 
 static inline void
diff --git a/net/netfilter/ipset/ip_set_hash_mac.c b/net/netfilter/ipset/ip_set_hash_mac.c
index ad7308b..829d70f 100644
--- a/net/netfilter/ipset/ip_set_hash_mac.c
+++ b/net/netfilter/ipset/ip_set_hash_mac.c
@@ -52,7 +52,12 @@ hash_mac4_data_equal(const struct hash_mac4_elem *e1,
 static inline bool
 hash_mac4_data_list(struct sk_buff *skb, const struct hash_mac4_elem *e)
 {
-	return nla_put(skb, IPSET_ATTR_ETHER, ETH_ALEN, e->ether);
+	if (nla_put(skb, IPSET_ATTR_ETHER, ETH_ALEN, e->ether))
+		goto nla_put_failure;
+	return false;
+
+nla_put_failure:
+	return true;
 }
 
 static inline void
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/ip_set_hash_net.c
index fdaf418..9b163f8 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -95,10 +95,10 @@ hash_net4_data_list(struct sk_buff *skb, const struct hash_net4_elem *data)
 	    (flags &&
 	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS, htonl(flags))))
 		goto nla_put_failure;
-	return 0;
+	return false;
 
 nla_put_failure:
-	return 1;
+	return true;
 }
 
 static inline void
@@ -260,10 +260,10 @@ hash_net6_data_list(struct sk_buff *skb, const struct hash_net6_elem *data)
 	    (flags &&
 	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS, htonl(flags))))
 		goto nla_put_failure;
-	return 0;
+	return false;
 
 nla_put_failure:
-	return 1;
+	return true;
 }
 
 static inline void
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index e313255..2dbb859 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -117,10 +117,10 @@ hash_netiface4_data_list(struct sk_buff *skb,
 	    (flags &&
 	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS, htonl(flags))))
 		goto nla_put_failure;
-	return 0;
+	return false;
 
 nla_put_failure:
-	return 1;
+	return true;
 }
 
 static inline void
@@ -341,10 +341,10 @@ hash_netiface6_data_list(struct sk_buff *skb,
 	    (flags &&
 	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS, htonl(flags))))
 		goto nla_put_failure;
-	return 0;
+	return false;
 
 nla_put_failure:
-	return 1;
+	return true;
 }
 
 static inline void
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
index 86372bc..23f0f20 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -110,10 +110,10 @@ hash_netport4_data_list(struct sk_buff *skb,
 	    (flags &&
 	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS, htonl(flags))))
 		goto nla_put_failure;
-	return 0;
+	return false;
 
 nla_put_failure:
-	return 1;
+	return true;
 }
 
 static inline void
@@ -319,10 +319,10 @@ hash_netport6_data_list(struct sk_buff *skb,
 	    (flags &&
 	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS, htonl(flags))))
 		goto nla_put_failure;
-	return 0;
+	return false;
 
 nla_put_failure:
-	return 1;
+	return true;
 }
 
 static inline void
diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
index 6ebf037..2ab3c55 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -124,10 +124,10 @@ hash_netportnet4_data_list(struct sk_buff *skb,
 	    (flags &&
 	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS, htonl(flags))))
 		goto nla_put_failure;
-	return 0;
+	return false;
 
 nla_put_failure:
-	return 1;
+	return true;
 }
 
 static inline void
@@ -387,10 +387,10 @@ hash_netportnet6_data_list(struct sk_buff *skb,
 	    (flags &&
 	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS, htonl(flags))))
 		goto nla_put_failure;
-	return 0;
+	return false;
 
 nla_put_failure:
-	return 1;
+	return true;
 }
 
 static inline void
-- 
1.8.5.1

