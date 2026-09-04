Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D69523784
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Sep 2026 18:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788548056; cv=none; b=qHxmUGhJymGsY/dQWuBmpGO60vTWq/H1Cye8YV0g+I6QyJUF7R5pWyjVOjrc+4lmWmXKJcKvl1l+/2+j+Pvz574ir5G7F5cKgkar7MtIBMGmyGv96kAPaixhdpqeVNNJyy64fzStAlTIHXhoD3YGHKlD/8sC4uklsiZajf2oj9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788548056; c=relaxed/simple;
	bh=4ApzHjCrnNh19ASNUfivZfrd/4aYekNVAlT6JC2corU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I8p91gSTuAyIQ437myggRdCO4MlEQjlEj3+BrCB9A7KdbHERSPx5hTowGhZyyQM7DJZV1dLccoUBvY2IxZ7Mpm171z4QukwagzQNZY1HGD8uh3Ap9YG8nfaZn85moFdp4BUbgGOJ/5R0ky9sMR6WySAv6A9e+toB87FTBjZ0Q+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 24C2660405; Fri, 04 Sep 2026 20:54:12 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v4 09/13] netfilter: ipset: remove multi-flag
Date: Fri,  4 Sep 2026 20:53:17 +0200
Message-ID: <20260904185321.30313-10-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904185321.30313-1-fw@strlen.de>
References: <20260904185321.30313-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jozsef Kadlecsik <kadlec@netfilter.org>

This is a leftover from the old hash table that needed this to know both
when to skip already-matched identical ip/mask pairs and to know the
number of same-key elements to size the hash buckets.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipset/ip_set_hash_gen.h        | 22 +++++++-------------
 net/netfilter/ipset/ip_set_hash_ip.c         |  6 ++----
 net/netfilter/ipset/ip_set_hash_ipmac.c      |  6 ++----
 net/netfilter/ipset/ip_set_hash_ipmark.c     |  6 ++----
 net/netfilter/ipset/ip_set_hash_ipport.c     |  6 ++----
 net/netfilter/ipset/ip_set_hash_ipportip.c   |  6 ++----
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |  6 ++----
 net/netfilter/ipset/ip_set_hash_mac.c        |  3 +--
 net/netfilter/ipset/ip_set_hash_net.c        |  6 ++----
 net/netfilter/ipset/ip_set_hash_netiface.c   |  8 ++-----
 net/netfilter/ipset/ip_set_hash_netnet.c     |  6 ++----
 net/netfilter/ipset/ip_set_hash_netport.c    |  6 ++----
 net/netfilter/ipset/ip_set_hash_netportnet.c |  6 ++----
 13 files changed, 30 insertions(+), 63 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index b6614ddb9e78..973adb854082 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -278,10 +278,7 @@ static int mtype_rht_cmpfn(struct rhashtable_compare_arg *arg, const void *obj)
 #ifdef IP_SET_HASH_WITH_MULTI
 	return !mtype_key_equal(&e->elem, (const struct mtype_elem *)arg->key);
 #else
-	u32 multi = 0;
-
-	return !mtype_data_equal(&e->elem,
-				 (const struct mtype_elem *)arg->key, &multi);
+	return !mtype_data_equal(&e->elem, (const struct mtype_elem *)arg->key);
 #endif
 }
 
@@ -737,7 +734,6 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	{
 		struct rhlist_head *tmp, *list;
 		unsigned int seen = 0;
-		u32 multi = 0;
 
 		list = rhltable_lookup(&h->rhlt, d, mtype_rht_params);
 		if (!list)
@@ -749,8 +745,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 					ipset_hash_elem_destroy_free(set, old);
 				continue;
 			}
-
-			if (mtype_data_equal(&old->elem, d, &multi))
+			if (mtype_data_equal(&old->elem, d))
 				goto insert;
 			++seen;
 		}
