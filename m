From: Soren Hansen <soren@ubuntu.com>
Subject: Automatically load modules in iptables-save
Date: Mon, 16 Mar 2009 12:42:24 +0100
Message-ID: <20090316114224.GE31952@ralph.linux2go.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JWEK1jqKZ6MHAcjA"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from atlas.linux2go.dk ([88.198.22.52]:55061 "EHLO atlas.linux2go.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbZCPLus (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2009 07:50:48 -0400
Received: from localhost (0107ds1-abv.0.fullrate.dk [90.185.52.147])
	by atlas.linux2go.dk (Postfix) with ESMTP id E3F0B40A625
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Mar 2009 12:42:25 +0100 (CET)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--JWEK1jqKZ6MHAcjA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

If the iptables modules are not loaded when iptables-save is run,
iptables-save will fail, because it can't open the relevant files in
/proc.  This patch makes iptables-save attempt to load the modules, and
then retries.


Index: iptables-1.4.1.1/iptables-save.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables-1.4.1.1.orig/iptables-save.c	2009-03-16 11:19:25.233429856 +01=
00
+++ iptables-1.4.1.1/iptables-save.c	2009-03-16 12:42:10.200735326 +0100
@@ -28,17 +28,22 @@
 	{.name =3D "counters", .has_arg =3D false, .val =3D 'c'},
 	{.name =3D "dump",     .has_arg =3D false, .val =3D 'd'},
 	{.name =3D "table",    .has_arg =3D true,  .val =3D 't'},
+	{.name =3D "modprobe", .has_arg =3D true,  .val =3D 'M'},
 	{NULL},
 };
=20
 /* Debugging prototype. */
-static int for_each_table(int (*func)(const char *tablename))
+static int for_each_table(int (*func)(const char *tablename), const char *=
modprobe)
 {
 	int ret =3D 1;
 	FILE *procfile =3D NULL;
 	char tablename[IPT_TABLE_MAXNAMELEN+1];
=20
 	procfile =3D fopen("/proc/net/ip_tables_names", "r");
+	if (!procfile) {
+		load_xtables_ko(modprobe, 0);
+		procfile =3D fopen("/proc/net/ip_tables_names", "r");
+	}
 	if (!procfile)
 		exit_error(OTHER_PROBLEM,
 			   "Unable to open /proc/net/ip_tables_names: %s\n",
@@ -57,15 +62,20 @@
 }
=20
=20
-static int do_output(const char *tablename)
+static int do_output(const char *tablename, const char *modprobe)
 {
 	iptc_handle_t h;
 	const char *chain =3D NULL;
=20
 	if (!tablename)
-		return for_each_table(&do_output);
+		return for_each_table(&do_output, modprobe);
=20
 	h =3D iptc_init(tablename);
+	if (!h) {
+		load_xtables_ko(modprobe, 0);
+		h =3D iptc_init(tablename);
+	}
+
 	if (!h)
 		exit_error(OTHER_PROBLEM, "Can't initialize: %s\n",
 			   iptc_strerror(errno));
@@ -134,6 +144,7 @@
 #endif
 {
 	const char *tablename =3D NULL;
+	const char *modprobe =3D NULL;
 	int c;
=20
 	program_name =3D "iptables-save";
@@ -152,7 +163,7 @@
 	init_extensions();
 #endif
=20
-	while ((c =3D getopt_long(argc, argv, "bcdt:", options, NULL)) !=3D -1) {
+	while ((c =3D getopt_long(argc, argv, "bcdt:M:", options, NULL)) !=3D -1)=
 {
 		switch (c) {
 		case 'b':
 			show_binary =3D 1;
@@ -166,8 +177,11 @@
 			/* Select specific table. */
 			tablename =3D optarg;
 			break;
+		case 'M':
+			modprobe =3D optarg;
+			break;
 		case 'd':
-			do_output(tablename);
+			do_output(tablename, modprobe);
 			exit(0);
 		}
 	}
@@ -177,5 +191,5 @@
 		exit(1);
 	}
=20
-	return !do_output(tablename);
+	return !do_output(tablename, modprobe);
 }


--=20
Soren Hansen                 |=20
Lead Virtualisation Engineer | Ubuntu Server Team
Canonical Ltd.               | http://www.ubuntu.com/

--JWEK1jqKZ6MHAcjA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkm+Ox8ACgkQo+Mz6+DAzGyQxQP+Oql8wIQSfzypo9uTZCN2wb27
5EeXGFvBw8Z9pnn5LZ1+KeYb9Vdh+o+lYKO8QiEqk+kLgvADcFwtgIgke2Q3CSIg
qGA3/cSPJyNdRl+efJ3y3JpY5CrzmHHBE/sMcMHolbA8f8CcOc5YbjFdlcGenUM/
t4ZxD96p6omAWQArnNk=
=OYTo
-----END PGP SIGNATURE-----

--JWEK1jqKZ6MHAcjA--
