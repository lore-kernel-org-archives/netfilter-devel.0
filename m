From: Harald Welte <laforge@netfilter.org>
Subject: Re: netflow/sflow & Linux
Date: Sun, 28 Mar 2004 20:42:39 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040328184239.GZ7039@sunbeam.de.gnumonks.org>
References: <20040322110710.GC8314@oasis.frogfoot.net> <Pine.LNX.4.44.0403221428520.19177-100000@filer.marasystems.com> <20040322154543.GA11903@oasis.frogfoot.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HENu/cXyPKFN4XCQ"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Abraham van der Merwe <abz@frogfoot.net>
Content-Disposition: inline
In-Reply-To: <20040322154543.GA11903@oasis.frogfoot.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--HENu/cXyPKFN4XCQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 22, 2004 at 05:45:43PM +0200, Abraham van der Merwe wrote:
> Hi Henrik                                        >@2004.03.22_15:31:00_+0=
200
>=20
> > > Has anyone done any work to enable Linux to do netflow (capturing not
> > > processing)?
> >=20
> > See www.ntop.org
>=20
> Yes, I know about that, but ntop is rather limited because it is just bas=
ed
> on libpcap.
>=20
> Maybe I should rephrase the question:
>=20
> Has anyone done any work to do netflow in Linux the "real" way, i.e.
>=20
>  (a) keep a "flow" in kernel space AND record routing information (e.g. AS
>      numbers would by extremely useful although we'd need some way for Ze=
bra
>      to pass this information to the kernel).

No.  Please see the mailinglist archives, this has been discussed over
and over and over again.

All you need to do is add per-direction byte and packet counters to
struct ip_conntrack, update them for every packed and use ctnetlink to
receive this information once a connection is deleted from the conntrack
table.

As easy as it is, nobody has implemented it yet..=20

> Regards
>  Abraham

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--HENu/cXyPKFN4XCQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAZxyfXaXGVTD0i/8RAvRvAJ4mBT9S9t9gsS8I05oDpcUHuhjtwACePCbV
9ZEMSFwbJd4si+QpnBvlztg=
=f+z5
-----END PGP SIGNATURE-----

--HENu/cXyPKFN4XCQ--
