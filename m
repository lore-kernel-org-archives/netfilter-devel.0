From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] netfilter 2.5 enhancement: new /proc/sys entries
Date: Tue, 24 Jun 2003 17:06:46 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030624150646.GM2645@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JvUS8mwutKMHKosv"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
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


--JvUS8mwutKMHKosv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This is the 2.5.x merge of the /prox/sys/ip(6)_tables_{matches,targets}
patch I've sent you earlier today.

If you are wondering how long this patch-bombing is going to continue:
There are two more patches to go: ipt_recent for 2.4.x and 2.5.x.

diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.5.73-cosmetic/net/ipv4/netf=
ilter/ip_tables.c linux-2.5.73-enh_ipt/net/ipv4/netfilter/ip_tables.c
--- linux-2.5.73-cosmetic/net/ipv4/netfilter/ip_tables.c	2003-06-22 20:32:3=
7.000000000 +0200
+++ linux-2.5.73-enh_ipt/net/ipv4/netfilter/ip_tables.c	2003-06-24 17:08:39=
=2E000000000 +0200
@@ -1703,14 +1703,15 @@
 };
=20
 #ifdef CONFIG_PROC_FS
-static inline int print_name(const struct ipt_table *t,
+static inline int print_name(const char *i,
 			     off_t start_offset, char *buffer, int length,
 			     off_t *pos, unsigned int *count)
 {
 	if ((*count)++ >=3D start_offset) {
 		unsigned int namelen;
=20
-		namelen =3D sprintf(buffer + *pos, "%s\n", t->name);
+		namelen =3D sprintf(buffer + *pos, "%s\n",
+				  i + sizeof(struct list_head));
 		if (*pos + namelen > length) {
 			/* Stop iterating */
 			return 1;
@@ -1728,7 +1729,7 @@
 	if (down_interruptible(&ipt_mutex) !=3D 0)
 		return 0;
=20
-	LIST_FIND(&ipt_tables, print_name, struct ipt_table *,
+	LIST_FIND(&ipt_tables, print_name, void *,
 		  offset, buffer, length, &pos, &count);
=20
 	up(&ipt_mutex);
@@ -1737,6 +1738,46 @@
 	*start=3D(char *)((unsigned long)count-offset);
 	return pos;
 }
+
+static int ipt_get_targets(char *buffer, char **start, off_t offset, int l=
ength)
+{
+	off_t pos =3D 0;
+	unsigned int count =3D 0;
+
+	if (down_interruptible(&ipt_mutex) !=3D 0)
+		return 0;
+
+	LIST_FIND(&ipt_target, print_name, void *,
+		  offset, buffer, length, &pos, &count);
+=09
+	up(&ipt_mutex);
+
+	*start =3D (char *)((unsigned long)count - offset);
+	return pos;
+}
+
+static int ipt_get_matches(char *buffer, char **start, off_t offset, int l=
ength)
+{
+	off_t pos =3D 0;
+	unsigned int count =3D 0;
+
+	if (down_interruptible(&ipt_mutex) !=3D 0)
+		return 0;
+=09
+	LIST_FIND(&ipt_match, print_name, void *,
+		  offset, buffer, length, &pos, &count);
+
+	up(&ipt_mutex);
+
+	*start =3D (char *)((unsigned long)count - offset);
+	return pos;
+}
+
+static struct { char *name; get_info_t *get_info; } ipt_proc_entry[] =3D
+{ { "ip_tables_names", ipt_get_tables },
+  { "ip_tables_targets", ipt_get_targets },
+  { "ip_tables_matches", ipt_get_matches },
+  { NULL, NULL} };
 #endif /*CONFIG_PROC_FS*/
=20
 static int __init init(void)
@@ -1762,13 +1803,19 @@
 #ifdef CONFIG_PROC_FS
 	{
 	struct proc_dir_entry *proc;
+	int i;
=20
-	proc =3D proc_net_create("ip_tables_names", 0, ipt_get_tables);
-	if (!proc) {
-		nf_unregister_sockopt(&ipt_sockopts);
-		return -ENOMEM;
+	for (i =3D 0; ipt_proc_entry[i].name; i++) {
+		proc =3D proc_net_create(ipt_proc_entry[i].name, 0,
+				       ipt_proc_entry[i].get_info);
+		if (!proc) {
+			while (--i >=3D 0)
+				proc_net_remove(ipt_proc_entry[i].name);
+			nf_unregister_sockopt(&ipt_sockopts);
+			return -ENOMEM;
+		}
+		proc->owner =3D THIS_MODULE;
 	}
-	proc->owner =3D THIS_MODULE;
 	}
 #endif
=20
@@ -1780,7 +1827,11 @@
 {
 	nf_unregister_sockopt(&ipt_sockopts);
 #ifdef CONFIG_PROC_FS
-	proc_net_remove("ip_tables_names");
+	{
+	int i;
+	for (i =3D 0; ipt_proc_entry[i].name; i++)
+		proc_net_remove(ipt_proc_entry[i].name);
+	}
 #endif
 }
=20
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.5.73-cosmetic/net/ipv6/netf=
ilter/ip6_tables.c linux-2.5.73-enh_ipt/net/ipv6/netfilter/ip6_tables.c
--- linux-2.5.73-cosmetic/net/ipv6/netfilter/ip6_tables.c	2003-06-24 16:49:=
49.000000000 +0200
+++ linux-2.5.73-enh_ipt/net/ipv6/netfilter/ip6_tables.c	2003-06-24 17:08:3=
9.000000000 +0200
@@ -1780,14 +1780,15 @@
 };
=20
 #ifdef CONFIG_PROC_FS
-static inline int print_name(const struct ip6t_table *t,
+static inline int print_name(const char *i,
 			     off_t start_offset, char *buffer, int length,
 			     off_t *pos, unsigned int *count)
 {
 	if ((*count)++ >=3D start_offset) {
 		unsigned int namelen;
=20
-		namelen =3D sprintf(buffer + *pos, "%s\n", t->name);
+		namelen =3D sprintf(buffer + *pos, "%s\n",
+				  i + sizeof(struct list_head));
 		if (*pos + namelen > length) {
 			/* Stop iterating */
 			return 1;
@@ -1805,7 +1806,7 @@
 	if (down_interruptible(&ip6t_mutex) !=3D 0)
 		return 0;
=20
-	LIST_FIND(&ip6t_tables, print_name, struct ip6t_table *,
+	LIST_FIND(&ip6t_tables, print_name, char *,
 		  offset, buffer, length, &pos, &count);
=20
 	up(&ip6t_mutex);
@@ -1814,6 +1815,46 @@
 	*start=3D(char *)((unsigned long)count-offset);
 	return pos;
 }
+
+static int ip6t_get_targets(char *buffer, char **start, off_t offset, int =
length)
+{
+	off_t pos =3D 0;
+	unsigned int count =3D 0;
+
+	if (down_interruptible(&ip6t_mutex) !=3D 0)
+		return 0;
+
+	LIST_FIND(&ip6t_target, print_name, char *,
+		  offset, buffer, length, &pos, &count);
+
+	up(&ip6t_mutex);
+
+	*start =3D (char *)((unsigned long)count - offset);
+	return pos;
+}
+
+static int ip6t_get_matches(char *buffer, char **start, off_t offset, int =
length)
+{
+	off_t pos =3D 0;
+	unsigned int count =3D 0;
+
+	if (down_interruptible(&ip6t_mutex) !=3D 0)
+		return 0;
+
+	LIST_FIND(&ip6t_match, print_name, char *,
+		  offset, buffer, length, &pos, &count);
+
+	up(&ip6t_mutex);
+
+	*start =3D (char *)((unsigned long)count - offset);
+	return pos;
+}
+
+static struct { char *name; get_info_t *get_info; } ip6t_proc_entry[] =3D
+{ { "ip6_tables_names", ip6t_get_tables },
+  { "ip6_tables_targets", ip6t_get_targets },
+  { "ip6_tables_matches", ip6t_get_matches },
+  { NULL, NULL} };
 #endif /*CONFIG_PROC_FS*/
=20
 static int __init init(void)
@@ -1839,13 +1880,19 @@
 #ifdef CONFIG_PROC_FS
 	{
 		struct proc_dir_entry *proc;
-		proc =3D proc_net_create("ip6_tables_names", 0,
-					ip6t_get_tables);
-		if (!proc) {
-			nf_unregister_sockopt(&ip6t_sockopts);
-			return -ENOMEM;
+		int i;
+
+		for (i =3D 0; ip6t_proc_entry[i].name; i++) {
+			proc =3D proc_net_create(ip6t_proc_entry[i].name, 0,
+					       ip6t_proc_entry[i].get_info);
+			if (!proc) {
+				while (--i >=3D 0)
+				       proc_net_remove(ip6t_proc_entry[i].name);
+				nf_unregister_sockopt(&ip6t_sockopts);
+				return -ENOMEM;
+			}
+			proc->owner =3D THIS_MODULE;
 		}
-		proc->owner =3D THIS_MODULE;
 	}
 #endif
=20
@@ -1857,7 +1904,11 @@
 {
 	nf_unregister_sockopt(&ip6t_sockopts);
 #ifdef CONFIG_PROC_FS
-	proc_net_remove("ip6_tables_names");
+	{
+		int i;
+		for (i =3D 0; ip6t_proc_entry[i].name; i++)
+			proc_net_remove(ip6t_proc_entry[i].name);
+	}
 #endif
 }
=20

Please apply, thanks.


--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--JvUS8mwutKMHKosv
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE++GkGXaXGVTD0i/8RAvleAJ9U3LOw3Y1MooqCbvp/faNIo3DuowCfU1Of
2vMiTLN8IrX9IK7iNOFbSj0=
=VTIU
-----END PGP SIGNATURE-----

--JvUS8mwutKMHKosv--
