From: "Piotr =?iso-8859-2?Q?Gasid=B3o?="
	<quaker@pandora.barbara.ds.polsl.gliwice.pl>
Subject: [PATCH] account match seq_file update [RESEND of RESEND]
Date: Sun, 26 Sep 2004 12:02:02 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040926100202.GA8843@barbara.eu.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=_pandora.barbara.ds.polsl.gliwice.pl-23540-1096192923-0001-2"
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
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_pandora.barbara.ds.polsl.gliwice.pl-23540-1096192923-0001-2
Content-Type: multipart/mixed; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

This is fourth try to send this patch. Last three mails were not
noticed on group :/

Changes (0.1.16 to 0.1.17):
- use of seq_file API in /proc/net/ipt_account/*
- code cleanup

Patch includes updates for both 2.4 and 2.6.

Please apply.

--=20
Piotr 'QuakeR' Gasid=B3o, BOFH @ pandora.barbara.eu.org
############## sending lusers to /dev/null since 1998
##### Waiting for tomorrow, for a little ray of light
### Waiting for tomorrow just to see your smile again

--wac7ysb48OaltWcw
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename="ipt_account-0.1.17.diff"
Content-Transfer-Encoding: quoted-printable

diff -uNr patch-o-matic-ng.orig/account/linux/Documentation/Configure.help.=
ladd patch-o-matic-ng/account/linux/Documentation/Configure.help.ladd
--- patch-o-matic-ng.orig/account/linux/Documentation/Configure.help.ladd	1=
970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/account/linux/Documentation/Configure.help.ladd	2004-0=
8-27 16:59:25.000000000 +0200
@@ -0,0 +1,44 @@
+CONFIG_IP_NF_MATCH_TOS
+account match support
+CONFIG_IP_NF_MATCH_ACCOUNT
+  This match is used for accounting traffic for all hosts in
+  defined network/netmask.=20
+ =20
+  Features:
+  - long (one counter per protocol TCP/UDP/IMCP/Other) and short statistics
+  - one iptables rule for all hosts in network/netmask
+  - loading/saving counters (by reading/writting to procfs entries)
+ =20
+  Example usage:
+ =20
+  account traffic for/to 192.168.0.0/24 network into table mynetwork:
+ =20
+  # iptables -A FORWARD -m account --aname mynetwork --aaddr 192.168.0.0/24
+ =20
+  account traffic for/to WWW serwer for 192.168.0.0/24 network into table=
=20
+  mywwwserver:
+ =20
+  # iptables -A INPUT -p tcp --dport 80=20
+    -m account --aname mywwwserver --aaddr 192.168.0.0/24 --ashort
+  # iptables -A OUTPUT -p tcp --sport 80
+    -m account --aname mywwwserver --aaddr 192.168.0.0/24 --ashort   =20
+ =20
+  read counters:
+ =20
+  # cat /proc/net/ipt_account/mynetwork
+  # cat /proc/net/ipt_account/mywwwserver
+ =20
+  set counters:
+ =20
+  # echo "ip =3D 192.168.0.1 packets_src =3D 0" > /proc/net/ipt_account/my=
wwserver
+ =20
+  Webpage:=20
+    http://www.barbara.eu.org/~quaker/ipt_account/   =20
+=20
+  If you want to compile it as a module, say M here and read
+  Documentation/modules.txt.  If unsure, say `N'.
+
+account debugging output
+CONFIG_IP_NF_MATCH_ACCOUNT_DEBUG
+  Say Y to get lots of debugging output.
+
diff -uNr patch-o-matic-ng.orig/account/linux/include/linux/netfilter_ipv4/=
ipt_account.h patch-o-matic-ng/account/linux/include/linux/netfilter_ipv4/i=
pt_account.h
--- patch-o-matic-ng.orig/account/linux/include/linux/netfilter_ipv4/ipt_ac=
count.h	2004-09-15 14:01:27.000000000 +0200
+++ patch-o-matic-ng/account/linux/include/linux/netfilter_ipv4/ipt_account=
=2Eh	2004-09-07 12:12:08.000000000 +0200
@@ -2,7 +2,7 @@
  * accounting match (ipt_account.c)
  * (C) 2003,2004 by Piotr Gasidlo (quaker@barbara.eu.org)
  *
- * Version: 0.1.6
+ * Version: 0.1.7
  *
  * This software is distributed under the terms of GNU GPL
  */
@@ -13,7 +13,7 @@
 #define IPT_ACCOUNT_NAME_LEN 64
=20
 #define IPT_ACCOUNT_NAME "ipt_account"
-#define IPT_ACCOUNT_VERSION  "0.1.6"
+#define IPT_ACCOUNT_VERSION  "0.1.7"
=20
 struct t_ipt_account_info {
 	char name[IPT_ACCOUNT_NAME_LEN];
diff -uNr patch-o-matic-ng.orig/account/linux/net/ipv4/netfilter/ipt_accoun=
t.c patch-o-matic-ng/account/linux/net/ipv4/netfilter/ipt_account.c
--- patch-o-matic-ng.orig/account/linux/net/ipv4/netfilter/ipt_account.c	20=
04-09-15 14:01:27.000000000 +0200
+++ patch-o-matic-ng/account/linux/net/ipv4/netfilter/ipt_account.c	2004-09=
-07 12:11:48.000000000 +0200
@@ -2,7 +2,7 @@
  * accounting match (ipt_account.c)
  * (C) 2003,2004 by Piotr Gasidlo (quaker@barbara.eu.org)
  *
- * Version: 0.1.6
+ * Version: 0.1.7
  *
  * This software is distributed under the terms of GNU GPL
  */
@@ -15,6 +15,8 @@
 #include <linux/interrupt.h>
 #include <linux/ctype.h>
=20
+#include <linux/seq_file.h>
+
 #include <asm/uaccess.h>
=20
 #include <linux/ip.h>
@@ -161,124 +163,53 @@
 	return (bufferptr - buffer);
 }
