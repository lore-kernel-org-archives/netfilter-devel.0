From: netfilter@interlinx.bc.ca
Subject: Re: ip_conntrack-timeouts conflicts with tcp-window-tracking
Date: Mon, 28 Oct 2002 07:14:38 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021028121438.GN27880@pc.ilinx>
References: <20021025203433.GJ23228@pc.ilinx> <Pine.LNX.4.33.0210281225160.1385-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aSnC4ZPPfhCvD8sN"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0210281225160.1385-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--aSnC4ZPPfhCvD8sN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 28, 2002 at 12:29:52PM +0100, Jozsef Kadlecsik wrote:
>=20
> The tcp-window-tracking patch do provide sysctl control of all the timeout
> parameters.

Indeed!  After deeper examination of the tcp-window-tracking patch I
did discover that it provides a whole host of sysctlable values.

> Please read the help file.

Didn't need to.  Read the source.  :-)

Now I'm off to build and debug a kernel that does not give me an
"Invalid argument" when trying to add nat table rules.

Thanx,
b.

--=20
Brian J. Murrell

--aSnC4ZPPfhCvD8sN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9vSotl3EQlGLyuXARArTzAKCzwsvb2sAiXl1su7EryL8JgL8vmwCg93fC
3v+/gKdTuRFIZI4+dsu8eBU=
=CIkj
-----END PGP SIGNATURE-----

--aSnC4ZPPfhCvD8sN--
