From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 05/11] kernel: const annotations
Date: Sun, 19 Dec 2010 06:18:07 +0100
Message-ID: <1292735894-17534-6-git-send-email-jengelh@medozas.de>
References: <1292735894-17534-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42667 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025Ab0LSFSV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 19 Dec 2010 00:18:21 -0500
In-Reply-To: <1292735894-17534-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 kernel/include/linux/netfilter/ipset/ip_set.h      |    2 +-
 .../include/linux/netfilter/ipset/ip_set_ahash.h   |    4 +-
 kernel/ip_set.c                                    |    8 +++---
 kernel/ip_set_bitmap_ip.c                          |   14 ++++++------
 kernel/ip_set_bitmap_ipmac.c                       |   10 ++++----
 kernel/ip_set_bitmap_port.c                        |   22 ++++++++++----------
 kernel/ip_set_hash_ip.c                            |   12 +++++-----
 kernel/ip_set_hash_ipport.c                        |   12 +++++-----
 kernel/ip_set_hash_ipportip.c                      |   12 +++++-----
 kernel/ip_set_hash_ipportnet.c                     |   12 +++++-----
 kernel/ip_set_hash_net.c                           |   12 +++++-----
 kernel/ip_set_hash_netport.c                       |   12 +++++-----
 kernel/ip_set_list_set.c                           |   10 ++++----
 13 files changed, 71 insertions(+), 71 deletions(-)

