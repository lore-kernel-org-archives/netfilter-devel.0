Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2958145DF61
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2026 11:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435283; cv=none; b=PepORsCARQ3UEnHyuZKaJCJESCydYvlIuzfB5oFrzUHa6ro+HI2rR7htSlLS4u4DDEa6BiLPsOHW4Q5d3YAgkmaQbJNj+yp5k/S/7to47Jnre5QLMXEiNAEQGyPAD9ECkh8qx+RVQFtGTCqxUIZCeICHeqznuIXDjEaK4IFoHK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435283; c=relaxed/simple;
	bh=9OKczEoZZMJQ9lF9tb2BgqTNeoxLg+dDx2co7Y3PHSg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1OZCFkV6npje3V8dirQf5cGSvtAqwYBGXyI8Fbt289FwQN1R1KdpVgVBWzJtUJYeG2AtfbwZb78lcbggFKMDlsfqLnLZLLmep4+jwLQp/9+rccAr065s5cPPY+b9P447gIhX7YMiZVL5R/XrnGUMFhi2gVLZz5wblQxwx7uXDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=U2OASCf5; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="U2OASCf5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788435264;
	bh=ik0O9Ctx7Bfs3G60kokT28dEZlOsjdEQ8BdDcEH+AP8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=U2OASCf54e/mdnazRqWPfIjDNeobWtwhJC9R8Vy53r2dfakpX/Vk3BAjS4qysPx1J
	 wvZaxUa/hUZpZQVXPQXIOwRkuekyD3P+WOM2m6UONkwRlmpdAzwZAcxiW8tKHvg4k1
	 D2ddyX8q4IQl0+urxMwUkkloq0CI/OvBmkE8uWgDrIvXAr14Oe++0b3lVrSLFX+iAl
	 IEmsFduoN4/7LFlgLO1FdFpeOZA/rTYgxbNE2on47T7BeV2EEGLVTNh9F2aWGWz/Xu
	 EB4BSej3gE41QhcJuJ4JjVg0xbPNvaVw2kkNZW8l8242A1cWFgUS5OFmnQxe4kGSb/
	 hdJ+JGoJXutNQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4652A607F0
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2026 13:34:24 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 8/8] netfilter: ipset: use GFP_KERNEL_ACCOUNT
Date: Thu,  3 Sep 2026 13:34:13 +0200
Message-ID: <20260903113413.1122606-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903113413.1122606-1-pablo@netfilter.org>
References: <20260903113413.1122606-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

GFP_KERNEL_ACCOUNT is preferred these days for memcg, replace
GFP_KERNEL by GFP_KERNEL_ACCOUNT.

Use GFP_KERNEL_ACCOUNT to allocate internal datastructures in
ipset.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes. I plan to keep it back, prioritizing Florian's work
    on ipset rhashtable.

 net/netfilter/ipset/ip_set_bitmap_ip.c    | 2 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c | 2 +-
 net/netfilter/ipset/ip_set_bitmap_port.c  | 2 +-
 net/netfilter/ipset/ip_set_core.c         | 7 ++++---
 net/netfilter/ipset/ip_set_hash_gen.h     | 6 +++---
 net/netfilter/ipset/ip_set_list_set.c     | 2 +-
 6 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
