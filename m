From: Harald Welte <laforge@gnumonks.org>
Subject: Re: FW: PPTP problem
Date: Fri, 25 Jul 2003 22:50:38 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030725205038.GE3244@sunbeam.de.gnumonks.org>
References: <007e01c34d35$c413e730$0440a8c0@SC2003002>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="A40sgxQLUpGaial+"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Enrico Demarin <enricod@videotron.ca>
Content-Disposition: inline
In-Reply-To: <007e01c34d35$c413e730$0440a8c0@SC2003002>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--A40sgxQLUpGaial+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 18, 2003 at 04:06:20PM +0200, Enrico Demarin wrote:
> Hi Harald,
>=20
> From what I understood , the problem is here :
>=20
> It seems to consider the answer of the server as a new gre connection
> instead of "tracking" the existing one... ;/

could you then please show me the expectation(s) generated? (you need to
look at the end of /proc/net/ip_conntrack while the connection is
established).

> - Enrico
=20
> > -----Original Message-----

Pleaes don't fullquote.

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--A40sgxQLUpGaial+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/IZgdXaXGVTD0i/8RArdEAKCvOnt7gVTeCYdOxQFH3avPLH9vXQCfZICw
F0exkHYSxkAoEuui4rqegzs=
=E5vI
-----END PGP SIGNATURE-----

--A40sgxQLUpGaial+--
