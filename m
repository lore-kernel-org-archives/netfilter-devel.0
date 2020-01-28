Return-Path: <SRS0=fFh5=3R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E585C33C9E
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jan 2020 11:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E38B24681
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jan 2020 11:31:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="M54mtn8h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgA1Lbl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Jan 2020 06:31:41 -0500
Received: from kadath.azazel.net ([81.187.231.250]:46118 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgA1Lbl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Jan 2020 06:31:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Ld7QNDKNXHEkvNpvCXvgA3WDUH1wY7Wd0OFsbnAD18s=; b=M54mtn8h41K/pBI/2fR4HbGxfs
        Xwqr5Pd0xwnVtDfrOkLWlKSiCSYtXo6NOy56vqLX3G5kHDJ+bV0Gy6uZbDQSfc7QjH4AYqMAwkD9l
        Tg0SIk5srZVNq+OSccdancsoFkqoGVZrHl3ul7UIOrqLV6Z6sZyORmEeazcswuigigiXuehL3diFd
        g1p++Z9an2OovRs++HTThlJ4i+tvJjytdlNH/85kq2dDf60EGdYPHno+B6ynbGalZWtxRw57sRkUn
        mD2tepRNhEEfBaoglZc6a+GdmRF1g3xc2Uu8MWbPdsvwB03sk9Kki/FmbGENKncXjhssXp4mdoaPB
        8WBmtKwA==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iwP5o-0008O9-Fc; Tue, 28 Jan 2020 11:31:40 +0000
Date:   Tue, 28 Jan 2020 11:31:39 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next v4 00/10] netfilter: nft_bitwise: shift support
Message-ID: <20200128113139.GA437225@azazel.net>
References: <20200115213216.77493-1-jeremy@azazel.net>
 <20200116144833.jeshvfqvjpbl6fez@salvia>
 <20200116145954.GC18463@azazel.net>
 <20200126111251.e4kncc54umrq7mea@salvia>
 <20200127111314.GA377617@azazel.net>
 <20200128100035.m4s54v5mfrlqvo4e@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <20200128100035.m4s54v5mfrlqvo4e@salvia>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-01-28, at 11:00:35 +0100, Pablo Neira Ayuso wrote:
> On Mon, Jan 27, 2020 at 11:13:14AM +0000, Jeremy Sowden wrote:
> > On 2020-01-26, at 12:12:51 +0100, Pablo Neira Ayuso wrote:
> > > I've been looking into (ab)using bitwise to implement add/sub. I
> > > would like to not add nft_arith for only this, and it seems to me
> > > much of your code can be reused.
> > >
> > > Do you think something like this would work?
> >
> > Absolutely.
> >
> > A couple of questions.  What's the use-case?
>
> inc/dec ip ttl field.

If it's just a simple addition or subtraction on one value, would
this make more sense?

        for (i = 0; i < words; i++) {
	        dst[i] = src[i] + delta;
	        delta = dst[i] < src[i] ? 1 : 0;
        }

> > I find the combination of applying the delta to every u32 and having
> > a carry curious.  Do you want to support bigendian arithmetic (i.e.,
> > carrying to the left) as well?
>
> Userspace should convert to host endianess before doing arithmetics.

Yes, but if the host is bigendian, the least significant bytes will be
on the right, and we need to carry to the left, don't we?

        for (i = words; i > 0; i--) {
	        dst[i - 1] = src[i - 1] + delta;
	        delta = dst[i - 1] < src[i - 1] ? 1 : 0;
        }

J.

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl4wG5QACgkQonv1GCHZ
79ckfAv/ZtESSNuUWh9oTXJQ/dbrDCT2b24UjUx4RWQJhdoFsMNJT6HmpDlfzwnp
feqG2KcdpBoyjvs9iTPmmT0iQJW3EeVXFdSAyzSuU37dThm7cn9krCytMxq52siH
3eGfxvqqzKZl3hZA/n1Ii2l7MU9+7lGTCuGfy75h7jE3Nkw1NSpqvhW4hb55ipjS
a3H1mblkNkq8+B8nqGGH9++MYM8+Ual16ISjxaFtz1c0mRjnN5pWeT/EOhNQp/he
EAoMgdpZEgvTdHhc0USJukW6NYnpyv4+P7LrzfqDzS3PRfaLT4b22lJms9fu6Clr
ODmx7HLnAHj4vpYTnqsf5IzttJbUASai5rqunKjGacC1C4h3axrhLVD+aKqi5/tC
MeBkSZ/9HDMSu16GDv0ajjs5cFNPvQe/L98QaInTrwRsEd8uzVOTn9jsuPez5JLH
/rpvKOBv3a2elad2UlTTny+GWGYoGr4bVfzO5mU4x0IoEW87UB/sYUSLu9EPDhxq
vdJa6GC6
=IfKI
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
