From: "Piotr =?iso-8859-2?Q?Gasid=B3o?="
	<quaker@pandora.barbara.ds.polsl.gliwice.pl>
Subject: [PATCH] ipt_account fixup
Date: Mon, 9 May 2005 15:44:39 +0200
Message-ID: <20050509134439.GA22175@barbara.eu.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=_pandora.barbara.ds.polsl.gliwice.pl-28680-1115646279-0001-2"
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

--=_pandora.barbara.ds.polsl.gliwice.pl-28680-1115646279-0001-2
Content-Type: multipart/mixed; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

Little changes to ipt_account:
- added time field,
- better error handling in __init,
- new module parameters handling in 2.6.x version

Please apply.

--=20
Piotr 'QuakeR' Gasid=B3o, BOFH @ pandora.barbara.eu.org
############## sending lusers to /dev/null since 1998
##### Waiting for tomorrow, for a little ray of light
### Waiting for tomorrow just to see your smile again

--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename="ipt_account-fix.diff"
Content-Transfer-Encoding: quoted-printable

diff -uNr patch-o-matic-ng.orig/account/linux/net/ipv4/netfilter/ipt_accoun=
t.c patch-o-matic-ng/account/linux/net/ipv4/netfilter/ipt_account.c
--- patch-o-matic-ng.orig/account/linux/net/ipv4/netfilter/ipt_account.c	20=
05-05-09 14:10:11.495288184 +0200
+++ patch-o-matic-ng/account/linux/net/ipv4/netfilter/ipt_account.c	2005-05=
-09 15:10:50.186123096 +0200
@@ -453,10 +453,12 @@
 	unsigned int *bucket =3D (unsigned int *)v;
=20
 	u_int32_t address =3D table->network + *bucket;
+	struct timespec last;
=20
 	if (!table->shortlisting) {
+		jiffies_to_timespec(jiffies - table->ip_list.l[*bucket].time, &last);
 		seq_printf(s,
-				"ip =3D %u.%u.%u.%u bytes_src =3D %llu %llu %llu %llu %llu packets_src=
 =3D %llu %llu %llu %llu %llu bytes_dest =3D %llu %llu %llu %llu %llu packe=
ts_dest =3D %llu %llu %llu %llu %llu\n",
+				"ip =3D %u.%u.%u.%u bytes_src =3D %llu %llu %llu %llu %llu packets_src=
 =3D %llu %llu %llu %llu %llu bytes_dest =3D %llu %llu %llu %llu %llu packe=
ts_dest =3D %llu %llu %llu %llu %llu time =3D %lu\n",
 				HIPQUAD(address),
 				table->ip_list.l[*bucket].src.b_all,
 				table->ip_list.l[*bucket].src.b_tcp,
@@ -477,16 +479,19 @@
 				table->ip_list.l[*bucket].dest.p_tcp,
 				table->ip_list.l[*bucket].dest.p_udp,
 				table->ip_list.l[*bucket].dest.p_icmp,
-				table->ip_list.l[*bucket].dest.p_other
+				table->ip_list.l[*bucket].dest.p_other,
+				last.tv_sec
 			);
 	} else {
+		jiffies_to_timespec(jiffies - table->ip_list.s[*bucket].time, &last);
 		seq_printf(s,
-				"ip =3D %u.%u.%u.%u bytes_src =3D %llu packets_src =3D %llu bytes_dest=
 =3D %llu packets_dest =3D %llu\n",
+				"ip =3D %u.%u.%u.%u bytes_src =3D %llu packets_src =3D %llu bytes_dest=
 =3D %llu packets_dest =3D %llu time =3D %lu\n",
 				HIPQUAD(address),
 				table->ip_list.s[*bucket].src.b_all,
 				table->ip_list.s[*bucket].src.p_all,
 				table->ip_list.s[*bucket].dest.b_all,
-				table->ip_list.s[*bucket].dest.p_all
+				table->ip_list.s[*bucket].dest.p_all,
+				last.tv_sec
 			  );
 	}
 	return 0;
