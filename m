From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] CTA_PROTO_NUM is u_int8_t not u_int16_t (was Re:
	CTA_PROTO_NUM u_int8_t or u_int16_t)
Date: Thu, 24 Nov 2005 21:07:36 +0100
Message-ID: <20051124200736.GW31478@sunbeam.de.gnumonks.org>
References: <4381DF77.2030704@eurodev.net> <4381FDF8.6030508@trash.net>
	<43820874.2050708@eurodev.net> <4382A19D.9090201@trash.net>
	<43836BAF.2050501@eurodev.net>
	<Pine.LNX.4.64.0511222103050.9114@bizon.gios.gov.pl>
	<20051122220606.GC31478@sunbeam.de.gnumonks.org>
	<4383C2C9.8050109@eurodev.net> <43843ACE.4050808@trash.net>
	<Pine.LNX.4.64.0511231128510.9162@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AtXsXeW4wxbQU8GE"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0511231128510.9162@bizon.gios.gov.pl>
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


--AtXsXeW4wxbQU8GE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 23, 2005 at 11:31:18AM +0100, Krzysztof Oledzki wrote:
>=20
>=20
> On Wed, 23 Nov 2005, Patrick McHardy wrote:
>=20
> >Pablo Neira wrote:
> >>Harald Welte wrote:
> >>>another alternative was to introduce a new CTA_PROTO_NUM8 value, which
> >>>is more explicit (but somehow stupid).
> >>Why don't we send a patch to -stable? I think that most people will use
> >>lastest stable branch in 2.6.14, so only < 2.6.14.3 would be broken. I
> >>still don't like too much the idea of adding a new field just because of
> >>this bugfix :(
> >I would be fine with this.
>=20
> Can we make it before 2.6.14.3? I don't know how long we are going to wai=
t for 2.6.14.4.

what about the following fix?  If no objections arise, I'll submit it
tomorrow.

diff --git a/include/linux/netfilter/nfnetlink_conntrack.h b/include/linux/=
netfilter/nfnetlink_conntrack.h
--- a/include/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/linux/netfilter/nfnetlink_conntrack.h
@@ -58,12 +58,13 @@ enum ctattr_ip {
=20
 enum ctattr_l4proto {
 	CTA_PROTO_UNSPEC,
-	CTA_PROTO_NUM,
+	CTA_PROTO_NUM,		/* old 16bit CTA_PROTO, pre-2.6.15 */
 	CTA_PROTO_SRC_PORT,
 	CTA_PROTO_DST_PORT,
 	CTA_PROTO_ICMP_ID,
 	CTA_PROTO_ICMP_TYPE,
 	CTA_PROTO_ICMP_CODE,
+	CTA_PROTO,		/* new CTA_PROTO value, 8bit width */
 	__CTA_PROTO_MAX
 };
 #define CTA_PROTO_MAX (__CTA_PROTO_MAX - 1)
diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter=
/ip_conntrack_netlink.c
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -57,7 +57,7 @@ ctnetlink_dump_tuples_proto(struct sk_bu
 	struct ip_conntrack_protocol *proto;
 	int ret =3D 0;
=20
-	NFA_PUT(skb, CTA_PROTO_NUM, sizeof(u_int8_t), &tuple->dst.protonum);
+	NFA_PUT(skb, CTA_PROTO, sizeof(u_int8_t), &tuple->dst.protonum);
=20
 	/* If no protocol helper is found, this function will return the
 	 * generic protocol helper, so proto won't *ever* be NULL */
@@ -508,6 +508,7 @@ static const size_t cta_min_proto[CTA_PR
 	[CTA_PROTO_ICMP_TYPE-1]	=3D sizeof(u_int8_t),
 	[CTA_PROTO_ICMP_CODE-1]	=3D sizeof(u_int8_t),
 	[CTA_PROTO_ICMP_ID-1]	=3D sizeof(u_int16_t),
+	[CTA_PROTO-1]		=3D sizeof(u_int8_t),
 };
=20
 static inline int
@@ -525,9 +526,14 @@ ctnetlink_parse_tuple_proto(struct nfatt
 	if (nfattr_bad_size(tb, CTA_PROTO_MAX, cta_min_proto))
 		return -EINVAL;
=20
-	if (!tb[CTA_PROTO_NUM-1])
+	/* CTA_PROTO_NUM has to be kept for backwards compatibility */
+	if (tb[CTA_PROTO-1])
+		tuple->dst.protonum =3D *(u_int8_t *)NFA_DATA(tb[CTA_PROTO-1]);
+	else if (tb[CTA_PROTO_NUM-1])
+		tuple->dst.protonum =3D=20
+				*(u_int16_t *)NFA_DATA(tb[CTA_PROTO_NUM-1]);
+	else
 		return -EINVAL;
-	tuple->dst.protonum =3D *(u_int16_t *)NFA_DATA(tb[CTA_PROTO_NUM-1]);
=20
 	proto =3D ip_conntrack_proto_find_get(tuple->dst.protonum);
=20
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--AtXsXeW4wxbQU8GE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDhh2IXaXGVTD0i/8RAjJrAKCXmTtVXnpR56Bz+aQefCWt7p/Y5gCdE880
J9AYrtUtSFSrOm0okthiTto=
=rObD
-----END PGP SIGNATURE-----

--AtXsXeW4wxbQU8GE--
