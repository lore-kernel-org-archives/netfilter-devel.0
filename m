From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC] cloned skbs - if i am right there is a bug in ipt_ECN.c
Date: Sat, 13 Dec 2003 09:53:58 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031213085358.GF8950@obroa-skai.de.gnumonks.org>
References: <002701c3c0ea$e26efa70$0e25fe0a@southpark.ae.poznan.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2FkSFaIQeDFoAt0B"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Content-Disposition: inline
In-Reply-To: <002701c3c0ea$e26efa70$0e25fe0a@southpark.ae.poznan.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--2FkSFaIQeDFoAt0B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 12, 2003 at 09:02:25PM +0100, Maciej Soltysiak wrote:
> I know it may sound lame. All of this came out when I was hacking
> on some netfilter module and noticed, that there might be a bug in
> ipt_ECN.c:
>=20
> in set_ect_tcp() we have:
>                 kfree_skb(*pskb);
>                 *pskb =3D nskb;
>                 iph =3D (*pskb)->nh.iph;
>         }
>=20
> But iph is not used, we are using tcph later on in the code, so we should:
>                 tcph =3D (*pskb)->nh.tcph;
>=20
> If this is not a bug, that line could be at least removed, because iph is
> not used.

This is indeed a bug.  This one is only present in 2.4.x, 2.6.x has a
quite seperate code piece in that function.

> If this my mail shows my ignorance with reading some docs, please show me
> which should i read.

I doubt there would be any other way than RTFS ;)

> Regards,
> Maciej

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--2FkSFaIQeDFoAt0B
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/2tOlXaXGVTD0i/8RAsO1AJ4yU9LyPbW+ZTo2zx0dYeIyCng79wCgss3B
LMHqKys9P2Dc0TuJ0Gj2TCo=
=6F9d
-----END PGP SIGNATURE-----

--2FkSFaIQeDFoAt0B--
