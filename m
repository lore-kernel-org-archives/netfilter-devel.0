From: "Piotr =?iso-8859-2?Q?Gasid=B3o?=" <quaker@pandora.barbara.eu.org>
Subject: [PATCH] ipt_account update
Date: Fri, 16 Jul 2004 15:56:13 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040716135613.GA13582@pandora.barbara.eu.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_pandora.barbara.ds.polsl.gliwice.pl-21745-1089986174-0001-2"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_pandora.barbara.ds.polsl.gliwice.pl-21745-1089986174-0001-2
Content-Type: multipart/mixed; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I've recently updated ipt_account match.=20

Changes in 0.1.6:
- rewritted locking
- removed 32-bit statistics, only 64-bit are available,
  new names for tables in procfs (no _32 and _64 postfix)
- added --ashort switch to create "short" tables (only sum of all
  traffic, no individual protocol statistics)
- counters can be changed (loaded) using procfs

Updated documentation (polish but also english) will be soon available
on my homepage.

Please apply patch to CVS.

--=20
Piotr 'QuakeR' Gasid=B3o, BOFH @ pandora.barbara.eu.org
############## sending lusers to /dev/null since 1998
##### Waiting for tomorrow, for a little ray of light
### Waiting for tomorrow just to see your smile again

--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename="ipt_account-0.1.16_iptables.diff"
Content-Transfer-Encoding: quoted-printable

diff -uNr iptables.clean/extensions/libipt_account.c iptables.1/extensions/=
libipt_account.c
--- iptables.clean/extensions/libipt_account.c	2004-03-17 15:40:03.00000000=
0 +0100
+++ iptables.1/extensions/libipt_account.c	2004-07-15 13:30:00.000000000 +0=
200
@@ -2,7 +2,7 @@
  * accounting match helper (libipt_account.c)
  * (C) 2003,2004 by Piotr Gasid=B3o (quaker@barbara.eu.org)
  *
- * Version: 0.1.5
+ * Version: 0.1.6
  *
  * This software is distributed under the terms of GNU GPL
  */
@@ -31,15 +31,18 @@
 			"--aname name\n"
 			"	defines name of list where statistics will be kept. If no is\n"
 			"	specified DEFAULT will be used.\n"
-
+			"--ashort\n"
+			"       table will colect only short statistics (only total counters\n"
+			"       without splitting it into protocols.\n"
 	,=20
 	IPTABLES_VERSION);
 };
=20
 static struct option opts[] =3D {
-	{ "aaddr", 1, NULL, 201 },
-	{ "aname", 1, NULL, 202 },
-	{ 0 }
+	{ .name =3D "aaddr",  .has_arg =3D 1, .flag =3D NULL, .val =3D 201 },
+	{ .name =3D "aname",  .has_arg =3D 1, .flag =3D NULL, .val =3D 202 },
+	{ .name =3D "ashort", .has_arg =3D 0, .flag =3D NULL, .val =3D 203 },
+	{ .name =3D 0, .has_arg =3D 0, .flag =3D 0, .val =3D 0 }
 };
=20
 /* Helper functions for parse_network */
@@ -139,6 +142,26 @@
 =09
 }
=20
+/* validate netmask */
+inline int valid_netmask(u_int32_t netmask) {
+	while (netmask & 0x80000000)
+		netmask <<=3D 1;
+	if (netmask !=3D 0)
+		return 0;
+        return 1;
+}
+
+/* validate network/netmask pair */
+inline int valid_network_and_netmask(struct t_ipt_account_info *info) {
+	if (!valid_netmask(info->netmask))
+		return 0;
+	if ((info->network & info->netmask) !=3D info->network)
+		return 0;
+	return 1;
+}
+
+
+
 /* Function initializes match */
 static void init(struct ipt_entry_match *match,=20
 		 unsigned int *nfcache) {
@@ -149,6 +172,7 @@
=20
 	/* set default table name to DEFAULT */
 	strncpy(info->name, "DEFAULT", IPT_ACCOUNT_NAME_LEN);
+	info->shortlisting =3D 0;
 =09
 }
=20
@@ -166,7 +190,9 @@
 	=09
 		/* --aaddr */
 		case 201:
-			parse_network(optarg, info);		=09
+			parse_network(optarg, info);
+			if (!valid_network_and_netmask(info))
+				exit_error(PARAMETER_PROBLEM, "account: wrong network/netmask");
 			*flags =3D 1;
 			break;
 		=09
@@ -175,8 +201,12 @@
 			if (strlen(optarg) < IPT_ACCOUNT_NAME_LEN)
 				strncpy(info->name, optarg, IPT_ACCOUNT_NAME_LEN);
 			else
-				exit_error(PARAMETER_PROBLEM, "account: Too long list name");		=09
+				exit_error(PARAMETER_PROBLEM, "account: Too long table name");		=09
 			break;=09
+		/* --ashort */
+		case 203:
+			info->shortlisting =3D 1;
+			break;
 		default:
 			return 0;		=09
 	}
@@ -204,6 +234,8 @@
 	      );
 =09
 	printf("name: %s ", info->name);
+	if (info->shortlisting)
+		printf("short-listing ");
 }
=20
 /* Function used for saving rule containing account match */
@@ -219,21 +251,23 @@
 	       );
 =09
 	printf("--aname %s ", info->name);
+	if (info->shortlisting)
+		printf("--ashort ");
 }
 =09
 static struct iptables_match account =3D {
-	NULL,			/* struct iptables_match *next; */
-	"account",		/* ipt_chainlabel name; */
-	IPTABLES_VERSION,	/* const char *version; */
-	IPT_ALIGN(sizeof(struct t_ipt_account_info)),		/* Size of match data. */
-	IPT_ALIGN(sizeof(struct t_ipt_account_info)),		/* Size of match data rele=
vent for userspace comparison purposes */
-	&help,			/* Function which prints out usage message. */
-	&init,			/* Initialize the match. */
-	&parse,			/* Function which parses command options; returns true if it at=
e an option */
-	&final_check,		/* Final check; exit if not ok. */
-	&print,			/* Prints out the match iff non-NULL: put space at end */
-	&save,			/* Saves the match info in parsable form to stdout. */
-	opts			/* Pointer to list of extra command-line options */
+	.next =3D NULL,
+	.name =3D "account",
+	.version =3D IPTABLES_VERSION,
+	.size =3D IPT_ALIGN(sizeof(struct t_ipt_account_info)),
+	.userspacesize =3D IPT_ALIGN(sizeof(struct t_ipt_account_info)),
+	.help =3D &help,
+	.init =3D &init,
+	.parse =3D &parse,
+	.final_check =3D &final_check,
+	.print =3D &print,
+	.save =3D &save,
+	.extra_opts =3D opts
 };
=20
 /* Function which registers match */

--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename="ipt_account-0.1.16_patch-o-matic-ng.diff"
Content-Transfer-Encoding: quoted-printable

diff -uNr patch-o-matic-ng.clean/ACCOUNT/linux/Documentation/Configure.help=
.ladd patch-o-matic-ng.1/ACCOUNT/linux/Documentation/Configure.help.ladd
--- patch-o-matic-ng.clean/ACCOUNT/linux/Documentation/Configure.help.ladd	=
2004-06-13 22:35:22.000000000 +0200
+++ patch-o-matic-ng.1/ACCOUNT/linux/Documentation/Configure.help.ladd	1970=
-01-01 01:00:00.000000000 +0100
@@ -1,19 +0,0 @@
-CONFIG_IP_NF_TARGET_ULOG
-ACCOUNT target support
-CONFIG_IP_NF_TARGET_ACCOUNT
-
-  The ACCOUNT target is a high performance accounting system for local net=
works.
-  It takes two parameters: --addr network/netmask and --tname NAME.
-
-  --addr is the subnet which is accounted for
-  --tname is the table name where the information is stored
-
-  The data can be queried later using the libipt_ACCOUNT userspace library
-  or by the "iptaccount" tool which is part of the libipt_ACCOUNT package.
-
-  A special subnet is "0.0.0.0/0": All data is stored in the src_bytes
-  and src_packets structure of slot "0". This is useful if you want
-  to account the overall traffic to/from your internet provider.
-
-  If you want to compile it as a module, say M here and read
-  Documentation/modules.txt.  If unsure, say `N'.
diff -uNr patch-o-matic-ng.clean/account/help patch-o-matic-ng.1/account/he=
lp
--- patch-o-matic-ng.clean/account/help	2004-03-17 15:50:12.000000000 +0100
+++ patch-o-matic-ng.1/account/help	2004-07-16 15:07:09.000000000 +0200
@@ -1,5 +1,33 @@
-This match is used for accounting traffic.
+This match is used for accounting traffic for all hosts in
+defined network/netmask.=20
=20
-Short options are available by using 'iptables -m account -h'
-Official Website: <http://www.barbara.eu.org/~quaker/ipt_account/>
+Features:
+- long (one counter per protocol TCP/UDP/IMCP/Other) and short statistics
+- one iptables rule for all hosts in network/netmask
+- loading/saving counters (by reading/writting to procfs entries)
=20
+Example usage:
+
+account traffic for/to 192.168.0.0/24 network into table mynetwork:
+
+# iptables -A FORWARD -m account --aname mynetwork --aaddr 192.168.0.0/24
+
+account traffic for/to WWW serwer for 192.168.0.0/24 network into table=20
+  mywwwserver:
+
+# iptables -A INPUT -p tcp --dport 80=20
+  -m account --aname mywwwserver --aaddr 192.168.0.0/24 --ashort
+# iptables -A OUTPUT -p tcp --sport 80
+  -m account --aname mywwwserver --aaddr 192.168.0.0/24 --ashort   =20
+ =20
+read counters:
+
+# cat /proc/net/ipt_account/mynetwork
+# cat /proc/net/ipt_account/mywwwserver
+
+set counters:
+
+# echo "ip =3D 192.168.0.1 packets_src =3D 0" > /proc/net/ipt_account/myww=
server
+ =20
+Webpage:=20
+  http://www.barbara.eu.org/~quaker/ipt_account/ =20
diff -uNr patch-o-matic-ng.clean/account/info patch-o-matic-ng.1/account/in=
fo
--- patch-o-matic-ng.clean/account/info	2004-03-17 15:50:12.000000000 +0100
+++ patch-o-matic-ng.1/account/info	2004-07-14 18:29:58.000000000 +0200
@@ -1,4 +1,3 @@
 Author: Piotr Gasido <quaker@pandora.barbara.eu.org>
 Status: working
 Repository: extra
-Requires: linux < 2.6.0
diff -uNr patch-o-matic-ng.clean/account/linux/Documentation/Configure.help=
.ladd patch-o-matic-ng.1/account/linux/Documentation/Configure.help.ladd
--- patch-o-matic-ng.clean/account/linux/Documentation/Configure.help.ladd	=
1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng.1/account/linux/Documentation/Configure.help.ladd	2004=
-07-16 15:24:17.000000000 +0200
@@ -0,0 +1,47 @@
+CONFIG_IP_NF_TARGET_TOS
+account match support
+CONFIG_IP_NF_MATCH_ACCOUNT
+  This match is used for accounting traffic for all hosts in
+  defined network/netmask.=20
+
+  Features:
+  - long (one counter per protocol TCP/UDP/IMCP/Other) and short statistics
+  - one iptables rule for all hosts in network/netmask
+  - loading/saving counters (by reading/writting to procfs entries)
+
+  Example usage:
+
+  account traffic for/to 192.168.0.0/24 network into table mynetwork:
+
+  # iptables -A FORWARD -m account --aname mynetwork --aaddr 192.168.0.0/24
+
+  account traffic for/to WWW serwer for 192.168.0.0/24 network into table=
=20
+    mywwwserver:
+
+  # iptables -A INPUT -p tcp --dport 80=20
+    -m account --aname mywwwserver --aaddr 192.168.0.0/24 --ashort
+  # iptables -A OUTPUT -p tcp --sport 80
+    -m account --aname mywwwserver --aaddr 192.168.0.0/24 --ashort   =20
+ =20
+  read counters:
+
+  # cat /proc/net/ipt_account/mynetwork
+  # cat /proc/net/ipt_account/mywwwserver
+
+  set counters:
+
+  # echo "ip =3D 192.168.0.1 packets_src =3D 0" > /proc/net/ipt_account/my=
wwserver
+ =20
+  Webpage:=20
+    http://www.barbara.eu.org/~quaker/ipt_account/ =20
+
+  If you want to compile it as a module, say M here and read
+  Documentation/modules.txt.  If unsure, say `N'.
+ =20
+account debugging output
+CONFIG_IP_NF_MATCH_ACCOUNT_DEBUG
+  Say Y to get lots of debugging output
+
+
+
+ =20
\ No newline at end of file
diff -uNr patch-o-matic-ng.clean/account/linux/include/linux/netfilter_ipv4=
/ipt_account.h patch-o-matic-ng.1/account/linux/include/linux/netfilter_ipv=
4/ipt_account.h
--- patch-o-matic-ng.clean/account/linux/include/linux/netfilter_ipv4/ipt_a=
ccount.h	2004-03-17 15:50:12.000000000 +0100
+++ patch-o-matic-ng.1/account/linux/include/linux/netfilter_ipv4/ipt_accou=
nt.h	2004-07-14 17:33:15.000000000 +0200
@@ -1,8 +1,8 @@
 /*=20
  * accounting match (ipt_account.c)
- * (C) 2003,2004 by Piotr Gasid=B3o (quaker@barbara.eu.org)
+ * (C) 2003,2004 by Piotr Gasidlo (quaker@barbara.eu.org)
  *
- * Version: 0.1.5
+ * Version: 0.1.6
  *
  * This software is distributed under the terms of GNU GPL
  */
@@ -12,10 +12,15 @@
=20
 #define IPT_ACCOUNT_NAME_LEN 64
=20
+#define IPT_ACCOUNT_NAME "ipt_account"
+#define IPT_ACCOUNT_VERSION  "0.1.6"
+
 struct t_ipt_account_info {
 	char name[IPT_ACCOUNT_NAME_LEN];
 	u_int32_t network;
 	u_int32_t netmask;
+	int shortlisting:1;
 };
