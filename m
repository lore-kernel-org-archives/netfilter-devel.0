From: Soren Hansen <soren@ubuntu.com>
Subject: Re: Automatically load modules in iptables-save
Date: Thu, 19 Mar 2009 17:43:27 +0100
Message-ID: <20090319164327.GH20472@ralph.linux2go.dk>
References: <20090319154301.GF20472@ralph.linux2go.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l06SQqiZYCi8rTKz"
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from atlas.linux2go.dk ([88.198.22.52]:53088 "EHLO atlas.linux2go.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbZCSQnf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Mar 2009 12:43:35 -0400
Content-Disposition: inline
In-Reply-To: <20090319154301.GF20472@ralph.linux2go.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--l06SQqiZYCi8rTKz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 19, 2009 at 04:43:01PM +0100, Soren Hansen wrote:
> On Thu, Mar 19, 2009 at 03:31:25PM +0100, Jan Engelhardt wrote:
> >>How about the case where someone calls "iptables-save -t foo"? Should
> >>that just return an empty string and exit(0), should it attempt module
> >>load to see if that's even a valid table or something entirely
> >>different?
> >=20
> > It should load x_tables.ko and the table... I have a suspicion
> > some unknown users might expect to see "*foo" when using -t.
>=20
> Alright. This patch should make everyone happy, then..

Sorry, this is better:


Index: iptables-1.4.1.1/iptables-save.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables-1.4.1.1.orig/iptables-save.c	2009-03-19 16:08:12.571341329 +01=
00
+++ iptables-1.4.1.1/iptables-save.c	2009-03-19 17:29:54.623322505 +0100
@@ -28,11 +28,12 @@
 	{.name =3D "counters", .has_arg =3D false, .val =3D 'c'},
 	{.name =3D "dump",     .has_arg =3D false, .val =3D 'd'},
 	{.name =3D "table",    .has_arg =3D true,  .val =3D 't'},
+	{.name =3D "modprobe", .has_arg =3D true,  .val =3D 'M'},
 	{NULL},
 };
=20
 /* Debugging prototype. */
-static int for_each_table(int (*func)(const char *tablename))
+static int for_each_table(int (*func)(const char *tablename, const char *m=
odprobe), const char *modprobe)
 {
 	int ret =3D 1;
 	FILE *procfile =3D NULL;
@@ -40,9 +41,7 @@
=20
 	procfile =3D fopen("/proc/net/ip_tables_names", "r");
 	if (!procfile)
-		exit_error(OTHER_PROBLEM,
-			   "Unable to open /proc/net/ip_tables_names: %s\n",
-			   strerror(errno));
+		exit(0);
=20
 	while (fgets(tablename, sizeof(tablename), procfile)) {
 		if (tablename[strlen(tablename) - 1] !=3D '\n')
@@ -50,22 +49,27 @@
 				   "Badly formed tablename `%s'\n",
 				   tablename);
 		tablename[strlen(tablename) - 1] =3D '\0';
-		ret &=3D func(tablename);
+		ret &=3D func(tablename, modprobe);
 	}
=20
 	return ret;
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
@@ -134,6 +138,7 @@
 #endif
 {
 	const char *tablename =3D NULL;
+	const char *modprobe =3D NULL;
 	int c;
=20
 	program_name =3D "iptables-save";
@@ -152,8 +157,8 @@
 	init_extensions();
 #endif
=20
-	while ((c =3D getopt_long(argc, argv, "bcdt:", options, NULL)) !=3D -1) {
-		switch (c) {
+	while ((c =3D getopt_long(argc, argv, "bcdt:M:", options, NULL)) !=3D -1)=
 {
+	switch (c) {
 		case 'b':
 			show_binary =3D 1;
 			break;
@@ -166,8 +171,11 @@
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
@@ -177,5 +185,5 @@
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

--l06SQqiZYCi8rTKz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAknCdi8ACgkQo+Mz6+DAzGxZIwQAgUJ3sln7KdhyncUIOujqlUaL
gODPfBBlnNAjz1mAfPR4/lrFh79L/dNJ8gtYFxTd36tO+6u87QEMR0Kne2UfNqPa
LvAv+aGP13dnu0iu96QhayjRU1KRRPsR/FCDj0yBCOaxdbYsfbti0HW4Q/qAsRka
Oo+plBJB9jgw8jcIk4s=
=/IV2
-----END PGP SIGNATURE-----

--l06SQqiZYCi8rTKz--
