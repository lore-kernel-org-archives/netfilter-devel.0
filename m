From: Massimiliano Hofer <max@nucleus.it>
Subject: [PATCH 1/2][priv_data-condition][part 1/2][core]
Date: Mon, 25 Sep 2006 10:16:33 +0200
Message-ID: <200609251016.33590.max@nucleus.it>
References: <200609250040.49298.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200609250040.49298.max@nucleus.it>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

=46rom 8fc22c9b95e4bfa7f56a303587bdcd6f01a6ce52 Mon Sep 17 00:00:00 2001
=46rom: Massimiliano Hofer <max@nucleus.it>
Date: Mon, 25 Sep 2006 10:06:12 +0200
Subject: [PATCH] priv_data

This patch adds support for instance specific data in matches and
targets.
I seize the opportunity of this massive function parameter change
to rename checkentry as init.
This is the core implementation. It won't compile without the
corresponding updates in matches and targets (in the following
patch).

Signed-off-by: Massimiliano Hofer <max@nucleus.it>
=2D--
 include/linux/netfilter/x_tables.h |   58 +++++++++------
 net/ipv4/netfilter/arp_tables.c    |   49 ++++++-------
 net/ipv4/netfilter/ip_tables.c     |  141 +++++++++++++++++---------------=
=2D---
 net/ipv6/netfilter/ip6_tables.c    |  109 +++++++++++++---------------
 net/netfilter/x_tables.c           |   95 ++++++++++++++++++++++--
 5 files changed, 258 insertions(+), 194 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x=
_tables.h
index 04319a7..e855fd2 100644
=2D-- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -20,6 +20,7 @@ struct xt_entry_match
=20
 			/* Used inside the kernel */
 			struct xt_match *match;
+			void *priv_data;
 		} kernel;
=20
 		/* Total length */
@@ -45,6 +46,7 @@ struct xt_entry_target
=20
 			/* Used inside the kernel */
 			struct xt_target *target;
+			void *priv_data;
 		} kernel;
=20
 		/* Total length */
@@ -156,18 +158,21 @@ struct xt_match
 		     const void *matchinfo,
 		     int offset,
 		     unsigned int protoff,
=2D		     int *hotdrop);
+		     int *hotdrop,
+		     void *priv_data);
=20
 	/* Called when user tries to insert an entry of this type. */
 	/* Should return true or false. */
=2D	int (*checkentry)(const char *tablename,
=2D			  const void *ip,
=2D			  const struct xt_match *match,
=2D			  void *matchinfo,
=2D			  unsigned int hook_mask);
+	int (*init)(const char *tablename,
+		    const void *ip,
+		    const struct xt_match *match,
+		    void *matchinfo,
+		    unsigned int hook_mask,
+		    void *priv_data);
=20
 	/* Called when entry of this type deleted. */
=2D	void (*destroy)(const struct xt_match *match, void *matchinfo);
+	void (*destroy)(const struct xt_match *match, void *matchinfo,
+			void *priv_data);
=20
 	/* Called when userspace align differs from kernel space one */
 	void (*compat_from_user)(void *dst, void *src);
@@ -182,6 +187,7 @@ struct xt_match
 	char *table;
 	unsigned int matchsize;
 	unsigned int compatsize;
+	size_t priv_size;
 	unsigned int hooks;
 	unsigned short proto;
=20
@@ -204,20 +210,23 @@ struct xt_target
 			       const struct net_device *out,
 			       unsigned int hooknum,
 			       const struct xt_target *target,
=2D			       const void *targinfo);
+			       const void *targinfo,
+			       void *priv_data);
=20
 	/* Called when user tries to insert an entry of this type:
            hook_mask is a bitmask of hooks from which it can be
            called. */
 	/* Should return true or false. */
=2D	int (*checkentry)(const char *tablename,
=2D			  const void *entry,
=2D			  const struct xt_target *target,
=2D			  void *targinfo,
=2D			  unsigned int hook_mask);
+	int (*init)(const char *tablename,
+		    const void *entry,
+		    const struct xt_target *target,
+		    void *targinfo,
+		    unsigned int hook_mask,
+		    void *priv_data);
=20
 	/* Called when entry of this type deleted. */
=2D	void (*destroy)(const struct xt_target *target, void *targinfo);
+	void (*destroy)(const struct xt_target *target, void *targinfo,
+			void *priv_data);
=20
 	/* Called when userspace align differs from kernel space one */
 	void (*compat_from_user)(void *dst, void *src);
@@ -229,6 +238,7 @@ struct xt_target
 	char *table;
 	unsigned int targetsize;
 	unsigned int compatsize;
+	size_t priv_size;
 	unsigned int hooks;
 	unsigned short proto;
