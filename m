From: Piotr Gasidlo <quaker@pandora.barbara.ds.polsl.gliwice.pl>
Subject: ipt_account match update
Date: Sat, 1 Apr 2006 18:53:47 +0200
Message-ID: <20060401165347.GA4848@barbara.eu.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=_pandora.barbara.ds.polsl.gliwice.pl-16601-1143910429-0001-2"
Cc: kaber@trash.net
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

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_pandora.barbara.ds.polsl.gliwice.pl-16601-1143910429-0001-2
Content-Type: multipart/mixed; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I've rewritten my ipt_account match. Main changes:
- big code cleanup,
- removed code that parsed input from user while writing to proc entry -
  I've used sscanf (in kernel) instead,
- match()ing is faster (speeded up code finding the right table to
  update)
- code is fully compatible with latest 2.6.16/2.4.32 kernels.

Including diff against patch-o-matic-ng SVN. No iptables (userspace)
patches are needed.

There is one problem. While rewriting I broke binary compatiblity (I've
added new variable to t_ipt_account_info structure, which is used by
iptables userspace program).

And I've question. Do I have to write this "update" like ipt_MARK was
rewriten in kernel? Or should I leave it like it is (ipt_account
is not in stock kernel, it will never be, and after applying patches
=66rom patch-o-matic-ng user *have* to recompile iptables, so problem
I think disapears).

--=20
Piotr 'QuakeR' Gasid=C5=82o, BOFH @ pandora.barbara.eu.org
############## sending lusers to /dev/null since 1998
##### Waiting for tomorrow, for a little ray of light
### Waiting for tomorrow just to see your smile again

--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="ipt_account_0.1.20.diff"
Content-Transfer-Encoding: quoted-printable

Index: patchlets/account/linux/include/linux/netfilter_ipv4/ipt_account.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- patch-o-matic-ng.orig/patchlets/account/linux/include/linux/netfilter_i=
pv4/ipt_account.h	(wersja 6575)
+++ patch-o-matic-ng/patchlets/account/linux/include/linux/netfilter_ipv4/i=
pt_account.h	(kopia robocza)
@@ -1,10 +1,8 @@
-/*=20
- * accounting match (ipt_account.c)
- * (C) 2003,2004 by Piotr Gasidlo (quaker@barbara.eu.org)
+/* Copyright (c) 2004-2006 Piotr 'QuakeR' Gasid=C5=82o <quaker@barbara.eu.=
org>
  *
- * Version: 0.1.7
- *
- * This software is distributed under the terms of GNU GPL
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
  */
=20
 #ifndef _IPT_ACCOUNT_H_
@@ -12,15 +10,15 @@
=20
 #define IPT_ACCOUNT_NAME_LEN 64
=20
-#define IPT_ACCOUNT_NAME "ipt_account"
-#define IPT_ACCOUNT_VERSION  "0.1.7"
+struct t_ipt_account_table;
=20
 struct t_ipt_account_info {
-	char name[IPT_ACCOUNT_NAME_LEN];
-	u_int32_t network;
-	u_int32_t netmask;
+	char name[IPT_ACCOUNT_NAME_LEN + 1];
+	u_int32_t network, netmask;
 	int shortlisting:1;
+	/* pointer to the table for fast matching */
+	struct t_ipt_account_table *table;
 };
=20
-#endif
+#endif /* _IPT_ACCOUNT_H */
=20
Index: patchlets/account/linux/net/ipv4/netfilter/ipt_account.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- patch-o-matic-ng.orig/patchlets/account/linux/net/ipv4/netfilter/ipt_ac=
count.c	(wersja 6575)
+++ patch-o-matic-ng/patchlets/account/linux/net/ipv4/netfilter/ipt_account=
=2Ec	(kopia robocza)
@@ -1,533 +1,285 @@
-/*=20
- * accounting match (ipt_account.c)
- * (C) 2003,2004 by Piotr Gasidlo (quaker@barbara.eu.org)
+/* Copyright (c) 2004-2006 Piotr 'QuakeR' Gasid=C5=82o <quaker@barbara.eu.=
org>
  *
- * Version: 0.1.7
- *
- * This software is distributed under the terms of GNU GPL
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
  */
=20
 #include <linux/module.h>
 #include <linux/skbuff.h>
+#include <linux/vmalloc.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <linux/time.h>
+#include <asm/uaccess.h>
 #include <linux/spinlock.h>
-#include <linux/vmalloc.h>
 #include <linux/interrupt.h>
-#include <linux/ctype.h>
=20
-#include <linux/seq_file.h>
+#define IPT_ACCOUNT_VERSION "0.1.20"
=20
-#include <asm/uaccess.h>
+// #define DEBUG_IPT_ACCOUNT
=20
-#include <linux/ip.h>
-#include <linux/tcp.h>
-#include <linux/udp.h>
-
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ipt_account.h>
-
-#if defined(CONFIG_IP_NF_MATCH_ACCOUNT_DEBUG)
-	#define dprintk(format,args...) printk(format,##args)
+#ifdef DEBUG_IPT_ACCOUNT
+	#define dprintk(format, args...) printk(format, ##args)
 #else
-        #define dprintk(format,args...)
+	#define dprintk(format, args...)
 #endif
=20
-static char version[] =3D
-KERN_INFO IPT_ACCOUNT_NAME " " IPT_ACCOUNT_VERSION " : Piotr Gasid=C5=82o =
<quaker@barbara.eu.org>, http://www.barbara.eu.org/~quaker/ipt_account/\n";
-
-/* rights for files created in /proc/net/ipt_account/ */
-static int permissions =3D 0644;
-/* maximal netmask for single table */
-static int netmask =3D 16;
-
-/* module information */
 MODULE_AUTHOR("Piotr Gasidlo <quaker@barbara.eu.org>");
-MODULE_DESCRIPTION("Traffic accounting modules");
+MODULE_DESCRIPTION("Traffic accounting module");
 MODULE_LICENSE("GPL");
