From: Harald Welte <laforge@netfilter.org>
Subject: Re: [TRIVIAL PATCH] pptp / kill gcc warnings.
Date: Thu, 3 Nov 2005 19:16:59 +0100
Message-ID: <20051103181659.GK905@sunbeam.de.gnumonks.org>
References: <200508011208.19824.pluto@agmk.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8tZVdKiiYitVG083"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pawel Sikora <pluto@agmk.net>
Content-Disposition: inline
In-Reply-To: <200508011208.19824.pluto@agmk.net>
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


--8tZVdKiiYitVG083
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 01, 2005 at 12:08:19PM +0200, Pawel Sikora wrote:
>=20

>   CC [M]  net/ipv4/netfilter/ip_conntrack_proto_gre.o
>           net/ipv4/netfilter/ip_conntrack_proto_gre.c: In function 'gre_p=
acket':
>           net/ipv4/netfilter/ip_conntrack_proto_gre.c:283: warning:
>            passing argument 3 of 'ip_ct_refresh_acct' discards qualifiers=
 from pointer target type
>           net/ipv4/netfilter/ip_conntrack_proto_gre.c:288: warning:
>            passing argument 3 of 'ip_ct_refresh_acct' discards qualifiers=
 from pointer target type
>           net/ipv4/netfilter/ip_conntrack_proto_gre.c: At top level:
>           net/ipv4/netfilter/ip_conntrack_proto_gre.c:329: warning:
>            initialization from incompatible pointer type
>=20
> Index: linux-2.6.11/net/ipv4/netfilter/ip_conntrack_proto_gre.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.11/net/ipv4/netfilter/ip_conntrack_proto_gre.c	(revision 42=
08)
> +++ linux-2.6.11/net/ipv4/netfilter/ip_conntrack_proto_gre.c	(working cop=
y)
> @@ -273,7 +273,7 @@
> =20
>  /* Returns verdict for packet, and may modify conntrack */
>  static int gre_packet(struct ip_conntrack *ct,
> -		      const struct sk_buff *skb,
> +		      struct sk_buff *skb,
>  		      enum ip_conntrack_info conntrackinfo)
>  {
>  	/* If we've seen traffic both ways, this is a GRE connection.

this patch is invalid.  Actually, you just move the warning to a
different place.  the 'gre_packet()' function is a function pointer to
'struct ip_conntrack_protocol', which rquires the third parameter to be
a 'const struct sk_buff *'. =20

I also don't understand why you get that warning.  ip_ct_refresh_acct()
also takes a 'const' argument ?!?



--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--8tZVdKiiYitVG083
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDalQbXaXGVTD0i/8RAiKCAJ9qb9bssdlsehnbQE/b3TX0b9AY6gCdGHhx
vJafSsAes+Nyw3EtaoI9/SY=
=516G
-----END PGP SIGNATURE-----

--8tZVdKiiYitVG083--
