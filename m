From: Harald Welte <laforge@netfilter.org>
Subject: Re: PATCH: extra conntrack stats
Date: Sun, 27 Apr 2003 14:48:35 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030427124835.GA990@sunbeam.de.gnumonks.org>
References: <200304192142.h3JLg1S03466@fokkensr.vertis.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SqEPCaGsKgsesFh5"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rolf Fokkens <fokkensr@fokkensr.vertis.nl>
Content-Disposition: inline
In-Reply-To: <200304192142.h3JLg1S03466@fokkensr.vertis.nl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--SqEPCaGsKgsesFh5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 19, 2003 at 11:42:01PM +0200, Rolf Fokkens wrote:
> Hi!
>=20
> This patch adds a little statistical information to the connection tracki=
ng:
> the number of packets and bytes that have gone throught each connection.
>=20
> Well, it's a small patch that may not do any harm and please some people.

It will.  You are adding a counter that is written to for every packet.
This causes tremendous cache line ping-pong on SMP systems.

This is inacceptable, the only way to implement this is via per-cpu
counters that are added at the time you read them out (like the iptables
per-cpu local counters)

> Cheers,
> Rolf

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--SqEPCaGsKgsesFh5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+q9GjXaXGVTD0i/8RAuuKAJ0bl7K2WLUYWBvcWznQdivYhmfHdgCcDvMc
uymgFvBr8I6Z1jcOAhkdSZs=
=1Z2F
-----END PGP SIGNATURE-----

--SqEPCaGsKgsesFh5--
