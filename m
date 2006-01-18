From: Harald Welte <laforge@netfilter.org>
Subject: Re: 2.6.16-rc1: iptables broken on ppc32?
Date: Wed, 18 Jan 2006 21:33:34 +0100
Message-ID: <20060118203334.GR4603@sunbeam.de.gnumonks.org>
References: <17358.19458.555996.684819@alkaid.it.uu.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wg9FEZT+WCTrEXgJ"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <17358.19458.555996.684819@alkaid.it.uu.se>
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


--wg9FEZT+WCTrEXgJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 18, 2006 at 03:09:06PM +0100, Mikael Pettersson wrote:
> When trying out kernel 2.6.16-rc1 on a ppc32 box (G4 eMac),
> the kernel refused to load my /etc/sysconfig/iptables. strace
> on /sbin/iptables-restore shows that the kernel returns EINVAL
> instead of accepting the configuration:

JFYI: I've created
https://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=3D430
=66rom your report. Please add yourself to the bugzilla entry, in case you
want to stay up-to-date

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--wg9FEZT+WCTrEXgJ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDzqYeXaXGVTD0i/8RApF6AJ4ihwFpL/x4ovtNquMQ6Ixlc/talwCfZLXD
hbDv0XcoahNjGLjvvPZNyXw=
=6l0F
-----END PGP SIGNATURE-----

--wg9FEZT+WCTrEXgJ--
