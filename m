From: Harald Welte <laforge@netfilter.org>
Subject: Request for Testing: linux-2.6 port of pptp-conntrack-nat
Date: Fri, 22 Oct 2004 18:12:42 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041022161242.GG3551@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XLWMkxR+mZNQ4WTO"
Cc: Netfilter Mailinglist <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--XLWMkxR+mZNQ4WTO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

Getting Mandrake's pptp-conntrack-nat patch to fully comply with the
APi's in current 2.6.x kernels was not exactly an easy job. =20

I can confirm that that patch would never have worked in any NAT setup,
and wold probably have crashed on any machines generating nonlinear PPTP
skbs (which is certainly not a usual case, but still easy to do for
somebody with a local user acocunt).

I've just committed the first compiling version of the 2.6.x
pptp-conntrack-nat patch to svn.netfilter.org (Version 3258).

At the moment I don't have the time to build a full test network and
test with various PPTP implementations.  If somebody is interested,
please go ahead and send bugreports :)

Cheers,
	Harald

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--XLWMkxR+mZNQ4WTO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBeTF6XaXGVTD0i/8RAldiAJ9ze8ttiK4RfPBeNDtJq3Q8qw7OZACfVLAe
T7CpXsDeHeK3AyUxQswS2ms=
=Fn3V
-----END PGP SIGNATURE-----

--XLWMkxR+mZNQ4WTO--
