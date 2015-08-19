From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] build: use _DEFAULT_SOURCE for newer glibc
Date: Wed, 19 Aug 2015 09:08:29 -0400
Message-ID: <20150819130829.GY1584@vapier>
References: <1439935658-17834-1-git-send-email-vapier@gentoo.org>
 <alpine.LSU.2.20.1508190908430.11093@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="4Ycl1UgPPPgGZoSL"
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:35968 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbbHSNIb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Aug 2015 09:08:31 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1508190908430.11093@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--4Ycl1UgPPPgGZoSL
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 19 Aug 2015 09:09, Jan Engelhardt wrote:
> On Wednesday 2015-08-19 00:07, Mike Frysinger wrote:
> >Since _BSD_SOURCE is deprecated with newer glibc versions, we get build
> >warnings when using only that define.  Add the newer _DEFAULT_SOURCE to
> >quiet things down.
>=20
> Why do we even need _BSD_SOURCE/_ISOC99_SOURCE/_DEFAULT_SOURCE? The=20
> thing apparently builds without it (glibc-2.19), too.

i would check with the guy who committed this ;)

commit 9921f2b9a241750e4730fc7d486687c6a32779f4
Author: Jan Engelhardt <jengelh@inai.de>
Date:   Wed Oct 10 00:35:14 2012 +0000

    build: resolve compile abort in libxt_limit on RHEL5
   =20
    libxt_limit.c: In function 'print_rate':
        libxt_limit.c:124: error: 'INFINITY' undeclared (first use in
        this function)
   =20
    The default mode of glibc-2.15's <features.h> sets
    "-D_POSIX_C_SOURCE=3D200809L", and therefore "-D_ISOC99_SOURCE". Howeve=
r,
    on =C3=BEe olde RHEL 5's glibc-2.5, it only has "-D_POSIX_C_SOURCE=3D20=
0112L".
   =20
    Explicitly draw in the definition of INFINITY by always defining
    _ISOC99_SOURCE. By doing this, we are moving off of the default set, so
    _BSD_SOURCE also needs to be explicitly set to get at IFNAMSIZ that is
    used in xt_hashlimit.h.
   =20
    Signed-off-by: Jan Engelhardt <jengelh@inai.de>
    Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
-mike

--4Ycl1UgPPPgGZoSL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJV1H/NAAoJEEFjO5/oN/WB1OUP/jAV0ef8nR4pr0qGIhz/VMPU
RJpgFv5Nhl/hy+XBqeAm/HhOcPo5qwUryhBhjFVlP2GTh5uQ+BG0sLQRn1sbkNkt
20x/41mLhQQYf6y1PCxY0W2aZOOsUnF/c1RU5tE0qeJ3B9+O9b8txI1o8vy3AXb/
3sE093O85Yu5VBLGmFqcoq1EGhSsXzMARzmUAPHxwiN0BXJU/sQy1pNMywrC8ql5
d9O6I7Z/KbA9eSh/gEJM8fKZH2qjemw4Qzz3yQe1EB7OiZu/RZn3xqHKcZgBGulb
KspcPD7nM5Dogxe2K9HK97rYMHjzPgRl9nAyySxTqyeEM/OP6c/euCCEJTEFDUcJ
WsrHbA5Go7fdYlT7A3EAIDOC5klnjJhE+7bSrmb53x/R0J0hnsabGiiSJb5n9RV1
PO9Vm1mL1nHbiqGKvdcm51zSWb9d/52PbB//RqvP9UobXQr+C6OLlc8p1XFgiV4Y
UL7bhFUmFxSwMUtX3wnt3rmEGNJRInW+hitBoPd8csLEyk2T6RbgVG7Te38zIUBA
WiWX/GkSI1M+ABOW7ANk745m1aFe0BEcYcyEPdjMm2LN7LGFrvzF3ynt3Nt1Bra9
Xsp6j6Tk8o7rSCiFVCV0xOk5s9rsrJyg/gu+sqVPUmaBXbtdVTVP/vfSf71BYPKb
XvdHrNk1dMZyhYB3+0Fl
=EXff
-----END PGP SIGNATURE-----

--4Ycl1UgPPPgGZoSL--
