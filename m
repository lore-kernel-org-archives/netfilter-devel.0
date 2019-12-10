Return-Path: <SRS0=RCn+=2A=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B132C43603
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Dec 2019 19:52:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F17902077B
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Dec 2019 19:52:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="Zr5l1lUh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfLJTwN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Dec 2019 14:52:13 -0500
Received: from kadath.azazel.net ([81.187.231.250]:34958 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfLJTwN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Dec 2019 14:52:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=N+uw2fMw1+u87tb5mUqsxkxF/6AePdr4Oyjb1I8i3po=; b=Zr5l1lUhH1MeG0BJ7gSL7bTNrz
        zl2fz2q4degcU33vHAYo7p3VxO24pweU4dI6GLk0wUzvR6sc0YYldPnyIYUEdhACm2/Q0DFHY03h9
        3HL2IOsskj8hiWGpqkXEaKzfwoG5JI8EKoNLpbTgRwjNQQGOfupXG9cCsRMmMqQVfRwhw0Smg/lrW
        kCDlguFhnI+rqXOZnNHBvzwk8vmouXqTv/IrIHDiVQdUCITl334IkEVTLe2f1RAncmmkv5rDCS7aj
        peBd2Oyj23yE2iAHr+bT954RC2Qc0WvPyX6EV5s6BBPYAKyVKUvyT69X4kaixrVRtBg9N+1Bp76VG
        VAttspgQ==;
Received: from ec2-34-241-25-124.eu-west-1.compute.amazonaws.com ([34.241.25.124] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1ielYH-0007En-QV; Tue, 10 Dec 2019 19:52:09 +0000
Date:   Tue, 10 Dec 2019 19:52:08 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: Re: [RFC PATCH nf-next] netfilter: conntrack: add support for
 storing DiffServ code-point as CT mark.
Message-ID: <20191210195208.GA703079@azazel.net>
References: <20191203160652.44396-1-ldir@darbyshire-bryant.me.uk>
 <20191209214208.852229-1-jeremy@azazel.net>
 <20191209224710.GI795@breakpoint.cc>
 <20191209232339.GA655861@azazel.net>
 <20191210012542.GJ795@breakpoint.cc>
 <20191210110100.GA5194@azazel.net>
 <20191210113234.GK795@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <20191210113234.GK795@breakpoint.cc>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-SA-Exim-Connect-IP: 34.241.25.124
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-12-10, at 12:32:34 +0100, Florian Westphal wrote:
> Jeremy Sowden <jeremy@azazel.net> wrote:
> > On 2019-12-10, at 02:25:42 +0100, Florian Westphal wrote:
> > > Jeremy Sowden <jeremy@azazel.net> wrote:
> > > > > I have older patches that adds a 'typeof' keyword for set
> > > > > definitions, maybe it could be used for this casting too.
> > > >
> > > > These?
> > > >
> > > >   https://lore.kernel.org/netfilter-devel/20190816144241.11469-1-fw@strlen.de/
> > >
> > > Yes, still did not yet have time to catch up and implement what Pablo
> > > suggested though.
> >
> > I'll take a look.
>
> No need, I plan to resurrect this work soon.
> If you really want to have a stab at it, let me know and I will rebase
> what I have locally and push it out to a scratch repo for you.

I'll concentrate on the ct mark stuff.

J.

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl3v91cACgkQ0Z7UzfnX
9sN2FQ//TjX/2FZw6B8jfyT9ZNRgYeP5WQYV6OG51lc9m3GeH8fChla/8DTpdfRb
5G/HCf8n+aUf2P+zwzjGhvOF3w57UGT6U+oA1Li1qpk1vv74l//8LccGc/ms4CKg
REkiUVGfIUjw0RKeu6WbZVNnq83mCGOBokGRf4pR0qvasevGRoJ/bJdJE5kU4uBR
v4MuhloEuSk7e82bYPIXv2s8XxcG/PTFpj20qvhJR1yRaf/wML+q5N59O50jQgo5
U8xMMxP9keMqidF1L1TH1dFK8z/ySONK57rmu45Q4Tl3DvdJDEVK/Y9BRtEnVd8c
rv6alb0w9OyYGUfBffm4vzrwi0dhJfa5KbRcbMIwQyRifONYLoFT67QtVFk5MQCQ
XPhYgDC6A8YSObuJZizA+qwfuHcEEqzZShjogriauGT1dWHzl1ILtzy4PZthjJHP
BJUkhuF3v9piQneYs2UIG1uxME65EuIxIxwEJQyoxe6lpm/0wUOnup/pbjpJVQVU
+gexpKUAcRoRRHBuru082r8tzCG7sl4DxQVNBAwebgOb+aT+Zf3lPAEY2ZoM/QE1
QUtie/a2nhxoshZUOY4ujvykJh8jxDEeRwdu3dwVRqAIhgfvE9Oz7x/nwq0Y/gUm
3ewND87PODcUC1aCyxssoMfZGSLyIzcofG0CdNYmhO10n3qZpvA=
=/f6+
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
