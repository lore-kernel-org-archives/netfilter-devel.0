From: Harald Welte <laforge@netfilter.org>
Subject: Re: [jorge@dti2.net: Re: Fw: PROBLEM: PATCH for 2.4.23-pre4 and up hang on one system]
Date: Thu, 13 Nov 2003 19:31:30 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031113183129.GB28516@obroa-skai.de.gnumonks.org>
References: <20031112004700.69796de6.davem@redhat.com> <Pine.LNX.4.44.0311131544200.20048-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZfOjI3PrQbgiZnxM"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0311131544200.20048-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ZfOjI3PrQbgiZnxM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2003 at 03:46:35PM +0100, Henrik Nordstrom wrote:
> On Wed, 12 Nov 2003, David S. Miller wrote:
>=20
> > On Wed, 12 Nov 2003 09:33:57 +0100
> > Harald Welte <laforge@gnumonks.org> wrote:
> >=20
> > > Since there is now a second bug report on that 'fix', I think it's
> > > better to back it out for 2.4.23.  The code has been without that 'fi=
x'
> > > for the whole 2.4.x time, and it didn't seem to cause any real proble=
m.
> > >=20
> > > So rather than fixing the theoretical case, I'd say we keep the code
> > > like before (please revert the below patch) and make user complaints =
go
> > > away.
> > >=20
> > > We'll try to investigate this further, but not before 2.4.23.
>=20
> It would probably be good to move the patch (74_nat-range-fix.patch) out
> from submitted to extra or pending to reflect the current status of this
> patch.

thanks, will do so.

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

--ZfOjI3PrQbgiZnxM
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/s84BXaXGVTD0i/8RAmIxAKCBM7NQPIdkgve68SqABsznsj8lMQCePu+6
rxie2rlzZUixylT46gOySF0=
=n0CX
-----END PGP SIGNATURE-----

--ZfOjI3PrQbgiZnxM--
