Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BDA1C2D0E4
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Nov 2020 15:09:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BA25223C7
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Nov 2020 15:09:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="iTW7F0ez"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgKOPJU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 Nov 2020 10:09:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbgKOPJT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Nov 2020 10:09:19 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782D6C0613D1
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2020 07:09:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0I/jgfG5tq2ms6Z7va5/Gg8d0iGTlI2LFNF5jY9+ffk=; b=iTW7F0ez4f0HGk+NYW2YzEYZsq
        ddFLiDpUkC/Q+CdVBLaypy1pkv3qoIDsR9vFjRnoFdoJ9Jr6SQaRUL8gV0+83lTTyTuAFBALlYMxN
        5usxe2yFnVS8RbVG6MJp9sTc6CiAOOjII5hJY2ZoWevJ00N6zWAzzW1w+QKXt3hew7L2r/jBUczAV
        pc9y6inSXBbrJWn8UGc8Av7UbUjDH6bCvly2lN5zRVJhjOtZL+hBPtgIguaaih58QblqLHhY8HCYI
        grtvHU32Crs2yKT/035v0OCpRi/FDcOsxfrMC0hbhdXKHFdCjpD+4Jx46l3f8yEKn/nNc6LZZRlvH
        xZqpkx3g==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:7c7a:91ff:fe7e:d268] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1keJeV-00023F-Nm; Sun, 15 Nov 2020 15:09:15 +0000
Date:   Sun, 15 Nov 2020 15:09:14 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnftnl 1/1] bitwise: improve formatting of registers in
 bitwise dumps.
Message-ID: <20201115150914.GB206012@azazel.net>
References: <20201114173605.244338-1-jeremy@azazel.net>
 <20201114173605.244338-2-jeremy@azazel.net>
 <20201115111654.GA24499@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="8P1HSweYDcXXzwPJ"
Content-Disposition: inline
In-Reply-To: <20201115111654.GA24499@salvia>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:7c7a:91ff:fe7e:d268
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--8P1HSweYDcXXzwPJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-11-15, at 12:16:54 +0100, Pablo Neira Ayuso wrote:
> On Sat, Nov 14, 2020 at 05:36:05PM +0000, Jeremy Sowden wrote:
> > Registers are formatted as 'reg %u' everywhere apart from in bitwise
> > expressions where they are formatted as 'reg=%u'.  Change bitwise to
> > match.
>
> LGTM.
>
> But this also needs an update for the nftables tests too, right?

Yup, I'll send it now.

J.

> Thanks.
>
> > Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> > ---
> >  src/expr/bitwise.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
> > index 9ea2f662b3e6..ba379a84485e 100644
> > --- a/src/expr/bitwise.c
> > +++ b/src/expr/bitwise.c
> > @@ -215,7 +215,7 @@ nftnl_expr_bitwise_snprintf_bool(char *buf, size_t size,
> >  {
> >  	int remain = size, offset = 0, ret;
> >
> > -	ret = snprintf(buf, remain, "reg %u = (reg=%u & ",
> > +	ret = snprintf(buf, remain, "reg %u = ( reg %u & ",
> >  		       bitwise->dreg, bitwise->sreg);
> >  	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
> >
> > --
> > 2.29.2
> >
>

--8P1HSweYDcXXzwPJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAl+xRJMACgkQKYasCr3x
BA0TkA/+P5mEjey4trLoRB08LJmo2C1ZMcDFyIKLG5eQoWD0QuossfxhQNNjJNFD
H4aGPhDqPVrF4zPY0dEZ0KRulwHU3Ib6rF2/2auENrXLcjlKOEFSwCg+sfnxJnF7
Lw7khZfcYP5K7jDKL53phMfM1nhuvmss4PjM6jM2c8ZBBwBGhch3kmAltL5zwaFp
ssMhFQ2jxcY3AglkMyoW6QcBe70zZCioC3DxQTVMDJh7QTbIV3mOyV9xarKdEJBN
pY3SIfNZ+UgvvPO7dpRbgUg9mcbuJ+M3MUMorAx7kI5MSuvWllBvm6b+ottvxVsZ
NBn5BXkObp8ibg6Dlgnz8jwmuXAHUsgW0tMX6yEqGWI9zextmKJGjC8KZjTkoGV3
S4pOHrZgmeA/UoQRbjrKirYYG3L9S7i5ijFsOqXZeUfyd7VuJSZMyRI8QEmZ756r
DQFU6pimFzdw/oG4hVqMHeBFeFMKISIfBTD/SXW1pAW+B89V4SRxpffRPbAQl+9N
iHdj0/6zeEGo3S2wHxol888dLMxMvTBniVe8I9klLfwS1qn/g/vHsFXiJVr/Vnv3
FOSxid8CrnvuX70ffEZKsboMAZOUBzXjYGE23SHV79DigPN4Fjv88ZLwsVPsAAhB
/LfkJWnQ+U/It+Ica2djibPywsyFhIMhrwS13R5IDb5wVnBSScI=
=3790
-----END PGP SIGNATURE-----

--8P1HSweYDcXXzwPJ--
