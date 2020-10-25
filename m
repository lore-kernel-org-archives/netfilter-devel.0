Return-Path: <SRS0=hvDf=EA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 266ACC55178
	for <netfilter-devel@archiver.kernel.org>; Sun, 25 Oct 2020 10:59:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96D4C222D9
	for <netfilter-devel@archiver.kernel.org>; Sun, 25 Oct 2020 10:59:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="WoR89xsp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415267AbgJYK7Q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 25 Oct 2020 06:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1415239AbgJYK7P (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Oct 2020 06:59:15 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CFB9C0613D0
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Oct 2020 03:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7n7SwAXK/1iIppVx97iK1x5jtej4kFrNJQQ4dbwgUjE=; b=WoR89xspZns/u9Vhyd1CUKj53R
        0F03hArNuoMR/AWZOSlnSROT980lHjMQags5UyfmnEif54rWoQmxa4tSISOJPL3qaRIiv7QducjdA
        SrJUKnUTnQMXqtJuvf2h17FUDEccp9NW8vwQ+jjm8ab0q4RVUpkRWYWYyLExmHpRrCYghqsmbcpnE
        sTAFvxhmDZlPHiKd0Hms+3aB8BfJjAM1kLl4YVefIcHTwmimqojfxd6s9MZUoyKQgJq2KPjygnlYb
        R50DoawxJ04QaQqzpQDtzdbNHWjZxSlyFZT3IdIYKgOQjRa+ik+EERJQvt6Yiv3/6esISXvbVZdNz
        1Ete9CNA==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:5ec5:d4ff:fe95:cee6] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kWdk2-0003AL-BB; Sun, 25 Oct 2020 10:59:14 +0000
Date:   Sun, 25 Oct 2020 10:59:13 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH xtables-addons 3/3] pknock: pknlusr: add man-page.
Message-ID: <20201025105913.GB5964@azazel.net>
References: <20201022173006.635720-1-jeremy@azazel.net>
 <20201022173006.635720-4-jeremy@azazel.net>
 <2p319p4q-576n-34r9-6oqn-7n93p6892rr@vanv.qr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7ZAtKRhVyVSsbBD2"
Content-Disposition: inline
In-Reply-To: <2p319p4q-576n-34r9-6oqn-7n93p6892rr@vanv.qr>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:5ec5:d4ff:fe95:cee6
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-10-23, at 11:24:16 +0200, Jan Engelhardt wrote:
> On Thursday 2020-10-22 19:30, Jeremy Sowden wrote:
> > Since pknlusr is now being installed, let's give it a man-page.
>
> There's a lot of.. markup I have never seen before (and thus did not
> feel would be necessary).

First man-page I've written from scratch in roff.  I used the
groff_man(7) man-page as a reference.

> I pushed a shortened version; if anything should be different, please
> send more patches on top.

No problem with the man-page itself, but the patch to Makefile.am isn't
quite right.  Will fix in v2.

J.

--7ZAtKRhVyVSsbBD2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl+VWoAACgkQonv1GCHZ
79eQHQv/WIYSguwW4YPaWw9HGsaMNpHQ7U8FpEzN1z1Pm06lsFs8qVpqDGMZtrEq
714D0pplz/esI4PEnTM6k1QNXMz93jw81z3IzpYCEXie6g0UWKaVPsZpiqKpWCur
ULzb4gFaBWG80T81D+fwlAYtRGf5OFTCoWjXH0fAuuBkrV/TFNkP6Rlqq6VbpyG7
iePigCgSDzd3MzGesbn5GbGhSmBeERuFPK+Gi10VqQ8G74GG+VqXNSeIbSZrHZHw
r7AoV/ZXJnOtAN+h0ks08C/ZSSD3PhGqElO5N8g8j9ugsvDMAXCdRIpASLlSWk8S
CK+hblHhm63A6FvDdgZTbdebNPlgLSZRdwKBjveN6ulyh0CsfMNLw7wbN+uboB5O
wfmz9HncCEiKV6DtrsmAKDHyWFqk99DIUEw4IZvuRPhrzuKBKIXMiz8tGuFA1jGe
te3TfXTrOhlZhmTeSh5HLuAOPHsCAeP8slemeyVFNjjoEMpyciynM6R4jiyUCtIG
otTHZ1yw
=BJ0N
-----END PGP SIGNATURE-----

--7ZAtKRhVyVSsbBD2--
