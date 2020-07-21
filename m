Return-Path: <SRS0=0X8Q=BA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFADEC433E1
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jul 2020 12:48:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C89D206E3
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jul 2020 12:48:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="QCBfzyFS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgGUMsH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Jul 2020 08:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbgGUMsH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Jul 2020 08:48:07 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0080BC061794
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jul 2020 05:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XbDVZBNbu8TghnVKHO3bH9Zo7ZedFCbjtWS2fJ2cwJ0=; b=QCBfzyFS9ukWW0Y0dNRq54b7mX
        si5qrSEXVFInv2f0GQvmwmOU3/W4dKSWqc1OmSbiDbDD3KlIARfMx5KN+rDZAG4Hno2ETER2WChxa
        SBiQxyKJh/nt9A/Yz97pe9iqr28hMsI9CnolthN5vN5AxBHTUqP81d3/j5DBYxsUQo/oxNztrZuQW
        HgZm07urpgzDSeizk4BjVHGspQMMZpGhVne/B7QrgY7GBH8keDR3rSdhK/2Ffd0a6uaUzAuxpamNs
        zNhgU0LZAtrLBf39wkAPayimfRwpiHYOmjZ6P5AstN5VEVCaw1agFufbwM/tXyJn2VBAg1kXmT0EK
        3B5TMnsw==;
Received: from celephais.dreamlands ([192.168.96.3] helo=dreamlands)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1jxrgg-0000Px-UX; Tue, 21 Jul 2020 13:48:03 +0100
Date:   Tue, 21 Jul 2020 13:48:01 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH xtables-addons] doc: fix quoted string in libxt_DNETMAP
 man-page.
Message-ID: <20200721124801.GA885340@dreamlands>
References: <20200721083136.710735-1-jeremy@azazel.net>
 <nycvar.YFH.7.77.849.2007211114060.23166@n3.vanv.qr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.77.849.2007211114060.23166@n3.vanv.qr>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-07-21, at 11:16:00 +0200, Jan Engelhardt wrote:
> On Tuesday 2020-07-21 10:31, Jeremy Sowden wrote:
> > In roff, lines beginning with a single quote are control lines.  In
> > the libxt_DNETMAP man-page there is a single-quoted string at the
> > beginning of a line, which troff tries and fails to interpret as a
> > macro:
>
> Is there some escaping magic available that would make this work as
> well? I would fear that if the next person (me included) comes around
> to use an editor's "wrap at 80 cols" feature, that the quote might
> re-shift to the start of line. If all else, I'd just pick " over ' -
> in the hope that that does not have a special meaning.

Good point.  I had another look at the documentation and found escape-
sequences for opening and closing single quotes.  I'll send out a new
version of the patch.

> > -boot time). Please note that the \fBttl\fR and \fBlasthit\fR entries contain an
> > -'\fBS\fR' in case of a static binding.
> > +boot time). Please note that the \fBttl\fR and \fBlasthit\fR entries contain
> > +an '\fBS\fR' in case of a static binding.

J.

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl8W4/cACgkQonv1GCHZ
79fRDAv+PdRcG9eEwAyglwukmKWQ0u60ZFNfksT9LTAxGoXsaM7FJDTRempSzYkH
iEzFZJ3ypLLb/Gqww6YW3mh7CUqTw1HiWee80L/cG0hcvmAt3Liyj3hyAgLeVEFw
obH61z8YorB3c30fKNu5qyiTjD0RdVSFflfYnG89+7ronORwaUNeY4DmyTkN29GG
8PMUQRN5Cy3JB0CNKeboRlYFiGfNimnitJyJgeHqGXIgD6WSMy0TvJ99WV2bhPfp
Zpjdn5A/Vugx34L+Pn7ZFEZ1Isab23O2LDCdPIDiyyzhg/z6HHKmpo+dEM5CiJDf
j1b2ZLYm4UuLONHYXg7to2smeD6H9bkz2CmuAw0RT/N6kYJsM+JNxEh2bI5HTO8b
Ik49UioZw5ZkJ61V1LJx2AimuVeOgKiEq9fNH+3jVLmSxju7CCCexhuNOOquS95X
UaJI7STnLFG+eEz0nOTkJyY76pPs5sAJ2Y+jR+l5pAScQqH8mmncxhb4YgyU0EFQ
XSJ0IYFl
=khV/
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
