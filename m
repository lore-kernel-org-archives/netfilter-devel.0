From: netfilter@interlinx.bc.ca
Subject: [PATCH] Amanda conntrack/nat module update
Date: Fri, 1 Nov 2002 18:23:37 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021101232337.GD16306@pc.ilinx>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bi5JUZtvcfApsciF"
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


--bi5JUZtvcfApsciF
Content-Type: multipart/mixed; boundary="M38YqGLZlgb6RLPS"
Content-Disposition: inline


--M38YqGLZlgb6RLPS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Harald and friends,

Please find attached an update patch to patch-o-matic for my Amanda
protocol conntrack/nat helper.  This patch corrects a minor error in
the Config.in indentation as well as, and more importantly, lengthens
the timeout for the master Amanda connection from the default UDP
stream timeout (normally 180 seconds) to 300 seconds.

This is required, because the Amanda server can tell the client to go
off and do some work (i.e. estimate the size of backups at various
incremental levels) and while the client is doing the work, no
communication will occur.  It is not uncommon for a client to take in
excess of 180 seconds to do the estimates.  Indeed, on my network
here, the value of 300 seconds is sufficient while 180 is not.

Additionally, this value can be tuned at module load time with a
module parameter, "master_timeout".

I would be most appreciative if you could apply this patch to
patch-o-matic at your earliest convenience.

In case anyone is interested, this patch implements a solution to my
question in this (incorrectly subjected) mailing list posting:

http://lists.netfilter.org/pipermail/netfilter-devel/2002-October/009676.ht=
ml

Thanx,
b.

--=20
Brian J. Murrell

--M38YqGLZlgb6RLPS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="amanda-pom.patch"
Content-Transfer-Encoding: quoted-printable

Index: extra/amanda-conntrack-nat.patch
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
RCS file: /cvspublic/netfilter/patch-o-matic/extra/amanda-conntrack-nat.pat=
ch,v
retrieving revision 1.1
diff -u -r1.1 amanda-conntrack-nat.patch
--- extra/amanda-conntrack-nat.patch	15 Sep 2002 11:37:15 -0000	1.1
+++ extra/amanda-conntrack-nat.patch	1 Nov 2002 23:21:06 -0000
@@ -34,10 +34,10 @@
 diff -uNr linux-2.4.18-6mdk-pom-clean/net/ipv4/netfilter/ip_conntrack_aman=
da.c linux-2.4.18-6mdkuml-48um-pom/net/ipv4/netfilter/ip_conntrack_amanda.c
 --- linux-2.4.18-6mdk-pom-clean/net/ipv4/netfilter/ip_conntrack_amanda.c	1=
969-12-31 19:00:00.000000000 -0500
 +++ linux-2.4.18-6mdkuml-48um-pom/net/ipv4/netfilter/ip_conntrack_amanda.c=
	2002-08-16 04:24:25.000000000 -0400
-@@ -0,0 +1,219 @@
-+/* Amanda extension for IP connection tracking, Version 0.1
+@@ -0,0 +1,233 @@
++/* Amanda extension for IP connection tracking, Version 0.2
 + * (C) 2002 by Brian J. Murrell <netfilter@interlinx.bc.ca>
-+ * based on HW's ip_conntrack_irc.c	as well as other modules
++ * based on HW's ip_conntrack_irc.c as well as other modules
 + *
 + *      This program is free software; you can redistribute it and/or
 + *      modify it under the terms of the GNU General Public License
@@ -45,7 +45,13 @@
 + *      2 of the License, or (at your option) any later version.
 + *
 + *	Module load syntax:
-+ * 	insmod ip_conntrack_amanda.o
++ * 	insmod ip_conntrack_amanda.o [master_timeout=3Dn]
++ *=09
++ *	Where master_timeout is the timeout (in seconds) of the master
++ *	connection (port 10080).  This defaults to 5 minutes but if
++ *	your clients take longer than 5 minutes to do their work
++ *	before getting back to the Amanda server, you can increase
++ *	this value.
 + *
 + */
 +
@@ -59,9 +65,13 @@
 +#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 +#include <linux/netfilter_ipv4/ip_conntrack_amanda.h>
 +
++static unsigned int master_timeout =3D 300;
++
 +MODULE_AUTHOR("Brian J. Murrell <netfilter@interlinx.bc.ca>");
 +MODULE_DESCRIPTION("Amanda connection tracking module");
 +MODULE_LICENSE("GPL");
++MODULE_PARM(master_timeout, "i");
++MODULE_PARM_DESC(master_timeout, "timeout for the master connection");
 +
 +DECLARE_LOCK(ip_amanda_lock);
 +struct module *ip_conntrack_amanda =3D THIS_MODULE;
@@ -97,6 +107,10 @@
 +	/* Can't track connections formed before we registered */
 +	if (!info)
 +		return NF_ACCEPT;
++
++	/* increase the UDP timeout of the master connection as replies from
++	 * Amanda clients to the server can be quite delayed */
++	ip_ct_refresh(ct, master_timeout * HZ);
 +
 +	/* If packet is coming from Amanda server */
 +	if (dir =3D=3D IP_CT_DIR_ORIGINAL)
Index: extra/amanda-conntrack-nat.patch.config.in-2
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
RCS file: /cvspublic/netfilter/patch-o-matic/extra/amanda-conntrack-nat.pat=
ch.config.in-2,v
retrieving revision 1.1
diff -u -r1.1 amanda-conntrack-nat.patch.config.in-2
--- extra/amanda-conntrack-nat.patch.config.in-2	15 Sep 2002 11:37:15 -0000=
	1.1
+++ extra/amanda-conntrack-nat.patch.config.in-2	1 Nov 2002 23:21:06 -0000
@@ -1,6 +1,6 @@
       dep_tristate '    REDIRECT target support' CONFIG_IP_NF_TARGET_REDIR=
ECT $CONFIG_IP_NF_NAT
       if [ "$CONFIG_IP_NF_AMANDA" =3D "m" ]; then
-       define_tristate CONFIG_IP_NF_NAT_AMANDA m
+        define_tristate CONFIG_IP_NF_NAT_AMANDA m
       else
         if [ "$CONFIG_IP_NF_AMANDA" =3D "y" ]; then
           define_tristate CONFIG_IP_NF_NAT_AMANDA $CONFIG_IP_NF_NAT

--M38YqGLZlgb6RLPS--

--bi5JUZtvcfApsciF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9wwz5l3EQlGLyuXARAkjWAKCgeCectMwDfJvk8zkazIT/169GLwCgtmo/
F2866+tsjUsPxE6cUCuqBNo=
=89lD
-----END PGP SIGNATURE-----

--bi5JUZtvcfApsciF--
