From: Harald Welte <laforge@netfilter.org>
Subject: Re: MSN throught Linux
Date: Tue, 7 Oct 2003 11:47:04 +0200
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <20031007094704.GI18246@sunbeam.de.gnumonks.org>
References: <14C5057BC852D611BAC400E0299AA10F02043F@MAILSERV> <5.2.0.9.0.20031006133543.00b32178@mail.network.com.pt>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="so9zsI5B81VjUb/o"
Cc: netfilter@lists.netfilter.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-admin@lists.netfilter.org>
To: Carlos Santos <csantos@csantos.net>
Content-Disposition: inline
In-Reply-To: <5.2.0.9.0.20031006133543.00b32178@mail.network.com.pt>
Errors-To: netfilter-admin@lists.netfilter.org
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
List-Id: netfilter-devel.vger.kernel.org


--so9zsI5B81VjUb/o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 06, 2003 at 01:46:27PM +0100, Carlos Santos wrote:
>=20
>=20
> Hi,
>=20
> I've been trying (on and off, on my spare time) to get my firewall (RedHa=
t=20
> 9 Shrike) to allow MSN, Netmeeting and Yahoo webcam conversations to take=
=20
> place. I've been keeping up with some of the threads that have been start=
ed=20
> lately about this subject and what I would like to know before going any=
=20
> further is: is UPNP a security risk ?=20

yes, obviously it is.  Have you ever looked at the specification?

Also read Section 5 of
http://linux-igd.sourceforge.net/documentation.php

the problem is, that any email worm or whatever malicious current
windows virus might be active on one of the computers inside your
network can open _any_ port to _any_ machine via uPNP calls to your upnp
igd.

This is most likely my last message on this totally rediculous
mechanism.

> Thanks,
> Carlos.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--so9zsI5B81VjUb/o
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/gouYXaXGVTD0i/8RAmcZAJ92t2j7byaeXJyu2yzuQ9fm1wWCJgCfcEXy
urwVzqW6D4o64iVyejl1kS8=
=IH3/
-----END PGP SIGNATURE-----

--so9zsI5B81VjUb/o--
