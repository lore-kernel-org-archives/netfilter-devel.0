From: Harald Welte <laforge@netfilter.org>
Subject: Re: ip_conntrack_lock usage?
Date: Wed, 11 Jun 2003 14:10:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030611121001.GL32593@sunbeam.de.gnumonks.org>
References: <200306080221.h582L8f07562@singularity.tronunltd.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="16qp2B0xu0fRvRD7"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ian Latter <Ian.Latter@mq.edu.au>
Content-Disposition: inline
In-Reply-To: <200306080221.h582L8f07562@singularity.tronunltd.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--16qp2B0xu0fRvRD7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 08, 2003 at 12:21:07PM +1000, Ian Latter wrote:
> Hey dudes,

>   The old rpc-recent module(s) had a comment at the top that said;
>     +/* For future conections RPC, using client's cache bindings
>     + * I'll use ip_conntrack_lock to lock these lists         */
>=20
> .. why would you use a global locking mechanism for lists that only have
> local implications?

I don't know the code in detail, but I don't see why.  If the private
lists are only changed from within the rpc helper,  there is no point
using the global lock.

The only reason I can think of:

ip_conntrack_lock is taken already by the core for most of the places
the lists are modified.  Then it makes more sense to use
ip_conntrack_lock from the few remaining places than adding a new
(for most cases nested) lock

> Thanks,
> Ian Latter

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--16qp2B0xu0fRvRD7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+5xwZXaXGVTD0i/8RAhwlAKCgo0eH0N+VHjvJHvMzA10B3u8wDACfcmM0
RqH500tf+7Cr4SiqHOaXjdg=
=vP4T
-----END PGP SIGNATURE-----

--16qp2B0xu0fRvRD7--
