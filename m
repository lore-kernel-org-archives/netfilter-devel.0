From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCh] Some ip6tables bugfixes
Date: Fri, 1 Apr 2005 08:55:15 +0200
Message-ID: <20050401065515.GP19835@sunbeam.de.gnumonks.org>
References: <42463931.5030904@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HzaOE8X7KzPzAQEl"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
Content-Disposition: inline
In-Reply-To: <42463931.5030904@outerspace.dyndns.org>
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


--HzaOE8X7KzPzAQEl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 27, 2005 at 07:40:17AM +0300, Jonas Berlin wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>=20
> I had some problems with porting ipv4 modules to ipv6 and after doing a
>=20
> ~  diff -uw iptables.c ip6tables.c

'vimdiff' does wonders :)

Sending        ip6tables.c
Transmitting file data .
Committed revision 3818.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--HzaOE8X7KzPzAQEl
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCTPBTXaXGVTD0i/8RAuTEAJ9v/VM+Gz2xTS1/MdzEWIOjtJn7SgCfb/G3
iZv+xZl3SWZ4Aa+FMFkpJHE=
=oWJi
-----END PGP SIGNATURE-----

--HzaOE8X7KzPzAQEl--
