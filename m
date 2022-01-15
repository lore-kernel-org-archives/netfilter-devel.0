Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0474AC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Jan 2022 17:09:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbiAORJv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 15 Jan 2022 12:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiAORJv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Jan 2022 12:09:51 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85B8C061574
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Jan 2022 09:09:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1MHU/pWLdA9s6EW8eiOIEtWOUG7bRDMzRcJKykHti2I=; b=B03QIBCLsL31yPIOftJGHMNpK4
        /11f8luU2SIWwElOxOA9G5GpUkIk4WGpq8icsaYiRT13Q2ilwTWwFIsL/pIa0VtLJjdB5YKUKGbVe
        QB6UKwyGjPNWQW0fkmqoF8BM8cRgucPvPmPIFBD9SQUUpefgjiZEiQZRknfE2AgRL4FGiuwSinPW9
        bkv0wQr/7ZnJei8MlWIi3fP0d4y4/JviLhUtVDELI60OggwwtmVN8ocU25P+DwlKqZl1jmDs0oV/6
        AW3cw+lP/T5uReyXpNRCr56Y1a+U/gybTdDzp7QD2y3j/doCIHiU0iSTJi53dk1vUyAJKeT5WxoGU
        81pJ6rZA==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1n8mYm-008NE6-7p; Sat, 15 Jan 2022 17:09:48 +0000
Date:   Sat, 15 Jan 2022 17:09:47 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH 08/11] src: add a helper that returns a payload
 dependency for a particular base
Message-ID: <YeL/29gSEOtXieCw@azazel.net>
References: <20211221193657.430866-1-jeremy@azazel.net>
 <20211221193657.430866-9-jeremy@azazel.net>
 <YeL62HGr/mHp37pe@strlen.de>
 <YeL84lhx/hxfGAg3@azazel.net>
 <YeL/NJzFHxsUqAas@azazel.net>
 <20220115170901.GA25474@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="87INmM+5sBVFZTx8"
Content-Disposition: inline
In-Reply-To: <20220115170901.GA25474@breakpoint.cc>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--87INmM+5sBVFZTx8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2022-01-15, at 18:09:01 +0100, Florian Westphal wrote:
> Jeremy Sowden <jeremy@azazel.net> wrote:
> > On 2022-01-15, at 16:57:07 +0000, Jeremy Sowden wrote:
> > > On 2022-01-15, at 17:48:24 +0100, Florian Westphal wrote:
> > > > Jeremy Sowden <jeremy@azazel.net> wrote:
> > > > > Currently, with only one base and dependency stored this is
> > > > > superfluous, but it will become more useful when the next
> > > > > commit adds support for storing a payload for every base.
> > > >
> > > > > +	dep = payload_dependency_get(ctx, PROTO_BASE_NETWORK_HDR)->expr;
> > > >
> > > > This new helper can return NULL, would you mind reworking this
> > > > to add error checks here?
> > >
> > > Yup.
> >
> > Actually, let me provide a bit more context:
> >
> >   @@ -2060,11 +2060,13 @@ static bool meta_may_dependency_kill(struct payload_dep_ctx *ctx,
> >                                        const struct expr *expr)
> >    {
> >           uint8_t l4proto, nfproto = NFPROTO_UNSPEC;
> >   -       struct expr *dep = ctx->pdep->expr;
> >   +       struct expr *dep;
> >
> >           if (ctx->pbase != PROTO_BASE_NETWORK_HDR)
> >                   return true;
> >
> >   +       dep = payload_dependency_get(ctx, PROTO_BASE_NETWORK_HDR)->expr;
> >   +
> >
> > We check that there is a PROTO_BASE_NETWORK_HDR dependency
> > immediately before calling the helper.
>
> Perhaps remove the check?
>
> bla()->foo looks weird, esp. given bla() last line is "return NULL".

Righto.

J.

--87INmM+5sBVFZTx8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmHi/9sACgkQKYasCr3x
BA3v/xAAsbcJtpu8qMpyJ0z9vNj8dUB1/XArpKbNYV41V2vObO82/MmAvqKHH2wX
b0cSquiSLX9oAI/6VzHAoI/tNctyGZ81IPHC2Yl+phbP79Dc5s63xbykht93h7Xw
GUfwySXkP4pGwlD/9B7pDyoAp/c923YauMVSvh2gzgoaXdR1fwgqISCaBrD10frA
7MYBR36HmxtNc5sqyFRRFJBNseBNDpVG1srxQ2F/Z50HEdOJhuZPOK/MAnXYr+Rh
rLEdzaGLy5kjVTlhYyqUp+T1nx13F1e5m1gMnbbe97WZQ9dgybeezs2AdcVSL06m
+TzgTEDxF9HKEcuNS5iAmsbod+pCoNK0Km16oM+AtbeeJaP6oA7qfIGuCsUI+2g8
MOnWVMiKgK9gtriRg+wp99v4yskuhJ/iVx+6fUopgIgBZBVxV7Gq3FA2qlWARdzE
X0LP1OBqp58i2hlt5X7JbCsBRgej/lBZbOCGnoKqt302QGat5RgxxOP/78xMLysS
Qv2IHT9vSoWsgZHEjo/TATenMptg4k+e8iS897ESq1F9XwGqkR+zz4uX4PejzTFW
9g3YWtolLsgfyjSSnc0RzYo/qf0m4ClixNAZLeEvM668Fp40X6fxGQSIyStoxYvF
jVBWulk0mzOqYVJeQ5BGjDJKUVSdHzuGxSmYBC4lh7rDhKzxDXw=
=NFK4
-----END PGP SIGNATURE-----

--87INmM+5sBVFZTx8--
