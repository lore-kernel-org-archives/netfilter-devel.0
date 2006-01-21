From: Harald Welte <laforge@netfilter.org>
Subject: Re: Simple coding question...
Date: Sat, 21 Jan 2006 15:45:23 +0100
Message-ID: <20060121144523.GY4603@sunbeam.de.gnumonks.org>
References: <1137328306.23199.4.camel@scaramouche.combox.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J9FDM06y/La6Wdcu"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Torsten Luettgert <t.luettgert@pressestimmen.de>
Content-Disposition: inline
In-Reply-To: <1137328306.23199.4.camel@scaramouche.combox.de>
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


--J9FDM06y/La6Wdcu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 15, 2006 at 01:31:46PM +0100, Torsten Luettgert wrote:
> Hello,
>=20
> recently I studied the MARK and CLASSIFY targets and found these
> lines doing the actual changes:
>=20
>    if((*pskb)->nfmark !=3D markinfo->mark)
>       (*pskb)->nfmark =3D markinfo->mark;
>=20
>    if((*pskb)->priority !=3D clinfo->priority)
>       (*pskb)->priority =3D clinfo->priority;
>=20
> Is there a reason the value is always checked first?

I cannot really comment, but I guess that it is done because reding data
is cheaper than writing.  When you write, you invalidate that cahce line
on all other cpus. =20

However, since it's unlikely that processing of the same s kb moves from
one cpu to the other, I think that reason is void, too.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--J9FDM06y/La6Wdcu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFD0kkDXaXGVTD0i/8RAmrGAJ9S1pYC6dYGhy9MRbRoYkPa1/5qZgCdERv2
bwtWATPx5divMioMhIeCw6g=
=yhl4
-----END PGP SIGNATURE-----

--J9FDM06y/La6Wdcu--
