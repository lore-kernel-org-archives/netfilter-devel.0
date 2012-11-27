From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH 2/2] build: resolve compile error due to missing nfacct
 CPPFLAGS
Date: Tue, 27 Nov 2012 08:54:35 +0100
Message-ID: <1354002875.4103.5.camel@tiger2>
References: <1353974099-19891-1-git-send-email-jengelh@inai.de>
	 <1353974099-19891-3-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ifb9nGeasIs6n/gOw4Wp"
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:35064 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757643Ab2K0HzN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2012 02:55:13 -0500
In-Reply-To: <1353974099-19891-3-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-ifb9nGeasIs6n/gOw4Wp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

On Tue, 2012-11-27 at 00:54 +0100, Jan Engelhardt wrote:
> Fixes this error:
>=20
> make[3]: Entering directory "/home/jengelh/code/ulogd2/output"
>   CC       ulogd_output_XML.lo
> ulogd_output_XML.c:31:49: fatal error:
> libnetfilter_acct/libnetfilter_acct.h: No such file or directory
>=20
> (Note that pkgconfig-provided cflags are actually cppflags, so
> I add ${LIBNETFILTER_ACCT_CFLAGS} to AM_CPPFLAGS.)
>=20
> Signed-off-by: Jan Engelhardt <jengelh@inai.de>
> ---
>  output/Makefile.am |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/output/Makefile.am b/output/Makefile.am
> index 630aee6..61d827a 100644
> --- a/output/Makefile.am
> +++ b/output/Makefile.am
> @@ -1,4 +1,4 @@
> -AM_CPPFLAGS =3D -I$(top_srcdir)/include
> +AM_CPPFLAGS =3D -I$(top_srcdir)/include ${LIBNETFILTER_ACCT_CFLAGS}
>  AM_CFLAGS =3D ${regular_CFLAGS} ${LIBNETFILTER_LOG_CFLAGS} \
>  	    ${LIBNETFILTER_CONNTRACK_CFLAGS}

Good catch but on last line we use the other ${LIBNETFILTER*_CFLAGS} to
populate AM_CFLAGS. We should keep all variables at the same place. If
we follow your indication in the commit we should use AM_CPPFLAGS (I'm
agree with that).

BR,
--=20
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/

--=-ifb9nGeasIs6n/gOw4Wp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlC0cbsACgkQnxA7CdMWjzIbAwCfXBjD2prhDAYI8PXXoazA376g
98EAoI4eUyLfTnttarURo0aQQ7qzyN72
=3isO
-----END PGP SIGNATURE-----

--=-ifb9nGeasIs6n/gOw4Wp--

