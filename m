From: Harald Welte <laforge@netfilter.org>
Subject: Re: DaveM get's removed from Cc (was Re: [PATCH 1/2] string match
	for iptables)
Date: Fri, 26 Aug 2005 20:33:44 +0200
Message-ID: <20050826183344.GF4226@rama.de.gnumonks.org>
References: <43075517.3070405@eurodev.net> <43075BEA.1030701@trash.net>
	<20050820.131403.37427784.davem@davemloft.net>
	<20050825104258.GU4442@rama.de.gnumonks.org>
	<1124988859.28166.28.camel@localhost.localdomain>
	<1124990355.28166.31.camel@localhost.localdomain>
	<430F0442.5030909@trash.net>
	<20050826132743.GZ4226@rama.de.gnumonks.org>
	<20050826152121.GB5606@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="udOl8koJG4PSVcOF"
Cc: netfilter-devel@lists.netfilter.org,
	Martin Josefsson <gandalf@wlug.westbo.se>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
Content-Disposition: inline
In-Reply-To: <20050826152121.GB5606@linuxace.com>
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


--udOl8koJG4PSVcOF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 26, 2005 at 08:21:21AM -0700, Phil Oester wrote:
> On Fri, Aug 26, 2005 at 03:27:43PM +0200, Harald Welte wrote:
> > it's a per-user configuration setting of mailman called "nodupes". =20
> >=20
> > If X subscribes to a mailinglist L and sets "nodupes", and Z sends a
> > message to L with Cc: X, then X will be removed.
>=20
> FWIW, most other lists seem to default to 'dupes', but netfilter-devel
> defaults to nodupes.  Perhaps the default should be flipped?

Thanks, changed the default for new members accordingly.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--udOl8koJG4PSVcOF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDD2CIXaXGVTD0i/8RAttGAJ4lbbz6+Wh+sABda4VQSExbi2Ce0wCfS1Zf
IXU5OhjjqEVVVvlqLn+ViMA=
=g2Hr
-----END PGP SIGNATURE-----

--udOl8koJG4PSVcOF--
