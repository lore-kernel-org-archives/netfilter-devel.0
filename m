From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH]Re: NAT before IPsec with 2.6
Date: Wed, 28 Jan 2004 14:39:23 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040128133923.GT11761@sunbeam.de.gnumonks.org>
References: <20040127103917.GC11761@sunbeam.de.gnumonks.org> <Pine.LNX.4.44.0401271207160.16067-100000@filer.marasystems.com> <20040127130739.GR11761@sunbeam.de.gnumonks.org> <20040128000938.GH11761@sunbeam.de.gnumonks.org> <401777B4.9020000@trash.net> <20040128103000.GP11761@sunbeam.de.gnumonks.org> <20040128112419.GA11961@alpha.home.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PzGeKfgKLFJqWH+5"
Cc: Patrick McHardy <kaber@trash.net>,
	Henrik Nordstrom <hno@marasystems.com>,
	Tom Eastep <teastep@shorewall.net>, Michal Ludvig <mludvig@suse.cz>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Willy Tarreau <willy@w.ods.org>
Content-Disposition: inline
In-Reply-To: <20040128112419.GA11961@alpha.home.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--PzGeKfgKLFJqWH+5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 28, 2004 at 12:24:19PM +0100, Willy Tarreau wrote:
> On Wed, Jan 28, 2004 at 11:30:00AM +0100, Harald Welte wrote:
> =20
> > > If NAT is used, ip_route_{input,output} might even return a different
> > > policy bundle.
> >=20
> > The question is, again: What ist the desired behaviour?  Should the
> > policy be determined on the un-NAT'ed packet or on the NAT'ed one?
>=20
> Harald, I believe it's important to remember that NAT is not the only usa=
ge
> of this extension. For many people seeking security (=3Dthose who install=
 VPN
> gateways for customers), it is very important to :
>   - be able to filter what enters and leaves a tunnel
>   - be able to filter where the encapsulated packets go to/come from
>=20
> NAT is complementary IMHO.

Yes, I totally agree.  My major point was conntrack being broken, and
thus stateful packet filtering not being possible.  The respective
iptables chains are missing.

Both of them are needed for the additional making-NAT-work.

> Regards,
> Willy

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--PzGeKfgKLFJqWH+5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAF7uLXaXGVTD0i/8RAjaEAJ0R1kBBZ24El5s8FA9aRwrIIk3VtwCdEGoG
iwMeADKd9agWjGoArwPozuA=
=n1uG
-----END PGP SIGNATURE-----

--PzGeKfgKLFJqWH+5--
