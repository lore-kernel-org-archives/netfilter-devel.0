From: Harald Welte <laforge@netfilter.org>
Subject: Re: QUEUE on Alpha not working?
Date: Fri, 5 Sep 2003 14:15:26 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030905121526.GF665@obroa-skai.de.gnumonks.org>
References: <Pine.LNX.4.55.0309041224060.27499@ryanspc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="924gEkU1VlJlwnwX"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ryan Veety <ryan@ryanspc.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0309041224060.27499@ryanspc.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--924gEkU1VlJlwnwX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 04, 2003 at 01:17:56PM -0400, Ryan Veety wrote:
> My DEC Alpha Multia is running debian unstable with kernel 2.4.21.  All c=
ode
> that uses libipq fails.  ipq_message_type returns NLMSG_ERROR for every
> packet.  Even the intercept tool from the netfilter testsuite (CVS) fails:

can you please submit this to bugzilla.netfilter.org?

James Morris (the ip_queue author) is currently moving from one
continent to another... so it could take some time until he can have a
look.

if it is in bugzilla, it will at least not get lost...

> Thanks
> Ryan

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--924gEkU1VlJlwnwX
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/WH5dXaXGVTD0i/8RApaJAJ9rC4/plwB+6L1S0YghKHwFouRmEACgphAI
2Me0lyQugirSvPX+bMVgoWo=
=XbOy
-----END PGP SIGNATURE-----

--924gEkU1VlJlwnwX--
