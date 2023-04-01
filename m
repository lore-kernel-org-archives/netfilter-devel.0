Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E46A1C6FD1D
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Apr 2023 12:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbjDAMaX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Apr 2023 08:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjDAMaW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Apr 2023 08:30:22 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB2C1C1C9
        for <netfilter-devel@vger.kernel.org>; Sat,  1 Apr 2023 05:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+yIQpz08NzW+VcjAnULq1l1jurc7RD8S9m3HXsWEiMA=; b=ZyQzbE+yX//DM3KWRzrkvB5iX1
        NsyzhPETmjIr/0GrcfoIFfS8YFKTh9odvisbbT1gn79CYpHJAVTs/PWBYmPrP7LcVinxjP0yyk9Zb
        KNdYaBEc3UD9JcgHJ7+49rkdW6QGX5vkaGBGUynK724WYhNW0/XwhmFkS8Axbaac5T6uHGc95n9BP
        Q36EdBNsmYmP5zQOb1U6TeQIGG7YbFnkCoOQ394VTL/sDq17uMto9NszcsS7I97Z2YwZbLSxBJ3Zc
        wryuuuEFn37Meo1RZExiYe8UIIkX3Q5n/95JCj2rEmgjNRfkYdunzGRz06Tpezogu1uenP36OlREq
        RREaZelA==;
Received: from [2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] (helo=celephais.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1piaN9-00EGVZ-3g; Sat, 01 Apr 2023 13:30:19 +0100
Date:   Sat, 1 Apr 2023 13:30:18 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Alyssa Ross <hi@alyssa.is>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables] build: use pkg-config for libpcap
Message-ID: <20230401123018.GC730228@celephais.dreamlands>
References: <20230331223601.315215-1-hi@alyssa.is>
 <20230401114304.GB730228@celephais.dreamlands>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="e7PYVrhgIg72Dzqj"
Content-Disposition: inline
In-Reply-To: <20230401114304.GB730228@celephais.dreamlands>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--e7PYVrhgIg72Dzqj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-04-01, at 12:43:04 +0100, Jeremy Sowden wrote:
> On 2023-03-31, at 22:36:01 +0000, Alyssa Ross wrote:
> > If building statically, with libpcap built with libnl support, linking
> > will fail, as the compiler won't be able to find the libnl symbols
> > since static libraries don't contain dependency information.  To fix
> > this, use pkg-config to find the flags for linking libpcap, since the
> > pkg-config files contain the neccesary dependency information.
>                                ^^^^^^^^^
> "necessary"			      =20
>=20
> > Signed-off-by: Alyssa Ross <hi@alyssa.is>
>=20
> LGTM.

Actually, there is a problem.  See below.

