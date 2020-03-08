Return-Path: <SRS0=ny0B=4Z=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 723F8C10DCE
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Mar 2020 10:39:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1299720828
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Mar 2020 10:39:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="lKbM4yE0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbgCHKjh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 8 Mar 2020 06:39:37 -0400
Received: from kadath.azazel.net ([81.187.231.250]:46156 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbgCHKjh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 8 Mar 2020 06:39:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
        Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ra0PbzN2DPgtntPPytn/Xz77JfToOanOEuDYNJU58+E=; b=lKbM4yE0Or2sLydz8IIoiJtP4b
        qoifZShFxMhsf12fqm7HPnAV9Mr6kmX/ZeAecncFWLrSvLtHPuJ7MzQq2DNUNGtrJO8x1UrG2gxNl
        Y3FMLu8J+RzjKuDrFgC/ipuWaDdrZTJtWOurqT69tJOa38fPM8wFh1lHcOmSupa9r9sRQgRLT0mlK
        pdHVH4Yuj9EazmJsvBfhxkFkzHoScDuiVX3na9bjjXogaImOxtmZYHz+xLxM44QXhVV7Hd17ygr/a
        Z6BN5XkqseuK1f2uFFW8M77/TteKvK2H31KVfKuPjdG642azPQR7QMoy88sMNinckX7brvwby/kU1
        jsqHW9kQ==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1jAtLM-0000Pf-Eg
        for netfilter-devel@vger.kernel.org; Sun, 08 Mar 2020 10:39:36 +0000
Date:   Sun, 8 Mar 2020 10:40:03 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: shift_stmt_expr grammar question
Message-ID: <20200308104003.GC121279@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nmemrqcdn5VTmUEE"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--nmemrqcdn5VTmUEE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Just noticed that the production for right shifts differs from the
production for left shifts (src/parser_bison.y, ll. 3020ff.):

  shift_stmt_expr    :       primary_stmt_expr
                     |       shift_stmt_expr         LSHIFT          primary_stmt_expr
                     {
                             $$ = binop_expr_alloc(&@$, OP_LSHIFT, $1, $3);
                     }
                     |       shift_stmt_expr         RSHIFT          primary_rhs_expr
                     {
                             $$ = binop_expr_alloc(&@$, OP_RSHIFT, $1, $3);
                     }
                     ;

Is there a reason why the RHS of LSHIFT is primary_stmt_expr, but the
RHS of RSHIFT is primary_rhs_expr?

J.

--nmemrqcdn5VTmUEE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl5ky3QACgkQonv1GCHZ
79cLlwwAkAhBzVcMZSjHmui8oBC5z+/7x+gOeIewR2obgRZrsd5Uy1bOfGJjvfiE
iK+GSqlx+cVaeDPz5vw5+DmvE2lL2lkiMvKA3TMfKSw4mdXOk1G4+DtIfHRnobKx
INySJbYfhDQRtMm0Zek4wFnandKLfmR8NWTwRWbPvH2xBnIscfBvHrM8O3g59olJ
tnytauc77L45+YPM+K1lLfkSo4beF7Xi1irH2mpqxwjL63QxWIQSrda9fnOvNo/o
yiWwng1VjNV+7Qhoo+jgdkSCEieYerUi+CCJMxvuoSB2/vaDfHjrE/kJC4v2/Mvb
MIu05HifQTSN2l7z5biuuYHallI2p81g0Z5t+s/8GZIJvSgXVgyDB8uCCLXI/s0A
c3h3vl7EPWxp9HdHh3zopMaenOmrqXpqnMzqSM5PB1O/lKwSpyFa9YJqfGLaXQ7I
AovnfnKz6vEGnq2nsWDB4scIzLAvs1KRJXparRf+j/d1CeMjkJ2AVKgxfOBJn9xs
E2hhVFyg
=0vKj
-----END PGP SIGNATURE-----

--nmemrqcdn5VTmUEE--
