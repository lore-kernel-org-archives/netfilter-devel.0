From: Harald Welte <laforge@netfilter.org>
Subject: Re: [netfilter-core] Re: New draft document on nat / traversal /
	hole punching (with Dan Kegel)
Date: Wed, 10 Nov 2004 14:20:55 +0100
Message-ID: <20041110132054.GS22257@sunbeam.de.gnumonks.org>
References: <20041109154946.GD22257@sunbeam.de.gnumonks.org>
	<1100024526.6496.10.camel@tux.rsn.bth.se>
	<1100043724.25963.19.camel@localhost.localdomain>
	<20041109221025.6617b513.davem@davemloft.net>
	<1100089575.2660.6.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9rRS2CJFk/mxouRY"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	coreteam@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
Content-Disposition: inline
In-Reply-To: <1100089575.2660.6.camel@nienna.balabit>
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


--9rRS2CJFk/mxouRY
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 10, 2004 at 01:26:16PM +0100, KOVACS Krisztian wrote:
>=20
>   Hi,
>=20
> 2004-11-10, sze keltez=E9ssel 07:10-kor David S. Miller ezt =EDrta:
> > On Wed, 10 Nov 2004 10:42:04 +1100
> > Rusty Russell <rusty@rustcorp.com.au> wrote:
> >=20
> > > On Tue, 2004-11-09 at 19:22 +0100, Martin Josefsson wrote:
> > > > Rusty, iirc we have a problem in the NAT core when we SNAT and have=
 to
> > > > remap ports, later SNAT'd connections from the same host:port pair
> > > > doesn't get the same mapping as the first one. You were working on =
a fix
> > > > for this? Was this ever made public?
> > >=20
> > > Dave, please apply.  (Thanks for the reminder Martin).
> >=20
> > Applied, thanks Rusty.
>=20
>   BTW, are there any plans to apply this fix to 2.4 as well? (With the
> in_range() fix included, of course.)

yes, certainly. I'm about to do the merge.

>  Regards,
>    Krisztian KOVACS

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--9rRS2CJFk/mxouRY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBkhW2XaXGVTD0i/8RAuR9AJwMFtuW/B8E1e1F83p0ALrbpwsx1ACfTIaN
S38V2aEkPzSh4GAuXLq0LkQ=
=1qwk
-----END PGP SIGNATURE-----

--9rRS2CJFk/mxouRY--