=20
@@ -290,12 +300,16 @@ extern void xt_unregister_match(struct x
 extern int xt_register_matches(struct xt_match *match, unsigned int n);
 extern void xt_unregister_matches(struct xt_match *match, unsigned int n);
=20
=2Dextern int xt_check_match(const struct xt_match *match, unsigned short f=
amily,
=2D			  unsigned int size, const char *table, unsigned int hook,
=2D			  unsigned short proto, int inv_proto);
=2Dextern int xt_check_target(const struct xt_target *target, unsigned shor=
t family,
=2D			   unsigned int size, const char *table, unsigned int hook,
=2D			   unsigned short proto, int inv_proto);
+extern int xt_init_match(struct xt_entry_match *m, char *module_prefix,
+			 unsigned short family, const char *table,
+			 unsigned int hook_mask, unsigned short proto,
+			 int inv_proto);
+extern void xt_destroy_match(struct xt_entry_match *m);
+extern int xt_init_target(struct xt_entry_target *t, char *module_prefix,
+			  unsigned short family, const char *table,
+			  unsigned int hook_mask, unsigned short proto,
+			  int inv_proto);
+extern void xt_destroy_target(struct xt_entry_target *m);
=20
 extern int xt_register_table(struct xt_table *table,
 			     struct xt_table_info *bootstrap,
@@ -390,13 +404,13 @@ extern int xt_compat_match_offset(struct
 extern void xt_compat_match_from_user(struct xt_entry_match *m,
 				      void **dstptr, int *size);
 extern int xt_compat_match_to_user(struct xt_entry_match *m,
=2D				   void __user **dstptr, int *size);
+				   void * __user *dstptr, int *size);
=20
 extern int xt_compat_target_offset(struct xt_target *target);
 extern void xt_compat_target_from_user(struct xt_entry_target *t,
 				       void **dstptr, int *size);
 extern int xt_compat_target_to_user(struct xt_entry_target *t,
=2D				    void __user **dstptr, int *size);
+				    void * __user *dstptr, int *size);
=20
 #endif /* CONFIG_COMPAT */
 #endif /* __KERNEL__ */
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_table=
s.c
index 85f0d73..e6fbe3a 100644
=2D-- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -206,7 +206,8 @@ static unsigned int arpt_error(struct sk
 			       const struct net_device *out,
 			       unsigned int hooknum,
 			       const struct xt_target *target,
=2D			       const void *targinfo)
+			       const void *targinfo,
+			       void *priv_data)
 {
 	if (net_ratelimit())
 		printk("arp_tables: error: '%s'\n", (char *)targinfo);
@@ -294,11 +295,13 @@ unsigned int arpt_do_table(struct sk_buf
 				/* Targets which reenter must return
 				 * abs. verdicts
 				 */
=2D				verdict =3D t->u.kernel.target->target(pskb,
=2D								     in, out,
=2D								     hook,
=2D								     t->u.kernel.target,
=2D								     t->data);
+				verdict =3D t->u.kernel.target->target(
+							pskb,
+							in, out,
+							hook,
+							t->u.kernel.target,
+							t->data,
+							t->u.kernel.priv_data);
=20
 				/* Target might have changed stuff. */
 				arp =3D (*pskb)->nh.arph;
@@ -454,11 +457,10 @@ static inline int standard_check(const s
=20
 static struct arpt_target arpt_standard_target;
=20
=2Dstatic inline int check_entry(struct arpt_entry *e, const char *name, un=
signed int size,
+static inline int init_entry(struct arpt_entry *e, const char *name, unsig=
ned int size,
 			      unsigned int *i)
 {
 	struct arpt_entry_target *t;
=2D	struct arpt_target *target;
 	int ret;
=20
 	if (!arp_checkentry(&e->arp)) {
@@ -467,18 +469,9 @@ static inline int check_entry(struct arp
 	}
=20
 	t =3D arpt_get_target(e);
=2D	target =3D try_then_request_module(xt_find_target(NF_ARP, t->u.user.nam=
e,
=2D							t->u.user.revision),
=2D					 "arpt_%s", t->u.user.name);
=2D	if (IS_ERR(target) || !target) {
=2D		duprintf("check_entry: `%s' not found\n", t->u.user.name);
=2D		ret =3D target ? PTR_ERR(target) : -ENOENT;
=2D		goto out;
=2D	}
=2D	t->u.kernel.target =3D target;
+	ret =3D xt_init_target(t, "arpt", NF_ARP,
+			     name, e->comefrom, 0, 0);
=20
=2D	ret =3D xt_check_target(target, NF_ARP, t->u.target_size - sizeof(*t),
=2D			      name, e->comefrom, 0, 0);
 	if (ret)
 		goto err;
=20
@@ -487,9 +480,11 @@ static inline int check_entry(struct arp
 			ret =3D -EINVAL;
 			goto err;
 		}
=2D	} else if (t->u.kernel.target->checkentry
=2D		   && !t->u.kernel.target->checkentry(name, e, target, t->data,
=2D						      e->comefrom)) {
+	} else if (t->u.kernel.target->init
+		   && !t->u.kernel.target->init(name, e, t->u.kernel.target,
+						t->data,
+						e->comefrom,
+						t->u.kernel.priv_data)) {
 		duprintf("arp_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
 		ret =3D -EINVAL;
@@ -499,8 +494,7 @@ static inline int check_entry(struct arp
 	(*i)++;
 	return 0;
 err:
=2D	module_put(t->u.kernel.target->me);
=2Dout:
+	xt_destroy_target(t);
 	return ret;
 }
=20
@@ -555,8 +549,9 @@ static inline int cleanup_entry(struct a
=20
 	t =3D arpt_get_target(e);
 	if (t->u.kernel.target->destroy)
=2D		t->u.kernel.target->destroy(t->u.kernel.target, t->data);
=2D	module_put(t->u.kernel.target->me);
+		t->u.kernel.target->destroy(t->u.kernel.target, t->data,
+					    t->u.kernel.priv_data);
+	xt_destroy_target(t);
 	return 0;
 }
=20
@@ -629,7 +624,7 @@ static int translate_table(const char *n
 	/* Finally, each sanity check must pass */
 	i =3D 0;
 	ret =3D ARPT_ENTRY_ITERATE(entry0, newinfo->size,
=2D				 check_entry, name, size, &i);
+				 init_entry, name, size, &i);
=20
 	if (ret !=3D 0) {
 		ARPT_ENTRY_ITERATE(entry0, newinfo->size,
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 78a44b0..d96f322 100644
=2D-- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -180,7 +180,8 @@ ipt_error(struct sk_buff **pskb,
 	  const struct net_device *out,
 	  unsigned int hooknum,
 	  const struct xt_target *target,
=2D	  const void *targinfo)
+	  const void *targinfo,
+	  void *priv_data)
 {
 	if (net_ratelimit())
 		printk("ip_tables: error: `%s'\n", (char *)targinfo);
@@ -198,7 +199,8 @@ int do_match(struct ipt_entry_match *m,
 {
 	/* Stop iteration if it doesn't match */
 	if (!m->u.kernel.match->match(skb, in, out, m->u.kernel.match, m->data,
=2D				      offset, skb->nh.iph->ihl*4, hotdrop))
+				      offset, skb->nh.iph->ihl*4, hotdrop,
+				      m->u.kernel.priv_data))
 		return 1;
 	else
 		return 0;
@@ -306,7 +308,8 @@ #endif
 								     in, out,
 								     hook,
 								     t->u.kernel.target,
=2D								     t->data);
+								     t->data,
+								     t->u.kernel.priv_data);
=20
 #ifdef CONFIG_NETFILTER_DEBUG
 				if (((struct ipt_entry *)table_base)->comefrom
@@ -464,8 +467,9 @@ cleanup_match(struct ipt_entry_match *m,
 		return 1;
=20
 	if (m->u.kernel.match->destroy)
=2D		m->u.kernel.match->destroy(m->u.kernel.match, m->data);
=2D	module_put(m->u.kernel.match->me);
+		m->u.kernel.match->destroy(m->u.kernel.match, m->data,
+					   m->u.kernel.priv_data);
+	xt_destroy_match(m);
 	return 0;
 }
=20
@@ -491,33 +495,24 @@ standard_check(const struct ipt_entry_ta
 }
=20
 static inline int
=2Dcheck_match(struct ipt_entry_match *m,
=2D	    const char *name,
=2D	    const struct ipt_ip *ip,
=2D	    unsigned int hookmask,
=2D	    unsigned int *i)
+init_match(struct ipt_entry_match *m,
+	   const char *name,
+	   const struct ipt_ip *ip,
+	   unsigned int hookmask,
+	   unsigned int *i)
 {
=2D	struct ipt_match *match;
 	int ret;
=20
=2D	match =3D try_then_request_module(xt_find_match(AF_INET, m->u.user.name,
=2D						   m->u.user.revision),
=2D					"ipt_%s", m->u.user.name);
=2D	if (IS_ERR(match) || !match) {
=2D		duprintf("check_match: `%s' not found\n", m->u.user.name);
=2D		return match ? PTR_ERR(match) : -ENOENT;
=2D	}
=2D	m->u.kernel.match =3D match;
=2D
=2D	ret =3D xt_check_match(match, AF_INET, m->u.match_size - sizeof(*m),
=2D			     name, hookmask, ip->proto,
=2D			     ip->invflags & IPT_INV_PROTO);
+	ret =3D xt_init_match(m, "ipt", AF_INET,
+			    name, hookmask, ip->proto,
+			    ip->invflags & IPT_INV_PROTO);
 	if (ret)
 		goto err;
=20
=2D	if (m->u.kernel.match->checkentry
=2D	    && !m->u.kernel.match->checkentry(name, ip, match, m->data,
=2D					      hookmask)) {
+	if (m->u.kernel.match->init
+	    && !m->u.kernel.match->init(name, ip, m->u.kernel.match,
+	    				m->data,
+					hookmask, m->u.kernel.priv_data)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 m->u.kernel.match->name);
 		ret =3D -EINVAL;
@@ -527,18 +522,17 @@ check_match(struct ipt_entry_match *m,
 	(*i)++;
 	return 0;
 err:
=2D	module_put(m->u.kernel.match->me);
+	xt_destroy_match(m);
 	return ret;
 }
=20
 static struct ipt_target ipt_standard_target;
=20
 static inline int
=2Dcheck_entry(struct ipt_entry *e, const char *name, unsigned int size,
+init_entry(struct ipt_entry *e, const char *name, unsigned int size,
 	    unsigned int *i)
 {
 	struct ipt_entry_target *t;
=2D	struct ipt_target *target;
 	int ret;
 	unsigned int j;
=20
@@ -548,25 +542,14 @@ check_entry(struct ipt_entry *e, const c
 	}
=20
 	j =3D 0;
=2D	ret =3D IPT_MATCH_ITERATE(e, check_match, name, &e->ip, e->comefrom, &j=
);
+	ret =3D IPT_MATCH_ITERATE(e, init_match, name, &e->ip, e->comefrom, &j);
 	if (ret !=3D 0)
 		goto cleanup_matches;
=20
 	t =3D ipt_get_target(e);
=2D	target =3D try_then_request_module(xt_find_target(AF_INET,
=2D						     t->u.user.name,
=2D						     t->u.user.revision),
=2D					 "ipt_%s", t->u.user.name);
=2D	if (IS_ERR(target) || !target) {
=2D		duprintf("check_entry: `%s' not found\n", t->u.user.name);
=2D		ret =3D target ? PTR_ERR(target) : -ENOENT;
=2D		goto cleanup_matches;
=2D	}
=2D	t->u.kernel.target =3D target;
=2D
=2D	ret =3D xt_check_target(target, AF_INET, t->u.target_size - sizeof(*t),
=2D			      name, e->comefrom, e->ip.proto,
=2D			      e->ip.invflags & IPT_INV_PROTO);
+	ret =3D xt_init_target(t, "ipt", AF_INET,
+			     name, e->comefrom, e->ip.proto,
+			     e->ip.invflags & IPT_INV_PROTO);
 	if (ret)
 		goto err;
=20
@@ -575,9 +558,11 @@ check_entry(struct ipt_entry *e, const c
 			ret =3D -EINVAL;
 			goto err;
 		}
=2D	} else if (t->u.kernel.target->checkentry
=2D		   && !t->u.kernel.target->checkentry(name, e, target, t->data,
=2D						      e->comefrom)) {
+	} else if (t->u.kernel.target->init
+		   && !t->u.kernel.target->init(name, e, t->u.kernel.target,
+		   				t->data,
+						e->comefrom,
+						t->u.kernel.priv_data)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
 		ret =3D -EINVAL;
@@ -587,7 +572,7 @@ check_entry(struct ipt_entry *e, const c
 	(*i)++;
 	return 0;
  err:
=2D	module_put(t->u.kernel.target->me);
+	xt_destroy_target(t);
  cleanup_matches:
 	IPT_MATCH_ITERATE(e, cleanup_match, &j);
 	return ret;
@@ -648,8 +633,9 @@ cleanup_entry(struct ipt_entry *e, unsig
 	IPT_MATCH_ITERATE(e, cleanup_match, NULL);
 	t =3D ipt_get_target(e);
 	if (t->u.kernel.target->destroy)
=2D		t->u.kernel.target->destroy(t->u.kernel.target, t->data);
=2D	module_put(t->u.kernel.target->me);
+		t->u.kernel.target->destroy(t->u.kernel.target, t->data,
+					    t->u.kernel.priv_data);
+	xt_destroy_target(t);
 	return 0;
 }
=20
@@ -718,7 +704,7 @@ translate_table(const char *name,
 	/* Finally, each sanity check must pass */
 	i =3D 0;
 	ret =3D IPT_ENTRY_ITERATE(entry0, newinfo->size,
=2D				check_entry, name, size, &i);
+				init_entry, name, size, &i);
=20
 	if (ret !=3D 0) {
 		IPT_ENTRY_ITERATE(entry0, newinfo->size,
@@ -1364,15 +1350,15 @@ struct compat_ipt_replace {
 };
=20
 static inline int compat_copy_match_to_user(struct ipt_entry_match *m,
=2D		void __user **dstptr, compat_uint_t *size)
+		void * __user *dstptr, compat_uint_t *size)
 {
 	return xt_compat_match_to_user(m, dstptr, size);
 }
=20
 static int compat_copy_entry_to_user(struct ipt_entry *e,
=2D		void __user **dstptr, compat_uint_t *size)
+		void * __user *dstptr, compat_uint_t *size)
 {
=2D	struct ipt_entry_target *t;
+	struct ipt_entry_target __user *t;
 	struct compat_ipt_entry __user *ce;
 	u_int16_t target_offset, next_offset;
 	compat_uint_t origsize;
@@ -1477,7 +1463,7 @@ check_compat_entry_size_and_hooks(struct
 						     t->u.user.revision),
 					 "ipt_%s", t->u.user.name);
 	if (IS_ERR(target) || !target) {
=2D		duprintf("check_entry: `%s' not found\n", t->u.user.name);
+		duprintf("init_entry: `%s' not found\n", t->u.user.name);
 		ret =3D target ? PTR_ERR(target) : -ENOENT;
 		goto cleanup_matches;
 	}
@@ -1523,15 +1509,15 @@ static inline int compat_copy_match_from
 	match =3D m->u.kernel.match;
 	xt_compat_match_from_user(m, dstptr, size);
=20
=2D	ret =3D xt_check_match(match, AF_INET, dm->u.match_size - sizeof(*dm),
=2D			     name, hookmask, ip->proto,
=2D			     ip->invflags & IPT_INV_PROTO);
+	ret =3D xt_init_match(m, "ipt", AF_INET,
+			    name, hookmask, ip->proto,
+			    ip->invflags & IPT_INV_PROTO);
 	if (ret)
 		goto err;
=20
=2D	if (m->u.kernel.match->checkentry
=2D	    && !m->u.kernel.match->checkentry(name, ip, match, dm->data,
=2D					      hookmask)) {
+	if (m->u.kernel.match->init
+	    && !m->u.kernel.match->init(name, ip, match, dm->data,
+					hookmask, m->u.kernel.priv_data)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 m->u.kernel.match->name);
 		ret =3D -EINVAL;
@@ -1541,7 +1527,7 @@ static inline int compat_copy_match_from
 	return 0;
=20
 err:
=2D	module_put(m->u.kernel.match->me);
+	xt_destroy_match(m);
 	return ret;
 }
=20
@@ -1581,9 +1567,9 @@ static int compat_copy_entry_from_user(s
=20
 	t =3D ipt_get_target(de);
 	target =3D t->u.kernel.target;
=2D	ret =3D xt_check_target(target, AF_INET, t->u.target_size - sizeof(*t),
=2D			      name, e->comefrom, e->ip.proto,
=2D			      e->ip.invflags & IPT_INV_PROTO);
+	ret =3D xt_init_target(t, "ipt", AF_INET,
+			     name, e->comefrom, e->ip.proto,
+			     e->ip.invflags & IPT_INV_PROTO);
 	if (ret)
 		goto err;
=20
@@ -1591,9 +1577,10 @@ static int compat_copy_entry_from_user(s
 	if (t->u.kernel.target =3D=3D &ipt_standard_target) {
 		if (!standard_check(t, *size))
 			goto err;
=2D	} else if (t->u.kernel.target->checkentry
=2D		   && !t->u.kernel.target->checkentry(name, de, target,
=2D						      t->data, de->comefrom)) {
+	} else if (t->u.kernel.target->init
+		   && !t->u.kernel.target->init(name, de, target,
+						t->data, de->comefrom,
+						t->u.kernel.priv_data)) {
 		duprintf("ip_tables: compat: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
 		goto err;
@@ -1602,7 +1589,7 @@ static int compat_copy_entry_from_user(s
 	return ret;
=20
 err:
=2D	module_put(t->u.kernel.target->me);
+	xt_destroy_target(t);
 cleanup_matches:
 	IPT_MATCH_ITERATE(e, cleanup_match, &j);
 	return ret;
@@ -2090,7 +2077,8 @@ icmp_match(const struct sk_buff *skb,
 	   const void *matchinfo,
 	   int offset,
 	   unsigned int protoff,
=2D	   int *hotdrop)
+	   int *hotdrop,
+	   void *priv_data)
 {
 	struct icmphdr _icmph, *ic;
 	const struct ipt_icmp *icmpinfo =3D matchinfo;
@@ -2118,11 +2106,12 @@ icmp_match(const struct sk_buff *skb,
=20
 /* Called when user tries to insert an entry of this type. */
 static int
=2Dicmp_checkentry(const char *tablename,
=2D	   const void *info,
=2D	   const struct xt_match *match,
=2D	   void *matchinfo,
=2D	   unsigned int hook_mask)
+icmp_init(const char *tablename,
+	  const void *info,
+	  const struct xt_match *match,
+	  void *matchinfo,
+	  unsigned int hook_mask,
+	  void *priv_data)
 {
 	const struct ipt_icmp *icmpinfo =3D matchinfo;
=20
@@ -2171,7 +2160,7 @@ static struct ipt_match icmp_matchstruct
 	.matchsize	=3D sizeof(struct ipt_icmp),
 	.proto		=3D IPPROTO_ICMP,
 	.family		=3D AF_INET,
=2D	.checkentry	=3D icmp_checkentry,
+	.init		=3D icmp_init,
 };
=20
 static int __init ip_tables_init(void)
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_table=
s.c
index 4ab368f..2c3ed69 100644
=2D-- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -217,7 +217,8 @@ ip6t_error(struct sk_buff **pskb,
 	  const struct net_device *out,
 	  unsigned int hooknum,
 	  const struct xt_target *target,
=2D	  const void *targinfo)
+	  const void *targinfo,
+	  void *priv_data)
 {
 	if (net_ratelimit())
 		printk("ip6_tables: error: `%s'\n", (char *)targinfo);
@@ -236,7 +237,8 @@ int do_match(struct ip6t_entry_match *m,
 {
 	/* Stop iteration if it doesn't match */
 	if (!m->u.kernel.match->match(skb, in, out, m->u.kernel.match, m->data,
=2D				      offset, protoff, hotdrop))
+				      offset, protoff, hotdrop,
+				      m->u.kernel.priv_data))
 		return 1;
 	else
 		return 0;
@@ -340,11 +342,13 @@ #ifdef CONFIG_NETFILTER_DEBUG
 				((struct ip6t_entry *)table_base)->comefrom
 					=3D 0xeeeeeeec;
 #endif
=2D				verdict =3D t->u.kernel.target->target(pskb,
=2D								     in, out,
=2D								     hook,
=2D								     t->u.kernel.target,
=2D								     t->data);
+				verdict =3D t->u.kernel.target->target(
+						pskb,
+						in, out,
+						hook,
+						t->u.kernel.target,
+						t->data,
+						t->u.kernel.priv_data);
=20
 #ifdef CONFIG_NETFILTER_DEBUG
 				if (((struct ip6t_entry *)table_base)->comefrom
@@ -501,8 +505,9 @@ cleanup_match(struct ip6t_entry_match *m
 		return 1;
=20
 	if (m->u.kernel.match->destroy)
=2D		m->u.kernel.match->destroy(m->u.kernel.match, m->data);
=2D	module_put(m->u.kernel.match->me);
+		m->u.kernel.match->destroy(m->u.kernel.match, m->data,
+					   m->u.kernel.priv_data);
+	xt_destroy_match(m);
 	return 0;
 }
=20
@@ -528,33 +533,24 @@ standard_check(const struct ip6t_entry_t
 }
=20
 static inline int
=2Dcheck_match(struct ip6t_entry_match *m,
=2D	    const char *name,
=2D	    const struct ip6t_ip6 *ipv6,
=2D	    unsigned int hookmask,
=2D	    unsigned int *i)
+init_match(struct ip6t_entry_match *m,
+	   const char *name,
+	   const struct ip6t_ip6 *ipv6,
+	   unsigned int hookmask,
+	   unsigned int *i)
 {
=2D	struct ip6t_match *match;
 	int ret;
=20
=2D	match =3D try_then_request_module(xt_find_match(AF_INET6, m->u.user.nam=
e,
=2D			      		m->u.user.revision),
=2D					"ip6t_%s", m->u.user.name);
=2D	if (IS_ERR(match) || !match) {
=2D	  	duprintf("check_match: `%s' not found\n", m->u.user.name);
=2D		return match ? PTR_ERR(match) : -ENOENT;
=2D	}
=2D	m->u.kernel.match =3D match;
=2D
=2D	ret =3D xt_check_match(match, AF_INET6, m->u.match_size - sizeof(*m),
=2D			     name, hookmask, ipv6->proto,
=2D			     ipv6->invflags & IP6T_INV_PROTO);
+	ret =3D xt_init_match(m, "ip6t", AF_INET6,
+			    name, hookmask, ipv6->proto,
+			    ipv6->invflags & IP6T_INV_PROTO);
 	if (ret)
 		goto err;
=20
=2D	if (m->u.kernel.match->checkentry
=2D	    && !m->u.kernel.match->checkentry(name, ipv6, match,  m->data,
=2D					      hookmask)) {
+	if (m->u.kernel.match->init
+	    && !m->u.kernel.match->init(name, ipv6, m->u.kernel.match,
+					m->data, hookmask,
+					m->u.kernel.priv_data)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 m->u.kernel.match->name);
 		ret =3D -EINVAL;
@@ -564,18 +560,17 @@ check_match(struct ip6t_entry_match *m,
 	(*i)++;
 	return 0;
 err:
=2D	module_put(m->u.kernel.match->me);
+	xt_destroy_match(m);
 	return ret;
 }
=20
 static struct ip6t_target ip6t_standard_target;
=20
 static inline int
=2Dcheck_entry(struct ip6t_entry *e, const char *name, unsigned int size,
=2D	    unsigned int *i)
+init_entry(struct ip6t_entry *e, const char *name, unsigned int size,
+	   unsigned int *i)
 {
 	struct ip6t_entry_target *t;
=2D	struct ip6t_target *target;
 	int ret;
 	unsigned int j;
=20
@@ -585,25 +580,14 @@ check_entry(struct ip6t_entry *e, const=20
 	}
=20
 	j =3D 0;
=2D	ret =3D IP6T_MATCH_ITERATE(e, check_match, name, &e->ipv6, e->comefrom,=
 &j);
+	ret =3D IP6T_MATCH_ITERATE(e, init_match, name, &e->ipv6, e->comefrom, &j=
);
 	if (ret !=3D 0)
 		goto cleanup_matches;
=20
 	t =3D ip6t_get_target(e);
=2D	target =3D try_then_request_module(xt_find_target(AF_INET6,
=2D							t->u.user.name,
=2D							t->u.user.revision),
=2D					 "ip6t_%s", t->u.user.name);
=2D	if (IS_ERR(target) || !target) {
=2D		duprintf("check_entry: `%s' not found\n", t->u.user.name);
=2D		ret =3D target ? PTR_ERR(target) : -ENOENT;
=2D		goto cleanup_matches;
=2D	}
=2D	t->u.kernel.target =3D target;
=2D
=2D	ret =3D xt_check_target(target, AF_INET6, t->u.target_size - sizeof(*t),
=2D			      name, e->comefrom, e->ipv6.proto,
=2D			      e->ipv6.invflags & IP6T_INV_PROTO);
+	ret =3D xt_init_target(t, "ip6t", AF_INET6,
+			     name, e->comefrom, e->ipv6.proto,
+			     e->ipv6.invflags & IP6T_INV_PROTO);
 	if (ret)
 		goto err;
=20
@@ -612,9 +596,11 @@ check_entry(struct ip6t_entry *e, const=20
 			ret =3D -EINVAL;
 			goto err;
 		}
=2D	} else if (t->u.kernel.target->checkentry
=2D		   && !t->u.kernel.target->checkentry(name, e, target, t->data,
=2D						      e->comefrom)) {
+	} else if (t->u.kernel.target->init
+		   && !t->u.kernel.target->init(name, e, t->u.kernel.target,
+						t->data,
+						e->comefrom,
+						t->u.kernel.priv_data)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
 		ret =3D -EINVAL;
@@ -624,7 +610,7 @@ check_entry(struct ip6t_entry *e, const=20
 	(*i)++;
 	return 0;
  err:
=2D	module_put(t->u.kernel.target->me);
+	xt_destroy_target(t);
  cleanup_matches:
 	IP6T_MATCH_ITERATE(e, cleanup_match, &j);
 	return ret;
@@ -685,8 +671,9 @@ cleanup_entry(struct ip6t_entry *e, unsi
 	IP6T_MATCH_ITERATE(e, cleanup_match, NULL);
 	t =3D ip6t_get_target(e);
 	if (t->u.kernel.target->destroy)
=2D		t->u.kernel.target->destroy(t->u.kernel.target, t->data);
=2D	module_put(t->u.kernel.target->me);
+		t->u.kernel.target->destroy(t->u.kernel.target, t->data,
+					    t->u.kernel.priv_data);
+	xt_destroy_target(t);
 	return 0;
 }
=20
@@ -755,7 +742,7 @@ translate_table(const char *name,
 	/* Finally, each sanity check must pass */
 	i =3D 0;
 	ret =3D IP6T_ENTRY_ITERATE(entry0, newinfo->size,
=2D				check_entry, name, size, &i);
+				 init_entry, name, size, &i);
=20
 	if (ret !=3D 0) {
 		IP6T_ENTRY_ITERATE(entry0, newinfo->size,
@@ -1310,7 +1297,8 @@ icmp6_match(const struct sk_buff *skb,
 	   const void *matchinfo,
 	   int offset,
 	   unsigned int protoff,
=2D	   int *hotdrop)
+	   int *hotdrop,
+	   void *priv_data)
 {
 	struct icmp6hdr _icmp, *ic;
 	const struct ip6t_icmp *icmpinfo =3D matchinfo;
@@ -1337,11 +1325,12 @@ icmp6_match(const struct sk_buff *skb,
=20
 /* Called when user tries to insert an entry of this type. */
 static int
=2Dicmp6_checkentry(const char *tablename,
+icmp6_init(const char *tablename,
 	   const void *entry,
 	   const struct xt_match *match,
 	   void *matchinfo,
=2D	   unsigned int hook_mask)
+	   unsigned int hook_mask,
+	   void *priv_data)
 {
 	const struct ip6t_icmp *icmpinfo =3D matchinfo;
=20
@@ -1377,7 +1366,7 @@ static struct ip6t_match icmp6_matchstru
 	.name		=3D "icmp6",
 	.match		=3D &icmp6_match,
 	.matchsize	=3D sizeof(struct ip6t_icmp),
=2D	.checkentry	=3D icmp6_checkentry,
+	.init		=3D icmp6_init,
 	.proto		=3D IPPROTO_ICMPV6,
 	.family		=3D AF_INET6,
 };
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 58522fc..5822202 100644
=2D-- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -303,10 +303,27 @@ int xt_find_revision(int af, const char=20
 }
 EXPORT_SYMBOL_GPL(xt_find_revision);
=20
=2Dint xt_check_match(const struct xt_match *match, unsigned short family,
=2D                   unsigned int size, const char *table, unsigned int ho=
ok_mask,
=2D		   unsigned short proto, int inv_proto)
=2D{
+int xt_init_match(struct xt_entry_match *m, char *module_prefix,
+		  unsigned short family, const char *table,
+		  unsigned int hook_mask,
+		  unsigned short proto, int inv_proto)
+{
+	struct xt_match *match;
+	unsigned int size =3D (m->u.match_size - sizeof(*m));
+
+	match =3D try_then_request_module(xt_find_match(family, m->u.user.name,
+						   m->u.user.revision),
+					"%s_%s",
+					module_prefix, m->u.user.name);
+	if (IS_ERR(match) || !match) {
+		duprintf("init_match: `%s' not found\n", m->u.user.name);
+		m->u.kernel.match =3D NULL;
+		m->u.kernel.priv_data =3D NULL;
+		return match ? PTR_ERR(match) : -ENOENT;
+	}
+	m->u.kernel.match =3D match;
+	m->u.kernel.priv_data =3D NULL;
+
 	if (XT_ALIGN(match->matchsize) !=3D size) {
 		printk("%s_tables: %s match: invalid size %Zu !=3D %u\n",
 		       xt_prefix[family], match->name,
@@ -328,9 +345,30 @@ int xt_check_match(const struct xt_match
 		       xt_prefix[family], match->name, match->proto);
 		return -EINVAL;
 	}
+
+	if (match->priv_size) {
+		m->u.kernel.priv_data =3D kzalloc(match->priv_size,
+						GFP_KERNEL);
+		if (!m->u.kernel.priv_data) {
+			printk("%s_tables: %s match: "
+			       "unable to allocate memory\n",
+			       xt_prefix[family], match->name);
+			return -ENOMEM;
+		}
+	}
+
 	return 0;
 }
=2DEXPORT_SYMBOL_GPL(xt_check_match);
+EXPORT_SYMBOL_GPL(xt_init_match);
+
+void xt_destroy_match(struct xt_entry_match *m)
+{
+	BUG_ON(!m);
+	kfree(m->u.kernel.priv_data);
+	if (m->u.kernel.match)
+		module_put(m->u.kernel.match->me);
+}
+EXPORT_SYMBOL_GPL(xt_destroy_match);
=20
 #ifdef CONFIG_COMPAT
 int xt_compat_match_offset(struct xt_match *match)
@@ -393,10 +431,28 @@ int xt_compat_match_to_user(struct xt_en
 EXPORT_SYMBOL_GPL(xt_compat_match_to_user);
 #endif /* CONFIG_COMPAT */
=20
=2Dint xt_check_target(const struct xt_target *target, unsigned short famil=
y,
=2D		    unsigned int size, const char *table, unsigned int hook_mask,
=2D		    unsigned short proto, int inv_proto)
+int xt_init_target(struct xt_entry_target *t, char *module_prefix,
+		   unsigned short family, const char *table,
+		   unsigned int hook_mask, unsigned short proto,
+		   int inv_proto)
 {
+	struct xt_target *target;
+	unsigned int size =3D t->u.target_size - sizeof(*t);
+=09
+	target =3D try_then_request_module(xt_find_target(family,
+						     t->u.user.name,
+						     t->u.user.revision),
+					 "%s_%s",
+					 module_prefix, t->u.user.name);
+	if (IS_ERR(target) || !target) {
+		duprintf("init_target: `%s' not found\n", t->u.user.name);
+		t->u.kernel.target =3D NULL;
+		t->u.kernel.priv_data =3D NULL;
+		return target ? PTR_ERR(target) : -ENOENT;
+	}
+	t->u.kernel.target =3D target;
+	t->u.kernel.priv_data =3D NULL;
+
 	if (XT_ALIGN(target->targetsize) !=3D size) {
 		printk("%s_tables: %s target: invalid size %Zu !=3D %u\n",
 		       xt_prefix[family], target->name,
@@ -418,9 +474,30 @@ int xt_check_target(const struct xt_targ
 		       xt_prefix[family], target->name, target->proto);
 		return -EINVAL;
 	}
+
+	if (target->priv_size) {
+		t->u.kernel.priv_data =3D kzalloc(target->priv_size,
+						GFP_KERNEL);
+		if (!t->u.kernel.priv_data) {
+			printk("%s_tables: %s target: "
+			       "unable to allocate memory\n",
+			       xt_prefix[family], target->name);
+			return -ENOMEM;
+		}
+	}
+
 	return 0;
 }
=2DEXPORT_SYMBOL_GPL(xt_check_target);
+EXPORT_SYMBOL_GPL(xt_init_target);
+
+void xt_destroy_target(struct xt_entry_target *t)
+{
+	BUG_ON(!t);
+	kfree(t->u.kernel.priv_data);
+	if (t->u.kernel.target)
+		module_put(t->u.kernel.target->me);
+}
+EXPORT_SYMBOL_GPL(xt_destroy_target);
=20
 #ifdef CONFIG_COMPAT
 int xt_compat_target_offset(struct xt_target *target)
=2D-=20
1.4.2