index ac7febce074f..e152cf35d859 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -217,7 +217,7 @@ init_map_ip(struct ip_set *set, struct bitmap_ip *map,
 	    u32 first_ip, u32 last_ip,
 	    u32 elements, u32 hosts, u8 netmask)
 {
-	map->members = bitmap_zalloc(elements, GFP_KERNEL | __GFP_NOWARN);
+	map->members = bitmap_zalloc(elements, GFP_KERNEL_ACCOUNT | __GFP_NOWARN);
 	if (!map->members)
 		return false;
 	map->first_ip = first_ip;
diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 5921fd9d2dca..a1179352220a 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -300,7 +300,7 @@ static bool
 init_map_ipmac(struct ip_set *set, struct bitmap_ipmac *map,
 	       u32 first_ip, u32 last_ip, u32 elements)
 {
-	map->members = bitmap_zalloc(elements, GFP_KERNEL | __GFP_NOWARN);
+	map->members = bitmap_zalloc(elements, GFP_KERNEL_ACCOUNT | __GFP_NOWARN);
 	if (!map->members)
 		return false;
 	map->first_ip = first_ip;
diff --git a/net/netfilter/ipset/ip_set_bitmap_port.c b/net/netfilter/ipset/ip_set_bitmap_port.c
index ca875c982424..0a0027cdb193 100644
--- a/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -231,7 +231,7 @@ static bool
 init_map_port(struct ip_set *set, struct bitmap_port *map,
 	      u16 first_port, u16 last_port)
 {
-	map->members = bitmap_zalloc(map->elements, GFP_KERNEL | __GFP_NOWARN);
+	map->members = bitmap_zalloc(map->elements, GFP_KERNEL_ACCOUNT | __GFP_NOWARN);
 	if (!map->members)
 		return false;
 	map->first_port = first_port;
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 0a86a170ba90..28ac8cba3d68 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1085,7 +1085,7 @@ static int ip_set_create(struct sk_buff *skb, const struct nfnl_info *info,
 	/* First, and without any locks, allocate and initialize
 	 * a normal base set structure.
 	 */
-	set = kzalloc_obj(*set);
+	set = kzalloc_obj(*set, GFP_KERNEL_ACCOUNT);
 	if (!set)
 		return -ENOMEM;
 	spin_lock_init(&set->lock);
@@ -1143,7 +1143,7 @@ static int ip_set_create(struct sk_buff *skb, const struct nfnl_info *info,
 			/* Wraparound */
 			goto cleanup;
 
-		list = kvzalloc_objs(struct ip_set *, i);
+		list = kvzalloc_objs(struct ip_set *, i, GFP_KERNEL_ACCOUNT);
 		if (!list)
 			goto cleanup;
 		/* nfnl mutex is held, both lists are valid */
@@ -2397,7 +2397,8 @@ ip_set_net_init(struct net *net)
 	if (inst->ip_set_max >= IPSET_INVALID_ID)
 		inst->ip_set_max = IPSET_INVALID_ID - 1;
 
-	list = kvzalloc_objs(struct ip_set *, inst->ip_set_max);
+	list = kvzalloc_objs(struct ip_set *, inst->ip_set_max,
+			     GFP_KERNEL_ACCOUNT);
 	if (!list)
 		return -ENOMEM;
 	inst->is_deleted = false;
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 80ca523f304b..39dec9285052 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -768,7 +768,7 @@ mtype_resize(struct ip_set *set, bool retried)
 	int ret;
 
 #ifdef IP_SET_HASH_WITH_NETS
-	tmp = kmalloc(dsize, GFP_KERNEL);
+	tmp = kmalloc(dsize, GFP_KERNEL_ACCOUNT);
 	if (!tmp)
 		return -ENOMEM;
 #endif
@@ -1754,7 +1754,7 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 		sizeof(struct IPSET_TOKEN(HTYPE, 6)) :
 		sizeof(struct IPSET_TOKEN(HTYPE, 4));
 #endif
-	h = kzalloc(hsize, GFP_KERNEL);
+	h = kzalloc(hsize, GFP_KERNEL_ACCOUNT);
 	if (!h)
 		return -ENOMEM;
 
@@ -1774,7 +1774,7 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 		goto free_t;
 #ifdef IP_SET_HASH_WITH_NETS
 	for (i = 0; i < IPSET_NET_COUNT; i++) {
-		nets = kzalloc_obj(*nets);
+		nets = kzalloc_obj(*nets, GFP_KERNEL_ACCOUNT);
 		if (!nets) {
 			while (i > 0)
 				kfree(rcu_dereference_raw(h->rnets[--i]));
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index f070088742d6..750fe38261c3 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -600,7 +600,7 @@ init_list_set(struct net *net, struct ip_set *set, u32 size)
 {
 	struct list_set *map;
 
-	map = kzalloc_obj(*map);
+	map = kzalloc_obj(*map, GFP_KERNEL_ACCOUNT);
 	if (!map)
 		return false;
 
-- 
2.47.3

