Return-Path: <SRS0=01nl=3W=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 450F9C3524B
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 Feb 2020 22:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E92552067C
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 Feb 2020 22:27:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="GwKq2Gad"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgBBW1w (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 2 Feb 2020 17:27:52 -0500
Received: from kadath.azazel.net ([81.187.231.250]:60722 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbgBBW1w (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 2 Feb 2020 17:27:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7EcFJpLjupZ7VoCAkGWtJS9H9HYpOptE7IGjksdZOxk=; b=GwKq2GadO23Zxy54cQkdjcUL3g
        PvxOzBS4cg0nKRZAYYZzXwddK4sX20zFsl++x7elHn9sDB1nYM/OA3uUym3UlMTrdj+WW9vfd2Xw6
        A9o2KzjeEYE6RoEELaH50kBpIecVg8+CJMPXxrwM3GxsUXxhu0yO2Xen0tlvAr/c7Djwra47Ik6oS
        e+TAReNR8v2u36ifo7DVWR/KTDV7lJeDaivzU5X3lfyQGfm5LkMh9dwQV25pNcDcbyuuNXo5Hqxme
        lZitmVXQBozY3QNlOvlQJsTl+YLwHyl3Vwwk+mKp/CK4x05ocakK+BoJksK0NQVkAbHbZBmh7qzXQ
        L8UCoLIw==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iyNiZ-0005Hl-2k; Sun, 02 Feb 2020 22:27:51 +0000
Date:   Sun, 2 Feb 2020 22:28:12 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v3 0/9] bitwise shift support
Message-ID: <20200202222812.GC136286@azazel.net>
References: <20200119225710.222976-1-jeremy@azazel.net>
 <20200128190945.foy5so5ibqecfrqs@salvia>
 <20200201123223.GA136286@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7qSK/uQB79J36Y4o"
Content-Disposition: inline
In-Reply-To: <20200201123223.GA136286@azazel.net>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--7qSK/uQB79J36Y4o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-02-01, at 12:32:23 +0000, Jeremy Sowden wrote:
> On 2020-01-28, at 20:09:45 +0100, Pablo Neira Ayuso wrote:
> > On Sun, Jan 19, 2020 at 10:57:01PM +0000, Jeremy Sowden wrote:
> > > The kernel supports bitwise shift operations.  This patch-set adds
> > > the support to nft.  There are a few preliminary housekeeping
> > > patches.
> >
> > Actually, this batch goes in the direction of adding the basic
> > lshift/right support.
> >
> > # nft --debug=netlink add rule x y tcp dport set tcp dport lshift 1
> > ip x y
> >   [ meta load l4proto => reg 1 ]
> >   [ cmp eq reg 1 0x00000006 ]
> >   [ payload load 2b @ transport header + 2 => reg 1 ]
> >   [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
> >   [ bitwise reg 1 = ( reg 1 << 0x00000001 ) ]
> >   [ payload write reg 1 => 2b @ transport header + 2 csum_type 1
> > csum_off 16 csum_flags 0x0 ]
> >
> > I'm applying patches 1, 2, 3, 4, 7 and 8.
> >
> > Regarding patch 5, it would be good to restore the parens when
> > listing.
>
> Will do.

This is already handled by the same code that does it for the other
parenthesized expressions (src/expression.c, ll. 600ff.):

  static void binop_arg_print(const struct expr *op, const struct expr *arg,
                              struct output_ctx *octx)
  {
          bool prec = false;

          if (arg->etype == EXPR_BINOP &&
              expr_binop_precedence[op->op] != 0 &&
              expr_binop_precedence[op->op] < expr_binop_precedence[arg->op])
                  prec = 1;

          if (prec)
                  nft_print(octx, "(");
          expr_print(arg, octx);
          if (prec)
                  nft_print(octx, ")");
  }

> > Patch 6, I guess it will break something else. Did you run tests/py
> > to check this?
>
> I did and I got the same results before and after applying it.  I'll
> take another look.

Evaluation of the shift expression inserts a byte-order conversion if
necessary to enforce host endianness, so by changing it we just avoid
the addition of the extra operation.  I've rewritten the commit message.

> > Patch 9, I'm skipping until 5 and 6 are sorted out.

I've tweaked the shell test-cases to include a parenthesized expression,
and added some matching Python ones.

I'll send a new version out soon.

J.

--7qSK/uQB79J36Y4o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl43TPMACgkQonv1GCHZ
79euwgv7BvPwSI3POhgbgVhq/Sg2Nd/LDy4srbx/2vqVA5ZfomwuiVPIfdo+N98M
0veyTD896fUVIlToph7asBkT9d/HlmL3h/vjYBRxLnm/cHM1DTBWYOrJCjguVAwA
WGH8ADFLx/chBiTu9hnjryinka0G3v4CkM/4u1EbNUtLRTgxtDnEk1+FBekvDXaT
Xb9z3poXnke3JtykEX0H4xXDIaGZEUgYHjDOBahEPSl3iDnkPaGNlKfwQFm4ea/5
cUXGEHoeAWisXAT0KvmaP9uoFUrEK4p1uoL4fuza3KJwHfFECtXEYRrztRTEV4KP
krMandLm6y+/QUkfm+0GOVXUqZm/co2Z9g0Q8os35exnSkVeWypmH6/BExvkDKjj
1aMDgskmidC2LBwOJaDeQOIjf2+bct+EgS8VvTm4/h89E28yikyreQKsZLXH8bAO
ABPvXtPjm4i99kR3rBPvLhZqIntnWaVfh9vIFosgPHTg2ltTR32vMsbjf6jh4Rr5
Yeo2jneH
=r05z
-----END PGP SIGNATURE-----

--7qSK/uQB79J36Y4o--
