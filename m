From: Bryan Cardillo <dillo@seas.upenn.edu>
Subject: [RFC][PATCH] ipt_expire - expiring iptables rules
Date: Fri, 10 Jun 2005 10:52:48 -0400
Message-ID: <20050610145248.GA3201@rover.pcbi.upenn.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="FL5UXtIhxfXey3p5"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

        I've written a new match module for automatically expiring
        rules.  Basically, I want to be able to add a rule, and know
        it will eventually go away, without any additional work on
        my part.  I know, I could write some scripts to track and
        expire rules from cron or something, but this seemed like
        more fun.  Anyway, right now the module itself is pretty
        crude, so consider it a proof of concept.  I'm curious,
        would others find this useful?  Has this been done?

        Cheers,
        Bryan Cardillo

--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=iso-8859-1
Content-Description: ipt_expire-kernel.patch
Content-Disposition: attachment; filename="ipt_expire-kernel.patch"
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by rover.pcbi.upenn.edu id
	j5AEqmp5011145

diff -Nru a/include/linux/netfilter_ipv4/ipt_expire.h b/include/linux/net=
filter_ipv4/ipt_expire.h
--- a/include/linux/netfilter_ipv4/ipt_expire.h	1969-12-31 19:00:00.00000=
0000 -0500
+++ b/include/linux/netfilter_ipv4/ipt_expire.h	2005-06-09 10:53:49.00000=
0000 -0400
@@ -0,0 +1,10 @@
+#ifndef __IPT_EXPIRE_H
+#define __IPT_EXPIRE_H
+
+#include <linux/types.h>
+
+struct ipt_exp_info {
+	time_t expiration;
+};
+
+#endif
diff -Nru a/net/ipv4/netfilter/ipt_expire.c b/net/ipv4/netfilter/ipt_expi=
re.c
--- a/net/ipv4/netfilter/ipt_expire.c	1969-12-31 19:00:00.000000000 -0500
+++ b/net/ipv4/netfilter/ipt_expire.c	2005-06-10 09:23:06.000000000 -0400
@@ -0,0 +1,476 @@
+/* This module matches until it expires, at which point the entire
+ * rule is deleted
+ *
+ * This module is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This module is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this module; if not, write to:
+ *      The Free Software Foundation, Inc.
+ *      59 Temple Place, Suite 330
+ *      Boston, MA  02111-1307  USA
+ *
+ * Copyright =A9 2005 Bryan Cardillo <dillo@seas.upenn.edu>
+ */
+
+#include <linux/config.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/workqueue.h>
+#include <linux/vmalloc.h>
+#include <linux/time.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_expire.h>
+
+#if CONFIG_NETFILTER_DEBUG
+#define dprintk(format, args...) \
+	printk("ipt_expire[%s]: " format "\n", __FUNCTION__, ## args)
+#else
+#define dprintk(format, args...)
+#endif
+
+MODULE_AUTHOR("Bryan Cardillo <dillo@seas.upenn.edu>");
+MODULE_DESCRIPTION("an iptables expiring match module");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("1.0");
+static int __init ipt_exp_init(void);
+static void __exit ipt_exp_exit(void);
+module_init(ipt_exp_init);
+module_exit(ipt_exp_exit);
+
+static int ipt_exp_match(const struct sk_buff *,
+		const struct net_device *, const struct net_device *,
+		const void *, int, int *);
+static int ipt_exp_checkentry(const char *, const struct ipt_ip *,
+		void *, unsigned int, unsigned int);
+static int ipt_exp_add_table(const char *);
+static void ipt_exp_remove_table(const char *);
+static void ipt_exp_schedule_expiration(time_t);
+static void ipt_exp_work_fn(void *);
+static int ipt_exp_get_info(const char *, struct ipt_getinfo *);
+static int ipt_exp_get_entries(struct ipt_getinfo *, struct ipt_get_entr=
ies *);
+static int ipt_exp_get_active(struct ipt_getinfo *,
+		struct ipt_get_entries *, struct ipt_replace *);
+static int ipt_exp_copy_active(struct ipt_entry *, struct ipt_replace *)=
;
+static int ipt_exp_is_expired(struct ipt_entry_match *);
+static int ipt_exp_replace_expired(struct ipt_replace *);
+
+/**
+ * struct for list of tables
+ */
+struct ipt_exp_table {
+	/**
+	 * the table name
+	 */
+	char name[IPT_TABLE_MAXNAMELEN];
+	/**
+	 * a list_head structure enabling list inclusion
+	 */
+	struct list_head list;
+};
+
+/**
+ * work_struct for scheduling the deletion of expired rules
+ */
+static DECLARE_WORK(ipt_exp_work, &ipt_exp_work_fn, NULL);
+
+/**
+ * iptables match
+ */
+static struct ipt_match ipt_expire_match =3D {
+	.name		=3D "expire",
+	.match		=3D &ipt_exp_match,
+	.checkentry	=3D &ipt_exp_checkentry,
+	.me		=3D THIS_MODULE
+};
+
+/**
+ * the list of tables contained expiring entries
+ */
+static spinlock_t ipt_exp_tables_lock =3D SPIN_LOCK_UNLOCKED;
+static LIST_HEAD(ipt_exp_tables);
+
+/**
+ * initialize module and register iptables match
+ * @see module_init()
+ * @see ipt_register_match()
+ */
+static int __init
+ipt_exp_init(void)
+{
+	dprintk("initializing");
+	ipt_register_match(&ipt_expire_match);
+	return 0;
+}
+
+/**
+ * cleanup module and unregister iptables match
+ * @see module_exit()
+ * @see ipt_unregister_match()
+ */
+static void __exit
+ipt_exp_exit(void)
+{
+	unsigned long flags;
+	struct ipt_exp_table *t, *tmp;
+
+	dprintk("exiting");
+
+	ipt_unregister_match(&ipt_expire_match);
+	cancel_delayed_work(&ipt_exp_work);
+=09
+	spin_lock_irqsave(&ipt_exp_tables_lock, flags);
+	list_for_each_entry_safe(t, tmp, &ipt_exp_tables, list)
+		kfree(t);
+	spin_unlock_irqrestore(&ipt_exp_tables_lock, flags);
+}
+
+/**
+ * match if the expiration time has't passed
+ * @param skb socket buffer
+ * @param in inbound network device
+ * @param out outbound network device
+ * @param matchinfo match specific data
+ * @param offset match offset (?)
+ * @param hotdrop set to 1 to drop packet immediately when returning fal=
se
+ * @return non-zero for active rules, zero otherwise
+ * @see struct ipt_match
+ */
+static int
+ipt_exp_match(const struct sk_buff *skb,
+		const struct net_device *in, const struct net_device *out,
+		const void *matchinfo, int offset, int *hotdrop)
+{
+	const struct ipt_exp_info *info =3D matchinfo;
+
+	if (get_seconds() < info->expiration)
+		return 1;
+
+	return 0;
+}
+
+/**
+ * check a new iptables entry
+ * @param tablename table name for new entry
+ * @param ip ip info for new entry
+ * @param matchinfo match specific data
+ * @param matchsize size of matchinfo data
+ * @param hookmask valid netfilter hooks (?)
+ * @return non-zero for valid entries, zero otherwise
+ */
+static int
+ipt_exp_checkentry(const char *tablename, const struct ipt_ip *ip,
+		void *matchinfo, unsigned int matchsize, unsigned int hookmask)
+{
+	struct ipt_exp_info *info =3D matchinfo;
+
+	if (matchsize !=3D IPT_ALIGN(sizeof(struct ipt_exp_info)))
+		return 0;
+
+	if (info->expiration < get_seconds())
+		return 0;
+
+	if (ipt_exp_add_table(tablename))
+		return 0;
+
+	ipt_exp_schedule_expiration(info->expiration);
+
+	return 1;
+}
+
+/**
+ * add a table to the set of tables to be searched for expired rules
+ * @param tablename the name of the table
+ * @return zero on success, non-zero on failure
+ */
+static int
+ipt_exp_add_table(const char *tablename)
+{
+	unsigned long flags;
+	struct ipt_exp_table *t;
+
+	spin_lock_irqsave(&ipt_exp_tables_lock, flags);
+	list_for_each_entry(t, &ipt_exp_tables, list)
+		if (strncmp(t->name, tablename, IPT_TABLE_MAXNAMELEN) =3D=3D 0)
+			break;
+	spin_unlock_irqrestore(&ipt_exp_tables_lock, flags);
+
+	if (&t->list =3D=3D &ipt_exp_tables) {
+		if (!(t =3D kmalloc(sizeof(struct ipt_exp_table), GFP_KERNEL))) {
+			dprintk("error allocating memory");
+			return -ENOMEM;
+		}
+		strlcpy(t->name, tablename, IPT_TABLE_MAXNAMELEN);
+		spin_lock_irqsave(&ipt_exp_tables_lock, flags);
+		list_add_tail(&t->list, &ipt_exp_tables);
+		spin_unlock_irqrestore(&ipt_exp_tables_lock, flags);
+	}
+	return 0;
+}
+
+/**
+ * remove a table from the set of tables to be searched for expired rule=
s
+ * @param tablename the name of the table to be removed
+ */
+static void
+ipt_exp_remove_table(const char *tablename)
+{
+	unsigned long flags;
+	struct ipt_exp_table *t, *tmp;
+
+	spin_lock_irqsave(&ipt_exp_tables_lock, flags);
+	list_for_each_entry_safe(t, tmp, &ipt_exp_tables, list) {
+		if (strncmp(t->name, tablename, IPT_TABLE_MAXNAMELEN) =3D=3D 0) {
+			list_del(&t->list);
+			kfree(t);
+		}
+	}
+	spin_unlock_irqrestore(&ipt_exp_tables_lock, flags);
+}
+
+/**
+ * schedule the next removal of expired rules
+ * @param expiration the time to be scheduled
+ */
+static void
+ipt_exp_schedule_expiration(time_t expiration)
+{
+	unsigned long delay =3D (expiration - get_seconds() < 1) ? HZ :
+					(expiration - get_seconds()) * HZ;
+
+	schedule_delayed_work(&ipt_exp_work, delay);
+}
+
+/**
+ * delete expired iptables rules
+ * @param __notused
+ * @see schedule_delayed_work()
+ */
+static void
+ipt_exp_work_fn(void *__notused)
+{
+	struct ipt_exp_table *t;
+
+	list_for_each_entry(t, &ipt_exp_tables, list) {
+		size_t sz;
+		struct ipt_getinfo info;
+		struct ipt_get_entries *entries =3D NULL;
+		struct ipt_replace *replace =3D NULL;
+
+		/* get table info */
+		if (ipt_exp_get_info(t->name, &info))
+			continue;
+
+		dprintk("expiring %s entries", info.name);
+
+		/* allocate memory */
+		sz =3D sizeof(struct ipt_get_entries) + info.size;
+		if (!(entries =3D vmalloc(sz))) {
+			dprintk("error allocating entry table");
+			break;
+		}
+		sz =3D sizeof(struct ipt_replace) + info.size;
+		if (!(replace =3D vmalloc(sz))) {
+			dprintk("error allocating replacement table");
+			goto out_free_entries;
+		}
+		memset(replace, 0, sz);
+		sz =3D sizeof(struct ipt_counters) * info.num_entries;
+		if (!(replace->counters =3D vmalloc(sz))) {
+			dprintk("error allocating counters");
+			goto out_free_entries_replace;
+		}
+		memset(replace->counters, 0, sz);
+
+		/* get all entries, then copy active ones */
+		if (ipt_exp_get_entries(&info, entries))
+			goto out_free_entries_replace_counters;
+		if (ipt_exp_get_active(&info, entries, replace))
+			goto out_free_entries_replace_counters;
+
+		/* replace table */
+		if (replace->size < info.size)
+			ipt_exp_replace_expired(replace);
+
+out_free_entries_replace_counters:
+		vfree(replace->counters);
+out_free_entries_replace:
+		vfree(replace);
+out_free_entries:
+		vfree(entries);
+	}
+}
+
+/**
+ * get info on an a table
+ * @param name the name of the table
+ * @param info the location to store the retrieved info
+ * @return zero on success, non-zero otherwise
+ */
+static int
+ipt_exp_get_info(const char *name, struct ipt_getinfo *info)
+{
+	int ret =3D 0;
+	int sz =3D sizeof(struct ipt_getinfo);
+
+	dprintk("getting entry info");
+
+	strlcpy(info->name, name, IPT_TABLE_MAXNAMELEN);
+	ret =3D nf_getsockopt(NULL, PF_INET, IPT_SO_GET_INFO, (char *)info, &sz=
);
+	switch (ret) {
+		case 0:
+			break;
+		case -ENOENT:
+			/* table is gone */
+			ipt_exp_remove_table(name);
+			break;
+		default:
+			dprintk("error getting iptables info");
+			break;
+	}
+
+	return ret;
+}
+
+/**
+ * get the entries for a table
+ * @param info the location of info about the table
+ * @param entries the location to allocate and store the retrieved entri=
es
+ * @return zero on success, non-zero otherwise
+ */
+static int
+ipt_exp_get_entries(struct ipt_getinfo *info, struct ipt_get_entries *en=
tries)
+{
+	int ret =3D 0;
+	int sz =3D sizeof(struct ipt_get_entries) + info->size;
+
+	dprintk("getting existing entries");
+
+	strlcpy(entries->name, info->name, IPT_TABLE_MAXNAMELEN);
+	entries->size =3D info->size;
+	ret =3D nf_getsockopt(NULL, PF_INET,
+			IPT_SO_GET_ENTRIES, (char *)entries, &sz);
+	if (ret)
+		dprintk("error getting iptables entries");
+
+	return ret;
+}
+
+/**
+ * iterate over a tables entries, copying entries which
+ * are not expired to the replacement table
+ * @param info the location of info about the table
+ * @param entries the location of the table entries
+ * @param replace the location to allocate and store the replacement ent=
ries
+ * @return zero on success, non-zero otherwise
+ */
+static int
+ipt_exp_get_active(struct ipt_getinfo *info,
+		struct ipt_get_entries *entries, struct ipt_replace *replace)
+{
+	dprintk("copying active entries");
+
+	/* copy stuff */
+	strlcpy(replace->name, info->name, IPT_TABLE_MAXNAMELEN);
+	memcpy(replace->hook_entry, info->hook_entry, sizeof(info->hook_entry))=
;
+	memcpy(replace->underflow, info->underflow, sizeof(info->underflow));
+	replace->valid_hooks =3D info->valid_hooks;
+	replace->num_counters =3D info->num_entries;
+
+	/* set size and entry count */
+	replace->size =3D 0;
+	replace->num_entries =3D 0;
+
+	return IPT_ENTRY_ITERATE(entries->entrytable, entries->size,=20
+					ipt_exp_copy_active, replace);
+}
+
+/**
+ * copy a table entry if it is not expired
+ * @param entry the source entry
+ * @param replace the replacement table
+ * @return zero;
+ */
+static int
+ipt_exp_copy_active(struct ipt_entry *entry, struct ipt_replace *replace=
)
+{
+	struct ipt_entry *dest =3D (void *)replace->entries + replace->size;
+
+	if (IPT_MATCH_ITERATE(entry, ipt_exp_is_expired))
+		return 0;
+
+	memcpy(dest, entry, entry->next_offset);
+	replace->size +=3D entry->next_offset;
+	replace->num_entries++;
+
+	return 0;
+}
+
+/**
+ * determine if an entry is expired
+ * @param match the entry match to check for expiration
+ * @return non-zero for expired entries, zero otherwise
+ */
+static int
+ipt_exp_is_expired(struct ipt_entry_match *match)
+{
+	if (strcmp(match->u.user.name, "expire") =3D=3D 0) {
+		struct ipt_exp_info *info =3D (struct ipt_exp_info *)match->data;
+		if (info->expiration < get_seconds())
+			return 1;
+	}
+	return 0;
+}
+
+/**
+ * update a table
+ * @param replace the replacement table
+ * @return zero on success, non-zero otherwise
+ */
+static int
+ipt_exp_replace_expired(struct ipt_replace *replace)
+{
+	int ret =3D 0;
+	int sz =3D sizeof(struct ipt_replace) + replace->size;
+
+	dprintk("replacing table %s", replace->name);
+
+	ret =3D nf_setsockopt(NULL, PF_INET,
+			IPT_SO_SET_REPLACE, (char *)replace, sz);
+	/*
+	 * FIXME remove this verbosity once tested?
+	 */
+	switch (ret) {
+		case 0:
+			break;
+		case -EFAULT:
+			dprintk("EFAULT replacing iptables");
+			break;
+		case -ENOPROTOOPT:
+			dprintk("ENOPROTOOPT replacing iptables");
+			break;
+		case -ENOMEM:
+			dprintk("ENOMEM replacing iptables");
+			break;
+		case -ENOENT:
+			dprintk("ENOENT replacing iptables");
+			break;
+		case -ELOOP:
+			dprintk("ELOOP replacing iptables");
+			break;
+		case -EINVAL:
+			dprintk("EINVAL replacing iptables");
+			break;
+		default:
+			dprintk("unknown error (%d) replacing iptables", ret);
+			break;
+	}
+	return ret;
+}
diff -Nru a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
--- a/net/ipv4/netfilter/Kconfig	2004-10-18 17:54:55.000000000 -0400
+++ b/net/ipv4/netfilter/Kconfig	2005-06-10 10:21:21.258583334 -0400
@@ -342,6 +342,17 @@
 	  If you want to compile it as a module, say M here and read
 	  Documentation/modules.txt.  If unsure, say `N'.
=20
+config IP_NF_MATCH_EXPIRE
+	tristate  'expiring match support'
+	depends on IP_NF_IPTABLES
+	help
+	  This option adds an expiring match, which allows you to add
+	  rules to your iptables ruleset which will later be removed
+          automatically.
+
+	  If you want to compile it as a module, say M here and read
+	  Documentation/modules.txt.  If unsure, say `N'.
+
 # `filter', generic and specific targets
 config IP_NF_FILTER
 	tristate "Packet filtering"
diff -Nru a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
--- a/net/ipv4/netfilter/Makefile	2004-10-18 17:53:43.000000000 -0400
+++ b/net/ipv4/netfilter/Makefile	2005-06-10 10:21:49.589495042 -0400
@@ -67,6 +67,7 @@
 obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) +=3D ipt_addrtype.o
 obj-$(CONFIG_IP_NF_MATCH_PHYSDEV) +=3D ipt_physdev.o
 obj-$(CONFIG_IP_NF_MATCH_COMMENT) +=3D ipt_comment.o
