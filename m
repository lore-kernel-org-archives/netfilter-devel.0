From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH]: 1st step to remove skb_linearize() in ip6_tables.c and optimization
Date: Sun, 1 Aug 2004 18:46:53 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040801164653.GA10656@sunbeam2>
References: <200406250457.NAA07080@toshiba.co.jp> <Pine.LNX.4.33.0406251133230.11001-100000@blackhole.kfki.hu> <20040721213653.GR27487@obroa-skai.de.gnumonks.org> <200407290609.PAA13928@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Cc: kadlec@blackhole.kfki.hu, kaber@trash.net,
	netfilter-devel@lists.netfilter.org, kisza@securityaudit.hu,
	usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200407290609.PAA13928@toshiba.co.jp>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 29, 2004 at 03:09:02PM +0900, Yasuyuki Kozakai wrote:
> I got time to implement your idea. How about this ? (not tested)
>
> 	struct tcphdr hdr;
> 	struct tcphdr *tcph
>=20
> 	tcph =3D skb_get_bits(skb, &hdr, skb->nh.iph->ihl*4, sizeof(hdr));
>=20
> If skb is neither shared nor cloned, this function linearize up to tcp he=
ader
> and returns the pointer to tcp header in skb.
>=20
> Otherwise, copies tcp header to "hdr" and return the pointer to it.
> If error, return NULL.

This sounds like a very sane approach to me. =20

Since we don't have stable API's in 2.6.x anymore (kernel summit
decision), we could even put this in our pending queue of patches for
something like 2.6.10/2.6.11

What does eveybody else think?  Comments?

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBDR59XaXGVTD0i/8RAh5PAJ9rNJy86dRf52G1D/MUUIq/iie6fwCffSgd
6Zy/aOfqEA3Fk8BQ1Xg1QTU=
=Q53G
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
