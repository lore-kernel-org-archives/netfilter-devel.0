From: Harald Welte <laforge@netfilter.org>
Subject: [FAQ] Re: PPTP connection tracking and NAT helper in Linux 2.6
Date: Sat, 16 Oct 2004 10:13:54 +0200
Sender: netfilter-bounces@lists.netfilter.org
Message-ID: <20041016081354.GE29413@sunbeam.de.gnumonks.org>
References: <20766.1097853320@www26.gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YkJPYEFdoxh/AXLE"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>
Return-path: <netfilter-bounces@lists.netfilter.org>
To: Jochen Rueppel <j.rueppel@gmx.de>
Content-Disposition: inline
In-Reply-To: <20766.1097853320@www26.gmx.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--YkJPYEFdoxh/AXLE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 15, 2004 at 05:15:20PM +0200, Jochen Rueppel wrote:
> Hi Harald
>=20
> In the info file for the current patchomatic modul "PPTP connection track=
ing
> and NAT helper" is written: "Requires: linux < 2.6.0"
>=20
> I plan to migrate to linux-kernel 2.6 in the near future.
> Will PPTP connection tracking be part of linux 2.6?
> If not, when will exist the natching patchomatic modul?

As soon as somebody ports it and sends me a patch.  I receive about 3-5
mails per week asking for this feature... but apparently nobody is
willing to contribute some time back to the netfilter project.

> thanks & greets
> Jochen

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--YkJPYEFdoxh/AXLE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBcNhCXaXGVTD0i/8RAlMcAJkBKVtNMk1aXOS+rYSXdTdcyK+ydgCeM9+Q
o0a0nGdy1eHDsAzJyhHFxLo=
=A2cV
-----END PGP SIGNATURE-----

--YkJPYEFdoxh/AXLE--
