From: Harald Welte <laforge@netfilter.org>
Subject: Re: memory leak related to bridging, conntrack and frags in 2.6.0
Date: Fri, 12 Dec 2003 16:55:43 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031212155543.GD14920@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.58.0312121001360.14007@picea.navaho>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pAwQNkOnpTn9IO2O"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andy Loukes <andy@navaho.co.uk>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0312121001360.14007@picea.navaho>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--pAwQNkOnpTn9IO2O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 12, 2003 at 10:10:33AM +0000, Andy Loukes wrote:
> 2.6.0-test11-bk8
> eepro100 driver
>=20
> I'm getting a major memory leak across a bridge. It goes away if I remove=
=20
> the conntrack module or I use packets < MTU.

are you sure it's a memory leak?  Please explain why.  Which number in
/proc/slabinfo are you looking at?  And did you confirm that this is not
just some cache that expires after some time?

> With this:
> ttcp -tus 172.16.0.12 -n 25000 -b 5000
> (25000 x 5000 byte udp packets)
>=20
> I see size-64 in slabinfo go up by 8472kB

I don't see where connection tracking allocates size-64 items.
Connection tracking creates it's own slab cache (called ip_conntrack).
And that one will certainly grow.

It also cannot be the fragment cache.  At least AFAIK it doesn't
allocate any additional per-packet data structures apart from the skb...
and that one is again not size-64.

> Some colleagues and I are trying to figure out where the problem is but I=
=20
> thought I'd post to see if anyone has any debugging tips (we are just=20
> starting to get our heads round NF!) or whether this is a known problem.
>=20
> regds,
>=20
> --=20
> Andy Loukes
> http://www.navaho.co.uk						Complete Appliance Technology
>=20
>=20

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--pAwQNkOnpTn9IO2O
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/2eT/XaXGVTD0i/8RAttaAJ90eARZ3p+nKcoAgwobYr6VJdnZmgCgju4Q
DqmLyhcVlwJVkc3G+Ute8+A=
=1jC/
-----END PGP SIGNATURE-----

--pAwQNkOnpTn9IO2O--