=20
-static int account_proc_read(char *buffer, char **start, off_t offset,
-		int length, int *eof, void *data) {
-=09
-	int len =3D 0, last_len =3D 0;
-	off_t pos =3D 0, begin =3D 0;
-	u_int32_t address, index;=09
-	struct timespec last;
-	unsigned long now =3D jiffies;
+static void *account_seq_start(struct seq_file *s, loff_t *pos)
+{
+	struct proc_dir_entry *pde =3D s->private;
+	struct t_ipt_account_table *table =3D pde->data;
=20
-	struct t_ipt_account_table *table =3D (struct t_ipt_account_table*)data;
+	unsigned int *bucket;
 =09
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_read() entered.\n");
-
 	spin_lock_bh(&table->ip_list_lock);
-	for (address =3D table->network, index =3D 0; index < table->count; addre=
ss++, index++) {
-		last_len =3D len;	=09
-		jiffies_to_timespec(now - table->ip_list.l[index].time, &last);
-		len +=3D sprintf(buffer + len,
-				"ip =3D %u.%u.%u.%u bytes_src =3D %llu %llu %llu %llu %llu packets_src=
 =3D %llu %llu %llu %llu %llu bytes_dest =3D %llu %llu %llu %llu %llu packe=
ts_dest =3D %llu %llu %llu %llu %llu time =3D %lu\n",
-				HIPQUAD(address),
-				table->ip_list.l[index].src.b_all,
-				table->ip_list.l[index].src.b_tcp,
-				table->ip_list.l[index].src.b_udp,
-				table->ip_list.l[index].src.b_icmp,
-				table->ip_list.l[index].src.b_other,
-			=09
-				table->ip_list.l[index].src.p_all,
-				table->ip_list.l[index].src.p_tcp,
-				table->ip_list.l[index].src.p_udp,
-				table->ip_list.l[index].src.p_icmp,
-				table->ip_list.l[index].src.p_other,
-			=09
-				table->ip_list.l[index].dest.b_all,
-				table->ip_list.l[index].dest.b_tcp,
-				table->ip_list.l[index].dest.b_udp,
-				table->ip_list.l[index].dest.b_icmp,
-				table->ip_list.l[index].dest.b_other,			=09
-			=09
-				table->ip_list.l[index].dest.p_all,
-				table->ip_list.l[index].dest.p_tcp,
-				table->ip_list.l[index].dest.p_udp,
-				table->ip_list.l[index].dest.p_icmp,
-				table->ip_list.l[index].dest.p_other,
-
-				last.tv_sec
-				);
-		pos =3D begin + len;
-		if (pos < offset) {
-			len =3D 0;
-			begin =3D pos;
-		}
-		if (pos > offset + length) {
-			len =3D last_len;
-			break;
-		}
-	}
-	spin_unlock_bh(&table->ip_list_lock);
-	*start =3D buffer + (offset - begin);
-	len -=3D (offset - begin);
-	if (len > length)
-		len =3D length;
+	if (*pos >=3D table->count)
+		return NULL;
=20
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_read() left.\n");
-=09
-	return len;
+	bucket =3D kmalloc(sizeof(unsigned int), GFP_KERNEL);
+	if (!bucket)
+		return ERR_PTR(-ENOMEM);
+	*bucket =3D *pos;
+	return bucket;
 }
=20
-static int account_proc_read_short(char *buffer, char **start, off_t offse=
t,
-		int length, int *eof, void *data) {
+static void *account_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	struct proc_dir_entry *pde =3D s->private;
+	struct t_ipt_account_table *table =3D pde->data;
 =09
-	int len =3D 0, last_len =3D 0;
-	off_t pos =3D 0, begin =3D 0;
-	u_int32_t address, index;=09
-	struct timespec last;
-	unsigned long now =3D jiffies;
-
-	struct t_ipt_account_table *table =3D (struct t_ipt_account_table*)data;
+	unsigned int *bucket =3D (unsigned int *)v;
 =09
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_read_short() entered.\=
n");
-
-	spin_lock_bh(&table->ip_list_lock);
-	for (address =3D table->network, index =3D 0; index < table->count; addre=
ss++, index++) {
-		last_len =3D len;	=09
-		jiffies_to_timespec(now - table->ip_list.s[index].time, &last);
-		len +=3D sprintf(buffer + len,
-				"ip =3D %u.%u.%u.%u bytes_src =3D %llu packets_src =3D %llu bytes_dest=
 =3D %llu packets_dest =3D %llu time =3D %lu\n",
-				HIPQUAD(address),
-				table->ip_list.s[index].src.b_all,
-				table->ip_list.s[index].src.p_all,
-				table->ip_list.s[index].dest.b_all,
-				table->ip_list.s[index].dest.p_all,
-				last.tv_sec
-				);
-		pos =3D begin + len;
-		if (pos < offset) {
-			len =3D 0;
-			begin =3D pos;
-		}
-		if (pos > offset + length) {
-			len =3D last_len;
-			break;
-		}
+	*pos =3D ++(*bucket);
+	if (*pos >=3D table->count) {
+		kfree(v);
+		return NULL;
 	}
-	spin_unlock_bh(&table->ip_list_lock);
-	*start =3D buffer + (offset - begin);
-	len -=3D (offset - begin);
-	if (len > length)
-		len =3D length;
-
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_read_short() left.\n");
-=09
-	return len;
+	return bucket;
 }
=20
-static int account_proc_write(struct file *file, const char *ubuffer,=20
-		unsigned long ulength, void *data) {
+static void account_seq_stop(struct seq_file *s, void *v)
+{
+	struct proc_dir_entry *pde =3D s->private;
+	struct t_ipt_account_table *table =3D pde->data;
+	unsigned int *bucket =3D (unsigned int *)v;
+	kfree(bucket);
+	spin_unlock_bh(&table->ip_list_lock);
+}
=20
-	struct t_ipt_account_table *table =3D (struct t_ipt_account_table*)data;
+static int account_seq_write(struct file *file, const char *ubuffer,=20
+		size_t ulength, loff_t *pos)
+{
+	struct proc_dir_entry *pde =3D ((struct seq_file *)file->private_data)->p=
rivate;
+	struct t_ipt_account_table *table =3D pde->data;
 	char buffer[1024], *bufferptr;
 	int length;
=20
@@ -289,8 +220,8 @@
 	u_int64_t *p, dummy;
 =09
 =09
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() entered.\n");
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() ulength =3D %l=
i.\n", ulength);
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() entered.\n");
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() ulength =3D %i.=
\n", ulength);
 =09
 	length =3D ulength;
 	if (ulength > 1024)
@@ -300,11 +231,11 @@
 	buffer[length - 1] =3D 0;
 	bufferptr =3D buffer;
=20
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() buffer =3D \'%=
s\' length =3D %li.\n", buffer, length);
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() buffer =3D \'%s=
\' length =3D %i.\n", buffer, length);
 =09
 	/* reset table counters */
 	if (!memcmp(buffer, "reset", 5)) {
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got \"reset\"=
=2E\n");
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got \"reset\".=
\n");
 		if (!table->shortlisting) {
 			spin_lock_bh(&table->ip_list_lock);
 			memset(table->ip_list.l, 0, sizeof(struct t_ipt_account_ip_list) * tabl=
e->count);
@@ -318,110 +249,110 @@
 	}
=20
 	if (!memcmp(buffer, "ip", 2)) {
-		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got \"ip\".\n=
");
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got \"ip\".\n"=
);
 		bufferptr +=3D 2;
 		if (!isspace(*bufferptr)) {
-			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected spa=
ce (%i).\n", bufferptr - buffer);
+			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected spac=
e (%i).\n", bufferptr - buffer);
 			return length; /* expected space */
 		}
 		bufferptr +=3D 1;
 		if (*bufferptr !=3D '=3D') {
-			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected equ=
al (%i).\n", bufferptr - buffer);
+			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected equa=
l (%i).\n", bufferptr - buffer);
 			return length; /* expected equal */
 		}
 		bufferptr +=3D 1;
 		if (!isspace(*bufferptr)) {
-			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected spa=
ce (%i).\n", bufferptr - buffer);
+			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected spac=
e (%i).\n", bufferptr - buffer);
 			return length; /* expected space */
 		}
 		bufferptr +=3D 1;
 		if (!(len =3D atoip(bufferptr, &ip))) {
-			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected ip =
(%i).\n", bufferptr - buffer);
+			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected ip (=
%i).\n", bufferptr - buffer);
 			return length; /* expected ip */
 		}
 		bufferptr +=3D len;
 		if ((ip & table->netmask) !=3D table->network) {
-			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected ip =
[%u.%u.%u.%u] from table's network/netmask [%u.%u.%u.%u/%u.%u.%u.%u].\n", H=
IPQUAD(ip), HIPQUAD(table->network), HIPQUAD(table->netmask));
+			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected ip [=
%u.%u.%u.%u] from table's network/netmask [%u.%u.%u.%u/%u.%u.%u.%u].\n", HI=
PQUAD(ip), HIPQUAD(table->network), HIPQUAD(table->netmask));
 			return length; /* expected ip from table's network/netmask */
 		}
 		if (!table->shortlisting) {
 			memset(&l, 0, sizeof(struct t_ipt_account_ip_list));
 			while(*bufferptr) {
 				if (!isspace(*bufferptr)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected s=
pace (%i).\n", bufferptr - buffer);
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected sp=
ace (%i).\n", bufferptr - buffer);
 					return length; /* expected space */
 				}
 				bufferptr +=3D 1;
 				if (!memcmp(bufferptr, "bytes_src", 9)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got bytes_=
src (%i).\n", bufferptr - buffer);
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got bytes_s=
rc (%i).\n", bufferptr - buffer);
 					p =3D &l.src.b_all;
 					bufferptr +=3D 9;
 				} else if (!memcmp(bufferptr, "bytes_dest", 10)) {				=09
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got bytes_=
dest (%i).\n", bufferptr - buffer);
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got bytes_d=
est (%i).\n", bufferptr - buffer);
 					p =3D &l.dest.b_all;
 					bufferptr +=3D 10;
 				} else if (!memcmp(bufferptr, "packets_src", 11)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got packet=
s_src (%i).\n", bufferptr - buffer);
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got packets=
_src (%i).\n", bufferptr - buffer);
 					p =3D &l.src.p_all;
 					bufferptr +=3D 11;
 				} else if (!memcmp(bufferptr, "packets_dest", 12)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got packet=
s_dest (%i).\n", bufferptr - buffer);
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got packets=
_dest (%i).\n", bufferptr - buffer);
 					p =3D &l.dest.p_all;
 					bufferptr +=3D 12;
 				} else if (!memcmp(bufferptr, "time", 4)) {
 					/* time hack, ignore time tokens */
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got time (=
%i).\n", bufferptr - buffer);
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got time (%=
i).\n", bufferptr - buffer);
 					bufferptr +=3D 4;
 					if (!isspace(*bufferptr)) {
-						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected =
space (%i).\n", bufferptr - buffer);
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected s=
pace (%i).\n", bufferptr - buffer);
 						return length; /* expected space */
 					}
 					bufferptr +=3D 1;
 					if (*bufferptr !=3D '=3D') {
-						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected =
equal (%i).\n", bufferptr - buffer);
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected e=
qual (%i).\n", bufferptr - buffer);
 						return length; /* expected equal */
 					}
 					bufferptr +=3D 1;
 					if (!isspace(*bufferptr)) {
-						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected =
space (%i).\n", bufferptr - buffer);
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected s=
pace (%i).\n", bufferptr - buffer);
 						return length; /* expected space */
 					}
 					bufferptr +=3D 1;
 					if (!(len =3D atoi64(bufferptr, &dummy))) {
-						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected =
int64 (%i).\n", bufferptr - buffer);
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected i=
nt64 (%i).\n", bufferptr - buffer);
 						return length; /* expected int64 */
 					}
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got %llu (=
%i).\n", dummy, bufferptr - buffer);
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got %llu (%=
i).\n", dummy, bufferptr - buffer);
 					bufferptr +=3D len;
 					continue; /* skip time token */
 				} else
 					return length;	/* expected token */
 				if (!isspace(*bufferptr)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected s=
pace (%i).\n", bufferptr - buffer);
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected sp=
ace (%i).\n", bufferptr - buffer);
 					return length; /* expected space */
 				}
 				bufferptr +=3D 1;
 				if (*bufferptr !=3D '=3D') {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected e=
qual (%i).\n", bufferptr - buffer);
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected eq=
ual (%i).\n", bufferptr - buffer);
 					return length; /* expected equal */
 				}
 				bufferptr +=3D 1;
 				for (i =3D 0; i < 5; i++) {
 					if (!isspace(*bufferptr)) {
-						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected =
space (%i).\n", bufferptr - buffer);
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected s=
pace (%i).\n", bufferptr - buffer);
 						return length; /* expected space */
 					}
 					bufferptr +=3D 1;
 					if (!(len =3D atoi64(bufferptr, p))) {
-						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected =
int64 (%i).\n", bufferptr - buffer);
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected i=
nt64 (%i).\n", bufferptr - buffer);
 						return length; /* expected int64 */
 					}
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got %llu (=
%i).\n", *p, bufferptr - buffer);
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got %llu (%=
i).\n", *p, bufferptr - buffer);
 					bufferptr +=3D len;
 					p++;
 				}
 			}
-			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() updating row=
=2E\n");
+			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() updating row.=
\n");
 			spin_lock_bh(&table->ip_list_lock);
 			/* update counters, do not overwrite time field */
 			memcpy(&table->ip_list.l[ip - table->network], &l, sizeof(struct t_ipt_=
account_ip_list) - sizeof(unsigned long));
@@ -430,79 +361,79 @@
 			memset(&s, 0, sizeof(struct t_ipt_account_ip_list_short));
 			while(*bufferptr) {
 				if (!isspace(*bufferptr)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected s=
pace (%i).\n", bufferptr - buffer);
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected sp=
ace (%i).\n", bufferptr - buffer);
 					return length; /* expected space */
 				}
 				bufferptr +=3D 1;
 				if (!memcmp(bufferptr, "bytes_src", 9)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got bytes_=
src (%i).\n", bufferptr - buffer);
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got bytes_s=
rc (%i).\n", bufferptr - buffer);
 					p =3D &s.src.b_all;
 					bufferptr +=3D 9;
 				} else if (!memcmp(bufferptr, "bytes_dest", 10)) {				=09
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got bytes_=
dest (%i).\n", bufferptr - buffer);
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got bytes_d=
est (%i).\n", bufferptr - buffer);
 					p =3D &s.dest.b_all;
 					bufferptr +=3D 10;
 				} else if (!memcmp(bufferptr, "packets_src", 11)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got packet=
s_src (%i).\n", bufferptr - buffer);
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got packets=
_src (%i).\n", bufferptr - buffer);
 					p =3D &s.src.p_all;
 					bufferptr +=3D 11;
 				} else if (!memcmp(bufferptr, "packets_dest", 12)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got packet=
s_dest (%i).\n", bufferptr - buffer);
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got packets=
_dest (%i).\n", bufferptr - buffer);
 					p =3D &s.dest.p_all;
 					bufferptr +=3D 12;
 				} else if (!memcmp(bufferptr, "time", 4)) {
 					/* time hack, ignore time tokens */
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got time (=
%i).\n", bufferptr - buffer);
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got time (%=
i).\n", bufferptr - buffer);
 					bufferptr +=3D 4;
 					if (!isspace(*bufferptr)) {
-						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected =
space (%i).\n", bufferptr - buffer);
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected s=
pace (%i).\n", bufferptr - buffer);
 						return length; /* expected space */
 					}
 					bufferptr +=3D 1;
 					if (*bufferptr !=3D '=3D') {
-						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected =
equal (%i).\n", bufferptr - buffer);
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected e=
qual (%i).\n", bufferptr - buffer);
 						return length; /* expected equal */
 					}
 					bufferptr +=3D 1;
 					if (!isspace(*bufferptr)) {
-						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected =
space (%i).\n", bufferptr - buffer);
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected s=
pace (%i).\n", bufferptr - buffer);
 						return length; /* expected space */
 					}
 					bufferptr +=3D 1;
 					if (!(len =3D atoi64(bufferptr, &dummy))) {
-						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected =
int64 (%i).\n", bufferptr - buffer);
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected i=
nt64 (%i).\n", bufferptr - buffer);
 						return length; /* expected int64 */
 					}
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got %llu (=
%i).\n", dummy, bufferptr - buffer);
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got %llu (%=
i).\n", dummy, bufferptr - buffer);
 					bufferptr +=3D len;
 					continue; /* skip time token */
 				} else {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected t=
oken (%i).\n", bufferptr - buffer);
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected to=
ken (%i).\n", bufferptr - buffer);
 					return length;	/* expected token */
 				}
 				if (!isspace(*bufferptr)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected s=
pace (%i).\n", bufferptr - buffer);
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected sp=
ace (%i).\n", bufferptr - buffer);
 					return length; /* expected space */
 				}
 				bufferptr +=3D 1;
 				if (*bufferptr !=3D '=3D') {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected e=
qual (%i).\n", bufferptr - buffer);
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected eq=
ual (%i).\n", bufferptr - buffer);
 					return length; /* expected equal */
 				}
 				bufferptr +=3D 1;
 				if (!isspace(*bufferptr)) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected s=
pace (%i).\n", bufferptr - buffer);
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected sp=
ace (%i).\n", bufferptr - buffer);
 					return length; /* expected space */
 				}
 				bufferptr +=3D 1;
 				if (!(len =3D atoi64(bufferptr, p))) {
-					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() expected i=
nt64 (%i).\n", bufferptr - buffer);
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected in=
t64 (%i).\n", bufferptr - buffer);
 					return length; /* expected int64 */
 				}
-				dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() got %llu (%=
i).\n", *p, bufferptr - buffer);
+				dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got %llu (%i=
).\n", *p, bufferptr - buffer);
 				bufferptr +=3D len;
 			}
-			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() updating row=
=2E\n");
+			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() updating row.=
\n");
 			spin_lock_bh(&table->ip_list_lock);
 			/* update counters, do not overwrite time field */
 			memcpy(&table->ip_list.s[ip - table->network], &s, sizeof(struct t_ipt_=
account_ip_list_short) - sizeof(unsigned long));
@@ -510,10 +441,84 @@
 		}
 	}
 =09
-	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_proc_write() left.\n");
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() left.\n");
 	return length;
 }
