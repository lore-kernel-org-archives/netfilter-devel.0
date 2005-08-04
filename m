From: Bryan Cardillo <dillo+netfilter@seas.upenn.edu>
Subject: Re: [PATCH] 2/3 pom expire
Date: Thu, 4 Aug 2005 12:07:56 -0400
Message-ID: <20050804160755.GC1975@home.seas.upenn.edu>
References: <20050804155512.GA1975@home.seas.upenn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050804155512.GA1975@home.seas.upenn.edu>
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

        in case my initial warning about this being a work in
        progress was not enough, there's an off-by-one bug in my
        patch numbering scheme, sorry, just not my day... should
        have been 1,2, and 3 of 3 (or 0, 1, and 2 of 2).

        --Bryan

 linux-2.6.10/include/linux/netfilter_ipv6/ip6t_expire.h |    3=20
 linux-2.6.10/net/ipv6/netfilter/ip6t_expire.c           |  725 +++++++--=
-------
 linux-2.6/include/linux/netfilter_ipv6/ip6t_expire.h    |    3=20
 linux-2.6/net/ipv6/netfilter/ip6t_expire.c              |  725 +++++++--=
-------
 4 files changed, 694 insertions(+), 762 deletions(-)

Index: patchlets/expire/linux-2.6.10/include/linux/netfilter_ipv6/ip6t_ex=
pire.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- patchlets/expire/linux-2.6.10/include/linux/netfilter_ipv6/ip6t_expir=
e.h	(revision 4210)
+++ patchlets/expire/linux-2.6.10/include/linux/netfilter_ipv6/ip6t_expir=
e.h	(working copy)
@@ -26,7 +26,8 @@
 #include <linux/types.h>
=20
 struct ip6t_exp_info {
-	time_t expiration;
+	time_t expires;
+	time_t delay;
 };
=20
 #endif
Index: patchlets/expire/linux-2.6/include/linux/netfilter_ipv6/ip6t_expir=
e.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- patchlets/expire/linux-2.6/include/linux/netfilter_ipv6/ip6t_expire.h=
	(revision 4210)
+++ patchlets/expire/linux-2.6/include/linux/netfilter_ipv6/ip6t_expire.h=
	(working copy)
@@ -26,7 +26,8 @@
 #include <linux/types.h>
=20
 struct ip6t_exp_info {
-	time_t expiration;
+	time_t expires;
+	time_t delay;
 };
=20
 #endif
Index: patchlets/expire/linux-2.6.10/net/ipv6/netfilter/ip6t_expire.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- patchlets/expire/linux-2.6.10/net/ipv6/netfilter/ip6t_expire.c	(revis=
ion 4210)
+++ patchlets/expire/linux-2.6.10/net/ipv6/netfilter/ip6t_expire.c	(worki=
ng copy)
@@ -17,7 +17,7 @@
  *      59 Temple Place, Suite 330
  *      Boston, MA  02111-1307  USA
  *
- * Copyright =A9 2005 Bryan Cardillo <dillo@seas.upenn.edu>
+ * Copyright (c) 2005 Bryan Cardillo <dillo@seas.upenn.edu>
  */
=20
 #include <linux/config.h>
@@ -39,311 +39,84 @@
 MODULE_AUTHOR("Bryan Cardillo <dillo@seas.upenn.edu>");
 MODULE_DESCRIPTION("an ip6tables expiring match module");
 MODULE_LICENSE("GPL");
-MODULE_VERSION("1.1");
-static int __init ip6t_exp_init(void);
-static void __exit ip6t_exp_exit(void);
-module_init(ip6t_exp_init);
-module_exit(ip6t_exp_exit);
+MODULE_VERSION("1.2");
=20
-static int ip6t_exp_match(const struct sk_buff *,
-		const struct net_device *, const struct net_device *,
-		const void *, int, unsigned int, int *);
-static int ip6t_exp_checkentry(const char *, const struct ip6t_ip6 *,
-		void *, unsigned int, unsigned int);
-static int ip6t_exp_add_table(const char *);
-static void ip6t_exp_remove_table(const char *);
-static void ip6t_exp_schedule_expiration(time_t);
-static void ip6t_exp_work_fn(void *);
-static int ip6t_exp_get_info(const char *, struct ip6t_getinfo *);
-static int ip6t_exp_get_entries(struct ip6t_getinfo *, struct ip6t_get_e=
ntries *);
-static int ip6t_exp_get_active(struct ip6t_getinfo *,
-		struct ip6t_get_entries *, struct ip6t_replace *);
-static int ip6t_exp_copy_active(struct ip6t_entry *, struct ip6t_replace=
 *);
-static int ip6t_exp_is_expired(struct ip6t_entry_match *);
-static int ip6t_exp_replace_expired(struct ip6t_replace *);
-static int ip6t_exp_get_counters(struct ip6t_get_entries *,
-		struct ip6t_replace *, struct ip6t_counters_info *);
-static int ip6t_exp_copy_counter(struct ip6t_entry *, struct ip6t_replac=
e *,
-		struct ip6t_counters_info *, int *);
-static int ip6t_exp_restore_counters(struct ip6t_counters_info *);
-
-/**
- * struct for list of tables
- */
 struct ip6t_exp_table {
-	/**
-	 * the table name
-	 */
 	char name[IP6T_TABLE_MAXNAMELEN];
-	/**
-	 * a list_head structure enabling list inclusion
-	 */
 	struct list_head list;
 };
