Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E105C432BE
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Aug 2021 10:06:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78C66610A8
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Aug 2021 10:06:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhH3KG4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Aug 2021 06:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233248AbhH3KGz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Aug 2021 06:06:55 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6A6C06175F
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Aug 2021 03:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ov+hBqfSDROeQ+Q8eUCn4fgmnA5hkXPb1vDwd9yx6IQ=; b=e/xKVazm3My0R3d8op3CIM8UUX
        97oBNSrkPpZjyemZ5pLNl+pioe3KZ8A+qfSWb/rjX7ZjKOa8hfVFkvzkNNSJLZD9ufEMC+si1kFK9
        rLu9PVvDFKe+tAWvF72xNL7GpBwCtC1aAaN6QokKBW9ShOoHbI96yXEr3v1X4NpztbDPX7ratYZfR
        iltHkhRgsUjo8TYexuPpIM5Nijp3O8suM9UsalClOvz2yKgDJONPs7bwmaWgzbsHpoKLbPCQlNTat
        ewJfdyJaCfrEUVGuzU4ZF1gjwaSD7ljiVv28qnTR2KoTGYa2P/e99dvCTMc7Joil/kox4HiB92L7J
        NJXrS7bQ==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mKeAy-0007z5-Jy; Mon, 30 Aug 2021 11:06:00 +0100
Date:   Mon, 30 Aug 2021 11:05:59 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_log 0/6] Implementation of some fields
 omitted by `ipulog_get_packet`.
Message-ID: <YSyth32P0Q5+0MIt@azazel.net>
References: <20210828193824.1288478-1-jeremy@azazel.net>
 <20210830001621.GA15908@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="+151+1GiuiQ0FZqO"
Content-Disposition: inline
In-Reply-To: <20210830001621.GA15908@salvia>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--+151+1GiuiQ0FZqO
Content-Type: multipart/mixed; boundary="b6ZiZrIqHjLwxIx5"
Content-Disposition: inline


--b6ZiZrIqHjLwxIx5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-08-30, at 02:16:21 +0200, Pablo Neira Ayuso wrote:
> On Sat, Aug 28, 2021 at 08:38:18PM +0100, Jeremy Sowden wrote:
> > The first four patches contain some miscellaneous improvements, then the
> > last two add code to retrieve time-stamps and interface names from
> > packets.
>
> Applied, thanks.
>
> > Incidentally, I notice that the last release of libnetfilter_log was in
> > 2012.  Time for 1.0.2, perhaps?
>
> I'll prepare for release, thanks for signalling.

Thanks.  Here's a patch to create a LIBVERSION variable for
libnetfilter_log_libipulog.

J.

--b6ZiZrIqHjLwxIx5
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline;
	filename="0001-build-add-LIBVERSION-variable-for-ipulog.patch"
Content-Transfer-Encoding: quoted-printable

=46rom f41fb8baa5993e21dbe21ad9ad52c8af2fae4d98 Mon Sep 17 00:00:00 2001
=46rom: Jeremy Sowden <jeremy@azazel.net>
Date: Sun, 29 Aug 2021 11:40:13 +0100
Subject: [PATCH] build: add LIBVERSION variable for ipulog

Replace hard-coded version-info in LDFLAGS.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/Makefile.am | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index 335c393f760a..815d9d31cfc0 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -18,13 +18,14 @@
 # set age to 0.
 # </snippet>
 #
-LIBVERSION=3D2:0:1
+LIBVERSION =3D 2:0:1
+IPULOG_LIBVERSION =3D 1:0:0
=20
 include ${top_srcdir}/Make_global.am
=20
 lib_LTLIBRARIES =3D libnetfilter_log.la
=20
-libnetfilter_log_la_LDFLAGS =3D -Wc,-nostartfiles	\
+libnetfilter_log_la_LDFLAGS =3D -Wc,-nostartfiles \
 			      -version-info $(LIBVERSION)
 libnetfilter_log_la_SOURCES =3D libnetfilter_log.c nlmsg.c
 libnetfilter_log_la_LIBADD  =3D ${LIBNFNETLINK_LIBS} ${LIBMNL_LIBS}
@@ -32,8 +33,8 @@ libnetfilter_log_la_LIBADD  =3D ${LIBNFNETLINK_LIBS} ${LI=
BMNL_LIBS}
 if BUILD_IPULOG
 lib_LTLIBRARIES +=3D libnetfilter_log_libipulog.la
=20
-libnetfilter_log_libipulog_la_LDFLAGS =3D -Wc,-nostartfiles	\
-					-version-info 1:0:0
-libnetfilter_log_libipulog_la_LIBADD =3D libnetfilter_log.la ${LIBNFNETLIN=
K_LIBS}
+libnetfilter_log_libipulog_la_LDFLAGS =3D -Wc,-nostartfiles \
+					-version-info $(IPULOG_LIBVERSION)
+libnetfilter_log_libipulog_la_LIBADD  =3D libnetfilter_log.la ${LIBNFNETLI=
NK_LIBS}
 libnetfilter_log_libipulog_la_SOURCES =3D libipulog_compat.c
 endif
--=20
2.33.0


--b6ZiZrIqHjLwxIx5--

--+151+1GiuiQ0FZqO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmEsrYcACgkQKYasCr3x
BA2Pbg//ZISgyDAiNu/pxEyhrxbuHlWTUcdESFHadu/+gr7qe8n3aOZ9s1ypBxW7
3aNlRh30KzBRQKeJ/d6OQ7BETw+ego6RnnWLbcTgaDb2aEX+VC43uVrtwHfA2u7P
F2rZXM4VuTwGMeUtHphMEfqysTbCF91YdqT6UCHVIKAbJlel31w6DwIVVTYO9Fdo
OSU7fknTM72TwQsWRJyqhNxYCrJ4ho1vdo8m0QmCdmNN140wwje75h5FwRvi0xpj
Rx32iMgpbMzBWRDZ+/XutN8rIHxZNMY2PyRi1X+c2qpApksyb/d5Rs0uN40K/ePJ
x4sXgD6rW3slgovexBIyEpC8BJsS//5A6d26nU+c1CE85aEfgpa2Goa6nZ+ClI3W
jaqKwtPRju8RmLFosP0sfUAs2hcoRBZumsaX82yxx7/0vcjmSaPeXVNSAOFnDPy8
cRsKnyXE8/uTeaanOU1du08NCIEBUZLPSjToecvhFY/Q76TpevU6dG5xLCSoTuGL
z+IKCMOzwa0uKzyc62z3uNHnqsDPRMgxiqD2SHUsjVkl0qNNCYHmIEX0mOgA2UUO
TWxzy0JJ1rR/QOZGa/QpxyVWznPd+yJRYLo+fpnXkuTqnEdC2hhLaoQj2K4vw+Nm
qabyIP1HeGXmmn80YRlX1mtRA+kOYxDUIgLYtZhwt83i9PH4dY0=
=Xnas
-----END PGP SIGNATURE-----

--+151+1GiuiQ0FZqO--
