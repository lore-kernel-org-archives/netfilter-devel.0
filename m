From: Harald Welte <laforge@netfilter.org>
Subject: Re: ULOG target for ipv6
Date: Tue, 15 Feb 2005 00:25:10 +0100
Message-ID: <20050214232510.GK3829@sunbeam.de.gnumonks.org>
References: <42086F50.9090504@niksula.hut.fi>
	<53965.213.236.112.75.1107867276.squirrel@213.236.112.75>
	<420BEAFB.9070405@niksula.hut.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DozTQjXnjm3C9Xhk"
Cc: netfilter-devel@lists.netfilter.org, Martijn Lievaart <m@rtij.nl>
To: Jonas Berlin <jberlin@niksula.hut.fi>
Content-Disposition: inline
In-Reply-To: <420BEAFB.9070405@niksula.hut.fi>
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


--DozTQjXnjm3C9Xhk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 11, 2005 at 01:15:07AM +0200, Jonas Berlin wrote:

> Here's my first attempt of ULOG for ipv6. It's _untested_, but it=20
> compiles at least on 2.6 and it patches fine against 2.4.28 also.

;) I've merged it into pom-ng (Rev. 3694).  I'm not quite happy about
ulogd from userspace having no idea whether the packet came from the
ipv4 or ipv6 stack - but I think it's fine for now.

> Someone could also point me to the latest instructions on how to=20
> contribute - the online docs I found here didn't work very well:

Well, there are no instructions.  Patches to the HOWTO's or new
documentation is always welcome.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--DozTQjXnjm3C9Xhk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCETNWXaXGVTD0i/8RAtwzAJ9fuWmT1IzgIkobNrxR4uje0NTjVQCcCL5j
XGWBuKqMhrKAT6tVRABbgJs=
=IC2n
-----END PGP SIGNATURE-----

--DozTQjXnjm3C9Xhk--
