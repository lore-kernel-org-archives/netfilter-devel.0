From: Massimiliano Hofer <max@nucleus.it>
Subject: [PATCH 3/4][data-condition]: instance data support in netfilter
	core code
Date: Tue, 5 Dec 2006 23:17:08 +0100
Message-ID: <200612052317.09549.max@nucleus.it>
References: <200612052312.28824.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200612052312.28824.max@nucleus.it>
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

=46rom b0ff8190113c29f440ee420c238836492c7e23ff Mon Sep 17 00:00:00 2001
=46rom: Massimiliano Hofer <max@nucleus.it>
Date: Tue, 5 Dec 2006 22:57:21 +0100
Subject: [PATCH] [NETFILTER]: instance data support in netfilter core code

This patch adds the relevant code to support instance specific data in matc=
hes and targets.
Some code shuffling happened and I used the opportunity to move some common=
 code
from ip_tables.c, arp_tables.c and ip6_tables.c to x_tables.c.

Signed-off-by: Massimiliano Hofer <max@nucleus.it>
=2D--
 include/linux/netfilter/x_tables.h |   16 +++--
 net/ipv4/netfilter/arp_tables.c    |   30 +++-------
 net/ipv4/netfilter/ip_tables.c     |   84 ++++++++------------------
 net/ipv6/netfilter/ip6_tables.c    |   75 ++++++------------------
 net/netfilter/x_tables.c           |  113 ++++++++++++++++++++++++++++++++=
+---
 5 files changed, 168 insertions(+), 150 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x=
