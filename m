From: Harald Welte <laforge@netfilter.org>
Subject: Re: hppa and s390 build error, 1.2.9 + 2.4.24 headers
Date: Sat, 14 Feb 2004 21:55:27 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040214205527.GZ7756@sunbeam.de.gnumonks.org>
References: <20040213174222.GC14190@absolom.libra.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VIT1Kna7lLfXMiZV"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Laurence J. Lane" <ljlane@nontoxic.org>
Content-Disposition: inline
In-Reply-To: <20040213174222.GC14190@absolom.libra.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--VIT1Kna7lLfXMiZV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 13, 2004 at 12:42:22PM -0500, Laurence J. Lane wrote:
> Does anyone have an idea of what is going wrong in the error below? It=20
> happens on s390 and hppa with 2.4.24 headers. Both build fine with 2.4.19
> headers.

Unfortunately I don't have access to any of those machines to further
debug the problem.

> failed hppa build excerpt:
>=20
>   /build/buildd/iptables-1.2.9/debian/build/linux-2.4.24/include/linux/ne=
tfilter_ipv4/ip_conntrack_icmp.h:9: error: parse error before "atomic_t"

this sounds like some problem with atomic_t in an include file of a
userspace program (iptables in this case).

However, the typedef for atomic_t (asm-s390/atomic.h) looks quite fine
to me.

Is there anything special about kernel/userspace toolchain on those
architectures (like different compiler versions, ...)?

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--VIT1Kna7lLfXMiZV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFALos/XaXGVTD0i/8RAp9pAKCyo9E7NRCw3i4IX57VLkGhPYTVvQCgm22k
2pD08+FLSyIsGTpT3OIElpc=
=GEAE
-----END PGP SIGNATURE-----

--VIT1Kna7lLfXMiZV--
