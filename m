From: Harald Welte <laforge@netfilter.org>
Subject: Re: module access to conntrack tcp timeouts
Date: Mon, 30 May 2005 20:00:12 +0200
Message-ID: <20050530180012.GW22760@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.62.0505271238130.2297@dgray-test.acs.internap.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M5PHxtWZRXQUdpfa"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Damon Gray <dgray@internap.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0505271238130.2297@dgray-test.acs.internap.com>
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


--M5PHxtWZRXQUdpfa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 27, 2005 at 12:43:12PM -0400, Damon Gray wrote:
>=20
> A module I'm working on needs to know what the current conntrack timeout =
for=20
> tcp established is. The variable is ip_ct_tcp_timeout_established in=20
> ip_conntrack_proto_tcp.c. What is the best way to go about getting access=
 to=20
> this information from another kernel module? Sysctl? Proc? Can you access=
=20
> sysctl information from the kernel?

As usual, the first question would be: Why do you need that kind of
information in the first place?  Understanding this will help us to
recommend possible options.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--M5PHxtWZRXQUdpfa
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCm1SsXaXGVTD0i/8RAngzAJ9yxdyNL9M6NnrRQXhk+KFhMEvSOACfU9YO
DOND29xSlYI91xp9uT8tVG8=
=lhB0
-----END PGP SIGNATURE-----

--M5PHxtWZRXQUdpfa--