@@ -891,25 +896,34 @@
=20
 static int __init init(void)=20
 {
+	int err;
+=09
 	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": __init() entered.\n");
 	printk(version);=09
 	/* check params */
 	if (netmask > 32 || netmask < 0) {
 		printk(KERN_INFO "account: Wrong netmask given by netmask parameter (%i)=
=2E Valid is 32 to 0.\n", netmask);
-		return -EINVAL;
+		err =3D -EINVAL;
+		goto doexit;
 	}
=20
 	/* create /proc/net/ipt_account directory */
 	proc_net_ipt_account =3D proc_mkdir("ipt_account", proc_net);
 	if (!proc_net_ipt_account) {	=09
 		printk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() failed to create procf=
s entry.\n");
-		return -EINVAL; /* was -ENOMEM */
+		err =3D -ENOMEM;
+		goto doexit;
 	}
 	proc_net_ipt_account->owner =3D THIS_MODULE;
 =09
+	err =3D ipt_register_match(&account_match);
+	if (err) {
+		printk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() failed to register mat=
ch.\n");
+		remove_proc_entry("ipt_account", proc_net);
+	}
+doexit:
 	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": __init() left.\n");
-
-	return ipt_register_match(&account_match);
+	return err;
 }
=20
 static void __exit fini(void)=20
diff -uNr patch-o-matic-ng.orig/account/linux-2.6/net/ipv4/netfilter/ipt_ac=
count.c patch-o-matic-ng/account/linux-2.6/net/ipv4/netfilter/ipt_account.c
--- patch-o-matic-ng.orig/account/linux-2.6/net/ipv4/netfilter/ipt_account.=
c	2005-05-09 14:10:11.662262800 +0200
+++ patch-o-matic-ng/account/linux-2.6/net/ipv4/netfilter/ipt_account.c	200=
5-05-09 15:20:07.904337040 +0200
@@ -44,9 +44,9 @@
 MODULE_AUTHOR("Piotr Gasidlo <quaker@barbara.eu.org>");
 MODULE_DESCRIPTION("Traffic accounting modules");
 MODULE_LICENSE("GPL");
-MODULE_PARM(permissions,"i");
+module_param(permissions, int, 0400);
+module_param(netmask, int, 0400);
 MODULE_PARM_DESC(permissions,"permissions on /proc/net/ipt_account/* files=
");
-MODULE_PARM(netmask, "i");
 MODULE_PARM_DESC(netmask, "maximum *save* size of one list (netmask)");
=20
 /* structure with statistics counters */
@@ -453,10 +453,12 @@
 	unsigned int *bucket =3D (unsigned int *)v;
=20
 	u_int32_t address =3D table->network + *bucket;
+	struct timespec last;
=20
 	if (!table->shortlisting) {
+		jiffies_to_timespec(jiffies - table->ip_list.l[*bucket].time, &last);
 		seq_printf(s,
-				"ip =3D %u.%u.%u.%u bytes_src =3D %llu %llu %llu %llu %llu packets_src=
 =3D %llu %llu %llu %llu %llu bytes_dest =3D %llu %llu %llu %llu %llu packe=
ts_dest =3D %llu %llu %llu %llu %llu\n",
+				"ip =3D %u.%u.%u.%u bytes_src =3D %llu %llu %llu %llu %llu packets_src=
 =3D %llu %llu %llu %llu %llu bytes_dest =3D %llu %llu %llu %llu %llu packe=
ts_dest =3D %llu %llu %llu %llu %llu time =3D %lu\n",
 				HIPQUAD(address),
 				table->ip_list.l[*bucket].src.b_all,
 				table->ip_list.l[*bucket].src.b_tcp,
@@ -477,16 +479,19 @@
 				table->ip_list.l[*bucket].dest.p_tcp,
 				table->ip_list.l[*bucket].dest.p_udp,
 				table->ip_list.l[*bucket].dest.p_icmp,
-				table->ip_list.l[*bucket].dest.p_other
+				table->ip_list.l[*bucket].dest.p_other,
+				last.tv_sec
 			);
 	} else {
+		jiffies_to_timespec(jiffies - table->ip_list.s[*bucket].time, &last);
 		seq_printf(s,
-				"ip =3D %u.%u.%u.%u bytes_src =3D %llu packets_src =3D %llu bytes_dest=
 =3D %llu packets_dest =3D %llu\n",
+				"ip =3D %u.%u.%u.%u bytes_src =3D %llu packets_src =3D %llu bytes_dest=
 =3D %llu packets_dest =3D %llu time =3D %lu\n",
 				HIPQUAD(address),
 				table->ip_list.s[*bucket].src.b_all,
 				table->ip_list.s[*bucket].src.p_all,
 				table->ip_list.s[*bucket].dest.b_all,
-				table->ip_list.s[*bucket].dest.p_all
+				table->ip_list.s[*bucket].dest.p_all,
+				last.tv_sec
 			  );
 	}
 	return 0;
@@ -700,7 +705,7 @@
         table =3D vmalloc(sizeof(struct t_ipt_account_table));
 	if (table =3D=3D NULL) {
 		printk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() failed to allocate %u =
for new table %s.\n", sizeof(struct t_ipt_account_table), info->name);
-		ret =3D 0; /* was -ENOMEM */
+		ret =3D 0;
 		goto failure;
 	}
 =09
@@ -721,7 +726,7 @@
 		table->ip_list.l =3D vmalloc(sizeof(struct t_ipt_account_ip_list) * tabl=
e->count);
 		if (table->ip_list.l =3D=3D NULL) {
 			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() failed to allocate %=
u for ip_list.\n", sizeof(struct t_ipt_account_ip_list) * table->count);
-			ret =3D 0; /* was -ENOMEM */
+			ret =3D 0;
 			goto failure_table;
 		}
 		memset(table->ip_list.l, 0, sizeof(struct t_ipt_account_ip_list) * table=
->count);
@@ -730,7 +735,7 @@
 		table->ip_list.s =3D vmalloc(sizeof(struct t_ipt_account_ip_list_short) =
* table->count);
 		if (table->ip_list.s =3D=3D NULL) {
 			dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() failed to allocate %=
u for ip_list.\n", sizeof(struct t_ipt_account_ip_list_short) * table->coun=
t);
-			ret =3D 0; /* was -ENOMEM */
+			ret =3D 0;
 			goto failure_table;
 		}
 		memset(table->ip_list.s, 0, sizeof(struct t_ipt_account_ip_list_short) *=
 table->count);
