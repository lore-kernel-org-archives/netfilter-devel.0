From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH/RFC/RFT] add "revision" support to arp_tables and ip6_tables
Date: Mon, 10 Oct 2005 00:26:28 +0200
Message-ID: <20051009222628.GC6593@rama.customers.eurospot.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UBnjLfzoMQYIXCvq"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
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


--UBnjLfzoMQYIXCvq
Content-Type: multipart/mixed; boundary="RpqchZ26BWispMcB"
Content-Disposition: inline


--RpqchZ26BWispMcB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave + Yasuyuki,
Dear ip6_tables and arp_tables maintainers ;)

I've added "revision" (i.e. support for multiple match/target versions)
to arp_tables and ip6_tables.

This is mainly a step to synchronize the two "evil twins" of ip_tables,
in order to provide a foundation for the "x_tables" code (which I
already have implemented on top of it).

At least according to some simple tests, I didn't break anything.  It's
already in my git tree's 'master' branch, and I intend to submit it
during early 2.6.15.

Please test/comment/fix,
	Harald
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--RpqchZ26BWispMcB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="82-ip6t_arpt_revisions.patch"
Content-Transfer-Encoding: quoted-printable

[NETFILTER] {ip6,arp}_tables: Add support for match/target revisions

This patch synchronizes {ip6,arp}_tables with recent changes in ip_tables.
It adds support for multiple revisions per match/target.

Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit b472176079a50f0c61c6a5f915a7c9129f20dd2b
tree a5b853d18b28bb2a821e1568e235622bea4c7991
parent 0dc2bc0656b4b1c5ba3524dadc8fbf36881903b7
author Harald Welte <laforge@netfilter.org> Sun, 09 Oct 2005 16:22:51 +0200
committer Harald Welte <laforge@netfilter.org> Sun, 09 Oct 2005 16:22:51 +0=
200

 include/linux/netfilter_arp/arp_tables.h  |   20 ++
 include/linux/netfilter_ipv6/ip6_tables.h |   27 ++-
 net/ipv4/netfilter/arp_tables.c           |  205 +++++++++++++------
 net/ipv6/netfilter/ip6_tables.c           |  307 ++++++++++++++++++-------=
----
 4 files changed, 363 insertions(+), 196 deletions(-)

diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfi=
lter_arp/arp_tables.h
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -68,7 +68,8 @@ struct arpt_entry_target
 			u_int16_t target_size;
=20
 			/* Used by userspace */
-			char name[ARPT_FUNCTION_MAXNAMELEN];
+			char name[ARPT_FUNCTION_MAXNAMELEN-1];
+			u_int8_t revision;
 		} user;
 		struct {
 			u_int16_t target_size;
@@ -148,7 +149,9 @@ struct arpt_entry
=20
 #define ARPT_SO_GET_INFO		(ARPT_BASE_CTL)
 #define ARPT_SO_GET_ENTRIES		(ARPT_BASE_CTL + 1)
-#define ARPT_SO_GET_MAX			ARPT_SO_GET_ENTRIES
+/* #define ARPT_SO_GET_REVISION_MATCH	(ARPT_BASE_CTL + 2)*/
+#define ARPT_SO_GET_REVISION_TARGET	(ARPT_BASE_CTL + 3)
+#define ARPT_SO_GET_MAX			ARPT_SO_GET_REVISION_TARGET
=20
 /* CONTINUE verdict for targets */
 #define ARPT_CONTINUE 0xFFFFFFFF
@@ -236,6 +239,15 @@ struct arpt_get_entries
 	struct arpt_entry entrytable[0];
 };
=20
+/* The argument to ARPT_SO_GET_REVISION_*.  Returns highest revision
+ * kernel supports, if >=3D revision. */
+struct arpt_get_revision
+{
+	char name[ARPT_FUNCTION_MAXNAMELEN-1];
+
+	u_int8_t revision;
+};
+
 /* Standard return verdict, or do jump. */
 #define ARPT_STANDARD_TARGET ""
 /* Error verdict. */