diff --git a/kernel/include/linux/netfilter/ipset/ip_set.h b/kernel/include/linux/netfilter/ipset/ip_set.h
index 23661c4..a3e4bb9 100644
--- a/kernel/include/linux/netfilter/ipset/ip_set.h
+++ b/kernel/include/linux/netfilter/ipset/ip_set.h
@@ -240,7 +240,7 @@ struct ip_set_type_variant {
 	/* List set header data */
 	int (*head)(struct ip_set *set, struct sk_buff *skb);
 	/* List elements */
-	int (*list)(struct ip_set *set, struct sk_buff *skb,
+	int (*list)(const struct ip_set *set, struct sk_buff *skb,
 		    struct netlink_callback *cb);
 
 	/* Return true if "b" set is the same as "a"
diff --git a/kernel/include/linux/netfilter/ipset/ip_set_ahash.h b/kernel/include/linux/netfilter/ipset/ip_set_ahash.h
index 589b157..7e0af3d 100644
--- a/kernel/include/linux/netfilter/ipset/ip_set_ahash.h
+++ b/kernel/include/linux/netfilter/ipset/ip_set_ahash.h
@@ -530,7 +530,7 @@ nla_put_failure:
 
 /* Reply a LIST/SAVE request: dump the elements of the specified set */
 static int
-type_pf_list(struct ip_set *set,
+type_pf_list(const struct ip_set *set,
 	     struct sk_buff *skb, struct netlink_callback *cb)
 {
 	const struct ip_set_hash *h = set->data;
@@ -931,7 +931,7 @@ type_pf_ttest(struct ip_set *set, void *value, u32 timeout)
 }
 
 static int
-type_pf_tlist(struct ip_set *set,
+type_pf_tlist(const struct ip_set *set,
 	      struct sk_buff *skb, struct netlink_callback *cb)
 {
 	const struct ip_set_hash *h = set->data;
diff --git a/kernel/ip_set.c b/kernel/ip_set.c
index 038a70e..c778670 100644
--- a/kernel/ip_set.c
+++ b/kernel/ip_set.c
@@ -623,7 +623,7 @@ EXPORT_SYMBOL(ip_set_put_byindex);
 const char *
 ip_set_name_byindex(ip_set_id_t index)
 {
-	struct ip_set *set = ip_set_list[index];
+	const struct ip_set *set = ip_set_list[index];
 
 	BUG_ON(set == NULL);
 	BUG_ON(atomic_read(&set->ref) == 0);
@@ -762,7 +762,7 @@ static ip_set_id_t
 find_set_id(const char *name)
 {
 	ip_set_id_t i, index = IPSET_INVALID_ID;
-	struct ip_set *set;
+	const struct ip_set *set;
 
 	for (i = 0; index == IPSET_INVALID_ID && i < ip_set_max; i++) {
 		set = ip_set_list[i];
@@ -1141,7 +1141,7 @@ ip_set_dump_done(struct netlink_callback *cb)
 static inline void
 dump_attrs(struct nlmsghdr *nlh)
 {
-	struct nlattr *attr;
+	const struct nlattr *attr;
 	int rem;
 
 	pr_debug("dump nlmsg");
@@ -1472,7 +1472,7 @@ ip_set_header(struct sock *ctnl, struct sk_buff *skb,
 	      NFNL_CB_CONST struct nlmsghdr *nlh,
 	      NFNL_CB_CONST struct nlattr * NFNL_CB_CONST attr[])
 {
-	struct ip_set *set;
+	const struct ip_set *set;
 	struct sk_buff *skb2;
 	struct nlmsghdr *nlh2;
 	ip_set_id_t index;
diff --git a/kernel/ip_set_bitmap_ip.c b/kernel/ip_set_bitmap_ip.c
index 2f124ec..9948080 100644
--- a/kernel/ip_set_bitmap_ip.c
+++ b/kernel/ip_set_bitmap_ip.c
@@ -220,7 +220,7 @@ nla_put_failure:
 }
 
 static int
-bitmap_ip_list(struct ip_set *set,
+bitmap_ip_list(const struct ip_set *set,
 	       struct sk_buff *skb, struct netlink_callback *cb)
 {
 	const struct bitmap_ip *map = set->data;
@@ -260,8 +260,8 @@ nla_put_failure:
 static bool
 bitmap_ip_same_set(const struct ip_set *a, const struct ip_set *b)
 {
-	struct bitmap_ip *x = a->data;
-	struct bitmap_ip *y = b->data;
+	const struct bitmap_ip *x = a->data;
+	const struct bitmap_ip *y = b->data;
 
 	return x->first_ip == y->first_ip
 	       && x->last_ip == y->last_ip
@@ -462,13 +462,13 @@ nla_put_failure:
 }
 
 static int
-bitmap_ip_timeout_list(struct ip_set *set,
+bitmap_ip_timeout_list(const struct ip_set *set,
 		       struct sk_buff *skb, struct netlink_callback *cb)
 {
 	const struct bitmap_ip_timeout *map = set->data;
 	struct nlattr *adt, *nested;
 	u32 id, first = cb->args[2];
-	unsigned long *table = map->members;
+	const unsigned long *table = map->members;
 
 	adt = ipset_nest_start(skb, IPSET_ATTR_ADT);
 	if (!adt)
@@ -507,8 +507,8 @@ nla_put_failure:
 static bool
 bitmap_ip_timeout_same_set(const struct ip_set *a, const struct ip_set *b)
 {
-	struct bitmap_ip_timeout *x = a->data;
-	struct bitmap_ip_timeout *y = b->data;
+	const struct bitmap_ip_timeout *x = a->data;
+	const struct bitmap_ip_timeout *y = b->data;
 
 	return x->first_ip == y->first_ip
 	       && x->last_ip == y->last_ip
diff --git a/kernel/ip_set_bitmap_ipmac.c b/kernel/ip_set_bitmap_ipmac.c
index 0bd9a89..1fae782 100644
--- a/kernel/ip_set_bitmap_ipmac.c
+++ b/kernel/ip_set_bitmap_ipmac.c
@@ -164,7 +164,7 @@ bitmap_ipmac_del(struct ip_set *set, void *value, u32 timeout)
 }
 
 static int
-bitmap_ipmac_list(struct ip_set *set,
+bitmap_ipmac_list(const struct ip_set *set,
 		  struct sk_buff *skb, struct netlink_callback *cb)
 {
 	const struct bitmap_ipmac *map = set->data;
@@ -287,7 +287,7 @@ bitmap_ipmac_tdel(struct ip_set *set, void *value, u32 timeout)
 }
 
 static int
-bitmap_ipmac_tlist(struct ip_set *set,
+bitmap_ipmac_tlist(const struct ip_set *set,
 		   struct sk_buff *skb, struct netlink_callback *cb)
 {
 	const struct bitmap_ipmac *map = set->data;
@@ -369,7 +369,7 @@ static int
 bitmap_ipmac_uadt(struct ip_set *set, struct nlattr *head, int len,
 		  enum ipset_adt adt, u32 *lineno, u32 flags)
 {
-	struct bitmap_ipmac *map = set->data;
+	const struct bitmap_ipmac *map = set->data;
 	struct nlattr *tb[IPSET_ATTR_ADT_MAX+1];
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct ipmac data;
@@ -460,8 +460,8 @@ nla_put_failure:
 static bool
 bitmap_ipmac_same_set(const struct ip_set *a, const struct ip_set *b)
 {
-	struct bitmap_ipmac *x = a->data;
-	struct bitmap_ipmac *y = b->data;
+	const struct bitmap_ipmac *x = a->data;
+	const struct bitmap_ipmac *y = b->data;
 
 	return x->first_ip == y->first_ip
 	       && x->last_ip == y->last_ip
diff --git a/kernel/ip_set_bitmap_port.c b/kernel/ip_set_bitmap_port.c
index eccef08..c7f402a 100644
--- a/kernel/ip_set_bitmap_port.c
+++ b/kernel/ip_set_bitmap_port.c
@@ -181,7 +181,7 @@ bitmap_port_flush(struct ip_set *set)
 static int
 bitmap_port_head(struct ip_set *set, struct sk_buff *skb)
 {
-	struct bitmap_port *map = set->data;
+	const struct bitmap_port *map = set->data;
 	struct nlattr *nested;
 
 	nested = ipset_nest_start(skb, IPSET_ATTR_DATA);
@@ -201,10 +201,10 @@ nla_put_failure:
 }
 
 static int
-bitmap_port_list(struct ip_set *set,
+bitmap_port_list(const struct ip_set *set,
 		 struct sk_buff *skb, struct netlink_callback *cb)
 {
-	struct bitmap_port *map = set->data;
+	const struct bitmap_port *map = set->data;
 	struct nlattr *atd, *nested;
 	u16 id, first = cb->args[2];
 	u16 last = map->last_port - map->first_port;
@@ -243,8 +243,8 @@ nla_put_failure:
 static bool
 bitmap_port_same_set(const struct ip_set *a, const struct ip_set *b)
 {
-	struct bitmap_port *x = a->data;
-	struct bitmap_port *y = b->data;
+	const struct bitmap_port *x = a->data;
+	const struct bitmap_port *y = b->data;
 
 	return x->first_port == y->first_port
 	       && x->last_port == y->last_port;
@@ -413,7 +413,7 @@ bitmap_port_timeout_flush(struct ip_set *set)
 static int
 bitmap_port_timeout_head(struct ip_set *set, struct sk_buff *skb)
 {
-	struct bitmap_port_timeout *map = set->data;
+	const struct bitmap_port_timeout *map = set->data;
 	struct nlattr *nested;
 
 	nested = ipset_nest_start(skb, IPSET_ATTR_DATA);
@@ -434,14 +434,14 @@ nla_put_failure:
 }
 
 static int
-bitmap_port_timeout_list(struct ip_set *set,
+bitmap_port_timeout_list(const struct ip_set *set,
 			 struct sk_buff *skb, struct netlink_callback *cb)
 {
-	struct bitmap_port_timeout *map = set->data;
+	const struct bitmap_port_timeout *map = set->data;
 	struct nlattr *adt, *nested;
 	u16 id, first = cb->args[2];
 	u16 last = map->last_port - map->first_port;
-	unsigned long *table = map->members;
+	const unsigned long *table = map->members;
 
 	adt = ipset_nest_start(skb, IPSET_ATTR_ADT);
 	if (!adt)
@@ -480,8 +480,8 @@ nla_put_failure:
 static bool
 bitmap_port_timeout_same_set(const struct ip_set *a, const struct ip_set *b)
 {
-	struct bitmap_port_timeout *x = a->data;
-	struct bitmap_port_timeout *y = b->data;
+	const struct bitmap_port_timeout *x = a->data;
+	const struct bitmap_port_timeout *y = b->data;
 
 	return x->first_port == y->first_port
 	       && x->last_port == y->last_port
diff --git a/kernel/ip_set_hash_ip.c b/kernel/ip_set_hash_ip.c
index 6859ac8..baacf4c 100644
--- a/kernel/ip_set_hash_ip.c
+++ b/kernel/ip_set_hash_ip.c
@@ -121,7 +121,7 @@ static int
 hash_ip4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	      enum ipset_adt adt, u8 pf, u8 dim, u8 flags)
 {
-	struct ip_set_hash *h = set->data;
+	const struct ip_set_hash *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	u32 ip;
 
@@ -145,7 +145,7 @@ static int
 hash_ip4_uadt(struct ip_set *set, struct nlattr *head, int len,
 	      enum ipset_adt adt, u32 *lineno, u32 flags)
 {
-	struct ip_set_hash *h = set->data;
+	const struct ip_set_hash *h = set->data;
 	struct nlattr *tb[IPSET_ATTR_ADT_MAX+1];
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	u32 ip, nip, ip_to, hosts, timeout = h->timeout;
@@ -210,8 +210,8 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *head, int len,
 static bool
 hash_ip_same_set(const struct ip_set *a, const struct ip_set *b)
 {
-	struct ip_set_hash *x = a->data;
-	struct ip_set_hash *y = b->data;
+	const struct ip_set_hash *x = a->data;
+	const struct ip_set_hash *y = b->data;
 
 	/* Resizing changes htable_bits, so we ignore it */
 	return x->maxelem == y->maxelem
@@ -310,7 +310,7 @@ static int
 hash_ip6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	      enum ipset_adt adt, u8 pf, u8 dim, u8 flags)
 {
-	struct ip_set_hash *h = set->data;
+	const struct ip_set_hash *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	union nf_inet_addr ip;
 
@@ -332,7 +332,7 @@ static int
 hash_ip6_uadt(struct ip_set *set, struct nlattr *head, int len,
 	      enum ipset_adt adt, u32 *lineno, u32 flags)
 {
-	struct ip_set_hash *h = set->data;
+	const struct ip_set_hash *h = set->data;
 	struct nlattr *tb[IPSET_ATTR_ADT_MAX+1];
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	union nf_inet_addr ip;
diff --git a/kernel/ip_set_hash_ipport.c b/kernel/ip_set_hash_ipport.c
index f9db93d..f9826a2 100644
--- a/kernel/ip_set_hash_ipport.c
+++ b/kernel/ip_set_hash_ipport.c
@@ -140,7 +140,7 @@ static int
 hash_ipport4_kadt(struct ip_set *set, const struct sk_buff *skb,
 		  enum ipset_adt adt, u8 pf, u8 dim, u8 flags)
 {
-	struct ip_set_hash *h = set->data;
+	const struct ip_set_hash *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipport4_elem data = { };
 
@@ -169,7 +169,7 @@ static int
 hash_ipport4_uadt(struct ip_set *set, struct nlattr *head, int len,
 		  enum ipset_adt adt, u32 *lineno, u32 flags)
 {
-	struct ip_set_hash *h = set->data;
+	const struct ip_set_hash *h = set->data;
 	struct nlattr *tb[IPSET_ATTR_ADT_MAX+1];
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipport4_elem data = { };
@@ -268,8 +268,8 @@ hash_ipport4_uadt(struct ip_set *set, struct nlattr *head, int len,
 static bool
 hash_ipport_same_set(const struct ip_set *a, const struct ip_set *b)
 {
-	struct ip_set_hash *x = a->data;
-	struct ip_set_hash *y = b->data;
+	const struct ip_set_hash *x = a->data;
+	const struct ip_set_hash *y = b->data;
 
 	/* Resizing changes htable_bits, so we ignore it */
 	return x->maxelem == y->maxelem
@@ -374,7 +374,7 @@ static int
 hash_ipport6_kadt(struct ip_set *set, const struct sk_buff *skb,
 		  enum ipset_adt adt, u8 pf, u8 dim, u8 flags)
 {
-	struct ip_set_hash *h = set->data;
+	const struct ip_set_hash *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipport6_elem data = { };
 
@@ -391,7 +391,7 @@ static int
 hash_ipport6_uadt(struct ip_set *set, struct nlattr *head, int len,
 		  enum ipset_adt adt, u32 *lineno, u32 flags)
 {
-	struct ip_set_hash *h = set->data;
+	const struct ip_set_hash *h = set->data;
 	struct nlattr *tb[IPSET_ATTR_ADT_MAX+1];
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipport6_elem data = { };
diff --git a/kernel/ip_set_hash_ipportip.c b/kernel/ip_set_hash_ipportip.c
index 5511bbf..a047c0e 100644
--- a/kernel/ip_set_hash_ipportip.c
+++ b/kernel/ip_set_hash_ipportip.c
@@ -145,7 +145,7 @@ static int
 hash_ipportip4_kadt(struct ip_set *set, const struct sk_buff *skb,
 		    enum ipset_adt adt, u8 pf, u8 dim, u8 flags)
 {
-	struct ip_set_hash *h = set->data;
+	const struct ip_set_hash *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipportip4_elem data = { };
 
@@ -176,7 +176,7 @@ static int
 hash_ipportip4_uadt(struct ip_set *set, struct nlattr *head, int len,
 		    enum ipset_adt adt, u32 *lineno, u32 flags)
 {
-	struct ip_set_hash *h = set->data;
+	const struct ip_set_hash *h = set->data;
 	struct nlattr *tb[IPSET_ATTR_ADT_MAX+1];
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipportip4_elem data = { };
@@ -279,8 +279,8 @@ hash_ipportip4_uadt(struct ip_set *set, struct nlattr *head, int len,
 static bool
 hash_ipportip_same_set(const struct ip_set *a, const struct ip_set *b)
 {
-	struct ip_set_hash *x = a->data;
-	struct ip_set_hash *y = b->data;
+	const struct ip_set_hash *x = a->data;
+	const struct ip_set_hash *y = b->data;
 
 	/* Resizing changes htable_bits, so we ignore it */
 	return x->maxelem == y->maxelem
@@ -390,7 +390,7 @@ static int
 hash_ipportip6_kadt(struct ip_set *set, const struct sk_buff *skb,
 		    enum ipset_adt adt, u8 pf, u8 dim, u8 flags)
 {
-	struct ip_set_hash *h = set->data;
+	const struct ip_set_hash *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipportip6_elem data = { };
 
@@ -408,7 +408,7 @@ static int
 hash_ipportip6_uadt(struct ip_set *set, struct nlattr *head, int len,
 		    enum ipset_adt adt, u32 *lineno, u32 flags)
 {
-	struct ip_set_hash *h = set->data;
+	const struct ip_set_hash *h = set->data;
 	struct nlattr *tb[IPSET_ATTR_ADT_MAX+1];
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipportip6_elem data = { };
diff --git a/kernel/ip_set_hash_ipportnet.c b/kernel/ip_set_hash_ipportnet.c
index 5775c57..08e0de9 100644
--- a/kernel/ip_set_hash_ipportnet.c
+++ b/kernel/ip_set_hash_ipportnet.c
@@ -158,7 +158,7 @@ static int
 hash_ipportnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
 		     enum ipset_adt adt, u8 pf, u8 dim, u8 flags)
 {
-	struct ip_set_hash *h = set->data;
+	const struct ip_set_hash *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipportnet4_elem data =
 		{ .cidr = h->nets[0].cidr || HOST_MASK };
@@ -197,7 +197,7 @@ static int
 hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *head, int len,
 		     enum ipset_adt adt, u32 *lineno, u32 flags)
 {
-	struct ip_set_hash *h = set->data;
+	const struct ip_set_hash *h = set->data;
 	struct nlattr *tb[IPSET_ATTR_ADT_MAX+1];
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipportnet4_elem data = { .cidr = HOST_MASK };
@@ -308,8 +308,8 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *head, int len,
 static bool
 hash_ipportnet_same_set(const struct ip_set *a, const struct ip_set *b)
 {
-	struct ip_set_hash *x = a->data;
-	struct ip_set_hash *y = b->data;
+	const struct ip_set_hash *x = a->data;
+	const struct ip_set_hash *y = b->data;
 	
 	/* Resizing changes htable_bits, so we ignore it */
 	return x->maxelem == y->maxelem
@@ -438,7 +438,7 @@ static int
 hash_ipportnet6_kadt(struct ip_set *set, const struct sk_buff *skb,
 		     enum ipset_adt adt, u8 pf, u8 dim, u8 flags)
 {
-	struct ip_set_hash *h = set->data;
+	const struct ip_set_hash *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipportnet6_elem data =
 		{ .cidr = h->nets[0].cidr || HOST_MASK };
@@ -463,7 +463,7 @@ static int
 hash_ipportnet6_uadt(struct ip_set *set, struct nlattr *head, int len,
 		     enum ipset_adt adt, u32 *lineno, u32 flags)
 {
-	struct ip_set_hash *h = set->data;
+	const struct ip_set_hash *h = set->data;
 	struct nlattr *tb[IPSET_ATTR_ADT_MAX+1];
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipportnet6_elem data = { .cidr = HOST_MASK };
diff --git a/kernel/ip_set_hash_net.c b/kernel/ip_set_hash_net.c
index 5e3086b..499f805 100644
--- a/kernel/ip_set_hash_net.c
+++ b/kernel/ip_set_hash_net.c
@@ -140,7 +140,7 @@ static int
 hash_net4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	       enum ipset_adt adt, u8 pf, u8 dim, u8 flags)
 {
-	struct ip_set_hash *h = set->data;
+	const struct ip_set_hash *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_net4_elem data = { .cidr = h->nets[0].cidr || HOST_MASK };
 
@@ -165,7 +165,7 @@ static int
 hash_net4_uadt(struct ip_set *set, struct nlattr *head, int len,
 	       enum ipset_adt adt, u32 *lineno, u32 flags)
 {
-	struct ip_set_hash *h = set->data;
+	const struct ip_set_hash *h = set->data;
 	struct nlattr *tb[IPSET_ATTR_ADT_MAX+1];
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_net4_elem data = { .cidr = HOST_MASK };
@@ -205,8 +205,8 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *head, int len,
 static bool
 hash_net_same_set(const struct ip_set *a, const struct ip_set *b)
 {
-	struct ip_set_hash *x = a->data;
-	struct ip_set_hash *y = b->data;
+	const struct ip_set_hash *x = a->data;
+	const struct ip_set_hash *y = b->data;
 
 	/* Resizing changes htable_bits, so we ignore it */
 	return x->maxelem == y->maxelem
@@ -322,7 +322,7 @@ static int
 hash_net6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	       enum ipset_adt adt, u8 pf, u8 dim, u8 flags)
 {
-	struct ip_set_hash *h = set->data;
+	const struct ip_set_hash *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_net6_elem data = { .cidr = h->nets[0].cidr || HOST_MASK };
 
@@ -341,7 +341,7 @@ static int
 hash_net6_uadt(struct ip_set *set, struct nlattr *head, int len,
 	       enum ipset_adt adt, u32 *lineno, u32 flags)
 {
-	struct ip_set_hash *h = set->data;
+	const struct ip_set_hash *h = set->data;
 	struct nlattr *tb[IPSET_ATTR_ADT_MAX+1];
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_net6_elem data = { .cidr = HOST_MASK };
diff --git a/kernel/ip_set_hash_netport.c b/kernel/ip_set_hash_netport.c
index c3f47a1..9233ce0 100644
--- a/kernel/ip_set_hash_netport.c
+++ b/kernel/ip_set_hash_netport.c
@@ -154,7 +154,7 @@ static int
 hash_netport4_kadt(struct ip_set *set, const struct sk_buff *skb,
 		   enum ipset_adt adt, u8 pf, u8 dim, u8 flags)
 {
-	struct ip_set_hash *h = set->data;
+	const struct ip_set_hash *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netport4_elem data = {
 		.cidr = h->nets[0].cidr || HOST_MASK };
@@ -189,7 +189,7 @@ static int
 hash_netport4_uadt(struct ip_set *set, struct nlattr *head, int len,
 		   enum ipset_adt adt, u32 *lineno, u32 flags)
 {
-	struct ip_set_hash *h = set->data;
+	const struct ip_set_hash *h = set->data;
 	struct nlattr *tb[IPSET_ATTR_ADT_MAX+1];
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netport4_elem data = { .cidr = HOST_MASK };
@@ -270,8 +270,8 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *head, int len,
 static bool
 hash_netport_same_set(const struct ip_set *a, const struct ip_set *b)
 {
-	struct ip_set_hash *x = a->data;
-	struct ip_set_hash *y = b->data;
+	const struct ip_set_hash *x = a->data;
+	const struct ip_set_hash *y = b->data;
 
 	/* Resizing changes htable_bits, so we ignore it */
 	return x->maxelem == y->maxelem
@@ -395,7 +395,7 @@ static int
 hash_netport6_kadt(struct ip_set *set, const struct sk_buff *skb,
 		   enum ipset_adt adt, u8 pf, u8 dim, u8 flags)
 {
-	struct ip_set_hash *h = set->data;
+	const struct ip_set_hash *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netport6_elem data = {
 		.cidr = h->nets[0].cidr || HOST_MASK };
@@ -419,7 +419,7 @@ static int
 hash_netport6_uadt(struct ip_set *set, struct nlattr *head, int len,
 		   enum ipset_adt adt, u32 *lineno, u32 flags)
 {
-	struct ip_set_hash *h = set->data;
+	const struct ip_set_hash *h = set->data;
 	struct nlattr *tb[IPSET_ATTR_ADT_MAX+1];
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netport6_elem data = { .cidr = HOST_MASK };
diff --git a/kernel/ip_set_list_set.c b/kernel/ip_set_list_set.c
index 07d9929..8c3e9b3 100644
--- a/kernel/ip_set_list_set.c
+++ b/kernel/ip_set_list_set.c
@@ -169,7 +169,7 @@ static int
 list_set_add(struct list_set *map, u32 i, ip_set_id_t id,
 	     unsigned long timeout)
 {
-	struct set_elem *e = list_set_elem(map, i);
+	const struct set_elem *e = list_set_elem(map, i);
 
 	if (i == map->size - 1 && e->id != IPSET_INVALID_ID)
 		/* Last element replaced: e.g. add new,before,last */
@@ -214,7 +214,7 @@ list_set_uadt(struct ip_set *set, struct nlattr *head, int len,
 	int before = 0;
 	u32 timeout = map->timeout;
 	ip_set_id_t id, refid = IPSET_INVALID_ID;
-	struct set_elem *elem;
+	const struct set_elem *elem;
 	struct ip_set *s;
 	u32 i;
 	int ret = 0;
@@ -395,7 +395,7 @@ nla_put_failure:
 }
 
 static int
-list_set_list(struct ip_set *set,
+list_set_list(const struct ip_set *set,
 	      struct sk_buff *skb, struct netlink_callback *cb)
 {
 	const struct list_set *map = set->data;
@@ -446,8 +446,8 @@ nla_put_failure:
 static bool
 list_set_same_set(const struct ip_set *a, const struct ip_set *b)
 {
-	struct list_set *x = a->data;
-	struct list_set *y = b->data;
+	const struct list_set *x = a->data;
+	const struct list_set *y = b->data;
 
 	return x->size == y->size
 	       && x->timeout == y->timeout;
-- 
1.7.1

