From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Use net/checksum.h, not asm/checksum.h
Date: Sun, 21 Sep 2003 16:47:29 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030921144729.GC22223@sunbeam.de.gnumonks.org>
References: <20030920001917.GG21596@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d01dLTUuW90fS44H"
Cc: James Morris <jmorris@intercode.com.au>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Matthew Wilcox <willy@debian.org>
Content-Disposition: inline
In-Reply-To: <20030920001917.GG21596@parcelfarce.linux.theplanet.co.uk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--d01dLTUuW90fS44H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 20, 2003 at 01:19:17AM +0100, Matthew Wilcox wrote:
>=20
> On PA-RISC, I get the warning:
>=20
> In file included from net/ipv4/netfilter/ip_nat_snmp_basic.c:56:
> include/asm/checksum.h:127: warning: `struct in6_addr' declared inside pa=
rameter
>  list
> include/asm/checksum.h:127: warning: its scope is only this definition or=
 declar
> ation, which is probably not what you want.
>=20
> This patch fixes that:

Thanks willy, I will push this patch to davem for kernel inclusion


--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--d01dLTUuW90fS44H
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/bboBXaXGVTD0i/8RAkFsAKCn/8I5Obd4SigjzaB4jnUburmzOQCgkINx
JENGwznAwZYEO6OPi2ST1wA=
=3T5R
-----END PGP SIGNATURE-----

--d01dLTUuW90fS44H--