=20
+
+static int account_seq_show(struct seq_file *s, void *v)
+{
+	struct proc_dir_entry *pde =3D s->private;
+	struct t_ipt_account_table *table =3D pde->data;
+	unsigned int *bucket =3D (unsigned int *)v;
+
+	u_int32_t address =3D table->network + *bucket;
+
+	if (!table->shortlisting) {
+		seq_printf(s,
+				"ip =3D %u.%u.%u.%u bytes_src =3D %llu %llu %llu %llu %llu packets_src=
 =3D %llu %llu %llu %llu %llu bytes_dest =3D %llu %llu %llu %llu %llu packe=
ts_dest =3D %llu %llu %llu %llu %llu\n",
+				HIPQUAD(address),
+				table->ip_list.l[*bucket].src.b_all,
+				table->ip_list.l[*bucket].src.b_tcp,
+				table->ip_list.l[*bucket].src.b_udp,
+				table->ip_list.l[*bucket].src.b_icmp,
+				table->ip_list.l[*bucket].src.b_other,
+				table->ip_list.l[*bucket].src.p_all,
+				table->ip_list.l[*bucket].src.p_tcp,
+				table->ip_list.l[*bucket].src.p_udp,
+				table->ip_list.l[*bucket].src.p_icmp,
+				table->ip_list.l[*bucket].src.p_other,
+				table->ip_list.l[*bucket].dest.b_all,
+				table->ip_list.l[*bucket].dest.b_tcp,
+				table->ip_list.l[*bucket].dest.b_udp,
+				table->ip_list.l[*bucket].dest.b_icmp,
+				table->ip_list.l[*bucket].dest.b_other,			=09
+				table->ip_list.l[*bucket].dest.p_all,
+				table->ip_list.l[*bucket].dest.p_tcp,
+				table->ip_list.l[*bucket].dest.p_udp,
+				table->ip_list.l[*bucket].dest.p_icmp,
+				table->ip_list.l[*bucket].dest.p_other
+			);
+	} else {
+		seq_printf(s,
+				"ip =3D %u.%u.%u.%u bytes_src =3D %llu packets_src =3D %llu bytes_dest=
 =3D %llu packets_dest =3D %llu\n",
+				HIPQUAD(address),
+				table->ip_list.s[*bucket].src.b_all,
+				table->ip_list.s[*bucket].src.p_all,
+				table->ip_list.s[*bucket].dest.b_all,
+				table->ip_list.s[*bucket].dest.p_all
+			  );
+	}
+	return 0;
+}
+
+static struct seq_operations account_seq_ops =3D {
+	.start =3D account_seq_start,
+	.next  =3D account_seq_next,
+	.stop  =3D account_seq_stop,
+	.show  =3D account_seq_show
+};
+
+static int account_seq_open(struct inode *inode, struct file *file)
+{
+	int ret =3D seq_open(file, &account_seq_ops);
+=09
+	if (!ret) {
+		struct seq_file *sf =3D file->private_data;
+		sf->private =3D PDE(inode);
+	}
+	return ret;
+}
+
+static struct file_operations account_file_ops =3D {
+	.owner =3D THIS_MODULE,
+	.open =3D account_seq_open,
+	.read =3D seq_read,
+	.write =3D account_seq_write,
+	.llseek =3D seq_lseek,
+	.release =3D seq_release
+};
+
 /* do raw accounting */
 static inline void do_account(struct t_ipt_account_stat *stat, const struc=
t sk_buff *skb) {
 =09
@@ -764,13 +769,12 @@
 		goto failure_unlink;
 	}
 	table->status_file->owner =3D THIS_MODULE;
