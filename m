From: Harald Welte <laforge@netfilter.org>
Subject: Re: [ANNOUNCE] IP sets
Date: Thu, 19 Feb 2004 21:31:13 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040219203113.GI4797@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.58.0402171348210.1089@tux.rsn.bth.se> <Pine.LNX.4.44.0402171452020.30953-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HuscSE0D68UGttcd"
Cc: Martin Josefsson <gandalf@wlug.westbo.se>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0402171452020.30953-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--HuscSE0D68UGttcd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 17, 2004 at 02:56:47PM +0100, Henrik Nordstrom wrote:
> Sounds worse than using vmalloc() to me.

;) well, maybe not from a performance point of view, but from a
aesthetic point of view.

> The main issue here is design requiring a large allocation, not which
> memory allocation method is used.
=20
agreed.

> Wrt the conntrack hashtable, has there been any thought about using a tree
> instead of a hash for conntrack?

Not really.  I have to admit that I personally have too little
experience with trees running in a multithreaded kernel.  One would
first have to analyze the locking / coherency issues.  =20

Yes, we could still use a big conntrack lock for the whole tree.  But
for the current hash table, the direction is heading towards per bucket
locks. =20

What do you want to do in the tree case?=20

Does somebody know any papers discussing performance comparison between
hashtables and various different trees in a multithreaded environment?

Once again, I'm lacking the scientific background (but am willing to
catch up).

> Regards
> Henrkik

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--HuscSE0D68UGttcd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFANR0RXaXGVTD0i/8RAqQQAJ9wgicOPq0pxBYYYA1MzbcLwUnoIgCfRsQc
4Vv5zYpLH0yehCQJ97t5wC4=
=OvCi
-----END PGP SIGNATURE-----

--HuscSE0D68UGttcd--
