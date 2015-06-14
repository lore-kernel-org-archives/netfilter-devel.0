From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 10/15] netfilter:ipset Remove rbtree from hash:net,iface
Date: Sun, 14 Jun 2015 10:56:27 +0200
Message-ID: <1434272192-8620-11-git-send-email-kadlec@blackhole.kfki.hu>
References: <1434272192-8620-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:34941 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbbFNI4j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Jun 2015 04:56:39 -0400
In-Reply-To: <1434272192-8620-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove rbtree in order to introduce RCU instead of rwlock in ipset

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_netiface.c | 163 ++++-------------------------
 1 file changed, 20 insertions(+), 143 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index aac2076..3258189 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -13,7 +13,6 @@
 #include <linux/skbuff.h>
 #include <linux/errno.h>
 #include <linux/random.h>
-#include <linux/rbtree.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
 #include <net/netlink.h>
@@ -37,88 +36,13 @@ MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
 IP_SET_MODULE_DESC("hash:net,iface", IPSET_TYPE_REV_MIN, IPSET_TYPE_REV_MAX);
 MODULE_ALIAS("ip_set_hash:net,iface");
 
-/* Interface name rbtree */
-
-struct iface_node {
-	struct rb_node node;
-	char iface[IFNAMSIZ];
-};
-
-#define iface_data(n)	(rb_entry(n, struct iface_node, node)->iface)
-
-static void
-rbtree_destroy(struct rb_root *root)
-{
-	struct iface_node *node, *next;
-
-	rbtree_postorder_for_each_entry_safe(node, next, root, node)
-		kfree(node);
-
-	*root = RB_ROOT;
-}
-
-static int
-iface_test(struct rb_root *root, const char **iface)
-{
-	struct rb_node *n = root->rb_node;
-
-	while (n) {
-		const char *d = iface_data(n);
-		int res = strcmp(*iface, d);
-
-		if (res < 0)
-			n = n->rb_left;
-		else if (res > 0)
-			n = n->rb_right;
-		else {
-			*iface = d;
-			return 1;
-		}
-	}
-	return 0;
-}
-
-static int
-iface_add(struct rb_root *root, const char **iface)
-{
-	struct rb_node **n = &(root->rb_node), *p = NULL;
-	struct iface_node *d;
-
-	while (*n) {
-		char *ifname = iface_data(*n);
-		int res = strcmp(*iface, ifname);
-
-		p = *n;
-		if (res < 0)
-			n = &((*n)->rb_left);
-		else if (res > 0)
-			n = &((*n)->rb_right);
-		else {
-			*iface = ifname;
-			return 0;
-		}
-	}
-
-	d = kzalloc(sizeof(*d), GFP_ATOMIC);
-	if (!d)
-		return -ENOMEM;
-	strcpy(d->iface, *iface);
-
-	rb_link_node(&d->node, p, n);
-	rb_insert_color(&d->node, root);
-
-	*iface = d->iface;
-	return 0;
-}
-
 /* Type specific function prefix */
 #define HTYPE		hash_netiface
 #define IP_SET_HASH_WITH_NETS
-#define IP_SET_HASH_WITH_RBTREE
 #define IP_SET_HASH_WITH_MULTI
 #define IP_SET_HASH_WITH_NET0
 
-#define STREQ(a, b)	(strcmp(a, b) == 0)
+#define STRLCPY(a, b)	strlcpy(a, b, IFNAMSIZ)
 
 /* IPv4 variant */
 
@@ -137,7 +61,7 @@ struct hash_netiface4_elem {
 	u8 cidr;
 	u8 nomatch;
 	u8 elem;
-	const char *iface;
+	char iface[IFNAMSIZ];
 };
 
 /* Common functions */
@@ -151,7 +75,7 @@ hash_netiface4_data_equal(const struct hash_netiface4_elem *ip1,
 	       ip1->cidr == ip2->cidr &&
 	       (++*multi) &&
 	       ip1->physdev == ip2->physdev &&
-	       ip1->iface == ip2->iface;
+	       strcmp(ip1->iface, ip2->iface) == 0;
 }
 
 static inline int
@@ -239,7 +163,6 @@ hash_netiface4_kadt(struct ip_set *set, const struct sk_buff *skb,
 		.elem = 1,
 	};
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
-	int ret;
 
 	if (e.cidr == 0)
 		return -EINVAL;
@@ -249,35 +172,24 @@ hash_netiface4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
 	e.ip &= ip_set_netmask(e.cidr);
 
-#define IFACE(dir)	(par->dir ? par->dir->name : NULL)
+#define IFACE(dir)	(par->dir ? par->dir->name : "")
 #define SRCDIR		(opt->flags & IPSET_DIM_TWO_SRC)
 
 	if (opt->cmdflags & IPSET_FLAG_PHYSDEV) {
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
-		e.iface = SRCDIR ? get_physindev_name(skb) :
-				   get_phyoutdev_name(skb);
+		const char *eiface = SRCDIR ? get_physindev_name(skb) :
+					      get_phyoutdev_name(skb);
 
-		if (!e.iface)
+		if (!eiface)
 			return -EINVAL;
+		STRLCPY(e.iface, eiface);
 		e.physdev = 1;
-#else
-		e.iface = NULL;
 #endif
 	} else
