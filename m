From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Make hashsize ip_conntrack parameter writable
Date: Tue, 11 Oct 2005 16:41:57 +0200
Message-ID: <20051011144157.GF4756@rama.de.gnumonks.org>
References: <1128536584.9868.1.camel@localhost.localdomain>
	<20051007034224.GB5953@rama> <434B8202.9020703@ufomechanic.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0rSojgWGcpz+ezC3"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
Content-Disposition: inline
In-Reply-To: <434B8202.9020703@ufomechanic.net>
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


--0rSojgWGcpz+ezC3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 11, 2005 at 10:12:34AM +0100, Amin Azez wrote:
> Harald Welte wrote:
> > JFYI, here's an incremental (yet untested) patch that adds support to
> > reinitialize the random seed when reisizing
>=20
> Just for my own education, why is the seed random?

to prevent any DoS attack on our hash function, by some attacker knowing
how to make lots of connections hash to the same bucket.

> Doe this mean that we randonly get a "bad" seed?

no, just when we receive the first packet, there can be relatively
little entropy in the random number generator.  So cryptographically
speaking, it makes sense to use a new seed when the system is already
running for some time.

> and random things in the kernel smells like hard to reproduce errors.

it's fairly common practise to use some random value in a hash
function to not expose the hash table to an attack on it.  It's what all
over the networking code is used for many hash tables.

I don't see how this ever could produce an error.  The hash function is
still deterministic, since the random value is static as long as the
hash table exists.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--0rSojgWGcpz+ezC3
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDS881XaXGVTD0i/8RAnAPAKCvrp5D+Gmv9YZivhZxIcU/2RZekgCfXyyX
9tDaV+lDz8f8kMkYbW3ug20=
=6cwG
-----END PGP SIGNATURE-----

--0rSojgWGcpz+ezC3--
