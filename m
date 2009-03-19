From: Soren Hansen <soren@ubuntu.com>
Subject: Re: Automatically load modules in iptables-save
Date: Thu, 19 Mar 2009 16:43:01 +0100
Message-ID: <20090319154301.GF20472@ralph.linux2go.dk>
References: <20090316171014.GG31952@ralph.linux2go.dk> <20090319125532.GC20472@ralph.linux2go.dk> <49C24332.2020107@trash.net> <20090319135006.GD20472@ralph.linux2go.dk> <alpine.LSU.2.00.0903191452550.27642@fbirervta.pbzchgretzou.qr> <20090319142935.GE20472@ralph.linux2go.dk> <alpine.LSU.2.00.0903191530310.31487@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="juZjCTNxrMaZdGZC"
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from atlas.linux2go.dk ([88.198.22.52]:59444 "EHLO atlas.linux2go.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbZCSPnS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Mar 2009 11:43:18 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0903191530310.31487@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--juZjCTNxrMaZdGZC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 19, 2009 at 03:31:25PM +0100, Jan Engelhardt wrote:
>>How about the case where someone calls "iptables-save -t foo"? Should
>>that just return an empty string and exit(0), should it attempt module
>>load to see if that's even a valid table or something entirely
>>different?
>=20
> It should load x_tables.ko and the table... I have a suspicion
> some unknown users might expect to see "*foo" when using -t.

Alright. This patch should make everyone happy, then..


Index: iptables-1.4.1.1/iptables-save.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables-1.4.1.1.orig/iptables-save.c	2009-03-19 16:03:12.800343689 +01=
00
+++ iptables-1.4.1.1/iptables-save.c	2009-03-19 16:07:45.095342140 +0100
@@ -28,17 +28,21 @@
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
 	char tablename[IPT_TABLE_MAXNAMELEN+1];
=20
 	procfile =3D fopen("/proc/net/ip_tables_names", "r");
+	if (!procfile) {
+		exit(0);
+	}
 	if (!procfile)
 		exit_error(OTHER_PROBLEM,
 			   "Unable to open /proc/net/ip_tables_names: %s\n",
@@ -50,22 +54,27 @@
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
@@ -134,6 +143,7 @@
 #endif
 {
 	const char *tablename =3D NULL;
+	const char *modprobe =3D NULL;
 	int c;
=20
 	program_name =3D "iptables-save";
@@ -152,8 +162,8 @@
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
@@ -166,8 +176,11 @@
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
@@ -177,5 +190,5 @@
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

--juZjCTNxrMaZdGZC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAknCaAQACgkQo+Mz6+DAzGxr0QP/Qh+Z1GqgF1vbSokNmA1axmdG
xa3AIhRlQ9oFbafPOwGDiqfzHUGgh5HaI0eoIp/SikAUV8DuU/zSBl/V6kUKFqJn
izEVBKuCXd6PHUoSVc5ArtfW4cYeInRmPh2hex5F2bhZFkysgXKGMr+wedqXV6MO
Njgze6XMOrpLD1muCzk=
=sxtO
-----END PGP SIGNATURE-----

--juZjCTNxrMaZdGZC--
