From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] CTA_PROTO_NUM is u_int8_t not u_int16_t (was Re:
	CTA_PROTO_NUM u_int8_t or u_int16_t)
Date: Thu, 24 Nov 2005 21:21:25 +0100
Message-ID: <20051124202125.GX31478@sunbeam.de.gnumonks.org>
References: <4381FDF8.6030508@trash.net> <43820874.2050708@eurodev.net>
	<4382A19D.9090201@trash.net> <43836BAF.2050501@eurodev.net>
	<Pine.LNX.4.64.0511222103050.9114@bizon.gios.gov.pl>
	<20051122220606.GC31478@sunbeam.de.gnumonks.org>
	<4383C2C9.8050109@eurodev.net> <43843ACE.4050808@trash.net>
	<Pine.LNX.4.64.0511231128510.9162@bizon.gios.gov.pl>
	<20051124200736.GW31478@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z61G0Sb+dz47cW6F"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>, Patrick McHardy <kaber@trash.net>,
	Pablo Neira <pablo@eurodev.net>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20051124200736.GW31478@sunbeam.de.gnumonks.org>
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


--z61G0Sb+dz47cW6F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Sorry, forget that other patch.

The only way how we can thoroughly solve (and avoid) this problem, also
for future cases, is to behave like 'real' TLV parsers (e.g. ASN1).

That is, for any kind of numeric values, we don't make an assumption
that the attribute has a certain fixed size.  Instead, we derive the
(u8/u16/u32/u64) size from the length of the attribute, i.e.
NFA_PAYLOAD() is 1/2/4/8 bytes long.

This is a quick and dirty patch to demonstrate what I mean:

=3D=3D=3D=3D=3D

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter=
/ip_conntrack_netlink.c
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -502,12 +502,13 @@ ctnetlink_parse_tuple_ip(struct nfattr *
 }
=20
 static const size_t cta_min_proto[CTA_PROTO_MAX] =3D {
-	[CTA_PROTO_NUM-1]	=3D sizeof(u_int16_t),
+	[CTA_PROTO_NUM-1]	=3D sizeof(u_int8_t),
 	[CTA_PROTO_SRC_PORT-1]	=3D sizeof(u_int16_t),
 	[CTA_PROTO_DST_PORT-1]	=3D sizeof(u_int16_t),
 	[CTA_PROTO_ICMP_TYPE-1]	=3D sizeof(u_int8_t),
 	[CTA_PROTO_ICMP_CODE-1]	=3D sizeof(u_int8_t),
 	[CTA_PROTO_ICMP_ID-1]	=3D sizeof(u_int16_t),
+	[CTA_PROTO-1]		=3D sizeof(u_int8_t),
 };
=20
 static inline int
@@ -527,7 +528,18 @@ ctnetlink_parse_tuple_proto(struct nfatt
=20
 	if (!tb[CTA_PROTO_NUM-1])
 		return -EINVAL;
-	tuple->dst.protonum =3D *(u_int16_t *)NFA_DATA(tb[CTA_PROTO_NUM-1]);
+
+	switch (NFA_PAYLOAD(tb[CTA_PROTO_NUM-1]))
+	case sizeof(u_int8_t):
+		tuple->dst.protonum =3D=20
+				*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_NUM-1]);
+		break;
+	case sizeof(u_int16_t):
+		tuple->dst.protonum =3D=20
+				*(u_int16_t *)NFA_DATA(tb[CTA_PROTO_NUM-1]);
+	default:
+		return -EINVAL;
+	}
=20
 	proto =3D ip_conntrack_proto_find_get(tuple->dst.protonum);

=3D=3D=3D=3D=3D

Obviously, this needs to be moved into a nfnetlink core funciton,
something like a function nfattr_parse_number() that would then be
called from all places that parse a number.

Userspace parsers (libnetfilter_conntrack) would have to introduce the
same semantics.

It might be a bit too much overhead, I'm not really decided yet.  But in
the end, if everybody plays according to that rule, we don't have any
such issues in the future.

Comments?

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--z61G0Sb+dz47cW6F
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDhiDFXaXGVTD0i/8RAhLuAJ93sad2vcxK4Di9VhSJ5XqD513V6gCgqQyx
P6Fd87aRE3G44CilXm8I2zw=
=tMxA
-----END PGP SIGNATURE-----

--z61G0Sb+dz47cW6F--
