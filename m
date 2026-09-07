Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95D13BB690
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 18:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788807367; cv=none; b=cAYlJdNDMlliGY/Mk8Q5QJhO6SHoWtdb0bOjbujo50qYVTysnQxx2K9KhZLo6Yps6CcOLwLv1Mk2C+yexgNMOeGPEirAWUaHe9rxSPHJT0FHCxCBRLltC1k7EAyz4BbjewE0JMZgrJugYDcyMBkI0E0WSXiV0dBMiHxffLHyjkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788807367; c=relaxed/simple;
	bh=7JEWXGf496oxKj4+O1Pa7lHk8UGk27vFpbRWPIP6/F0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YXeLtNKs/6EITn7O+MZpUjDCZK1OtWp8cgHwJD2+PTyTqQUPukkETYGOQyVTxvjSK8Nj8MXdJIQwF6/8rQ9JGUQzpQ/JE5NQpFSA6jquz/Hh5GluEvaxXqjvmGosAxva/7lQ06CxkCOqykBHOd+xBjvkW6MDYzoLfnYPhC8U8I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=W1/GNDAX; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="W1/GNDAX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788807363;
	bh=UCAk+aPY5sbolkUnCJ+cjY/uR8mKh8bwOElJpJRfouk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=W1/GNDAXN8cNjJJaXH/o8gIhU7ShhwaJ+ldMEPQDognpu/fppsKXaS8ZKkPZcyWHF
	 vXujOUoWA5pdvWxr4RKdvYqUmdLpvNF9HolRBhWmjwyouVZVeUuEHfM4dU2Mwsdymc
	 2gh7NDN0LfQDhBcTup+Gl/Ww1paqKchGiYAJq79ShoMpZsFiAVYXYhAh8LyZM/ueR5
	 LfP5NGGUNoNp59jAzSMlNzj0+1I8aOdwu7T+j5SGqETaLs9DMCArQknnxKdigL3Z0S
	 OvmHRoNrXPmcsfZErl+aMQrDtKrCMN/mojyD6s+fe+4QiBcauvpSj6ZCByZ+KGJ3jv
	 bNI+2/B9SYA5w==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A9B8B60795
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 20:56:03 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v3 8/8] netfilter: ipset: use GFP_KERNEL_ACCOUNT
Date: Mon,  7 Sep 2026 20:55:52 +0200
Message-ID: <20260907185552.1422008-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260907185552.1422008-1-pablo@netfilter.org>
References: <20260907185552.1422008-1-pablo@netfilter.org>
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
v3: no changes

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

