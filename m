From: Harald Welte <laforge@netfilter.org>
Subject: Re: [2.6] Nonsense-messages from iptables + co.
Date: Fri, 14 Nov 2003 21:37:37 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031114203737.GI6937@obroa-skai.de.gnumonks.org>
References: <20031114132054.GA646@merlin.emma.line.org> <20031114151004.GE2395@obroa-skai.de.gnumonks.org> <20031114200119.GA27789@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Rmm1Stw9KgbdL9/H"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Linux-Kernel mailing list <linux-kernel@vger.kernel.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20031114200119.GA27789@merlin.emma.line.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Rmm1Stw9KgbdL9/H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2003 at 09:01:19PM +0100, Matthias Andree wrote:

> > I guess it was Rusty.  The idea message is a funny way of telling you
> > that you are sending incomplete ip headers.
>=20
> Am I? what's with the *_limit() function called before the printk?

it's a generic network rate limiting function.  It prevents the same
message from being logged and logged again (and thus flooding your
syslog).

> > Something that is not likely to occur unless you are trying to send
> > corrupt packets via raw ip sockets...
>=20
> Not at the times when these occurred.

there seemed to be a bug that I was unaware of, and according to other
mails in this thread it has been fixed.
=20
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Rmm1Stw9KgbdL9/H
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/tT0RXaXGVTD0i/8RApkEAJsEg3wPDHHXLEuImo0KOu664P3J+QCfaCC9
iD83iiPSOXKldXorCBNRb9U=
=17iT
-----END PGP SIGNATURE-----

--Rmm1Stw9KgbdL9/H--
