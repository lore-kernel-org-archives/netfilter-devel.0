From: Harald Welte <laforge@netfilter.org>
Subject: Re: TTL patch buggy?
Date: Wed, 7 Jan 2004 20:31:35 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040107193135.GE6629@obroa-skai.de.gnumonks.org>
References: <1073426586.15282.13.camel@jasiiitosh.nexusmgmt.com> <Pine.LNX.4.44.0401071709030.4717-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nHwqXXcoX0o6fKCv"
Cc: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0401071709030.4717-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--nHwqXXcoX0o6fKCv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 07, 2004 at 05:16:51PM +0100, Henrik Nordstrom wrote:
> Harald: What do you think about making the patch civilised and restricting
> the TTL to be set to lower values only eleminating the need of the above
> safeguard match? (simply change "new_ttl !=3D iph->ttl" to "new_ttl <=20
> iph->ttl")

No. The most common use of the TTL target is to re-increment the ttl to
64 at the gateway.  This is for br0ken ISP's that don't allow you to use
a router behind your DSL line.  They check if the TTL is one of the
commonly-used values (32,64,128).. .if it is an odd number, they drop
the packet.

Yes, it is dangerous.  That's why we didn't put it in the stock kernel.
But still, it has valid uses :(

> Regards
> Henrik

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--nHwqXXcoX0o6fKCv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE//F6XXaXGVTD0i/8RArSDAJ4rR/FJ3OSgc4/Y7HKJ9jAK8OV4qACfQ3wA
EvIAZIx7p3NIf+1NZ/lyjs0=
=h1fM
-----END PGP SIGNATURE-----

--nHwqXXcoX0o6fKCv--
