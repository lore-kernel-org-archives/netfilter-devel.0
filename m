From: Harald Welte <laforge@netfilter.org>
Subject: Re: per-cpu table information
Date: Thu, 16 Sep 2004 09:12:02 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040916071202.GH2678@sunbeam.de.gnumonks.org>
References: <41402D9E.5050906@rediffmail.com>
	<20040915223602.GF2678@sunbeam.de.gnumonks.org>
	<20040915154738.7cb24983.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EemXnrF2ob+xzFeB"
Cc: netfilter-devel@lists.netfilter.org, swapsn@rediffmail.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline
In-Reply-To: <20040915154738.7cb24983.davem@davemloft.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--EemXnrF2ob+xzFeB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 15, 2004 at 03:47:38PM -0700, David S. Miller wrote:
> On Thu, 16 Sep 2004 00:36:02 +0200
> Harald Welte <laforge@netfilter.org> wrote:
>=20
> > Because we don't need any locking and we don't have cache line ping-pong
> > between the CPU's, if there is no shared data.
>=20
> In my opinion the disadvantages (both in code complexity and table
> update cost) far outweigh whatever speed gains you this obtains.

Table update cost is mostly harmed by the atomic replacement of the
whole table, not by one-time copying...

And iptables performance is bad enough, we don't need to make it any
worse (we have per-rule counters that need to be written to!).

Anyway, pkttables will simply have a 'matchinfo/targinfo read only'
policy (everybody who needs a writable memory needs to dynamically
allocate and do his own locking), and not have per-rule countes anymore.
This means the whole ruleset is read-only and we don't need any code
replication.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--EemXnrF2ob+xzFeB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBSTzCXaXGVTD0i/8RArbfAKCUJopq1XVBc8rn1wcnMdv3nzZecQCfQU5t
9Ryc3v8hd1aj+ACiMRWVzDw=
=y5VK
-----END PGP SIGNATURE-----

--EemXnrF2ob+xzFeB--
