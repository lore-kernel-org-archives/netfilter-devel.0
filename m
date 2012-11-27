From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH 1/2] build: resolve automake-1.12 warnings
Date: Tue, 27 Nov 2012 08:56:43 +0100
Message-ID: <1354003003.4103.7.camel@tiger2>
References: <1353974099-19891-1-git-send-email-jengelh@inai.de>
	 <1353974099-19891-2-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-u/95RH0Ujx9h+TlTudVk"
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:35104 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758248Ab2K0H5S (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2012 02:57:18 -0500
In-Reply-To: <1353974099-19891-2-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-u/95RH0Ujx9h+TlTudVk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

On Tue, 2012-11-27 at 00:54 +0100, Jan Engelhardt wrote:
> /usr/share/automake-1.12/am/ltlibrary.am: warning:
> 'ulogd_output_SQLITE3.la': linking libtool libraries using a non-POSIX
> archiver requires 'AM_PROG_AR' in 'configure.ac'
> (one for each .la)
>=20
> Signed-off-by: Jan Engelhardt <jengelh@inai.de>
> ---
>  configure.ac |    1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/configure.ac b/configure.ac
> index c70887d..df0e9d3 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -6,6 +6,7 @@ AM_INIT_AUTOMAKE([-Wall foreign tar-pax no-dist-gzip dist=
-bzip2 1.10b])
>  AC_CONFIG_HEADER([config.h])
>  AC_CONFIG_MACRO_DIR([m4])
> =20
> +m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
>  dnl kernel style compile messages
>  m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])

I've applied this patch which even work with an old automake ;)

BR,
--=20
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/

--=-u/95RH0Ujx9h+TlTudVk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlC0cjsACgkQnxA7CdMWjzJDHACfR9sgZvAY1vnwjDuw1ol43OUi
vZcAni9hTFWzJNAILWZFGJcUDrTqx7J8
=bU32
-----END PGP SIGNATURE-----

--=-u/95RH0Ujx9h+TlTudVk--

