Return-Path: <SRS0=Xvwf=23=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EE27C32771
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 09:31:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 088672072C
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 09:31:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="ZRykI0h8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbgAFJba (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 04:31:30 -0500
Received: from kadath.azazel.net ([81.187.231.250]:35062 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgAFJba (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 04:31:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sgRcB8zulWIon1hxwG3MPy4mvSWUBQA/DTjS0Oh80t0=; b=ZRykI0h8WparegM/+89lVamjZx
        j5z21xPZ+8FagH9CcqXlESLkg1Aguo48AmampFUUD3NTzMhlwp0V6+WiRX8To4MHimcemzes5r1aw
        ye/koyuhBKcfAFpRfvaLz6RuOnyWogpRh5405hW8Ro/Akd/jt63FBBRBaX8HgmTMoCK8oCyATVVza
        TQswxWas3qR47QoOxirTfzqhLNGNrKfvyfpuIna8sucZz0CmmWj137iiyXHzu5LX+aZbAuMQ2jHtL
        rEuWL+WYn30YV3FhEgBBVfAdql6WDbI19Tde0d1Pc/pUw01IosSjMvPFoCAXWv9KejRk4duRNWsks
        h6z6Furw==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1ioOjQ-0003IW-Qz; Mon, 06 Jan 2020 09:31:28 +0000
Date:   Mon, 6 Jan 2020 09:31:38 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v2] evaluate: fix expr_set_context call for shift
 binops.
Message-ID: <20200106093138.GB615678@azazel.net>
References: <20191220190215.1743199-1-jeremy@azazel.net>
 <20191224231428.1972155-1-jeremy@azazel.net>
 <20200106092842.tp2pxubgmfcptthq@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="1LKvkjL3sHcu1TtY"
Content-Disposition: inline
In-Reply-To: <20200106092842.tp2pxubgmfcptthq@salvia>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-01-06, at 10:28:42 +0100, Pablo Neira Ayuso wrote:
> On Tue, Dec 24, 2019 at 11:14:28PM +0000, Jeremy Sowden wrote:
> > expr_evaluate_binop calls expr_set_context for shift expressions to
> > set the context data-type to `integer`.  This clobbers the
> > byte-order of the context, resulting in unexpected conversions to
> > NBO.  For example:
> >
> >   $ sudo nft flush ruleset
> >   $ sudo nft add table t
> >   $ sudo nft add chain t c '{ type filter hook output priority mangle; }'
> >   $ sudo nft add rule t c oif lo tcp dport ssh ct mark set '0x10 | 0xe'
> >   $ sudo nft add rule t c oif lo tcp dport ssh ct mark set '0xf << 1'
> >   $ sudo nft list table t
> >   table ip t {
> >           chain c {
> >                   type filter hook output priority mangle; policy accept;
> >                   oif "lo" tcp dport 22 ct mark set 0x0000001e
> >                   oif "lo" tcp dport 22 ct mark set 0x1e000000
> >           }
> >   }
> >
> > Replace it with a call to __expr_set_context in order to preserve host
> > endianness.
> >
> > Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> > ---
> >  src/evaluate.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > Change-log:
> >
> >   In v1, I just dropped the expr_set_context call; however, it is needed
> >   to ensure that the right operand has integer type.  Instead, I now
> >   change it to __expr_set_context in order to ensure that the byte-order
> >   is correct.
> >
> > diff --git a/src/evaluate.c b/src/evaluate.c
> > index a865902c0fc7..43637e1cf6c8 100644
> > --- a/src/evaluate.c
> > +++ b/src/evaluate.c
> > @@ -1145,7 +1145,8 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
> >  	left = op->left;
> >
> >  	if (op->op == OP_LSHIFT || op->op == OP_RSHIFT)
> > -		expr_set_context(&ctx->ectx, &integer_type, ctx->ectx.len);
> > +		__expr_set_context(&ctx->ectx, &integer_type,
> > +				   BYTEORDER_HOST_ENDIAN, ctx->ectx.len, 0);
>
> tests/py spews a few warnings after this patch.

I'll take a look.

Cheers.

J.

--1LKvkjL3sHcu1TtY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl4S/nIACgkQonv1GCHZ
79d2Xwv/VgNM064AZLnmOUfGkuxIeoEcXakzRdXLeTuX5UQBRR0Zzfqf00pUBLM7
T1rzd7ncIccWjo3tfnpkiAmQbbs6FHDx0LAIXvGNx7+vbPiKKAVzRAxI/1vBh0vL
mDVe/nRXCHPDQ14mUsQM5JS7Vm3j7UKMlhgr37MTdV5NddW/Q+RsgafCRFsTq+OS
3EIaM5bXB63o1ZNEo37dR3fTmkWrQAf7jg09xpKDx2Q8LlAMZ+BMAchrlo3uDu5b
eBwIPSGudtrzVEDGSToT6aKWfosNyg7HLGLVfGUDGXLC3v7WQlyD+AJZrnbB2w5h
/N90GFFg+cyD6J6tegNZMe9bkwV27FGEX2DtPTWVNT7mg8xaHafgABtWHWRcsAyr
m/4FNpQorDWYGYOY9kDD2Q1AQTfQuYx24pbgR5AMqvVfAB5FuhDciepsby2xmQ8A
eMLDoQWD0ZcVWruNzoDMqBbbANU2EuBYsDHhQFboSGHHSE+mtnLWkXJUyi5yVHfm
Ho2MQCn5
=++90
-----END PGP SIGNATURE-----

--1LKvkjL3sHcu1TtY--