+obj-$(CONFIG_IP_NF_MATCH_EXPIRE) +=3D ipt_expire.o
=20
 # targets
 obj-$(CONFIG_IP_NF_TARGET_REJECT) +=3D ipt_REJECT.o

--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=iso-8859-1
Content-Description: ipt_expire-iptables.patch
Content-Disposition: attachment; filename="ipt_expire-iptables.patch"
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by rover.pcbi.upenn.edu id
	j5AEqmp5011145

diff -Nru a/extensions/libipt_expire.c b/extensions/libipt_expire.c
--- a/extensions/libipt_expire.c	1969-12-31 19:00:00.000000000 -0500
+++ b/extensions/libipt_expire.c	2005-06-09 14:47:32.000000000 -0400
@@ -0,0 +1,170 @@
+/* This library manipulates expiring firewall rules
+ *
+ * This library is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this library; if not, write to:
+ *      The Free Software Foundation, Inc.
+ *      59 Temple Place, Suite 330
+ *      Boston, MA  02111-1307  USA
+ *
+ * Copyright =A9 2005 Bryan Cardillo <dillo@seas.upenn.edu>
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <time.h>
+
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ipt_expire.h>
+
+static void ipt_exp_help(void);
+static int ipt_exp_parse(int, char **, int, unsigned int *,
+		const struct ipt_entry *, unsigned int *,
+		struct ipt_entry_match **);
+static void ipt_exp_final_check(unsigned int);
+static void ipt_exp_print(const struct ipt_ip *,
+		const struct ipt_entry_match *, int);
+static void ipt_exp_save(const struct ipt_ip *, const struct ipt_entry_m=
atch *);
+
+/**
+ * options
+ */
+static struct option ipt_exp_opts[] =3D {
+	{ "expiration", 1, 0, 'e' },
+	{ 0 }
+};
+
+/**
+ * match
+ */
+static struct iptables_match ipt_expire_match =3D {
+	.next =3D NULL,
+	.name =3D "expire",
+	.version =3D IPTABLES_VERSION,
+	.size =3D IPT_ALIGN(sizeof(struct ipt_exp_info)),
+	.userspacesize =3D IPT_ALIGN(sizeof(struct ipt_exp_info)),
+	.help =3D &ipt_exp_help,
+	.parse =3D &ipt_exp_parse,
+	.final_check =3D &ipt_exp_final_check,
+	.print =3D &ipt_exp_print,
+	.save =3D &ipt_exp_save,
+	.extra_opts =3D ipt_exp_opts
+};
+
+/**
+ * shared library initialization
+ * @see register_match()
+ */
+void
+_init(void)
+{
+	register_match(&ipt_expire_match);
+}
+
+/**
+ * print usage information
+ */
+static void
+ipt_exp_help(void)
+{
+    printf("EXPIRE match options\n"
+           "  --expiration [+]TIME\t\t"
+	   "rule expires at [in] TIME\n\n");
+}
+
+/**
+ * parse module specific options
+ * @param c the short option character
+ * @param argv the arguments array
+ * @param invert is this an inverted argument
+ * @param flags module specific flags
+ * @param entry the entry
+ * @param nfcache netfilter cache flags
+ * @param match the match
+ * @return zero if an option was found, non-zero otherwise
+ */
+static int
+ipt_exp_parse(int c, char **argv, int invert, unsigned int *flags,
+	const struct ipt_entry *entry, unsigned int *nfcache,
+	struct ipt_entry_match **match)
+{
+	char *arg;
+	struct ipt_exp_info *info;
+=09
+	info =3D (struct ipt_exp_info *)(*match)->data;
+	info->expiration =3D 0;
+	switch (c) {
+		case 'e':
+			arg =3D argv[optind-1];
+			check_inverse(arg, &invert, &optind, 0);
+			if (invert)
+				exit_error(PARAMETER_PROBLEM,
+					"--expiration cannot be inverted");
+                        if (*arg =3D=3D '+')
+				arg++;
+			if (string_to_number_l(
+					arg, 1, 0, &info->expiration) < 0)
+				exit_error(PARAMETER_PROBLEM,
+					"invalid expiration time");
+			*flags =3D 1;
+			if (*argv[optind-1] =3D=3D '+')
+				info->expiration +=3D time(NULL);
+			break;
+		default:
+			return 0;
+	}
+	return 1;
+}
+
+/**
+ * ensures an expiration was specified
+ * @param flags module specific flags from options parsing
+ */
+static void
+ipt_exp_final_check(unsigned int flags)
+{
+	if (flags !=3D 1)
+		exit_error(PARAMETER_PROBLEM,
+			"you must specify an expiration time (--expiration)");
+}
+
+/**
+ * print information about an expiring match
+ * in a format suitable for viewing
+ * @param ip the address information
+ * @param match the match
+ * @param numeric the verbose level (?)
+ */
+static void
+ipt_exp_print(const struct ipt_ip *ip,
+	const struct ipt_entry_match *match, int numeric)
+{
+	struct ipt_exp_info *info;
+	info =3D (struct ipt_exp_info *)match->data;
+	printf("expires in %lds ", info->expiration - time(NULL));
+}
+
+/**
+ * print information about an expiring match
+ * in a format suitable for reconstructing the match
+ * @param ip the address information
+ * @param match the match
+ */
+static void
+ipt_exp_save(const struct ipt_ip *ip, const struct ipt_entry_match *matc=
h)
+{
+	struct ipt_exp_info *info;
+	info =3D (struct ipt_exp_info *)match->data;
+	printf("-m expire --expiration %ld ", info->expiration);
+}
diff -Nru a/extensions/Makefile b/extensions/Makefile
--- a/extensions/Makefile	2004-11-18 17:52:12.000000000 -0500
+++ b/extensions/Makefile	2005-06-10 10:33:08.891541054 -0400
@@ -5,7 +5,7 @@
 # header files are present in the include/linux directory of this iptabl=
es
 # package (HW)
 #
-PF_EXT_SLIB:=3Dah addrtype comment connlimit connmark conntrack dscp ecn=
 esp hashlimit helper icmp iprange length limit mac mark multiport owner =
physdev pkttype realm rpc sctp standard state tcp tcpmss tos ttl udp uncl=
ean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NOT=
RACK REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TRACE TTL ULOG
+PF_EXT_SLIB:=3Dah addrtype comment expire connlimit connmark conntrack d=
scp ecn esp hashlimit helper icmp iprange length limit mac mark multiport=
 owner physdev pkttype realm rpc sctp standard state tcp tcpmss tos ttl u=
dp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NET=
MAP NOTRACK REDIRECT REJECT SAME SNAT TARPIT TCPMSS TOS TRACE TTL ULOG
 PF6_EXT_SLIB:=3Deui64 hl icmpv6 length limit mac mark multiport owner ph=
ysdev standard tcp udp HL LOG MARK TRACE
=20
 # Optionals

--FL5UXtIhxfXey3p5--