@@ -274,7 +286,9 @@ struct arpt_target
 {
 	struct list_head list;
=20
-	const char name[ARPT_FUNCTION_MAXNAMELEN];
+	const char name[ARPT_FUNCTION_MAXNAMELEN-1];
+
+	u_int8_t revision;
=20
 	/* Returns verdict. */
 	unsigned int (*target)(struct sk_buff **pskb,
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netf=
ilter_ipv6/ip6_tables.h
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -57,7 +57,8 @@ struct ip6t_entry_match
 			u_int16_t match_size;
=20
 			/* Used by userspace */
-			char name[IP6T_FUNCTION_MAXNAMELEN];
+			char name[IP6T_FUNCTION_MAXNAMELEN-1];
+			u_int8_t revision;
 		} user;
 		struct {
 			u_int16_t match_size;
@@ -80,7 +81,8 @@ struct ip6t_entry_target
 			u_int16_t target_size;
=20
 			/* Used by userspace */
-			char name[IP6T_FUNCTION_MAXNAMELEN];
+			char name[IP6T_FUNCTION_MAXNAMELEN-1];
+			u_int8_t revision;
 		} user;
 		struct {
 			u_int16_t target_size;
@@ -161,7 +163,9 @@ struct ip6t_entry
=20
 #define IP6T_SO_GET_INFO		(IP6T_BASE_CTL)
 #define IP6T_SO_GET_ENTRIES		(IP6T_BASE_CTL + 1)
-#define IP6T_SO_GET_MAX			IP6T_SO_GET_ENTRIES
+#define	IP6T_SO_GET_REVISION_MATCH	(IP6T_BASE_CTL + 2)
+#define	IP6T_SO_GET_REVISION_TARGET	(IP6T_BASE_CTL + 3)
+#define IP6T_SO_GET_MAX			IP6T_SO_GET_REVISION_TARGET
=20
 /* CONTINUE verdict for targets */
 #define IP6T_CONTINUE 0xFFFFFFFF
@@ -291,6 +295,15 @@ struct ip6t_get_entries
 	struct ip6t_entry entrytable[0];
 };
=20
+/* The argument to IP6T_SO_GET_REVISION_*.  Returns highest revision
+ * kernel supports, if >=3D revision. */
+struct ip6t_get_revision
+{
+	char name[IP6T_FUNCTION_MAXNAMELEN-1];
+
+	u_int8_t revision;
+};
+
 /* Standard return verdict, or do jump. */
 #define IP6T_STANDARD_TARGET ""
 /* Error verdict. */
@@ -352,7 +365,9 @@ struct ip6t_match
 {
 	struct list_head list;
=20
-	const char name[IP6T_FUNCTION_MAXNAMELEN];
+	const char name[IP6T_FUNCTION_MAXNAMELEN-1];
+
+	u_int8_t revision;
=20
 	/* Return true or false: return FALSE and set *hotdrop =3D 1 to
            force immediate packet drop. */
@@ -387,7 +402,9 @@ struct ip6t_target
 {
 	struct list_head list;
=20
-	const char name[IP6T_FUNCTION_MAXNAMELEN];
+	const char name[IP6T_FUNCTION_MAXNAMELEN-1];
+
+	u_int8_t revision;
=20
 	/* Returns verdict. Argument order changed since 2.6.9, as this
 	   must now handle non-linear skbs, using skb_copy_bits and
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_table=
s.c
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -347,58 +347,106 @@ unsigned int arpt_do_table(struct sk_buf
 		return verdict;
 }
=20
-static inline void *find_inlist_lock_noload(struct list_head *head,
-					    const char *name,
-					    int *error,
-					    struct semaphore *mutex)
+/*
+ * These are weird, but module loading must not be done with mutex
+ * held (since they will register), and we have to have a single
+ * function to use try_then_request_module().
+ */
+
+/* Find table by name, grabs mutex & ref.  Returns ERR_PTR() on error. */
+static inline struct arpt_table *find_table_lock(const char *name)
 {
-	void *ret;
+	struct arpt_table *t;
=20
-	*error =3D down_interruptible(mutex);
-	if (*error !=3D 0)
-		return NULL;
+	if (down_interruptible(&arpt_mutex) !=3D 0)
+		return ERR_PTR(-EINTR);
=20
-	ret =3D list_named_find(head, name);
-	if (!ret) {
-		*error =3D -ENOENT;
-		up(mutex);
-	}
-	return ret;
+	list_for_each_entry(t, &arpt_tables, list)
+		if (strcmp(t->name, name) =3D=3D 0 && try_module_get(t->me))
+			return t;
+	up(&arpt_mutex);
+	return NULL;
 }
=20
-#ifndef CONFIG_KMOD
-#define find_inlist_lock(h,n,p,e,m) find_inlist_lock_noload((h),(n),(e),(m=
))
-#else
-static void *
-find_inlist_lock(struct list_head *head,
-		 const char *name,
-		 const char *prefix,
-		 int *error,
-		 struct semaphore *mutex)
-{
-	void *ret;
-
-	ret =3D find_inlist_lock_noload(head, name, error, mutex);
-	if (!ret) {
-		duprintf("find_inlist: loading `%s%s'.\n", prefix, name);
-		request_module("%s%s", prefix, name);
-		ret =3D find_inlist_lock_noload(head, name, error, mutex);
+
+/* Find target, grabs ref.  Returns ERR_PTR() on error. */
+static inline struct arpt_target *find_target(const char *name, u8 revisio=
n)
+{
+	struct arpt_target *t;
+	int err =3D 0;
+
+	if (down_interruptible(&arpt_mutex) !=3D 0)
+		return ERR_PTR(-EINTR);
+
+	list_for_each_entry(t, &arpt_target, list) {
+		if (strcmp(t->name, name) =3D=3D 0) {
+			if (t->revision =3D=3D revision) {
+				if (try_module_get(t->me)) {
+					up(&arpt_mutex);
+					return t;
+				}
+			} else
+				err =3D -EPROTOTYPE; /* Found something. */
+		}
 	}
+	up(&arpt_mutex);
+	return ERR_PTR(err);
+}
=20
-	return ret;
+struct arpt_target *arpt_find_target(const char *name, u8 revision)
+{
+	struct arpt_target *target;
+
+	target =3D try_then_request_module(find_target(name, revision),
+					 "arpt_%s", name);
+	if (IS_ERR(target) || !target)
+		return NULL;
+	return target;
 }
-#endif
=20
-static inline struct arpt_table *arpt_find_table_lock(const char *name, in=
t *error, struct semaphore *mutex)
+static int target_revfn(const char *name, u8 revision, int *bestp)
 {
-	return find_inlist_lock(&arpt_tables, name, "arptable_", error, mutex);
+	struct arpt_target *t;
+	int have_rev =3D 0;
+
+	list_for_each_entry(t, &arpt_target, list) {
+		if (strcmp(t->name, name) =3D=3D 0) {
+			if (t->revision > *bestp)
+				*bestp =3D t->revision;
+			if (t->revision =3D=3D revision)
+				have_rev =3D1;
+		}
+	}
+	return have_rev;
 }
=20
-static struct arpt_target *arpt_find_target_lock(const char *name, int *er=
ror, struct semaphore *mutex)
+/* Returns true or false (if no such extension at all) */
+static inline int find_revision(const char *name, u8 revision,
+				int (*revfn)(const char *, u8, int *),
+				int *err)
 {
-	return find_inlist_lock(&arpt_target, name, "arpt_", error, mutex);
+	int have_rev, best =3D -1;
+
+	if (down_interruptible(&arpt_mutex) !=3D 0) {
+		*err =3D -EINTR;
+		return 1;
+	}
+	have_rev =3D revfn(name, revision, &best);
+	up(&arpt_mutex);
+
+	/* Nothing at all?  Return 0 to try loading module. */
+	if (best =3D=3D -1) {
+		*err =3D -ENOENT;
+		return 0;
+	}
+
+	*err =3D best;
+	if (!have_rev)
+		*err =3D -EPROTONOSUPPORT;
+	return 1;
 }
=20
+
 /* All zeroes =3D=3D unconditional rule. */
 static inline int unconditional(const struct arpt_arp *arp)
 {
@@ -544,17 +592,15 @@ static inline int check_entry(struct arp
 	}
=20
 	t =3D arpt_get_target(e);
-	target =3D arpt_find_target_lock(t->u.user.name, &ret, &arpt_mutex);
-	if (!target) {
+	target =3D try_then_request_module(find_target(t->u.user.name,
+						     t->u.user.revision),
+					 "arpt_%s", t->u.user.name);
+	if (IS_ERR(target) || !target) {
 		duprintf("check_entry: `%s' not found\n", t->u.user.name);
+		ret =3D target ? PTR_ERR(target) : -ENOENT;
 		goto out;
 	}
-	if (!try_module_get((target->me))) {
-		ret =3D -ENOENT;
-		goto out_unlock;
-	}
 	t->u.kernel.target =3D target;
-	up(&arpt_mutex);
=20
 	if (t->u.kernel.target =3D=3D &arpt_standard_target) {
 		if (!standard_check(t, size)) {
@@ -576,8 +622,6 @@ static inline int check_entry(struct arp
 	(*i)++;
 	return 0;
=20
-out_unlock:
-	up(&arpt_mutex);
 out:
 	return ret;
 }
@@ -844,8 +888,8 @@ static int get_entries(const struct arpt
 	int ret;
 	struct arpt_table *t;
=20
-	t =3D arpt_find_table_lock(entries->name, &ret, &arpt_mutex);
-	if (t) {
+	t =3D find_table_lock(entries->name);
+	if (t || !IS_ERR(t)) {
 		duprintf("t->private->number =3D %u\n",
 			 t->private->number);
 		if (entries->size =3D=3D t->private->size)
@@ -857,10 +901,10 @@ static int get_entries(const struct arpt
 				 entries->size);
 			ret =3D -EINVAL;
 		}
+		module_put(t->me);
 		up(&arpt_mutex);
 	} else
-		duprintf("get_entries: Can't find %s!\n",
-			 entries->name);
+		ret =3D t ? PTR_ERR(t) : -ENOENT;
=20
 	return ret;
 }
@@ -910,22 +954,19 @@ static int do_replace(void __user *user,
=20
 	duprintf("arp_tables: Translated table\n");
=20
-	t =3D arpt_find_table_lock(tmp.name, &ret, &arpt_mutex);
-	if (!t)
+	t =3D try_then_request_module(find_table_lock(tmp.name),
+				    "arptable_%s", tmp.name);
+	if (!t || IS_ERR(t)) {
+		ret =3D t ? PTR_ERR(t) : -ENOENT;
 		goto free_newinfo_counters_untrans;
+	}
=20
 	/* You lied! */
 	if (tmp.valid_hooks !=3D t->valid_hooks) {
 		duprintf("Valid hook crap: %08X vs %08X\n",
 			 tmp.valid_hooks, t->valid_hooks);
 		ret =3D -EINVAL;
-		goto free_newinfo_counters_untrans_unlock;
-	}
-
-	/* Get a reference in advance, we're not allowed fail later */
-	if (!try_module_get(t->me)) {
-		ret =3D -EBUSY;
-		goto free_newinfo_counters_untrans_unlock;
+		goto put_module;
 	}
=20
 	oldinfo =3D replace_table(t, tmp.num_counters, newinfo, &ret);
@@ -956,7 +997,6 @@ static int do_replace(void __user *user,
=20
  put_module:
 	module_put(t->me);
- free_newinfo_counters_untrans_unlock:
 	up(&arpt_mutex);
  free_newinfo_counters_untrans:
 	ARPT_ENTRY_ITERATE(newinfo->entries, newinfo->size, cleanup_entry, NULL);
@@ -986,7 +1026,7 @@ static int do_add_counters(void __user *
 	unsigned int i;
 	struct arpt_counters_info tmp, *paddc;
 	struct arpt_table *t;
-	int ret;
+	int ret =3D 0;
=20
 	if (copy_from_user(&tmp, user, sizeof(tmp)) !=3D 0)
 		return -EFAULT;
@@ -1003,9 +1043,11 @@ static int do_add_counters(void __user *
 		goto free;
 	}
=20
-	t =3D arpt_find_table_lock(tmp.name, &ret, &arpt_mutex);
-	if (!t)
+	t =3D find_table_lock(tmp.name);
+	if (!t || IS_ERR(t)) {
+		ret =3D t ? PTR_ERR(t) : -ENOENT;
 		goto free;
+	}
=20
 	write_lock_bh(&t->lock);
 	if (t->private->number !=3D paddc->num_counters) {
@@ -1022,6 +1064,7 @@ static int do_add_counters(void __user *
  unlock_up_free:
 	write_unlock_bh(&t->lock);
 	up(&arpt_mutex);
+	module_put(t->me);
  free:
 	vfree(paddc);
=20
@@ -1076,8 +1119,10 @@ static int do_arpt_get_ctl(struct sock *
 			break;
 		}
 		name[ARPT_TABLE_MAXNAMELEN-1] =3D '\0';
-		t =3D arpt_find_table_lock(name, &ret, &arpt_mutex);
-		if (t) {
+
+		t =3D try_then_request_module(find_table_lock(name),
+					    "arptable_%s", name);
+		if (t && !IS_ERR(t)) {
 			struct arpt_getinfo info;
=20
 			info.valid_hooks =3D t->valid_hooks;
@@ -1093,9 +1138,10 @@ static int do_arpt_get_ctl(struct sock *
 				ret =3D -EFAULT;
 			else
 				ret =3D 0;
-
 			up(&arpt_mutex);
-		}
+			module_put(t->me);
+		} else
+			ret =3D t ? PTR_ERR(t) : -ENOENT;
 	}
 	break;
=20
@@ -1116,6 +1162,24 @@ static int do_arpt_get_ctl(struct sock *
 		break;
 	}
=20
+	case ARPT_SO_GET_REVISION_TARGET: {
+		struct arpt_get_revision rev;
+
+		if (*len !=3D sizeof(rev)) {
+			ret =3D -EINVAL;
+			break;
+		}
+		if (copy_from_user(&rev, user, sizeof(rev)) !=3D 0) {
+			ret =3D -EFAULT;
+			break;
+		}
+
+		try_then_request_module(find_revision(rev.name, rev.revision,
+						      target_revfn, &ret),
+					"arpt_%s", rev.name);
+		break;
+	}
+
 	default:
 		duprintf("do_arpt_get_ctl: unknown request %i\n", cmd);
 		ret =3D -EINVAL;
@@ -1133,12 +1197,9 @@ int arpt_register_target(struct arpt_tar
 	if (ret !=3D 0)
 		return ret;
=20
-	if (!list_named_insert(&arpt_target, target)) {
-		duprintf("arpt_register_target: `%s' already in list!\n",
-			 target->name);
-		ret =3D -EINVAL;
-	}
+	list_add(&target->list, &arpt_target);
 	up(&arpt_mutex);
+
 	return ret;
 }
=20
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_table=
s.c
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -2,7 +2,7 @@
  * Packet matching code.
  *
  * Copyright (C) 1999 Paul `Rusty' Russell & Michael J. Neuling
- * Copyright (C) 2000-2002 Netfilter core team <coreteam@netfilter.org>
+ * Copyright (C) 2000-2005 Netfilter Core Team <coreteam@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -23,7 +23,6 @@
 #include <linux/tcp.h>
 #include <linux/udp.h>
 #include <linux/icmpv6.h>
-#include <net/ip.h>
 #include <net/ipv6.h>
 #include <asm/uaccess.h>
 #include <asm/semaphore.h>
@@ -79,13 +79,12 @@ static DECLARE_MUTEX(ip6t_mutex);
 #define inline
 #endif
=20
-/* Locking is simple: we assume at worst case there will be one packet
-   in user context and one from bottom halves (or soft irq if Alexey's
-   softnet patch was applied).
-
+/*
    We keep a set of rules for each CPU, so we can avoid write-locking
-   them; doing a readlock_bh() stops packets coming through if we're
-   in user context.
+   them in the softirq when updating the counters and therefore
+   only need to read-lock in the softirq; doing a write_lock_bh() in user
+   context stops packets coming through and allows user context to read
+   the counters or update the rules.
=20
    To be cache friendly on SMP, we arrange them like so:
    [ n-entries ]
@@ -355,7 +354,7 @@ ip6t_do_table(struct sk_buff **pskb,
 	      struct ip6t_table *table,
 	      void *userdata)
 {
-	static const char nulldevname[IFNAMSIZ];
+	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(lon=
g))));
 	int offset =3D 0;
 	unsigned int protoff =3D 0;
 	int hotdrop =3D 0;
@@ -368,7 +367,6 @@ ip6t_do_table(struct sk_buff **pskb,
 	/* Initialization */
 	indev =3D in ? in->name : nulldevname;
 	outdev =3D out ? out->name : nulldevname;
-
 	/* We handle fragments by dealing with the first fragment as
 	 * if it was a normal packet.  All other fragments are treated
 	 * normally, except that they will NEVER match rules that ask
@@ -496,75 +494,145 @@ ip6t_do_table(struct sk_buff **pskb,
 #endif
 }
=20
-/* If it succeeds, returns element and locks mutex */
-static inline void *
-find_inlist_lock_noload(struct list_head *head,
-			const char *name,
-			int *error,
-			struct semaphore *mutex)
-{
-	void *ret;
-
-#if 1
-	duprintf("find_inlist: searching for `%s' in %s.\n",
-		 name, head =3D=3D &ip6t_target ? "ip6t_target"
-		 : head =3D=3D &ip6t_match ? "ip6t_match"
-		 : head =3D=3D &ip6t_tables ? "ip6t_tables" : "UNKNOWN");
-#endif
+/*
+ * These are weird, but module loading must not be done with mutex
+ * held (since they will register), and we have to have a single
+ * function to use try_then_request_module().
+ */
=20
-	*error =3D down_interruptible(mutex);
-	if (*error !=3D 0)
-		return NULL;
+/* Find table by name, grabs mutex & ref.  Returns ERR_PTR() on error. */
+static inline struct ip6t_table *find_table_lock(const char *name)
+{
+	struct ip6t_table *t;
+
+	if (down_interruptible(&ip6t_mutex) !=3D 0)
+		return ERR_PTR(-EINTR);
+
+	list_for_each_entry(t, &ip6t_tables, list)
+		if (strcmp(t->name, name) =3D=3D 0 && try_module_get(t->me))
+			return t;
+	up(&ip6t_mutex);
+	return NULL;
+}
+
+/* Find match, grabs ref.  Returns ERR_PTR() on error. */
+static inline struct ip6t_match *find_match(const char *name, u8 revision)
+{
+	struct ip6t_match *m;
+	int err =3D 0;
+
+	if (down_interruptible(&ip6t_mutex) !=3D 0)
+		return ERR_PTR(-EINTR);
=20
-	ret =3D list_named_find(head, name);
-	if (!ret) {
-		*error =3D -ENOENT;
-		up(mutex);
+	list_for_each_entry(m, &ip6t_match, list) {
+		if (strcmp(m->name, name) =3D=3D 0) {
+			if (m->revision =3D=3D revision) {
+				if (try_module_get(m->me)) {
+					up(&ip6t_mutex);
+					return m;
+				}
+			} else
+				err =3D -EPROTOTYPE; /* Found something. */
+		}
 	}
-	return ret;
+	up(&ip6t_mutex);
+	return ERR_PTR(err);
 }
=20
-#ifndef CONFIG_KMOD
-#define find_inlist_lock(h,n,p,e,m) find_inlist_lock_noload((h),(n),(e),(m=
))
-#else
-static void *
-find_inlist_lock(struct list_head *head,
-		 const char *name,
-		 const char *prefix,
-		 int *error,
-		 struct semaphore *mutex)
-{
-	void *ret;
-
-	ret =3D find_inlist_lock_noload(head, name, error, mutex);
-	if (!ret) {
-		duprintf("find_inlist: loading `%s%s'.\n", prefix, name);
-		request_module("%s%s", prefix, name);
-		ret =3D find_inlist_lock_noload(head, name, error, mutex);
+/* Find target, grabs ref.  Returns ERR_PTR() on error. */
+static inline struct ip6t_target *find_target(const char *name, u8 revisio=
n)
+{
+	struct ip6t_target *t;
+	int err =3D 0;
+
+	if (down_interruptible(&ip6t_mutex) !=3D 0)
+		return ERR_PTR(-EINTR);
+
+	list_for_each_entry(t, &ip6t_target, list) {
+		if (strcmp(t->name, name) =3D=3D 0) {
+			if (t->revision =3D=3D revision) {
+				if (try_module_get(t->me)) {
+					up(&ip6t_mutex);
+					return t;
+				}
+			} else
+				err =3D -EPROTOTYPE; /* Found something. */
+		}
 	}
+	up(&ip6t_mutex);
+	return ERR_PTR(err);
+}
=20
-	return ret;
+struct ip6t_target *ip6t_find_target(const char *name, u8 revision)
+{
+	struct ip6t_target *target;
+
+	target =3D try_then_request_module(find_target(name, revision),
+					 "ip6t_%s", name);
+	if (IS_ERR(target) || !target)
+		return NULL;
+	return target;
 }
-#endif
=20
-static inline struct ip6t_table *
-ip6t_find_table_lock(const char *name, int *error, struct semaphore *mutex)
+static int match_revfn(const char *name, u8 revision, int *bestp)
 {
-	return find_inlist_lock(&ip6t_tables, name, "ip6table_", error, mutex);
+	struct ip6t_match *m;
+	int have_rev =3D 0;
+
+	list_for_each_entry(m, &ip6t_match, list) {
+		if (strcmp(m->name, name) =3D=3D 0) {
+			if (m->revision > *bestp)
+				*bestp =3D m->revision;
+			if (m->revision =3D=3D revision)
+				have_rev =3D 1;
+		}
+	}
+	return have_rev;
 }
=20
-static inline struct ip6t_match *
-find_match_lock(const char *name, int *error, struct semaphore *mutex)
+static int target_revfn(const char *name, u8 revision, int *bestp)
 {
-	return find_inlist_lock(&ip6t_match, name, "ip6t_", error, mutex);
+	struct ip6t_target *t;
+	int have_rev =3D 0;
+
+	list_for_each_entry(t, &ip6t_target, list) {
+		if (strcmp(t->name, name) =3D=3D 0) {
+			if (t->revision > *bestp)
+				*bestp =3D t->revision;
+			if (t->revision =3D=3D revision)
+				have_rev =3D 1;
+		}
+	}
+	return have_rev;
 }
=20
-static struct ip6t_target *
-ip6t_find_target_lock(const char *name, int *error, struct semaphore *mute=
x)
+/* Returns true or fals (if no such extension at all) */
+static inline int find_revision(const char *name, u8 revision,
+				int (*revfn)(const char *, u8, int *),
+				int *err)
 {
-	return find_inlist_lock(&ip6t_target, name, "ip6t_", error, mutex);
+	int have_rev, best =3D -1;
+
+	if (down_interruptible(&ip6t_mutex) !=3D 0) {
+		*err =3D -EINTR;
+		return 1;
+	}
+	have_rev =3D revfn(name, revision, &best);
+	up(&ip6t_mutex);
+
+	/* Nothing at all?  Return 0 to try loading module. */
+	if (best =3D=3D -1) {
+		*err =3D -ENOENT;
+		return 0;
+	}
+
+	*err =3D best;
+	if (!have_rev)
+		*err =3D -EPROTONOSUPPORT;
+	return 1;
 }
=20
+
 /* All zeroes =3D=3D unconditional rule. */
 static inline int
 unconditional(const struct ip6t_ip6 *ipv6)
@@ -724,20 +792,16 @@ check_match(struct ip6t_entry_match *m,
 	    unsigned int hookmask,
 	    unsigned int *i)
 {
-	int ret;
 	struct ip6t_match *match;
=20
-	match =3D find_match_lock(m->u.user.name, &ret, &ip6t_mutex);
-	if (!match) {
-	  //		duprintf("check_match: `%s' not found\n", m->u.name);
-		return ret;
-	}
-	if (!try_module_get(match->me)) {
-		up(&ip6t_mutex);
-		return -ENOENT;
+	match =3D try_then_request_module(find_match(m->u.user.name,
+						   m->u.user.revision),
+					"ip6t_%s", m->u.user.name);
+	if (IS_ERR(match) || !match) {
+		duprintf("check_match: `%s' not found\n", m->u.user.name);
+		return match ? PTR_ERR(match) : -ENOENT;
 	}
 	m->u.kernel.match =3D match;
-	up(&ip6t_mutex);
=20
 	if (m->u.kernel.match->checkentry
 	    && !m->u.kernel.match->checkentry(name, ipv6, m->data,
@@ -775,22 +839,16 @@ check_entry(struct ip6t_entry *e, const=20
 		goto cleanup_matches;
=20
 	t =3D ip6t_get_target(e);
-	target =3D ip6t_find_target_lock(t->u.user.name, &ret, &ip6t_mutex);
-	if (!target) {
+	target =3D try_then_request_module(find_target(t->u.user.name,
+						     t->u.user.revision),
+					 "ip6t_%s", t->u.user.name);
+	if (IS_ERR(target) || !target) {
 		duprintf("check_entry: `%s' not found\n", t->u.user.name);
-		goto cleanup_matches;
-	}
-	if (!try_module_get(target->me)) {
-		up(&ip6t_mutex);
-		ret =3D -ENOENT;
+		ret =3D target ? PTR_ERR(target) : -ENOENT;
 		goto cleanup_matches;
 	}
 	t->u.kernel.target =3D target;
-	up(&ip6t_mutex);
-	if (!t->u.kernel.target) {
-		ret =3D -EBUSY;
-		goto cleanup_matches;
-	}
+
 	if (t->u.kernel.target =3D=3D &ip6t_standard_target) {
 		if (!standard_check(t, size)) {
 			ret =3D -EINVAL;
@@ -1115,8 +1173,8 @@ get_entries(const struct ip6t_get_entrie
 	int ret;
 	struct ip6t_table *t;
=20
-	t =3D ip6t_find_table_lock(entries->name, &ret, &ip6t_mutex);
-	if (t) {
+	t =3D find_table_lock(entries->name);
+	if (t && !IS_ERR(t)) {
 		duprintf("t->private->number =3D %u\n",
 			 t->private->number);
 		if (entries->size =3D=3D t->private->size)
@@ -1128,10 +1186,10 @@ get_entries(const struct ip6t_get_entrie
 				 entries->size);
 			ret =3D -EINVAL;
 		}
+		module_put(t->me);
 		up(&ip6t_mutex);
 	} else
-		duprintf("get_entries: Can't find %s!\n",
-			 entries->name);
+		ret =3D t ? PTR_ERR(t) : -ENOENT;
=20
 	return ret;
 }
@@ -1178,22 +1236,19 @@ do_replace(void __user *user, unsigned i
=20
 	duprintf("ip_tables: Translated table\n");
=20
-	t =3D ip6t_find_table_lock(tmp.name, &ret, &ip6t_mutex);
-	if (!t)
+	t =3D try_then_request_module(find_table_lock(tmp.name),
+				    "ip6table_%s", tmp.name);
+	if (!t || IS_ERR(t)) {
+		ret =3D t ? PTR_ERR(t) : -ENOENT;
 		goto free_newinfo_counters_untrans;
+	}
=20
 	/* You lied! */
 	if (tmp.valid_hooks !=3D t->valid_hooks) {
 		duprintf("Valid hook crap: %08X vs %08X\n",
 			 tmp.valid_hooks, t->valid_hooks);
 		ret =3D -EINVAL;
-		goto free_newinfo_counters_untrans_unlock;
-	}
-
-	/* Get a reference in advance, we're not allowed fail later */
-	if (!try_module_get(t->me)) {
-		ret =3D -EBUSY;
-		goto free_newinfo_counters_untrans_unlock;
+		goto put_module;
 	}
=20
 	oldinfo =3D replace_table(t, tmp.num_counters, newinfo, &ret);
@@ -1215,7 +1270,6 @@ do_replace(void __user *user, unsigned i
 	/* Decrease module usage counts and free resource */
 	IP6T_ENTRY_ITERATE(oldinfo->entries, oldinfo->size, cleanup_entry,NULL);
 	vfree(oldinfo);
-	/* Silent error: too late now. */
 	if (copy_to_user(tmp.counters, counters,
 			 sizeof(struct ip6t_counters) * tmp.num_counters) !=3D 0)
 		ret =3D -EFAULT;
@@ -1225,7 +1279,6 @@ do_replace(void __user *user, unsigned i
=20
  put_module:
 	module_put(t->me);
- free_newinfo_counters_untrans_unlock:
 	up(&ip6t_mutex);
  free_newinfo_counters_untrans:
 	IP6T_ENTRY_ITERATE(newinfo->entries, newinfo->size, cleanup_entry,NULL);
@@ -1264,7 +1317,7 @@ do_add_counters(void __user *user, unsig
 	unsigned int i;
 	struct ip6t_counters_info tmp, *paddc;
 	struct ip6t_table *t;
-	int ret;
+	int ret =3D 0;
=20
 	if (copy_from_user(&tmp, user, sizeof(tmp)) !=3D 0)
 		return -EFAULT;
@@ -1281,9 +1334,11 @@ do_add_counters(void __user *user, unsig
 		goto free;
 	}
=20
-	t =3D ip6t_find_table_lock(tmp.name, &ret, &ip6t_mutex);
-	if (!t)
+	t =3D find_table_lock(tmp.name);
+	if (!t || IS_ERR(t)) {
+		ret =3D t ? PTR_ERR(t) : -ENOENT;
 		goto free;
+	}
=20
 	write_lock_bh(&t->lock);
 	if (t->private->number !=3D paddc->num_counters) {
@@ -1300,6 +1355,7 @@ do_add_counters(void __user *user, unsig
  unlock_up_free:
 	write_unlock_bh(&t->lock);
 	up(&ip6t_mutex);
+	module_put(t->me);
  free:
 	vfree(paddc);
=20
@@ -1356,8 +1412,10 @@ do_ip6t_get_ctl(struct sock *sk, int cmd
 			break;
 		}
 		name[IP6T_TABLE_MAXNAMELEN-1] =3D '\0';
-		t =3D ip6t_find_table_lock(name, &ret, &ip6t_mutex);
-		if (t) {
+
+		t =3D try_then_request_module(find_table_lock(name),
+					    "ip6table_%s", name);
+		if (t && !IS_ERR(t)) {
 			struct ip6t_getinfo info;
=20
 			info.valid_hooks =3D t->valid_hooks;
@@ -1373,9 +1431,10 @@ do_ip6t_get_ctl(struct sock *sk, int cmd
 				ret =3D -EFAULT;
 			else
 				ret =3D 0;
-
 			up(&ip6t_mutex);
-		}
+			module_put(t->me);
+		} else
+			ret =3D t ? PTR_ERR(t) : -ENOENT;
 	}
 	break;
=20
@@ -1396,6 +1455,31 @@ do_ip6t_get_ctl(struct sock *sk, int cmd
 		break;
 	}
=20
+	case IP6T_SO_GET_REVISION_MATCH:
+	case IP6T_SO_GET_REVISION_TARGET: {
+		struct ip6t_get_revision rev;
+		int (*revfn)(const char *, u8, int *);
+
+		if (*len !=3D sizeof(rev)) {
+			ret =3D -EINVAL;
+			break;
+		}
+		if (copy_from_user(&rev, user, sizeof(rev)) !=3D 0) {
+			ret =3D -EFAULT;
+			break;
+		}
+
+		if (cmd =3D=3D IP6T_SO_GET_REVISION_TARGET)
+			revfn =3D target_revfn;
+		else
+			revfn =3D match_revfn;
+
+		try_then_request_module(find_revision(rev.name, rev.revision,
+						      revfn, &ret),
+					"ip6t_%s", rev.name);
+		break;
+	}
+
 	default:
 		duprintf("do_ip6t_get_ctl: unknown request %i\n", cmd);
 		ret =3D -EINVAL;
@@ -1413,12 +1497,7 @@ ip6t_register_target(struct ip6t_target=20
 	ret =3D down_interruptible(&ip6t_mutex);
 	if (ret !=3D 0)
 		return ret;
-
-	if (!list_named_insert(&ip6t_target, target)) {
-		duprintf("ip6t_register_target: `%s' already in list!\n",
-			 target->name);
-		ret =3D -EINVAL;
-	}
+	list_add(&target->list, &ip6t_target);
 	up(&ip6t_mutex);
 	return ret;
 }
@@ -1440,11 +1519,7 @@ ip6t_register_match(struct ip6t_match *m
 	if (ret !=3D 0)
 		return ret;
=20
-	if (!list_named_insert(&ip6t_match, match)) {
-		duprintf("ip6t_register_match: `%s' already in list!\n",
-			 match->name);
-		ret =3D -EINVAL;
-	}
+	list_add(&match->list, &ip6t_match);
 	up(&ip6t_mutex);
=20
 	return ret;

--RpqchZ26BWispMcB--

--UBnjLfzoMQYIXCvq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDSZkUXaXGVTD0i/8RAhfjAKCiQrkAuDsHMhBYN1eEmh7cEtkfkQCeIryG
il9ansbQ7iK3NScWryGfbqQ=
=opBE
-----END PGP SIGNATURE-----

--UBnjLfzoMQYIXCvq--