@@ -841,10 +836,9 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		if (list) {
 			const struct mtype_rht_elem *dup;
 			struct rhlist_head *tmp;
-			u32 multi = 0;
 
 			rhl_for_each_entry_rcu(dup, tmp, list, node) {
-				if (dup == e || !mtype_data_equal(&dup->elem, d, &multi))
+				if (dup == e || !mtype_data_equal(&dup->elem, d))
 					continue;
 
 				/* check for duplicate key insertion: unlikely,
@@ -930,13 +924,12 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 #ifdef IP_SET_HASH_WITH_MULTI
 	{
 		struct rhlist_head *tmp, *list;
-		u32 multi = 0;
 
 		list = rhltable_lookup(&h->rhlt, d, mtype_rht_params);
 		if (!list)
 			goto out_unlock;
 		rhl_for_each_entry_rcu(e, tmp, list, node) {
-			if (!mtype_data_equal(&e->elem, d, &multi))
+			if (!mtype_data_equal(&e->elem, d))
 				continue;
 			if (SET_ELEM_EXPIRED(set, &e->elem))
 				goto out_unlock;
@@ -995,8 +988,8 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 #else
 	int ret, j;
 #endif
+	bool multi = false;
 	unsigned int seq0;
-	u32 multi;
 
 	pr_debug("test by nets\n");
 retry:
@@ -1035,7 +1028,7 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 		rhl_for_each_entry_rcu(e, tmp, list, node) {
 			if (!SET_ELEM_EXPIRED(set, &e->elem))
 				multi = true;
-			if (!mtype_data_equal(&e->elem, d, &multi))
+			if (!mtype_data_equal(&e->elem, d))
 				continue;
 			ret = mtype_data_match(&e->elem, ext, mext, set, flags);
 			if (ret)
@@ -1100,14 +1093,13 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 #ifdef IP_SET_HASH_WITH_MULTI
 	{
 		struct rhlist_head *tmp, *list;
-		u32 multi = 0;
 
 		list = rhltable_lookup(&h->rhlt, d, mtype_rht_params);
 		if (!list)
 			goto out;
 
 		rhl_for_each_entry_rcu(e, tmp, list, node) {
-			if (!mtype_data_equal(&e->elem, d, &multi))
+			if (!mtype_data_equal(&e->elem, d))
 				continue;
 			ret = mtype_data_match(&e->elem, ext, mext, set, flags);
 			if (ret)
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index 9b82ec5d4037..44aac980b0b2 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -49,8 +49,7 @@ struct hash_ip4_elem {
 
 static bool
 hash_ip4_data_equal(const struct hash_ip4_elem *e1,
-		    const struct hash_ip4_elem *e2,
-		    u32 *multi)
+		    const struct hash_ip4_elem *e2)
 {
 	return e1->ip == e2->ip;
 }
@@ -181,8 +180,7 @@ struct hash_ip6_elem {
 
 static bool
 hash_ip6_data_equal(const struct hash_ip6_elem *ip1,
-		    const struct hash_ip6_elem *ip2,
-		    u32 *multi)
+		    const struct hash_ip6_elem *ip2)
 {
 	return ipv6_addr_equal(&ip1->ip.in6, &ip2->ip.in6);
 }
diff --git a/net/netfilter/ipset/ip_set_hash_ipmac.c b/net/netfilter/ipset/ip_set_hash_ipmac.c
index dced4c5f3ca3..88f4931aadeb 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmac.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmac.c
@@ -50,8 +50,7 @@ struct hash_ipmac4_elem {
 
 static bool
 hash_ipmac4_data_equal(const struct hash_ipmac4_elem *e1,
-		       const struct hash_ipmac4_elem *e2,
-		       u32 *multi)
+		       const struct hash_ipmac4_elem *e2)
 {
 	return e1->ip == e2->ip && ether_addr_equal(e1->ether, e2->ether);
 }
@@ -150,8 +149,7 @@ struct hash_ipmac6_elem {
 
 static bool
 hash_ipmac6_data_equal(const struct hash_ipmac6_elem *e1,
-		       const struct hash_ipmac6_elem *e2,
-		       u32 *multi)
+		       const struct hash_ipmac6_elem *e2)
 {
 	return ipv6_addr_equal(&e1->ip.in6, &e2->ip.in6) &&
 		ether_addr_equal(e1->ether, e2->ether);
diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ipset/ip_set_hash_ipmark.c
index 6196b0112cf9..88c8239ea3b8 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -45,8 +45,7 @@ struct hash_ipmark4_elem {
 
 static bool
 hash_ipmark4_data_equal(const struct hash_ipmark4_elem *ip1,
-			const struct hash_ipmark4_elem *ip2,
-			u32 *multi)
+			const struct hash_ipmark4_elem *ip2)
 {
 	return ip1->ip == ip2->ip &&
 	       ip1->mark == ip2->mark;
@@ -181,8 +180,7 @@ struct hash_ipmark6_elem {
 
 static bool
 hash_ipmark6_data_equal(const struct hash_ipmark6_elem *ip1,
-			const struct hash_ipmark6_elem *ip2,
-			u32 *multi)
+			const struct hash_ipmark6_elem *ip2)
 {
 	return ipv6_addr_equal(&ip1->ip.in6, &ip2->ip.in6) &&
 	       ip1->mark == ip2->mark;
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index 7842ff4ad74f..f2f41700d59e 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -53,8 +53,7 @@ struct hash_ipport4_elem {
 
 static bool
 hash_ipport4_data_equal(const struct hash_ipport4_elem *ip1,
-			const struct hash_ipport4_elem *ip2,
-			u32 *multi)
+			const struct hash_ipport4_elem *ip2)
 {
 	return ip1->ip == ip2->ip &&
 	       ip1->port == ip2->port &&
@@ -223,8 +222,7 @@ struct hash_ipport6_elem {
 
 static bool
 hash_ipport6_data_equal(const struct hash_ipport6_elem *ip1,
-			const struct hash_ipport6_elem *ip2,
-			u32 *multi)
+			const struct hash_ipport6_elem *ip2)
 {
 	return ipv6_addr_equal(&ip1->ip.in6, &ip2->ip.in6) &&
 	       ip1->port == ip2->port &&
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/ipset/ip_set_hash_ipportip.c
index b1b24358c810..7e82bcd9aa42 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -49,8 +49,7 @@ struct hash_ipportip4_elem {
 
 static bool
 hash_ipportip4_data_equal(const struct hash_ipportip4_elem *ip1,
-			  const struct hash_ipportip4_elem *ip2,
-			  u32 *multi)
+			  const struct hash_ipportip4_elem *ip2)
 {
 	return ip1->ip == ip2->ip &&
 	       ip1->ip2 == ip2->ip2 &&
@@ -220,8 +219,7 @@ struct hash_ipportip6_elem {
 
 static bool
 hash_ipportip6_data_equal(const struct hash_ipportip6_elem *ip1,
-			  const struct hash_ipportip6_elem *ip2,
-			  u32 *multi)
+			  const struct hash_ipportip6_elem *ip2)
 {
 	return ipv6_addr_equal(&ip1->ip.in6, &ip2->ip.in6) &&
 	       ipv6_addr_equal(&ip1->ip2.in6, &ip2->ip2.in6) &&
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index 58a47a0f89f0..01950dbff27d 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -62,8 +62,7 @@ struct hash_ipportnet4_elem {
 
 static bool
 hash_ipportnet4_data_equal(const struct hash_ipportnet4_elem *ip1,
-			   const struct hash_ipportnet4_elem *ip2,
-			   u32 *multi)
+			   const struct hash_ipportnet4_elem *ip2)
 {
 	return ip1->ip == ip2->ip &&
 	       ip1->ip2 == ip2->ip2 &&
@@ -320,8 +319,7 @@ struct hash_ipportnet6_elem {
 
 static bool
 hash_ipportnet6_data_equal(const struct hash_ipportnet6_elem *ip1,
-			   const struct hash_ipportnet6_elem *ip2,
-			   u32 *multi)
+			   const struct hash_ipportnet6_elem *ip2)
 {
 	return ipv6_addr_equal(&ip1->ip.in6, &ip2->ip.in6) &&
 	       ipv6_addr_equal(&ip1->ip2.in6, &ip2->ip2.in6) &&
diff --git a/net/netfilter/ipset/ip_set_hash_mac.c b/net/netfilter/ipset/ip_set_hash_mac.c
index 4c195db349f7..0e7b30faddee 100644
--- a/net/netfilter/ipset/ip_set_hash_mac.c
+++ b/net/netfilter/ipset/ip_set_hash_mac.c
@@ -40,8 +40,7 @@ struct hash_mac4_elem {
 
 static bool
 hash_mac4_data_equal(const struct hash_mac4_elem *e1,
-		     const struct hash_mac4_elem *e2,
-		     u32 *multi)
+		     const struct hash_mac4_elem *e2)
 {
 	return ether_addr_equal(e1->ether, e2->ether);
 }
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/ip_set_hash_net.c
index 157660674f1d..431f0ae56054 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -50,8 +50,7 @@ struct hash_net4_elem {
 
 static bool
 hash_net4_data_equal(const struct hash_net4_elem *ip1,
-		     const struct hash_net4_elem *ip2,
-		     u32 *multi)
+		     const struct hash_net4_elem *ip2)
 {
 	return ip1->ip == ip2->ip &&
 	       ip1->cidr == ip2->cidr;
@@ -221,8 +220,7 @@ struct hash_net6_elem {
 
 static bool
 hash_net6_data_equal(const struct hash_net6_elem *ip1,
-		     const struct hash_net6_elem *ip2,
-		     u32 *multi)
+		     const struct hash_net6_elem *ip2)
 {
 	return ipv6_addr_equal(&ip1->ip.in6, &ip2->ip.in6) &&
 	       ip1->cidr == ip2->cidr;
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index 82b00337cfef..0869a62ef200 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -74,11 +74,9 @@ hash_netiface4_key_equal(const struct hash_netiface4_elem *ip1,
 
 static bool
 hash_netiface4_data_equal(const struct hash_netiface4_elem *ip1,
-			  const struct hash_netiface4_elem *ip2,
-			  u32 *multi)
+			  const struct hash_netiface4_elem *ip2)
 {
 	return hash_netiface4_key_equal(ip1, ip2) &&
-	       (++*multi) &&
 	       (ip1->wildcard ?
 		strncmp(ip1->iface, ip2->iface, strlen(ip1->iface)) == 0 :
 		strcmp(ip1->iface, ip2->iface) == 0);
@@ -314,11 +312,9 @@ hash_netiface6_key_equal(const struct hash_netiface6_elem *ip1,
 
 static bool
 hash_netiface6_data_equal(const struct hash_netiface6_elem *ip1,
-			  const struct hash_netiface6_elem *ip2,
-			  u32 *multi)
+			  const struct hash_netiface6_elem *ip2)
 {
 	return hash_netiface6_key_equal(ip1, ip2) &&
-	       (++*multi) &&
 	       (ip1->wildcard ?
 		strncmp(ip1->iface, ip2->iface, strlen(ip1->iface)) == 0 :
 		strcmp(ip1->iface, ip2->iface) == 0);
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset/ip_set_hash_netnet.c
index 4e77e40ebc2c..a6bd24e3b1ac 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -58,8 +58,7 @@ struct hash_netnet4_elem {
 
 static bool
 hash_netnet4_data_equal(const struct hash_netnet4_elem *ip1,
-			const struct hash_netnet4_elem *ip2,
-			u32 *multi)
+			const struct hash_netnet4_elem *ip2)
 {
 	return ip1->ipcmp == ip2->ipcmp &&
 	       ip1->ccmp == ip2->ccmp;
@@ -295,8 +294,7 @@ struct hash_netnet6_elem {
 
 static bool
 hash_netnet6_data_equal(const struct hash_netnet6_elem *ip1,
-			const struct hash_netnet6_elem *ip2,
-			u32 *multi)
+			const struct hash_netnet6_elem *ip2)
 {
 	return ipv6_addr_equal(&ip1->ip[0].in6, &ip2->ip[0].in6) &&
 	       ipv6_addr_equal(&ip1->ip[1].in6, &ip2->ip[1].in6) &&
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
index dfe8f995abbe..a301aff67c6d 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -60,8 +60,7 @@ struct hash_netport4_elem {
 
 static bool
 hash_netport4_data_equal(const struct hash_netport4_elem *ip1,
-			 const struct hash_netport4_elem *ip2,
-			 u32 *multi)
+			 const struct hash_netport4_elem *ip2)
 {
 	return ip1->ip == ip2->ip &&
 	       ip1->port == ip2->port &&
@@ -277,8 +276,7 @@ struct hash_netport6_elem {
 
 static bool
 hash_netport6_data_equal(const struct hash_netport6_elem *ip1,
-			 const struct hash_netport6_elem *ip2,
-			 u32 *multi)
+			 const struct hash_netport6_elem *ip2)
 {
 	return ipv6_addr_equal(&ip1->ip.in6, &ip2->ip.in6) &&
 	       ip1->port == ip2->port &&
diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
index 0dc79d37beac..8575a2c5e215 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -59,8 +59,7 @@ struct hash_netportnet4_elem {
 
 static bool
 hash_netportnet4_data_equal(const struct hash_netportnet4_elem *ip1,
-			    const struct hash_netportnet4_elem *ip2,
-			    u32 *multi)
+			    const struct hash_netportnet4_elem *ip2)
 {
 	return ip1->ipcmp == ip2->ipcmp &&
 	       ip1->ccmp == ip2->ccmp &&
@@ -352,8 +351,7 @@ struct hash_netportnet6_elem {
 
 static bool
 hash_netportnet6_data_equal(const struct hash_netportnet6_elem *ip1,
-			    const struct hash_netportnet6_elem *ip2,
-			    u32 *multi)
+			    const struct hash_netportnet6_elem *ip2)
 {
 	return ipv6_addr_equal(&ip1->ip[0].in6, &ip2->ip[0].in6) &&
 	       ipv6_addr_equal(&ip1->ip[1].in6, &ip2->ip[1].in6) &&
-- 
2.55.0

