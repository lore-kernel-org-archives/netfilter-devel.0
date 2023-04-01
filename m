Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 236CBC6FD1D
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Apr 2023 11:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjDALnL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Apr 2023 07:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjDALnK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Apr 2023 07:43:10 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DF5CC12
        for <netfilter-devel@vger.kernel.org>; Sat,  1 Apr 2023 04:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hjIrFEu3FTnKsDMWAUYixwSHT2eKfiL4NwO1piZCqeI=; b=BqKcp2yVaoFn86QZtq5I5d/O96
        ptnDZPXiaCnCmR6DkdrsjhsNAZ6c2yE+KUDOHVtgJTL1la4XffE7khpiMNslvD7M4Pn8tlSWoiliX
        E1uhh1mC2H49kJwEIueyojGuWtlsoQvOSYGzkZjwb9EDL25BgRTvqh41DZI2TqfiCznXnmPXs+uvN
        48Wrdlp0xxdj0oX/uxNnfrNJZRgpQePlSuMvpQ9HySfPbnMnODwan9hSXKBet4/u6Ykyx98yzUTP5
        CkaDs7uSyoiPVLsVLJIWpOrxoLBuvWV7gYAMLSlXWYSf9uVDkwbP+fzTHYgp2YMC0OTpUBulSpTPJ
        TXyTew5w==;
Received: from [2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] (helo=celephais.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1piZdR-00EEph-Rk; Sat, 01 Apr 2023 12:43:05 +0100
Date:   Sat, 1 Apr 2023 12:43:04 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Alyssa Ross <hi@alyssa.is>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables] build: use pkg-config for libpcap
Message-ID: <20230401114304.GB730228@celephais.dreamlands>
References: <20230331223601.315215-1-hi@alyssa.is>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="9W2Pspl7wwrUuxAh"
Content-Disposition: inline
In-Reply-To: <20230331223601.315215-1-hi@alyssa.is>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--9W2Pspl7wwrUuxAh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-03-31, at 22:36:01 +0000, Alyssa Ross wrote:
> If building statically, with libpcap built with libnl support, linking
> will fail, as the compiler won't be able to find the libnl symbols
> since static libraries don't contain dependency information.  To fix
> this, use pkg-config to find the flags for linking libpcap, since the
> pkg-config files contain the neccesary dependency information.
                               ^^^^^^^^^
"necessary"			      =20

> Signed-off-by: Alyssa Ross <hi@alyssa.is>

LGTM.  The only thing I would say is that pkg-config support was added
to libpcap comparatively recently (2018).  When I made similar changes
to ulogd2 last year, I added a fall-back to pcap-config:

  https://git.netfilter.org/ulogd2/commit/?id=3Dbe4df8f66eb843dc19c7d1fed7c=
33fd7a40c2e21

> ---
>  configure.ac      | 3 ++-
>  utils/Makefile.am | 6 +++---
>  2 files changed, 5 insertions(+), 4 deletions(-)
>=20
> diff --git a/configure.ac b/configure.ac
> index bc2ed47b..e0bb26aa 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -114,7 +114,8 @@ AM_CONDITIONAL([ENABLE_NFTABLES], [test "$enable_nfta=
bles" =3D "yes"])
>  AM_CONDITIONAL([ENABLE_CONNLABEL], [test "$enable_connlabel" =3D "yes"])
> =20
>  if test "x$enable_bpfc" =3D "xyes" || test "x$enable_nfsynproxy" =3D "xy=
es"; then
> -	AC_CHECK_LIB(pcap, pcap_compile,, AC_MSG_ERROR(missing libpcap library =
required by bpf compiler or nfsynproxy tool))
> +	PKG_CHECK_MODULES([libpcap], [libpcap], [], [
> +		AC_MSG_ERROR(missing libpcap library required by bpf compiler or nfsyn=
proxy tool)])
>  fi
> =20
>  PKG_CHECK_MODULES([libnfnetlink], [libnfnetlink >=3D 1.0],
> diff --git a/utils/Makefile.am b/utils/Makefile.am
> index e9eec48f..34056514 100644
> --- a/utils/Makefile.am
> +++ b/utils/Makefile.am
> @@ -2,7 +2,7 @@
> =20
>  AM_CFLAGS =3D ${regular_CFLAGS}
>  AM_CPPFLAGS =3D ${regular_CPPFLAGS} -I${top_builddir}/include \
> -              -I${top_srcdir}/include ${libnfnetlink_CFLAGS}
> +              -I${top_srcdir}/include ${libnfnetlink_CFLAGS} ${libpcap_C=
FLAGS}
>  AM_LDFLAGS =3D ${regular_LDFLAGS}
> =20
>  sbin_PROGRAMS =3D
> @@ -25,12 +25,12 @@ endif
>  if ENABLE_BPFC
>  man_MANS +=3D nfbpf_compile.8
>  sbin_PROGRAMS +=3D nfbpf_compile
> -nfbpf_compile_LDADD =3D -lpcap
> +nfbpf_compile_LDADD =3D ${libpcap_LIBS}
>  endif
> =20
>  if ENABLE_SYNCONF
>  sbin_PROGRAMS +=3D nfsynproxy
> -nfsynproxy_LDADD =3D -lpcap
> +nfsynproxy_LDADD =3D ${libpcap_LIBS}
>  endif
> =20
>  CLEANFILES =3D nfnl_osf.8 nfbpf_compile.8
>=20
> base-commit: 09f0bfe2032454d21e3650e7ac75c4dc53f3c881
> --=20
> 2.37.1
>=20
>=20

J.

--9W2Pspl7wwrUuxAh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmQoGLwACgkQKYasCr3x
BA3tkA//QaQJGJqcNUW5/Odczr9R8adGNWlazz3SyglvcHmVQG7ApXZ8QnlYPzgN
jYV4QZ85sd5OsXSJli0FHaLn9smy/VvkZyzv03nplcYrujxVdXwDaWU3kUAqxCD4
JiBWRykBvdSZGRdbAYJrEbCWLYR6WDr/Pmjp/aE/i3cf2Xt1ejGbteIOA8giUN8r
Jem6D3/iIGmIDAnPpo+8z5A13g8/6WETC9uOtxE2jVm49RCrDsO6XwA1kboxISQ5
1EfrlRTtBZboYn/qQFpEpvDLC/qJpUEKlp7Zr5QzQvBcDGaYC/2a7eSd57EnflAC
NkCTO5IbsTLKY10Vk+rfpv+VGdYFpdXUbfHsClTjgve6FlLbOEHhQrZHhwzqLQ6o
EYnX6Qw1EyidfIV2EGJngC9pLZUxFOrZvRNnJJ12G5yFT2K1D0ZZLFgKZBfo0N/c
7bSvi5GyKlFQYiLT1BvVyT4I4nR015e7X9444q1TEysRxh4rqoEJCOcmiJEpWIep
cNTaeRiUoM08wuwOhSDUCuNNASfYUpdydVbd/3gD/M2kndj48bFGQjr7Lz17w4UV
DqFbFItRfAUFjtHuZJ6sqjRsU4YZxAbP39NQWNNTPguCTm4zb9Goo205UNSr7NU+
0qMPGVJ0kOqQAaX5hjeQX8icLYXOv0quaB6JGtooSuZx4/MXON4=
=1fLM
-----END PGP SIGNATURE-----

--9W2Pspl7wwrUuxAh--
