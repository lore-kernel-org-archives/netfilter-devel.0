From: Harald Welte <laforge@gnumonks.org>
Subject: Re: help me on ip_nat_xdmcp
Date: Sun, 22 Feb 2004 17:09:26 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040222160926.GO4797@sunbeam.de.gnumonks.org>
References: <Law9-F31jqshfZGaxdf00057dcf@hotmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aNEXz8bjPwULP3qW"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Joph Zeng <joph_csu@hotmail.com>
Content-Disposition: inline
In-Reply-To: <Law9-F31jqshfZGaxdf00057dcf@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--aNEXz8bjPwULP3qW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 22, 2004 at 10:58:47PM +0800, Joph Zeng wrote:
> Dear Sir:
>=20
> I want to connect a X server from inside a private network, so I have to=
=20
> use ip_nat_xdmcp module for iptables. I download xdmcp helper 1.1 version=
=20
> form CVS, and get a Makefile(attached to this mail) to compile it.=20

The XDMCP helper was never fully finished, that's why it is not in
patch-o-matic or in the mainstream kernel.

Unfortunately I don't have the time to finish it at the moment.

If you use the current code, you will open a _major_ security hole into
your firewall.


--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--aNEXz8bjPwULP3qW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAONQ2XaXGVTD0i/8RAvVGAJ9SqWk8wv+SA+uaAqAkHTUKTctsaACfaW73
hr91YkuHP6irTK0XALLmur0=
=Kdkc
-----END PGP SIGNATURE-----

--aNEXz8bjPwULP3qW--