=20
-/**
- * work_struct for scheduling the deletion of expired rules
- */
-static DECLARE_WORK(ip6t_exp_work, &ip6t_exp_work_fn, NULL);
-
-/**
- * ip6tables match
- */
-static struct ip6t_match ip6t_expire_match =3D {
-	.name		=3D "expire",
-	.match		=3D &ip6t_exp_match,
-	.checkentry	=3D &ip6t_exp_checkentry,
-	.me		=3D THIS_MODULE
+struct ip6t_exp_entry {
+	unsigned int offset;
+	unsigned int size;
 };
=20
-/**
- * the list of tables contained expiring entries
- */
-static spinlock_t ip6t_exp_tables_lock =3D SPIN_LOCK_UNLOCKED;
-static LIST_HEAD(ip6t_exp_tables);
+static spinlock_t tables_lock =3D SPIN_LOCK_UNLOCKED;
+static LIST_HEAD(tables);
=20
-/**
- * initialize module and register ip6tables match
- * @see module_init()
- * @see ip6t_register_match()
- */
-static int __init
-ip6t_exp_init(void)
+static struct ip6t_exp_table *
+find_table(const char *tablename)
 {
-	dprintk("initializing");
-	ip6t_register_match(&ip6t_expire_match);
-	return 0;
+	struct ip6t_exp_table *t;
+	list_for_each_entry(t, &tables, list)
+		if (strncmp(t->name, tablename, IP6T_TABLE_MAXNAMELEN) =3D=3D 0)
+			return t;
+	return NULL;
 }
=20
-/**
- * cleanup module and unregister ip6tables match
- * @see module_exit()
- * @see ip6t_unregister_match()
- */
-static void __exit
-ip6t_exp_exit(void)
-{
-	unsigned long flags;
-	struct ip6t_exp_table *t, *tmp;
-
-	dprintk("exiting");
-
-	ip6t_unregister_match(&ip6t_expire_match);
-	cancel_delayed_work(&ip6t_exp_work);
-=09
-	spin_lock_irqsave(&ip6t_exp_tables_lock, flags);
-	list_for_each_entry_safe(t, tmp, &ip6t_exp_tables, list)
-		kfree(t);
-	spin_unlock_irqrestore(&ip6t_exp_tables_lock, flags);
-}
-
-/**
- * match if the expiration time has't passed
- * @param skb socket buffer
- * @param in inbound network device
- * @param out outbound network device
- * @param matchinfo match specific data
- * @param offset match offset (?)
- * @param header (?)
- * @param len (?)
- * @param hotdrop set to 1 to drop packet immediately when returning fal=
se
- * @return non-zero for active rules, zero otherwise
- * @see struct ip6t_match
- */
 static int
-ip6t_exp_match(const struct sk_buff *skb,
-		const struct net_device *in, const struct net_device *out,
-		const void *matchinfo, int offset,
-		unsigned int protoff, int *hotdrop)
+add_table(const char *tablename)
 {
-	const struct ip6t_exp_info *info =3D matchinfo;
-
-	if (get_seconds() < info->expiration)
-		return 1;
-
-	return 0;
-}
-
-/**
- * check a new ip6tables entry
- * @param tablename table name for new entry
- * @param ip ip info for new entry
- * @param matchinfo match specific data
- * @param matchsize size of matchinfo data
- * @param hookmask valid netfilter hooks (?)
- * @return non-zero for valid entries, zero otherwise
- */
-static int
-ip6t_exp_checkentry(const char *tablename, const struct ip6t_ip6 *ip,
-		void *matchinfo, unsigned int matchsize, unsigned int hookmask)
-{
-	struct ip6t_exp_info *info =3D matchinfo;
-
-	if (matchsize !=3D IP6T_ALIGN(sizeof(struct ip6t_exp_info)))
-		return 0;
-
-	if (info->expiration <=3D get_seconds())
-		return 0;
-
-	if (ip6t_exp_add_table(tablename))
-		return 0;
-
-	ip6t_exp_schedule_expiration(info->expiration);
-
-	return 1;
-}
-
-/**
- * add a table to the set of tables to be searched for expired rules
- * @param tablename the name of the table
- * @return zero on success, non-zero on failure
- */
-static int
-ip6t_exp_add_table(const char *tablename)
-{
 	unsigned long flags;
 	struct ip6t_exp_table *t;
=20
-	spin_lock_irqsave(&ip6t_exp_tables_lock, flags);
-	list_for_each_entry(t, &ip6t_exp_tables, list)
-		if (strncmp(t->name, tablename, IP6T_TABLE_MAXNAMELEN) =3D=3D 0)
-			break;
-	spin_unlock_irqrestore(&ip6t_exp_tables_lock, flags);
+	/**
+	 * FIXME need a better solution here, can't allocate
+	 * memory while holding a lock, so we have to search
+	 * twice to avoid insertion race and not allocate memory
+	 * in the common case
+	 */
+	spin_lock_irqsave(&tables_lock, flags);
+	if (find_table(tablename)) {
+		spin_unlock_irqrestore(&tables_lock, flags);
+		return 0;
+	}
+	spin_unlock_irqrestore(&tables_lock, flags);
=20
-	if (&t->list =3D=3D &ip6t_exp_tables) {
-		if (!(t =3D kmalloc(sizeof(struct ip6t_exp_table), GFP_KERNEL))) {
-			dprintk("error allocating memory");
-			return -ENOMEM;
-		}
-		strlcpy(t->name, tablename, IP6T_TABLE_MAXNAMELEN);
-		spin_lock_irqsave(&ip6t_exp_tables_lock, flags);
-		list_add_tail(&t->list, &ip6t_exp_tables);
-		spin_unlock_irqrestore(&ip6t_exp_tables_lock, flags);
+	if (!(t =3D kmalloc(sizeof(struct ip6t_exp_table), GFP_KERNEL))) {
+		dprintk("error allocating memory");
+		return -ENOMEM;
 	}
-	return 0;
-}
+	strlcpy(t->name, tablename, IP6T_TABLE_MAXNAMELEN);
=20
-/**
- * remove a table from the set of tables to be searched for expired rule=
s
- * @param tablename the name of the table to be removed
- */
-static void
-ip6t_exp_remove_table(const char *tablename)
-{
-	unsigned long flags;
-	struct ip6t_exp_table *t, *tmp;
-
-	spin_lock_irqsave(&ip6t_exp_tables_lock, flags);
-	list_for_each_entry_safe(t, tmp, &ip6t_exp_tables, list) {
-		if (strncmp(t->name, tablename, IP6T_TABLE_MAXNAMELEN) =3D=3D 0) {
-			list_del(&t->list);
-			kfree(t);
-		}
+	spin_lock_irqsave(&tables_lock, flags);
+	if (find_table(tablename)) {
+		spin_unlock_irqrestore(&tables_lock, flags);
+		kfree(t);
+		return 0;
 	}
-	spin_unlock_irqrestore(&ip6t_exp_tables_lock, flags);
-}
=20
-/**
- * schedule the next removal of expired rules
- * @param expiration the time to be scheduled
- */
-static void
-ip6t_exp_schedule_expiration(time_t expiration)
-{
-	unsigned long delay =3D (expiration - get_seconds() < 1) ? HZ :
-					(expiration - get_seconds()) * HZ;
+	list_add_tail(&t->list, &tables);
+	spin_unlock_irqrestore(&tables_lock, flags);
=20
-	schedule_delayed_work(&ip6t_exp_work, delay);
+	return 0;
 }
=20
-/**
- * delete expired ip6tables rules
- * @param __notused
- * @see schedule_delayed_work()
- */
 static void
-ip6t_exp_work_fn(void *__notused)
+remove_table(const char *tablename)
 {
+	unsigned long flags;
 	struct ip6t_exp_table *t;
=20
-	/*
-	 * FIXME what about locking here?
-	 */
-	list_for_each_entry(t, &ip6t_exp_tables, list) {
-		size_t sz;
-		struct ip6t_getinfo info;
-		struct ip6t_get_entries *entries =3D NULL;
-		struct ip6t_replace *replace =3D NULL;
-		struct ip6t_counters_info *counters =3D NULL;
-
-		dprintk("expiring %s entries", t->name);
-
-		/* get table info */
-		if (ip6t_exp_get_info(t->name, &info))
-			continue;
-
-		/* allocate memory */
-		sz =3D sizeof(struct ip6t_get_entries) + info.size;
-		if (!(entries =3D vmalloc(sz))) {
-			dprintk("error allocating entry table");
-			break;
-		}
-		sz =3D sizeof(struct ip6t_replace) + info.size;
-		if (!(replace =3D vmalloc(sz))) {
-			dprintk("error allocating replacement table");
-			goto out_free_entries;
-		}
-		memset(replace, 0, sz);
-		sz =3D sizeof(struct ip6t_counters) * info.num_entries;
-		if (!(replace->counters =3D vmalloc(sz))) {
-			dprintk("error allocating counters");
-			goto out_free_entries_replace;
-		}
-		memset(replace->counters, 0, sz);
-		sz +=3D sizeof(struct ip6t_counters_info);
-		if (!(counters =3D vmalloc(sz))) {
-			dprintk("error allocating new counters");
-			goto out_free_entries_replace_counters;
-		}
-		memset(counters, 0, sz);
-
-		/* get all entries, then copy active ones */
-		if (ip6t_exp_get_entries(&info, entries))
-			goto out_free_entries_replace_counters_info;
-		if (ip6t_exp_get_active(&info, entries, replace))
-			goto out_free_entries_replace_counters_info;
-
-		/* replace table */
-		if (replace->size < info.size) {
-			if (ip6t_exp_get_counters(entries, replace, counters))
-				goto out_free_entries_replace_counters_info;
-			if (ip6t_exp_replace_expired(replace))
-				goto out_free_entries_replace_counters_info;
-			if (ip6t_exp_restore_counters(counters))
-				goto out_free_entries_replace_counters_info;
-		}
-
-		dprintk("expired %s entries", t->name);
-
-out_free_entries_replace_counters_info:
-		vfree(counters);
-out_free_entries_replace_counters:
-		vfree(replace->counters);
-out_free_entries_replace:
-		vfree(replace);
-out_free_entries:
-		vfree(entries);
-	}
+	spin_lock_irqsave(&tables_lock, flags);
+	if ((t =3D find_table(tablename)))
+		list_del(&t->list);
+	spin_unlock_irqrestore(&tables_lock, flags);
+	kfree(t);
 }
=20
-/**
- * get info on an a table
- * @param name the name of the table
- * @param info the location to store the retrieved info
- * @return zero on success, non-zero otherwise
- */
 static int
-ip6t_exp_get_info(const char *name, struct ip6t_getinfo *info)
+get_info(const char *name, struct ip6t_getinfo *info)
 {
 	int ret =3D 0;
 	int sz =3D sizeof(struct ip6t_getinfo);
@@ -357,25 +130,39 @@
 			break;
 		case -ENOENT:
 			/* table is gone */
-			ip6t_exp_remove_table(name);
+			remove_table(name);
 			break;
 		default:
-			dprintk("error getting ip6tables info");
+			dprintk("error getting iptables info");
 			break;
 	}
=20
 	return ret;
 }
=20
-/**
- * get the entries for a table
- * @param info the location of info about the table
- * @param entries the location to allocate and store the retrieved entri=
es
- * @return zero on success, non-zero otherwise
- */
 static int
-ip6t_exp_get_entries(struct ip6t_getinfo *info, struct ip6t_get_entries =
*entries)
+is_expired(struct ip6t_entry_match *match, time_t now)
 {
+	if (strcmp(match->u.user.name, "expire") =3D=3D 0) {
+		struct ip6t_exp_info *info =3D (struct ip6t_exp_info *)match->data;
+		if (info->expires <=3D now)
+			return 1;
+	}
+	return 0;
+}
+
+static int
+count_entries(struct ip6t_entry *entry, time_t now, int *expired)
+{
+	if (IP6T_MATCH_ITERATE(entry, is_expired, now))
+		(*expired)++;
+	return 0;
+}
+
+static int
+get_entries(struct ip6t_getinfo *info,
+		struct ip6t_get_entries *entries, time_t now, int *expired)
+{
 	int ret =3D 0;
 	int sz =3D sizeof(struct ip6t_get_entries) + info->size;
=20
@@ -385,24 +172,74 @@
 	entries->size =3D info->size;
 	ret =3D nf_getsockopt(NULL, PF_INET,
 			IP6T_SO_GET_ENTRIES, (char *)entries, &sz);
-	if (ret)
-		dprintk("error getting ip6tables entries");
+	if (!ret) {
+		IP6T_ENTRY_ITERATE(entries->entrytable, entries->size,
+					count_entries, now, expired);
+	} else {
+		dprintk("error getting iptables entries");
+	}
=20
 	return ret;
 }
=20
-/**
- * iterate over a tables entries, copying entries which
- * are not expired to the replacement table
- * @param info the location of info about the table
- * @param entries the location of the table entries
- * @param replace the location to allocate and store the replacement ent=
ries
- * @return zero on success, non-zero otherwise
- */
 static int
-ip6t_exp_get_active(struct ip6t_getinfo *info,
-		struct ip6t_get_entries *entries, struct ip6t_replace *replace)
+get_expired_entry(struct ip6t_entry *entry, struct ip6t_entry *base,
+		struct ip6t_exp_entry *expired, time_t now, int *index)
 {
+	if (IP6T_MATCH_ITERATE(entry, is_expired, now)) {
+		expired[(*index)].offset =3D (void *)entry - (void *)base;
+		expired[(*index)].size =3D entry->next_offset;
+		(*index)++;
+	}
+	return 0;
+}
+
+static void
+get_expired_info(struct ip6t_get_entries *entries,
+		struct ip6t_exp_entry *expired, time_t now)
+{
+	int index =3D 0;
+	IP6T_ENTRY_ITERATE(entries->entrytable, entries->size,
+			get_expired_entry, entries->entrytable,
+			expired, now, &index);
+}
+
+static void
+fix_target(struct ip6t_entry *dest, struct ip6t_entry *entry,
+		struct ip6t_exp_entry *expired, size_t ecnt)
+{
+	struct ip6t_standard_target *t =3D
+		(void *)dest + dest->target_offset;
+	char *name =3D t->target.u.user.name;
+	if (!strcmp(name, IP6T_STANDARD_TARGET) && t->verdict > 0) {
+		int i;
+		for (i =3D 0; i < ecnt; i++)
+			if (expired[i].offset < t->verdict)
+				t->verdict -=3D expired[i].size;
+	}
+}
+
+static int
+copy_active(struct ip6t_entry *entry, struct ip6t_replace *replace,
+		time_t now, struct ip6t_exp_entry *expired, size_t ecnt)
+{
+	if (!(IP6T_MATCH_ITERATE(entry, is_expired, now))) {
+		struct ip6t_entry *dest =3D
+			(void *)replace->entries + replace->size;
+		memcpy(dest, entry, entry->next_offset);
+		fix_target(dest, entry, expired, ecnt);
+		replace->size +=3D entry->next_offset;
+		replace->num_entries++;
+	}
+
+	return 0;
+}
+
+static void
+get_active(struct ip6t_getinfo *info, struct ip6t_get_entries *entries,
+		struct ip6t_replace *replace, time_t now,
+		struct ip6t_exp_entry *expired, size_t ecnt)
+{
 	dprintk("copying active entries");
=20
 	/* copy stuff */
@@ -416,58 +253,35 @@
 	replace->size =3D 0;
 	replace->num_entries =3D 0;
=20
-	return IP6T_ENTRY_ITERATE(entries->entrytable, entries->size,=20
-					ip6t_exp_copy_active, replace);
+	IP6T_ENTRY_ITERATE(entries->entrytable, entries->size,=20
+				copy_active, replace, now, expired, ecnt);
 }
=20
-/**
- * copy a table entry if it is not expired
- * @param entry the source entry
- * @param replace the replacement table
- * @return zero;
- */
-static int
-ip6t_exp_copy_active(struct ip6t_entry *entry, struct ip6t_replace *repl=
ace)
+static void
+fix_hooks(struct ip6t_replace *replace,
+		struct ip6t_exp_entry *expired, size_t ecnt)
 {
-	if (!(IP6T_MATCH_ITERATE(entry, ip6t_exp_is_expired))) {
-		struct ip6t_entry *dest =3D
-				(void *)replace->entries + replace->size;
-		memcpy(dest, entry, entry->next_offset);
-		replace->size +=3D entry->next_offset;
-		replace->num_entries++;
-	}
+	int i, j;
+	for (i =3D 0; i < NF_IP6_NUMHOOKS; i++) {
+		if (!(replace->valid_hooks & (1 << i)))
+			continue;
=20
-	return 0;
-}
-
-/**
- * determine if an entry is expired
- * @param match the entry match to check for expiration
- * @return non-zero for expired entries, zero otherwise
- */
-static int
-ip6t_exp_is_expired(struct ip6t_entry_match *match)
-{
-	if (strcmp(match->u.user.name, "expire") =3D=3D 0) {
-		struct ip6t_exp_info *info =3D (struct ip6t_exp_info *)match->data;
-		if (info->expiration <=3D get_seconds())
-			return 1;
+		for (j =3D 0; j < ecnt; j++) {
+			if (expired[j].offset < replace->hook_entry[i])
+				replace->hook_entry[i] -=3D expired[j].size;
+			if (expired[j].offset < replace->underflow[i])
+				replace->underflow[i] -=3D expired[j].size;
+		}
 	}
-	return 0;
 }
=20
-/**
- * update a table
- * @param replace the replacement table
- * @return zero on success, non-zero otherwise
- */
 static int
-ip6t_exp_replace_expired(struct ip6t_replace *replace)
+replace_entries(struct ip6t_replace *replace)
 {
 	int ret =3D 0;
 	int sz =3D sizeof(struct ip6t_replace) + replace->size;
=20
-	dprintk("replacing table %s", replace->name);
+	dprintk("replacing table \"%s\"", replace->name);
=20
 	ret =3D nf_setsockopt(NULL, PF_INET,
 			IP6T_SO_SET_REPLACE, (char *)replace, sz);
@@ -478,80 +292,59 @@
 		case 0:
 			break;
 		case -EFAULT:
-			dprintk("EFAULT replacing ip6tables");
+			dprintk("EFAULT replacing iptables");
 			break;
 		case -ENOPROTOOPT:
-			dprintk("ENOPROTOOPT replacing ip6tables");
+			dprintk("ENOPROTOOPT replacing iptables");
 			break;
 		case -ENOMEM:
-			dprintk("ENOMEM replacing ip6tables");
+			dprintk("ENOMEM replacing iptables");
 			break;
 		case -ENOENT:
-			dprintk("ENOENT replacing ip6tables");
+			dprintk("ENOENT replacing iptables");
 			break;
 		case -ELOOP:
-			dprintk("ELOOP replacing ip6tables");
+			dprintk("ELOOP replacing iptables");
 			break;
 		case -EINVAL:
-			dprintk("EINVAL replacing ip6tables");
+			dprintk("EINVAL replacing iptables");
 			break;
 		default:
-			dprintk("unknown error (%d) replacing ip6tables", ret);
+			dprintk("unknown error (%d) replacing iptables", ret);
 			break;
 	}
 	return ret;
 }
=20
-/**
- * get counters for unexpired entries
- * @param entries the entries info
- * @param replace the replacement structure, containing the old counters
- * @param counters the new counter info
- * @return zero on success, non-zero on failure
- */
 static int
-ip6t_exp_get_counters(struct ip6t_get_entries *entries,
-		struct ip6t_replace *replace,
-		struct ip6t_counters_info *counters)
+copy_counter(struct ip6t_entry *entry,
+		struct ip6t_replace *replace, time_t now,
+		struct ip6t_counters_info *counters, int *index)
 {
+	if (!(IP6T_MATCH_ITERATE(entry, is_expired, now)))
+		counters->counters[counters->num_counters++] =3D
+				replace->counters[*index];
+	(*index)++;
+	return 0;
+}
+
+static void
+get_counters(struct ip6t_get_entries *entries, struct ip6t_replace *repl=
ace,
+		time_t now, struct ip6t_counters_info *counters)
+{
 	int index =3D 0;
 	dprintk("copying active counters");
=20
-	/* init stuff */
 	strlcpy(counters->name, replace->name, IP6T_TABLE_MAXNAMELEN);
 	counters->num_counters =3D 0;
=20
-	return IP6T_ENTRY_ITERATE(entries->entrytable, entries->size,=20
-			ip6t_exp_copy_counter, replace, counters, &index);
+	IP6T_ENTRY_ITERATE(entries->entrytable, entries->size,=20
+				copy_counter, replace, now, counters, &index);
 }
=20
-/**
- * copy a rule counter if the rule is still active
- * @param entry the entry
- * @param replace the replacement structure containing the old counters
- * @param counter the new counter info
- * @param index the current entry index
- * @return zero
- */
 static int
-ip6t_exp_copy_counter(struct ip6t_entry *entry, struct ip6t_replace *rep=
lace,
-		struct ip6t_counters_info *counters, int *index)
+restore_counters(struct ip6t_counters_info *counters)
 {
-	if (!(IP6T_MATCH_ITERATE(entry, ip6t_exp_is_expired)))
-		counters->counters[counters->num_counters++] =3D
-				replace->counters[*index];
-	(*index)++;
-	return 0;
-}
-
-/**
- * restore the counters for a table
- * @param counter the counters
- * @return zero on success, non-zero otherwise
- */
-static int
-ip6t_exp_restore_counters(struct ip6t_counters_info *counters)
-{
 	int ret =3D 0;
 	int sz =3D sizeof(struct ip6t_counters_info) +
 			sizeof(struct ip6t_counters) * counters->num_counters;
@@ -564,3 +357,175 @@
 		dprintk("error restoring counters (%d)", ret);
 	return ret;
 }
+
+static void *
+exp_vmalloc(size_t size)
+{
+	void *p =3D vmalloc(size);
+	if (!p)
+		dprintk("error allocating memory");
+	return p;
+}
+
+static void
+delete_expired(void *__notused)
+{
+	struct ip6t_exp_table *t;
+	time_t now =3D get_seconds();
+
+	/*
+	 * FIXME what about locking here?
+	 */
+	list_for_each_entry(t, &tables, list) {
+		size_t sz, ecnt =3D 0;
+		struct ip6t_getinfo info;
+		struct ip6t_get_entries *entries =3D NULL;
+		struct ip6t_replace *replace =3D NULL;
+		struct ip6t_exp_entry *expired =3D NULL;
+		struct ip6t_counters_info *counters =3D NULL;
+
+		dprintk("expiring %s entries", t->name);
+
+		/* get table info */
+		if (get_info(t->name, &info))
+			continue;
+
+		sz =3D sizeof(struct ip6t_get_entries) + info.size;
+		if (!(entries =3D exp_vmalloc(sz)))
+			break;
+
+		if (get_entries(&info, entries, now, &ecnt))
+			goto out_free_ents;
+
+		if (!ecnt)
+			goto out_free_ents;
+
+		sz =3D sizeof(struct ip6t_exp_entry) * ecnt;
+		if (!(expired =3D exp_vmalloc(sz)))
+			goto out_free_ents;
+
+		get_expired_info(entries, expired, now);
+
+		sz =3D sizeof(struct ip6t_replace) + info.size;
+		if (!(replace =3D exp_vmalloc(sz)))
+			goto out_free_ents_exp;
+		memset(replace, 0, sz);
+
+		sz =3D sizeof(struct ip6t_counters) * info.num_entries;
+		if (!(replace->counters =3D exp_vmalloc(sz)))
+			goto out_free_ents_exp_repl;
+		memset(replace->counters, 0, sz);
+
+		sz +=3D sizeof(struct ip6t_counters_info);
+		if (!(counters =3D exp_vmalloc(sz)))
+			goto out_free_ents_exp_repl_cnt;
+		memset(counters, 0, sz);
+
+		get_active(&info, entries, replace, now, expired, ecnt);
+		get_counters(entries, replace, now, counters);
+		fix_hooks(replace, expired, ecnt);
+
+		if (replace_entries(replace))
+			goto out_free_ents_exp_repl_cnt_info;
+		if (restore_counters(counters))
+			goto out_free_ents_exp_repl_cnt_info;
+
+		dprintk("expired %s entries", t->name);
+
+out_free_ents_exp_repl_cnt_info:
+		vfree(counters);
+out_free_ents_exp_repl_cnt:
+		vfree(replace->counters);
+out_free_ents_exp_repl:
+		vfree(replace);
+out_free_ents_exp:
+		vfree(expired);
+out_free_ents:
+		vfree(entries);
+	}
+}
+
+static DECLARE_WORK(work, &delete_expired, NULL);
+
+static void
+schedule_expiration(struct ip6t_exp_info *info)
+{
+	unsigned long delay =3D (info->expires +
+				info->delay - get_seconds()) * HZ;
+	schedule_delayed_work(&work, delay);
+}
+
+static int
+match(const struct sk_buff *skb,
+		const struct net_device *in, const struct net_device *out,
+		const void *matchinfo, int offset,
+		unsigned int protoff, int *hotdrop)
+{
+	const struct ip6t_exp_info *info =3D matchinfo;
+
+	if (get_seconds() < info->expires)
+		return 1;
+
+	return 0;
+}
+
+static int
+checkentry(const char *tablename, const struct ip6t_ip6 *ip,
+		void *matchinfo, unsigned int matchsize, unsigned int hookmask)
+{
+	struct ip6t_exp_info *info =3D matchinfo;
+
+	if (matchsize !=3D IP6T_ALIGN(sizeof(struct ip6t_exp_info)))
+		return 0;
+
+	if (info->expires <=3D get_seconds())
+		return 0;
+
+	if (add_table(tablename))
+		return 0;
+
+	schedule_expiration(info);
+
+	return 1;
+}
+
+static struct ip6t_match ip6t_expire_match =3D {
+	.name		=3D "expire",
+	.match		=3D &match,
+	.checkentry	=3D &checkentry,
+	.me		=3D THIS_MODULE
+};
+
+static int __init
+ip6t_exp_init(void)
+{
+	dprintk("initializing");
+	ip6t_register_match(&ip6t_expire_match);
+	return 0;
+}
+
+static void __exit
+ip6t_exp_exit(void)
+{
+	LIST_HEAD(free_tables);
+	struct ip6t_exp_table *t, *tmp;
+	unsigned long flags;
+
+	dprintk("exiting");
+
+	ip6t_unregister_match(&ip6t_expire_match);
+	cancel_delayed_work(&work);
+=09
+	spin_lock_irqsave(&tables_lock, flags);
+	list_for_each_entry(t, &tables, list)
+		list_move_tail(&free_tables, &t->list);
+	spin_unlock_irqrestore(&tables_lock, flags);
+
+	list_for_each_entry_safe(t, tmp, &free_tables, list) {
+		list_del(&t->list);
+		kfree(t);
+	}
+}
+
+module_init(ip6t_exp_init);
+module_exit(ip6t_exp_exit);
Index: patchlets/expire/linux-2.6/net/ipv6/netfilter/ip6t_expire.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- patchlets/expire/linux-2.6/net/ipv6/netfilter/ip6t_expire.c	(revision=
 4210)
+++ patchlets/expire/linux-2.6/net/ipv6/netfilter/ip6t_expire.c	(working =
copy)
@@ -17,7 +17,7 @@
  *      59 Temple Place, Suite 330
  *      Boston, MA  02111-1307  USA
  *
- * Copyright =A9 2005 Bryan Cardillo <dillo@seas.upenn.edu>
+ * Copyright (c) 2005 Bryan Cardillo <dillo@seas.upenn.edu>
  */
=20
 #include <linux/config.h>
@@ -39,311 +39,84 @@
 MODULE_AUTHOR("Bryan Cardillo <dillo@seas.upenn.edu>");
 MODULE_DESCRIPTION("an ip6tables expiring match module");
 MODULE_LICENSE("GPL");
-MODULE_VERSION("1.1");
-static int __init ip6t_exp_init(void);
-static void __exit ip6t_exp_exit(void);
-module_init(ip6t_exp_init);
-module_exit(ip6t_exp_exit);
+MODULE_VERSION("1.2");
=20
-static int ip6t_exp_match(const struct sk_buff *,
-		const struct net_device *, const struct net_device *,
-		const void *, int, const void *, u_int16_t, int *);
-static int ip6t_exp_checkentry(const char *, const struct ip6t_ip6 *,
-		void *, unsigned int, unsigned int);
-static int ip6t_exp_add_table(const char *);
-static void ip6t_exp_remove_table(const char *);
-static void ip6t_exp_schedule_expiration(time_t);
-static void ip6t_exp_work_fn(void *);
-static int ip6t_exp_get_info(const char *, struct ip6t_getinfo *);
-static int ip6t_exp_get_entries(struct ip6t_getinfo *, struct ip6t_get_e=
ntries *);
-static int ip6t_exp_get_active(struct ip6t_getinfo *,
-		struct ip6t_get_entries *, struct ip6t_replace *);
-static int ip6t_exp_copy_active(struct ip6t_entry *, struct ip6t_replace=
 *);
-static int ip6t_exp_is_expired(struct ip6t_entry_match *);
-static int ip6t_exp_replace_expired(struct ip6t_replace *);
-static int ip6t_exp_get_counters(struct ip6t_get_entries *,
-		struct ip6t_replace *, struct ip6t_counters_info *);
-static int ip6t_exp_copy_counter(struct ip6t_entry *, struct ip6t_replac=
e *,
-		struct ip6t_counters_info *, int *);
-static int ip6t_exp_restore_counters(struct ip6t_counters_info *);
-
-/**
- * struct for list of tables
- */
 struct ip6t_exp_table {
-	/**
-	 * the table name
-	 */
 	char name[IP6T_TABLE_MAXNAMELEN];
-	/**
-	 * a list_head structure enabling list inclusion
-	 */
 	struct list_head list;
 };
=20
-/**
- * work_struct for scheduling the deletion of expired rules
- */
-static DECLARE_WORK(ip6t_exp_work, &ip6t_exp_work_fn, NULL);
-
-/**
- * ip6tables match
- */
-static struct ip6t_match ip6t_expire_match =3D {
-	.name		=3D "expire",
-	.match		=3D &ip6t_exp_match,
-	.checkentry	=3D &ip6t_exp_checkentry,
-	.me		=3D THIS_MODULE
+struct ip6t_exp_entry {
+	unsigned int offset;
+	unsigned int size;
 };
=20
-/**
- * the list of tables contained expiring entries
- */
-static spinlock_t ip6t_exp_tables_lock =3D SPIN_LOCK_UNLOCKED;
-static LIST_HEAD(ip6t_exp_tables);
+static spinlock_t tables_lock =3D SPIN_LOCK_UNLOCKED;
+static LIST_HEAD(tables);
=20
-/**
- * initialize module and register ip6tables match
- * @see module_init()
- * @see ip6t_register_match()
- */
-static int __init
-ip6t_exp_init(void)
+static struct ip6t_exp_table *
+find_table(const char *tablename)
 {
-	dprintk("initializing");
-	ip6t_register_match(&ip6t_expire_match);
-	return 0;
+	struct ip6t_exp_table *t;
+	list_for_each_entry(t, &tables, list)
+		if (strncmp(t->name, tablename, IP6T_TABLE_MAXNAMELEN) =3D=3D 0)
+			return t;
+	return NULL;
 }
=20
-/**
- * cleanup module and unregister ip6tables match
- * @see module_exit()
- * @see ip6t_unregister_match()
- */
-static void __exit
-ip6t_exp_exit(void)
-{
-	unsigned long flags;
-	struct ip6t_exp_table *t, *tmp;
-
-	dprintk("exiting");
-
-	ip6t_unregister_match(&ip6t_expire_match);
-	cancel_delayed_work(&ip6t_exp_work);
-=09
-	spin_lock_irqsave(&ip6t_exp_tables_lock, flags);
-	list_for_each_entry_safe(t, tmp, &ip6t_exp_tables, list)
-		kfree(t);
-	spin_unlock_irqrestore(&ip6t_exp_tables_lock, flags);
-}
-
-/**
- * match if the expiration time has't passed
- * @param skb socket buffer
- * @param in inbound network device
- * @param out outbound network device
- * @param matchinfo match specific data
- * @param offset match offset (?)
- * @param header (?)
- * @param len (?)
- * @param hotdrop set to 1 to drop packet immediately when returning fal=
se
- * @return non-zero for active rules, zero otherwise
- * @see struct ip6t_match
- */
 static int
-ip6t_exp_match(const struct sk_buff *skb,
-		const struct net_device *in, const struct net_device *out,
-		const void *matchinfo, int offset,
-		const void *header, u_int16_t len, int *hotdrop)
+add_table(const char *tablename)
 {
-	const struct ip6t_exp_info *info =3D matchinfo;
-
-	if (get_seconds() < info->expiration)
-		return 1;
-
-	return 0;
-}
-
-/**
- * check a new ip6tables entry
- * @param tablename table name for new entry
- * @param ip ip info for new entry
- * @param matchinfo match specific data
- * @param matchsize size of matchinfo data
- * @param hookmask valid netfilter hooks (?)
- * @return non-zero for valid entries, zero otherwise
- */
-static int
-ip6t_exp_checkentry(const char *tablename, const struct ip6t_ip6 *ip,
-		void *matchinfo, unsigned int matchsize, unsigned int hookmask)
-{
-	struct ip6t_exp_info *info =3D matchinfo;
-
-	if (matchsize !=3D IP6T_ALIGN(sizeof(struct ip6t_exp_info)))
-		return 0;
-
-	if (info->expiration <=3D get_seconds())
-		return 0;
-
-	if (ip6t_exp_add_table(tablename))
-		return 0;
-
-	ip6t_exp_schedule_expiration(info->expiration);
-
-	return 1;
-}
-
-/**
- * add a table to the set of tables to be searched for expired rules
- * @param tablename the name of the table
- * @return zero on success, non-zero on failure
- */
-static int
-ip6t_exp_add_table(const char *tablename)
-{
 	unsigned long flags;
 	struct ip6t_exp_table *t;
=20
-	spin_lock_irqsave(&ip6t_exp_tables_lock, flags);
-	list_for_each_entry(t, &ip6t_exp_tables, list)
-		if (strncmp(t->name, tablename, IP6T_TABLE_MAXNAMELEN) =3D=3D 0)
-			break;
-	spin_unlock_irqrestore(&ip6t_exp_tables_lock, flags);
+	/**
+	 * FIXME need a better solution here, can't allocate
+	 * memory while holding a lock, so we have to search
+	 * twice to avoid insertion race and not allocate memory
+	 * in the common case
+	 */
+	spin_lock_irqsave(&tables_lock, flags);
+	if (find_table(tablename)) {
+		spin_unlock_irqrestore(&tables_lock, flags);
+		return 0;
+	}
+	spin_unlock_irqrestore(&tables_lock, flags);
=20
-	if (&t->list =3D=3D &ip6t_exp_tables) {
-		if (!(t =3D kmalloc(sizeof(struct ip6t_exp_table), GFP_KERNEL))) {
-			dprintk("error allocating memory");
-			return -ENOMEM;
-		}
-		strlcpy(t->name, tablename, IP6T_TABLE_MAXNAMELEN);
-		spin_lock_irqsave(&ip6t_exp_tables_lock, flags);
-		list_add_tail(&t->list, &ip6t_exp_tables);
-		spin_unlock_irqrestore(&ip6t_exp_tables_lock, flags);
+	if (!(t =3D kmalloc(sizeof(struct ip6t_exp_table), GFP_KERNEL))) {
+		dprintk("error allocating memory");
+		return -ENOMEM;
 	}
-	return 0;
-}
+	strlcpy(t->name, tablename, IP6T_TABLE_MAXNAMELEN);
=20
-/**
- * remove a table from the set of tables to be searched for expired rule=
s
- * @param tablename the name of the table to be removed
- */
-static void
-ip6t_exp_remove_table(const char *tablename)
-{
-	unsigned long flags;
-	struct ip6t_exp_table *t, *tmp;
-
-	spin_lock_irqsave(&ip6t_exp_tables_lock, flags);
-	list_for_each_entry_safe(t, tmp, &ip6t_exp_tables, list) {
-		if (strncmp(t->name, tablename, IP6T_TABLE_MAXNAMELEN) =3D=3D 0) {
-			list_del(&t->list);
-			kfree(t);
-		}
+	spin_lock_irqsave(&tables_lock, flags);
+	if (find_table(tablename)) {
+		spin_unlock_irqrestore(&tables_lock, flags);
+		kfree(t);
+		return 0;
 	}
-	spin_unlock_irqrestore(&ip6t_exp_tables_lock, flags);
-}
=20
-/**
- * schedule the next removal of expired rules
- * @param expiration the time to be scheduled
- */
-static void
-ip6t_exp_schedule_expiration(time_t expiration)
-{
-	unsigned long delay =3D (expiration - get_seconds() < 1) ? HZ :
-					(expiration - get_seconds()) * HZ;
+	list_add_tail(&t->list, &tables);
+	spin_unlock_irqrestore(&tables_lock, flags);
=20
-	schedule_delayed_work(&ip6t_exp_work, delay);
+	return 0;
 }
=20
-/**
- * delete expired ip6tables rules
- * @param __notused
- * @see schedule_delayed_work()
- */
 static void
-ip6t_exp_work_fn(void *__notused)
+remove_table(const char *tablename)
 {
+	unsigned long flags;
 	struct ip6t_exp_table *t;
=20
-	/*
-	 * FIXME what about locking here?
-	 */
-	list_for_each_entry(t, &ip6t_exp_tables, list) {
-		size_t sz;
-		struct ip6t_getinfo info;
-		struct ip6t_get_entries *entries =3D NULL;
-		struct ip6t_replace *replace =3D NULL;
-		struct ip6t_counters_info *counters =3D NULL;
-
-		dprintk("expiring %s entries", t->name);
-
-		/* get table info */
-		if (ip6t_exp_get_info(t->name, &info))
-			continue;
-
-		/* allocate memory */
-		sz =3D sizeof(struct ip6t_get_entries) + info.size;
-		if (!(entries =3D vmalloc(sz))) {
-			dprintk("error allocating entry table");
-			break;
-		}
-		sz =3D sizeof(struct ip6t_replace) + info.size;
-		if (!(replace =3D vmalloc(sz))) {
-			dprintk("error allocating replacement table");
-			goto out_free_entries;
-		}
-		memset(replace, 0, sz);
-		sz =3D sizeof(struct ip6t_counters) * info.num_entries;
-		if (!(replace->counters =3D vmalloc(sz))) {
-			dprintk("error allocating counters");
-			goto out_free_entries_replace;
-		}
-		memset(replace->counters, 0, sz);
-		sz +=3D sizeof(struct ip6t_counters_info);
-		if (!(counters =3D vmalloc(sz))) {
-			dprintk("error allocating new counters");
-			goto out_free_entries_replace_counters;
-		}
-		memset(counters, 0, sz);
-
-		/* get all entries, then copy active ones */
-		if (ip6t_exp_get_entries(&info, entries))
-			goto out_free_entries_replace_counters_info;
-		if (ip6t_exp_get_active(&info, entries, replace))
-			goto out_free_entries_replace_counters_info;
-
-		/* replace table */
-		if (replace->size < info.size) {
-			if (ip6t_exp_get_counters(entries, replace, counters))
-				goto out_free_entries_replace_counters_info;
-			if (ip6t_exp_replace_expired(replace))
-				goto out_free_entries_replace_counters_info;
-			if (ip6t_exp_restore_counters(counters))
-				goto out_free_entries_replace_counters_info;
-		}
-
-		dprintk("expired %s entries", t->name);
-
-out_free_entries_replace_counters_info:
-		vfree(counters);
-out_free_entries_replace_counters:
-		vfree(replace->counters);
-out_free_entries_replace:
-		vfree(replace);
-out_free_entries:
-		vfree(entries);
-	}
+	spin_lock_irqsave(&tables_lock, flags);
+	if ((t =3D find_table(tablename)))
+		list_del(&t->list);
+	spin_unlock_irqrestore(&tables_lock, flags);
+	kfree(t);
 }
=20
-/**
- * get info on an a table
- * @param name the name of the table
- * @param info the location to store the retrieved info
- * @return zero on success, non-zero otherwise
- */
 static int
-ip6t_exp_get_info(const char *name, struct ip6t_getinfo *info)
+get_info(const char *name, struct ip6t_getinfo *info)
 {
 	int ret =3D 0;
 	int sz =3D sizeof(struct ip6t_getinfo);
@@ -357,25 +130,39 @@
 			break;
 		case -ENOENT:
 			/* table is gone */
-			ip6t_exp_remove_table(name);
+			remove_table(name);
 			break;
 		default:
-			dprintk("error getting ip6tables info");
+			dprintk("error getting iptables info");
 			break;
 	}
=20
 	return ret;
 }
=20
-/**
- * get the entries for a table
- * @param info the location of info about the table
- * @param entries the location to allocate and store the retrieved entri=
es
- * @return zero on success, non-zero otherwise
- */
 static int
-ip6t_exp_get_entries(struct ip6t_getinfo *info, struct ip6t_get_entries =
*entries)
+is_expired(struct ip6t_entry_match *match, time_t now)
 {
+	if (strcmp(match->u.user.name, "expire") =3D=3D 0) {
+		struct ip6t_exp_info *info =3D (struct ip6t_exp_info *)match->data;
+		if (info->expires <=3D now)
+			return 1;
+	}
+	return 0;
+}
+
+static int
+count_entries(struct ip6t_entry *entry, time_t now, int *expired)
+{
+	if (IP6T_MATCH_ITERATE(entry, is_expired, now))
+		(*expired)++;
+	return 0;
+}
+
+static int
+get_entries(struct ip6t_getinfo *info,
+		struct ip6t_get_entries *entries, time_t now, int *expired)
+{
 	int ret =3D 0;
 	int sz =3D sizeof(struct ip6t_get_entries) + info->size;
=20
@@ -385,24 +172,74 @@
 	entries->size =3D info->size;
 	ret =3D nf_getsockopt(NULL, PF_INET,
 			IP6T_SO_GET_ENTRIES, (char *)entries, &sz);
-	if (ret)
-		dprintk("error getting ip6tables entries");
+	if (!ret) {
+		IP6T_ENTRY_ITERATE(entries->entrytable, entries->size,
+					count_entries, now, expired);
+	} else {
+		dprintk("error getting iptables entries");
+	}
=20
 	return ret;
 }
=20
-/**
- * iterate over a tables entries, copying entries which
- * are not expired to the replacement table
- * @param info the location of info about the table
- * @param entries the location of the table entries
- * @param replace the location to allocate and store the replacement ent=
ries
- * @return zero on success, non-zero otherwise
- */
 static int
-ip6t_exp_get_active(struct ip6t_getinfo *info,
-		struct ip6t_get_entries *entries, struct ip6t_replace *replace)
+get_expired_entry(struct ip6t_entry *entry, struct ip6t_entry *base,
+		struct ip6t_exp_entry *expired, time_t now, int *index)
 {
+	if (IP6T_MATCH_ITERATE(entry, is_expired, now)) {
+		expired[(*index)].offset =3D (void *)entry - (void *)base;
+		expired[(*index)].size =3D entry->next_offset;
+		(*index)++;
+	}
+	return 0;
+}
+
+static void
+get_expired_info(struct ip6t_get_entries *entries,
+		struct ip6t_exp_entry *expired, time_t now)
+{
+	int index =3D 0;
+	IP6T_ENTRY_ITERATE(entries->entrytable, entries->size,
+			get_expired_entry, entries->entrytable,
+			expired, now, &index);
+}
+
+static void
+fix_target(struct ip6t_entry *dest, struct ip6t_entry *entry,
+		struct ip6t_exp_entry *expired, size_t ecnt)
+{
+	struct ip6t_standard_target *t =3D
+		(void *)dest + dest->target_offset;
+	char *name =3D t->target.u.user.name;
+	if (!strcmp(name, IP6T_STANDARD_TARGET) && t->verdict > 0) {
+		int i;
+		for (i =3D 0; i < ecnt; i++)
+			if (expired[i].offset < t->verdict)
+				t->verdict -=3D expired[i].size;
+	}
+}
+
+static int
+copy_active(struct ip6t_entry *entry, struct ip6t_replace *replace,
+		time_t now, struct ip6t_exp_entry *expired, size_t ecnt)
+{
+	if (!(IP6T_MATCH_ITERATE(entry, is_expired, now))) {
+		struct ip6t_entry *dest =3D
+			(void *)replace->entries + replace->size;
+		memcpy(dest, entry, entry->next_offset);
+		fix_target(dest, entry, expired, ecnt);
+		replace->size +=3D entry->next_offset;
+		replace->num_entries++;
+	}
+
+	return 0;
+}
+
+static void
+get_active(struct ip6t_getinfo *info, struct ip6t_get_entries *entries,
+		struct ip6t_replace *replace, time_t now,
+		struct ip6t_exp_entry *expired, size_t ecnt)
+{
 	dprintk("copying active entries");
=20
 	/* copy stuff */
@@ -416,58 +253,35 @@
 	replace->size =3D 0;
 	replace->num_entries =3D 0;
=20
-	return IP6T_ENTRY_ITERATE(entries->entrytable, entries->size,=20
-					ip6t_exp_copy_active, replace);
+	IP6T_ENTRY_ITERATE(entries->entrytable, entries->size,=20
+				copy_active, replace, now, expired, ecnt);
 }
=20
-/**
- * copy a table entry if it is not expired
- * @param entry the source entry
- * @param replace the replacement table
- * @return zero;
- */
-static int
-ip6t_exp_copy_active(struct ip6t_entry *entry, struct ip6t_replace *repl=
ace)
+static void
+fix_hooks(struct ip6t_replace *replace,
+		struct ip6t_exp_entry *expired, size_t ecnt)
 {
-	if (!(IP6T_MATCH_ITERATE(entry, ip6t_exp_is_expired))) {
-		struct ip6t_entry *dest =3D
-				(void *)replace->entries + replace->size;
-		memcpy(dest, entry, entry->next_offset);
-		replace->size +=3D entry->next_offset;
-		replace->num_entries++;
-	}
+	int i, j;
+	for (i =3D 0; i < NF_IP6_NUMHOOKS; i++) {
+		if (!(replace->valid_hooks & (1 << i)))
+			continue;
=20
-	return 0;
-}
-
-/**
- * determine if an entry is expired
- * @param match the entry match to check for expiration
- * @return non-zero for expired entries, zero otherwise
- */
-static int
-ip6t_exp_is_expired(struct ip6t_entry_match *match)
-{
-	if (strcmp(match->u.user.name, "expire") =3D=3D 0) {
-		struct ip6t_exp_info *info =3D (struct ip6t_exp_info *)match->data;
-		if (info->expiration <=3D get_seconds())
-			return 1;
+		for (j =3D 0; j < ecnt; j++) {
+			if (expired[j].offset < replace->hook_entry[i])
+				replace->hook_entry[i] -=3D expired[j].size;
+			if (expired[j].offset < replace->underflow[i])
+				replace->underflow[i] -=3D expired[j].size;
+		}
 	}
-	return 0;
 }
=20
-/**
- * update a table
- * @param replace the replacement table
- * @return zero on success, non-zero otherwise
- */
 static int
-ip6t_exp_replace_expired(struct ip6t_replace *replace)
+replace_entries(struct ip6t_replace *replace)
 {
 	int ret =3D 0;
 	int sz =3D sizeof(struct ip6t_replace) + replace->size;
=20
-	dprintk("replacing table %s", replace->name);
+	dprintk("replacing table \"%s\"", replace->name);
=20
 	ret =3D nf_setsockopt(NULL, PF_INET,
 			IP6T_SO_SET_REPLACE, (char *)replace, sz);
@@ -478,80 +292,59 @@
 		case 0:
 			break;
 		case -EFAULT:
-			dprintk("EFAULT replacing ip6tables");
+			dprintk("EFAULT replacing iptables");
 			break;
 		case -ENOPROTOOPT:
-			dprintk("ENOPROTOOPT replacing ip6tables");
+			dprintk("ENOPROTOOPT replacing iptables");
 			break;
 		case -ENOMEM:
-			dprintk("ENOMEM replacing ip6tables");
+			dprintk("ENOMEM replacing iptables");
 			break;
 		case -ENOENT:
-			dprintk("ENOENT replacing ip6tables");
+			dprintk("ENOENT replacing iptables");
 			break;
 		case -ELOOP:
-			dprintk("ELOOP replacing ip6tables");
+			dprintk("ELOOP replacing iptables");
 			break;
 		case -EINVAL:
-			dprintk("EINVAL replacing ip6tables");
+			dprintk("EINVAL replacing iptables");
 			break;
 		default:
-			dprintk("unknown error (%d) replacing ip6tables", ret);
+			dprintk("unknown error (%d) replacing iptables", ret);
 			break;
 	}
 	return ret;
 }
=20
-/**
- * get counters for unexpired entries
- * @param entries the entries info
- * @param replace the replacement structure, containing the old counters
- * @param counters the new counter info
- * @return zero on success, non-zero on failure
- */
 static int
-ip6t_exp_get_counters(struct ip6t_get_entries *entries,
-		struct ip6t_replace *replace,
-		struct ip6t_counters_info *counters)
+copy_counter(struct ip6t_entry *entry,
+		struct ip6t_replace *replace, time_t now,
+		struct ip6t_counters_info *counters, int *index)
 {
+	if (!(IP6T_MATCH_ITERATE(entry, is_expired, now)))
+		counters->counters[counters->num_counters++] =3D
+				replace->counters[*index];
+	(*index)++;
+	return 0;
+}
+
+static void
+get_counters(struct ip6t_get_entries *entries, struct ip6t_replace *repl=
ace,
+		time_t now, struct ip6t_counters_info *counters)
+{
 	int index =3D 0;
 	dprintk("copying active counters");
=20
-	/* init stuff */
 	strlcpy(counters->name, replace->name, IP6T_TABLE_MAXNAMELEN);
 	counters->num_counters =3D 0;
=20
-	return IP6T_ENTRY_ITERATE(entries->entrytable, entries->size,=20
-			ip6t_exp_copy_counter, replace, counters, &index);
+	IP6T_ENTRY_ITERATE(entries->entrytable, entries->size,=20
+				copy_counter, replace, now, counters, &index);
 }
=20
-/**
- * copy a rule counter if the rule is still active
- * @param entry the entry
- * @param replace the replacement structure containing the old counters
- * @param counter the new counter info
- * @param index the current entry index
- * @return zero
- */
 static int
-ip6t_exp_copy_counter(struct ip6t_entry *entry, struct ip6t_replace *rep=
lace,
-		struct ip6t_counters_info *counters, int *index)
+restore_counters(struct ip6t_counters_info *counters)
 {
-	if (!(IP6T_MATCH_ITERATE(entry, ip6t_exp_is_expired)))
-		counters->counters[counters->num_counters++] =3D
-				replace->counters[*index];
-	(*index)++;
-	return 0;
-}
-
-/**
- * restore the counters for a table
- * @param counter the counters
- * @return zero on success, non-zero otherwise
- */
-static int
-ip6t_exp_restore_counters(struct ip6t_counters_info *counters)
-{
 	int ret =3D 0;
 	int sz =3D sizeof(struct ip6t_counters_info) +
 			sizeof(struct ip6t_counters) * counters->num_counters;
@@ -564,3 +357,175 @@
 		dprintk("error restoring counters (%d)", ret);
 	return ret;
 }
+
+static void *
+exp_vmalloc(size_t size)
+{
+	void *p =3D vmalloc(size);
+	if (!p)
+		dprintk("error allocating memory");
+	return p;
+}
+
+static void
+delete_expired(void *__notused)
+{
+	struct ip6t_exp_table *t;
+	time_t now =3D get_seconds();
+
+	/*
+	 * FIXME what about locking here?
+	 */
+	list_for_each_entry(t, &tables, list) {
+		size_t sz, ecnt =3D 0;
+		struct ip6t_getinfo info;
+		struct ip6t_get_entries *entries =3D NULL;
+		struct ip6t_replace *replace =3D NULL;
+		struct ip6t_exp_entry *expired =3D NULL;
+		struct ip6t_counters_info *counters =3D NULL;
+
+		dprintk("expiring %s entries", t->name);
+
+		/* get table info */
+		if (get_info(t->name, &info))
+			continue;
+
+		sz =3D sizeof(struct ip6t_get_entries) + info.size;
+		if (!(entries =3D exp_vmalloc(sz)))
+			break;
+
+		if (get_entries(&info, entries, now, &ecnt))
+			goto out_free_ents;
+
+		if (!ecnt)
+			goto out_free_ents;
+
+		sz =3D sizeof(struct ip6t_exp_entry) * ecnt;
+		if (!(expired =3D exp_vmalloc(sz)))
+			goto out_free_ents;
+
+		get_expired_info(entries, expired, now);
+
+		sz =3D sizeof(struct ip6t_replace) + info.size;
+		if (!(replace =3D exp_vmalloc(sz)))
+			goto out_free_ents_exp;
+		memset(replace, 0, sz);
+
+		sz =3D sizeof(struct ip6t_counters) * info.num_entries;
+		if (!(replace->counters =3D exp_vmalloc(sz)))
+			goto out_free_ents_exp_repl;
+		memset(replace->counters, 0, sz);
+
+		sz +=3D sizeof(struct ip6t_counters_info);
+		if (!(counters =3D exp_vmalloc(sz)))
+			goto out_free_ents_exp_repl_cnt;
+		memset(counters, 0, sz);
+
+		get_active(&info, entries, replace, now, expired, ecnt);
+		get_counters(entries, replace, now, counters);
+		fix_hooks(replace, expired, ecnt);
+
+		if (replace_entries(replace))
+			goto out_free_ents_exp_repl_cnt_info;
+		if (restore_counters(counters))
+			goto out_free_ents_exp_repl_cnt_info;
+
+		dprintk("expired %s entries", t->name);
+
+out_free_ents_exp_repl_cnt_info:
+		vfree(counters);
+out_free_ents_exp_repl_cnt:
+		vfree(replace->counters);
+out_free_ents_exp_repl:
+		vfree(replace);
+out_free_ents_exp:
+		vfree(expired);
+out_free_ents:
+		vfree(entries);
+	}
+}
+
+static DECLARE_WORK(work, &delete_expired, NULL);
+
+static void
+schedule_expiration(struct ip6t_exp_info *info)
+{
+	unsigned long delay =3D (info->expires +
+				info->delay - get_seconds()) * HZ;
+	schedule_delayed_work(&work, delay);
+}
+
+static int
+match(const struct sk_buff *skb,
+		const struct net_device *in, const struct net_device *out,
+		const void *matchinfo, int offset, const void *header,
+		u_int16_t len, int *hotdrop)
+{
+	const struct ip6t_exp_info *info =3D matchinfo;
+
+	if (get_seconds() < info->expires)
+		return 1;
+
+	return 0;
+}
+
+static int
+checkentry(const char *tablename, const struct ip6t_ip6 *ip,
+		void *matchinfo, unsigned int matchsize, unsigned int hookmask)
+{
+	struct ip6t_exp_info *info =3D matchinfo;
+
+	if (matchsize !=3D IP6T_ALIGN(sizeof(struct ip6t_exp_info)))
+		return 0;
+
+	if (info->expires <=3D get_seconds())
+		return 0;
+
+	if (add_table(tablename))
+		return 0;
+
+	schedule_expiration(info);
+
+	return 1;
+}
+
+static struct ip6t_match ip6t_expire_match =3D {
+	.name		=3D "expire",
+	.match		=3D &match,
+	.checkentry	=3D &checkentry,
+	.me		=3D THIS_MODULE
+};
+
+static int __init
+ip6t_exp_init(void)
+{
+	dprintk("initializing");
+	ip6t_register_match(&ip6t_expire_match);
+	return 0;
+}
+
+static void __exit
+ip6t_exp_exit(void)
+{
+	LIST_HEAD(free_tables);
+	struct ip6t_exp_table *t, *tmp;
+	unsigned long flags;
+
+	dprintk("exiting");
+
+	ip6t_unregister_match(&ip6t_expire_match);
+	cancel_delayed_work(&work);
+=09
+	spin_lock_irqsave(&tables_lock, flags);
+	list_for_each_entry(t, &tables, list)
+		list_move_tail(&free_tables, &t->list);
+	spin_unlock_irqrestore(&tables_lock, flags);
+
+	list_for_each_entry_safe(t, tmp, &free_tables, list) {
+		list_del(&t->list);
+		kfree(t);
+	}
+}
+
+module_init(ip6t_exp_init);
+module_exit(ip6t_exp_exit);
