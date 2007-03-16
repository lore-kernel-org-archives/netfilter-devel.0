From: Phil Dibowitz <phil@ipom.com>
Subject: [PATCH] Fix icmp_id setter and doc
Date: Fri, 16 Mar 2007 12:15:05 -0700
Message-ID: <20070316191505.GB26826@ipom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4ZLFUWh1odzi/v6L"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


--4ZLFUWh1odzi/v6L
Content-Type: multipart/mixed; boundary="A6N2fC+uXW/VQSAv"
Content-Disposition: inline


--A6N2fC+uXW/VQSAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

ICMP ID is stored as a u_int16_t, but its setter function derefs it's
arguement as a u_int8_t. Additionally the api "doc" claims it's a u8, when
it's not.

This patch fixes both.

--=20
Phil Dibowitz                             phil@ipom.com
Open Source software and tech docs        Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"Never write it in C if you can do it in 'awk';
 Never do it in 'awk' if 'sed' can handle it;
 Never use 'sed' when 'tr' can do the job;
 Never invoke 'tr' when 'cat' is sufficient;
 Avoid using 'cat' whenever possible" -- Taylor's Laws of Programming


--A6N2fC+uXW/VQSAv
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="libnetfilter_conntrack-0.0.50_icmp_id.patch"
Content-Transfer-Encoding: quoted-printable

--- libnetfilter_conntrack-0.0.50/include/libnetfilter_conntrack/libnetfilt=
er_conntrack.h.orig	2007-03-16 12:07:40.000000000 -0700
+++ libnetfilter_conntrack-0.0.50/include/libnetfilter_conntrack/libnetfilt=
er_conntrack.h	2007-03-16 12:08:25.000000000 -0700
@@ -359,7 +359,7 @@
 	ATTR_REPL_PORT_DST,		/* u16 bits */
 	ATTR_ICMP_TYPE =3D 12,		/* u8 bits */
 	ATTR_ICMP_CODE,			/* u8 bits */
-	ATTR_ICMP_ID,			/* u8 bits */
+	ATTR_ICMP_ID,			/* u16 bits */
 	ATTR_ORIG_L3PROTO,		/* u8 bits */
 	ATTR_REPL_L3PROTO =3D 16,		/* u8 bits */
 	ATTR_ORIG_L4PROTO,		/* u8 bits */
--- libnetfilter_conntrack-0.0.50/src/conntrack/setter.c.orig	2007-03-16 12=
:08:52.000000000 -0700
+++ libnetfilter_conntrack-0.0.50/src/conntrack/setter.c	2007-03-16 12:09:0=
0.000000000 -0700
@@ -79,7 +79,7 @@
=20
 static void set_attr_icmp_id(struct nf_conntrack *ct, const void *value)
 {
-	ct->tuple[__DIR_ORIG].l4src.icmp.id =3D *((u_int8_t *) value);
+	ct->tuple[__DIR_ORIG].l4src.icmp.id =3D *((u_int16_t *) value);
 }
=20
 static void set_attr_orig_l3proto(struct nf_conntrack *ct, const void *val=
ue)

--A6N2fC+uXW/VQSAv--

--4ZLFUWh1odzi/v6L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF+uy5N5XoxaHnMrsRAp3LAJ0SsdC2irA8b4HGhzzhcaQ0zS61sQCdEFeL
woe0j+SiNT5YdR6NoQoE3rU=
=iWw/
-----END PGP SIGNATURE-----

--4ZLFUWh1odzi/v6L--