> The only thing I would say is that pkg-config support was added
> to libpcap comparatively recently (2018).  When I made similar changes
> to ulogd2 last year, I added a fall-back to pcap-config:
>=20
>   https://git.netfilter.org/ulogd2/commit/?id=3Dbe4df8f66eb843dc19c7d1fed=
7c33fd7a40c2e21
>=20
> > ---
> >  configure.ac      | 3 ++-
> >  utils/Makefile.am | 6 +++---
> >  2 files changed, 5 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/configure.ac b/configure.ac
> > index bc2ed47b..e0bb26aa 100644
> > --- a/configure.ac
> > +++ b/configure.ac
> > @@ -114,7 +114,8 @@ AM_CONDITIONAL([ENABLE_NFTABLES], [test "$enable_nf=
tables" =3D "yes"])
> >  AM_CONDITIONAL([ENABLE_CONNLABEL], [test "$enable_connlabel" =3D "yes"=
])
> > =20
> >  if test "x$enable_bpfc" =3D "xyes" || test "x$enable_nfsynproxy" =3D "=
xyes"; then
> > -	AC_CHECK_LIB(pcap, pcap_compile,, AC_MSG_ERROR(missing libpcap librar=
y required by bpf compiler or nfsynproxy tool))
> > +	PKG_CHECK_MODULES([libpcap], [libpcap], [], [
> > +		AC_MSG_ERROR(missing libpcap library required by bpf compiler or nfs=
ynproxy tool)])
> >  fi

When autoconf first encounters `PKG_CHECK_MODULES`, if `$PKG_CONFIG` is
not already defined it will execute `PKG_PROG_PKG_CONFIG` to find it.
However, because you are calling `PKG_CHECK_MODULES` in a conditional,
if `$enable_bpfc` and `$enable_nfsynproxy` are not `yes`, the expansion
of `PKG_PROG_PKG_CONFIG` will not be executed and so the following
pkg-config checks will fail:

  checking for libnfnetlink >=3D 1.0... no
  checking for libmnl >=3D 1.0... no
  *** Error: No suitable libmnl found. ***
      Please install the 'libmnl' package
      Or consider --disable-nftables to skip
      iptables-compat over nftables support.

Something like this will fix it:

  @@ -14,6 +14,7 @@ AC_PROG_CC
   AM_PROG_CC_C_O
   m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
   LT_INIT([disable-static])
  +PKG_PROG_PKG_CONFIG
  =20
   AC_ARG_WITH([kernel],
          AS_HELP_STRING([--with-kernel=3DPATH],

> >  PKG_CHECK_MODULES([libnfnetlink], [libnfnetlink >=3D 1.0],
> > diff --git a/utils/Makefile.am b/utils/Makefile.am
> > index e9eec48f..34056514 100644
> > --- a/utils/Makefile.am
> > +++ b/utils/Makefile.am
> > @@ -2,7 +2,7 @@
> > =20
> >  AM_CFLAGS =3D ${regular_CFLAGS}
> >  AM_CPPFLAGS =3D ${regular_CPPFLAGS} -I${top_builddir}/include \
> > -              -I${top_srcdir}/include ${libnfnetlink_CFLAGS}
> > +              -I${top_srcdir}/include ${libnfnetlink_CFLAGS} ${libpcap=
_CFLAGS}
> >  AM_LDFLAGS =3D ${regular_LDFLAGS}
> > =20
> >  sbin_PROGRAMS =3D
> > @@ -25,12 +25,12 @@ endif
> >  if ENABLE_BPFC
> >  man_MANS +=3D nfbpf_compile.8
> >  sbin_PROGRAMS +=3D nfbpf_compile
> > -nfbpf_compile_LDADD =3D -lpcap
> > +nfbpf_compile_LDADD =3D ${libpcap_LIBS}
> >  endif
> > =20
> >  if ENABLE_SYNCONF
> >  sbin_PROGRAMS +=3D nfsynproxy
> > -nfsynproxy_LDADD =3D -lpcap
> > +nfsynproxy_LDADD =3D ${libpcap_LIBS}
> >  endif
> > =20
> >  CLEANFILES =3D nfnl_osf.8 nfbpf_compile.8
> >=20
> > base-commit: 09f0bfe2032454d21e3650e7ac75c4dc53f3c881
> > --=20
> > 2.37.1
> >=20
> >=20

J.



--e7PYVrhgIg72Dzqj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmQoI9kACgkQKYasCr3x
BA0cGg/9EHQN+cC+RADGW2JC92M6slcZ9DqC++M+l1kgq6mgAFwLpiHa06DKAPnm
ZqeNQMbYpCwTF7k6sNtp8LcRO60IR36eiOmCMGgOoGLZS+S3Fg5Fl8Emzrfbdjix
FfFHur4hZSumfz7RuokOoUqOGHPDjm334ky7UfwrD4GnFw/gkOAbofcxhB2a8XEl
vvwqxCC3+rTh9ljJwMpuFM3CpaXzxKFYZt9nRaVFYMZo7DRYoe2FVZgpDyxYzL25
3dVopLD68IPCMJ+o1WoddVjPTFtHuTM+/qtwe6RleBQbNSJuVzmjexxjCocYuPKs
zEVsow4juZTVOAAIrl00TLItp+9V6h0ZfXhRhenGzGBzSSNTnwk02wieo78DASUm
So2ZdCMUmeFc3jBn2ZIw/qCEBnXonkJlk9JxtWLfsrnlMOV/ZeoQw+RPMTHe+TF8
O7+0+oSJVkLOcR0Bk0Je1RFLUZZ2o2dLSdopJXGO398cdFzTLkvUXG8iIvl7R+rc
DS9fOuKF9YVRSNrZCTra+gUhjMEA2dFJDVeQL90MWicArTy8LsiQvsg+8dz+ZrVp
RVA9eBQeTiIWgYMSAaDsDp+vUQgrKYflUtdbsLpbUaHhUzxTxbfYQ0jedrnv/lXb
t7ONYpV2CKB/wEiAL23BKKe8mKpU1YL0MmgRZ4NF3m+62vYJX08=
=zPKG
-----END PGP SIGNATURE-----

--e7PYVrhgIg72Dzqj--