=20
 #endif
+
diff -uNr patch-o-matic-ng.clean/account/linux/net/ipv4/netfilter/Config.in=
.ladd patch-o-matic-ng.1/account/linux/net/ipv4/netfilter/Config.in.ladd
--- patch-o-matic-ng.clean/account/linux/net/ipv4/netfilter/Config.in.ladd	=
2004-03-17 15:50:12.000000000 +0100
+++ patch-o-matic-ng.1/account/linux/net/ipv4/netfilter/Config.in.ladd	2004=
-07-14 17:46:35.000000000 +0200
@@ -1,2 +1,5 @@
   dep_tristate '  TOS match support' CONFIG_IP_NF_MATCH_TOS $CONFIG_IP_NF_=
IPTABLES
-  dep_tristate '  account match support' CONFIG_IP_NF_MATCH_ACCOUNT $CONFI=
G_IP_NF_IPTABLES
+  dep_tristate '  account match support' CONFIG_IP_NF_MATCH_ACCOUNT $CONFI=
G_IP_NF_IPTABLES $CONFIG_PROC_FS
+  if [ "$CONFIG_IP_NF_MATCH_ACCOUNT" !=3D "n" ]; then=20
+    bool '    account debugging output' CONFIG_IP_NF_MATCH_ACCOUNT_DEBUG
+  fi
diff -uNr patch-o-matic-ng.clean/account/linux/net/ipv4/netfilter/ipt_accou=
nt.c patch-o-matic-ng.1/account/linux/net/ipv4/netfilter/ipt_account.c
--- patch-o-matic-ng.clean/account/linux/net/ipv4/netfilter/ipt_account.c	2=
004-03-17 15:50:12.000000000 +0100
+++ patch-o-matic-ng.1/account/linux/net/ipv4/netfilter/ipt_account.c	2004-=
07-16 14:45:37.000000000 +0200
@@ -1,8 +1,8 @@
 /*=20
  * accounting match (ipt_account.c)
- * (C) 2003,2004 by Piotr Gasid=B3o (quaker@barbara.eu.org)
+ * (C) 2003,2004 by Piotr Gasidlo (quaker@barbara.eu.org)
  *
- * Version: 0.1.5
+ * Version: 0.1.6
  *
  * This software is distributed under the terms of GNU GPL
  */
@@ -13,6 +13,7 @@
 #include <linux/spinlock.h>
 #include <linux/vmalloc.h>
 #include <linux/interrupt.h>
+#include <linux/ctype.h>
=20
 #include <asm/uaccess.h>
=20
@@ -23,106 +24,188 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_account.h>
=20
-static char version[] =3D
-KERN_INFO "ipt_account 0.1.5 : Piotr Gasid=B3o <quaker@barbara.eu.org>, ht=
tp://www.barbara.eu.org/~quaker/ipt_account/\n";
+#if defined(CONFIG_IP_NF_MATCH_ACCOUNT_DEBUG)
+	#define dprintk(format,args...) printk(format,##args)
+#else
+        #define dprintk(format,args...)
+#endif
=20
-/* default rights for files created in /proc/net/ipt_account/ */
-static int ip_list_perms =3D 0644;
+static char version[] =3D
+KERN_INFO IPT_ACCOUNT_NAME " " IPT_ACCOUNT_VERSION " : Piotr Gasid=B3o <qu=
aker@barbara.eu.org>, http://www.barbara.eu.org/~quaker/ipt_account/\n";
=20
-/*=20
- * safe netmask, if you want account traffic for networks=20
- * bigger that /17 you must specify ip_list_max_hosts parameter=20
- * during load=20
- */
-static int ip_list_max_mask =3D 17;
-static int ip_list_max_hosts_count;
-static int debug =3D 0;
+/* rights for files created in /proc/net/ipt_account/ */
+static int permissions =3D 0644;
+/* maximal netmask for single table */
+static int netmask =3D 16;
=20
 /* module information */
-MODULE_AUTHOR("Piotr Gasid=B3o <quaker@barbara.eu.org>");
+MODULE_AUTHOR("Piotr Gasidlo <quaker@barbara.eu.org>");
 MODULE_DESCRIPTION("Traffic accounting modules");
 MODULE_LICENSE("GPL");