_tables.h
index 17aa03b..8903d35 100644
=2D-- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -284,12 +284,16 @@ extern void xt_unregister_match(struct x
 extern int xt_register_matches(struct xt_match *match, unsigned int n);
 extern void xt_unregister_matches(struct xt_match *match, unsigned int n);
=20
=2Dextern int xt_init_match(const struct xt_match *match, unsigned short fa=
mily,
=2D			 unsigned int size, const char *table, unsigned int hook,
=2D			 unsigned short proto, int inv_proto);
=2Dextern int xt_init_target(const struct xt_target *target, unsigned short=
 family,
=2D			  unsigned int size, const char *table, unsigned int hook,
=2D			  unsigned short proto, int inv_proto);
+extern int xt_init_match(struct xt_entry_match *m,
+                        unsigned short family, const char *table,
+                        unsigned int hook_mask, const void *ip,
+			unsigned short proto, int inv_proto);
+extern void xt_destroy_match(struct xt_entry_match *m);
+extern int xt_init_target(struct xt_entry_target *t,
+                         unsigned short family, const char *table,
+                         unsigned int hook_mask, unsigned short proto,
+                         int inv_proto);
+extern void xt_destroy_target(struct xt_entry_target *m);
=20
 extern int xt_register_table(struct xt_table *table,
 			     struct xt_table_info *bootstrap,
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_table=
s.c
index 683179f..dce28d9 100644
=2D-- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -456,11 +456,10 @@ static inline int standard_check(const s
=20
 static struct arpt_target arpt_standard_target;
=20
=2Dstatic inline int check_entry(struct arpt_entry *e, const char *name, un=
signed int size,
=2D			      unsigned int *i)
+static inline int init_entry(struct arpt_entry *e, const char *name, unsig=
ned int size,
+			     unsigned int *i)
 {
 	struct arpt_entry_target *t;
=2D	struct arpt_target *target;
 	int ret;
=20
 	if (!arp_checkentry(&e->arp)) {
@@ -475,30 +474,20 @@ static inline int check_entry(struct arp
 	if (e->target_offset + t->u.target_size > e->next_offset)
 		return -EINVAL;
=20
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
=2D
=2D	ret =3D xt_init_target(target, NF_ARP, t->u.target_size - sizeof(*t),
+	ret =3D xt_init_target(t, NF_ARP,
 			     name, e->comefrom, 0, 0);
+
 	if (ret)
 		goto err;
=20
=2D	t->u.kernel.data=3DNULL;
 	if (t->u.kernel.target =3D=3D &arpt_standard_target) {
 		if (!standard_check(t, size)) {
 			ret =3D -EINVAL;
 			goto err;
 		}
 	} else if (t->u.kernel.target->init
=2D		   && !t->u.kernel.target->init(name, e, target, t->data,
=2D						t->u.kernel.data,
+		   && !t->u.kernel.target->init(name, e, t->u.kernel.target,
+						t->data, t->u.kernel.data,
 						e->comefrom)) {
 		duprintf("arp_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
@@ -509,8 +498,7 @@ static inline int check_entry(struct arp
 	(*i)++;
 	return 0;
 err:
=2D	module_put(t->u.kernel.target->me);
=2Dout:
+	xt_destroy_target(t);
 	return ret;
 }
=20
@@ -567,7 +555,7 @@ static inline int cleanup_entry(struct a
 	if (t->u.kernel.target->destroy)
 		t->u.kernel.target->destroy(t->u.kernel.target, t->data,
 					    t->u.kernel.data);
=2D	module_put(t->u.kernel.target->me);
+	xt_destroy_target(t);
 	return 0;
 }
=20
@@ -635,7 +623,7 @@ static int translate_table(const char *n
 	/* Finally, each sanity check must pass */
 	i =3D 0;
 	ret =3D ARPT_ENTRY_ITERATE(entry0, newinfo->size,
=2D				 check_entry, name, size, &i);
+				 init_entry, name, size, &i);
=20
 	if (ret !=3D 0)
 		goto cleanup;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 4077577..98a2e28 100644
=2D-- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -469,7 +469,7 @@ cleanup_match(struct ipt_entry_match *m,
 	if (m->u.kernel.match->destroy)
 		m->u.kernel.match->destroy(m->u.kernel.match, m->data,
 					   m->u.kernel.data);
=2D	module_put(m->u.kernel.match->me);
+	xt_destroy_match(m);
 	return 0;
 }
=20
@@ -501,49 +501,24 @@ init_match(struct ipt_entry_match *m,
 	    unsigned int hookmask,
 	    unsigned int *i)
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
=2D	ret =3D xt_init_match(match, AF_INET, m->u.match_size - sizeof(*m),
=2D			    name, hookmask, ip->proto,
+	ret =3D xt_init_match(m, AF_INET,
+			    name, hookmask, ip, ip->proto,
 			    ip->invflags & IPT_INV_PROTO);
=2D	if (ret)
=2D		goto err;
=20
=2D	m->u.kernel.data =3D NULL;
=2D	if (m->u.kernel.match->init
=2D	    && !m->u.kernel.match->init(name, ip, match, m->data,
=2D					m->u.kernel.data, hookmask)) {
=2D		duprintf("ip_tables: check failed for `%s'.\n",
=2D			 m->u.kernel.match->name);
=2D		ret =3D -EINVAL;
=2D		goto err;
=2D	}
=2D
=2D	(*i)++;
=2D	return 0;
=2Derr:
=2D	module_put(m->u.kernel.match->me);
+	if(!ret)
+		(*i)++;
 	return ret;
 }
=20
 static struct ipt_target ipt_standard_target;
=20
 static inline int
=2Dcheck_entry(struct ipt_entry *e, const char *name, unsigned int size,
=2D	    unsigned int *i)
+init_entry(struct ipt_entry *e, const char *name, unsigned int size,
+	   unsigned int *i)
 {
 	struct ipt_entry_target *t;
=2D	struct ipt_target *target;
 	int ret;
 	unsigned int j;
=20
@@ -564,32 +539,20 @@ check_entry(struct ipt_entry *e, const c
 	ret =3D -EINVAL;
 	if (e->target_offset + t->u.target_size > e->next_offset)
 			goto cleanup_matches;
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
=2D	ret =3D xt_init_target(target, AF_INET, t->u.target_size - sizeof(*t),
+	ret =3D xt_init_target(t, AF_INET,
 			     name, e->comefrom, e->ip.proto,
 			     e->ip.invflags & IPT_INV_PROTO);
 	if (ret)
 		goto err;
=20
=2D	t->u.kernel.data =3D NULL;
 	if (t->u.kernel.target =3D=3D &ipt_standard_target) {
 		if (!standard_check(t, size)) {
 			ret =3D -EINVAL;
 			goto err;
 		}
 	} else if (t->u.kernel.target->init
=2D		   && !t->u.kernel.target->init(name, e, target, t->data,
=2D						t->u.kernel.data,
+		   && !t->u.kernel.target->init(name, e, t->u.kernel.target,
+						t->data, t->u.kernel.data,
 						e->comefrom)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
@@ -600,7 +563,7 @@ check_entry(struct ipt_entry *e, const c
 	(*i)++;
 	return 0;
  err:
=2D	module_put(t->u.kernel.target->me);
+	xt_destroy_target(t);
  cleanup_matches:
 	IPT_MATCH_ITERATE(e, cleanup_match, &j);
 	return ret;
@@ -663,7 +626,7 @@ cleanup_entry(struct ipt_entry *e, unsig
 	if (t->u.kernel.target->destroy)
 		t->u.kernel.target->destroy(t->u.kernel.target, t->data,
 					    t->u.kernel.data);
=2D	module_put(t->u.kernel.target->me);
+	xt_destroy_target(t);
 	return 0;
 }
=20
@@ -729,7 +692,7 @@ translate_table(const char *name,
 	/* Finally, each sanity check must pass */
 	i =3D 0;
 	ret =3D IPT_ENTRY_ITERATE(entry0, newinfo->size,
=2D				check_entry, name, size, &i);
+				init_entry, name, size, &i);
=20
 	if (ret !=3D 0)
 		goto cleanup;
@@ -1499,7 +1462,7 @@ check_compat_entry_size_and_hooks(struct
 						     t->u.user.revision),
 					 "ipt_%s", t->u.user.name);
 	if (IS_ERR(target) || !target) {
=2D		duprintf("check_entry: `%s' not found\n", t->u.user.name);
+		duprintf("init_entry: `%s' not found\n", t->u.user.name);
 		ret =3D target ? PTR_ERR(target) : -ENOENT;
 		goto cleanup_matches;
 	}
@@ -1545,17 +1508,22 @@ static inline int compat_copy_match_from
 	match =3D m->u.kernel.match;
 	xt_compat_match_from_user(m, dstptr, size);
=20
=2D	ret =3D xt_init_match(match, AF_INET, dm->u.match_size - sizeof(*dm),
=2D			    name, hookmask, ip->proto,
+	ret =3D xt_init_match(m, AF_INET, name, hookmask,
+			    ip, ip->proto,
 			    ip->invflags & IPT_INV_PROTO);
=2D	m->u.kernel.data =3D NULL;
=2D	if (!ret && m->u.kernel.match->init
+	if(ret)
+		goto err;
+	if (m->u.kernel.match->init
 	    && !m->u.kernel.match->init(name, ip, match, dm->data,
 					m->u.kernel.data, hookmask)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 m->u.kernel.match->name);
 		ret =3D -EINVAL;
+		goto err;
 	}
+	return 0;
+err:
+	xt_destroy_match(m);
 	return ret;
 }
=20
@@ -1578,7 +1546,7 @@ static int compat_copy_entry_from_user(s
 	ret =3D IPT_MATCH_ITERATE(e, compat_copy_match_from_user, dstptr, size,
 			name, &de->ip, de->comefrom);
 	if (ret)
=2D		goto err;
+		return ret;
 	de->target_offset =3D e->target_offset - (origsize - *size);
 	t =3D ipt_get_target(e);
 	target =3D t->u.kernel.target;
@@ -1594,14 +1562,13 @@ static int compat_copy_entry_from_user(s
=20
 	t =3D ipt_get_target(de);
 	target =3D t->u.kernel.target;
=2D	ret =3D xt_init_target(target, AF_INET, t->u.target_size - sizeof(*t),
+	ret =3D xt_init_target(t, AF_INET,
 			     name, e->comefrom, e->ip.proto,
 			     e->ip.invflags & IPT_INV_PROTO);
 	if (ret)
 		goto err;
=20
 	ret =3D -EINVAL;
=2D	t->u.kernel.data =3D NULL;
 	if (t->u.kernel.target =3D=3D &ipt_standard_target) {
 		if (!standard_check(t, *size))
 			goto err;
@@ -1615,6 +1582,7 @@ static int compat_copy_entry_from_user(s
 	}
 	ret =3D 0;
 err:
+	xt_destroy_target(t);
 	return ret;
 }
=20
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_table=
s.c
index f14fe12..055fec0 100644
=2D-- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -508,7 +508,7 @@ cleanup_match(struct ip6t_entry_match *m
 	if (m->u.kernel.match->destroy)
 		m->u.kernel.match->destroy(m->u.kernel.match, m->data,
 					   m->u.kernel.data);
=2D	module_put(m->u.kernel.match->me);
+	xt_destroy_match(m);
 	return 0;
 }
=20
@@ -534,55 +534,30 @@ standard_check(const struct ip6t_entry_t
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
=2D	ret =3D xt_init_match(match, AF_INET6, m->u.match_size - sizeof(*m),
=2D			    name, hookmask, ipv6->proto,
+	ret =3D xt_init_match(m, AF_INET6,
+			    name, hookmask, ipv6, ipv6->proto,
 			    ipv6->invflags & IP6T_INV_PROTO);
=2D	if (ret)
=2D		goto err;
=2D
=2D	m->u.kernel.data=3DNULL;
=2D	if (m->u.kernel.match->init
=2D	    && !m->u.kernel.match->init(name, ipv6, match,  m->data,
=2D					m->u.kernel.data, hookmask)) {
=2D		duprintf("ip_tables: check failed for `%s'.\n",
=2D			 m->u.kernel.match->name);
=2D		ret =3D -EINVAL;
=2D		goto err;
=2D	}
=20
=2D	(*i)++;
+	if(!ret)
+		(*i)++;
 	return 0;
=2Derr:
=2D	module_put(m->u.kernel.match->me);
=2D	return ret;
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
@@ -596,7 +571,7 @@ check_entry(struct ip6t_entry *e, const
 		return -EINVAL;
=20
 	j =3D 0;
=2D	ret =3D IP6T_MATCH_ITERATE(e, check_match, name, &e->ipv6, e->comefrom,=
 &j);
+	ret =3D IP6T_MATCH_ITERATE(e, init_match, name, &e->ipv6, e->comefrom, &j=
);
 	if (ret !=3D 0)
 		goto cleanup_matches;
=20
@@ -604,32 +579,20 @@ check_entry(struct ip6t_entry *e, const
 	ret =3D -EINVAL;
 	if (e->target_offset + t->u.target_size > e->next_offset)
 			goto cleanup_matches;
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
=2D	ret =3D xt_init_target(target, AF_INET6, t->u.target_size - sizeof(*t),
+	ret =3D xt_init_target(t, AF_INET6,
 			     name, e->comefrom, e->ipv6.proto,
 			     e->ipv6.invflags & IP6T_INV_PROTO);
 	if (ret)
 		goto err;
=20
=2D	t->u.kernel.data=3DNULL;
 	if (t->u.kernel.target =3D=3D &ip6t_standard_target) {
 		if (!standard_check(t, size)) {
 			ret =3D -EINVAL;
 			goto err;
 		}
 	} else if (t->u.kernel.target->init
=2D		   && !t->u.kernel.target->init(name, e, target, t->data,
=2D						t->u.kernel.data,
+		   && !t->u.kernel.target->init(name, e, t->u.kernel.target,
+						t->data, t->u.kernel.data,
 						e->comefrom)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
@@ -640,7 +603,7 @@ check_entry(struct ip6t_entry *e, const
 	(*i)++;
 	return 0;
  err:
=2D	module_put(t->u.kernel.target->me);
+	xt_destroy_target(t);
  cleanup_matches:
 	IP6T_MATCH_ITERATE(e, cleanup_match, &j);
 	return ret;
@@ -703,7 +666,7 @@ cleanup_entry(struct ip6t_entry *e, unsi
 	if (t->u.kernel.target->destroy)
 		t->u.kernel.target->destroy(t->u.kernel.target, t->data,
 					    t->u.kernel.data);
=2D	module_put(t->u.kernel.target->me);
+	xt_destroy_target(t);
 	return 0;
 }
=20
@@ -769,7 +732,7 @@ translate_table(const char *name,
 	/* Finally, each sanity check must pass */
 	i =3D 0;
 	ret =3D IP6T_ENTRY_ITERATE(entry0, newinfo->size,
=2D				check_entry, name, size, &i);
+				init_entry, name, size, &i);
=20
 	if (ret !=3D 0)
 		goto cleanup;
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 679c430..7f2b16c 100644
=2D-- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -304,35 +304,91 @@ int xt_find_revision(int af, const char
 }
 EXPORT_SYMBOL_GPL(xt_find_revision);
=20
=2Dint xt_init_match(const struct xt_match *match, unsigned short family,
=2D                  unsigned int size, const char *table, unsigned int hoo=
k_mask,
+int xt_init_match(struct xt_entry_match *m,
+		  unsigned short family, const char *table,
+		  unsigned int hook_mask, const void *ip,
 		  unsigned short proto, int inv_proto)
 {
+	struct xt_match *match;
+	unsigned int size =3D (m->u.match_size - sizeof(*m));
+	int ret=3D0;
+
+	match =3D try_then_request_module(xt_find_match(family, m->u.user.name,
+						   m->u.user.revision),
+					"%st_%s",
+					xt_prefix[family], m->u.user.name);
+	if (IS_ERR(match) || !match) {
+		duprintf("init_match: `%s' not found\n", m->u.user.name);
+		m->u.kernel.match =3D NULL;
+		m->u.kernel.data =3D NULL;
+		return match ? PTR_ERR(match) : -ENOENT;
+	}
+	m->u.kernel.match =3D match;
+	m->u.kernel.data =3D NULL;
+
 	if (XT_ALIGN(match->matchsize) !=3D size) {
 		printk("%s_tables: %s match: invalid size %Zu !=3D %u\n",
 		       xt_prefix[family], match->name,
 		       XT_ALIGN(match->matchsize), size);
=2D		return -EINVAL;
+		ret =3D -EINVAL;
+		goto err;
 	}
 	if (match->table && strcmp(match->table, table)) {
 		printk("%s_tables: %s match: only valid in %s table, not %s\n",
 		       xt_prefix[family], match->name, match->table, table);
=2D		return -EINVAL;
+		ret =3D -EINVAL;
+		goto err;
 	}
 	if (match->hooks && (hook_mask & ~match->hooks) !=3D 0) {
 		printk("%s_tables: %s match: bad hook_mask %u\n",
 		       xt_prefix[family], match->name, hook_mask);
=2D		return -EINVAL;
+		ret =3D -EINVAL;
+		goto err;
 	}
 	if (match->proto && (match->proto !=3D proto || inv_proto)) {
 		printk("%s_tables: %s match: only valid for protocol %u\n",
 		       xt_prefix[family], match->name, match->proto);
=2D		return -EINVAL;
+		ret =3D -EINVAL;
+		goto err;
 	}
+
+	if (match->datasize) {
+		m->u.kernel.data =3D kzalloc(match->datasize,
+					   GFP_KERNEL);
+		if (!m->u.kernel.data) {
+			printk("%s_tables: %s match: "
+			       "unable to allocate memory\n",
+			       xt_prefix[family], match->name);
+			ret =3D -ENOMEM;
+			goto err;
+		}
+	}
+
+	if (m->u.kernel.match->init
+	    && !m->u.kernel.match->init(table, ip, m->u.kernel.match, m->data,
+					m->u.kernel.data, hook_mask)) {
+		duprintf("ip_tables: check failed for `%s'.\n",
+			 m->u.kernel.match->name);
+		ret =3D -EINVAL;
+		goto err;
+	}
+
 	return 0;
+err:
+	xt_destroy_match(m);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(xt_init_match);
=20
+void xt_destroy_match(struct xt_entry_match *m)
+{
+	BUG_ON(!m);
+	kfree(m->u.kernel.data);
+	if (m->u.kernel.match)
+		module_put(m->u.kernel.match->me);
+}
+EXPORT_SYMBOL_GPL(xt_destroy_match);
+
 #ifdef CONFIG_COMPAT
 int xt_compat_match_offset(struct xt_match *match)
 {
@@ -394,10 +450,28 @@ int xt_compat_match_to_user(struct xt_en
 EXPORT_SYMBOL_GPL(xt_compat_match_to_user);
 #endif /* CONFIG_COMPAT */
=20
=2Dint xt_init_target(const struct xt_target *target, unsigned short family,
=2D		   unsigned int size, const char *table, unsigned int hook_mask,
=2D		   unsigned short proto, int inv_proto)
+int xt_init_target(struct xt_entry_target *t,
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
+					 "%st_%s",
+					 xt_prefix[family], t->u.user.name);
+	if (IS_ERR(target) || !target) {
+		duprintf("init_target: `%s' not found\n", t->u.user.name);
+		t->u.kernel.target =3D NULL;
+		t->u.kernel.data =3D NULL;
+		return target ? PTR_ERR(target) : -ENOENT;
+	}
+	t->u.kernel.target =3D target;
+	t->u.kernel.data =3D NULL;
+
 	if (XT_ALIGN(target->targetsize) !=3D size) {
 		printk("%s_tables: %s target: invalid size %Zu !=3D %u\n",
 		       xt_prefix[family], target->name,
@@ -419,10 +493,31 @@ int xt_init_target(const struct xt_targe
 		       xt_prefix[family], target->name, target->proto);
 		return -EINVAL;
 	}
+
+	if (target->datasize) {
+		t->u.kernel.data =3D kzalloc(target->datasize,
+					   GFP_KERNEL);
+		if (!t->u.kernel.data) {
+			printk("%s_tables: %s target: "
+			       "unable to allocate memory\n",
+			       xt_prefix[family], target->name);
+			return -ENOMEM;
+		}
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xt_init_target);
=20
+void xt_destroy_target(struct xt_entry_target *t)
+{
+	BUG_ON(!t);
+	kfree(t->u.kernel.data);
+	if (t->u.kernel.target)
+		module_put(t->u.kernel.target->me);
+}
+EXPORT_SYMBOL_GPL(xt_destroy_target);
+
 #ifdef CONFIG_COMPAT
 int xt_compat_target_offset(struct xt_target *target)
 {
=2D-=20
1.4.3.3
