From: Harald Welte <laforge@netfilter.org>
Subject: Re: NAT before IPsec with 2.6
Date: Tue, 27 Jan 2004 21:51:23 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040127205123.GA11761@sunbeam.de.gnumonks.org>
References: <20040127130739.GR11761@sunbeam.de.gnumonks.org> <Pine.LNX.4.44.0401271457370.17979-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iRaAnoDFBoP0sW/E"
Cc: Willy Tarreau <willy@w.ods.org>, Tom Eastep <teastep@shorewall.net>,
	Michal Ludvig <mludvig@suse.cz>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0401271457370.17979-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--iRaAnoDFBoP0sW/E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 27, 2004 at 03:12:49PM +0100, Henrik Nordstrom wrote:
> On Tue, 27 Jan 2004, Harald Welte wrote:
>=20
> > > My view of where hooks should be for IPSec:
> > >=20
> > > (Client) -> Gateway -> (Gateway)
> > >=20
> > >   1. PREROUTING, original client packet
> > >   2. FORWARD, original client packet. Destination the IPSec SPI
> > >   3. POSTROUTING, original client packet. Destination the IPSec SPI
> > >   4. OUTPUT, ESP packet. Preferably with some preserved information a=
bout=20
> > > the original packet attached.
> > >   5. POSTROUTING, ESP packet.
> >=20
> > I agree to all but 4.    My proposal was PREROUTING, yours OUTPUT.
>=20
> It is very hard to distinguis the different IPSec cases here. Save of
> adding yet another hook for encapsulated and to be decapsulated packets
> OUTPUT(/INPUT) is the closest match in my opinion.=20

Please don't confuse hooks with chains.  I suggested to add new
netfilter hooks (NF_IP_{PRE,POST}_XFRM), but attach the old INPUT/OUTPUT
(or even PREROUTING/POSTROUTING) chains to those hooks.

Hm.  You have a point, but I'm still not really sure.  I'll do it the
way you proposed, but I might change my mind again in the future ;)

> If introducing new hooks then we would have
>=20
>    XXXX -> POSTROUTING <-net-> PREROUTING -> YYYY
>=20
> if XXXX and YYYY can be the same hook name in this case or not I'll leave
> to the core team to ponder upon?
>=20
> What exacly is the semantical problem of using OUTPUT/INPUT?  In my view
> the ESP/AH packet is locally generated, and belongs to a connection with a
> local endpoint.

well, you convinced me (for now). new hooks, old chains.=20

> Regards
> Henrik

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--iRaAnoDFBoP0sW/E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAFs9LXaXGVTD0i/8RAtZgAJ0ZuJjKMs7NI3upN+VrtkZg+tXJYQCgqPy6
QMmPWj5Mz+RUjjtmiGVXf30=
=gliI
-----END PGP SIGNATURE-----

--iRaAnoDFBoP0sW/E--