@@ -763,7 +768,7 @@
 	/* create procfs status file */
 	table->status_file =3D create_proc_entry(table->name, permissions, proc_n=
et_ipt_account);
 	if (table->status_file =3D=3D NULL) {
-		ret =3D 0; /* was -ENOMEM */
+		ret =3D 0;
 		goto failure_unlink;
 	}
 	table->status_file->owner =3D THIS_MODULE;
@@ -785,13 +790,13 @@
 	if (table =3D=3D NULL) {
 		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() no table found. Leavi=
ng.\n");
 		spin_unlock_bh(&account_lock);
-		return 0; /* was -ENOMEM */
+		return 0;
 	}
 	while (strncmp(info->name, table->name, IPT_ACCOUNT_NAME_LEN) && (last_ta=
ble =3D table) && (table =3D table->next));
 	if (table =3D=3D NULL) {
 		dprintk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() table already destroy=
ed. Leaving.\n");
 		spin_unlock_bh(&account_lock);
-		return 0; /* was -ENOMEM */
+		return 0;
 	}
 	if (last_table)
 		last_table->next =3D table->next;
@@ -886,25 +891,34 @@
=20
 static int __init init(void)=20
 {
+	int err;
+=09
 	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": __init() entered.\n");
 	printk(version);=09
 	/* check params */
 	if (netmask > 32 || netmask < 0) {
 		printk(KERN_INFO "account: Wrong netmask given by netmask parameter (%i)=
=2E Valid is 32 to 0.\n", netmask);
-		return -EINVAL;
+		err =3D -EINVAL;
+		goto doexit;
 	}
=20
 	/* create /proc/net/ipt_account directory */
 	proc_net_ipt_account =3D proc_mkdir("ipt_account", proc_net);
 	if (!proc_net_ipt_account) {	=09
 		printk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() failed to create procf=
s entry.\n");
-		return -EINVAL; /* was -ENOMEM */
+		err =3D -ENOMEM;
+		goto doexit;
 	}
 	proc_net_ipt_account->owner =3D THIS_MODULE;
 =09
+	err =3D ipt_register_match(&account_match);
+	if (err) {
+		printk(KERN_INFO IPT_ACCOUNT_NAME ": checkentry() failed to register mat=
ch.\n");
+		remove_proc_entry("ipt_account", proc_net);
+	}
+doexit:=09
 	dprintk(KERN_INFO IPT_ACCOUNT_NAME ": __init() left.\n");
-
-	return ipt_register_match(&account_match);
+	return err;
 }
=20
 static void __exit fini(void)=20

--uAKRQypu60I7Lcqm--

--=_pandora.barbara.ds.polsl.gliwice.pl-28680-1115646279-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCf2lHgEmu6PNADqoRAujXAJ0RcxtB6ZM6G9W6f4UqB/VQtN4eMACcD/9F
IyCM+6eQpuQTUsUt8fLfPK0=
=L7kp
-----END PGP SIGNATURE-----

--=_pandora.barbara.ds.polsl.gliwice.pl-28680-1115646279-0001-2--
