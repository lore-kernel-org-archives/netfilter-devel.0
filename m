From: Olivier Mehani <shtrom@ssji.net>
Subject: Re: [xtables-addons] [SOLVED] "unknown option `--gw'" for target
	TEE
Date: Wed, 25 Nov 2009 11:10:12 +0100
Message-ID: <20091125101012.GD4295@lxiv.inria.fr>
References: <20091125083434.GC4295@lxiv.inria.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ryJZkp9/svQ58syV"
Cc: Sebastian =?iso-8859-15?Q?Cla=DFen?=
	<sebastian.classen@freenet.de>, Jan Engelhardt <jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:43088 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758601AbZKYKU1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2009 05:20:27 -0500
Content-Disposition: inline
In-Reply-To: <20091125083434.GC4295@lxiv.inria.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--ryJZkp9/svQ58syV
Content-Type: multipart/mixed; boundary="cHMo6Wbp1wrKhbfi"
Content-Disposition: inline


--cHMo6Wbp1wrKhbfi
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Replying to self, funny how a night's sleep help find new approaches.

On Wed, Nov 25, 2009 at 09:34:34AM +0100, Olivier Mehani wrote:
> # ip6tables -t mangle -A PREROUTING -i eth0 -j TEE --gw PFX1:46ff:fee0:df=
cc
> ip6tables v1.4.5: unknown option `--gw'
> Try `ip6tables -h' or 'ip6tables --help' for more information.
>=20
> As far as my understanding of the doc goes, my command is valid, but it
> doesn't work.

In contradiction with the documentation, the proper parameter is
actually --gateway, thus
# ip6tables -t mangle -A PREROUTING -i eth0 -j TEE --gateway PFX1:EUI64
works like a charm.

Maybe the documentation should be udpated as per the attached patch?
It removes all occurences of --gw in the dor and error messages, and
adds a quick example (quite similar to my scenario).

Finally, beware of router advertisements.

--=20
Olivier Mehani <shtrom@ssji.net>
PGP fingerprint: 4435 CF6A 7C8D DD9B E2DE  F5F9 F012 A6E2 98C6 6655

--cHMo6Wbp1wrKhbfi
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: attachment; filename="TEE-doc.patch"
Content-Transfer-Encoding: quoted-printable

Index: xtables-addons-1.20/extensions/libxt_TEE.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- xtables-addons-1.20.orig/extensions/libxt_TEE.c
+++ xtables-addons-1.20/extensions/libxt_TEE.c
@@ -51,7 +51,7 @@ static int tee_tg_parse(int c, char **ar
 	case 'g':
 		if (*flags & FLAG_GATEWAY)
 			xtables_error(PARAMETER_PROBLEM,
-			           "Cannot specify --gw more than once");
+			           "Cannot specify --gateway more than once");
=20
 		ia =3D xtables_numeric_to_ipaddr(optarg);
 		if (ia =3D=3D NULL)
@@ -76,7 +76,7 @@ static int tee_tg6_parse(int c, char **a
 	case 'g':
 		if (*flags & FLAG_GATEWAY)
 			xtables_error(PARAMETER_PROBLEM,
-			           "Cannot specify --gw more than once");
+			           "Cannot specify --gateway more than once");
=20
 		ia =3D xtables_numeric_to_ip6addr(optarg);
 		if (ia =3D=3D NULL)
Index: xtables-addons-1.20/extensions/libxt_TEE.man
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- xtables-addons-1.20.orig/extensions/libxt_TEE.man
+++ xtables-addons-1.20/extensions/libxt_TEE.man
@@ -3,6 +3,10 @@ machine on the \fBlocal\fP network segme
 must be the target, or you will have to configure the nexthop to forward it
 further if so desired.
 .TP
-\fB\-\-gw\fP \fIipaddr\fP
+\fB\-\-gateway\fP \fIipaddr\fP
 Send the cloned packet to the host reachable at the given IP address.
 Use of 0.0.0.0 (for IPv4 packets) or :: (IPv6) is invalid.
+.TP
+To forward all incoming traffic on eth0 to an IP-level logging box:
+.IP
+\-t mangle -A PREROUTING -i eth0 -j TEE --gateway 2001:db8::1
Index: xtables-addons-1.20/extensions/xt_TEE.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- xtables-addons-1.20.orig/extensions/xt_TEE.c
+++ xtables-addons-1.20/extensions/xt_TEE.c
@@ -175,7 +175,7 @@ tee_tg4(struct sk_buff **pskb, const str
 	/*
 	 * Copy the skb, and route the copy. Will later return %XT_CONTINUE for
 	 * the original skb, which should continue on its way as if nothing has
-	 * happened. The copy should be independently delivered to the TEE --gw.
+	 * happened. The copy should be independently delivered to the TEE --gate=
way.
 	 */
 	skb =3D skb_copy(skb, GFP_ATOMIC);
 	if (skb =3D=3D NULL) {
Index: xtables-addons-1.20/xtables-addons.8
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- xtables-addons-1.20.orig/xtables-addons.8
+++ xtables-addons-1.20/xtables-addons.8
@@ -48,9 +48,13 @@ machine on the \fBlocal\fP network segme
 must be the target, or you will have to configure the nexthop to forward it
 further if so desired.
 .TP
-\fB\-\-gw\fP \fIipaddr\fP
+\fB\-\-gateway\fP \fIipaddr\fP
 Send the cloned packet to the host reachable at the given IP address.
 Use of 0.0.0.0 (for IPv4 packets) or :: (IPv6) is invalid.
+.TP
+To forward all incoming traffic on eth0 to an IP-level logging box:
+.IP
+\-t mangle -A PREROUTING -i eth0 -j TEE --gateway 2001:db8::1
 .SS RAWSNAT
 The \fBRAWSNAT\fR and \fBRAWDNAT\fP targets provide stateless network addr=
ess
 translation.

--cHMo6Wbp1wrKhbfi--

--ryJZkp9/svQ58syV
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJLDQKEAAoJEPASpuKYxmZVUQQH/19EVCP3BwdKyXTcGXIdq+6J
PwWI0Gn0KpX6wPsA6NQgbaaLmxe1EfZk1mD074ylSZg21oL2XFLPtnLO/36OndQc
dipMyBMq2t3OyyFgfJLS/EpJZw4GkkVurqU4C07JTE5f4qYRirW0cjGpF1V5G366
N0M7DGqXpPt2bqrG0ZsN74ms4EBNPOygtZY+ZxOfwhcCQ9uNHnC2UOQuxJ0T0Wkr
Wd9Q7ryZ/leAAKjT0jBvmEjxZLMixYqj5nQHT8+Qu8VhG1FVbTM/tkbW3+zbzEqc
kzCrXmZsXg0S1RdJ0KYDDbRAFwv/8OtrPUxys7PtWOKnAmVhmIMy5SgaQZ93XBA=
=rnnL
-----END PGP SIGNATURE-----

--ryJZkp9/svQ58syV--
