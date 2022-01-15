Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48D6AC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Jan 2022 17:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbiAORHD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 15 Jan 2022 12:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiAORHD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Jan 2022 12:07:03 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CA3C061574
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Jan 2022 09:07:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FgVBwapRsaiXpBLRAkHIrLjor0mJDKD1wwa9Pr8h7qY=; b=ldRQHRkg9E6M4TKLJ5QYS0HNQ4
        RHt9c4mFx8T4wKEcHJDCyQTOWasZQ83sCxDEHj/UVbHrkm1B1NGTyPqAXSHh7vbIvb7aZvLqMYUvx
        wutdJGOrTh2pGP5gJ24HxPj55xfHe+/lZIXBIOmZMTUhwT+80Bpy5RKjFqVrxAQatR9ddIv6/RnpQ
        OGcedE9bEyutNcJ03mfPKAq8+nfAVkJamgXg5q1bLgVW2jt6S0E6vDX4patiZwkg1D//f5u5aTDRI
        WCGt4oNsb/EnKceyaaTv/ZRfMfti3AXsSMD94EL/+t8/9KHHglFgQ0ggZFqK210lcqex65o2zKXTr
        clZmPIeA==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1n8mW5-008NCC-8j; Sat, 15 Jan 2022 17:07:01 +0000
Date:   Sat, 15 Jan 2022 17:07:00 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH 08/11] src: add a helper that returns a payload
 dependency for a particular base
Message-ID: <YeL/NJzFHxsUqAas@azazel.net>
References: <20211221193657.430866-1-jeremy@azazel.net>
 <20211221193657.430866-9-jeremy@azazel.net>
 <YeL62HGr/mHp37pe@strlen.de>
 <YeL84lhx/hxfGAg3@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vjU7gkYWDpvUKl6L"
Content-Disposition: inline
In-Reply-To: <YeL84lhx/hxfGAg3@azazel.net>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--vjU7gkYWDpvUKl6L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2022-01-15, at 16:57:07 +0000, Jeremy Sowden wrote:
> On 2022-01-15, at 17:48:24 +0100, Florian Westphal wrote:
> > Jeremy Sowden <jeremy@azazel.net> wrote:
> > > Currently, with only one base and dependency stored this is
> > > superfluous, but it will become more useful when the next commit
> > > adds support for storing a payload for every base.
> >
> > > +	dep = payload_dependency_get(ctx, PROTO_BASE_NETWORK_HDR)->expr;
> >
> > This new helper can return NULL, would you mind reworking this to
> > add error checks here?
>
> Yup.

Actually, let me provide a bit more context:

  @@ -2060,11 +2060,13 @@ static bool meta_may_dependency_kill(struct payload_dep_ctx *ctx,
                                       const struct expr *expr)
   {
          uint8_t l4proto, nfproto = NFPROTO_UNSPEC;
  -       struct expr *dep = ctx->pdep->expr;
  +       struct expr *dep;

          if (ctx->pbase != PROTO_BASE_NETWORK_HDR)
                  return true;

  +       dep = payload_dependency_get(ctx, PROTO_BASE_NETWORK_HDR)->expr;
  +

We check that there is a PROTO_BASE_NETWORK_HDR dependency immediately
before calling the helper.

J.

--vjU7gkYWDpvUKl6L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmHi/zQACgkQKYasCr3x
BA34iw//aT+8GEbv9D/M1we0Ju/bqKHtoScc9898w7X+ylDmCYHPP1stw7IiDTw8
DJDKzyfaQ967XUI/5u6oglXXyDPG8EueDFgT2SJBNR8OyGGfk8qNgUvtJEuN4cWh
Dg3mN+hfLZIDP2Z062/QHt2LyIr+gu6zL7d4Zp6aFQG93jKFBfpK/avPtQzwi05s
H/Zrsl2l/YLq9x79hOmi/BXTYGHE51P+cl9QIMJrT5BWaLBZar9kUZAZ+4AWrcwt
MWtpHCxgQ9tq9H/9ZD3GFNiCL5X20U3jMu/zy14C2FW/yDjNyFsEXFPLuO3bXVjy
NsKHrnQ+GGkQ4Gd3ohp/ZnIng/vgcAjgs91Zhxa1XNhbs64VUA6G04U4Ld1bvoj1
GWc3hsOjzEF9zG4oZR7GHnmfvDtVrD+mSoFBBa0q2qWYuI4RQwItY0fWC2UC/+WA
4JLWbKbTGp51pWGRlqy7TBBxsAir51xl3KwflwqiHmyG5wevi9RXKjr4QzQ8jeSN
3wBP/sEboR8dGf5SVwdtbCjD1RzIXXWuv5CI8cMysXM2RBvHOcqxHXYgKrfQpHEd
nBInBMExYacVQiSzrdwpRjcdbn/8OmOktDcSnkk2XwZuksYSh1gogLmTIw+NQ0B+
3n+6gfGe3Erd5BjqEhoaAwb0OEWnl0/3Za0WxYkXHxCqdJXdS6M=
=AiQm
-----END PGP SIGNATURE-----

--vjU7gkYWDpvUKl6L--
