Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A047851120D
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Sep 2026 18:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788548064; cv=none; b=TlPwkGt3FbUwI6Vrm2WDz/O98KITGTUMlRTbRNRfh36kcapNNK9wE/0igVSxP6ofthpAOhH/yTE53QLXhSmo448Y+WSpdYzoOGWI3c7Co7B/oOcXh7AqlqA+szzcomh2HD/dMTIFm0PVQrnLyjUes+gOrL/6sSileKKK9avLaOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788548064; c=relaxed/simple;
	bh=mQzst/RLYiqCcgh+YA9YYJy+B+Vcd1PlqQ6IS9JeAbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fF18BB49CMBlauzudKyF+NojPUGj0H4ZjsE/G7Xa8HZ/KnyV2U1XRi3+SMjG1ZbFYMKtMCxsFy3pPW3jSHXrdgd+CBHR+OEhtmldFL/Y1L44dCQ+kGgPGZ7EcxgJPMllfbeWXtoFON2uw+4DCAUOqk29KHjJQT9nSDxlveTpIBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id AA7EB60E1B; Fri, 04 Sep 2026 20:54:20 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v4 11/13] netfilter: ipset: remove trivial kvfree wrapper
Date: Fri,  4 Sep 2026 20:53:19 +0200
Message-ID: <20260904185321.30313-12-fw@strlen.de>
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

This is a leftover from the days when kvmalloc/kvfree did not exist.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/ipset/ip_set.h    |  7 +++++--
 net/netfilter/ipset/ip_set_bitmap_gen.h   |  4 ++--
 net/netfilter/ipset/ip_set_bitmap_ip.c    |  2 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c |  2 +-
 net/netfilter/ipset/ip_set_bitmap_port.c  |  2 +-
 net/netfilter/ipset/ip_set_core.c         | 17 -----------------
 6 files changed, 10 insertions(+), 24 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 9a0a2944700b..b2ff881e2ec1 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -318,8 +318,6 @@ extern int ip_set_test(ip_set_id_t id, const struct sk_buff *skb,
 		       struct ip_set_adt_opt *opt);
 
 /* Utility functions */
-extern void *ip_set_alloc(size_t size);
-extern void ip_set_free(void *members);
 extern int ip_set_get_ipaddr4(struct nlattr *nla,  __be32 *ipaddr);
 extern int ip_set_get_ipaddr6(struct nlattr *nla, union nf_inet_addr *ipaddr);
 extern size_t ip_set_elem_len(struct ip_set *set, struct nlattr *tb[],
@@ -333,6 +331,11 @@ extern bool ip_set_match_extensions(struct ip_set *set,
 				    struct ip_set_ext *mext,
 				    u32 flags, void *data);
 
+static inline void *ip_set_alloc(size_t size)
+{
+	return kvzalloc(size, GFP_KERNEL_ACCOUNT);
+}
+
 static inline int
 ip_set_get_hostipaddr4(struct nlattr *nla, u32 *ipaddr)
 {
diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index 0b6dd2e13433..409a7d07fa8d 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -62,8 +62,8 @@ mtype_destroy(struct ip_set *set)
 
 	if (set->dsize && set->extensions & IPSET_EXT_DESTROY)
 		mtype_ext_cleanup(set);
-	ip_set_free(map->members);
-	ip_set_free(map);
+	kvfree(map->members);
+	kvfree(map);
 
 	set->data = NULL;
 }
diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
index 9307c89d2837..9252eb45d705 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -333,7 +333,7 @@ bitmap_ip_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
 	set->variant = &bitmap_ip;
 	if (!init_map_ip(set, map, first_ip, last_ip,
 			 elements, hosts, netmask)) {
-		ip_set_free(map);
+		kvfree(map);
 		return -ENOMEM;
 	}
 	if (tb[IPSET_ATTR_TIMEOUT]) {
diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 720650d0c3f1..ec8d93e8d2db 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -375,7 +375,7 @@ bitmap_ipmac_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
 	map->memsize = BITS_TO_LONGS(elements) * sizeof(unsigned long);
 	set->variant = &bitmap_ipmac;
 	if (!init_map_ipmac(set, map, first_ip, last_ip, elements)) {
-		ip_set_free(map);
+		kvfree(map);
 		return -ENOMEM;
 	}
 	if (tb[IPSET_ATTR_TIMEOUT]) {
diff --git a/net/netfilter/ipset/ip_set_bitmap_port.c b/net/netfilter/ipset/ip_set_bitmap_port.c
index ea644bd420c5..6c5d31305d43 100644
--- a/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -284,7 +284,7 @@ bitmap_port_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
 	map->memsize = BITS_TO_LONGS(elements) * sizeof(unsigned long);
 	set->variant = &bitmap_port;
 	if (!init_map_port(set, map, first_port, last_port)) {
-		ip_set_free(map);
+		kvfree(map);
 		return -ENOMEM;
 	}
 	if (tb[IPSET_ATTR_TIMEOUT]) {
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index f1378e9540a1..632e30c7f35d 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -255,23 +255,6 @@ ip_set_type_unregister(struct ip_set_type *type)
 }
 EXPORT_SYMBOL_GPL(ip_set_type_unregister);
 
-/* Utility functions */
-void *
-ip_set_alloc(size_t size)
-{
-	return kvzalloc(size, GFP_KERNEL_ACCOUNT);
-}
-EXPORT_SYMBOL_GPL(ip_set_alloc);
-
-void
-ip_set_free(void *members)
-{
-	pr_debug("%p: free with %s\n", members,
-		 is_vmalloc_addr(members) ? "vfree" : "kfree");
-	kvfree(members);
-}
-EXPORT_SYMBOL_GPL(ip_set_free);
-
 static bool
 flag_nested(const struct nlattr *nla)
 {
-- 
2.55.0

