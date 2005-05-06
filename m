From: Christian Hentschel <chentschel@arnet.com.ar>
Subject: Re: ip_nat_mangle_udp_packet problems
Date: Fri, 06 May 2005 15:50:21 -0300
Message-ID: <1115405421.1847.26.camel@www.l-chr.com.ar>
References: <1115310771.1852.11.camel@www.l-chr.com.ar>
	<427B9A38.2040602@trash.net>
	<1115404044.1847.19.camel@www.l-chr.com.ar>
	<427BB931.60709@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-ANLhSg4UHp9a/VOTXRfE"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <427BB931.60709@trash.net>
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


--=-ANLhSg4UHp9a/VOTXRfE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2005-05-06 at 20:36 +0200, Patrick McHardy wrote:
> Christian Hentschel wrote:
> > What i see in enlarge_skb() is that if packet is larger than 65536 it
> > does as u said a copy.
>=20
> No, it drops it if it gets this large. skb_copy_expand(), as it name
> implies, copies the packet to a new one with more room.

:).. sorry i didn't see thee return.=20

> > I see that enlarge_skb() does the "reload" of the pointer to pskb,
> > pointing it to the enlarged skbuff. This is what u meant?
> >=20
> >         kfree_skb(*pskb);
> >         *pskb =3D nskb;
> >         return 1;
>=20
> Not really. What I meant is that if you have something like this before
> the call to ip_nat_mangle_udp_packet():
>=20
> struct udphdr *uh =3D (void *)(*pskb)->nh.iph + (*pskb)->nh.iph->ihl*4;
>=20
> then you need to reload the pointer after the call like this:
>=20
> uh =3D (void *)(*pskb)->nh.iph + (*pskb)->nh.iph->ihl*4;
>=20
> otherwise it might point to the old and already freed skb.

Well, this helps me a lot!!

> Just post your code if this doesn't help.

Thanks a lot again!.=20

--=20
Christian Hentschel <chentschel@arnet.com.ar>

--=-ANLhSg4UHp9a/VOTXRfE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBCe7xt/jxG54BC3LgRAndeAJ9boaQ0nFvHyVFByzbuoycmH0V31gCfSegw
mtWSxc3nGFhsGvDPrxPgUZU=
=v/G1
-----END PGP SIGNATURE-----

--=-ANLhSg4UHp9a/VOTXRfE--
