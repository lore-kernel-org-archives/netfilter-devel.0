From: Christian Hentschel <chentschel@arnet.com.ar>
Subject: Re: ip_nat_mangle_udp_packet problems
Date: Fri, 06 May 2005 15:27:24 -0300
Message-ID: <1115404044.1847.19.camel@www.l-chr.com.ar>
References: <1115310771.1852.11.camel@www.l-chr.com.ar>
	<427B9A38.2040602@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-pbgsom+TtdFXPVNty6Wl"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <427B9A38.2040602@trash.net>
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


--=-pbgsom+TtdFXPVNty6Wl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2005-05-06 at 18:24 +0200, Patrick McHardy wrote:
> Christian Hentschel wrote:
> > Hi,=20
> > 	i hope someone could answer this problem i'm experimenting. I'm writin=
g
> > a SIP/RTP conntrack/NAT helper, and i need to mangle packets multiple
> > times, since there are lots of fields to be mangled.
> > 	I'm using new conntrack/nat framework (>2.6.11) and the way i took to
> > do it is causing me some problems.
> > 	Basically, i just look for string into the packet, mangle it and call
> > ip_nat_mangle_udp_packet(). The problem is when i try to search the
> > nexts strings, i get the wrong offsets.=20
> > I saw ip_nat_mangle_udp_packet() does not do it manipulation
> > immediatelly. Please could someone explain this ?.
>=20
> enlarge_skb() called from ip_nat_mangle_udp_packet() might replace the
> packet if it doesn't fit. You need to reload all pointers to the skb
> after calling ip_nat_mangle_udp_packet().

Hi, well first thanks for answering my problem.=20
What i see in enlarge_skb() is that if packet is larger than 65536 it
does as u said a copy. But i'm mangling <1024bytes packets, and after
mangling searching from the start of the paiload. This is
(*pskb)->nh.iph->ihl*4 + sizeof(struct udphdr).

I see that enlarge_skb() does the "reload" of the pointer to pskb,
pointing it to the enlarged skbuff. This is what u meant?

        kfree_skb(*pskb);
        *pskb =3D nskb;
        return 1;

what is happening is really obscure for me.

Thanks in advance.=20
Christian.

--=20
Christian Hentschel <chentschel@arnet.com.ar>

--=-pbgsom+TtdFXPVNty6Wl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBCe7cM/jxG54BC3LgRAj9FAJ4qq1dTVFRSq6mni/kCdcGa+QG+tACgnWcG
Odf5B6wwj7Hyzq461hZweCs=
=Vtr6
-----END PGP SIGNATURE-----

--=-pbgsom+TtdFXPVNty6Wl--
