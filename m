From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] endianess fix for ip_conntrack_amanda
Date: Sat, 23 Aug 2003 23:03:23 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030823210323.GB6750@sunbeam.de.gnumonks.org>
References: <20030805190657.GA31073@satan.blackhosts>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+pHx0qQiF2pBVqBT"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jakub Bogusz <qboosh@pld.org.pl>
Content-Disposition: inline
In-Reply-To: <20030805190657.GA31073@satan.blackhosts>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--+pHx0qQiF2pBVqBT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 05, 2003 at 09:06:57PM +0200, Jakub Bogusz wrote:
> Hello,
>=20
> I've just noticed that I probably missed one place (in ip_conntrack_amand=
a)
> when I was making fixes for big-endian archs in conntrack and nat modules
> by using C99 initializers in May, and it remained unfixed (at least in
> 2.6.0-test2, where all other fixes are already merged; probably the same
> in 2.4.22-pre).

yes, indeed.  Thanks for hunting this down - I will submit your patch
soon.

> Jakub Bogusz    http://cyber.cs.net.pl/~qboosh/
> PLD Linux       http://www.pld-linux.org/

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--+pHx0qQiF2pBVqBT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/R9abXaXGVTD0i/8RAh+7AJ4yk2M9YNqbgkHKnN/0YX+awcUqUwCgk8mI
LS74+f0xo9fd1rTuHiGOHaI=
=ofg7
-----END PGP SIGNATURE-----

--+pHx0qQiF2pBVqBT--
