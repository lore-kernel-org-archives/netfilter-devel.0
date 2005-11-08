From: Harald Welte <laforge@netfilter.org>
Subject: Re: Roadmap for IPv6 stateful filtering
Date: Tue, 8 Nov 2005 15:19:15 +0100
Message-ID: <20051108141914.GV26843@sunbeam.de.gnumonks.org>
References: <436FBCDF.4060900@net.in.tum.de> <4370A4A3.20702@eurodev.net>
	<200511081502.04272@nienna>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7L9kolmstoDTZ4pm"
Cc: netfilter-devel@lists.netfilter.org, Pablo Neira <pablo@eurodev.net>,
	Gregor Maier <gregor@net.in.tum.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
Content-Disposition: inline
In-Reply-To: <200511081502.04272@nienna>
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


--7L9kolmstoDTZ4pm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 08, 2005 at 03:02:03PM +0100, KOVACS Krisztian wrote:
>=20
>   Hi,
>=20
> On Tuesday 08 November 2005 14.14, Pablo Neira wrote:
> > Gregor Maier wrote:
> > > I just wanted to ask if there is any roadmap or a plan when (if at al=
l)
> > > stateful filtering (and maybe connection tracking) for IPv6 will be
> > > available in netfilter.
> > > I found a page that claimed that stateful IPv6 filtering will be
> > > available in the 2.6.15 kernel release (unfortunaly I misplaced the
> > > link to the page somewhere :-(  ). Is this info correct? Or is there
> > > another kernel version targeted?
> >
> > nf_conntrack got pushed forward to 2.6.15, so you'll have that feature
> > in the next release candidate.
>=20
>   Unfortunately I'm not quite sure about that... It's not yet in Linus' t=
ree=20
> and it did not made it into Arnaldo's net-2.6 tree either. Maybe Harald h=
as=20
> more information about it, but it seems quite a bit uncertain whether or=
=20
> not it will be merged in 2.6.15...

*sigh*

Nobody has yet bothered to respond to me.  I have no news from neither
Linus, nor Acme, nor Davem. =20

Sorry.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--7L9kolmstoDTZ4pm
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDcLPiXaXGVTD0i/8RAoDIAKCftegj2yjdtcRHL0JFLE6bRvQjeACfZuy/
t67dIK7FNcvcIBeCwzzXPRk=
=44lf
-----END PGP SIGNATURE-----

--7L9kolmstoDTZ4pm--
