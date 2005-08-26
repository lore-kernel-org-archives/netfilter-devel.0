From: Harald Welte <laforge@netfilter.org>
Subject: [RFC] TTL target goes mainline ?
Date: Fri, 26 Aug 2005 13:18:32 +0200
Message-ID: <20050826111832.GT4226@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7gQyIpR7q4QSXYu+"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
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


--7gQyIpR7q4QSXYu+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

As we are in the process of pushing more 'new' code from
patch-o-matic-ng into the mainline kernel, I was thinking whether or not
we should also submit potentially-dangerous targets such as the TTL
target to the kernel.

The TTL target allows setting, incrementing and decrementing of the TTL,
and is therefore extremely dangerous. OTOTH, there are ISP's that check
whether you use a router or not (and thus filter or not) by looking at
the TTL of every packet that comes in on your link - so there is a
practical use of this to a number of people.

At some point the kernel had a CONFIG_DANGEROUS, but that had been
removed. I think CONFIG_DANGEROUS would be exactly the right thing for
TTL manipulations.

So my proposal is to only allow decrementing (or setting to a value
below the original one) the TTL unless CONFIG_EXPERIMENTAL is set.=20

What do you think?

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--7gQyIpR7q4QSXYu+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDDvqIXaXGVTD0i/8RAibiAJ9yIt1H0sD+QWmU6M0Ap1ptwnDtaACcDCjP
9l0RNPyPlFxogs4NInAEbzA=
=D2Vj
-----END PGP SIGNATURE-----

--7gQyIpR7q4QSXYu+--
