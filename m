From: Christophe Saout <christophe@saout.de>
Subject: Re: 2.6.16-rc1-mm3 XFRM+NAT issue
Date: Mon, 30 Jan 2006 00:30:38 +0100
Message-ID: <1138577438.28895.1.camel@leto.intern.saout.de>
References: <1138563710.26998.22.camel@leto.intern.saout.de>
	<43DD1E3E.70503@trash.net>	<1138568354.21229.1.camel@leto.intern.saout.de>
	<43DD3E3D.5070201@trash.net>
	<1138573848.28464.1.camel@leto.intern.saout.de>
	<43DD48CC.9070709@trash.net>
	<1138577096.28609.13.camel@leto.intern.saout.de>
	<43DD4F31.8030807@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-4AkDPnZUk8wCXH8Vwvya"
Cc: netfilter-devel@lists.netfilter.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <43DD4F31.8030807@trash.net>
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


--=-4AkDPnZUk8wCXH8Vwvya
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Am Montag, den 30.01.2006, 00:26 +0100 schrieb Patrick McHardy:

> >>Found it, the packet doesn't have its dst_entry released after DNAT in
> >>PRE_ROUTING because of an incorrect check and is delivered locally.
> >>This patch should fix it.
>
> Actually it seems I got confused, the check looks right. Can you post
> the output of /proc/net/ip_conntrack for this connection please?

tcp      6 431980 ESTABLISHED src=3D192.168.80.90 dst=3D<inet host>
sport=3D33816 dport=3D22 packets=3D22 bytes=3D3972 src=3D<inet host> dst=3D=
<gateway
pub ip> sport=3D22 dport=3D33816 packets=3D19 bytes=3D3568 [ASSURED] mark=
=3D0
use=3D1


--=-4AkDPnZUk8wCXH8Vwvya
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBD3VAdZCYBcts5dM0RAvqKAJ4uvbVye7hh4fVXzauOWPlrAzVIJgCdFFCR
xd8gbqgzKZxVT0YoBpOiMOI=
=Lb69
-----END PGP SIGNATURE-----

--=-4AkDPnZUk8wCXH8Vwvya--
