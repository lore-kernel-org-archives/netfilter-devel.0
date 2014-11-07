From: Giorgio <giorgio.nicole@arcor.de>
Subject: Re: [PATCH nft 5/5] build: autotools conversion
Date: Fri, 07 Nov 2014 19:17:25 +0100
Message-ID: <545D0CB5.90909@arcor.de>
References: <1415298349-985-1-git-send-email-pablo@netfilter.org> <1415298349-985-6-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="8F7dAX5Tw4ADbjH2Xhhv3lMJpRdi86msv"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:49859 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751459AbaKGSTK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Nov 2014 13:19:10 -0500
In-Reply-To: <1415298349-985-6-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8F7dAX5Tw4ADbjH2Xhhv3lMJpRdi86msv
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 11/06/2014 07:25 PM, Pablo Neira Ayuso wrote:

> diff --git a/Make_global.am b/Make_global.am
> new file mode 100644
> index 0000000..8ad0eb0
> --- /dev/null
> +++ b/Make_global.am
> @@ -0,0 +1,10 @@
> +AM_CPPFLAGS =3D -I$(top_srcdir)/include
> +AM_CPPFLAGS +=3D -DDEFAULT_INCLUDE_PATH=3D"\"${sysconfdir}\"" -D__USE_=
GNU
> +
> +AM_CFLAGS =3D -Wall	\
> +	    -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations	\=

> +	    -Wdeclaration-after-statement -Wsign-compare -Winit-self		\
> +	    -Wformat-nonliteral -Wformat-security -Wmissing-format-attribute	=
\
> +	    -Wcast-align -Wundef -Wbad-function-cast # -Wshadow			\
> +	    -Waggregate-return -Wunused -Wwrite-strings				\
> +	    ${LIBMNL_CFLAGS} ${LIBNFTNL_CFLAGS}

why do you need this new file? The #include in the main Makefile.am is
useless because you do not build anything there; the only right place to
have these definitions is under src/Makefile.am.

giorgio



--8F7dAX5Tw4ADbjH2Xhhv3lMJpRdi86msv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlRdDLwACgkQYqbc2h3T5VAbrACdGPWgq05tOBew1yFOEaW/fqYL
SZsAoL3HWCEhkBieynTH9iUlL+6v9xzg
=+isE
-----END PGP SIGNATURE-----

--8F7dAX5Tw4ADbjH2Xhhv3lMJpRdi86msv--
