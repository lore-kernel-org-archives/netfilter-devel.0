From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 15/15] netfilter: ipset: Whitespace and coding fixes detected by checkpatch.pl
Date: Tue,  7 Jun 2011 18:56:20 +0200
Message-ID: <1307465780-28980-16-git-send-email-kadlec@blackhole.kfki.hu>
References: <1307465780-28980-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-2-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-3-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-4-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-5-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-6-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-7-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-8-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-9-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-10-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-11-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-12-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-13-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-14-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-15-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:48724 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757192Ab1FGQ4X (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2011 12:56:23 -0400
In-Reply-To: <1307465780-28980-15-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 include/linux/netfilter/ipset/ip_set.h         |    6 ++--
 include/linux/netfilter/ipset/ip_set_ahash.h   |    2 +-
 include/linux/netfilter/ipset/ip_set_timeout.h |    2 +-
 include/linux/netfilter/ipset/pfxlen.h         |    2 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c      |    3 +-
 net/netfilter/ipset/ip_set_core.c              |    4 +-
 net/netfilter/ipset/ip_set_hash_net.c          |    4 +-
 net/netfilter/ipset/ip_set_hash_netiface.c     |   26 ++++++++++++------------
 net/netfilter/ipset/ip_set_hash_netport.c      |    2 +-
 net/netfilter/ipset/pfxlen.c                   |    2 +-
 net/netfilter/xt_set.c                         |    2 +-
 11 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index e409173..3540c6e 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -331,7 +331,7 @@ struct ip_set {
 /* register and unregister set references */
 extern ip_set_id_t ip_set_get_byname(const char *name, struct ip_set **set);
 extern void ip_set_put_byindex(ip_set_id_t index);
-extern const char * ip_set_name_byindex(ip_set_id_t index);
+extern const char *ip_set_name_byindex(ip_set_id_t index);
 extern ip_set_id_t ip_set_nfnl_get(const char *name);
 extern ip_set_id_t ip_set_nfnl_get_byindex(ip_set_id_t index);
 extern void ip_set_nfnl_put(ip_set_id_t index);
@@ -349,7 +349,7 @@ extern int ip_set_test(ip_set_id_t id, const struct sk_buff *skb,
 		       const struct ip_set_adt_opt *opt);
 
 /* Utility functions */
-extern void * ip_set_alloc(size_t size);
+extern void *ip_set_alloc(size_t size);
 extern void ip_set_free(void *members);
 extern int ip_set_get_ipaddr4(struct nlattr *nla,  __be32 *ipaddr);
 extern int ip_set_get_ipaddr6(struct nlattr *nla, union nf_inet_addr *ipaddr);
@@ -359,7 +359,7 @@ ip_set_get_hostipaddr4(struct nlattr *nla, u32 *ipaddr)
 {
 	__be32 ip;
 	int ret = ip_set_get_ipaddr4(nla, &ip);
-	
+
 	if (ret)
 		return ret;
 	*ipaddr = ntohl(ip);
diff --git a/include/linux/netfilter/ipset/ip_set_ahash.h b/include/linux/netfilter/ipset/ip_set_ahash.h
index 8a0999a..c5b06aa 100644
--- a/include/linux/netfilter/ipset/ip_set_ahash.h
+++ b/include/linux/netfilter/ipset/ip_set_ahash.h
@@ -43,7 +43,7 @@ struct htable {
 	struct hbucket bucket[0]; /* hashtable buckets */
 };
 
-#define hbucket(h, i)		&((h)->bucket[i])
+#define hbucket(h, i)		(&((h)->bucket[i]))
 
 /* Book-keeping of the prefixes added to the set */
 struct ip_set_hash_nets {
diff --git a/include/linux/netfilter/ipset/ip_set_timeout.h b/include/linux/netfilter/ipset/ip_set_timeout.h
index bae086a..4792320 100644
--- a/include/linux/netfilter/ipset/ip_set_timeout.h
+++ b/include/linux/netfilter/ipset/ip_set_timeout.h
@@ -78,7 +78,7 @@ ip_set_timeout_set(u32 timeout)
 static inline u32
 ip_set_timeout_get(unsigned long timeout)
 {
-	return timeout == IPSET_ELEM_PERMANENT ? 0 : 
+	return timeout == IPSET_ELEM_PERMANENT ? 0 :
 		jiffies_to_msecs(timeout - jiffies)/1000;
 }
 
diff --git a/include/linux/netfilter/ipset/pfxlen.h b/include/linux/netfilter/ipset/pfxlen.h
index d55a6cc..199fd11 100644
--- a/include/linux/netfilter/ipset/pfxlen.h
+++ b/include/linux/netfilter/ipset/pfxlen.h
@@ -2,7 +2,7 @@
 #define _PFXLEN_H
 
 #include <asm/byteorder.h>
-#include <linux/netfilter.h> 
+#include <linux/netfilter.h>
 #include <net/tcp.h>
 
 /* Prefixlen maps, by Jan Engelhardt  */
diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 51ab664..56096f5 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -635,7 +635,8 @@ static struct ip_set_type bitmap_ipmac_type = {
 	},
 	.adt_policy	= {
 		[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
-		[IPSET_ATTR_ETHER]	= { .type = NLA_BINARY, .len  = ETH_ALEN },
+		[IPSET_ATTR_ETHER]	= { .type = NLA_BINARY,
+					    .len  = ETH_ALEN },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
 		[IPSET_ATTR_LINENO]	= { .type = NLA_U32 },
 	},
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 4e33b19..1bd7810 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -683,8 +683,8 @@ ip_set_create(struct sock *ctnl, struct sk_buff *skb,
 	if (attr[IPSET_ATTR_DATA] &&
 	    nla_parse_nested(tb, IPSET_ATTR_CREATE_MAX, attr[IPSET_ATTR_DATA],
 			     set->type->create_policy)) {
-	    	ret = -IPSET_ERR_PROTOCOL;
-	    	goto put_out;
+		ret = -IPSET_ERR_PROTOCOL;
+		goto put_out;
 	}
 
 	ret = set->type->create(set, tb, flags);
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/ip_set_hash_net.c
index 050163f..2d4b1f4 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -187,7 +187,7 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 			return -IPSET_ERR_TIMEOUT;
 		timeout = ip_set_timeout_uget(tb[IPSET_ATTR_TIMEOUT]);
 	}
-	
+
 	if (adt == IPSET_TEST || !tb[IPSET_ATTR_IP_TO]) {
 		data.ip = htonl(ip & ip_set_hostmask(data.cidr));
 		ret = adtfn(set, &data, timeout, flags);
@@ -205,7 +205,7 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 			return -IPSET_ERR_HASH_RANGE;
 	}
 	if (retried)
-		ip = h->next.ip;		
+		ip = h->next.ip;
 	while (!after(ip, ip_to)) {
 		data.ip = htonl(ip);
 		last = ip_set_range_to_cidr(ip, ip_to, &data.cidr);
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index 51e5df1..3d6c53b 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -100,7 +100,7 @@ iface_test(struct rb_root *root, const char **iface)
 	while (n) {
 		const char *d = iface_data(n);
 		int res = ifname_compare(*iface, d);
-		
+
 		if (res < 0)
 			n = n->rb_left;
 		else if (res > 0)
@@ -118,7 +118,7 @@ iface_add(struct rb_root *root, const char **iface)
 {
 	struct rb_node **n = &(root->rb_node), *p = NULL;
 	struct iface_node *d;
-	
+
 	while (*n) {
 		char *ifname = iface_data(*n);
 		int res = ifname_compare(*iface, ifname);
@@ -296,10 +296,10 @@ hash_netiface4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	if (opt->cmdflags & IPSET_FLAG_PHYSDEV) {
 #ifdef CONFIG_BRIDGE_NETFILTER
 		const struct nf_bridge_info *nf_bridge = skb->nf_bridge;
-		
+
 		if (!nf_bridge)
 			return -EINVAL;
-		data.iface = SRCDIR ? PHYSDEV(physindev): PHYSDEV(physoutdev);
+		data.iface = SRCDIR ? PHYSDEV(physindev) : PHYSDEV(physoutdev);
 		data.physdev = 1;
 #else
 		data.iface = NULL;
@@ -350,7 +350,7 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (tb[IPSET_ATTR_CIDR]) {
 		data.cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
 		if (!data.cidr)
-			return -IPSET_ERR_INVALID_CIDR; 
+			return -IPSET_ERR_INVALID_CIDR;
 	}
 
 	if (tb[IPSET_ATTR_TIMEOUT]) {
@@ -359,7 +359,7 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 		timeout = ip_set_timeout_uget(tb[IPSET_ATTR_TIMEOUT]);
 	}
 
-	strcpy(iface, nla_data(tb[IPSET_ATTR_IFACE])); 
+	strcpy(iface, nla_data(tb[IPSET_ATTR_IFACE]));
 	data.iface = iface;
 	ret = iface_test(&h->rbtree, &data.iface);
 	if (adt == IPSET_ADD) {
@@ -372,8 +372,8 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 		return ret;
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
-		u32 flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
-		if (flags & IPSET_FLAG_PHYSDEV)
+		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+		if (cadt_flags & IPSET_FLAG_PHYSDEV)
 			data.physdev = 1;
 	}
 
@@ -559,10 +559,10 @@ hash_netiface6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	if (opt->cmdflags & IPSET_FLAG_PHYSDEV) {
 #ifdef CONFIG_BRIDGE_NETFILTER
 		const struct nf_bridge_info *nf_bridge = skb->nf_bridge;
-		
+
 		if (!nf_bridge)
 			return -EINVAL;
-		data.iface = SRCDIR ? PHYSDEV(physindev): PHYSDEV(physoutdev);
+		data.iface = SRCDIR ? PHYSDEV(physindev) : PHYSDEV(physoutdev);
 		data.physdev = 1;
 #else
 		data.iface = NULL;
@@ -623,7 +623,7 @@ hash_netiface6_uadt(struct ip_set *set, struct nlattr *tb[],
 		timeout = ip_set_timeout_uget(tb[IPSET_ATTR_TIMEOUT]);
 	}
 
-	strcpy(iface, nla_data(tb[IPSET_ATTR_IFACE])); 
+	strcpy(iface, nla_data(tb[IPSET_ATTR_IFACE]));
 	data.iface = iface;
 	ret = iface_test(&h->rbtree, &data.iface);
 	if (adt == IPSET_ADD) {
@@ -636,8 +636,8 @@ hash_netiface6_uadt(struct ip_set *set, struct nlattr *tb[],
 		return ret;
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
-		u32 flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
-		if (flags & IPSET_FLAG_PHYSDEV)
+		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
+		if (cadt_flags & IPSET_FLAG_PHYSDEV)
 			data.physdev = 1;
 	}
 
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
index d7710a9..fe203d1 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -199,7 +199,7 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (tb[IPSET_ATTR_CIDR]) {
 		data.cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
 		if (!data.cidr)
-			return -IPSET_ERR_INVALID_CIDR; 
+			return -IPSET_ERR_INVALID_CIDR;
 	}
 
 	if (tb[IPSET_ATTR_PORT])
diff --git a/net/netfilter/ipset/pfxlen.c b/net/netfilter/ipset/pfxlen.c
index b57a856..bd13d66 100644
--- a/net/netfilter/ipset/pfxlen.c
+++ b/net/netfilter/ipset/pfxlen.c
@@ -148,7 +148,7 @@ const union nf_inet_addr ip_set_netmask_map[] = {
 EXPORT_SYMBOL_GPL(ip_set_netmask_map);
 
 #undef  E
-#define E(a, b, c, d) 						\
+#define E(a, b, c, d)						\
 	{.ip6 = { (__force __be32) a, (__force __be32) b,	\
 		  (__force __be32) c, (__force __be32) d,	\
 	} }
diff --git a/net/netfilter/xt_set.c b/net/netfilter/xt_set.c
index 453847f..19461c4 100644
--- a/net/netfilter/xt_set.c
+++ b/net/netfilter/xt_set.c
@@ -37,7 +37,7 @@ match_set(ip_set_id_t index, const struct sk_buff *skb,
 	return inv;
 }
 
-#define ADT_OPT(n, f, d, fs, cfs, t) 	\
+#define ADT_OPT(n, f, d, fs, cfs, t)	\
 const struct ip_set_adt_opt n = {	\
 	.family	= f,			\
 	.dim = d,			\
-- 
1.7.0.4