-MODULE_PARM(permissions,"i");
-MODULE_PARM_DESC(permissions,"permissions on /proc/net/ipt_account/* files=
");
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_account.h>
+
+/* defaults, can be overriden */
+static unsigned int netmask =3D 16; /* Safe netmask, if you try to create =
table
+																		 for larger netblock you will get error.=20
+																		 Increase by command line only when you
+																		 known what are you doing. */
+
 MODULE_PARM(netmask, "i");
-MODULE_PARM_DESC(netmask, "maximum *save* size of one list (netmask)");
+MODULE_PARM_DESC(netmask,"maximum *save* netmask");
=20
-/* structure with statistics counters */
-struct t_ipt_account_stat {
-	u_int64_t b_all, b_tcp, b_udp, b_icmp, b_other;		/* byte counters for all=
/tcp/udp/icmp/other traffic  */
-	u_int64_t p_all, p_tcp, p_udp, p_icmp, p_other;		/* packet counters for a=
ll/tcp/udp/icmp/other traffic */
+/* structure with statistics counter, used when table is created without -=
-ashort switch */
+struct t_ipt_account_stat_long {
+	u_int64_t b_all, b_tcp, b_udp, b_icmp, b_other;
+	u_int64_t p_all, p_tcp, p_udp, p_icmp, p_other;
 };
=20
-/* stucture with statistics counters, used when table is created with --as=
hort switch */
+/* same as above, for tables created with --ashort switch */
 struct t_ipt_account_stat_short {
-	u_int64_t b_all;					/* byte counters for all traffic */
-	u_int64_t p_all;					/* packet counters for all traffic */
+	u_int64_t b_all;
+	u_int64_t p_all;
 };
-=20
-/* structure holding to/from statistics for single ip */
-struct t_ipt_account_ip_list {
-	struct t_ipt_account_stat src;
-	struct t_ipt_account_stat dest;
-	unsigned long time;					/* time when this record was last updated */=09
-=09
+
+/* structure holding to/from statistics for single ip when table is create=
d without --ashort switch */
+struct t_ipt_account_stats_long {
+	struct t_ipt_account_stat_long src, dst;
+	struct timespec time; /* time, when statistics was last modified */
 };
=20
-/* same as above, for tables with --ashort switch */
-struct t_ipt_account_ip_list_short {
-	struct t_ipt_account_stat_short src;
-	struct t_ipt_account_stat_short dest;
-	unsigned long time;
+/* same as above, for tables created with --ashort switch */
+struct t_ipt_account_stats_short {
+	struct t_ipt_account_stat_short src, dst;
+	struct timespec time;
 };
=20
 /* structure describing single table */
 struct t_ipt_account_table {
-	char name[IPT_ACCOUNT_NAME_LEN];	/* table name ( =3D filename in /proc/ne=
t/ipt_account/) */
-	union {					/* table with statistics for each ip in network/netmask */
-		struct t_ipt_account_ip_list *l;
-		struct t_ipt_account_ip_list_short *s;
-	} ip_list;
-	u_int32_t network;			/* network/netmask covered by table*/
-	u_int32_t netmask;				=09
-	u_int32_t count;
-	int shortlisting:1;			/* show only total columns of counters */=09
-	int use_count;				/* rules counter - counting number of rules using this =
table */
-	struct t_ipt_account_table *next;
-	spinlock_t ip_list_lock;
-	struct proc_dir_entry *status_file;
-};
+	struct list_head list;
+	atomic_t use; /* use counter, the number of rules which points to this ta=
ble */
=20
-/* we must use spinlocks to avoid parallel modifications of table list */
-static spinlock_t account_lock =3D SPIN_LOCK_UNLOCKED;
+	char name[IPT_ACCOUNT_NAME_LEN + 1]; /* table name ( =3D filename in /pro=
c/net/ipt_account/) */
+	u_int32_t network, netmask, count; /* network/netmask/hosts count coverte=
d by table */
=20
-static struct proc_dir_entry *proc_net_ipt_account =3D NULL;
+	int shortlisting:1; /* gather only total statistics (set for tables creat=
ed with --ashort switch) */
+=09
+	union { /* statistics for each ip in network/netmask */
+		struct t_ipt_account_stats_long *l;
+		struct t_ipt_account_stats_short *s;
+	} stats;
+	rwlock_t stats_lock; /* lock, to assure that above union can be safely mo=
dified */
=20
-/* root pointer holding list of the tables */
-static struct t_ipt_account_table *account_tables =3D NULL;
+	struct proc_dir_entry *pde; /* handle to proc entry */
+};
=20
-/* convert ascii to ip */
-int atoip(char *buffer, u_int32_t *ip) {
+static LIST_HEAD(ipt_account_tables);
+static rwlock_t ipt_account_lock =3D RW_LOCK_UNLOCKED; /* lock, to assure =
that table list can be safely modified */
=20
-	char *bufferptr =3D buffer;
-	int part, shift;
+static struct file_operations ipt_account_proc_fops;
+static struct proc_dir_entry *ipt_account_procdir;
+
+/*
+ * Function creates new table and inserts it into linked list.
+ */
+static struct t_ipt_account_table *
+ipt_account_table_init(struct t_ipt_account_info *info)
+{=09
+	struct t_ipt_account_table *table;
 =09
-	/* zero ip */
-	*ip =3D 0;
+	dprintk(KERN_DEBUG "ipt_account [ipt_account_table_init]: name =3D %s\n",=
 info->name);
=20
-	/* first must be a digit */
-	if (!isdigit(*bufferptr))
-		return 0;
+	/*
+	 * Allocate memory for table.
+	 */
+	table =3D vmalloc(sizeof(struct t_ipt_account_table));
+	if (!table) {
+		printk(KERN_ERR "ipt_account [ipt_account_table_init]: table =3D vmalloc=
(sizeof(struct t_ipt_account_table)) failed.\n");
+		goto cleanup_none;
+	}
+	memset(table, 0, sizeof(struct t_ipt_account_table));
=20
-	/* parse first 3 octets (III.III.III.iii) */
-	for (part =3D 0, shift =3D 24; *bufferptr && shift; bufferptr++) {
-		if (isdigit(*bufferptr)) {
-			part =3D part * 10 + (*bufferptr - '0');
-			continue;
+	/*
+	 * Table attributes.
+	 */
+	strncpy(table->name, info->name, IPT_ACCOUNT_NAME_LEN);=09
+	table->name[IPT_ACCOUNT_NAME_LEN - 1] =3D '\0';
+
+	table->network =3D info->network;
+	table->netmask =3D info->netmask;
+	table->count =3D (0xffffffff ^ table->netmask) + 1;
+=09
+	/*
+	 * Table properties.
+	 */
+	table->shortlisting =3D info->shortlisting;
+=09
+	/*
+	 * Initialize use counter.
+	 */
+	atomic_set(&table->use, 1);
+
+	/*
+	 * Allocate memory for statistic counters.
+	 */
+	if (table->shortlisting) {
+		table->stats.s =3D vmalloc(sizeof(struct t_ipt_account_stats_short) * ta=
ble->count);
+		if (!table->stats.s) {
+			printk(KERN_ERR "ipt_account [ipt_account_table_init]: table->stats.s =
=3D vmalloc(sizeof(struct t_ipt_account_stats_short) * table->count) failed=
=2E\n");
+			goto cleanup_table;
 		}
-		if (*bufferptr =3D=3D '.') {
-			if (part > 255)
-				return 0;
-			*ip |=3D part << shift;
-			shift -=3D 8;
-			part =3D 0;
-			continue;
+		memset(table->stats.s, 0, sizeof(struct t_ipt_account_stats_short) * tab=
le->count);
+	} else {
+		table->stats.l =3D vmalloc(sizeof(struct t_ipt_account_stats_long) * tab=
le->count);
+		if (!table->stats.l) {
+			printk(KERN_ERR "ipt_account [ipt_account_table_init]: table->stats.l =
=3D vmalloc(sizeof(struct t_ipt_account_stats_long) * table->count) failed.=
\n");
+			goto cleanup_table;
 		}
-		return 0;
+		memset(table->stats.l, 0, sizeof(struct t_ipt_account_stats_long) * tabl=
e->count);
 	}
 =09
-	/* we expect more digts */
-	if (!*bufferptr)
-		return 0;
-	/* parse last octet (iii.iii.iii.III) */
-	for (; *bufferptr; bufferptr++) {
-		if (isdigit(*bufferptr)) {
-			part =3D part * 10 + (*bufferptr - '0');		=09
-			continue;
-		} else {
-			if (part > 255)
-				return 0;
-			*ip |=3D part;
-			break;
-		}
+	/*
+	 * Reset locks.
+	 */
+	table->stats_lock =3D RW_LOCK_UNLOCKED;
+=09
+	/*
+	 * Create /proc/ipt_account/name entry.
+	 */
+	table->pde =3D create_proc_entry(table->name, S_IWUSR | S_IRUSR, ipt_acco=
unt_procdir);
+	if (!table->pde) {
+		goto cleanup_stats;
 	}
-	return (bufferptr - buffer);
-}
+	table->pde->proc_fops =3D &ipt_account_proc_fops;
+	table->pde->data =3D table;
+=09
+	/*
+	 * Insert table into list.
+	 */
+	write_lock_bh(&ipt_account_lock);
+	list_add(&table->list, &ipt_account_tables);
+	write_unlock_bh(&ipt_account_lock);
+=09
+	return table;
=20
-/* convert ascii to 64bit integer */
-int atoi64(char *buffer, u_int64_t *i) {=09
-	char *bufferptr =3D buffer;
-
-	/* zero integer */
-	*i =3D 0;
+	/*
+	 * If something goes wrong we end here.
+	 */
+cleanup_stats:
+	if (table->shortlisting)
+		vfree(table->stats.s);
+	else
+		vfree(table->stats.l);
 =09
-	while (isdigit(*bufferptr)) {
-		*i =3D *i * 10 + (*bufferptr - '0');
-		bufferptr++;
-	}
-	return (bufferptr - buffer);
+cleanup_table:
+	vfree(table);
+cleanup_none:
+	return NULL;
+=09
 }
=20
-static void *account_seq_start(struct seq_file *s, loff_t *pos)
+/*
+ * Function destroys table. Table *must* be already unlinked.
+ */
+static void
+ipt_account_table_destroy(struct t_ipt_account_table *table)
 {
-	struct proc_dir_entry *pde =3D s->private;
-	struct t_ipt_account_table *table =3D pde->data;
-
-	unsigned int *bucket;
+	dprintk(KERN_DEBUG "ipt_account [ipt_account_table_destory]: name =3D %s\=
n", table->name);
 =09
-	spin_lock_bh(&table->ip_list_lock);
-	if (*pos >=3D table->count)
-		return NULL;
-
-	bucket =3D kmalloc(sizeof(unsigned int), GFP_KERNEL);
-	if (!bucket)
-		return ERR_PTR(-ENOMEM);
-	*bucket =3D *pos;
-	return bucket;
+	remove_proc_entry(table->pde->name, table->pde->parent);
+	if (table->shortlisting)
+		vfree(table->stats.s);
+	else
+		vfree(table->stats.l);
+	vfree(table);
 }
=20
-static void *account_seq_next(struct seq_file *s, void *v, loff_t *pos)
+/*
+ * Function increments use counter for table.
+ */
+static inline void
+ipt_account_table_get(struct t_ipt_account_table *table)=20
 {
-	struct proc_dir_entry *pde =3D s->private;
-	struct t_ipt_account_table *table =3D pde->data;
+	dprintk(KERN_DEBUG "ipt_account [ipt_account_table_get]: name =3D %s\n", =
table->name);
 =09
-	unsigned int *bucket =3D (unsigned int *)v;
-=09
-	*pos =3D ++(*bucket);
-	if (*pos >=3D table->count) {
-		kfree(v);
-		return NULL;
-	}
-	return bucket;
+	atomic_inc(&table->use);
 }
=20
-static void account_seq_stop(struct seq_file *s, void *v)
+/*
+ * Function decrements use counter for table. If use counter drops to zero,
+ * table is removed from linked list and destroyed.
+ */
+static inline void
+ipt_account_table_put(struct t_ipt_account_table *table)=20
 {
-	struct proc_dir_entry *pde =3D s->private;
-	struct t_ipt_account_table *table =3D pde->data;
-	unsigned int *bucket =3D (unsigned int *)v;
-	kfree(bucket);
-	spin_unlock_bh(&table->ip_list_lock);
+	dprintk(KERN_DEBUG "ipt_account [ipt_account_table_put]: name =3D %s\n", =
table->name);
+=09
+	if (atomic_dec_and_test(&table->use)) {
+		write_lock_bh(&ipt_account_lock);
+		list_del(&table->list);
+		write_unlock_bh(&ipt_account_lock);
+		ipt_account_table_destroy(table);
+	}
 }
=20
-static int account_seq_write(struct file *file, const char *ubuffer,=20
-		size_t ulength, loff_t *pos)
+/*
+ * Helper function, which returns a structure pointer to a table with
+ * specified name.
+ */
+static struct t_ipt_account_table *
+__ipt_account_table_find(char *name)=20
 {
-	struct proc_dir_entry *pde =3D ((struct seq_file *)file->private_data)->p=
rivate;
-	struct t_ipt_account_table *table =3D pde->data;
-	char buffer[1024], *bufferptr;
-	int length;
-
-	u_int32_t ip;
-	int len, i;
-	struct t_ipt_account_ip_list l;
-	struct t_ipt_account_ip_list_short s;
-	u_int64_t *p, dummy;
-=09
-=09
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() entered.\n");
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() ulength =3D %zi=
=2E\n", ulength);
-=09
-	length =3D ulength;
-	if (ulength > 1024)
-		length =3D 1024;
-	if (copy_from_user(buffer, ubuffer, length))
-		return -EFAULT;
-	buffer[length - 1] =3D 0;
-	bufferptr =3D buffer;
-
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() buffer =3D \'%s=
\' length =3D %i.\n", buffer, length);
-=09
-	/* reset table counters */
-	if (!memcmp(buffer, "reset", 5)) {
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got \"reset\".=
\n");
-		if (!table->shortlisting) {
-			spin_lock_bh(&table->ip_list_lock);
-			memset(table->ip_list.l, 0, sizeof(struct t_ipt_account_ip_list) * tabl=
e->count);
-			spin_unlock_bh(&table->ip_list_lock);
-		} else {
-			spin_lock_bh(&table->ip_list_lock);
-			memset(table->ip_list.s, 0, sizeof(struct t_ipt_account_ip_list_short) =
* table->count);
-			spin_unlock_bh(&table->ip_list_lock);
-		}
-		return length;
+	struct list_head *pos;
+	list_for_each(pos, &ipt_account_tables) {
+		struct t_ipt_account_table *table =3D list_entry(pos,
+				struct t_ipt_account_table, list);
+		if (!strncmp(table->name, name, IPT_ACCOUNT_NAME_LEN))
+			return table;
 	}
-
-	if (!memcmp(buffer, "ip", 2)) {
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got \"ip\".\n"=
);
-		bufferptr +=3D 2;
-		if (!isspace(*bufferptr)) {
-			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected spac=
e (%ti).\n", bufferptr - buffer);
-			return length; /* expected space */
-		}
-		bufferptr +=3D 1;
-		if (*bufferptr !=3D '=3D') {
-			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected equa=
l (%ti).\n", bufferptr - buffer);
-			return length; /* expected equal */
-		}
-		bufferptr +=3D 1;
-		if (!isspace(*bufferptr)) {
-			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected spac=
e (%ti).\n", bufferptr - buffer);
-			return length; /* expected space */
-		}
-		bufferptr +=3D 1;
-		if (!(len =3D atoip(bufferptr, &ip))) {
-			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected ip (=
%ti).\n", bufferptr - buffer);
-			return length; /* expected ip */
-		}
-		bufferptr +=3D len;
-		if ((ip & table->netmask) !=3D table->network) {
-			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected ip [=
%u.%u.%u.%u] from table's network/netmask [%u.%u.%u.%u/%u.%u.%u.%u].\n", HI=
PQUAD(ip), HIPQUAD(table->network), HIPQUAD(table->netmask));
-			return length; /* expected ip from table's network/netmask */
-		}
-		if (!table->shortlisting) {
-			memset(&l, 0, sizeof(struct t_ipt_account_ip_list));
-			while(*bufferptr) {
-				if (!isspace(*bufferptr)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected sp=
ace (%ti).\n", bufferptr - buffer);
-					return length; /* expected space */
-				}
-				bufferptr +=3D 1;
-				if (!memcmp(bufferptr, "bytes_src", 9)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got bytes_s=
rc (%ti).\n", bufferptr - buffer);
-					p =3D &l.src.b_all;
-					bufferptr +=3D 9;
-				} else if (!memcmp(bufferptr, "bytes_dest", 10)) {				=09
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got bytes_d=
est (%ti).\n", bufferptr - buffer);
-					p =3D &l.dest.b_all;
-					bufferptr +=3D 10;
-				} else if (!memcmp(bufferptr, "packets_src", 11)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got packets=
_src (%ti).\n", bufferptr - buffer);
-					p =3D &l.src.p_all;
-					bufferptr +=3D 11;
-				} else if (!memcmp(bufferptr, "packets_dest", 12)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got packets=
_dest (%ti).\n", bufferptr - buffer);
-					p =3D &l.dest.p_all;
-					bufferptr +=3D 12;
-				} else if (!memcmp(bufferptr, "time", 4)) {
-					/* time hack, ignore time tokens */
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got time (%=
ti).\n", bufferptr - buffer);
-					bufferptr +=3D 4;
-					if (!isspace(*bufferptr)) {
-						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected s=
pace (%ti).\n", bufferptr - buffer);
-						return length; /* expected space */
-					}
-					bufferptr +=3D 1;
-					if (*bufferptr !=3D '=3D') {
-						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected e=
qual (%ti).\n", bufferptr - buffer);
-						return length; /* expected equal */
-					}
-					bufferptr +=3D 1;
-					if (!isspace(*bufferptr)) {
-						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected s=
pace (%ti).\n", bufferptr - buffer);
-						return length; /* expected space */
-					}
-					bufferptr +=3D 1;
-					if (!(len =3D atoi64(bufferptr, &dummy))) {
-						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected i=
nt64 (%ti).\n", bufferptr - buffer);
-						return length; /* expected int64 */
-					}
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got %llu (%=
ti).\n", dummy, bufferptr - buffer);
-					bufferptr +=3D len;
-					continue; /* skip time token */
-				} else
-					return length;	/* expected token */
-				if (!isspace(*bufferptr)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected sp=
ace (%ti).\n", bufferptr - buffer);
-					return length; /* expected space */
-				}
-				bufferptr +=3D 1;
-				if (*bufferptr !=3D '=3D') {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected eq=
ual (%ti).\n", bufferptr - buffer);
-					return length; /* expected equal */
-				}
-				bufferptr +=3D 1;
-				for (i =3D 0; i < 5; i++) {
-					if (!isspace(*bufferptr)) {
-						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected s=
pace (%ti).\n", bufferptr - buffer);
-						return length; /* expected space */
-					}
-					bufferptr +=3D 1;
-					if (!(len =3D atoi64(bufferptr, p))) {
-						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected i=
nt64 (%ti).\n", bufferptr - buffer);
-						return length; /* expected int64 */
-					}
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got %llu (%=
ti).\n", *p, bufferptr - buffer);
-					bufferptr +=3D len;
-					p++;
-				}
-			}
-			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() updating row.=
\n");
-			spin_lock_bh(&table->ip_list_lock);
-			/* update counters, do not overwrite time field */
-			memcpy(&table->ip_list.l[ip - table->network], &l, sizeof(struct t_ipt_=
account_ip_list) - sizeof(unsigned long));
-			spin_unlock_bh(&table->ip_list_lock);
-		} else {
-			memset(&s, 0, sizeof(struct t_ipt_account_ip_list_short));
-			while(*bufferptr) {
-				if (!isspace(*bufferptr)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected sp=
ace (%ti).\n", bufferptr - buffer);
-					return length; /* expected space */
-				}
-				bufferptr +=3D 1;
-				if (!memcmp(bufferptr, "bytes_src", 9)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got bytes_s=
rc (%ti).\n", bufferptr - buffer);
-					p =3D &s.src.b_all;
-					bufferptr +=3D 9;
-				} else if (!memcmp(bufferptr, "bytes_dest", 10)) {				=09
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got bytes_d=
est (%ti).\n", bufferptr - buffer);
-					p =3D &s.dest.b_all;
-					bufferptr +=3D 10;
-				} else if (!memcmp(bufferptr, "packets_src", 11)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got packets=
_src (%ti).\n", bufferptr - buffer);
-					p =3D &s.src.p_all;
-					bufferptr +=3D 11;
-				} else if (!memcmp(bufferptr, "packets_dest", 12)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got packets=
_dest (%ti).\n", bufferptr - buffer);
-					p =3D &s.dest.p_all;
-					bufferptr +=3D 12;
-				} else if (!memcmp(bufferptr, "time", 4)) {
-					/* time hack, ignore time tokens */
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got time (%=
ti).\n", bufferptr - buffer);
-					bufferptr +=3D 4;
-					if (!isspace(*bufferptr)) {
-						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected s=
pace (%ti).\n", bufferptr - buffer);
-						return length; /* expected space */
-					}
-					bufferptr +=3D 1;
-					if (*bufferptr !=3D '=3D') {
-						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected e=
qual (%ti).\n", bufferptr - buffer);
-						return length; /* expected equal */
-					}
-					bufferptr +=3D 1;
-					if (!isspace(*bufferptr)) {
-						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected s=
pace (%ti).\n", bufferptr - buffer);
-						return length; /* expected space */
-					}
-					bufferptr +=3D 1;
-					if (!(len =3D atoi64(bufferptr, &dummy))) {
-						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected i=
nt64 (%ti).\n", bufferptr - buffer);
-						return length; /* expected int64 */
-					}
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got %llu (%=
ti).\n", dummy, bufferptr - buffer);
-					bufferptr +=3D len;
-					continue; /* skip time token */
-				} else {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected to=
ken (%ti).\n", bufferptr - buffer);
-					return length;	/* expected token */
-				}
-				if (!isspace(*bufferptr)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected sp=
ace (%ti).\n", bufferptr - buffer);
-					return length; /* expected space */
-				}
-				bufferptr +=3D 1;
-				if (*bufferptr !=3D '=3D') {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected eq=
ual (%ti).\n", bufferptr - buffer);
-					return length; /* expected equal */
-				}
-				bufferptr +=3D 1;
-				if (!isspace(*bufferptr)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected sp=
ace (%ti).\n", bufferptr - buffer);
-					return length; /* expected space */
-				}
-				bufferptr +=3D 1;
-				if (!(len =3D atoi64(bufferptr, p))) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected in=
t64 (%ti).\n", bufferptr - buffer);
-					return length; /* expected int64 */
-				}
-				dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got %llu (%t=
i).\n", *p, bufferptr - buffer);
-				bufferptr +=3D len;
-			}
-			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() updating row.=
\n");
-			spin_lock_bh(&table->ip_list_lock);
-			/* update counters, do not overwrite time field */
-			memcpy(&table->ip_list.s[ip - table->network], &s, sizeof(struct t_ipt_=
account_ip_list_short) - sizeof(unsigned long));
-			spin_unlock_bh(&table->ip_list_lock);
-		}
-	}
-=09
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() left.\n");
-	return length;
+	return NULL;
 }
=20
-
-static int account_seq_show(struct seq_file *s, void *v)
+/*
+ * Function, which returns a structure pointer to a table with
+ * specified name. When such table is found its use coutner
+ * is incremented.
+ */
+static inline struct t_ipt_account_table *
+ipt_account_table_find_get(char *name)=20
 {
-	struct proc_dir_entry *pde =3D s->private;
-	struct t_ipt_account_table *table =3D pde->data;
-	unsigned int *bucket =3D (unsigned int *)v;
+	struct t_ipt_account_table *table;
=20
-	u_int32_t address =3D table->network + *bucket;
-	struct timespec last;
+	dprintk(KERN_DEBUG "ipt_account [ipt_account_table_find_get]: name =3D %s=
\n", name);
=20
-	if (!table->shortlisting) {
-		jiffies_to_timespec(jiffies - table->ip_list.l[*bucket].time, &last);
-		seq_printf(s,
-				"ip =3D %u.%u.%u.%u bytes_src =3D %llu %llu %llu %llu %llu packets_src=
 =3D %llu %llu %llu %llu %llu bytes_dest =3D %llu %llu %llu %llu %llu packe=
ts_dest =3D %llu %llu %llu %llu %llu time =3D %lu\n",
-				HIPQUAD(address),
-				table->ip_list.l[*bucket].src.b_all,
-				table->ip_list.l[*bucket].src.b_tcp,
-				table->ip_list.l[*bucket].src.b_udp,
-				table->ip_list.l[*bucket].src.b_icmp,
-				table->ip_list.l[*bucket].src.b_other,
-				table->ip_list.l[*bucket].src.p_all,
-				table->ip_list.l[*bucket].src.p_tcp,
-				table->ip_list.l[*bucket].src.p_udp,
-				table->ip_list.l[*bucket].src.p_icmp,
-				table->ip_list.l[*bucket].src.p_other,
-				table->ip_list.l[*bucket].dest.b_all,
-				table->ip_list.l[*bucket].dest.b_tcp,
-				table->ip_list.l[*bucket].dest.b_udp,
-				table->ip_list.l[*bucket].dest.b_icmp,
-				table->ip_list.l[*bucket].dest.b_other,			=09
-				table->ip_list.l[*bucket].dest.p_all,
-				table->ip_list.l[*bucket].dest.p_tcp,
-				table->ip_list.l[*bucket].dest.p_udp,
-				table->ip_list.l[*bucket].dest.p_icmp,
-				table->ip_list.l[*bucket].dest.p_other,
-				last.tv_sec
-			);
-	} else {
-		jiffies_to_timespec(jiffies - table->ip_list.s[*bucket].time, &last);
-		seq_printf(s,
-				"ip =3D %u.%u.%u.%u bytes_src =3D %llu packets_src =3D %llu bytes_dest=
 =3D %llu packets_dest =3D %llu time =3D %lu\n",
-				HIPQUAD(address),
-				table->ip_list.s[*bucket].src.b_all,
-				table->ip_list.s[*bucket].src.p_all,
-				table->ip_list.s[*bucket].dest.b_all,
-				table->ip_list.s[*bucket].dest.p_all,
-				last.tv_sec
-			  );
+	read_lock_bh(&ipt_account_lock);
+	table =3D __ipt_account_table_find(name);
+	if (!table) {
+		read_unlock_bh(&ipt_account_lock);
+		return NULL;
 	}
-	return 0;
-}
+	atomic_inc(&table->use);
+	read_unlock_bh(&ipt_account_lock);
+	return table;
+}=09
=20
-static struct seq_operations account_seq_ops =3D {
-	.start =3D account_seq_start,
-	.next  =3D account_seq_next,
-	.stop  =3D account_seq_stop,
-	.show  =3D account_seq_show
-};
-
-static int account_seq_open(struct inode *inode, struct file *file)
+/*
+ * Helper function, with updates statistics for specified IP. It's only
+ * used for tables created without --ashort switch.
+ */
+static inline void
+__account_long(struct t_ipt_account_stat_long *stat, const struct sk_buff =
*skb)=20
 {
-	int ret =3D seq_open(file, &account_seq_ops);
-=09
-	if (!ret) {
-		struct seq_file *sf =3D file->private_data;
-		sf->private =3D PDE(inode);
-	}
-	return ret;
-}
-
-static struct file_operations account_file_ops =3D {
-	.owner =3D THIS_MODULE,
-	.open =3D account_seq_open,
-	.read =3D seq_read,
-	.write =3D account_seq_write,
-	.llseek =3D seq_lseek,
-	.release =3D seq_release
-};
-
-/* do raw accounting */
-static inline void do_account(struct t_ipt_account_stat *stat, const struc=
t sk_buff *skb) {
-=09
-	/* update packet & bytes counters in *stat structure */
 	stat->b_all +=3D skb->len;
 	stat->p_all++;
 =09
@@ -550,391 +302,467 @@
 	}
 }
=20
-static inline void do_account_short(struct t_ipt_account_stat_short *stat,=
 const struct sk_buff *skb) {
-
-	/* update packet & bytes counters in *stat structure */
+/*
+ * Same as above, but used for tables created with --ashort switch.
+ */
+static inline void
+__account_short(struct t_ipt_account_stat_short *stat, const struct sk_buf=
f *skb)
+{
 	stat->b_all +=3D skb->len;
 	stat->p_all++;
 }
=20
-static int match(const struct sk_buff *skb,
-	  const struct net_device *in,
-	  const struct net_device *out,
-	  const void *matchinfo,
-	  int offset,
-	  const void *hdr,
-	  u_int16_t datalen,
-	  int *hotdrop)
+/*
+ * Match function. Here we do accounting stuff.
+ */
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+			const void *hdr,
+			u_int16_t datalen,
+      int *hotdrop)
 {
-=09
-	const struct t_ipt_account_info *info =3D (struct t_ipt_account_info*)mat=
chinfo;
-	struct t_ipt_account_table *table;
-	int ret;
-	unsigned long now;
+	struct t_ipt_account_info *info =3D (struct t_ipt_account_info *)matchinf=
o;
+	struct t_ipt_account_table *table =3D info->table;
+	u_int32_t address;=09
+	/* Get current time. */
+	struct timespec now;
+	jiffies_to_timespec(jiffies, &now);
+	/* Default we assume no match. */
+	int ret =3D 0;
+	=09
+	dprintk(KERN_DEBUG "ipt_account [match]: name =3D %s\n", table->name);
=20
-	u_int32_t address;
-=09
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() entered.\n");
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() match name =3D %s.\n", info=
->name);
-=09
-	spin_lock_bh(&account_lock);
-	/* find the right table */
-	table =3D account_tables;
-	while (table && strncmp(table->name, info->name, IPT_ACCOUNT_NAME_LEN) &&=
 (table =3D table->next));
-	spin_unlock_bh(&account_lock);
-
-	if (table =3D=3D NULL) {
-		/* ups, no table with that name */
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() table %s not found. Leavin=
g.\n", info->name);
-		return 0;
-	}
-
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() table found %s\n", table->n=
ame);
-
-	/*  lock table while updating statistics */
-	spin_lock_bh(&table->ip_list_lock);
-
-	/* default: no match */
-	ret =3D 0;
-
-	/* get current time */
-	now =3D jiffies;
-
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() got packet src =3D %u.%u.%u=
=2E%u, dst =3D %u.%u.%u.%u, proto =3D %u.\n", NIPQUAD(skb->nh.iph->saddr), =
NIPQUAD(skb->nh.iph->daddr), skb->nh.iph->protocol);
-		=09
-	/* check whether traffic from source ip address ... */
+	/* Check whether traffic from source ip address ... */
 	address =3D ntohl(skb->nh.iph->saddr);
-	/* ... is being accounted by this table */=09
+	/* ... is being accounted by this table. */=09
 	if (address && ((u_int32_t)(address & table->netmask) =3D=3D (u_int32_t)t=
able->network)) {	=09
-		/* yes, account this packet */
-		dprintk(KERN_INFO "ipt_account: match() accounting packet src =3D %u.%u.=
%u.%u, proto =3D %u.\n", HIPQUAD(address), skb->nh.iph->protocol);
-		/* update counters this host */
+		write_lock_bh(&table->stats_lock);
+		/* Yes, account this packet. */
+		dprintk(KERN_DEBUG "ipt_account: [match]: accounting packet src =3D %u.%=
u.%u.%u, proto =3D %u.\n", HIPQUAD(address), skb->nh.iph->protocol);
+		/* Update counters this host. */
 		if (!table->shortlisting) {
-			do_account(&table->ip_list.l[address - table->network].src, skb);
-			table->ip_list.l[address - table->network].time =3D now;
-			/* update also counters for all hosts in this table (network address) */
-			if (table->netmask !=3D INADDR_BROADCAST) {
-				do_account(&table->ip_list.l[0].src, skb);
-				table->ip_list.l[0].time =3D now;
+			__account_long(&table->stats.l[address - table->network].src, skb);
+			table->stats.l[address - table->network].time =3D now;
+			/* Update also counters for all hosts in this table (network address) */
+			if (table->count > 1) {
+				__account_long(&table->stats.l[0].src, skb);
+				table->stats.l[0].time =3D now;
 			}
 		} else {
-			do_account_short(&table->ip_list.s[address - table->network].src, skb);
-			table->ip_list.s[address - table->network].time =3D now;
-			/* update also counters for all hosts in this table (network address) */
-			if (table->netmask !=3D INADDR_BROADCAST) {
-				do_account_short(&table->ip_list.s[0].src, skb);
-				table->ip_list.s[0].time =3D now;
+			__account_short(&table->stats.s[address - table->network].src, skb);
+			table->stats.s[address - table->network].time =3D now;
+			if (table->count > 1) {
+				__account_short(&table->stats.s[0].src, skb);
+				table->stats.s[0].time =3D now;
 			}
 		}
-		/* yes, it's a match */
+		write_unlock_bh(&table->stats_lock);
+		/* Yes, it's a match. */
 		ret =3D 1;
 	}
-
-	/* do the same thing with destination ip address */
+=09
+	/* Do the same thing with destination ip address. */
 	address =3D ntohl(skb->nh.iph->daddr);
 	if (address && ((u_int32_t)(address & table->netmask) =3D=3D (u_int32_t)t=
able->network)) {
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() accounting packet dst =3D =
%u.%u.%u.%u, proto =3D %u.\n", HIPQUAD(address), skb->nh.iph->protocol);
+		write_lock_bh(&table->stats_lock);
+		dprintk(KERN_DEBUG "ipt_account: [match]: accounting packet dst =3D %u.%=
u.%u.%u, proto =3D %u.\n", HIPQUAD(address), skb->nh.iph->protocol);
 		if (!table->shortlisting) {
-			do_account(&table->ip_list.l[address - table->network].dest, skb);
-			table->ip_list.l[address - table->network].time =3D now;
-			if (table->netmask !=3D INADDR_BROADCAST) {
-				do_account(&table->ip_list.l[0].dest, skb);			=09
-				table->ip_list.s[0].time =3D now;
+			__account_long(&table->stats.l[address - table->network].dst, skb);
+			table->stats.l[address - table->network].time =3D now;
+			if (table->count > 1) {
+				__account_long(&table->stats.l[0].dst, skb);
+				table->stats.l[0].time =3D now;
 			}
 		} else {
-			do_account_short(&table->ip_list.s[address - table->network].dest, skb);
-			table->ip_list.s[address - table->network].time =3D now;
-			if (table->netmask !=3D INADDR_BROADCAST) {
-				do_account_short(&table->ip_list.s[0].dest, skb);
-				table->ip_list.s[0].time =3D now;
+			__account_short(&table->stats.s[address - table->network].dst, skb);
+			table->stats.s[address - table->network].time =3D now;
+			if (table->count > 1) {
+				__account_short(&table->stats.s[0].dst, skb);
+				table->stats.s[0].time =3D now;
 			}
 		}
+		write_unlock_bh(&table->stats_lock);
 		ret =3D 1;
 	}
-	spin_unlock_bh(&table->ip_list_lock);
 =09
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() left.\n");=09
-
 	return ret;
 }
=20
-static int checkentry(const char *tablename,
-	       const struct ipt_ip *ip,
-	       void *matchinfo,
-	       unsigned int matchinfosize,
-	       unsigned int hook_mask)
+/*
+ * Checkentry function.
+ */
+static int
+checkentry(const char *tablename,
+	   const struct ipt_ip *ipt_ip,
+	   void *matchinfo,
+	   unsigned int matchsize,
+	   unsigned int hook_mask)
 {
-	const struct t_ipt_account_info *info =3D matchinfo;
-	struct t_ipt_account_table *table, *find_table, *last_table;
-	int ret =3D 0;
+	struct t_ipt_account_info *info =3D matchinfo;
+	struct t_ipt_account_table *table;
=20
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() entered.\n");
+	dprintk(KERN_DEBUG "ipt_account [checkentry]: name =3D %s\n", info->name);
+=09
+	if (matchsize !=3D IPT_ALIGN(sizeof(struct t_ipt_account_info)))
+		return 0;
=20
-	if (matchinfosize !=3D IPT_ALIGN(sizeof(struct t_ipt_account_info))) retu=
rn 0;
-	if (!info->name || !info->name[0]) return 0;
-
-	/* find whether table with this name already exists */
-	spin_lock_bh(&account_lock);
-	find_table =3D account_tables;
-	while( (last_table =3D find_table) && strncmp(info->name,find_table->name=
,IPT_ACCOUNT_NAME_LEN) && (find_table =3D find_table->next) );
-	if (find_table !=3D NULL) {
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() table %s found.\n", i=
nfo->name);	=09
-		/* if table exists, check whether table network/netmask equals rule netw=
ork/netmask */
-		if (find_table->network !=3D info->network || find_table->netmask !=3D i=
nfo->netmask || find_table->shortlisting !=3D info->shortlisting) {
-			spin_unlock_bh(&account_lock);
-			printk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() wrong parameters (not=
 equals existing table parameters).\n");
-			ret =3D 0;
-			goto failure;
-		}
-		/* increment table use count */
-		find_table->use_count++;
-		spin_unlock_bh(&account_lock);
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() incrementing use coun=
t.\n");
-		ret =3D 1;
-		goto failure;
+	/*=20
+	 * Sanity checks.=20
+	 */
+	if (info->netmask < ((~0L << (32 - netmask)) & 0xffffffff)) {
+		printk(KERN_ERR "ipt_account[checkentry]: too big netmask (increase modu=
le 'netmask' parameter).\n");
+		return 0;
 	}
-	spin_unlock_bh(&account_lock);
-
-	/* check netmask first, before allocating memory */
-	if (info->netmask < ((1 << netmask) - 1)) {
-		printk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() too big netmask.\n");
-		ret =3D 0;
-		goto failure;
+	if ((info->network & info->netmask) !=3D info->network) {
+		printk(KERN_ERR "ipt_account[checkentry]: wrong network/netmask.\n");
+		return 0;
 	}
-
-	/* table doesn't exist - create new */
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() allocating %zu for new=
 table %s.\n", sizeof(struct t_ipt_account_table), info->name);
-        table =3D vmalloc(sizeof(struct t_ipt_account_table));
-	if (table =3D=3D NULL) {
-		printk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() failed to allocate %zu=
 for new table %s.\n", sizeof(struct t_ipt_account_table), info->name);
-		ret =3D 0; /* was -ENOMEM */
-		goto failure;
+	if (info->name[0] =3D=3D '\0') {
+		printk(KERN_ERR "ipt_account[checkentry]: wrong table name.\n");
+		return 0;
 	}
+		=09
+	/*
+	 * Avoid searching list for already seen and added rules.
+	 * Simply increase use count and exit.
+	 */
+	if (info->table) {
+		ipt_account_table_get(info->table);
+		return 1;
+	}
 =09
-	/* setup table parameters */
-	table->ip_list_lock =3D SPIN_LOCK_UNLOCKED;
-	table->next =3D NULL;
-	table->use_count =3D 1;
-	table->network =3D info->network;
-	table->netmask =3D info->netmask;
-	table->shortlisting =3D info->shortlisting;
-	table->count =3D (~table->netmask) + 1;
-	strncpy(table->name,info->name,IPT_ACCOUNT_NAME_LEN);
-	table->name[IPT_ACCOUNT_NAME_LEN - 1] =3D '\0';
-=09
-	/* allocate memory for table->ip_list */
-	if (!table->shortlisting) {
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() allocating %zu for ip=
_list.\n", sizeof(struct t_ipt_account_ip_list) * table->count);
-		table->ip_list.l =3D vmalloc(sizeof(struct t_ipt_account_ip_list) * tabl=
e->count);
-		if (table->ip_list.l =3D=3D NULL) {
-			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() failed to allocate %=
zu for ip_list.\n", sizeof(struct t_ipt_account_ip_list) * table->count);
-			ret =3D 0; /* was -ENOMEM */
-			goto failure_table;
+	/*
+	 * We got new rule. Try to find table with the same name as given in info=
 structure.
+	 */
+	table =3D ipt_account_table_find_get(info->name);
+	if (!table) {
+		dprintk(KERN_DEBUG "ipt_account [checkentry]: table not found, creating =
new one.\n");
+		/*
+		 * Table not exist, create new one.
+		 */
+		table =3D ipt_account_table_init(info);
+		if (!table) {
+			return 0;
 		}
-		memset(table->ip_list.l, 0, sizeof(struct t_ipt_account_ip_list) * table=
->count);
 	} else {
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() allocating %zu for ip=
_list.\n", sizeof(struct t_ipt_account_ip_list_short) * table->count);
-		table->ip_list.s =3D vmalloc(sizeof(struct t_ipt_account_ip_list_short) =
* table->count);
-		if (table->ip_list.s =3D=3D NULL) {
-			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() failed to allocate %=
zu for ip_list.\n", sizeof(struct t_ipt_account_ip_list_short) * table->cou=
nt);
-			ret =3D 0; /* was -ENOMEM */
-			goto failure_table;
+		dprintk(KERN_DEBUG "ipt_account [checkentry]: table found, checking.\n");
+		/*=20
+		 * Table exists, but whether rule network/netmask/shortlisting matches=
=20
+		 * table network/netmask/shortlisting. Failure on missmatch.=20
+		 */	=09
+		if (table->network !=3D info->network || table->netmask !=3D info->netma=
sk || table->shortlisting !=3D info->shortlisting) {
+			printk(KERN_ERR "ipt_account [checkentry]: table found, rule network/ne=
tmask/shortlisting not match table network/netmask/shortlisting.\n");
+			/*
+			 * Remember to release table usage counter.
+			 */
+			ipt_account_table_put(table);
+			return 0;
 		}
-		memset(table->ip_list.s, 0, sizeof(struct t_ipt_account_ip_list_short) *=
 table->count);
+		dprintk(KERN_DEBUG "ipt_account [checkentry]: table found, reusing.\n");
 	}
+	/*
+	 * Link rule with table.
+	 */
+	info->table =3D table;
+	return 1;
+}
+
+/*
+ * Destroy function.
+ */
+static void
+destroy(void *matchinfo, unsigned int matchsize)
+{
+	struct t_ipt_account_info *info =3D matchinfo;
 =09
-	/* put table into chain */
-	spin_lock_bh(&account_lock);
-	find_table =3D account_tables;
-	while( (last_table =3D find_table) && strncmp(info->name, find_table->nam=
e, IPT_ACCOUNT_NAME_LEN) && (find_table =3D find_table->next) );
-	if (find_table !=3D NULL) {
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() table %s found.\n", i=
nfo->name);
-		if (find_table->network !=3D info->network || find_table->netmask !=3D i=
nfo->netmask) {
-			spin_unlock_bh(&account_lock);
-			printk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() wrong network/netmask=
=2E\n");
-			ret =3D 0;
-			goto failure_ip_list;
-		}
-		find_table->use_count++;
-		spin_unlock_bh(&account_lock);
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() incrementing use coun=
t.\n");
-		ret =3D 1;
-		goto failure_ip_list;
-	}
-	if (!last_table)=20
-		account_tables =3D table;=20
-	else=20
-		last_table->next =3D table;
-	spin_unlock_bh(&account_lock);
+	dprintk(KERN_DEBUG "ipt_account [destroy]: name =3D %s\n", info->name);
=20
-	/* create procfs status file */
-	table->status_file =3D create_proc_entry(table->name, permissions, proc_n=
et_ipt_account);
-	if (table->status_file =3D=3D NULL) {
-		ret =3D 0; /* was -ENOMEM */
-		goto failure_unlink;
-	}
-	table->status_file->owner =3D THIS_MODULE;
-	table->status_file->data =3D table;=09
-	wmb();
-//	if (!table->shortlisting)
-		table->status_file->proc_fops =3D &account_file_ops;
-//	else
-//		table->status_file->proc_fops =3D &account_file_ops_short;
+	/*
+	 * Release table, by decreasing its usage counter. When
+	 * counter hits zero, memory used by table structure is
+	 * released and table is removed from list.
+	 */
+	ipt_account_table_put(info->table);
+	return;
+}
=20
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() left.\n");=09
-	/* everything went just okey */
-	return 1;
+static struct ipt_match account_match =3D {=20
+  .name =3D "account",=20
+  .match =3D &match,=20
+  .checkentry =3D &checkentry,=20
+  .destroy =3D &destroy,=20
+  .me =3D THIS_MODULE
+};
=20
-	/* do cleanup in case of failure */
-failure_unlink:
-	/* remove table from list */
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() removing table.\n");
-	spin_lock_bh(&account_lock);
-	last_table =3D NULL;
-	table =3D account_tables;
-	if (table =3D=3D NULL) {
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() no table found. Leavi=
ng.\n");
-		spin_unlock_bh(&account_lock);
-		return 0; /* was -ENOMEM */
+/*
+ * Below functions (ipt_account_seq_start, ipt_account_seq_next,=20
+ * ipt_account_seq_stop, ipt_account_seq_show, ipt_account_proc_write)=20
+ * are used to implement proc stuff.
+ */
+static void *ipt_account_seq_start(struct seq_file *sf, loff_t *pos)
+{
+	struct proc_dir_entry *pde =3D sf->private;
+	struct t_ipt_account_table *table =3D pde->data;
+	unsigned int *i;
+
+	read_lock_bh(&table->stats_lock);
+	if (*pos >=3D table->count)
+		return NULL;
+	i =3D kmalloc(sizeof(unsigned int), GFP_ATOMIC);
+	if (!i)
+		return ERR_PTR(-ENOMEM);
+	*i =3D *pos;
+	return i;
+}
+
+static void *ipt_account_seq_next(struct seq_file *sf, void *v, loff_t *po=
s)
+{
+	struct proc_dir_entry *pde =3D sf->private;
+	struct t_ipt_account_table *table =3D pde->data;
+	unsigned int *i =3D (unsigned int *)v;
+
+	*pos =3D ++(*i);
+	if (*i >=3D table->count) {
+		kfree(v);
+		return NULL;
 	}
-	while (strncmp(info->name, table->name, IPT_ACCOUNT_NAME_LEN) && (last_ta=
ble =3D table) && (table =3D table->next));
-	if (table =3D=3D NULL) {
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() table already destroy=
ed. Leaving.\n");
-		spin_unlock_bh(&account_lock);
-		return 0; /* was -ENOMEM */
-	}
-	if (last_table)
-		last_table->next =3D table->next;
-	else
-		account_tables =3D table->next;
-	spin_unlock_bh(&account_lock);
-failure_ip_list:
-	/* free memory allocated for statistics table */
-	if (!table->shortlisting)
-		vfree(table->ip_list.l);
-	else
-		vfree(table->ip_list.s);
-failure_table:
-	/* free table */
-	vfree(table);
-failure:
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() left. Table not create=
d.\n");=09
-	/* failure return */
-	return ret;
+	return i;
 }
=20
-static void destroy(void *matchinfo,=20
-	     unsigned int matchinfosize)
+static void ipt_account_seq_stop(struct seq_file *sf, void *v)
 {
-	const struct t_ipt_account_info *info =3D matchinfo;
-	struct t_ipt_account_table *table, *last_table;
+	struct proc_dir_entry *pde =3D sf->private;
+	struct t_ipt_account_table *table =3D pde->data;
+	kfree(v);
+	read_unlock_bh(&table->stats_lock);
+}
=20
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": destory() entered.\n");
+static int ipt_account_seq_show(struct seq_file *sf, void *v)
+{
+	struct proc_dir_entry *pde =3D sf->private;
+	struct t_ipt_account_table *table =3D pde->data;
+	unsigned int *i =3D (unsigned int *)v;
 =09
-	if (matchinfosize !=3D IPT_ALIGN(sizeof(struct t_ipt_account_info))) retu=
rn;
+	struct timespec now;
+	jiffies_to_timespec(jiffies, &now);
+=09
+	u_int32_t address =3D table->network + *i;
=20
-	/* search for table */
-	spin_lock_bh(&account_lock);
-	last_table =3D NULL;
-	table =3D account_tables;
-	if(table =3D=3D NULL) {
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": destory() no tables found. Leaving=
=2E\n");
-		spin_unlock_bh(&account_lock);
-		return;
+	if (!table->shortlisting) {
+		struct t_ipt_account_stats_long *l =3D &table->stats.l[*i];
+		seq_printf(sf,
+				"ip =3D %u.%u.%u.%u bytes_src =3D %Lu %Lu %Lu %Lu %Lu packets_src =3D =
%Lu %Lu %Lu %Lu %Lu bytes_dst =3D %Lu %Lu %Lu %Lu %Lu packets_dst =3D %Lu %=
Lu %Lu %Lu %Lu time =3D %lu\n",
+				HIPQUAD(address),
+				l->src.b_all,
+				l->src.b_tcp,
+				l->src.b_udp,
+				l->src.b_icmp,
+				l->src.b_other,
+				l->src.p_all,
+				l->src.p_tcp,
+				l->src.p_udp,
+				l->src.p_icmp,
+				l->src.p_other,
+				l->dst.b_all,
+				l->dst.b_tcp,
+				l->dst.b_udp,
+				l->dst.b_icmp,
+				l->dst.b_other,			=09
+				l->dst.p_all,
+				l->dst.p_tcp,
+				l->dst.p_udp,
+				l->dst.p_icmp,
+				l->dst.p_other,
+				now.tv_sec - l->time.tv_sec
+			);
+	} else {
+		struct t_ipt_account_stats_short *s =3D &table->stats.s[*i];
+		seq_printf(sf,
+				"ip =3D %u.%u.%u.%u bytes_src =3D %Lu packets_src =3D %Lu bytes_dst =
=3D %Lu packets_dst =3D %Lu time =3D %lu\n",
+				HIPQUAD(address),
+				s->src.b_all,
+				s->src.p_all,
+				s->dst.b_all,
+				s->dst.p_all,
+				now.tv_sec - s->time.tv_sec
+			);
 	}
-	while( strncmp(info->name,table->name,IPT_ACCOUNT_NAME_LEN) && (last_tabl=
e =3D table) && (table =3D table->next) );
-	if (table =3D=3D NULL) {
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": destory() no table %s not found. L=
eaving.\n", info->name);
-		spin_unlock_bh(&account_lock);
-		return;
-	}
=20
-	/* decrement table use-count */
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": destory() decrementing use count.\n=
");
-	table->use_count--;
-	if (table->use_count) {
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": destory() table still in use. Leav=
ing.\n");
-		spin_unlock_bh(&account_lock);
-		return;
+	return 0;
+}
+
+static struct seq_operations ipt_account_seq_ops =3D {
+	.start =3D ipt_account_seq_start,
+	.next =3D ipt_account_seq_next,
+	.stop =3D ipt_account_seq_stop,
+	.show =3D ipt_account_seq_show
+};
+
+static ssize_t ipt_account_proc_write(struct file *file, const char __user=
 *input, size_t size, loff_t *ofs)
+{
+	char buffer[1024];
+	struct proc_dir_entry *pde =3D PDE(file->f_dentry->d_inode);
+	struct t_ipt_account_table *table =3D pde->data;
+
+	u_int32_t o[4], ip;
+	struct t_ipt_account_stats_long l;
+	struct t_ipt_account_stats_short s;
+
+	dprintk(KERN_DEBUG "ipt_account [ipt_account_proc_write]: name =3D %s.\n"=
, table->name);
+
+	if (copy_from_user(buffer, input, 1024))
+		return -EFAULT;
+
+	if (!strncmp(buffer, "reset", 5)) {
+		/*
+		 * User requested to clear all table. Ignorant, does
+		 * he known how match time it took us to fill it? ;-)
+		 */
+		write_lock_bh(&table->stats_lock);
+		if (table->shortlisting)
+			memset(table->stats.s, 0, sizeof(struct t_ipt_account_stats_short) * ta=
ble->count);
+		else
+			memset(table->stats.l, 0, sizeof(struct t_ipt_account_stats_long) * tab=
le->count);
+		write_unlock_bh(&table->stats_lock);	=09
+	} else if (!table->shortlisting && sscanf(buffer, "ip =3D %u.%u.%u.%u byt=
es_src =3D %Lu %Lu %Lu %Lu %Lu packets_src =3D %Lu %Lu %Lu %Lu %Lu bytes_ds=
t =3D %Lu %Lu %Lu %Lu %Lu packets_dst =3D %Lu %Lu %Lu %Lu %Lu time =3D %lu"=
, 			=09
+				&o[0], &o[1], &o[2], &o[3],
+				&l.src.b_all, &l.src.b_tcp, &l.src.b_udp, &l.src.b_icmp, &l.src.b_othe=
r,
+				&l.src.p_all, &l.src.p_tcp, &l.src.p_udp, &l.src.p_icmp, &l.src.p_othe=
r,
+				&l.dst.b_all, &l.dst.b_tcp, &l.dst.b_udp, &l.dst.b_icmp, &l.dst.b_othe=
r,
+				&l.dst.p_all, &l.dst.p_tcp, &l.dst.p_udp, &l.dst.p_icmp, &l.dst.p_othe=
r,
+				&l.time.tv_sec) =3D=3D 25) {
+		/*
+		 * We got line formated like long listing row. We have to
+		 * check, if IP is accounted by table. If so, we
+		 * simply replace row with user's one.
+		 */
+		ip =3D o[0] << 24 | o[1] << 16 | o[2] << 8 | o[3];
+		if ((u_int32_t)(ip & table->netmask) =3D=3D (u_int32_t)table->network) {
+			/*
+			 * Ignore user input time. Set current time.
+			 */
+			jiffies_to_timespec(jiffies, &l.time);
+			write_lock_bh(&table->stats_lock);
+			table->stats.l[ip - table->network] =3D l;
+			write_unlock_bh(&table->stats_lock);
+		}
+	} else if (table->shortlisting && sscanf(buffer, "ip =3D %u.%u.%u.%u byte=
s_src =3D %Lu packets_src =3D %Lu bytes_dst =3D %Lu packets_dst =3D %Lu tim=
e =3D %lu\n",=20
+				&o[0], &o[1], &o[2], &o[3],=20
+				&s.src.b_all,=20
+				&s.src.p_all,=20
+				&s.dst.b_all,=20
+				&s.dst.p_all,=20
+				&s.time.tv_sec) =3D=3D 9) {	=09
+		/*
+		 * We got line formated like short listing row. Do the
+		 * same action like above.
+		 */	=09
+		ip =3D o[0] << 24 | o[1] << 16 | o[2] << 8 | o[3];	=09
+		if ((u_int32_t)(ip & table->netmask) =3D=3D (u_int32_t)table->network) {
+			jiffies_to_timespec(jiffies, &s.time);
+			write_lock_bh(&table->stats_lock);
+			table->stats.s[ip - table->network] =3D s;
+			write_unlock_bh(&table->stats_lock);
+		}
+	} else {
+		/*
+		 * We don't understand what user have just wrote.
+		 */
+		return -EIO;
 	}
=20
-	/* remove table if use-count is zero */
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": destory() table %s not used. Removi=
ng.\n", table->name);
+	return size;
+}
=20
-	/* unlink table */
-	if(last_table)=20
-		last_table->next =3D table->next;=20
-	else=20
-		account_tables =3D table->next;
-	spin_unlock_bh(&account_lock);
+static int ipt_account_proc_open(struct inode *inode, struct file *file)
+{
+	int ret =3D seq_open(file, &ipt_account_seq_ops);
+	if (!ret) {
+		struct seq_file *sf =3D file->private_data;
+		struct proc_dir_entry *pde =3D PDE(inode);
+		struct t_ipt_account_table *table =3D pde->data;
+	=09
+		sf->private =3D pde;
=20
-	/* wait while table is still in use */
-	spin_lock_bh(&table->ip_list_lock);
-	spin_unlock_bh(&table->ip_list_lock);
+		ipt_account_table_get(table);
+	}
+	return ret;
+}
=20
-	/* remove proc entries */=09
-	remove_proc_entry(table->name, proc_net_ipt_account);
+static int ipt_account_proc_release(struct inode *inode, struct file *file)
+{
+	struct proc_dir_entry *pde =3D PDE(inode);
+	struct t_ipt_account_table *table =3D pde->data;
+	int ret;
=20
-	/* remove table */
-	if (!table->shortlisting)
-		vfree(table->ip_list.l);
-	else
-		vfree(table->ip_list.s);
-	vfree(table);
+	ret =3D seq_release(inode, file);
=20
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": destory() left.\n");
-	return;
+	if (!ret)
+		ipt_account_table_put(table);
+=09
+	return ret;
 }
=20
-static struct ipt_match account_match =3D {
-	.name =3D "account",
-	.match =3D &match,
-	.checkentry =3D &checkentry,
-	.destroy =3D &destroy,
-	.me =3D THIS_MODULE
+static struct file_operations ipt_account_proc_fops =3D {
+	.owner =3D THIS_MODULE,
+	.open =3D ipt_account_proc_open,
+	.read =3D seq_read,
+	.write =3D ipt_account_proc_write,
+	.llseek =3D seq_lseek,
+	.release =3D ipt_account_proc_release
 };
=20
-static int __init init(void)=20
+/*
+ * Module init function.
+ */
+static int __init init(void)
 {
-	int err;
-=09
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": __init() entered.\n");
-	printk(version);=09
-	/* check params */
+	int ret =3D 0;
+
+	printk(KERN_INFO "ipt_account %s : Piotr Gasid=C5=82o <quaker@barbara.eu.=
org>, http://www.barbara.eu.org/~quaker/ipt_account/\n", IPT_ACCOUNT_VERSIO=
N);
+
+	/* Check module parameters. */
 	if (netmask > 32 || netmask < 0) {
-		printk(KERN_INFO "account: Wrong netmask given by netmask parameter (%i)=
=2E Valid is 32 to 0.\n", netmask);
-		err =3D -EINVAL;
-		goto doexit;
+		printk(KERN_ERR "ipt_account[__init]: Wrong netmask given as parameter (=
%i). Valid is 32 to 0.\n", netmask);
+		ret =3D -EINVAL;
+		goto cleanup_none;
 	}
+=09
+	/* Register match. */
+	if (ipt_register_match(&account_match)) {
+		ret =3D -EINVAL;
+		goto cleanup_none;
+	}
=20
-	/* create /proc/net/ipt_account directory */
-	proc_net_ipt_account =3D proc_mkdir("ipt_account", proc_net);
-	if (!proc_net_ipt_account) {	=09
-		printk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() failed to create procf=
s entry.\n");
-		err =3D -ENOMEM;
-		goto doexit;
+	/* Create /proc/net/ipt_account/ entry. */
+	ipt_account_procdir =3D proc_mkdir("ipt_account", proc_net);
+	if (!ipt_account_procdir) {	=09
+		printk(KERN_ERR "ipt_account [__init]: ipt_account_procdir =3D proc_mkdi=
r(\"ipt_account\", proc_net) failed.\n");
+		ret =3D -ENOMEM;
+		goto cleanup_match;
 	}
-	proc_net_ipt_account->owner =3D THIS_MODULE;
 =09
-	err =3D ipt_register_match(&account_match);
-	if (err) {
-		printk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() failed to register mat=
ch.\n");
-		remove_proc_entry("ipt_account", proc_net);
-	}
-doexit:
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": __init() left.\n");
-	return err;
+	return ret;
+
+	/* If something goes wrong we end here. */
+cleanup_match:
+	ipt_unregister_match(&account_match);
+cleanup_none:
+	return ret;
 }
=20
-static void __exit fini(void)=20
+/*
+ * Module exit function.
+ */
+static void __exit fini(void)
 {
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": __exit() entered.\n");
-=09
+	/* Remove /proc/net/ipt_account/ */
+	remove_proc_entry(ipt_account_procdir->name, ipt_account_procdir->parent)=
;=09
 	ipt_unregister_match(&account_match);
-	/* remove /proc/net/ipt_account/ directory */
-	remove_proc_entry("ipt_account", proc_net);
-
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": __exit() left.\n");
 }
=20
 module_init(init);
Index: patchlets/account/linux-2.6/include/linux/netfilter_ipv4/ipt_account=
=2Eh
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- patch-o-matic-ng.orig/patchlets/account/linux-2.6/include/linux/netfilt=
er_ipv4/ipt_account.h	(wersja 6575)
+++ patch-o-matic-ng/patchlets/account/linux-2.6/include/linux/netfilter_ip=
v4/ipt_account.h	(kopia robocza)
@@ -1,10 +1,8 @@
-/*=20
- * accounting match (ipt_account.c)
- * (C) 2003,2004 by Piotr Gasidlo (quaker@barbara.eu.org)
+/* Copyright (c) 2004-2006 Piotr 'QuakeR' Gasid=C5=82o <quaker@barbara.eu.=
org>
  *
- * Version: 0.1.7
- *
- * This software is distributed under the terms of GNU GPL
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
  */
=20
 #ifndef _IPT_ACCOUNT_H_
@@ -12,15 +10,15 @@
=20
 #define IPT_ACCOUNT_NAME_LEN 64
=20
-#define IPT_ACCOUNT_NAME "ipt_account"
-#define IPT_ACCOUNT_VERSION  "0.1.7"
+struct t_ipt_account_table;
=20
 struct t_ipt_account_info {
-	char name[IPT_ACCOUNT_NAME_LEN];
-	u_int32_t network;
-	u_int32_t netmask;
+	char name[IPT_ACCOUNT_NAME_LEN + 1];
+	u_int32_t network, netmask;
 	int shortlisting:1;
+	/* pointer to the table for fast matching */
+	struct t_ipt_account_table *table;
 };
=20
-#endif
+#endif /* _IPT_ACCOUNT_H */
=20
Index: patchlets/account/linux-2.6/net/ipv4/netfilter/ipt_account.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- patch-o-matic-ng.orig/patchlets/account/linux-2.6/net/ipv4/netfilter/ip=
t_account.c	(wersja 6575)
+++ patch-o-matic-ng/patchlets/account/linux-2.6/net/ipv4/netfilter/ipt_acc=
ount.c	(kopia robocza)
@@ -1,533 +1,282 @@
-/*=20
- * accounting match (ipt_account.c)
- * (C) 2003,2004 by Piotr Gasidlo (quaker@barbara.eu.org)
+/* Copyright (c) 2004-2006 Piotr 'QuakeR' Gasid=C5=82o <quaker@barbara.eu.=
org>
  *
- * Version: 0.1.7
- *
- * This software is distributed under the terms of GNU GPL
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
  */
=20
 #include <linux/module.h>
 #include <linux/skbuff.h>
-#include <linux/proc_fs.h>
-#include <linux/spinlock.h>
 #include <linux/vmalloc.h>
-#include <linux/interrupt.h>
-#include <linux/ctype.h>
-
+#include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <linux/time.h>
=20
-#include <asm/uaccess.h>
+#define IPT_ACCOUNT_VERSION "0.1.20"
=20
-#include <linux/ip.h>
-#include <linux/tcp.h>
-#include <linux/udp.h>
+// #define DEBUG_IPT_ACCOUNT
=20
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ipt_account.h>
-
-#if defined(CONFIG_IP_NF_MATCH_ACCOUNT_DEBUG)
-	#define dprintk(format,args...) printk(format,##args)
+#ifdef DEBUG_IPT_ACCOUNT
+	#define dprintk(format, args...) printk(format, ##args)
 #else
-        #define dprintk(format,args...)
+	#define dprintk(format, args...)
 #endif
=20
-static char version[] =3D
-KERN_INFO IPT_ACCOUNT_NAME " " IPT_ACCOUNT_VERSION " : Piotr Gasid=C5=82o =
<quaker@barbara.eu.org>, http://www.barbara.eu.org/~quaker/ipt_account/\n";
-
-/* rights for files created in /proc/net/ipt_account/ */
-static int permissions =3D 0644;
-/* maximal netmask for single table */
-static int netmask =3D 16;
-
-/* module information */
 MODULE_AUTHOR("Piotr Gasidlo <quaker@barbara.eu.org>");
-MODULE_DESCRIPTION("Traffic accounting modules");
+MODULE_DESCRIPTION("Traffic accounting module");
 MODULE_LICENSE("GPL");
-module_param(permissions, int, 0400);
-module_param(netmask, int, 0400);
-MODULE_PARM_DESC(permissions,"permissions on /proc/net/ipt_account/* files=
");
-MODULE_PARM_DESC(netmask, "maximum *save* size of one list (netmask)");
=20
-/* structure with statistics counters */
-struct t_ipt_account_stat {
-	u_int64_t b_all, b_tcp, b_udp, b_icmp, b_other;		/* byte counters for all=
/tcp/udp/icmp/other traffic  */
-	u_int64_t p_all, p_tcp, p_udp, p_icmp, p_other;		/* packet counters for a=
ll/tcp/udp/icmp/other traffic */
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_account.h>
+
+/* defaults, can be overriden */
+static unsigned int netmask =3D 16; /* Safe netmask, if you try to create =
table
+																		 for larger netblock you will get error.=20
+																		 Increase by command line only when you
+																		 known what are you doing. */
+
+module_param(netmask, uint, 0400);
+MODULE_PARM_DESC(netmask,"maximum *save* netmask");
+
+/* structure with statistics counter, used when table is created without -=
-ashort switch */
+struct t_ipt_account_stat_long {
+	u_int64_t b_all, b_tcp, b_udp, b_icmp, b_other;
+	u_int64_t p_all, p_tcp, p_udp, p_icmp, p_other;
 };
=20
-/* stucture with statistics counters, used when table is created with --as=
hort switch */
+/* same as above, for tables created with --ashort switch */
 struct t_ipt_account_stat_short {
-	u_int64_t b_all;					/* byte counters for all traffic */
-	u_int64_t p_all;					/* packet counters for all traffic */
+	u_int64_t b_all;
+	u_int64_t p_all;
 };
-=20
-/* structure holding to/from statistics for single ip */
-struct t_ipt_account_ip_list {
-	struct t_ipt_account_stat src;
-	struct t_ipt_account_stat dest;
-	unsigned long time;					/* time when this record was last updated */=09
-=09
+
+/* structure holding to/from statistics for single ip when table is create=
d without --ashort switch */
+struct t_ipt_account_stats_long {
+	struct t_ipt_account_stat_long src, dst;
+	struct timespec time; /* time, when statistics was last modified */
 };
=20
-/* same as above, for tables with --ashort switch */
-struct t_ipt_account_ip_list_short {
-	struct t_ipt_account_stat_short src;
-	struct t_ipt_account_stat_short dest;
-	unsigned long time;
+/* same as above, for tables created with --ashort switch */
+struct t_ipt_account_stats_short {
+	struct t_ipt_account_stat_short src, dst;
+	struct timespec time;
 };
=20
 /* structure describing single table */
 struct t_ipt_account_table {
-	char name[IPT_ACCOUNT_NAME_LEN];	/* table name ( =3D filename in /proc/ne=
t/ipt_account/) */
-	union {					/* table with statistics for each ip in network/netmask */
-		struct t_ipt_account_ip_list *l;
-		struct t_ipt_account_ip_list_short *s;
-	} ip_list;
-	u_int32_t network;			/* network/netmask covered by table*/
-	u_int32_t netmask;				=09
-	u_int32_t count;
-	int shortlisting:1;			/* show only total columns of counters */=09
-	int use_count;				/* rules counter - counting number of rules using this =
table */
-	struct t_ipt_account_table *next;
-	spinlock_t ip_list_lock;
-	struct proc_dir_entry *status_file;
-};
+	struct list_head list;
+	atomic_t use; /* use counter, the number of rules which points to this ta=
ble */
=20
-/* we must use spinlocks to avoid parallel modifications of table list */
-static spinlock_t account_lock =3D SPIN_LOCK_UNLOCKED;
+	char name[IPT_ACCOUNT_NAME_LEN + 1]; /* table name ( =3D filename in /pro=
c/net/ipt_account/) */
+	u_int32_t network, netmask, count; /* network/netmask/hosts count coverte=
d by table */
=20
-static struct proc_dir_entry *proc_net_ipt_account =3D NULL;
+	int shortlisting:1; /* gather only total statistics (set for tables creat=
ed with --ashort switch) */
+=09
+	union { /* statistics for each ip in network/netmask */
+		struct t_ipt_account_stats_long *l;
+		struct t_ipt_account_stats_short *s;
+	} stats;
+	rwlock_t stats_lock; /* lock, to assure that above union can be safely mo=
dified */
=20
-/* root pointer holding list of the tables */
-static struct t_ipt_account_table *account_tables =3D NULL;
+	struct proc_dir_entry *pde; /* handle to proc entry */
+};
=20
-/* convert ascii to ip */
-int atoip(char *buffer, u_int32_t *ip) {
+static LIST_HEAD(ipt_account_tables);
+static rwlock_t ipt_account_lock =3D RW_LOCK_UNLOCKED; /* lock, to assure =
that table list can be safely modified */
=20
-	char *bufferptr =3D buffer;
-	int part, shift;
+static struct file_operations ipt_account_proc_fops;
+static struct proc_dir_entry *ipt_account_procdir;
+
+/*
+ * Function creates new table and inserts it into linked list.
+ */
+static struct t_ipt_account_table *
+ipt_account_table_init(struct t_ipt_account_info *info)
+{=09
+	struct t_ipt_account_table *table;
 =09
-	/* zero ip */
-	*ip =3D 0;
+	dprintk(KERN_DEBUG "ipt_account [ipt_account_table_init]: name =3D %s\n",=
 info->name);
=20
-	/* first must be a digit */
-	if (!isdigit(*bufferptr))
-		return 0;
+	/*
+	 * Allocate memory for table.
+	 */
+	table =3D vmalloc(sizeof(struct t_ipt_account_table));
+	if (!table) {
+		printk(KERN_ERR "ipt_account [ipt_account_table_init]: table =3D vmalloc=
(sizeof(struct t_ipt_account_table)) failed.\n");
+		goto cleanup_none;
+	}
+	memset(table, 0, sizeof(struct t_ipt_account_table));
=20
-	/* parse first 3 octets (III.III.III.iii) */
-	for (part =3D 0, shift =3D 24; *bufferptr && shift; bufferptr++) {
-		if (isdigit(*bufferptr)) {
-			part =3D part * 10 + (*bufferptr - '0');
-			continue;
+	/*
+	 * Table attributes.
+	 */
+	strncpy(table->name, info->name, IPT_ACCOUNT_NAME_LEN);=09
+	table->name[IPT_ACCOUNT_NAME_LEN - 1] =3D '\0';
+
+	table->network =3D info->network;
+	table->netmask =3D info->netmask;
+	table->count =3D (0xffffffff ^ table->netmask) + 1;
+=09
+	/*
+	 * Table properties.
+	 */
+	table->shortlisting =3D info->shortlisting;
+=09
+	/*
+	 * Initialize use counter.
+	 */
+	atomic_set(&table->use, 1);
+
+	/*
+	 * Allocate memory for statistic counters.
+	 */
+	if (table->shortlisting) {
+		table->stats.s =3D vmalloc(sizeof(struct t_ipt_account_stats_short) * ta=
ble->count);
+		if (!table->stats.s) {
+			printk(KERN_ERR "ipt_account [ipt_account_table_init]: table->stats.s =
=3D vmalloc(sizeof(struct t_ipt_account_stats_short) * table->count) failed=
=2E\n");
+			goto cleanup_table;
 		}
-		if (*bufferptr =3D=3D '.') {
-			if (part > 255)
-				return 0;
-			*ip |=3D part << shift;
-			shift -=3D 8;
-			part =3D 0;
-			continue;
+		memset(table->stats.s, 0, sizeof(struct t_ipt_account_stats_short) * tab=
le->count);
+	} else {
+		table->stats.l =3D vmalloc(sizeof(struct t_ipt_account_stats_long) * tab=
le->count);
+		if (!table->stats.l) {
+			printk(KERN_ERR "ipt_account [ipt_account_table_init]: table->stats.l =
=3D vmalloc(sizeof(struct t_ipt_account_stats_long) * table->count) failed.=
\n");
+			goto cleanup_table;
 		}
-		return 0;
+		memset(table->stats.l, 0, sizeof(struct t_ipt_account_stats_long) * tabl=
e->count);
 	}
 =09
-	/* we expect more digts */
-	if (!*bufferptr)
-		return 0;
-	/* parse last octet (iii.iii.iii.III) */
-	for (; *bufferptr; bufferptr++) {
-		if (isdigit(*bufferptr)) {
-			part =3D part * 10 + (*bufferptr - '0');		=09
-			continue;
-		} else {
-			if (part > 255)
-				return 0;
-			*ip |=3D part;
-			break;
-		}
+	/*
+	 * Reset locks.
+	 */
+	table->stats_lock =3D RW_LOCK_UNLOCKED;
+=09
+	/*
+	 * Create /proc/ipt_account/name entry.
+	 */
+	table->pde =3D create_proc_entry(table->name, S_IWUSR | S_IRUSR, ipt_acco=
unt_procdir);
+	if (!table->pde) {
+		goto cleanup_stats;
 	}
-	return (bufferptr - buffer);
-}
+	table->pde->proc_fops =3D &ipt_account_proc_fops;
+	table->pde->data =3D table;
+=09
+	/*
+	 * Insert table into list.
+	 */
+	write_lock_bh(&ipt_account_lock);
+	list_add(&table->list, &ipt_account_tables);
+	write_unlock_bh(&ipt_account_lock);
+=09
+	return table;
=20
-/* convert ascii to 64bit integer */
-int atoi64(char *buffer, u_int64_t *i) {=09
-	char *bufferptr =3D buffer;
-
-	/* zero integer */
-	*i =3D 0;
+	/*
+	 * If something goes wrong we end here.
+	 */
+cleanup_stats:
+	if (table->shortlisting)
+		vfree(table->stats.s);
+	else
+		vfree(table->stats.l);
 =09
-	while (isdigit(*bufferptr)) {
-		*i =3D *i * 10 + (*bufferptr - '0');
-		bufferptr++;
-	}
-	return (bufferptr - buffer);
+cleanup_table:
+	vfree(table);
+cleanup_none:
+	return NULL;
+=09
 }
=20
-static void *account_seq_start(struct seq_file *s, loff_t *pos)
+/*
+ * Function destroys table. Table *must* be already unlinked.
+ */
+static void
+ipt_account_table_destroy(struct t_ipt_account_table *table)
 {
-	struct proc_dir_entry *pde =3D s->private;
-	struct t_ipt_account_table *table =3D pde->data;
-
-	unsigned int *bucket;
+	dprintk(KERN_DEBUG "ipt_account [ipt_account_table_destory]: name =3D %s\=
n", table->name);
 =09
-	spin_lock_bh(&table->ip_list_lock);
-	if (*pos >=3D table->count)
-		return NULL;
-
-	bucket =3D kmalloc(sizeof(unsigned int), GFP_KERNEL);
-	if (!bucket)
-		return ERR_PTR(-ENOMEM);
-	*bucket =3D *pos;
-	return bucket;
+	remove_proc_entry(table->pde->name, table->pde->parent);
+	if (table->shortlisting)
+		vfree(table->stats.s);
+	else
+		vfree(table->stats.l);
+	vfree(table);
 }
=20
-static void *account_seq_next(struct seq_file *s, void *v, loff_t *pos)
+/*
+ * Function increments use counter for table.
+ */
+static inline void
+ipt_account_table_get(struct t_ipt_account_table *table)=20
 {
-	struct proc_dir_entry *pde =3D s->private;
-	struct t_ipt_account_table *table =3D pde->data;
+	dprintk(KERN_DEBUG "ipt_account [ipt_account_table_get]: name =3D %s\n", =
table->name);
 =09
-	unsigned int *bucket =3D (unsigned int *)v;
-=09
-	*pos =3D ++(*bucket);
-	if (*pos >=3D table->count) {
-		kfree(v);
-		return NULL;
-	}
-	return bucket;
+	atomic_inc(&table->use);
 }
=20
-static void account_seq_stop(struct seq_file *s, void *v)
+/*
+ * Function decrements use counter for table. If use counter drops to zero,
+ * table is removed from linked list and destroyed.
+ */
+static inline void
+ipt_account_table_put(struct t_ipt_account_table *table)=20
 {
-	struct proc_dir_entry *pde =3D s->private;
-	struct t_ipt_account_table *table =3D pde->data;
-	unsigned int *bucket =3D (unsigned int *)v;
-	kfree(bucket);
-	spin_unlock_bh(&table->ip_list_lock);
-}
-
-static int account_seq_write(struct file *file, const char *ubuffer,=20
-		size_t ulength, loff_t *pos)
-{
-	struct proc_dir_entry *pde =3D ((struct seq_file *)file->private_data)->p=
rivate;
-	struct t_ipt_account_table *table =3D pde->data;
-	char buffer[1024], *bufferptr;
-	int length;
-
-	u_int32_t ip;
-	int len, i;
-	struct t_ipt_account_ip_list l;
-	struct t_ipt_account_ip_list_short s;
-	u_int64_t *p, dummy;
+	dprintk(KERN_DEBUG "ipt_account [ipt_account_table_put]: name =3D %s\n", =
table->name);
 =09
-=09
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() entered.\n");
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() ulength =3D %zi=
=2E\n", ulength);
-=09
-	length =3D ulength;
-	if (ulength > 1024)
-		length =3D 1024;
-	if (copy_from_user(buffer, ubuffer, length))
-		return -EFAULT;
-	buffer[length - 1] =3D 0;
-	bufferptr =3D buffer;
-
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() buffer =3D \'%s=
\' length =3D %i.\n", buffer, length);
-=09
-	/* reset table counters */
-	if (!memcmp(buffer, "reset", 5)) {
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got \"reset\".=
\n");
-		if (!table->shortlisting) {
-			spin_lock_bh(&table->ip_list_lock);
-			memset(table->ip_list.l, 0, sizeof(struct t_ipt_account_ip_list) * tabl=
e->count);
-			spin_unlock_bh(&table->ip_list_lock);
-		} else {
-			spin_lock_bh(&table->ip_list_lock);
-			memset(table->ip_list.s, 0, sizeof(struct t_ipt_account_ip_list_short) =
* table->count);
-			spin_unlock_bh(&table->ip_list_lock);
-		}
-		return length;
+	if (atomic_dec_and_test(&table->use)) {
+		write_lock_bh(&ipt_account_lock);
+		list_del(&table->list);
+		write_unlock_bh(&ipt_account_lock);
+		ipt_account_table_destroy(table);
 	}
-
-	if (!memcmp(buffer, "ip", 2)) {
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got \"ip\".\n"=
);
-		bufferptr +=3D 2;
-		if (!isspace(*bufferptr)) {
-			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected spac=
e (%ti).\n", bufferptr - buffer);
-			return length; /* expected space */
-		}
-		bufferptr +=3D 1;
-		if (*bufferptr !=3D '=3D') {
-			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected equa=
l (%ti).\n", bufferptr - buffer);
-			return length; /* expected equal */
-		}
-		bufferptr +=3D 1;
-		if (!isspace(*bufferptr)) {
-			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected spac=
e (%ti).\n", bufferptr - buffer);
-			return length; /* expected space */
-		}
-		bufferptr +=3D 1;
-		if (!(len =3D atoip(bufferptr, &ip))) {
-			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected ip (=
%ti).\n", bufferptr - buffer);
-			return length; /* expected ip */
-		}
-		bufferptr +=3D len;
-		if ((ip & table->netmask) !=3D table->network) {
-			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected ip [=
%u.%u.%u.%u] from table's network/netmask [%u.%u.%u.%u/%u.%u.%u.%u].\n", HI=
PQUAD(ip), HIPQUAD(table->network), HIPQUAD(table->netmask));
-			return length; /* expected ip from table's network/netmask */
-		}
-		if (!table->shortlisting) {
-			memset(&l, 0, sizeof(struct t_ipt_account_ip_list));
-			while(*bufferptr) {
-				if (!isspace(*bufferptr)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected sp=
ace (%ti).\n", bufferptr - buffer);
-					return length; /* expected space */
-				}
-				bufferptr +=3D 1;
-				if (!memcmp(bufferptr, "bytes_src", 9)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got bytes_s=
rc (%ti).\n", bufferptr - buffer);
-					p =3D &l.src.b_all;
-					bufferptr +=3D 9;
-				} else if (!memcmp(bufferptr, "bytes_dest", 10)) {				=09
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got bytes_d=
est (%ti).\n", bufferptr - buffer);
-					p =3D &l.dest.b_all;
-					bufferptr +=3D 10;
-				} else if (!memcmp(bufferptr, "packets_src", 11)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got packets=
_src (%ti).\n", bufferptr - buffer);
-					p =3D &l.src.p_all;
-					bufferptr +=3D 11;
-				} else if (!memcmp(bufferptr, "packets_dest", 12)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got packets=
_dest (%ti).\n", bufferptr - buffer);
-					p =3D &l.dest.p_all;
-					bufferptr +=3D 12;
-				} else if (!memcmp(bufferptr, "time", 4)) {
-					/* time hack, ignore time tokens */
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got time (%=
ti).\n", bufferptr - buffer);
-					bufferptr +=3D 4;
-					if (!isspace(*bufferptr)) {
-						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected s=
pace (%ti).\n", bufferptr - buffer);
-						return length; /* expected space */
-					}
-					bufferptr +=3D 1;
-					if (*bufferptr !=3D '=3D') {
-						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected e=
qual (%ti).\n", bufferptr - buffer);
-						return length; /* expected equal */
-					}
-					bufferptr +=3D 1;
-					if (!isspace(*bufferptr)) {
-						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected s=
pace (%ti).\n", bufferptr - buffer);
-						return length; /* expected space */
-					}
-					bufferptr +=3D 1;
-					if (!(len =3D atoi64(bufferptr, &dummy))) {
-						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected i=
nt64 (%ti).\n", bufferptr - buffer);
-						return length; /* expected int64 */
-					}
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got %llu (%=
ti).\n", dummy, bufferptr - buffer);
-					bufferptr +=3D len;
-					continue; /* skip time token */
-				} else
-					return length;	/* expected token */
-				if (!isspace(*bufferptr)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected sp=
ace (%ti).\n", bufferptr - buffer);
-					return length; /* expected space */
-				}
-				bufferptr +=3D 1;
-				if (*bufferptr !=3D '=3D') {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected eq=
ual (%ti).\n", bufferptr - buffer);
-					return length; /* expected equal */
-				}
-				bufferptr +=3D 1;
-				for (i =3D 0; i < 5; i++) {
-					if (!isspace(*bufferptr)) {
-						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected s=
pace (%ti).\n", bufferptr - buffer);
-						return length; /* expected space */
-					}
-					bufferptr +=3D 1;
-					if (!(len =3D atoi64(bufferptr, p))) {
-						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected i=
nt64 (%ti).\n", bufferptr - buffer);
-						return length; /* expected int64 */
-					}
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got %llu (%=
ti).\n", *p, bufferptr - buffer);
-					bufferptr +=3D len;
-					p++;
-				}
-			}
-			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() updating row.=
\n");
-			spin_lock_bh(&table->ip_list_lock);
-			/* update counters, do not overwrite time field */
-			memcpy(&table->ip_list.l[ip - table->network], &l, sizeof(struct t_ipt_=
account_ip_list) - sizeof(unsigned long));
-			spin_unlock_bh(&table->ip_list_lock);
-		} else {
-			memset(&s, 0, sizeof(struct t_ipt_account_ip_list_short));
-			while(*bufferptr) {
-				if (!isspace(*bufferptr)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected sp=
ace (%ti).\n", bufferptr - buffer);
-					return length; /* expected space */
-				}
-				bufferptr +=3D 1;
-				if (!memcmp(bufferptr, "bytes_src", 9)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got bytes_s=
rc (%ti).\n", bufferptr - buffer);
-					p =3D &s.src.b_all;
-					bufferptr +=3D 9;
-				} else if (!memcmp(bufferptr, "bytes_dest", 10)) {				=09
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got bytes_d=
est (%ti).\n", bufferptr - buffer);
-					p =3D &s.dest.b_all;
-					bufferptr +=3D 10;
-				} else if (!memcmp(bufferptr, "packets_src", 11)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got packets=
_src (%ti).\n", bufferptr - buffer);
-					p =3D &s.src.p_all;
-					bufferptr +=3D 11;
-				} else if (!memcmp(bufferptr, "packets_dest", 12)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got packets=
_dest (%ti).\n", bufferptr - buffer);
-					p =3D &s.dest.p_all;
-					bufferptr +=3D 12;
-				} else if (!memcmp(bufferptr, "time", 4)) {
-					/* time hack, ignore time tokens */
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got time (%=
ti).\n", bufferptr - buffer);
-					bufferptr +=3D 4;
-					if (!isspace(*bufferptr)) {
-						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected s=
pace (%ti).\n", bufferptr - buffer);
-						return length; /* expected space */
-					}
-					bufferptr +=3D 1;
-					if (*bufferptr !=3D '=3D') {
-						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected e=
qual (%ti).\n", bufferptr - buffer);
-						return length; /* expected equal */
-					}
-					bufferptr +=3D 1;
-					if (!isspace(*bufferptr)) {
-						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected s=
pace (%ti).\n", bufferptr - buffer);
-						return length; /* expected space */
-					}
-					bufferptr +=3D 1;
-					if (!(len =3D atoi64(bufferptr, &dummy))) {
-						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected i=
nt64 (%ti).\n", bufferptr - buffer);
-						return length; /* expected int64 */
-					}
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got %llu (%=
ti).\n", dummy, bufferptr - buffer);
-					bufferptr +=3D len;
-					continue; /* skip time token */
-				} else {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected to=
ken (%ti).\n", bufferptr - buffer);
-					return length;	/* expected token */
-				}
-				if (!isspace(*bufferptr)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected sp=
ace (%ti).\n", bufferptr - buffer);
-					return length; /* expected space */
-				}
-				bufferptr +=3D 1;
-				if (*bufferptr !=3D '=3D') {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected eq=
ual (%ti).\n", bufferptr - buffer);
-					return length; /* expected equal */
-				}
-				bufferptr +=3D 1;
-				if (!isspace(*bufferptr)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected sp=
ace (%ti).\n", bufferptr - buffer);
-					return length; /* expected space */
-				}
-				bufferptr +=3D 1;
-				if (!(len =3D atoi64(bufferptr, p))) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected in=
t64 (%ti).\n", bufferptr - buffer);
-					return length; /* expected int64 */
-				}
-				dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got %llu (%t=
i).\n", *p, bufferptr - buffer);
-				bufferptr +=3D len;
-			}
-			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() updating row.=
\n");
-			spin_lock_bh(&table->ip_list_lock);
-			/* update counters, do not overwrite time field */
-			memcpy(&table->ip_list.s[ip - table->network], &s, sizeof(struct t_ipt_=
account_ip_list_short) - sizeof(unsigned long));
-			spin_unlock_bh(&table->ip_list_lock);
-		}
-	}
-=09
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() left.\n");
-	return length;
 }
=20
-
-static int account_seq_show(struct seq_file *s, void *v)
+/*
+ * Helper function, which returns a structure pointer to a table with
+ * specified name.
+ */
+static struct t_ipt_account_table *
+__ipt_account_table_find(char *name)=20
 {
-	struct proc_dir_entry *pde =3D s->private;
-	struct t_ipt_account_table *table =3D pde->data;
-	unsigned int *bucket =3D (unsigned int *)v;
-
-	u_int32_t address =3D table->network + *bucket;
-	struct timespec last;
-
-	if (!table->shortlisting) {
-		jiffies_to_timespec(jiffies - table->ip_list.l[*bucket].time, &last);
-		seq_printf(s,
-				"ip =3D %u.%u.%u.%u bytes_src =3D %llu %llu %llu %llu %llu packets_src=
 =3D %llu %llu %llu %llu %llu bytes_dest =3D %llu %llu %llu %llu %llu packe=
ts_dest =3D %llu %llu %llu %llu %llu time =3D %lu\n",
-				HIPQUAD(address),
-				table->ip_list.l[*bucket].src.b_all,
-				table->ip_list.l[*bucket].src.b_tcp,
-				table->ip_list.l[*bucket].src.b_udp,
-				table->ip_list.l[*bucket].src.b_icmp,
-				table->ip_list.l[*bucket].src.b_other,
-				table->ip_list.l[*bucket].src.p_all,
-				table->ip_list.l[*bucket].src.p_tcp,
-				table->ip_list.l[*bucket].src.p_udp,
-				table->ip_list.l[*bucket].src.p_icmp,
-				table->ip_list.l[*bucket].src.p_other,
-				table->ip_list.l[*bucket].dest.b_all,
-				table->ip_list.l[*bucket].dest.b_tcp,
-				table->ip_list.l[*bucket].dest.b_udp,
-				table->ip_list.l[*bucket].dest.b_icmp,
-				table->ip_list.l[*bucket].dest.b_other,			=09
-				table->ip_list.l[*bucket].dest.p_all,
-				table->ip_list.l[*bucket].dest.p_tcp,
-				table->ip_list.l[*bucket].dest.p_udp,
-				table->ip_list.l[*bucket].dest.p_icmp,
-				table->ip_list.l[*bucket].dest.p_other,
-				last.tv_sec
-			);
-	} else {
-		jiffies_to_timespec(jiffies - table->ip_list.s[*bucket].time, &last);
-		seq_printf(s,
-				"ip =3D %u.%u.%u.%u bytes_src =3D %llu packets_src =3D %llu bytes_dest=
 =3D %llu packets_dest =3D %llu time =3D %lu\n",
-				HIPQUAD(address),
-				table->ip_list.s[*bucket].src.b_all,
-				table->ip_list.s[*bucket].src.p_all,
-				table->ip_list.s[*bucket].dest.b_all,
-				table->ip_list.s[*bucket].dest.p_all,
-				last.tv_sec
-			  );
+	struct list_head *pos;
+	list_for_each(pos, &ipt_account_tables) {
+		struct t_ipt_account_table *table =3D list_entry(pos,
+				struct t_ipt_account_table, list);
+		if (!strncmp(table->name, name, IPT_ACCOUNT_NAME_LEN))
+			return table;
 	}
-	return 0;
+	return NULL;
 }
=20
-static struct seq_operations account_seq_ops =3D {
-	.start =3D account_seq_start,
-	.next  =3D account_seq_next,
-	.stop  =3D account_seq_stop,
-	.show  =3D account_seq_show
-};
-
-static int account_seq_open(struct inode *inode, struct file *file)
+/*
+ * Function, which returns a structure pointer to a table with
+ * specified name. When such table is found its use coutner
+ * is incremented.
+ */
+static inline struct t_ipt_account_table *
+ipt_account_table_find_get(char *name)=20
 {
-	int ret =3D seq_open(file, &account_seq_ops);
+	struct t_ipt_account_table *table;
 =09
-	if (!ret) {
-		struct seq_file *sf =3D file->private_data;
-		sf->private =3D PDE(inode);
+        dprintk(KERN_DEBUG "ipt_account [ipt_account_table_find_get]: name=
 =3D %s\n", name);
+=09
+	read_lock_bh(&ipt_account_lock);
+	table =3D __ipt_account_table_find(name);
+	if (!table) {
+		read_unlock_bh(&ipt_account_lock);
+		return NULL;
 	}
-	return ret;
-}
+	atomic_inc(&table->use);
+	read_unlock_bh(&ipt_account_lock);
+	return table;
+}=09
=20
-static struct file_operations account_file_ops =3D {
-	.owner =3D THIS_MODULE,
-	.open =3D account_seq_open,
-	.read =3D seq_read,
-	.write =3D account_seq_write,
-	.llseek =3D seq_lseek,
-	.release =3D seq_release
-};
-
-/* do raw accounting */
-static inline void do_account(struct t_ipt_account_stat *stat, const struc=
t sk_buff *skb) {
-=09
-	/* update packet & bytes counters in *stat structure */
+/*
+ * Helper function, with updates statistics for specified IP. It's only
+ * used for tables created without --ashort switch.
+ */
+static inline void
+__account_long(struct t_ipt_account_stat_long *stat, const struct sk_buff =
*skb)=20
+{
 	stat->b_all +=3D skb->len;
 	stat->p_all++;
 =09
@@ -550,386 +299,464 @@
 	}
 }
=20
-static inline void do_account_short(struct t_ipt_account_stat_short *stat,=
 const struct sk_buff *skb) {
-
-	/* update packet & bytes counters in *stat structure */
+/*
+ * Same as above, but used for tables created with --ashort switch.
+ */
+static inline void
+__account_short(struct t_ipt_account_stat_short *stat, const struct sk_buf=
f *skb)
+{
 	stat->b_all +=3D skb->len;
 	stat->p_all++;
 }
=20
-static int match(const struct sk_buff *skb,
-	  const struct net_device *in,
-	  const struct net_device *out,
-	  const void *matchinfo,
-	  int offset,
-	  int *hotdrop)
+/*
+ * Match function. Here we do accounting stuff.
+ */
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+			unsigned int protoff,
+      int *hotdrop)
 {
-=09
-	const struct t_ipt_account_info *info =3D (struct t_ipt_account_info*)mat=
chinfo;
-	struct t_ipt_account_table *table;
-	int ret;
-	unsigned long now;
+	struct t_ipt_account_info *info =3D (struct t_ipt_account_info *)matchinf=
o;
+	struct t_ipt_account_table *table =3D info->table;
+	u_int32_t address;=09
+	/* Get current time. */
+	struct timespec now =3D CURRENT_TIME_SEC;
+	/* Default we assume no match. */
+	int ret =3D 0;
+	=09
+	dprintk(KERN_DEBUG "ipt_account [match]: name =3D %s\n", table->name);
=20
-	u_int32_t address;
-=09
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() entered.\n");
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() match name =3D %s.\n", info=
->name);
-=09
-	spin_lock_bh(&account_lock);
-	/* find the right table */
-	table =3D account_tables;
-	while (table && strncmp(table->name, info->name, IPT_ACCOUNT_NAME_LEN) &&=
 (table =3D table->next));
-	spin_unlock_bh(&account_lock);
-
-	if (table =3D=3D NULL) {
-		/* ups, no table with that name */
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() table %s not found. Leavin=
g.\n", info->name);
-		return 0;
-	}
-
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() table found %s\n", table->n=
ame);
-
-	/*  lock table while updating statistics */
-	spin_lock_bh(&table->ip_list_lock);
-
-	/* default: no match */
-	ret =3D 0;
-
-	/* get current time */
-	now =3D jiffies;
-
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() got packet src =3D %u.%u.%u=
=2E%u, dst =3D %u.%u.%u.%u, proto =3D %u.\n", NIPQUAD(skb->nh.iph->saddr), =
NIPQUAD(skb->nh.iph->daddr), skb->nh.iph->protocol);
-		=09
-	/* check whether traffic from source ip address ... */
+	/* Check whether traffic from source ip address ... */
 	address =3D ntohl(skb->nh.iph->saddr);
-	/* ... is being accounted by this table */=09
+	/* ... is being accounted by this table. */=09
 	if (address && ((u_int32_t)(address & table->netmask) =3D=3D (u_int32_t)t=
able->network)) {	=09
-		/* yes, account this packet */
-		dprintk(KERN_INFO "ipt_account: match() accounting packet src =3D %u.%u.=
%u.%u, proto =3D %u.\n", HIPQUAD(address), skb->nh.iph->protocol);
-		/* update counters this host */
+		write_lock_bh(&table->stats_lock);
+		/* Yes, account this packet. */
+		dprintk(KERN_DEBUG "ipt_account: [match]: accounting packet src =3D %u.%=
u.%u.%u, proto =3D %u.\n", HIPQUAD(address), skb->nh.iph->protocol);
+		/* Update counters this host. */
 		if (!table->shortlisting) {
-			do_account(&table->ip_list.l[address - table->network].src, skb);
-			table->ip_list.l[address - table->network].time =3D now;
-			/* update also counters for all hosts in this table (network address) */
-			if (table->netmask !=3D INADDR_BROADCAST) {
-				do_account(&table->ip_list.l[0].src, skb);
-				table->ip_list.l[0].time =3D now;
+			__account_long(&table->stats.l[address - table->network].src, skb);
+			table->stats.l[address - table->network].time =3D now;
+			/* Update also counters for all hosts in this table (network address) */
+			if (table->count > 1) {
+				__account_long(&table->stats.l[0].src, skb);
+				table->stats.l[0].time =3D now;
 			}
 		} else {
-			do_account_short(&table->ip_list.s[address - table->network].src, skb);
-			table->ip_list.s[address - table->network].time =3D now;
-			/* update also counters for all hosts in this table (network address) */
-			if (table->netmask !=3D INADDR_BROADCAST) {
-				do_account_short(&table->ip_list.s[0].src, skb);
-				table->ip_list.s[0].time =3D now;
+			__account_short(&table->stats.s[address - table->network].src, skb);
+			table->stats.s[address - table->network].time =3D now;
+			if (table->count > 1) {
+				__account_short(&table->stats.s[0].src, skb);
+				table->stats.s[0].time =3D now;
 			}
 		}
-		/* yes, it's a match */
+		write_unlock_bh(&table->stats_lock);
+		/* Yes, it's a match. */
 		ret =3D 1;
 	}
-
-	/* do the same thing with destination ip address */
+=09
+	/* Do the same thing with destination ip address. */
 	address =3D ntohl(skb->nh.iph->daddr);
 	if (address && ((u_int32_t)(address & table->netmask) =3D=3D (u_int32_t)t=
able->network)) {
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() accounting packet dst =3D =
%u.%u.%u.%u, proto =3D %u.\n", HIPQUAD(address), skb->nh.iph->protocol);
+		write_lock_bh(&table->stats_lock);
+		dprintk(KERN_DEBUG "ipt_account: [match]: accounting packet dst =3D %u.%=
u.%u.%u, proto =3D %u.\n", HIPQUAD(address), skb->nh.iph->protocol);
 		if (!table->shortlisting) {
-			do_account(&table->ip_list.l[address - table->network].dest, skb);
-			table->ip_list.l[address - table->network].time =3D now;
-			if (table->netmask !=3D INADDR_BROADCAST) {
-				do_account(&table->ip_list.l[0].dest, skb);			=09
-				table->ip_list.s[0].time =3D now;
+			__account_long(&table->stats.l[address - table->network].dst, skb);
+			table->stats.l[address - table->network].time =3D now;
+			if (table->count > 1) {
+				__account_long(&table->stats.l[0].dst, skb);
+				table->stats.l[0].time =3D now;
 			}
 		} else {
-			do_account_short(&table->ip_list.s[address - table->network].dest, skb);
-			table->ip_list.s[address - table->network].time =3D now;
-			if (table->netmask !=3D INADDR_BROADCAST) {
-				do_account_short(&table->ip_list.s[0].dest, skb);
-				table->ip_list.s[0].time =3D now;
+			__account_short(&table->stats.s[address - table->network].dst, skb);
+			table->stats.s[address - table->network].time =3D now;
+			if (table->count > 1) {
+				__account_short(&table->stats.s[0].dst, skb);
+				table->stats.s[0].time =3D now;
 			}
 		}
+		write_unlock_bh(&table->stats_lock);
 		ret =3D 1;
 	}
-	spin_unlock_bh(&table->ip_list_lock);
 =09
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() left.\n");=09
-
 	return ret;
 }
=20
-static int checkentry(const char *tablename,
-	       const struct ipt_ip *ip,
-	       void *matchinfo,
-	       unsigned int matchinfosize,
-	       unsigned int hook_mask)
+/*
+ * Checkentry function.
+ */
+static int
+checkentry(const char *tablename,
+	   const void *ip,
+	   void *matchinfo,
+	   unsigned int matchsize,
+	   unsigned int hook_mask)
 {
-	const struct t_ipt_account_info *info =3D matchinfo;
-	struct t_ipt_account_table *table, *find_table, *last_table;
-	int ret =3D 0;
+	struct t_ipt_account_info *info =3D matchinfo;
+	struct t_ipt_account_table *table;
=20
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() entered.\n");
+	dprintk(KERN_DEBUG "ipt_account [checkentry]: name =3D %s\n", info->name);
+=09
+	if (matchsize !=3D IPT_ALIGN(sizeof(struct t_ipt_account_info)))
+		return 0;
=20
-	if (matchinfosize !=3D IPT_ALIGN(sizeof(struct t_ipt_account_info))) retu=
rn 0;
-	if (!info->name || !info->name[0]) return 0;
-
-	/* find whether table with this name already exists */
-	spin_lock_bh(&account_lock);
-	find_table =3D account_tables;
-	while( (last_table =3D find_table) && strncmp(info->name,find_table->name=
,IPT_ACCOUNT_NAME_LEN) && (find_table =3D find_table->next) );
-	if (find_table !=3D NULL) {
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() table %s found.\n", i=
nfo->name);	=09
-		/* if table exists, check whether table network/netmask equals rule netw=
ork/netmask */
-		if (find_table->network !=3D info->network || find_table->netmask !=3D i=
nfo->netmask || find_table->shortlisting !=3D info->shortlisting) {
-			spin_unlock_bh(&account_lock);
-			printk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() wrong parameters (not=
 equals existing table parameters).\n");
-			ret =3D 0;
-			goto failure;
-		}
-		/* increment table use count */
-		find_table->use_count++;
-		spin_unlock_bh(&account_lock);
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() incrementing use coun=
t.\n");
-		ret =3D 1;
-		goto failure;
+	/*=20
+	 * Sanity checks.=20
+	 */
+	if (info->netmask < ((~0L << (32 - netmask)) & 0xffffffff)) {
+		printk(KERN_ERR "ipt_account[checkentry]: too big netmask (increase modu=
le 'netmask' parameter).\n");
+		return 0;
 	}
-	spin_unlock_bh(&account_lock);
-
-	/* check netmask first, before allocating memory */
-	if (info->netmask < ((1 << netmask) - 1)) {
-		printk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() too big netmask.\n");
-		ret =3D 0;
-		goto failure;
+	if ((info->network & info->netmask) !=3D info->network) {
+		printk(KERN_ERR "ipt_account[checkentry]: wrong network/netmask.\n");
+		return 0;
 	}
+	if (info->name[0] =3D=3D '\0') {
+		printk(KERN_ERR "ipt_account[checkentry]: wrong table name.\n");
+		return 0;
+	}
=20
-	/* table doesn't exist - create new */
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() allocating %zu for new=
 table %s.\n", sizeof(struct t_ipt_account_table), info->name);
-        table =3D vmalloc(sizeof(struct t_ipt_account_table));
-	if (table =3D=3D NULL) {
-		printk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() failed to allocate %zu=
 for new table %s.\n", sizeof(struct t_ipt_account_table), info->name);
-		ret =3D 0;
-		goto failure;
+	/*
+	 * Avoid searching list for already seen and added rules.
+	 * Simply increase use count and exit.
+	 */
+	if (info->table) {
+		ipt_account_table_get(info->table);
+		return 1;
 	}
 =09
-	/* setup table parameters */
-	table->ip_list_lock =3D SPIN_LOCK_UNLOCKED;
-	table->next =3D NULL;
-	table->use_count =3D 1;
-	table->network =3D info->network;
-	table->netmask =3D info->netmask;
-	table->shortlisting =3D info->shortlisting;
-	table->count =3D (~table->netmask) + 1;
-	strncpy(table->name,info->name,IPT_ACCOUNT_NAME_LEN);
-	table->name[IPT_ACCOUNT_NAME_LEN - 1] =3D '\0';
-=09
-	/* allocate memory for table->ip_list */
-	if (!table->shortlisting) {
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() allocating %zu for ip=
_list.\n", sizeof(struct t_ipt_account_ip_list) * table->count);
-		table->ip_list.l =3D vmalloc(sizeof(struct t_ipt_account_ip_list) * tabl=
e->count);
-		if (table->ip_list.l =3D=3D NULL) {
-			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() failed to allocate %=
zu for ip_list.\n", sizeof(struct t_ipt_account_ip_list) * table->count);
-			ret =3D 0;
-			goto failure_table;
+	/*
+	 * We got new rule. Try to find table with the same name as given in info=
 structure.
+	 */
+	table =3D ipt_account_table_find_get(info->name);
+	if (!table) {
+		dprintk(KERN_DEBUG "ipt_account [checkentry]: table not found, creating =
new one.\n");
+		/*
+		 * Table not exist, create new one.
+		 */
+		table =3D ipt_account_table_init(info);
+		if (!table) {
+			return 0;
 		}
-		memset(table->ip_list.l, 0, sizeof(struct t_ipt_account_ip_list) * table=
->count);
 	} else {
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() allocating %zu for ip=
_list.\n", sizeof(struct t_ipt_account_ip_list_short) * table->count);
-		table->ip_list.s =3D vmalloc(sizeof(struct t_ipt_account_ip_list_short) =
* table->count);
-		if (table->ip_list.s =3D=3D NULL) {
-			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() failed to allocate %=
zu for ip_list.\n", sizeof(struct t_ipt_account_ip_list_short) * table->cou=
nt);
-			ret =3D 0;
-			goto failure_table;
+		dprintk(KERN_DEBUG "ipt_account [checkentry]: table found, checking.\n");
+		/*=20
+		 * Table exists, but whether rule network/netmask/shortlisting matches=
=20
+		 * table network/netmask/shortlisting. Failure on missmatch.=20
+		 */	=09
+		if (table->network !=3D info->network || table->netmask !=3D info->netma=
sk || table->shortlisting !=3D info->shortlisting) {
+			printk(KERN_ERR "ipt_account [checkentry]: table found, rule network/ne=
tmask/shortlisting not match table network/netmask/shortlisting.\n");
+			/*
+			 * Remember to release table usage counter.
+			 */
+			ipt_account_table_put(table);
+			return 0;
 		}
-		memset(table->ip_list.s, 0, sizeof(struct t_ipt_account_ip_list_short) *=
 table->count);
+		dprintk(KERN_DEBUG "ipt_account [checkentry]: table found, reusing.\n");
 	}
+	/*
+	 * Link rule with table.
+	 */
+	info->table =3D table;
+	return 1;
+}
+
+/*
+ * Destroy function.
+ */
+static void
+destroy(void *matchinfo, unsigned int matchsize)
+{
+	struct t_ipt_account_info *info =3D matchinfo;
 =09
-	/* put table into chain */
-	spin_lock_bh(&account_lock);
-	find_table =3D account_tables;
-	while( (last_table =3D find_table) && strncmp(info->name, find_table->nam=
e, IPT_ACCOUNT_NAME_LEN) && (find_table =3D find_table->next) );
-	if (find_table !=3D NULL) {
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() table %s found.\n", i=
nfo->name);
-		if (find_table->network !=3D info->network || find_table->netmask !=3D i=
nfo->netmask) {
-			spin_unlock_bh(&account_lock);
-			printk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() wrong network/netmask=
=2E\n");
-			ret =3D 0;
-			goto failure_ip_list;
-		}
-		find_table->use_count++;
-		spin_unlock_bh(&account_lock);
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() incrementing use coun=
t.\n");
-		ret =3D 1;
-		goto failure_ip_list;
-	}
-	if (!last_table)=20
-		account_tables =3D table;=20
-	else=20
-		last_table->next =3D table;
-	spin_unlock_bh(&account_lock);
+	dprintk(KERN_DEBUG "ipt_account [destroy]: name =3D %s\n", info->name);
=20
-	/* create procfs status file */
-	table->status_file =3D create_proc_entry(table->name, permissions, proc_n=
et_ipt_account);
-	if (table->status_file =3D=3D NULL) {
-		ret =3D 0;
-		goto failure_unlink;
-	}
-	table->status_file->owner =3D THIS_MODULE;
-	table->status_file->data =3D table;=09
-	wmb();
-	table->status_file->proc_fops =3D &account_file_ops;
+	/*
+	 * Release table, by decreasing its usage counter. When
+	 * counter hits zero, memory used by table structure is
+	 * released and table is removed from list.
+	 */
+	ipt_account_table_put(info->table);
+	return;
+}
=20
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() left.\n");=09
-	/* everything went just okey */
-	return 1;
+static struct ipt_match account_match =3D {=20
+  .name =3D "account",=20
+  .match =3D &match,=20
+  .checkentry =3D &checkentry,=20
+  .destroy =3D &destroy,=20
+  .me =3D THIS_MODULE
+};
=20
-	/* do cleanup in case of failure */
-failure_unlink:
-	/* remove table from list */
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() removing table.\n");
-	spin_lock_bh(&account_lock);
-	last_table =3D NULL;
-	table =3D account_tables;
-	if (table =3D=3D NULL) {
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() no table found. Leavi=
ng.\n");
-		spin_unlock_bh(&account_lock);
-		return 0;
+/*
+ * Below functions (ipt_account_seq_start, ipt_account_seq_next,=20
+ * ipt_account_seq_stop, ipt_account_seq_show, ipt_account_proc_write)=20
+ * are used to implement proc stuff.
+ */
+static void *ipt_account_seq_start(struct seq_file *sf, loff_t *pos)
+{
+	struct proc_dir_entry *pde =3D sf->private;
+	struct t_ipt_account_table *table =3D pde->data;
+	unsigned int *i;
+
+	read_lock_bh(&table->stats_lock);
+	if (*pos >=3D table->count)
+		return NULL;
+	i =3D kmalloc(sizeof(unsigned int), GFP_ATOMIC);
+	if (!i)
+		return ERR_PTR(-ENOMEM);
+	*i =3D *pos;
+	return i;
+}
+
+static void *ipt_account_seq_next(struct seq_file *sf, void *v, loff_t *po=
s)
+{
+	struct proc_dir_entry *pde =3D sf->private;
+	struct t_ipt_account_table *table =3D pde->data;
+	unsigned int *i =3D (unsigned int *)v;
+
+	*pos =3D ++(*i);
+	if (*i >=3D table->count) {
+		kfree(v);
+		return NULL;
 	}
-	while (strncmp(info->name, table->name, IPT_ACCOUNT_NAME_LEN) && (last_ta=
ble =3D table) && (table =3D table->next));
-	if (table =3D=3D NULL) {
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() table already destroy=
ed. Leaving.\n");
-		spin_unlock_bh(&account_lock);
-		return 0;
-	}
-	if (last_table)
-		last_table->next =3D table->next;
-	else
-		account_tables =3D table->next;
-	spin_unlock_bh(&account_lock);
-failure_ip_list:
-	/* free memory allocated for statistics table */
-	if (!table->shortlisting)
-		vfree(table->ip_list.l);
-	else
-		vfree(table->ip_list.s);
-failure_table:
-	/* free table */
-	vfree(table);
-failure:
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() left. Table not create=
d.\n");=09
-	/* failure return */
-	return ret;
+	return i;
 }
=20
-static void destroy(void *matchinfo,=20
-	     unsigned int matchinfosize)
+static void ipt_account_seq_stop(struct seq_file *sf, void *v)
 {
-	const struct t_ipt_account_info *info =3D matchinfo;
-	struct t_ipt_account_table *table, *last_table;
+	struct proc_dir_entry *pde =3D sf->private;
+	struct t_ipt_account_table *table =3D pde->data;
+	kfree(v);
+	read_unlock_bh(&table->stats_lock);
+}
=20
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": destory() entered.\n");
+static int ipt_account_seq_show(struct seq_file *sf, void *v)
+{
+	struct proc_dir_entry *pde =3D sf->private;
+	struct t_ipt_account_table *table =3D pde->data;
+	unsigned int *i =3D (unsigned int *)v;
 =09
-	if (matchinfosize !=3D IPT_ALIGN(sizeof(struct t_ipt_account_info))) retu=
rn;
+	struct timespec now =3D CURRENT_TIME_SEC;
+=09
+	u_int32_t address =3D table->network + *i;
=20
-	/* search for table */
-	spin_lock_bh(&account_lock);
-	last_table =3D NULL;
-	table =3D account_tables;
-	if(table =3D=3D NULL) {
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": destory() no tables found. Leaving=
=2E\n");
-		spin_unlock_bh(&account_lock);
-		return;
+	if (!table->shortlisting) {
+		struct t_ipt_account_stats_long *l =3D &table->stats.l[*i];
+		seq_printf(sf,
+				"ip =3D %u.%u.%u.%u bytes_src =3D %llu %llu %llu %llu %llu packets_src=
 =3D %llu %llu %llu %llu %llu bytes_dst =3D %llu %llu %llu %llu %llu packet=
s_dst =3D %llu %llu %llu %llu %llu time =3D %lu\n",
+				HIPQUAD(address),
+				l->src.b_all,
+				l->src.b_tcp,
+				l->src.b_udp,
+				l->src.b_icmp,
+				l->src.b_other,
+				l->src.p_all,
+				l->src.p_tcp,
+				l->src.p_udp,
+				l->src.p_icmp,
+				l->src.p_other,
+				l->dst.b_all,
+				l->dst.b_tcp,
+				l->dst.b_udp,
+				l->dst.b_icmp,
+				l->dst.b_other,			=09
+				l->dst.p_all,
+				l->dst.p_tcp,
+				l->dst.p_udp,
+				l->dst.p_icmp,
+				l->dst.p_other,
+				now.tv_sec - l->time.tv_sec
+			);
+	} else {
+		struct t_ipt_account_stats_short *s =3D &table->stats.s[*i];
+		seq_printf(sf,
+				"ip =3D %u.%u.%u.%u bytes_src =3D %llu packets_src =3D %llu bytes_dst =
=3D %llu packets_dst =3D %llu time =3D %lu\n",
+				HIPQUAD(address),
+				s->src.b_all,
+				s->src.p_all,
+				s->dst.b_all,
+				s->dst.p_all,
+				now.tv_sec - s->time.tv_sec
+			);
 	}
-	while( strncmp(info->name,table->name,IPT_ACCOUNT_NAME_LEN) && (last_tabl=
e =3D table) && (table =3D table->next) );
-	if (table =3D=3D NULL) {
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": destory() no table %s not found. L=
eaving.\n", info->name);
-		spin_unlock_bh(&account_lock);
-		return;
-	}
=20
-	/* decrement table use-count */
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": destory() decrementing use count.\n=
");
-	table->use_count--;
-	if (table->use_count) {
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": destory() table still in use. Leav=
ing.\n");
-		spin_unlock_bh(&account_lock);
-		return;
+	return 0;
+}
+
+static struct seq_operations ipt_account_seq_ops =3D {
+	.start =3D ipt_account_seq_start,
+	.next =3D ipt_account_seq_next,
+	.stop =3D ipt_account_seq_stop,
+	.show =3D ipt_account_seq_show
+};
+
+static ssize_t ipt_account_proc_write(struct file *file, const char __user=
 *input, size_t size, loff_t *ofs)
+{
+	char buffer[1024];
+	struct proc_dir_entry *pde =3D PDE(file->f_dentry->d_inode);
+	struct t_ipt_account_table *table =3D pde->data;
+
+	u_int32_t o[4], ip;
+	struct t_ipt_account_stats_long l;
+	struct t_ipt_account_stats_short s;
+
+	dprintk(KERN_DEBUG "ipt_account [ipt_account_proc_write]: name =3D %s.\n"=
, table->name);
+
+	if (copy_from_user(buffer, input, 1024))
+		return -EFAULT;
+
+	if (!strncmp(buffer, "reset", 5)) {
+		/*
+		 * User requested to clear all table. Ignorant, does
+		 * he known how match time it took us to fill it? ;-)
+		 */
+		write_lock_bh(&table->stats_lock);
+		if (table->shortlisting)
+			memset(table->stats.s, 0, sizeof(struct t_ipt_account_stats_short) * ta=
ble->count);
+		else
+			memset(table->stats.l, 0, sizeof(struct t_ipt_account_stats_long) * tab=
le->count);
+		write_unlock_bh(&table->stats_lock);	=09
+	} else if (!table->shortlisting && sscanf(buffer, "ip =3D %u.%u.%u.%u byt=
es_src =3D %llu %llu %llu %llu %llu packets_src =3D %llu %llu %llu %llu %ll=
u bytes_dst =3D %llu %llu %llu %llu %llu packets_dst =3D %llu %llu %llu %ll=
u %llu time =3D %lu", 			=09
+				&o[0], &o[1], &o[2], &o[3],
+				&l.src.b_all, &l.src.b_tcp, &l.src.b_udp, &l.src.b_icmp, &l.src.b_othe=
r,
+				&l.src.p_all, &l.src.p_tcp, &l.src.p_udp, &l.src.p_icmp, &l.src.p_othe=
r,
+				&l.dst.b_all, &l.dst.b_tcp, &l.dst.b_udp, &l.dst.b_icmp, &l.dst.b_othe=
r,
+				&l.dst.p_all, &l.dst.p_tcp, &l.dst.p_udp, &l.dst.p_icmp, &l.dst.p_othe=
r,
+				&l.time.tv_sec) =3D=3D 25 ) {
+		/*
+		 * We got line formated like long listing row. We have to
+		 * check, if IP is accounted by table. If so, we
+		 * simply replace row with user's one.
+		 */
+		ip =3D o[0] << 24 | o[1] << 16 | o[2] << 8 | o[3];
+		if ((u_int32_t)(ip & table->netmask) =3D=3D (u_int32_t)table->network) {
+			/*
+			 * Ignore user input time. Set current time.
+			 */
+			l.time =3D CURRENT_TIME_SEC;
+			write_lock_bh(&table->stats_lock);
+			table->stats.l[ip - table->network] =3D l;
+			write_unlock_bh(&table->stats_lock);
+		}
+	} else if (table->shortlisting && sscanf(buffer, "ip =3D %u.%u.%u.%u byte=
s_src =3D %llu packets_src =3D %llu bytes_dst =3D %llu packets_dst =3D %llu=
 time =3D %lu\n",=20
+				&o[0], &o[1], &o[2], &o[3],=20
+				&s.src.b_all,=20
+				&s.src.p_all,=20
+				&s.dst.b_all,=20
+				&s.dst.p_all,=20
+				&s.time.tv_sec) =3D=3D 9) {	=09
+		/*
+		 * We got line formated like short listing row. Do the
+		 * same action like above.
+		 */
+		ip =3D o[0] << 24 | o[1] << 16 | o[2] << 8 | o[3];	=09
+		if ((u_int32_t)(ip & table->netmask) =3D=3D (u_int32_t)table->network) {
+			s.time =3D CURRENT_TIME_SEC;
+			write_lock_bh(&table->stats_lock);
+			table->stats.s[ip - table->network] =3D s;
+			write_unlock_bh(&table->stats_lock);
+		}
+	} else {
+		/*
+		 * We don't understand what user have just wrote.
+		 */
+		return -EIO;
 	}
=20
-	/* remove table if use-count is zero */
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": destory() table %s not used. Removi=
ng.\n", table->name);
+	return size;
+}
=20
-	/* unlink table */
-	if(last_table)=20
-		last_table->next =3D table->next;=20
-	else=20
-		account_tables =3D table->next;
-	spin_unlock_bh(&account_lock);
+static int ipt_account_proc_open(struct inode *inode, struct file *file)
+{
+	int ret =3D seq_open(file, &ipt_account_seq_ops);
+	if (!ret) {
+		struct seq_file *sf =3D file->private_data;
+		struct proc_dir_entry *pde =3D PDE(inode);
+		struct t_ipt_account_table *table =3D pde->data;
+	=09
+		sf->private =3D pde;
=20
-	/* wait while table is still in use */
-	spin_lock_bh(&table->ip_list_lock);
-	spin_unlock_bh(&table->ip_list_lock);
+		ipt_account_table_get(table);
+	}
+	return ret;
+}
=20
-	/* remove proc entries */=09
-	remove_proc_entry(table->name, proc_net_ipt_account);
+static int ipt_account_proc_release(struct inode *inode, struct file *file)
+{
+	struct proc_dir_entry *pde =3D PDE(inode);
+	struct t_ipt_account_table *table =3D pde->data;
+	int ret;
=20
-	/* remove table */
-	if (!table->shortlisting)
-		vfree(table->ip_list.l);
-	else
-		vfree(table->ip_list.s);
-	vfree(table);
+	ret =3D seq_release(inode, file);
=20
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": destory() left.\n");
-	return;
+	if (!ret)
+		ipt_account_table_put(table);
+=09
+	return ret;
 }
=20
-static struct ipt_match account_match =3D {
-	.name =3D "account",
-	.match =3D &match,
-	.checkentry =3D &checkentry,
-	.destroy =3D &destroy,
-	.me =3D THIS_MODULE
+static struct file_operations ipt_account_proc_fops =3D {
+	.owner =3D THIS_MODULE,
+	.open =3D ipt_account_proc_open,
+	.read =3D seq_read,
+	.write =3D ipt_account_proc_write,
+	.llseek =3D seq_lseek,
+	.release =3D ipt_account_proc_release
 };
=20
-static int __init init(void)=20
+/*
+ * Module init function.
+ */
+static int __init init(void)
 {
-	int err;
-=09
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": __init() entered.\n");
-	printk(version);=09
-	/* check params */
+	int ret =3D 0;
+
+	printk(KERN_INFO "ipt_account %s : Piotr Gasid=C5=82o <quaker@barbara.eu.=
org>, http://www.barbara.eu.org/~quaker/ipt_account/\n", IPT_ACCOUNT_VERSIO=
N);
+
+	/* Check module parameters. */
 	if (netmask > 32 || netmask < 0) {
-		printk(KERN_INFO "account: Wrong netmask given by netmask parameter (%i)=
=2E Valid is 32 to 0.\n", netmask);
-		err =3D -EINVAL;
-		goto doexit;
+		printk(KERN_ERR "ipt_account[__init]: Wrong netmask given as parameter (=
%i). Valid is 32 to 0.\n", netmask);
+		ret =3D -EINVAL;
+		goto cleanup_none;
 	}
+=09
+	/* Register match. */
+	if (ipt_register_match(&account_match)) {
+		ret =3D -EINVAL;
+		goto cleanup_none;
+	}
=20
-	/* create /proc/net/ipt_account directory */
-	proc_net_ipt_account =3D proc_mkdir("ipt_account", proc_net);
-	if (!proc_net_ipt_account) {	=09
-		printk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() failed to create procf=
s entry.\n");
-		err =3D -ENOMEM;
-		goto doexit;
+	/* Create /proc/net/ipt_account/ entry. */
+	ipt_account_procdir =3D proc_mkdir("ipt_account", proc_net);
+	if (!ipt_account_procdir) {	=09
+		printk(KERN_ERR "ipt_account [__init]: ipt_account_procdir =3D proc_mkdi=
r(\"ipt_account\", proc_net) failed.\n");
+		ret =3D -ENOMEM;
+		goto cleanup_match;
 	}
-	proc_net_ipt_account->owner =3D THIS_MODULE;
 =09
-	err =3D ipt_register_match(&account_match);
-	if (err) {
-		printk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() failed to register mat=
ch.\n");
-		remove_proc_entry("ipt_account", proc_net);
-	}
-doexit:=09
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": __init() left.\n");
-	return err;
+	return ret;
+
+	/* If something goes wrong we end here. */
+cleanup_match:
+	ipt_unregister_match(&account_match);
+cleanup_none:
+	return ret;
 }
=20
-static void __exit fini(void)=20
+/*
+ * Module exit function.
+ */
+static void __exit fini(void)
 {
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": __exit() entered.\n");
-=09
+	/* Remove /proc/net/ipt_account/ */
+	remove_proc_entry(ipt_account_procdir->name, ipt_account_procdir->parent)=
;=09
 	ipt_unregister_match(&account_match);
-	/* remove /proc/net/ipt_account/ directory */
-	remove_proc_entry("ipt_account", proc_net);
-
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": __exit() left.\n");
 }
=20
 module_init(init);

--SLDf9lqlvOQaIe6s--

--=_pandora.barbara.ds.polsl.gliwice.pl-16601-1143910429-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFELrAbgEmu6PNADqoRAq+jAJwJmBnvd2LjgOKahiK6Y/inISRZuwCfU1Q3
lBL82juVT3xpes1fRGw119M=
=mzPL
-----END PGP SIGNATURE-----

--=_pandora.barbara.ds.polsl.gliwice.pl-16601-1143910429-0001-2--
