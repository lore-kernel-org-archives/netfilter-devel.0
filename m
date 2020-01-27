Return-Path: <SRS0=xF+Z=3Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2232C2D0DB
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jan 2020 11:57:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BAC920716
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jan 2020 11:57:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="sxytG0eK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730167AbgA0L5l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Jan 2020 06:57:41 -0500
Received: from kadath.azazel.net ([81.187.231.250]:48622 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729747AbgA0L5k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Jan 2020 06:57:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DJmSZ2PHA39rCBbD5mTX6g+kZde9p1GdnVORlnW9pKI=; b=sxytG0eKb46K4/v/hou1L5VOFy
        MMGnBRu0CQ9UQw2/h0lFepMrVlGIEXjnX5Zjta787xbq3jOuRuIaNGycDtcx8lLEmLHDvmvg6qXEx
        n2lg1QgY7adNS6vdaJL84d5x5pq7YlNLDCQpAFImfFTur7HubuhHxK0q8fkxpo1Z4+GbP3wjKUw1q
        wc1rZXbmCKDpXrr1ZUCmJueYGIjnNgaj8pqATVzH18HbPGjnujhauYY8iY8OTj2ra7plsVfUDbblJ
        +esaMVk4G+ym29vVUjFX1rk5UVBWFpOODrV2MTkENk0nh7jDfpskXf2yJuxuxWg1sE/sbs2f2MRAF
        Sx27WkhQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iw2Ku-0006UQ-9P; Mon, 27 Jan 2020 11:13:44 +0000
Date:   Mon, 27 Jan 2020 11:13:43 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] evaluate: don't eval unary arguments.
Message-ID: <20200127111343.GB377617@azazel.net>
References: <20200119181203.60884-1-jeremy@azazel.net>
 <20200127093304.pqqvrxgyzveemert@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Bn2rw/3z4jIqBvZU"
Content-Disposition: inline
In-Reply-To: <20200127093304.pqqvrxgyzveemert@salvia>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--Bn2rw/3z4jIqBvZU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-01-27, at 10:33:04 +0100, Pablo Neira Ayuso wrote:
> On Sun, Jan 19, 2020 at 06:12:03PM +0000, Jeremy Sowden wrote:
> > When a unary expression is inserted to implement a byte-order
> > conversion, the expression being converted has already been
> > evaluated and so expr_evaluate_unary doesn't need to do so.  For
> > most types of expression, the double evaluation doesn't matter since
> > evaluation is idempotent.  However, in the case of payload
> > expressions which are munged during evaluation, it can cause
> > unexpected errors:
> >
> >   # nft add table ip t
> >   # nft add chain ip t c '{ type filter hook input priority filter; }'
> >   # nft add rule ip t c ip dscp set 'ip dscp | 0x10'
> >   Error: Value 252 exceeds valid range 0-63
> >   add rule ip t c ip dscp set ip dscp | 0x10
> >                               ^^^^^^^
>
> I'm still hitting this after applying this patch.
>
> nft add rule ip t c ip dscp set ip dscp or 0x10
> Error: Value 252 exceeds valid range 0-63
> add rule ip t c ip dscp set ip dscp or 0x10
>                             ^^^^^^
> Probably problem is somewhere else? I'm not sure why we can assume
> here that the argument of the unary expression should not be
> evaluated.

I'll take another look.

J.

--Bn2rw/3z4jIqBvZU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl4uxeYACgkQonv1GCHZ
79ePZgv/UVU6xn1BqM37ymWsMfjMzyk2OMFjt5K2bRusju9/leThEASa3y3S/T39
p5Wq/rR71kEAirfYdjzYoyXuPhJ5/NrgpNjR/dymgmRr/QigZ1vZ9BaQN8L9LF1x
mhi8LgcNqMVnVrkEAeKUsbMvsl1gcFwnGuyQy7LtJ9Xt4XiVtkv3dQvZJJjPAfCS
GQR7D0Ce+PC/ll4+fHUPT4NxQvwfQsl5vpRBqHU9RRpLeSxu5wEhPNWurVBhDJTy
8X775zK8iWAyg3erlU4yenSCUG++tF78ZDeyP3ZHW6nUpuHAStpumOG7hI5lkbEP
0jORVL6KbON3z5negEuVDYDeQhPBQJvFCmY2eguuErZtgjBwvOtgvqj6OIBJh4jW
Q1uqQwxvOwbLrRfpoV9/Rami3B4G5p3W1vb/FdmE2ZAKugh4j32d7gGwD6j2FlkX
1sjPrvK+wOSGhVCLGjIQbsLnns4mbNsqIFjXNW9MFKjyGHyw6UdjRDVFNmo9M+71
W+XgIJcF
=yGe5
-----END PGP SIGNATURE-----

--Bn2rw/3z4jIqBvZU--