-MODULE_PARM(ip_list_perms,"i");
-MODULE_PARM_DESC(ip_list_perms,"permissions on /proc/net/ipt_account/* fil=
es");
-MODULE_PARM(ip_list_max_mask, "i");
-MODULE_PARM_DESC(ip_list_max_mask, "maximum *save* size of one list (netma=
sk)");
-#ifdef DEBUG
-MODULE_PARM(debug,"i");
-MODULE_PARM_DESC(debug,"debugging level, defaults to 0");
-#endif
+MODULE_PARM(permissions,"i");
+MODULE_PARM_DESC(permissions,"permissions on /proc/net/ipt_account/* files=
");
+MODULE_PARM(netmask, "i");
+MODULE_PARM_DESC(netmask, "maximum *save* size of one list (netmask)");
=20
 /* structure with statistics counters */
 struct t_ipt_account_stat {
 	u_int64_t b_all, b_tcp, b_udp, b_icmp, b_other;		/* byte counters for all=
/tcp/udp/icmp/other traffic  */
 	u_int64_t p_all, p_tcp, p_udp, p_icmp, p_other;		/* packet counters for a=
ll/tcp/udp/icmp/other traffic */
 };
+
+/* stucture with statistics counters, used when table is created with --as=
hort switch */
+struct t_ipt_account_stat_short {
+	u_int64_t b_all;					/* byte counters for all traffic */
+	u_int64_t p_all;					/* packet counters for all traffic */
+};
 =20
 /* structure holding to/from statistics for single ip */
 struct t_ipt_account_ip_list {
 	struct t_ipt_account_stat src;
 	struct t_ipt_account_stat dest;
+	unsigned long time;					/* time when this record was last updated */=09
+=09
+};
+
+/* same as above, for tables with --ashort switch */
+struct t_ipt_account_ip_list_short {
+	struct t_ipt_account_stat_short src;
+	struct t_ipt_account_stat_short dest;
+	unsigned long time;
 };
=20
 /* structure describing single table */
 struct t_ipt_account_table {
 	char name[IPT_ACCOUNT_NAME_LEN];	/* table name ( =3D filename in /proc/ne=
t/ipt_account/) */
-	struct t_ipt_account_ip_list *ip_list;	/* table with statistics for each =
ip in network/netmask */
-	struct t_ipt_account_table *next;
+	union {					/* table with statistics for each ip in network/netmask */
+		struct t_ipt_account_ip_list *l;
+		struct t_ipt_account_ip_list_short *s;
+	} ip_list;
 	u_int32_t network;			/* network/netmask covered by table*/
 	u_int32_t netmask;				=09
+	u_int32_t count;
+	int shortlisting:1;			/* show only total columns of counters */=09
 	int use_count;				/* rules counter - counting number of rules using this =
table */
+	struct t_ipt_account_table *next;
 	spinlock_t ip_list_lock;
-	struct proc_dir_entry *status_proc_64, *status_proc_32;
+	struct proc_dir_entry *status_file;
 };
=20
 /* we must use spinlocks to avoid parallel modifications of table list */
-static spinlock_t ipt_account_tables_lock =3D SPIN_LOCK_UNLOCKED;
+static spinlock_t account_lock =3D SPIN_LOCK_UNLOCKED;
=20
 static struct proc_dir_entry *proc_net_ipt_account =3D NULL;
=20
 /* root pointer holding list of the tables */
-static struct t_ipt_account_table *ipt_account_tables =3D NULL;
+static struct t_ipt_account_table *account_tables =3D NULL;
+
+/* convert ascii to ip */
+int atoip(char *buffer, u_int32_t *ip) {
+
+	char *bufferptr =3D buffer;
+	int part, shift;
+=09
+	/* zero ip */
+	*ip =3D 0;
+
+	/* first must be a digit */
+	if (!isdigit(*bufferptr))
+		return 0;
=20
-static int ip_list_read_proc_64(char *buffer, char **start, off_t offset,
+	/* parse first 3 octets (III.III.III.iii) */
+	for (part =3D 0, shift =3D 24; *bufferptr && shift; bufferptr++) {
+		if (isdigit(*bufferptr)) {
+			part =3D part * 10 + (*bufferptr - '0');
+			continue;
+		}
+		if (*bufferptr =3D=3D '.') {
+			if (part > 255)
+				return 0;
+			*ip |=3D part << shift;
+			shift -=3D 8;
+			part =3D 0;
+			continue;
+		}
+		return 0;
+	}
+=09
+	/* we expect more digts */
+	if (!*bufferptr)
+		return 0;
+	/* parse last octet (iii.iii.iii.III) */
+	for (; *bufferptr; bufferptr++) {
+		if (isdigit(*bufferptr)) {
+			part =3D part * 10 + (*bufferptr - '0');		=09
+			continue;
+		} else {
+			if (part > 255)
+				return 0;
+			*ip |=3D part;
+			break;
+		}
+	}
+	return (bufferptr - buffer);
+}
+
+/* convert ascii to 64bit integer */
+int atoi64(char *buffer, u_int64_t *i) {=09
+	char *bufferptr =3D buffer;
+
+	/* zero integer */
+	*i =3D 0;
+=09
+	while (isdigit(*bufferptr)) {
+		*i =3D *i * 10 + (*bufferptr - '0');
+		bufferptr++;
+	}
+	return (bufferptr - buffer);
+}
+
+static int account_proc_read(char *buffer, char **start, off_t offset,
 		int length, int *eof, void *data) {
 =09
 	int len =3D 0, last_len =3D 0;
 	off_t pos =3D 0, begin =3D 0;
-
 	u_int32_t address, index;=09
+	struct timespec last;
+	unsigned long now =3D jiffies;
=20
 	struct t_ipt_account_table *table =3D (struct t_ipt_account_table*)data;
+=09
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_read() entered.\n");
=20
-	spin_lock(&table->ip_list_lock);
-	for (address =3D table->network; (u_int32_t)(address & table->netmask) =
=3D=3D (u_int32_t)(table->network); address++) {
+	spin_lock_bh(&table->ip_list_lock);
+	for (address =3D table->network, index =3D 0; index < table->count; addre=
ss++, index++) {
 		last_len =3D len;	=09
-		index =3D address - table->network;
-			len +=3D sprintf(buffer + len,
-				"ip =3D %u.%u.%u.%u bytes_src =3D %llu %llu %llu %llu %llu packets_src=
 =3D %llu %llu %llu %llu %llu bytes_dest =3D %llu %llu %llu %llu %llu packe=
ts_dest =3D %llu %llu %llu %llu %llu\n",
+		jiffies_to_timespec(now - table->ip_list.l[index].time, &last);
+		len +=3D sprintf(buffer + len,
+				"ip =3D %u.%u.%u.%u bytes_src =3D %llu %llu %llu %llu %llu packets_src=
 =3D %llu %llu %llu %llu %llu bytes_dest =3D %llu %llu %llu %llu %llu packe=
ts_dest =3D %llu %llu %llu %llu %llu time =3D %lu\n",
 				HIPQUAD(address),
-				table->ip_list[index].src.b_all,
-				table->ip_list[index].src.b_tcp,
-				table->ip_list[index].src.b_udp,
-				table->ip_list[index].src.b_icmp,
-				table->ip_list[index].src.b_other,
+				table->ip_list.l[index].src.b_all,
+				table->ip_list.l[index].src.b_tcp,
+				table->ip_list.l[index].src.b_udp,
+				table->ip_list.l[index].src.b_icmp,
+				table->ip_list.l[index].src.b_other,
 			=09
-				table->ip_list[index].src.p_all,
-				table->ip_list[index].src.p_tcp,
-				table->ip_list[index].src.p_udp,
-				table->ip_list[index].src.p_icmp,
-				table->ip_list[index].src.p_other,
+				table->ip_list.l[index].src.p_all,
+				table->ip_list.l[index].src.p_tcp,
+				table->ip_list.l[index].src.p_udp,
+				table->ip_list.l[index].src.p_icmp,
+				table->ip_list.l[index].src.p_other,
 			=09
-				table->ip_list[index].dest.b_all,
-				table->ip_list[index].dest.b_tcp,
-				table->ip_list[index].dest.b_udp,
-				table->ip_list[index].dest.b_icmp,
-				table->ip_list[index].dest.b_other,			=09
+				table->ip_list.l[index].dest.b_all,
+				table->ip_list.l[index].dest.b_tcp,
+				table->ip_list.l[index].dest.b_udp,
+				table->ip_list.l[index].dest.b_icmp,
+				table->ip_list.l[index].dest.b_other,			=09
 			=09
-				table->ip_list[index].dest.p_all,
-				table->ip_list[index].dest.p_tcp,
-				table->ip_list[index].dest.p_udp,
-				table->ip_list[index].dest.p_icmp,
-				table->ip_list[index].dest.p_other
+				table->ip_list.l[index].dest.p_all,
+				table->ip_list.l[index].dest.p_tcp,
+				table->ip_list.l[index].dest.p_udp,
+				table->ip_list.l[index].dest.p_icmp,
+				table->ip_list.l[index].dest.p_other,
+
+				last.tv_sec
 				);
 		pos =3D begin + len;
 		if (pos < offset) {
@@ -134,56 +217,43 @@
 			break;
 		}
 	}
-	spin_unlock(&table->ip_list_lock);
+	spin_unlock_bh(&table->ip_list_lock);
 	*start =3D buffer + (offset - begin);
 	len -=3D (offset - begin);
 	if (len > length)
 		len =3D length;
+
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_read() left.\n");
+=09
 	return len;
 }
=20
-static int ip_list_read_proc_32(char *buffer, char **start, off_t offset,
+static int account_proc_read_short(char *buffer, char **start, off_t offse=
t,
 		int length, int *eof, void *data) {
 =09
 	int len =3D 0, last_len =3D 0;
 	off_t pos =3D 0, begin =3D 0;
-
-	u_int32_t address, index;
+	u_int32_t address, index;=09
+	struct timespec last;
+	unsigned long now =3D jiffies;
=20
 	struct t_ipt_account_table *table =3D (struct t_ipt_account_table*)data;
 =09
-	spin_lock(&table->ip_list_lock);
-	for (address =3D table->network; (u_int32_t)(address & table->netmask) =
=3D=3D (u_int32_t)(table->network); address++) {
-		last_len =3D len;=09
-		index =3D address - table->network;
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_read_short() entered.\=
n");
+
+	spin_lock_bh(&table->ip_list_lock);
+	for (address =3D table->network, index =3D 0; index < table->count; addre=
ss++, index++) {
+		last_len =3D len;	=09
+		jiffies_to_timespec(now - table->ip_list.s[index].time, &last);
 		len +=3D sprintf(buffer + len,
-				"ip =3D %u.%u.%u.%u bytes_src =3D %u %u %u %u %u packets_src =3D %u %u=
 %u %u %u bytes_dest =3D %u %u %u %u %u packets_dest =3D %u %u %u %u %u\n",
+				"ip =3D %u.%u.%u.%u bytes_src =3D %llu packets_src =3D %llu bytes_dest=
 =3D %llu packets_dest =3D %llu time =3D %lu\n",
 				HIPQUAD(address),
-				(u_int32_t)table->ip_list[index].src.b_all,
-				(u_int32_t)table->ip_list[index].src.b_tcp,
-				(u_int32_t)table->ip_list[index].src.b_udp,
-				(u_int32_t)table->ip_list[index].src.b_icmp,
-				(u_int32_t)table->ip_list[index].src.b_other,
-			=09
-				(u_int32_t)table->ip_list[index].src.p_all,
-				(u_int32_t)table->ip_list[index].src.p_tcp,
-				(u_int32_t)table->ip_list[index].src.p_udp,
-				(u_int32_t)table->ip_list[index].src.p_icmp,
-				(u_int32_t)table->ip_list[index].src.p_other,
-			=09
-				(u_int32_t)table->ip_list[index].dest.b_all,
-				(u_int32_t)table->ip_list[index].dest.b_tcp,
-				(u_int32_t)table->ip_list[index].dest.b_udp,
-				(u_int32_t)table->ip_list[index].dest.b_icmp,
-				(u_int32_t)table->ip_list[index].dest.b_other,
-			=09
-				(u_int32_t)table->ip_list[index].dest.p_all,
-				(u_int32_t)table->ip_list[index].dest.p_tcp,
-				(u_int32_t)table->ip_list[index].dest.p_udp,
-				(u_int32_t)table->ip_list[index].dest.p_icmp,
-				(u_int32_t)table->ip_list[index].dest.p_other
-	=09
-			);
+				table->ip_list.s[index].src.b_all,
+				table->ip_list.s[index].src.p_all,
+				table->ip_list.s[index].dest.b_all,
+				table->ip_list.s[index].dest.p_all,
+				last.tv_sec
+				);
 		pos =3D begin + len;
 		if (pos < offset) {
 			len =3D 0;
@@ -192,63 +262,291 @@
 		if (pos > offset + length) {
 			len =3D last_len;
 			break;
-		}	=09
+		}
 	}
-	spin_unlock(&table->ip_list_lock);			=09
+	spin_unlock_bh(&table->ip_list_lock);
 	*start =3D buffer + (offset - begin);
 	len -=3D (offset - begin);
 	if (len > length)
 		len =3D length;
+
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_read_short() left.\n");
+=09
 	return len;
 }
=20
-static int ip_list_write_proc(struct file *file, const char *buffer,=20
-		unsigned long length, void *data) {
+static int account_proc_write(struct file *file, const char *ubuffer,=20
+		unsigned long ulength, void *data) {
=20
-	int len =3D (length > 1024) ? length : 1024;
 	struct t_ipt_account_table *table =3D (struct t_ipt_account_table*)data;
-	char kernel_buffer[1024];
-	u_int32_t hosts_count =3D INADDR_BROADCAST - table->netmask + 1;
-=09
-	copy_from_user(kernel_buffer, buffer, len);
-	kernel_buffer[len - 1] =3D 0;
-=09
-	/* echo "reset" > /proc/net/ipt_recent/table clears the table */
-	if (!strncmp(kernel_buffer, "reset", len)) {
-		spin_lock(&table->ip_list_lock);
-		memset(table->ip_list, 0, sizeof(struct t_ipt_account_ip_list) * hosts_c=
ount);
-		spin_unlock(&table->ip_list_lock);
+	char buffer[1024], *bufferptr;
+	int length;
+
+	u_int32_t ip;
+	int len, i;
+	struct t_ipt_account_ip_list l;
+	struct t_ipt_account_ip_list_short s;
+	u_int64_t *p, dummy;
+=09
+=09
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() entered.\n");
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() ulength =3D %l=
i.\n", ulength);
+=09
+	length =3D ulength;
+	if (ulength > 1024)
+		length =3D 1024;
+	if (copy_from_user(buffer, ubuffer, length))
+		return -EFAULT;
+	buffer[length - 1] =3D 0;
+	bufferptr =3D buffer;
+
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() buffer =3D \'%=
s\' length =3D %li.\n", buffer, length);
+=09
+	/* reset table counters */
+	if (!memcmp(buffer, "reset", 5)) {
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got \"reset\"=
.\n");
+		if (!table->shortlisting) {
+			spin_lock_bh(&table->ip_list_lock);
+			memset(table->ip_list.l, 0, sizeof(struct t_ipt_account_ip_list) * tabl=
e->count);
+			spin_unlock_bh(&table->ip_list_lock);
+		} else {
+			spin_lock_bh(&table->ip_list_lock);
+			memset(table->ip_list.s, 0, sizeof(struct t_ipt_account_ip_list_short) =
* table->count);
+			spin_unlock_bh(&table->ip_list_lock);
+		}
+		return length;
+	}
+
+	if (!memcmp(buffer, "ip", 2)) {
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got \"ip\".\n=
");
+		bufferptr +=3D 2;
+		if (!isspace(*bufferptr)) {
+			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected spa=
ce (%i).\n", bufferptr - buffer);
+			return length; /* expected space */
+		}
+		bufferptr +=3D 1;
+		if (*bufferptr !=3D '=3D') {
+			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected equ=
al (%i).\n", bufferptr - buffer);
+			return length; /* expected equal */
+		}
+		bufferptr +=3D 1;
+		if (!isspace(*bufferptr)) {
+			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected spa=
ce (%i).\n", bufferptr - buffer);
+			return length; /* expected space */
+		}
+		bufferptr +=3D 1;
+		if (!(len =3D atoip(bufferptr, &ip))) {
+			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected ip =
(%i).\n", bufferptr - buffer);
+			return length; /* expected ip */
+		}
+		bufferptr +=3D len;
+		if ((ip & table->netmask) !=3D table->network) {
+			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected ip =
[%u.%u.%u.%u] from table's network/netmask [%u.%u.%u.%u/%u.%u.%u.%u].\n", H=
IPQUAD(ip), HIPQUAD(table->network), HIPQUAD(table->netmask));
+			return length; /* expected ip from table's network/netmask */
+		}
+		if (!table->shortlisting) {
+			memset(&l, 0, sizeof(struct t_ipt_account_ip_list));
+			while(*bufferptr) {
+				if (!isspace(*bufferptr)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected s=
pace (%i).\n", bufferptr - buffer);
+					return length; /* expected space */
+				}
+				bufferptr +=3D 1;
+				if (!memcmp(bufferptr, "bytes_src", 9)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got bytes_=
src (%i).\n", bufferptr - buffer);
+					p =3D &l.src.b_all;
+					bufferptr +=3D 9;
+				} else if (!memcmp(bufferptr, "bytes_dest", 10)) {				=09
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got bytes_=
dest (%i).\n", bufferptr - buffer);
+					p =3D &l.dest.b_all;
+					bufferptr +=3D 10;
+				} else if (!memcmp(bufferptr, "packets_src", 11)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got packet=
s_src (%i).\n", bufferptr - buffer);
+					p =3D &l.src.p_all;
+					bufferptr +=3D 11;
+				} else if (!memcmp(bufferptr, "packets_dest", 12)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got packet=
s_dest (%i).\n", bufferptr - buffer);
+					p =3D &l.dest.p_all;
+					bufferptr +=3D 12;
+				} else if (!memcmp(bufferptr, "time", 4)) {
+					/* time hack, ignore time tokens */
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got time (=
%i).\n", bufferptr - buffer);
+					bufferptr +=3D 4;
+					if (!isspace(*bufferptr)) {
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected =
space (%i).\n", bufferptr - buffer);
+						return length; /* expected space */
+					}
+					bufferptr +=3D 1;
+					if (*bufferptr !=3D '=3D') {
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected =
equal (%i).\n", bufferptr - buffer);
+						return length; /* expected equal */
+					}
+					bufferptr +=3D 1;
+					if (!isspace(*bufferptr)) {
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected =
space (%i).\n", bufferptr - buffer);
+						return length; /* expected space */
+					}
+					bufferptr +=3D 1;
+					if (!(len =3D atoi64(bufferptr, &dummy))) {
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected =
int64 (%i).\n", bufferptr - buffer);
+						return length; /* expected int64 */
+					}
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got %llu (=
%i).\n", dummy, bufferptr - buffer);
+					bufferptr +=3D len;
+					continue; /* skip time token */
+				} else
+					return length;	/* expected token */
+				if (!isspace(*bufferptr)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected s=
pace (%i).\n", bufferptr - buffer);
+					return length; /* expected space */
+				}
+				bufferptr +=3D 1;
+				if (*bufferptr !=3D '=3D') {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected e=
qual (%i).\n", bufferptr - buffer);
+					return length; /* expected equal */
+				}
+				bufferptr +=3D 1;
+				for (i =3D 0; i < 5; i++) {
+					if (!isspace(*bufferptr)) {
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected =
space (%i).\n", bufferptr - buffer);
+						return length; /* expected space */
+					}
+					bufferptr +=3D 1;
+					if (!(len =3D atoi64(bufferptr, p))) {
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected =
int64 (%i).\n", bufferptr - buffer);
+						return length; /* expected int64 */
+					}
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got %llu (=
%i).\n", *p, bufferptr - buffer);
+					bufferptr +=3D len;
+					p++;
+				}
+			}
+			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() updating row=
.\n");
+			spin_lock_bh(&table->ip_list_lock);
+			/* update counters, do not overwrite time field */
+			memcpy(&table->ip_list.l[ip - table->network], &l, sizeof(struct t_ipt_=
account_ip_list) - sizeof(unsigned long));
+			spin_unlock_bh(&table->ip_list_lock);
+		} else {
+			memset(&s, 0, sizeof(struct t_ipt_account_ip_list_short));
+			while(*bufferptr) {
+				if (!isspace(*bufferptr)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected s=
pace (%i).\n", bufferptr - buffer);
+					return length; /* expected space */
+				}
+				bufferptr +=3D 1;
+				if (!memcmp(bufferptr, "bytes_src", 9)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got bytes_=
src (%i).\n", bufferptr - buffer);
+					p =3D &s.src.b_all;
+					bufferptr +=3D 9;
+				} else if (!memcmp(bufferptr, "bytes_dest", 10)) {				=09
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got bytes_=
dest (%i).\n", bufferptr - buffer);
+					p =3D &s.dest.b_all;
+					bufferptr +=3D 10;
+				} else if (!memcmp(bufferptr, "packets_src", 11)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got packet=
s_src (%i).\n", bufferptr - buffer);
+					p =3D &s.src.p_all;
+					bufferptr +=3D 11;
+				} else if (!memcmp(bufferptr, "packets_dest", 12)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got packet=
s_dest (%i).\n", bufferptr - buffer);
+					p =3D &s.dest.p_all;
+					bufferptr +=3D 12;
+				} else if (!memcmp(bufferptr, "time", 4)) {
+					/* time hack, ignore time tokens */
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got time (=
%i).\n", bufferptr - buffer);
+					bufferptr +=3D 4;
+					if (!isspace(*bufferptr)) {
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected =
space (%i).\n", bufferptr - buffer);
+						return length; /* expected space */
+					}
+					bufferptr +=3D 1;
+					if (*bufferptr !=3D '=3D') {
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected =
equal (%i).\n", bufferptr - buffer);
+						return length; /* expected equal */
+					}
+					bufferptr +=3D 1;
+					if (!isspace(*bufferptr)) {
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected =
space (%i).\n", bufferptr - buffer);
+						return length; /* expected space */
+					}
+					bufferptr +=3D 1;
+					if (!(len =3D atoi64(bufferptr, &dummy))) {
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected =
int64 (%i).\n", bufferptr - buffer);
+						return length; /* expected int64 */
+					}
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got %llu (=
%i).\n", dummy, bufferptr - buffer);
+					bufferptr +=3D len;
+					continue; /* skip time token */
+				} else {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected t=
oken (%i).\n", bufferptr - buffer);
+					return length;	/* expected token */
+				}
+				if (!isspace(*bufferptr)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected s=
pace (%i).\n", bufferptr - buffer);
+					return length; /* expected space */
+				}
+				bufferptr +=3D 1;
+				if (*bufferptr !=3D '=3D') {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected e=
qual (%i).\n", bufferptr - buffer);
+					return length; /* expected equal */
+				}
+				bufferptr +=3D 1;
+				if (!isspace(*bufferptr)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected s=
pace (%i).\n", bufferptr - buffer);
+					return length; /* expected space */
+				}
+				bufferptr +=3D 1;
+				if (!(len =3D atoi64(bufferptr, p))) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected i=
nt64 (%i).\n", bufferptr - buffer);
+					return length; /* expected int64 */
+				}
+				dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got %llu (%=
i).\n", *p, bufferptr - buffer);
+				bufferptr +=3D len;
+			}
+			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() updating row=
.\n");
+			spin_lock_bh(&table->ip_list_lock);
+			/* update counters, do not overwrite time field */
+			memcpy(&table->ip_list.s[ip - table->network], &s, sizeof(struct t_ipt_=
account_ip_list_short) - sizeof(unsigned long));
+			spin_unlock_bh(&table->ip_list_lock);
+		}
 	}
 =09
-	return len;
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() left.\n");
+	return length;
 }
=20
 /* do raw accounting */
-static void do_account(struct t_ipt_account_stat *stat, u_int8_t proto, u_=
int16_t pktlen) {
+static inline void do_account(struct t_ipt_account_stat *stat, const struc=
t sk_buff *skb) {
 =09
 	/* update packet & bytes counters in *stat structure */
-	stat->b_all +=3D pktlen;
+	stat->b_all +=3D skb->len;
 	stat->p_all++;
 =09
-	switch (proto) {
+	switch (skb->nh.iph->protocol) {
 		case IPPROTO_TCP:
-			stat->b_tcp +=3D pktlen;
+			stat->b_tcp +=3D skb->len;
 			stat->p_tcp++;
 			break;
 		case IPPROTO_UDP:
-			stat->b_udp +=3D pktlen;
+			stat->b_udp +=3D skb->len;
 			stat->p_udp++;
 			break;
 		case IPPROTO_ICMP:
-			stat->b_icmp +=3D pktlen;
+			stat->b_icmp +=3D skb->len;
 			stat->p_icmp++;
 			break;
 		default:
-			stat->b_other +=3D pktlen;
+			stat->b_other +=3D skb->len;
 			stat->p_other++;
 	}
 }
=20
+static inline void do_account_short(struct t_ipt_account_stat_short *stat,=
 const struct sk_buff *skb) {
+
+	/* update packet & bytes counters in *stat structure */
+	stat->b_all +=3D skb->len;
+	stat->p_all++;
+}
+
 static int match(const struct sk_buff *skb,
 	  const struct net_device *in,
 	  const struct net_device *out,
@@ -262,90 +560,92 @@
 	const struct t_ipt_account_info *info =3D (struct t_ipt_account_info*)mat=
chinfo;
 	struct t_ipt_account_table *table;
 	int ret;
+	unsigned long now;
=20
 	u_int32_t address;
-	u_int16_t pktlen;
-	u_int8_t proto;
 =09
-	if (debug) {
-		printk(KERN_INFO "ipt_account: match() entering.\n");
-		printk(KERN_INFO "ipt_account: match() match name =3D %s.\n", info->name=
);
-	}
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() entered.\n");
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() match name =3D %s.\n", info=
->name);
 =09
-	spin_lock(&ipt_account_tables_lock);
+	spin_lock_bh(&account_lock);
 	/* find the right table */
-	table =3D ipt_account_tables;
+	table =3D account_tables;
 	while (table && strncmp(table->name, info->name, IPT_ACCOUNT_NAME_LEN) &&=
 (table =3D table->next));
-	spin_unlock(&ipt_account_tables_lock);
+	spin_unlock_bh(&account_lock);
=20
 	if (table =3D=3D NULL) {
 		/* ups, no table with that name */
-		if (debug)
-			printk(KERN_INFO "ipt_account: match() table %s not found. Leaving.\n",=
 info->name);
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() table %s not found. Leavin=
g.\n", info->name);
 		return 0;
 	}
=20
-	if (debug)
-		printk(KERN_INFO "ipt_account: match() table found %s\n", table->name);
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() table found %s\n", table->n=
ame);
+
+	/*  lock table while updating statistics */
+	spin_lock_bh(&table->ip_list_lock);
=20
 	/* default: no match */
 	ret =3D 0;
=20
-	/* get packet protocol/length */
-	pktlen =3D skb->len;
-	proto =3D skb->nh.iph->protocol;
-
-	if (debug)
-		printk(KERN_INFO "ipt_account: match() got packet src =3D %u.%u.%u.%u, d=
st =3D %u.%u.%u.%u, proto =3D %u.\n",
-				 NIPQUAD(skb->nh.iph->saddr),
-				 NIPQUAD(skb->nh.iph->daddr),
-				 proto
-				 );
+	/* get current time */
+	now =3D jiffies;
=20
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() got packet src =3D %u.%u.%u=
.%u, dst =3D %u.%u.%u.%u, proto =3D %u.\n", NIPQUAD(skb->nh.iph->saddr), NI=
PQUAD(skb->nh.iph->daddr), skb->nh.iph->protocol);
+		=09
 	/* check whether traffic from source ip address ... */
 	address =3D ntohl(skb->nh.iph->saddr);
-=09
 	/* ... is being accounted by this table */=09
 	if (address && ((u_int32_t)(address & table->netmask) =3D=3D (u_int32_t)t=
able->network)) {	=09
-		if (debug)
-			printk(KERN_INFO "ipt_account: match() accounting packet src =3D %u.%u.=
%u.%u, proto =3D %u.\n",
-					 HIPQUAD(address),
-					 proto
-					 );
 		/* yes, account this packet */
-		spin_lock(&table->ip_list_lock);
+		dprintk(KERN_INFO "ipt_account: match() accounting packet src =3D %u.%u.=
%u.%u, proto =3D %u.\n", HIPQUAD(address), skb->nh.iph->protocol);
 		/* update counters this host */
-		do_account(&table->ip_list[(u_int32_t)(address - table->network)].src, p=
roto, pktlen);
-		/* update counters for all hosts in this table (network address) */
-		if (table->netmask !=3D INADDR_BROADCAST)
-			do_account(&table->ip_list[0].src, proto, pktlen);
-		spin_unlock(&table->ip_list_lock);
+		if (!table->shortlisting) {
+			do_account(&table->ip_list.l[address - table->network].src, skb);
+			table->ip_list.l[address - table->network].time =3D now;
+			/* update also counters for all hosts in this table (network address) */
+			if (table->netmask !=3D INADDR_BROADCAST) {
+				do_account(&table->ip_list.l[0].src, skb);
+				table->ip_list.l[0].time =3D now;
+			}
+		} else {
+			do_account_short(&table->ip_list.s[address - table->network].src, skb);
+			table->ip_list.s[address - table->network].time =3D now;
+			/* update also counters for all hosts in this table (network address) */
+			if (table->netmask !=3D INADDR_BROADCAST) {
+				do_account_short(&table->ip_list.s[0].src, skb);
+				table->ip_list.s[0].time =3D now;
+			}
+		}
 		/* yes, it's a match */
 		ret =3D 1;
 	}
=20
 	/* do the same thing with destination ip address */
 	address =3D ntohl(skb->nh.iph->daddr);
-    if (address && ((u_int32_t)(address & table->netmask) =3D=3D (u_int32_=
t)table->network)) {
-		if (debug)
-			printk(KERN_INFO "ipt_account: match() accounting packet dst =3D %u.%u.=
%u.%u, proto =3D %u.\n",
-					HIPQUAD(address),
-					proto
-					);
-		spin_lock(&table->ip_list_lock);
-		do_account(&table->ip_list[(u_int32_t)(address - table->network)].dest, =
proto, pktlen);
-		if (table->netmask !=3D INADDR_BROADCAST)
-			do_account(&table->ip_list[0].dest, proto, pktlen);
-		spin_unlock(&table->ip_list_lock);
+	if (address && ((u_int32_t)(address & table->netmask) =3D=3D (u_int32_t)t=
able->network)) {
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() accounting packet dst =3D =
%u.%u.%u.%u, proto =3D %u.\n", HIPQUAD(address), skb->nh.iph->protocol);
+		if (!table->shortlisting) {
+			do_account(&table->ip_list.l[address - table->network].dest, skb);
+			table->ip_list.l[address - table->network].time =3D now;
+			if (table->netmask !=3D INADDR_BROADCAST) {
+				do_account(&table->ip_list.l[0].dest, skb);			=09
+				table->ip_list.s[0].time =3D now;
+			}
+		} else {
+			do_account_short(&table->ip_list.s[address - table->network].dest, skb);
+			table->ip_list.s[address - table->network].time =3D now;
+			if (table->netmask !=3D INADDR_BROADCAST) {
+				do_account_short(&table->ip_list.s[0].dest, skb);
+				table->ip_list.s[0].time =3D now;
+			}
+		}
 		ret =3D 1;
-=09
 	}
-
-	if (debug)
-		printk(KERN_INFO "ipt_account: match() leaving.\n");=09
+	spin_unlock_bh(&table->ip_list_lock);
 =09
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() left.\n");=09
+
 	return ret;
-=09
 }
=20
 static int checkentry(const char *tablename,
@@ -355,149 +655,163 @@
 	       unsigned int hook_mask)
 {
 	const struct t_ipt_account_info *info =3D matchinfo;
-	struct t_ipt_account_table *table;
+	struct t_ipt_account_table *table, *find_table, *last_table;
+	int ret =3D 0;
=20
-	char proc_entry_name[IPT_ACCOUNT_NAME_LEN + 3];
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() entered.\n");
=20
-	u_int32_t hosts_count;
+	if (matchinfosize !=3D IPT_ALIGN(sizeof(struct t_ipt_account_info))) retu=
rn 0;
+	if (!info->name || !info->name[0]) return 0;
=20
-	if (debug)
-		printk(KERN_INFO "ipt_account: checkentry() entering.\n");
+	/* find whether table with this name already exists */
+	spin_lock_bh(&account_lock);
+	find_table =3D account_tables;
+	while( (last_table =3D find_table) && strncmp(info->name,find_table->name=
,IPT_ACCOUNT_NAME_LEN) && (find_table =3D find_table->next) );
+	if (find_table !=3D NULL) {
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() table %s found.\n", i=
nfo->name);	=09
+		/* if table exists, check whether table network/netmask equals rule netw=
ork/netmask */
+		if (find_table->network !=3D info->network || find_table->netmask !=3D i=
nfo->netmask || find_table->shortlisting !=3D info->shortlisting) {
+			spin_unlock_bh(&account_lock);
+			printk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() wrong parameters (not=
 equals existing table parameters).\n");
+			ret =3D 0;
+			goto failure;
+		}
+		/* increment table use count */
+		find_table->use_count++;
+		spin_unlock_bh(&account_lock);
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() incrementing use coun=
t.\n");
+		ret =3D 1;
+		goto failure;
+	}
+	spin_unlock_bh(&account_lock);
=20
-	if (matchinfosize !=3D IPT_ALIGN(sizeof(struct t_ipt_account_info)))
-		return 0;
-=09
-	if (!info->name || !info->name[0])
-		return 0;
+	/* check netmask first, before allocating memory */
+	if (info->netmask < ((1 << netmask) - 1)) {
+		printk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() too big netmask.\n");
+		ret =3D 0;
+		goto failure;
+	}
=20
-	/* find whether table with this name already exists */
-	spin_lock(&ipt_account_tables_lock);
-	table =3D ipt_account_tables;
-	while (table && strncmp(info->name, table->name, IPT_ACCOUNT_NAME_LEN) &&=
 (table =3D table->next));
-=09
-	if (table) {
-		/* yes, table exists */
-		if (info->network !=3D table->network || info->netmask !=3D table->netma=
sk) {
-			/*=20
-			 * tried to do accounting in existing table, but network/netmask in ipt=
able rule
-			 * doesn't match network/netmask in table structure - deny adding the r=
ule=20
-			 */
-			printk(KERN_ERR "ipt_account: checkentry() table %s found. But table ne=
tmask/network %u.%u.%u.%u/%u.%u.%u.%u differs from rule netmask/network %u.=
%u.%u.%u/%u.%u.%u.%u. Leaving without creating entry.\n",=20
-					table->name,
-					HIPQUAD(table->network),
-					HIPQUAD(table->netmask),
-					HIPQUAD(info->network),
-					HIPQUAD(info->netmask)
-					);
-			spin_unlock(&ipt_account_tables_lock);
-			return 0;
-		}		=09
-		if (debug)
-			printk(KERN_INFO "ipt_account: checkentry() table %s found. Incrementin=
g use count (use_count =3D %i). Leaving.\n", table->name, table->use_count);
-		/* increase table use count */	=09
-		table->use_count++;
-		spin_unlock(&ipt_account_tables_lock);
-		/* everything went okey */
-		return 1;
-	};
-=09
-	if (debug)
-		printk(KERN_INFO "ipt_account: checkentry() table %s not found. Creating=
.\n", info->name);
-=09
-	/* table doesn't exist - create one */
-	table =3D vmalloc(sizeof(struct t_ipt_account_table));
+	/* table doesn't exist - create new */
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() allocating %u for new =
table %s.\n", sizeof(struct t_ipt_account_table), info->name);
+        table =3D vmalloc(sizeof(struct t_ipt_account_table));
 	if (table =3D=3D NULL) {
-	    if (debug)
-		    printk(KERN_INFO "ipt_account: checkentry() unable to allocate memor=
y (t_account_table) for table %s. Leaving.\n", info->name);
-	    spin_unlock(&ipt_account_tables_lock);
-	    return -ENOMEM;
+		printk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() failed to allocate %u =
for new table %s.\n", sizeof(struct t_ipt_account_table), info->name);
+		ret =3D 0; /* was -ENOMEM */
+		goto failure;
 	}
 =09
-	/* set table parameters */
-	strncpy(table->name, info->name, IPT_ACCOUNT_NAME_LEN);
-	table->use_count =3D 1;=09
+	/* setup table parameters */
+	table->ip_list_lock =3D SPIN_LOCK_UNLOCKED;
+	table->next =3D NULL;
+	table->use_count =3D 1;
 	table->network =3D info->network;
 	table->netmask =3D info->netmask;
-	table->ip_list_lock =3D SPIN_LOCK_UNLOCKED;
-=09
-	hosts_count =3D INADDR_BROADCAST - table->netmask + 1;
+	table->shortlisting =3D info->shortlisting;
+	table->count =3D (~table->netmask) + 1;
+	strncpy(table->name,info->name,IPT_ACCOUNT_NAME_LEN);
+	table->name[IPT_ACCOUNT_NAME_LEN - 1] =3D '\0';
+=09
+	/* allocate memory for table->ip_list */
+	if (!table->shortlisting) {
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() allocating %u for ip_=
list.\n", sizeof(struct t_ipt_account_ip_list) * table->count);
+		table->ip_list.l =3D vmalloc(sizeof(struct t_ipt_account_ip_list) * tabl=
e->count);
+		if (table->ip_list.l =3D=3D NULL) {
+			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() failed to allocate %=
u for ip_list.\n", sizeof(struct t_ipt_account_ip_list) * table->count);
+			ret =3D 0; /* was -ENOMEM */
+			goto failure_table;
+		}
+		memset(table->ip_list.l, 0, sizeof(struct t_ipt_account_ip_list) * table=
->count);
+	} else {
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() allocating %u for ip_=
list.\n", sizeof(struct t_ipt_account_ip_list_short) * table->count);
+		table->ip_list.s =3D vmalloc(sizeof(struct t_ipt_account_ip_list_short) =
* table->count);
+		if (table->ip_list.s =3D=3D NULL) {
+			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() failed to allocate %=
u for ip_list.\n", sizeof(struct t_ipt_account_ip_list_short) * table->coun=
t);
+			ret =3D 0; /* was -ENOMEM */
+			goto failure_table;
+		}
+		memset(table->ip_list.s, 0, sizeof(struct t_ipt_account_ip_list_short) *=
 table->count);
+	}
 =09
-	if (debug)
-		printk(KERN_INFO "ipt_account: checkentry() allocating memory for %u hos=
ts (%u netmask).\n", hosts_count, info->netmask);
-
-	/* check whether table is not too big */
-	if (hosts_count > ip_list_max_hosts_count) {
-		printk(KERN_ERR "ipt_account: checkentry() unable allocate memory for %u=
 hosts (%u netmask). Increase value of ip_list_max_mask parameter.\n", host=
s_count, info->netmask);
-		vfree(table);
-		spin_unlock(&ipt_account_tables_lock);
-		return -ENOMEM;
-	}
-
-	table->ip_list =3D vmalloc(sizeof(struct t_ipt_account_ip_list) * hosts_c=
ount);
-	if (table->ip_list =3D=3D NULL) {
-	    if (debug)
-		    printk(KERN_INFO "ipt_account: checkentry() unable to allocate memor=
y (t_account_ip_list) for table %s. Leaving.\n", table->name);
-	    vfree(table);
-	    spin_unlock(&ipt_account_tables_lock);
-	    return -ENOMEM;
-	}
-
-	memset(table->ip_list, 0, sizeof(struct t_ipt_account_ip_list) * hosts_co=
unt);
-
-	/*=20
-	 * create entries in /proc/net/ipt_account: one with full 64-bit counters=
 and
-	 * second with 32-bit ones. The second can be used in programs supporting=
 only 32-bit numbers
-	 * (mrtg, rrdtool).
-	 */
-=09
-	strncpy(proc_entry_name, table->name, IPT_ACCOUNT_NAME_LEN);
-	strncat(proc_entry_name, "_64", 4);
-=09
-	table->status_proc_64 =3D create_proc_entry(proc_entry_name, ip_list_perm=
s, proc_net_ipt_account);
-	if (table->status_proc_64 =3D=3D NULL) {	   =20
-	    if (debug)
-		    printk(KERN_INFO "ipt_account: checkentry() unable to allocate memor=
y (status_proc_64) for table %s. Leaving.\n", table->name);
-	    vfree(table->ip_list);
-	    vfree(table);
-	    spin_unlock(&ipt_account_tables_lock);
-	    return -ENOMEM;
-	}
-
-	table->status_proc_64->owner =3D THIS_MODULE;
-	table->status_proc_64->read_proc =3D ip_list_read_proc_64;
-	table->status_proc_64->write_proc =3D ip_list_write_proc;
-	table->status_proc_64->data =3D table;=09
-
-	strncpy(proc_entry_name, table->name, IPT_ACCOUNT_NAME_LEN);
-	strncat(proc_entry_name, "_32", 4);
-=09
-	table->status_proc_32 =3D create_proc_entry(proc_entry_name, ip_list_perm=
s, proc_net_ipt_account);
-	if (table->status_proc_32 =3D=3D NULL) {	   =20
-	    if (debug)
-		    printk(KERN_INFO "ipt_account: checkentry() unable to allocate memor=
y (status_proc_32) for table %s. Leaving.\n", table->name);
-	    vfree(table->ip_list);
-	    vfree(table);
-	    spin_unlock(&ipt_account_tables_lock);
-	    return -ENOMEM;
-	}
-
-	table->status_proc_32->owner =3D THIS_MODULE;
-	table->status_proc_32->read_proc =3D ip_list_read_proc_32;
-	table->status_proc_32->write_proc =3D ip_list_write_proc;
-	table->status_proc_32->data =3D table;
-=09
-	/* finaly, insert table into list */
-	table->next =3D ipt_account_tables;
-	ipt_account_tables =3D table;
-
-	if (debug)
-		printk(KERN_INFO "ipt_account: checkentry() successfully created table %=
s (use_count =3D %i).\n", table->name, table->use_count);
+	/* put table into chain */
+	spin_lock_bh(&account_lock);
+	find_table =3D account_tables;
+	while( (last_table =3D find_table) && strncmp(info->name, find_table->nam=
e, IPT_ACCOUNT_NAME_LEN) && (find_table =3D find_table->next) );
+	if (find_table !=3D NULL) {
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() table %s found.\n", i=
nfo->name);
+		if (find_table->network !=3D info->network || find_table->netmask !=3D i=
nfo->netmask) {
+			spin_unlock_bh(&account_lock);
+			printk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() wrong network/netmask=
.\n");
+			ret =3D 0;
+			goto failure_ip_list;
+		}
+		find_table->use_count++;
+		spin_unlock_bh(&account_lock);
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() incrementing use coun=
t.\n");
+		ret =3D 1;
+		goto failure_ip_list;
+	}
+	if (!last_table)=20
+		account_tables =3D table;=20
+	else=20
+		last_table->next =3D table;
+	spin_unlock_bh(&account_lock);
+
+	/* create procfs status file */
+	table->status_file =3D create_proc_entry(table->name, permissions, proc_n=
et_ipt_account);
+	if (table->status_file =3D=3D NULL) {
+		ret =3D 0; /* was -ENOMEM */
+		goto failure_unlink;
+	}
+	table->status_file->owner =3D THIS_MODULE;
+	table->status_file->data =3D table;
+	wmb();
+	if (!table->shortlisting)
+		table->status_file->read_proc =3D account_proc_read;
+	else
+		table->status_file->read_proc =3D account_proc_read_short;
+	table->status_file->write_proc =3D account_proc_write;
=20
-	spin_unlock(&ipt_account_tables_lock);
-=09
-	if (debug)
-		printk(KERN_INFO "ipt_account: checkentry() leaving.\n");
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() left.\n");=09
+	/* everything went just okey */
 	return 1;
+
+	/* do cleanup in case of failure */
+failure_unlink:
+	/* remove table from list */
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() removing table.\n");
+	spin_lock_bh(&account_lock);
+	last_table =3D NULL;
+	table =3D account_tables;
+	if (table =3D=3D NULL) {
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() no table found. Leavi=
ng.\n");
+		spin_unlock_bh(&account_lock);
+		return 0; /* was -ENOMEM */
+	}
+	while (strncmp(info->name, table->name, IPT_ACCOUNT_NAME_LEN) && (last_ta=
ble =3D table) && (table =3D table->next));
+	if (table =3D=3D NULL) {
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() table already destroy=
ed. Leaving.\n");
+		spin_unlock_bh(&account_lock);
+		return 0; /* was -ENOMEM */
+	}
+	if (last_table)
+		last_table->next =3D table->next;
+	else
+		account_tables =3D table->next;
+	spin_unlock_bh(&account_lock);
+failure_ip_list:
+	/* free memory allocated for statistics table */
+	if (!table->shortlisting)
+		vfree(table->ip_list.l);
+	else
+		vfree(table->ip_list.s);
+failure_table:
+	/* free table */
+	vfree(table);
+failure:
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() left. Table not create=
d.\n");=09
+	/* failure return */
+	return ret;
 }
=20
 static void destroy(void *matchinfo,=20
@@ -505,111 +819,104 @@
 {
 	const struct t_ipt_account_info *info =3D matchinfo;
 	struct t_ipt_account_table *table, *last_table;
-	char proc_entry_name[IPT_ACCOUNT_NAME_LEN + 3];
-=09
-	if (debug)
-		printk(KERN_INFO "ipt_account: destroy() entered.\n");
-=09
-	if (matchinfosize !=3D IPT_ALIGN(sizeof(struct t_ipt_account_info)))
-		return;
=20
-	spin_lock(&ipt_account_tables_lock);
-	table =3D ipt_account_tables;
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": destory() entered.\n");
+=09
+	if (matchinfosize !=3D IPT_ALIGN(sizeof(struct t_ipt_account_info))) retu=
rn;
=20
-	if (table =3D=3D NULL) {
-		/* list is empty, sometheing is realy wrong! */
-		if (debug)
-			printk(KERN_INFO "ipt_account: destroy() unable to found any tables (as=
ked for %s). Leaving.\n", info->name);
-		spin_unlock(&ipt_account_tables_lock);
+	/* search for table */
+	spin_lock_bh(&account_lock);
+	last_table =3D NULL;
+	table =3D account_tables;
+	if(table =3D=3D NULL) {
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": destory() no tables found. Leaving=
.\n");
+		spin_unlock_bh(&account_lock);
 		return;
 	}
-=09
-	/* find table combined with this rule - this code is taken for ipt_recent=
 ;) */
-	last_table =3D NULL;
-	while (strncmp(table->name, info->name, IPT_ACCOUNT_NAME_LEN) && (last_ta=
ble =3D table) && (table =3D table->next));
-
+	while( strncmp(info->name,table->name,IPT_ACCOUNT_NAME_LEN) && (last_tabl=
e =3D table) && (table =3D table->next) );
 	if (table =3D=3D NULL) {
-		printk(KERN_ERR "ipt_account: destroy() unable to found table %s. Leavin=
g.\n", info->name);
-		spin_unlock(&ipt_account_tables_lock);
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": destory() no table %s not found. L=
eaving.\n", info->name);
+		spin_unlock_bh(&account_lock);
 		return;
 	}
=20
-	/* decrease table use counter */
+	/* decrement table use-count */
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": destory() decrementing use count.\n=
");
 	table->use_count--;
-	if (table->use_count !=3D 0) {
-		/* table is used by other rule, can't remove it */
-		if (debug)
-			printk(KERN_INFO "ipt_account: destroy() table %s is still used (use_co=
unt =3D %i). Leaving.\n", table->name, table->use_count);
-		spin_unlock(&ipt_account_tables_lock);
+	if (table->use_count) {
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": destory() table still in use. Leav=
ing.\n");
+		spin_unlock_bh(&account_lock);
 		return;
 	}
=20
-	/* table is not used by any other tule - remove it */
-	if (debug)
-		printk(KERN_INFO "ipt_account: destroy() removing table %s (use_count =
=3D %i).\n", table->name, table->use_count);
-=09
-	if (last_table)
-		last_table->next =3D table->next;
+	/* remove table if use-count is zero */
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": destory() table %s not used. Removi=
ng.\n", table->name);
+
+	/* unlink table */
+	if(last_table)=20
+		last_table->next =3D table->next;=20
+	else=20
+		account_tables =3D table->next;
+	spin_unlock_bh(&account_lock);
+
+	/* wait while table is still in use */
+	spin_lock_bh(&table->ip_list_lock);
+	spin_unlock_bh(&table->ip_list_lock);
+
+	/* remove proc entries */=09
+	remove_proc_entry(table->name, proc_net_ipt_account);
+
+	/* remove table */
+	if (!table->shortlisting)
+		vfree(table->ip_list.l);
 	else
-		ipt_account_tables =3D table->next;
-=09
-	spin_lock(&table->ip_list_lock);
-	spin_unlock(&table->ip_list_lock);
-=09
-	/* remove procfs entries */
-	strncpy(proc_entry_name, table->name, IPT_ACCOUNT_NAME_LEN);
-	strncat(proc_entry_name, "_64", 4);
-	remove_proc_entry(proc_entry_name, proc_net_ipt_account);
-	strncpy(proc_entry_name, table->name, IPT_ACCOUNT_NAME_LEN);
-	strncat(proc_entry_name, "_32", 4);
-	remove_proc_entry(proc_entry_name, proc_net_ipt_account);
-	vfree(table->ip_list);
+		vfree(table->ip_list.s);
 	vfree(table);
=20
-	spin_unlock(&ipt_account_tables_lock);
-=09
-	if (debug)
-		printk(KERN_INFO "account: destroy() leaving.\n");
-
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": destory() left.\n");
 	return;
 }
=20
 static struct ipt_match account_match =3D {
-	{ NULL, NULL },
-	"account",
-	&match,
-	&checkentry,
-	&destroy,
-	THIS_MODULE
+	.name =3D "account",
+	.match =3D &match,
+	.checkentry =3D &checkentry,
+	.destroy =3D &destroy,
+	.me =3D THIS_MODULE
 };
=20
 static int __init init(void)=20
 {
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": __init() entered.\n");
 	printk(version);=09
-	if (debug)
-		printk(KERN_INFO "account: __init(): ip_list_perms =3D %i, ip_list_max_m=
ask =3D %i\n", ip_list_perms, ip_list_max_mask);			=09
 	/* check params */
-	if (ip_list_max_mask > 32 || ip_list_max_mask < 0) {
-		printk(KERN_ERR "account: Wrong netmask given by ip_list_max_mask parame=
ter (%u). Valid is 32 to 0.\n", ip_list_max_mask);
-		return 0;
+	if (netmask > 32 || netmask < 0) {
+		printk(KERN_INFO "account: Wrong netmask given by netmask parameter (%i)=
. Valid is 32 to 0.\n", netmask);
+		return -EINVAL;
 	}
=20
-	ip_list_max_hosts_count =3D (1 << (32 - ip_list_max_mask)) + 1;
-=09
 	/* create /proc/net/ipt_account directory */
 	proc_net_ipt_account =3D proc_mkdir("ipt_account", proc_net);
-	if (!proc_net_ipt_account)
-		return -ENOMEM;
+	if (!proc_net_ipt_account) {	=09
+		printk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() failed to create procf=
s entry.\n");
+		return -EINVAL; /* was -ENOMEM */
+	}
+	proc_net_ipt_account->owner =3D THIS_MODULE;
+=09
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": __init() left.\n");
=20
 	return ipt_register_match(&account_match);
 }
=20
-/* procedura usuwaj=B1ca modu=B3 */
 static void __exit fini(void)=20
 {
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": __exit() entered.\n");
+=09
 	ipt_unregister_match(&account_match);
 	/* remove /proc/net/ipt_account/ directory */
 	remove_proc_entry("ipt_account", proc_net);
+
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": __exit() left.\n");
 }
=20
 module_init(init);
diff -uNr patch-o-matic-ng.clean/account/linux-2.6/include/linux/netfilter_=
ipv4/ipt_account.h patch-o-matic-ng.1/account/linux-2.6/include/linux/netfi=
lter_ipv4/ipt_account.h
--- patch-o-matic-ng.clean/account/linux-2.6/include/linux/netfilter_ipv4/i=
pt_account.h	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng.1/account/linux-2.6/include/linux/netfilter_ipv4/ipt_a=
ccount.h	2004-07-14 17:33:15.000000000 +0200
@@ -0,0 +1,26 @@
+/*=20
+ * accounting match (ipt_account.c)
+ * (C) 2003,2004 by Piotr Gasidlo (quaker@barbara.eu.org)
+ *
+ * Version: 0.1.6
+ *
+ * This software is distributed under the terms of GNU GPL
+ */
+
+#ifndef _IPT_ACCOUNT_H_
+#define _IPT_ACCOUNT_H_
+
+#define IPT_ACCOUNT_NAME_LEN 64
+
+#define IPT_ACCOUNT_NAME "ipt_account"
+#define IPT_ACCOUNT_VERSION  "0.1.6"
+
+struct t_ipt_account_info {
+	char name[IPT_ACCOUNT_NAME_LEN];
+	u_int32_t network;
+	u_int32_t netmask;
+	int shortlisting:1;
+};
+
+#endif
+
diff -uNr patch-o-matic-ng.clean/account/linux-2.6/net/ipv4/netfilter/Kconf=
ig.ladd patch-o-matic-ng.1/account/linux-2.6/net/ipv4/netfilter/Kconfig.ladd
--- patch-o-matic-ng.clean/account/linux-2.6/net/ipv4/netfilter/Kconfig.lad=
d	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng.1/account/linux-2.6/net/ipv4/netfilter/Kconfig.ladd	20=
04-07-16 15:39:54.000000000 +0200
@@ -0,0 +1,47 @@
+config IP_NF_MATCH_ACCOUNT
+	tristate "account match support"
+	depends on IP_NF_IPTABLES && PROC_FS
+	help
+		This match is used for accounting traffic for all hosts in
+		defined network/netmask.=20
+	=09
+		Features:
+		- long (one counter per protocol TCP/UDP/IMCP/Other) and short statistics
+		- one iptables rule for all hosts in network/netmask
+		- loading/saving counters (by reading/writting to procfs entries)
+	=09
+		Example usage:
+	=09
+		account traffic for/to 192.168.0.0/24 network into table mynetwork:
+	=09
+		# iptables -A FORWARD -m account --aname mynetwork --aaddr 192.168.0.0/24
+	=09
+		account traffic for/to WWW serwer for 192.168.0.0/24 network into table=
=20
+		  mywwwserver:
+	=09
+		# iptables -A INPUT -p tcp --dport 80=20
+		  -m account --aname mywwwserver --aaddr 192.168.0.0/24 --ashort
+		# iptables -A OUTPUT -p tcp --sport 80
+		  -m account --aname mywwwserver --aaddr 192.168.0.0/24 --ashort   =20
+		 =20
+		read counters:
+	=09
+		# cat /proc/net/ipt_account/mynetwork
+		# cat /proc/net/ipt_account/mywwwserver
+	=09
+		set counters:
+	=09
+		# echo "ip =3D 192.168.0.1 packets_src =3D 0" > /proc/net/ipt_account/my=
wwserver
+	=09
+		Webpage:=20
+		  http://www.barbara.eu.org/~quaker/ipt_account/ =20
+
+		If you want to compile it as a module, say M here and read
+		<file:Documentation/modules.txt>.  If unsure, say `N'.=09
+	=09
+config IP_NF_MATCH_ACCOUNT_DEBUG
+	bool "account debugging output"
+	depends on IP_NF_MATCH_ACCOUNT
+	help
+		Say Y to get lots of debugging output.
+
diff -uNr patch-o-matic-ng.clean/account/linux-2.6/net/ipv4/netfilter/Makef=
ile.ladd patch-o-matic-ng.1/account/linux-2.6/net/ipv4/netfilter/Makefile.l=
add
--- patch-o-matic-ng.clean/account/linux-2.6/net/ipv4/netfilter/Makefile.la=
dd	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng.1/account/linux-2.6/net/ipv4/netfilter/Makefile.ladd	2=
004-03-17 15:50:12.000000000 +0100
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP_NF_MATCH_TOS) +=3D ipt_tos.o
+obj-$(CONFIG_IP_NF_MATCH_ACCOUNT) +=3D ipt_account.o
diff -uNr patch-o-matic-ng.clean/account/linux-2.6/net/ipv4/netfilter/ipt_a=
ccount.c patch-o-matic-ng.1/account/linux-2.6/net/ipv4/netfilter/ipt_accoun=
t.c
--- patch-o-matic-ng.clean/account/linux-2.6/net/ipv4/netfilter/ipt_account=
.c	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng.1/account/linux-2.6/net/ipv4/netfilter/ipt_account.c	2=
004-07-16 14:49:58.000000000 +0200
@@ -0,0 +1,922 @@
+/*=20
+ * accounting match (ipt_account.c)
+ * (C) 2003,2004 by Piotr Gasidlo (quaker@barbara.eu.org)
+ *
+ * Version: 0.1.6
+ *
+ * This software is distributed under the terms of GNU GPL
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/proc_fs.h>
+#include <linux/spinlock.h>
+#include <linux/vmalloc.h>
+#include <linux/interrupt.h>
+#include <linux/ctype.h>
+
+#include <asm/uaccess.h>
+
+#include <linux/ip.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_account.h>
+
+#if defined(CONFIG_IP_NF_MATCH_ACCOUNT_DEBUG)
+	#define dprintk(format,args...) printk(format,##args)
+#else
+        #define dprintk(format,args...)
+#endif
+
+static char version[] =3D
+KERN_INFO IPT_ACCOUNT_NAME " " IPT_ACCOUNT_VERSION " : Piotr Gasid=B3o <qu=
aker@barbara.eu.org>, http://www.barbara.eu.org/~quaker/ipt_account/\n";
+
+/* rights for files created in /proc/net/ipt_account/ */
+static int permissions =3D 0644;
+/* maximal netmask for single table */
+static int netmask =3D 16;
+
+/* module information */
+MODULE_AUTHOR("Piotr Gasidlo <quaker@barbara.eu.org>");
+MODULE_DESCRIPTION("Traffic accounting modules");
+MODULE_LICENSE("GPL");
+MODULE_PARM(permissions,"i");
+MODULE_PARM_DESC(permissions,"permissions on /proc/net/ipt_account/* files=
");
+MODULE_PARM(netmask, "i");
+MODULE_PARM_DESC(netmask, "maximum *save* size of one list (netmask)");
+
+/* structure with statistics counters */
+struct t_ipt_account_stat {
+	u_int64_t b_all, b_tcp, b_udp, b_icmp, b_other;		/* byte counters for all=
/tcp/udp/icmp/other traffic  */
+	u_int64_t p_all, p_tcp, p_udp, p_icmp, p_other;		/* packet counters for a=
ll/tcp/udp/icmp/other traffic */
+};
+
+/* stucture with statistics counters, used when table is created with --as=
hort switch */
+struct t_ipt_account_stat_short {
+	u_int64_t b_all;					/* byte counters for all traffic */
+	u_int64_t p_all;					/* packet counters for all traffic */
+};
+=20
+/* structure holding to/from statistics for single ip */
+struct t_ipt_account_ip_list {
+	struct t_ipt_account_stat src;
+	struct t_ipt_account_stat dest;
+	unsigned long time;					/* time when this record was last updated */=09
+=09
+};
+
+/* same as above, for tables with --ashort switch */
+struct t_ipt_account_ip_list_short {
+	struct t_ipt_account_stat_short src;
+	struct t_ipt_account_stat_short dest;
+	unsigned long time;
+};
+
+/* structure describing single table */
+struct t_ipt_account_table {
+	char name[IPT_ACCOUNT_NAME_LEN];	/* table name ( =3D filename in /proc/ne=
t/ipt_account/) */
+	union {					/* table with statistics for each ip in network/netmask */
+		struct t_ipt_account_ip_list *l;
+		struct t_ipt_account_ip_list_short *s;
+	} ip_list;
+	u_int32_t network;			/* network/netmask covered by table*/
+	u_int32_t netmask;				=09
+	u_int32_t count;
+	int shortlisting:1;			/* show only total columns of counters */=09
+	int use_count;				/* rules counter - counting number of rules using this =
table */
+	struct t_ipt_account_table *next;
+	spinlock_t ip_list_lock;
+	struct proc_dir_entry *status_file;
+};
+
+/* we must use spinlocks to avoid parallel modifications of table list */
+static spinlock_t account_lock =3D SPIN_LOCK_UNLOCKED;
+
+static struct proc_dir_entry *proc_net_ipt_account =3D NULL;
+
+/* root pointer holding list of the tables */
+static struct t_ipt_account_table *account_tables =3D NULL;
+
+/* convert ascii to ip */
+int atoip(char *buffer, u_int32_t *ip) {
+
+	char *bufferptr =3D buffer;
+	int part, shift;
+=09
+	/* zero ip */
+	*ip =3D 0;
+
+	/* first must be a digit */
+	if (!isdigit(*bufferptr))
+		return 0;
+
+	/* parse first 3 octets (III.III.III.iii) */
+	for (part =3D 0, shift =3D 24; *bufferptr && shift; bufferptr++) {
+		if (isdigit(*bufferptr)) {
+			part =3D part * 10 + (*bufferptr - '0');
+			continue;
+		}
+		if (*bufferptr =3D=3D '.') {
+			if (part > 255)
+				return 0;
+			*ip |=3D part << shift;
+			shift -=3D 8;
+			part =3D 0;
+			continue;
+		}
+		return 0;
+	}
+=09
+	/* we expect more digts */
+	if (!*bufferptr)
+		return 0;
+	/* parse last octet (iii.iii.iii.III) */
+	for (; *bufferptr; bufferptr++) {
+		if (isdigit(*bufferptr)) {
+			part =3D part * 10 + (*bufferptr - '0');		=09
+			continue;
+		} else {
+			if (part > 255)
+				return 0;
+			*ip |=3D part;
+			break;
+		}
+	}
+	return (bufferptr - buffer);
+}
+
+/* convert ascii to 64bit integer */
+int atoi64(char *buffer, u_int64_t *i) {=09
+	char *bufferptr =3D buffer;
+
+	/* zero integer */
+	*i =3D 0;
+=09
+	while (isdigit(*bufferptr)) {
+		*i =3D *i * 10 + (*bufferptr - '0');
+		bufferptr++;
+	}
+	return (bufferptr - buffer);
+}
+
+static int account_proc_read(char *buffer, char **start, off_t offset,
+		int length, int *eof, void *data) {
+=09
+	int len =3D 0, last_len =3D 0;
+	off_t pos =3D 0, begin =3D 0;
+	u_int32_t address, index;=09
+	struct timespec last;
+	unsigned long now =3D jiffies;
+
+	struct t_ipt_account_table *table =3D (struct t_ipt_account_table*)data;
+=09
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_read() entered.\n");
+
+	spin_lock_bh(&table->ip_list_lock);
+	for (address =3D table->network, index =3D 0; index < table->count; addre=
ss++, index++) {
+		last_len =3D len;	=09
+		jiffies_to_timespec(now - table->ip_list.l[index].time, &last);
+		len +=3D sprintf(buffer + len,
+				"ip =3D %u.%u.%u.%u bytes_src =3D %llu %llu %llu %llu %llu packets_src=
 =3D %llu %llu %llu %llu %llu bytes_dest =3D %llu %llu %llu %llu %llu packe=
ts_dest =3D %llu %llu %llu %llu %llu time =3D %lu\n",
+				HIPQUAD(address),
+				table->ip_list.l[index].src.b_all,
+				table->ip_list.l[index].src.b_tcp,
+				table->ip_list.l[index].src.b_udp,
+				table->ip_list.l[index].src.b_icmp,
+				table->ip_list.l[index].src.b_other,
+			=09
+				table->ip_list.l[index].src.p_all,
+				table->ip_list.l[index].src.p_tcp,
+				table->ip_list.l[index].src.p_udp,
+				table->ip_list.l[index].src.p_icmp,
+				table->ip_list.l[index].src.p_other,
+			=09
+				table->ip_list.l[index].dest.b_all,
+				table->ip_list.l[index].dest.b_tcp,
+				table->ip_list.l[index].dest.b_udp,
+				table->ip_list.l[index].dest.b_icmp,
+				table->ip_list.l[index].dest.b_other,			=09
+			=09
+				table->ip_list.l[index].dest.p_all,
+				table->ip_list.l[index].dest.p_tcp,
+				table->ip_list.l[index].dest.p_udp,
+				table->ip_list.l[index].dest.p_icmp,
+				table->ip_list.l[index].dest.p_other,
+
+				last.tv_sec
+				);
+		pos =3D begin + len;
+		if (pos < offset) {
+			len =3D 0;
+			begin =3D pos;
+		}
+		if (pos > offset + length) {
+			len =3D last_len;
+			break;
+		}
+	}
+	spin_unlock_bh(&table->ip_list_lock);
+	*start =3D buffer + (offset - begin);
+	len -=3D (offset - begin);
+	if (len > length)
+		len =3D length;
+
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_read() left.\n");
+=09
+	return len;
+}
+
+static int account_proc_read_short(char *buffer, char **start, off_t offse=
t,
+		int length, int *eof, void *data) {
+=09
+	int len =3D 0, last_len =3D 0;
+	off_t pos =3D 0, begin =3D 0;
+	u_int32_t address, index;=09
+	struct timespec last;
+	unsigned long now =3D jiffies;
+
+	struct t_ipt_account_table *table =3D (struct t_ipt_account_table*)data;
+=09
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_read_short() entered.\=
n");
+
+	spin_lock_bh(&table->ip_list_lock);
+	for (address =3D table->network, index =3D 0; index < table->count; addre=
ss++, index++) {
+		last_len =3D len;	=09
+		jiffies_to_timespec(now - table->ip_list.s[index].time, &last);
+		len +=3D sprintf(buffer + len,
+				"ip =3D %u.%u.%u.%u bytes_src =3D %llu packets_src =3D %llu bytes_dest=
 =3D %llu packets_dest =3D %llu time =3D %lu\n",
+				HIPQUAD(address),
+				table->ip_list.s[index].src.b_all,
+				table->ip_list.s[index].src.p_all,
+				table->ip_list.s[index].dest.b_all,
+				table->ip_list.s[index].dest.p_all,
+				last.tv_sec
+				);
+		pos =3D begin + len;
+		if (pos < offset) {
+			len =3D 0;
+			begin =3D pos;
+		}
+		if (pos > offset + length) {
+			len =3D last_len;
+			break;
+		}
+	}
+	spin_unlock_bh(&table->ip_list_lock);
+	*start =3D buffer + (offset - begin);
+	len -=3D (offset - begin);
+	if (len > length)
+		len =3D length;
+
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_read_short() left.\n");
+=09
+	return len;
+}
+
+static int account_proc_write(struct file *file, const char *ubuffer,=20
+		unsigned long ulength, void *data) {
+
+	struct t_ipt_account_table *table =3D (struct t_ipt_account_table*)data;
+	char buffer[1024], *bufferptr;
+	int length;
+
+	u_int32_t ip;
+	int len, i;
+	struct t_ipt_account_ip_list l;
+	struct t_ipt_account_ip_list_short s;
+	u_int64_t *p, dummy;
+=09
+=09
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() entered.\n");
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() ulength =3D %l=
i.\n", ulength);
+=09
+	length =3D ulength;
+	if (ulength > 1024)
+		length =3D 1024;
+	if (copy_from_user(buffer, ubuffer, length))
+		return -EFAULT;
+	buffer[length - 1] =3D 0;
+	bufferptr =3D buffer;
+
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() buffer =3D \'%=
s\' length =3D %li.\n", buffer, length);
+=09
+	/* reset table counters */
+	if (!memcmp(buffer, "reset", 5)) {
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got \"reset\"=
.\n");
+		if (!table->shortlisting) {
+			spin_lock_bh(&table->ip_list_lock);
+			memset(table->ip_list.l, 0, sizeof(struct t_ipt_account_ip_list) * tabl=
e->count);
+			spin_unlock_bh(&table->ip_list_lock);
+		} else {
+			spin_lock_bh(&table->ip_list_lock);
+			memset(table->ip_list.s, 0, sizeof(struct t_ipt_account_ip_list_short) =
* table->count);
+			spin_unlock_bh(&table->ip_list_lock);
+		}
+		return length;
+	}
+
+	if (!memcmp(buffer, "ip", 2)) {
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got \"ip\".\n=
");
+		bufferptr +=3D 2;
+		if (!isspace(*bufferptr)) {
+			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected spa=
ce (%i).\n", bufferptr - buffer);
+			return length; /* expected space */
+		}
+		bufferptr +=3D 1;
+		if (*bufferptr !=3D '=3D') {
+			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected equ=
al (%i).\n", bufferptr - buffer);
+			return length; /* expected equal */
+		}
+		bufferptr +=3D 1;
+		if (!isspace(*bufferptr)) {
+			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected spa=
ce (%i).\n", bufferptr - buffer);
+			return length; /* expected space */
+		}
+		bufferptr +=3D 1;
+		if (!(len =3D atoip(bufferptr, &ip))) {
+			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected ip =
(%i).\n", bufferptr - buffer);
+			return length; /* expected ip */
+		}
+		bufferptr +=3D len;
+		if ((ip & table->netmask) !=3D table->network) {
+			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected ip =
[%u.%u.%u.%u] from table's network/netmask [%u.%u.%u.%u/%u.%u.%u.%u].\n", H=
IPQUAD(ip), HIPQUAD(table->network), HIPQUAD(table->netmask));
+			return length; /* expected ip from table's network/netmask */
+		}
+		if (!table->shortlisting) {
+			memset(&l, 0, sizeof(struct t_ipt_account_ip_list));
+			while(*bufferptr) {
+				if (!isspace(*bufferptr)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected s=
pace (%i).\n", bufferptr - buffer);
+					return length; /* expected space */
+				}
+				bufferptr +=3D 1;
+				if (!memcmp(bufferptr, "bytes_src", 9)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got bytes_=
src (%i).\n", bufferptr - buffer);
+					p =3D &l.src.b_all;
+					bufferptr +=3D 9;
+				} else if (!memcmp(bufferptr, "bytes_dest", 10)) {				=09
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got bytes_=
dest (%i).\n", bufferptr - buffer);
+					p =3D &l.dest.b_all;
+					bufferptr +=3D 10;
+				} else if (!memcmp(bufferptr, "packets_src", 11)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got packet=
s_src (%i).\n", bufferptr - buffer);
+					p =3D &l.src.p_all;
+					bufferptr +=3D 11;
+				} else if (!memcmp(bufferptr, "packets_dest", 12)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got packet=
s_dest (%i).\n", bufferptr - buffer);
+					p =3D &l.dest.p_all;
+					bufferptr +=3D 12;
+				} else if (!memcmp(bufferptr, "time", 4)) {
+					/* time hack, ignore time tokens */
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got time (=
%i).\n", bufferptr - buffer);
+					bufferptr +=3D 4;
+					if (!isspace(*bufferptr)) {
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected =
space (%i).\n", bufferptr - buffer);
+						return length; /* expected space */
+					}
+					bufferptr +=3D 1;
+					if (*bufferptr !=3D '=3D') {
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected =
equal (%i).\n", bufferptr - buffer);
+						return length; /* expected equal */
+					}
+					bufferptr +=3D 1;
+					if (!isspace(*bufferptr)) {
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected =
space (%i).\n", bufferptr - buffer);
+						return length; /* expected space */
+					}
+					bufferptr +=3D 1;
+					if (!(len =3D atoi64(bufferptr, &dummy))) {
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected =
int64 (%i).\n", bufferptr - buffer);
+						return length; /* expected int64 */
+					}
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got %llu (=
%i).\n", dummy, bufferptr - buffer);
+					bufferptr +=3D len;
+					continue; /* skip time token */
+				} else
+					return length;	/* expected token */
+				if (!isspace(*bufferptr)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected s=
pace (%i).\n", bufferptr - buffer);
+					return length; /* expected space */
+				}
+				bufferptr +=3D 1;
+				if (*bufferptr !=3D '=3D') {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected e=
qual (%i).\n", bufferptr - buffer);
+					return length; /* expected equal */
+				}
+				bufferptr +=3D 1;
+				for (i =3D 0; i < 5; i++) {
+					if (!isspace(*bufferptr)) {
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected =
space (%i).\n", bufferptr - buffer);
+						return length; /* expected space */
+					}
+					bufferptr +=3D 1;
+					if (!(len =3D atoi64(bufferptr, p))) {
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected =
int64 (%i).\n", bufferptr - buffer);
+						return length; /* expected int64 */
+					}
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got %llu (=
%i).\n", *p, bufferptr - buffer);
+					bufferptr +=3D len;
+					p++;
+				}
+			}
+			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() updating row=
.\n");
+			spin_lock_bh(&table->ip_list_lock);
+			/* update counters, do not overwrite time field */
+			memcpy(&table->ip_list.l[ip - table->network], &l, sizeof(struct t_ipt_=
account_ip_list) - sizeof(unsigned long));
+			spin_unlock_bh(&table->ip_list_lock);
+		} else {
+			memset(&s, 0, sizeof(struct t_ipt_account_ip_list_short));
+			while(*bufferptr) {
+				if (!isspace(*bufferptr)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected s=
pace (%i).\n", bufferptr - buffer);
+					return length; /* expected space */
+				}
+				bufferptr +=3D 1;
+				if (!memcmp(bufferptr, "bytes_src", 9)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got bytes_=
src (%i).\n", bufferptr - buffer);
+					p =3D &s.src.b_all;
+					bufferptr +=3D 9;
+				} else if (!memcmp(bufferptr, "bytes_dest", 10)) {				=09
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got bytes_=
dest (%i).\n", bufferptr - buffer);
+					p =3D &s.dest.b_all;
+					bufferptr +=3D 10;
+				} else if (!memcmp(bufferptr, "packets_src", 11)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got packet=
s_src (%i).\n", bufferptr - buffer);
+					p =3D &s.src.p_all;
+					bufferptr +=3D 11;
+				} else if (!memcmp(bufferptr, "packets_dest", 12)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got packet=
s_dest (%i).\n", bufferptr - buffer);
+					p =3D &s.dest.p_all;
+					bufferptr +=3D 12;
+				} else if (!memcmp(bufferptr, "time", 4)) {
+					/* time hack, ignore time tokens */
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got time (=
%i).\n", bufferptr - buffer);
+					bufferptr +=3D 4;
+					if (!isspace(*bufferptr)) {
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected =
space (%i).\n", bufferptr - buffer);
+						return length; /* expected space */
+					}
+					bufferptr +=3D 1;
+					if (*bufferptr !=3D '=3D') {
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected =
equal (%i).\n", bufferptr - buffer);
+						return length; /* expected equal */
+					}
+					bufferptr +=3D 1;
+					if (!isspace(*bufferptr)) {
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected =
space (%i).\n", bufferptr - buffer);
+						return length; /* expected space */
+					}
+					bufferptr +=3D 1;
+					if (!(len =3D atoi64(bufferptr, &dummy))) {
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected =
int64 (%i).\n", bufferptr - buffer);
+						return length; /* expected int64 */
+					}
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got %llu (=
%i).\n", dummy, bufferptr - buffer);
+					bufferptr +=3D len;
+					continue; /* skip time token */
+				} else {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected t=
oken (%i).\n", bufferptr - buffer);
+					return length;	/* expected token */
+				}
+				if (!isspace(*bufferptr)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected s=
pace (%i).\n", bufferptr - buffer);
+					return length; /* expected space */
+				}
+				bufferptr +=3D 1;
+				if (*bufferptr !=3D '=3D') {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected e=
qual (%i).\n", bufferptr - buffer);
+					return length; /* expected equal */
+				}
+				bufferptr +=3D 1;
+				if (!isspace(*bufferptr)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected s=
pace (%i).\n", bufferptr - buffer);
+					return length; /* expected space */
+				}
+				bufferptr +=3D 1;
+				if (!(len =3D atoi64(bufferptr, p))) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected i=
nt64 (%i).\n", bufferptr - buffer);
+					return length; /* expected int64 */
+				}
+				dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got %llu (%=
i).\n", *p, bufferptr - buffer);
+				bufferptr +=3D len;
+			}
+			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() updating row=
.\n");
+			spin_lock_bh(&table->ip_list_lock);
+			/* update counters, do not overwrite time field */
+			memcpy(&table->ip_list.s[ip - table->network], &s, sizeof(struct t_ipt_=
account_ip_list_short) - sizeof(unsigned long));
+			spin_unlock_bh(&table->ip_list_lock);
+		}
+	}
+=09
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() left.\n");
+	return length;
+}
+
+/* do raw accounting */
+static inline void do_account(struct t_ipt_account_stat *stat, const struc=
t sk_buff *skb) {
+=09
+	/* update packet & bytes counters in *stat structure */
+	stat->b_all +=3D skb->len;
+	stat->p_all++;
+=09
+	switch (skb->nh.iph->protocol) {
+		case IPPROTO_TCP:
+			stat->b_tcp +=3D skb->len;
+			stat->p_tcp++;
+			break;
+		case IPPROTO_UDP:
+			stat->b_udp +=3D skb->len;
+			stat->p_udp++;
+			break;
+		case IPPROTO_ICMP:
+			stat->b_icmp +=3D skb->len;
+			stat->p_icmp++;
+			break;
+		default:
+			stat->b_other +=3D skb->len;
+			stat->p_other++;
+	}
+}
+
+static inline void do_account_short(struct t_ipt_account_stat_short *stat,=
 const struct sk_buff *skb) {
+
+	/* update packet & bytes counters in *stat structure */
+	stat->b_all +=3D skb->len;
+	stat->p_all++;
+}
+
+static int match(const struct sk_buff *skb,
+	  const struct net_device *in,
+	  const struct net_device *out,
+	  const void *matchinfo,
+	  int offset,
+	  int *hotdrop)
+{
+=09
+	const struct t_ipt_account_info *info =3D (struct t_ipt_account_info*)mat=
chinfo;
+	struct t_ipt_account_table *table;
+	int ret;
+	unsigned long now;
+
+	u_int32_t address;
+=09
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() entered.\n");
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() match name =3D %s.\n", info=
->name);
+=09
+	spin_lock_bh(&account_lock);
+	/* find the right table */
+	table =3D account_tables;
+	while (table && strncmp(table->name, info->name, IPT_ACCOUNT_NAME_LEN) &&=
 (table =3D table->next));
+	spin_unlock_bh(&account_lock);
+
+	if (table =3D=3D NULL) {
+		/* ups, no table with that name */
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() table %s not found. Leavin=
g.\n", info->name);
+		return 0;
+	}
+
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() table found %s\n", table->n=
ame);
+
+	/*  lock table while updating statistics */
+	spin_lock_bh(&table->ip_list_lock);
+
+	/* default: no match */
+	ret =3D 0;
+
+	/* get current time */
+	now =3D jiffies;
+
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() got packet src =3D %u.%u.%u=
.%u, dst =3D %u.%u.%u.%u, proto =3D %u.\n", NIPQUAD(skb->nh.iph->saddr), NI=
PQUAD(skb->nh.iph->daddr), skb->nh.iph->protocol);
+		=09
+	/* check whether traffic from source ip address ... */
+	address =3D ntohl(skb->nh.iph->saddr);
+	/* ... is being accounted by this table */=09
+	if (address && ((u_int32_t)(address & table->netmask) =3D=3D (u_int32_t)t=
able->network)) {	=09
+		/* yes, account this packet */
+		dprintk(KERN_INFO "ipt_account: match() accounting packet src =3D %u.%u.=
%u.%u, proto =3D %u.\n", HIPQUAD(address), skb->nh.iph->protocol);
+		/* update counters this host */
+		if (!table->shortlisting) {
+			do_account(&table->ip_list.l[address - table->network].src, skb);
+			table->ip_list.l[address - table->network].time =3D now;
+			/* update also counters for all hosts in this table (network address) */
+			if (table->netmask !=3D INADDR_BROADCAST) {
+				do_account(&table->ip_list.l[0].src, skb);
+				table->ip_list.l[0].time =3D now;
+			}
+		} else {
+			do_account_short(&table->ip_list.s[address - table->network].src, skb);
+			table->ip_list.s[address - table->network].time =3D now;
+			/* update also counters for all hosts in this table (network address) */
+			if (table->netmask !=3D INADDR_BROADCAST) {
+				do_account_short(&table->ip_list.s[0].src, skb);
+				table->ip_list.s[0].time =3D now;
+			}
+		}
+		/* yes, it's a match */
+		ret =3D 1;
+	}
+
+	/* do the same thing with destination ip address */
+	address =3D ntohl(skb->nh.iph->daddr);
+	if (address && ((u_int32_t)(address & table->netmask) =3D=3D (u_int32_t)t=
able->network)) {
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() accounting packet dst =3D =
%u.%u.%u.%u, proto =3D %u.\n", HIPQUAD(address), skb->nh.iph->protocol);
+		if (!table->shortlisting) {
+			do_account(&table->ip_list.l[address - table->network].dest, skb);
+			table->ip_list.l[address - table->network].time =3D now;
+			if (table->netmask !=3D INADDR_BROADCAST) {
+				do_account(&table->ip_list.l[0].dest, skb);			=09
+				table->ip_list.s[0].time =3D now;
+			}
+		} else {
+			do_account_short(&table->ip_list.s[address - table->network].dest, skb);
+			table->ip_list.s[address - table->network].time =3D now;
+			if (table->netmask !=3D INADDR_BROADCAST) {
+				do_account_short(&table->ip_list.s[0].dest, skb);
+				table->ip_list.s[0].time =3D now;
+			}
+		}
+		ret =3D 1;
+	}
+	spin_unlock_bh(&table->ip_list_lock);
+=09
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": match() left.\n");=09
+
+	return ret;
+}
+
+static int checkentry(const char *tablename,
+	       const struct ipt_ip *ip,
+	       void *matchinfo,
+	       unsigned int matchinfosize,
+	       unsigned int hook_mask)
+{
+	const struct t_ipt_account_info *info =3D matchinfo;
+	struct t_ipt_account_table *table, *find_table, *last_table;
+	int ret =3D 0;
+
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() entered.\n");
+
+	if (matchinfosize !=3D IPT_ALIGN(sizeof(struct t_ipt_account_info))) retu=
rn 0;
+	if (!info->name || !info->name[0]) return 0;
+
+	/* find whether table with this name already exists */
+	spin_lock_bh(&account_lock);
+	find_table =3D account_tables;
+	while( (last_table =3D find_table) && strncmp(info->name,find_table->name=
,IPT_ACCOUNT_NAME_LEN) && (find_table =3D find_table->next) );
+	if (find_table !=3D NULL) {
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() table %s found.\n", i=
nfo->name);	=09
+		/* if table exists, check whether table network/netmask equals rule netw=
ork/netmask */
+		if (find_table->network !=3D info->network || find_table->netmask !=3D i=
nfo->netmask || find_table->shortlisting !=3D info->shortlisting) {
+			spin_unlock_bh(&account_lock);
+			printk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() wrong parameters (not=
 equals existing table parameters).\n");
+			ret =3D 0;
+			goto failure;
+		}
+		/* increment table use count */
+		find_table->use_count++;
+		spin_unlock_bh(&account_lock);
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() incrementing use coun=
t.\n");
+		ret =3D 1;
+		goto failure;
+	}
+	spin_unlock_bh(&account_lock);
+
+	/* check netmask first, before allocating memory */
+	if (info->netmask < ((1 << netmask) - 1)) {
+		printk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() too big netmask.\n");
+		ret =3D 0;
+		goto failure;
+	}
+
+	/* table doesn't exist - create new */
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() allocating %u for new =
table %s.\n", sizeof(struct t_ipt_account_table), info->name);
+        table =3D vmalloc(sizeof(struct t_ipt_account_table));
+	if (table =3D=3D NULL) {
+		printk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() failed to allocate %u =
for new table %s.\n", sizeof(struct t_ipt_account_table), info->name);
+		ret =3D 0; /* was -ENOMEM */
+		goto failure;
+	}
+=09
+	/* setup table parameters */
+	table->ip_list_lock =3D SPIN_LOCK_UNLOCKED;
+	table->next =3D NULL;
+	table->use_count =3D 1;
+	table->network =3D info->network;
+	table->netmask =3D info->netmask;
+	table->shortlisting =3D info->shortlisting;
+	table->count =3D (~table->netmask) + 1;
+	strncpy(table->name,info->name,IPT_ACCOUNT_NAME_LEN);
+	table->name[IPT_ACCOUNT_NAME_LEN - 1] =3D '\0';
+=09
+	/* allocate memory for table->ip_list */
+	if (!table->shortlisting) {
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() allocating %u for ip_=
list.\n", sizeof(struct t_ipt_account_ip_list) * table->count);
+		table->ip_list.l =3D vmalloc(sizeof(struct t_ipt_account_ip_list) * tabl=
e->count);
+		if (table->ip_list.l =3D=3D NULL) {
+			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() failed to allocate %=
u for ip_list.\n", sizeof(struct t_ipt_account_ip_list) * table->count);
+			ret =3D 0; /* was -ENOMEM */
+			goto failure_table;
+		}
+		memset(table->ip_list.l, 0, sizeof(struct t_ipt_account_ip_list) * table=
->count);
+	} else {
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() allocating %u for ip_=
list.\n", sizeof(struct t_ipt_account_ip_list_short) * table->count);
+		table->ip_list.s =3D vmalloc(sizeof(struct t_ipt_account_ip_list_short) =
* table->count);
+		if (table->ip_list.s =3D=3D NULL) {
+			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() failed to allocate %=
u for ip_list.\n", sizeof(struct t_ipt_account_ip_list_short) * table->coun=
t);
+			ret =3D 0; /* was -ENOMEM */
+			goto failure_table;
+		}
+		memset(table->ip_list.s, 0, sizeof(struct t_ipt_account_ip_list_short) *=
 table->count);
+	}
+=09
+	/* put table into chain */
+	spin_lock_bh(&account_lock);
+	find_table =3D account_tables;
+	while( (last_table =3D find_table) && strncmp(info->name, find_table->nam=
e, IPT_ACCOUNT_NAME_LEN) && (find_table =3D find_table->next) );
+	if (find_table !=3D NULL) {
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() table %s found.\n", i=
nfo->name);
+		if (find_table->network !=3D info->network || find_table->netmask !=3D i=
nfo->netmask) {
+			spin_unlock_bh(&account_lock);
+			printk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() wrong network/netmask=
.\n");
+			ret =3D 0;
+			goto failure_ip_list;
+		}
+		find_table->use_count++;
+		spin_unlock_bh(&account_lock);
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() incrementing use coun=
t.\n");
+		ret =3D 1;
+		goto failure_ip_list;
+	}
+	if (!last_table)=20
+		account_tables =3D table;=20
+	else=20
+		last_table->next =3D table;
+	spin_unlock_bh(&account_lock);
+
+	/* create procfs status file */
+	table->status_file =3D create_proc_entry(table->name, permissions, proc_n=
et_ipt_account);
+	if (table->status_file =3D=3D NULL) {
+		ret =3D 0; /* was -ENOMEM */
+		goto failure_unlink;
+	}
+	table->status_file->owner =3D THIS_MODULE;
+	table->status_file->data =3D table;
+	wmb();
+	if (!table->shortlisting)
+		table->status_file->read_proc =3D account_proc_read;
+	else
+		table->status_file->read_proc =3D account_proc_read_short;
+	table->status_file->write_proc =3D account_proc_write;
+
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() left.\n");=09
+	/* everything went just okey */
+	return 1;
+
+	/* do cleanup in case of failure */
+failure_unlink:
+	/* remove table from list */
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() removing table.\n");
+	spin_lock_bh(&account_lock);
+	last_table =3D NULL;
+	table =3D account_tables;
+	if (table =3D=3D NULL) {
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() no table found. Leavi=
ng.\n");
+		spin_unlock_bh(&account_lock);
+		return 0; /* was -ENOMEM */
+	}
+	while (strncmp(info->name, table->name, IPT_ACCOUNT_NAME_LEN) && (last_ta=
ble =3D table) && (table =3D table->next));
+	if (table =3D=3D NULL) {
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() table already destroy=
ed. Leaving.\n");
+		spin_unlock_bh(&account_lock);
+		return 0; /* was -ENOMEM */
+	}
+	if (last_table)
+		last_table->next =3D table->next;
+	else
+		account_tables =3D table->next;
+	spin_unlock_bh(&account_lock);
+failure_ip_list:
+	/* free memory allocated for statistics table */
+	if (!table->shortlisting)
+		vfree(table->ip_list.l);
+	else
+		vfree(table->ip_list.s);
+failure_table:
+	/* free table */
+	vfree(table);
+failure:
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() left. Table not create=
d.\n");=09
+	/* failure return */
+	return ret;
+}
+
+static void destroy(void *matchinfo,=20
+	     unsigned int matchinfosize)
+{
+	const struct t_ipt_account_info *info =3D matchinfo;
+	struct t_ipt_account_table *table, *last_table;
+
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": destory() entered.\n");
+=09
+	if (matchinfosize !=3D IPT_ALIGN(sizeof(struct t_ipt_account_info))) retu=
rn;
+
+	/* search for table */
+	spin_lock_bh(&account_lock);
+	last_table =3D NULL;
+	table =3D account_tables;
+	if(table =3D=3D NULL) {
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": destory() no tables found. Leaving=
.\n");
+		spin_unlock_bh(&account_lock);
+		return;
+	}
+	while( strncmp(info->name,table->name,IPT_ACCOUNT_NAME_LEN) && (last_tabl=
e =3D table) && (table =3D table->next) );
+	if (table =3D=3D NULL) {
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": destory() no table %s not found. L=
eaving.\n", info->name);
+		spin_unlock_bh(&account_lock);
+		return;
+	}
+
+	/* decrement table use-count */
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": destory() decrementing use count.\n=
");
+	table->use_count--;
+	if (table->use_count) {
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": destory() table still in use. Leav=
ing.\n");
+		spin_unlock_bh(&account_lock);
+		return;
+	}
+
+	/* remove table if use-count is zero */
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": destory() table %s not used. Removi=
ng.\n", table->name);
+
+	/* unlink table */
+	if(last_table)=20
+		last_table->next =3D table->next;=20
+	else=20
+		account_tables =3D table->next;
+	spin_unlock_bh(&account_lock);
+
+	/* wait while table is still in use */
+	spin_lock_bh(&table->ip_list_lock);
+	spin_unlock_bh(&table->ip_list_lock);
+
+	/* remove proc entries */=09
+	remove_proc_entry(table->name, proc_net_ipt_account);
+
+	/* remove table */
+	if (!table->shortlisting)
+		vfree(table->ip_list.l);
+	else
+		vfree(table->ip_list.s);
+	vfree(table);
+
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": destory() left.\n");
+	return;
+}
+
+static struct ipt_match account_match =3D {
+	.name =3D "account",
+	.match =3D &match,
+	.checkentry =3D &checkentry,
+	.destroy =3D &destroy,
+	.me =3D THIS_MODULE
+};
+
+static int __init init(void)=20
+{
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": __init() entered.\n");
+	printk(version);=09
+	/* check params */
+	if (netmask > 32 || netmask < 0) {
+		printk(KERN_INFO "account: Wrong netmask given by netmask parameter (%i)=
. Valid is 32 to 0.\n", netmask);
+		return -EINVAL;
+	}
+
+	/* create /proc/net/ipt_account directory */
+	proc_net_ipt_account =3D proc_mkdir("ipt_account", proc_net);
+	if (!proc_net_ipt_account) {	=09
+		printk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() failed to create procf=
s entry.\n");
+		return -EINVAL; /* was -ENOMEM */
+	}
+	proc_net_ipt_account->owner =3D THIS_MODULE;
+=09
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": __init() left.\n");
+
+	return ipt_register_match(&account_match);
+}
+
+static void __exit fini(void)=20
+{
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": __exit() entered.\n");
+=09
+	ipt_unregister_match(&account_match);
+	/* remove /proc/net/ipt_account/ directory */
+	remove_proc_entry("ipt_account", proc_net);
+
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": __exit() left.\n");
+}
+
+module_init(init);
+module_exit(fini);
+

--nFreZHaLTZJo0R7j--

--=_pandora.barbara.ds.polsl.gliwice.pl-21745-1089986174-0001-2
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQFA9959gEmu6PNADqoRArG/AKCFIjx0V0NNylqoitSsUWusI+z0sACfXxOV
2TwvSwPBfehD9eou5uOR3mk=
=zE7U
-----END PGP SIGNATURE-----

--=_pandora.barbara.ds.polsl.gliwice.pl-21745-1089986174-0001-2--