-		e.iface = SRCDIR ? IFACE(in) : IFACE(out);
+		STRLCPY(e.iface, SRCDIR ? IFACE(in) : IFACE(out));
 
-	if (!e.iface)
+	if (strlen(e.iface) == 0)
 		return -EINVAL;
-	ret = iface_test(&h->rbtree, &e.iface);
-	if (adt == IPSET_ADD) {
-		if (!ret) {
-			ret = iface_add(&h->rbtree, &e.iface);
-			if (ret)
-				return ret;
-		}
-	} else if (!ret)
-		return ret;
-
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
 }
 
@@ -290,7 +202,6 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 	struct hash_netiface4_elem e = { .cidr = HOST_MASK, .elem = 1 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	u32 ip = 0, ip_to = 0, last;
-	char iface[IFNAMSIZ];
 	int ret;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -314,18 +225,7 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 		if (e.cidr > HOST_MASK)
 			return -IPSET_ERR_INVALID_CIDR;
 	}
-
-	strcpy(iface, nla_data(tb[IPSET_ATTR_IFACE]));
-	e.iface = iface;
-	ret = iface_test(&h->rbtree, &e.iface);
-	if (adt == IPSET_ADD) {
-		if (!ret) {
-			ret = iface_add(&h->rbtree, &e.iface);
-			if (ret)
-				return ret;
-		}
-	} else if (!ret)
-		return ret;
+	nla_strlcpy(e.iface, tb[IPSET_ATTR_IFACE], IFNAMSIZ);
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
@@ -384,7 +284,7 @@ struct hash_netiface6_elem {
 	u8 cidr;
 	u8 nomatch;
 	u8 elem;
-	const char *iface;
+	char iface[IFNAMSIZ];
 };
 
 /* Common functions */
@@ -398,7 +298,7 @@ hash_netiface6_data_equal(const struct hash_netiface6_elem *ip1,
 	       ip1->cidr == ip2->cidr &&
 	       (++*multi) &&
 	       ip1->physdev == ip2->physdev &&
-	       ip1->iface == ip2->iface;
+	       strcmp(ip1->iface, ip2->iface) == 0;
 }
 
 static inline int
@@ -473,7 +373,6 @@ hash_netiface6_kadt(struct ip_set *set, const struct sk_buff *skb,
 		.elem = 1,
 	};
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
-	int ret;
 
 	if (e.cidr == 0)
 		return -EINVAL;
@@ -485,29 +384,19 @@ hash_netiface6_kadt(struct ip_set *set, const struct sk_buff *skb,
 
 	if (opt->cmdflags & IPSET_FLAG_PHYSDEV) {
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
-		e.iface = SRCDIR ? get_physindev_name(skb) :
-				   get_phyoutdev_name(skb);
-		if (!e.iface)
+		const char *eiface = SRCDIR ? get_physindev_name(skb) :
+					      get_phyoutdev_name(skb);
+		if (!eiface)
 			return -EINVAL;
 
+		STRLCPY(e.iface, eiface);
 		e.physdev = 1;
-#else
-		e.iface = NULL;
 #endif
 	} else
-		e.iface = SRCDIR ? IFACE(in) : IFACE(out);
+		STRLCPY(e.iface, SRCDIR ? IFACE(in) : IFACE(out));
 
-	if (!e.iface)
+	if (strlen(e.iface) == 0)
 		return -EINVAL;
-	ret = iface_test(&h->rbtree, &e.iface);
-	if (adt == IPSET_ADD) {
-		if (!ret) {
-			ret = iface_add(&h->rbtree, &e.iface);
-			if (ret)
-				return ret;
-		}
-	} else if (!ret)
-		return ret;
 
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
 }
@@ -516,11 +405,9 @@ static int
 hash_netiface6_uadt(struct ip_set *set, struct nlattr *tb[],
 		   enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	struct hash_netiface *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netiface6_elem e = { .cidr = HOST_MASK, .elem = 1 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	char iface[IFNAMSIZ];
 	int ret;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -549,17 +436,7 @@ hash_netiface6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	ip6_netmask(&e.ip, e.cidr);
 
-	strcpy(iface, nla_data(tb[IPSET_ATTR_IFACE]));
-	e.iface = iface;
-	ret = iface_test(&h->rbtree, &e.iface);
-	if (adt == IPSET_ADD) {
-		if (!ret) {
-			ret = iface_add(&h->rbtree, &e.iface);
-			if (ret)
-				return ret;
-		}
-	} else if (!ret)
-		return ret;
+	nla_strlcpy(e.iface, tb[IPSET_ATTR_IFACE], IFNAMSIZ);
 
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
-- 
1.8.5.1

