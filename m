From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [netfilter-core] Bug in ip_nat_core.c, introduced in 2.4.19pre4 and still persisting in 2.4.20
Date: Tue, 7 Jan 2003 21:34:38 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030107203438.GC9467@sunbeam.de.gnumonks.org>
References: <000001c2b5ba$3871c5c0$026ba8c0@DEEPBLUE>
Reply-To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tez2gqrut5pn4jhH"
Cc: coreteam@netfilter.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ruud van den Brink <ruud@stress.utwente.nl>
Content-Disposition: inline
In-Reply-To: <000001c2b5ba$3871c5c0$026ba8c0@DEEPBLUE>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--tez2gqrut5pn4jhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 06, 2003 at 08:31:33PM +0100, Ruud van den Brink wrote:
> Hi netfilter team,
>=20
> I have been using the 2.4.16 kernel for a while, and recently I upgraded =
to
> 2.4.19. At that time, CIPE (a VPN application) refused to work in
> conjunction with NAT. Today I finally found some time to trace the problem
> in the Kernel source.
> [...]

Have you tried to set the CONFIG_IP_NF_NAT_LOCAL config option?

The half-working implementation of NAT for locally-terminated
connections was fully implemented and made a seperate config option at
that time.

Please follow-up to netfilter-devel@lists.netfilter.org, this is the
right place for this kind of stuff.

> Kind regards,
> Ruud.

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--tez2gqrut5pn4jhH
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+GzneXaXGVTD0i/8RAgJEAJ95dokFZAEQv0gET5Jm1cuYr8T0PQCgjQEI
hUN5lXae9aERBo9lzizf+Tw=
=803w
-----END PGP SIGNATURE-----

--tez2gqrut5pn4jhH--
