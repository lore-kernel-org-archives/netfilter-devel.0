From: Alexander Samad <alex@samad.com.au>
Subject: Re: Problem compiling iptables 3887
Date: Thu, 28 Apr 2005 13:41:20 +1000
Message-ID: <20050428034120.GJ11176@samad.com.au>
References: <20050428014428.GF11176@samad.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="va4/JQ6j8/8uipEp"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050428014428.GF11176@samad.com.au>
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


--va4/JQ6j8/8uipEp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi=20

Found it I had DEBUG flag set !

A

On Thu, Apr 28, 2005 at 11:44:28AM +1000, Alexander Samad wrote:
> Hi
>=20
> I currently build my own kernel and iptables patched with pom-ng - I get
> these via svn.  Iptables version 3887 , pom-ng  3887
>=20
> Whilst attempting to do this recently (last week or so) I have come
> across this compilation problem
>=20
> cc -O2 -Wall -Wunused -I../../linux/include -Iinclude/
> -DIPTABLES_VERSION=3D\"1.3.1\" -g -DDEBUG -pg  -DIPTC_DEBUG
> -DNO_SHARED_LIBS=3D1   -c -o libiptc/libip6tc.o libiptc/libip6tc.c
> libiptc/libip6tc.c: In function `do_check':
> libiptc/libip6tc.c:281: warning: implicit declaration of function
> `get_chain_end'
> libiptc/libip6tc.c:282: warning: implicit declaration of function
> `get_entry'
> libiptc/libip6tc.c:282: error: invalid type argument of `->'
> l
>=20
> I was wondering if somebody can help me fix it or tell me who to talk to
> advise of the problem ?
>=20
> Thanks
> Alex



--va4/JQ6j8/8uipEp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCcFtgkZz88chpJ2MRAiO1AKCEysgTVxJeofhK544fZFok9XIpRQCgxiWL
pUyZcSPuNC4YQgNYitqNEEQ=
=oQP3
-----END PGP SIGNATURE-----

--va4/JQ6j8/8uipEp--
