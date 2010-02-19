From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: [PATCH] MASQUERADE: fix --to-ports parser
Date: Fri, 19 Feb 2010 06:30:19 +0300
Message-ID: <20100219033019.GB25665@wo.int.altlinux.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nVMJ2NtxeReIH9PS"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vint.altlinux.org ([194.107.17.35]:43041 "EHLO
	vint.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242Ab0BSDaU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Feb 2010 22:30:20 -0500
Received: from wo.int.altlinux.org (wo.int.altlinux.org [192.168.1.4])
	by vint.altlinux.org (Postfix) with ESMTP id 76D2E226C001
	for <netfilter-devel@vger.kernel.org>; Fri, 19 Feb 2010 03:30:19 +0000 (UTC)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--nVMJ2NtxeReIH9PS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Rewrite port range validator to use xtables_strtoui() and
xtables_param_act().  Original check failed to recognize
such port range errors as "1a-2" and "1-2a".
Also, original parser erroneously denied using port 0,
which is now allowed.

Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
---
 extensions/libipt_MASQUERADE.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUERADE.c
index 9d7fc17..3386ff3 100644
--- a/extensions/libipt_MASQUERADE.c
+++ b/extensions/libipt_MASQUERADE.c
@@ -38,34 +38,34 @@ static void MASQUERADE_init(struct xt_entry_target *t)
 static void
 parse_ports(const char *arg, struct nf_nat_multi_range *mr)
 {
-	const char *dash;
-	int port;
+	char *end;
+	unsigned int port, maxport;
=20
 	mr->range[0].flags |=3D IP_NAT_RANGE_PROTO_SPECIFIED;
=20
-	port =3D atoi(arg);
-	if (port <=3D 0 || port > 65535)
-		xtables_error(PARAMETER_PROBLEM, "Port \"%s\" not valid\n", arg);
+	if (!xtables_strtoui(arg, &end, &port, 0, UINT16_MAX))
+		xtables_param_act(XTF_BAD_VALUE, "MASQUERADE", "--to-ports", arg);
=20
-	dash =3D strchr(arg, '-');
-	if (!dash) {
+	switch (*end) {
+	case '\0':
 		mr->range[0].min.tcp.port
 			=3D mr->range[0].max.tcp.port
 			=3D htons(port);
-	} else {
-		int maxport;
+		return;
+	case '-':
+		if (!xtables_strtoui(end + 1, NULL, &maxport, 0, UINT16_MAX))
+			break;
=20
-		maxport =3D atoi(dash + 1);
-		if (maxport =3D=3D 0 || maxport > 65535)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Port `%s' not valid\n", dash+1);
 		if (maxport < port)
-			/* People are stupid.  Present reader excepted. */
-			xtables_error(PARAMETER_PROBLEM,
-				   "Port range `%s' funky\n", arg);
+			break;
+
 		mr->range[0].min.tcp.port =3D htons(port);
 		mr->range[0].max.tcp.port =3D htons(maxport);
+		return;
+	default:
+		break;
 	}
+	xtables_param_act(XTF_BAD_VALUE, "MASQUERADE", "--to-ports", arg);
 }
=20
 static int MASQUERADE_parse(int c, char **argv, int invert, unsigned int *=
flags,


--=20
ldv

--nVMJ2NtxeReIH9PS
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkt+BcsACgkQfKvmrJ41Nh6XbgCgp5adndnUNOwVI5xVzfZN5gx7
tBIAn1ew6JnPfvZqVu+YTJTE2cQy9Osm
=ff1p
-----END PGP SIGNATURE-----

--nVMJ2NtxeReIH9PS--
