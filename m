From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [netfilter-core] netfilter violates RFC 1812
Date: Wed, 4 Dec 2002 14:06:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021204130651.GF9736@naboo.club.berlin.ccc.de>
References: <3DE60D10.4060703@rz.rwth-aachen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OZkY3AIuv2LYvjdk"
Cc: coreteam@netfilter.org, Wolfgang Kueter <wolfgang@shconnect.de>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jens Hektor <hektor@rz.rwth-aachen.de>
Content-Disposition: inline
In-Reply-To: <3DE60D10.4060703@rz.rwth-aachen.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--OZkY3AIuv2LYvjdk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 28, 2002 at 01:33:20PM +0100, Jens Hektor wrote:
> Hi,
>=20
> I'm pretty sure that this has been stated elsewhere, but it would
> be nice to have a fix because Linux packte filters are clearly
> running well.

Yup, please refer to multiple threads about this subject on
netfilter-devel.

> RFC 1812 (pp81-82) clearly states that router with packet filtering
> capabilities should give ICMP Type "destination unreachable", code
> "communication administratively prohibited" (13).

this is true.  There are patches floating around for exactly this
issue.  The problem is: It is impossible to add this feature without
hurting backwards- or forward-compatibility between new/old
iptables-userspace and iptables-kernel.  So we're sort of in a no-win
situation :(

> Bye, Jens Hektor

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M-=
=20
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)

--OZkY3AIuv2LYvjdk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE97f3rXaXGVTD0i/8RAtblAKCFXOHkY3e1GmyzPeYVAd89AYpUJACdGzjH
ANp6C8dP3CeB+wWaA5haTWs=
=mFtJ
-----END PGP SIGNATURE-----

--OZkY3AIuv2LYvjdk--