-	table->status_file->data =3D table;
+	table->status_file->data =3D table;=09
 	wmb();
-	if (!table->shortlisting)
-		table->status_file->read_proc =3D account_proc_read;
-	else
-		table->status_file->read_proc =3D account_proc_read_short;
-	table->status_file->write_proc =3D account_proc_write;
+//	if (!table->shortlisting)
+		table->status_file->proc_fops =3D &account_file_ops;
+//	else
+//		table->status_file->proc_fops =3D &account_file_ops_short;
=20
 	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() left.\n");=09
 	/* everything went just okey */
diff -uNr patch-o-matic-ng.orig/account/linux-2.6/include/linux/netfilter_i=
pv4/ipt_account.h patch-o-matic-ng/account/linux-2.6/include/linux/netfilte=
r_ipv4/ipt_account.h
--- patch-o-matic-ng.orig/account/linux-2.6/include/linux/netfilter_ipv4/ip=
t_account.h	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/account/linux-2.6/include/linux/netfilter_ipv4/ipt_acc=
ount.h	2004-09-07 12:12:08.000000000 +0200
@@ -0,0 +1,26 @@
+/*=20
+ * accounting match (ipt_account.c)
+ * (C) 2003,2004 by Piotr Gasidlo (quaker@barbara.eu.org)
+ *
+ * Version: 0.1.7
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
+#define IPT_ACCOUNT_VERSION  "0.1.7"
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
diff -uNr patch-o-matic-ng.orig/account/linux-2.6/net/ipv4/netfilter/Kconfi=
g.ladd patch-o-matic-ng/account/linux-2.6/net/ipv4/netfilter/Kconfig.ladd
--- patch-o-matic-ng.orig/account/linux-2.6/net/ipv4/netfilter/Kconfig.ladd=
	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/account/linux-2.6/net/ipv4/netfilter/Kconfig.ladd	2004=
-08-27 16:40:42.000000000 +0200
@@ -0,0 +1,45 @@
+config IP_NF_MATCH_ACCOUNT
+	tristate "account match support"
+	depends on IP_NF_IPTABLES && PROC_FS
+	help
+	  This match is used for accounting traffic for all hosts in
+	  defined network/netmask.=20
+	 =20
+	  Features:
+	  - long (one counter per protocol TCP/UDP/IMCP/Other) and short statisti=
cs
+	  - one iptables rule for all hosts in network/netmask
+	  - loading/saving counters (by reading/writting to procfs entries)
+	 =20
+	  Example usage:
+	 =20
+	  account traffic for/to 192.168.0.0/24 network into table mynetwork:
+	 =20
+	  # iptables -A FORWARD -m account --aname mynetwork --aaddr 192.168.0.0/=
24
+	 =20
+	  account traffic for/to WWW serwer for 192.168.0.0/24 network into table=
=20
+	  mywwwserver:
+	 =20
+	  # iptables -A INPUT -p tcp --dport 80=20
+	    -m account --aname mywwwserver --aaddr 192.168.0.0/24 --ashort
+	  # iptables -A OUTPUT -p tcp --sport 80
+	    -m account --aname mywwwserver --aaddr 192.168.0.0/24 --ashort   =20
+	 =20
+	  read counters:
+	 =20
+	  # cat /proc/net/ipt_account/mynetwork
+	  # cat /proc/net/ipt_account/mywwwserver
+	 =20
+	  set counters:
+	 =20
+	  # echo "ip =3D 192.168.0.1 packets_src =3D 0" > /proc/net/ipt_account/m=
ywwserver
+	 =20
+	  Webpage:=20
+	    http://www.barbara.eu.org/~quaker/ipt_account/
+
+config IP_NF_MATCH_ACCOUNT_DEBUG
+	bool "account debugging output"
+	depends on IP_NF_MATCH_ACCOUNT
+	help
+	  Say Y to get lots of debugging output.
+	 =20
+
diff -uNr patch-o-matic-ng.orig/account/linux-2.6/net/ipv4/netfilter/Makefi=
le.ladd patch-o-matic-ng/account/linux-2.6/net/ipv4/netfilter/Makefile.ladd
--- patch-o-matic-ng.orig/account/linux-2.6/net/ipv4/netfilter/Makefile.lad=
d	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/account/linux-2.6/net/ipv4/netfilter/Makefile.ladd	200=
4-03-17 15:50:12.000000000 +0100
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP_NF_MATCH_TOS) +=3D ipt_tos.o
+obj-$(CONFIG_IP_NF_MATCH_ACCOUNT) +=3D ipt_account.o
diff -uNr patch-o-matic-ng.orig/account/linux-2.6/net/ipv4/netfilter/ipt_ac=
count.c patch-o-matic-ng/account/linux-2.6/net/ipv4/netfilter/ipt_account.c
--- patch-o-matic-ng.orig/account/linux-2.6/net/ipv4/netfilter/ipt_account.=
c	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/account/linux-2.6/net/ipv4/netfilter/ipt_account.c	200=
4-09-15 14:10:40.000000000 +0200
@@ -0,0 +1,923 @@
+/*=20
+ * accounting match (ipt_account.c)
+ * (C) 2003,2004 by Piotr Gasidlo (quaker@barbara.eu.org)
+ *
+ * Version: 0.1.7
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
+#include <linux/seq_file.h>
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
+static void *account_seq_start(struct seq_file *s, loff_t *pos)
+{
+	struct proc_dir_entry *pde =3D s->private;
+	struct t_ipt_account_table *table =3D pde->data;
+
+	unsigned int *bucket;
+=09
+	spin_lock_bh(&table->ip_list_lock);
+	if (*pos >=3D table->count)
+		return NULL;
+
+	bucket =3D kmalloc(sizeof(unsigned int), GFP_KERNEL);
+	if (!bucket)
+		return ERR_PTR(-ENOMEM);
+	*bucket =3D *pos;
+	return bucket;
+}
+
+static void *account_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	struct proc_dir_entry *pde =3D s->private;
+	struct t_ipt_account_table *table =3D pde->data;
+=09
+	unsigned int *bucket =3D (unsigned int *)v;
+=09
+	*pos =3D ++(*bucket);
+	if (*pos >=3D table->count) {
+		kfree(v);
+		return NULL;
+	}
+	return bucket;
+}
+
+static void account_seq_stop(struct seq_file *s, void *v)
+{
+	struct proc_dir_entry *pde =3D s->private;
+	struct t_ipt_account_table *table =3D pde->data;
+	unsigned int *bucket =3D (unsigned int *)v;
+	kfree(bucket);
+	spin_unlock_bh(&table->ip_list_lock);
+}
+
+static int account_seq_write(struct file *file, const char *ubuffer,=20
+		size_t ulength, loff_t *pos)
+{
+	struct proc_dir_entry *pde =3D ((struct seq_file *)file->private_data)->p=
rivate;
+	struct t_ipt_account_table *table =3D pde->data;
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
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() entered.\n");
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() ulength =3D %i.=
\n", ulength);
+=09
+	length =3D ulength;
+	if (ulength > 1024)
+		length =3D 1024;
+	if (copy_from_user(buffer, ubuffer, length))
+		return -EFAULT;
+	buffer[length - 1] =3D 0;
+	bufferptr =3D buffer;
+
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() buffer =3D \'%s=
\' length =3D %i.\n", buffer, length);
+=09
+	/* reset table counters */
+	if (!memcmp(buffer, "reset", 5)) {
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got \"reset\".=
\n");
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
+		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got \"ip\".\n"=
);
+		bufferptr +=3D 2;
+		if (!isspace(*bufferptr)) {
+			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected spac=
e (%i).\n", bufferptr - buffer);
+			return length; /* expected space */
+		}
+		bufferptr +=3D 1;
+		if (*bufferptr !=3D '=3D') {
+			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected equa=
l (%i).\n", bufferptr - buffer);
+			return length; /* expected equal */
+		}
+		bufferptr +=3D 1;
+		if (!isspace(*bufferptr)) {
+			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected spac=
e (%i).\n", bufferptr - buffer);
+			return length; /* expected space */
+		}
+		bufferptr +=3D 1;
+		if (!(len =3D atoip(bufferptr, &ip))) {
+			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected ip (=
%i).\n", bufferptr - buffer);
+			return length; /* expected ip */
+		}
+		bufferptr +=3D len;
+		if ((ip & table->netmask) !=3D table->network) {
+			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected ip [=
%u.%u.%u.%u] from table's network/netmask [%u.%u.%u.%u/%u.%u.%u.%u].\n", HI=
PQUAD(ip), HIPQUAD(table->network), HIPQUAD(table->netmask));
+			return length; /* expected ip from table's network/netmask */
+		}
+		if (!table->shortlisting) {
+			memset(&l, 0, sizeof(struct t_ipt_account_ip_list));
+			while(*bufferptr) {
+				if (!isspace(*bufferptr)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected sp=
ace (%i).\n", bufferptr - buffer);
+					return length; /* expected space */
+				}
+				bufferptr +=3D 1;
+				if (!memcmp(bufferptr, "bytes_src", 9)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got bytes_s=
rc (%i).\n", bufferptr - buffer);
+					p =3D &l.src.b_all;
+					bufferptr +=3D 9;
+				} else if (!memcmp(bufferptr, "bytes_dest", 10)) {				=09
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got bytes_d=
est (%i).\n", bufferptr - buffer);
+					p =3D &l.dest.b_all;
+					bufferptr +=3D 10;
+				} else if (!memcmp(bufferptr, "packets_src", 11)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got packets=
_src (%i).\n", bufferptr - buffer);
+					p =3D &l.src.p_all;
+					bufferptr +=3D 11;
+				} else if (!memcmp(bufferptr, "packets_dest", 12)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got packets=
_dest (%i).\n", bufferptr - buffer);
+					p =3D &l.dest.p_all;
+					bufferptr +=3D 12;
+				} else if (!memcmp(bufferptr, "time", 4)) {
+					/* time hack, ignore time tokens */
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got time (%=
i).\n", bufferptr - buffer);
+					bufferptr +=3D 4;
+					if (!isspace(*bufferptr)) {
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected s=
pace (%i).\n", bufferptr - buffer);
+						return length; /* expected space */
+					}
+					bufferptr +=3D 1;
+					if (*bufferptr !=3D '=3D') {
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected e=
qual (%i).\n", bufferptr - buffer);
+						return length; /* expected equal */
+					}
+					bufferptr +=3D 1;
+					if (!isspace(*bufferptr)) {
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected s=
pace (%i).\n", bufferptr - buffer);
+						return length; /* expected space */
+					}
+					bufferptr +=3D 1;
+					if (!(len =3D atoi64(bufferptr, &dummy))) {
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected i=
nt64 (%i).\n", bufferptr - buffer);
+						return length; /* expected int64 */
+					}
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got %llu (%=
i).\n", dummy, bufferptr - buffer);
+					bufferptr +=3D len;
+					continue; /* skip time token */
+				} else
+					return length;	/* expected token */
+				if (!isspace(*bufferptr)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected sp=
ace (%i).\n", bufferptr - buffer);
+					return length; /* expected space */
+				}
+				bufferptr +=3D 1;
+				if (*bufferptr !=3D '=3D') {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected eq=
ual (%i).\n", bufferptr - buffer);
+					return length; /* expected equal */
+				}
+				bufferptr +=3D 1;
+				for (i =3D 0; i < 5; i++) {
+					if (!isspace(*bufferptr)) {
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected s=
pace (%i).\n", bufferptr - buffer);
+						return length; /* expected space */
+					}
+					bufferptr +=3D 1;
+					if (!(len =3D atoi64(bufferptr, p))) {
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected i=
nt64 (%i).\n", bufferptr - buffer);
+						return length; /* expected int64 */
+					}
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got %llu (%=
i).\n", *p, bufferptr - buffer);
+					bufferptr +=3D len;
+					p++;
+				}
+			}
+			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() updating row.=
\n");
+			spin_lock_bh(&table->ip_list_lock);
+			/* update counters, do not overwrite time field */
+			memcpy(&table->ip_list.l[ip - table->network], &l, sizeof(struct t_ipt_=
account_ip_list) - sizeof(unsigned long));
+			spin_unlock_bh(&table->ip_list_lock);
+		} else {
+			memset(&s, 0, sizeof(struct t_ipt_account_ip_list_short));
+			while(*bufferptr) {
+				if (!isspace(*bufferptr)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected sp=
ace (%i).\n", bufferptr - buffer);
+					return length; /* expected space */
+				}
+				bufferptr +=3D 1;
+				if (!memcmp(bufferptr, "bytes_src", 9)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got bytes_s=
rc (%i).\n", bufferptr - buffer);
+					p =3D &s.src.b_all;
+					bufferptr +=3D 9;
+				} else if (!memcmp(bufferptr, "bytes_dest", 10)) {				=09
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got bytes_d=
est (%i).\n", bufferptr - buffer);
+					p =3D &s.dest.b_all;
+					bufferptr +=3D 10;
+				} else if (!memcmp(bufferptr, "packets_src", 11)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got packets=
_src (%i).\n", bufferptr - buffer);
+					p =3D &s.src.p_all;
+					bufferptr +=3D 11;
+				} else if (!memcmp(bufferptr, "packets_dest", 12)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got packets=
_dest (%i).\n", bufferptr - buffer);
+					p =3D &s.dest.p_all;
+					bufferptr +=3D 12;
+				} else if (!memcmp(bufferptr, "time", 4)) {
+					/* time hack, ignore time tokens */
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got time (%=
i).\n", bufferptr - buffer);
+					bufferptr +=3D 4;
+					if (!isspace(*bufferptr)) {
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected s=
pace (%i).\n", bufferptr - buffer);
+						return length; /* expected space */
+					}
+					bufferptr +=3D 1;
+					if (*bufferptr !=3D '=3D') {
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected e=
qual (%i).\n", bufferptr - buffer);
+						return length; /* expected equal */
+					}
+					bufferptr +=3D 1;
+					if (!isspace(*bufferptr)) {
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected s=
pace (%i).\n", bufferptr - buffer);
+						return length; /* expected space */
+					}
+					bufferptr +=3D 1;
+					if (!(len =3D atoi64(bufferptr, &dummy))) {
+						dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected i=
nt64 (%i).\n", bufferptr - buffer);
+						return length; /* expected int64 */
+					}
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got %llu (%=
i).\n", dummy, bufferptr - buffer);
+					bufferptr +=3D len;
+					continue; /* skip time token */
+				} else {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected to=
ken (%i).\n", bufferptr - buffer);
+					return length;	/* expected token */
+				}
+				if (!isspace(*bufferptr)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected sp=
ace (%i).\n", bufferptr - buffer);
+					return length; /* expected space */
+				}
+				bufferptr +=3D 1;
+				if (*bufferptr !=3D '=3D') {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected eq=
ual (%i).\n", bufferptr - buffer);
+					return length; /* expected equal */
+				}
+				bufferptr +=3D 1;
+				if (!isspace(*bufferptr)) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected sp=
ace (%i).\n", bufferptr - buffer);
+					return length; /* expected space */
+				}
+				bufferptr +=3D 1;
+				if (!(len =3D atoi64(bufferptr, p))) {
+					dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() expected in=
t64 (%i).\n", bufferptr - buffer);
+					return length; /* expected int64 */
+				}
+				dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() got %llu (%i=
).\n", *p, bufferptr - buffer);
+				bufferptr +=3D len;
+			}
+			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() updating row.=
\n");
+			spin_lock_bh(&table->ip_list_lock);
+			/* update counters, do not overwrite time field */
+			memcpy(&table->ip_list.s[ip - table->network], &s, sizeof(struct t_ipt_=
account_ip_list_short) - sizeof(unsigned long));
+			spin_unlock_bh(&table->ip_list_lock);
+		}
+	}
+=09
+	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": account_seq_write() left.\n");
+	return length;
+}
+
+
+static int account_seq_show(struct seq_file *s, void *v)
+{
+	struct proc_dir_entry *pde =3D s->private;
+	struct t_ipt_account_table *table =3D pde->data;
+	unsigned int *bucket =3D (unsigned int *)v;
+
+	u_int32_t address =3D table->network + *bucket;
+
+	if (!table->shortlisting) {
+		seq_printf(s,
+				"ip =3D %u.%u.%u.%u bytes_src =3D %llu %llu %llu %llu %llu packets_src=
 =3D %llu %llu %llu %llu %llu bytes_dest =3D %llu %llu %llu %llu %llu packe=
ts_dest =3D %llu %llu %llu %llu %llu\n",
+				HIPQUAD(address),
+				table->ip_list.l[*bucket].src.b_all,
+				table->ip_list.l[*bucket].src.b_tcp,
+				table->ip_list.l[*bucket].src.b_udp,
+				table->ip_list.l[*bucket].src.b_icmp,
+				table->ip_list.l[*bucket].src.b_other,
+				table->ip_list.l[*bucket].src.p_all,
+				table->ip_list.l[*bucket].src.p_tcp,
+				table->ip_list.l[*bucket].src.p_udp,
+				table->ip_list.l[*bucket].src.p_icmp,
+				table->ip_list.l[*bucket].src.p_other,
+				table->ip_list.l[*bucket].dest.b_all,
+				table->ip_list.l[*bucket].dest.b_tcp,
+				table->ip_list.l[*bucket].dest.b_udp,
+				table->ip_list.l[*bucket].dest.b_icmp,
+				table->ip_list.l[*bucket].dest.b_other,			=09
+				table->ip_list.l[*bucket].dest.p_all,
+				table->ip_list.l[*bucket].dest.p_tcp,
+				table->ip_list.l[*bucket].dest.p_udp,
+				table->ip_list.l[*bucket].dest.p_icmp,
+				table->ip_list.l[*bucket].dest.p_other
+			);
+	} else {
+		seq_printf(s,
+				"ip =3D %u.%u.%u.%u bytes_src =3D %llu packets_src =3D %llu bytes_dest=
 =3D %llu packets_dest =3D %llu\n",
+				HIPQUAD(address),
+				table->ip_list.s[*bucket].src.b_all,
+				table->ip_list.s[*bucket].src.p_all,
+				table->ip_list.s[*bucket].dest.b_all,
+				table->ip_list.s[*bucket].dest.p_all
+			  );
+	}
+	return 0;
+}
+
+static struct seq_operations account_seq_ops =3D {
+	.start =3D account_seq_start,
+	.next  =3D account_seq_next,
+	.stop  =3D account_seq_stop,
+	.show  =3D account_seq_show
+};
+
+static int account_seq_open(struct inode *inode, struct file *file)
+{
+	int ret =3D seq_open(file, &account_seq_ops);
+=09
+	if (!ret) {
+		struct seq_file *sf =3D file->private_data;
+		sf->private =3D PDE(inode);
+	}
+	return ret;
+}
+
+static struct file_operations account_file_ops =3D {
+	.owner =3D THIS_MODULE,
+	.open =3D account_seq_open,
+	.read =3D seq_read,
+	.write =3D account_seq_write,
+	.llseek =3D seq_lseek,
+	.release =3D seq_release
+};
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
=2E%u, dst =3D %u.%u.%u.%u, proto =3D %u.\n", NIPQUAD(skb->nh.iph->saddr), =
NIPQUAD(skb->nh.iph->daddr), skb->nh.iph->protocol);
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
=2E\n");
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
+	table->status_file->data =3D table;=09
+	wmb();
+	table->status_file->proc_fops =3D &account_file_ops;
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
=2E\n");
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
=2E Valid is 32 to 0.\n", netmask);
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

--wac7ysb48OaltWcw--

--=_pandora.barbara.ds.polsl.gliwice.pl-23540-1096192923-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQFBVpOagEmu6PNADqoRAjd/AJ9lO7LhX34woxx5lsv04Ohjr47UowCfVLaW
2WQ+R/SfsAAYwkgzWMmA/A0=
=m+MG
-----END PGP SIGNATURE-----

--=_pandora.barbara.ds.polsl.gliwice.pl-23540-1096192923-0001-2--
