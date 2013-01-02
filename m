From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] build: resolve link failure for ip6t_NETMAP
Date: Tue, 1 Jan 2013 23:03:51 -0500
Message-ID: <201301012303.52249.vapier@gentoo.org>
References: <201212301951.47241.vapier@gentoo.org> <1356933246-20336-1-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1876285.sIHVEUn7za";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:60625 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab3ABECP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Jan 2013 23:02:15 -0500
In-Reply-To: <1356933246-20336-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--nextPart1876285.sIHVEUn7za
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 31 December 2012 00:54:06 Jan Engelhardt wrote:
> Like this? We cannot really get rid of mentioning .libs without involving
> libltdl, and there I really do not want to go.

why ?  are the modules run directly out of the build tree, or you just need=
 to=20
install them ?  `libtool --mode=3Dinstall` can install an .la file ...

> +	${AM_VERBOSE_NULL} ln -fs .libs/$@ $@;

i'm not sure why a lot of these rules have trailing semi-colons.  they're=20
pointless.

> +	${AM_VERBOSE_CCLD} ../libtool ${AM_LIBTOOL_SILENT} --tag=3DCC --mode=3D=
link
> ${CCLD} ${AM_LDFLAGS} -module ${LDFLAGS} -o $@ $< -L../libxtables
> -lxtables ${$*_LIBADD} -rpath ${xtlibdir};

should be ../libxtables/libxtables.la rather than -L/-l for libxtables

>  libxt_NOTRACK.so: libxt_CT.so
>  	ln -fs $< $@
> libxt_state.so: libxt_conntrack.so
>  	ln -fs $< $@

these two rules could use your new $AM_VERBOSE_NULL

otherwise, this is an improvement imo over the existing code
=2Dmike

--nextPart1876285.sIHVEUn7za
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJQ47GoAAoJEEFjO5/oN/WBEt0P/jlZ2caMTEMYvt8dAatvu6mi
Rigby04XRyZk+/UkucORMeCUj6mYcfdoXDnK1JM0GiWBsk6yG9ZQM4ekPvPEDb7J
GMbkoKqk7IB2/xsB7FfEqbD35oLVNPSQ0rRpYfWOof1FPiWJJ3J5/r5YKDqr13Ww
pZTRs1FugfyoNFOgUiT0wWlKLP9zwiSf/y9V2sFMVocHY7e8gdjWRHua+FIfP5fn
HygmAhIXnIMhWxXIkg0XeK5e+CD/6QoZXNbFR13gfBi3Ol1B6DxbdqD63Ywt3ybt
k1XgZhwjzUTQJT/obmnl7RAWQL5Jv1XpjAWe2tbN6RLtVOBB7Yo+py0zX8azNAcM
mLLCWxIJSyr7EftqwH+nP67UKwKnb3j6Fta3dKD3jPU7iDjqmm3GQudRDEA9DXTO
/h6uZnpvceMH/oGu6ZuTDwT3gSWasz/CWhLNY7Blj0n477+ET4QrHVoeEc6GWILY
+UtO3wwYvGbJINUtUbWuxkx85n7WR7zk25lQYlaKEufcRqWT1onU6cVjCElngTOk
5l/32mnYEmBE9+PkYYhZwzdQoacEWq+4RzDt+5QnoqLw0QokcvwlndLa417Vxsf5
2V2h3JWWwEIwP2xlHpjloluYKiHsY8Oi0xUlhkeQJifJNoVVNMxIPKk3aH/wAith
6UfzcVFUVzLxyraXPnrC
=KkBX
-----END PGP SIGNATURE-----

--nextPart1876285.sIHVEUn7za--
