From: Phil Dibowitz <phil@ipom.com>
Subject: Re: [PATCH] libnetfilter_conntrack: add extern C's to public headers
Date: Wed, 28 Mar 2007 22:55:06 -0700
Message-ID: <460B54BA.4050303@ipom.com>
References: <45FF7A38.8090907@ipom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig11CF3EA801734D0D3673DE36"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45FF7A38.8090907@ipom.com>
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

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig11CF3EA801734D0D3673DE36
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Phil Dibowitz wrote:
> The attached patch adds:
>=20
>   extern "C" {...}
>=20
> to all of the public headers in libnetfilter_conntrack's public headers=
=2E It
> is, of course, #ifdef __cplusplus'd.
>=20
> This will make it more straight forward for C++ developers to use
> libnetfilter_conntrack in their applications.

I never saw a response to this patch... I was wondering if there was an
objection to it, or if it got accepted, or forgotten, or...?

--=20
Phil Dibowitz                             phil@ipom.com
Open Source software and tech docs        Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"Never write it in C if you can do it in 'awk';
 Never do it in 'awk' if 'sed' can handle it;
 Never use 'sed' when 'tr' can do the job;
 Never invoke 'tr' when 'cat' is sufficient;
 Avoid using 'cat' whenever possible" -- Taylor's Laws of Programming



--------------enig11CF3EA801734D0D3673DE36
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGC1S6N5XoxaHnMrsRAsscAJ42jsdrx5yqUlzneEwuhZh0IlN7dACeMpoZ
GqdRT47xaFJaw/MnHUqb3eE=
=p1Vj
-----END PGP SIGNATURE-----

--------------enig11CF3EA801734D0D3673DE36--
