From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] make multiple invocations of do_command() behave sane
Date: Mon, 2 Feb 2004 16:05:45 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040202150545.GE24449@obroa-skai.de.gnumonks.org>
References: <1075671804.19762.23.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hwvH6HDNit2nSK4j"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1075671804.19762.23.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--hwvH6HDNit2nSK4j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 01, 2004 at 10:43:24PM +0100, Martin Josefsson wrote:
> Hi
>=20
> While writing a small script for managing my firewallrules I ran into a
> small problem with iptables-restore.
> The problem is that it doesn't respect the order of matches in a rule.

Thanks a lot, this is indeed an important issue.   I wonder why nobody
has complained about this in the past.

> If noone screams too loud I'm going to merge the patch into cvs sometime
> soon.

please do so.

> /Martin
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--hwvH6HDNit2nSK4j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAHmdJXaXGVTD0i/8RAiAvAJ90X1WGYbvdceezK4BQLOfRBqgF4QCffzNC
bp6BiA8ssBy1F5HRy7ONTpk=
=EsNn
-----END PGP SIGNATURE-----

--hwvH6HDNit2nSK4j--
