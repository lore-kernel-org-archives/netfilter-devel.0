Return-Path: <SRS0=RCn+=2A=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24975C43603
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Dec 2019 11:01:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAC0C20663
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Dec 2019 11:01:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="AJFitO90"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfLJLBF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Dec 2019 06:01:05 -0500
Received: from kadath.azazel.net ([81.187.231.250]:41486 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726915AbfLJLBF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Dec 2019 06:01:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kJShq3T+Gvzt2fxcCKZwSTa75ocXOBifrGWBzwSjmZk=; b=AJFitO90pL9DGZzF7vlXQg1i1w
        DBLCBgyU39sdzvNU0ILIFnnCHaxlq7ErWGMuZMnXdPOwZkVOQpn4A1rYY/q+SXR5TzJ68IeN46+OX
        n5HS+nK4hOAVGILdNPsznMD/wzI9GXgYV/SwuNMGzKuhkL+la2ySC6LxXmClgBi+lVNTH3dg3d4Fk
        vKoM9O3HTwJ6ITHY7ABbHHyL/MfR8+5P6R0RyUtROxeHPN4urv5Q2rZ+5Z73NhtPy3yKvQDXfSjYO
        1Dslt7bnio1sM9OjLxIkxyyfpzuaDxkBF1Jl3nYgVLxnQ4Ss7EbKKSbCxT/azuliO80WXiH7cUCbA
        fqEF7MrA==;
Received: from pnakotus.dreamlands ([192.168.96.5] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iedGH-0002xT-Tj; Tue, 10 Dec 2019 11:01:02 +0000
Date:   Tue, 10 Dec 2019 11:01:01 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: Re: [RFC PATCH nf-next] netfilter: conntrack: add support for
 storing DiffServ code-point as CT mark.
Message-ID: <20191210110100.GA5194@azazel.net>
References: <20191203160652.44396-1-ldir@darbyshire-bryant.me.uk>
 <20191209214208.852229-1-jeremy@azazel.net>
 <20191209224710.GI795@breakpoint.cc>
 <20191209232339.GA655861@azazel.net>
 <20191210012542.GJ795@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <20191210012542.GJ795@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 192.168.96.5
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-12-10, at 02:25:42 +0100, Florian Westphal wrote:
> Jeremy Sowden <jeremy@azazel.net> wrote:
> > > I have older patches that adds a 'typeof' keyword for set
> > > definitions, maybe it could be used for this casting too.
> >
> > These?
> >
> >   https://lore.kernel.org/netfilter-devel/20190816144241.11469-1-fw@strlen.de/
>
> Yes, still did not yet have time to catch up and implement what Pablo
> suggested though.

I'll take a look.

Thanks for the pointers, Florian.

J.

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl3vetkACgkQ0Z7UzfnX
9sM8jg//e1bg120Skkb2m4mIxVuuVmfRfkHhdokVJVQhPHhEooPvDSWbeJ6WCOxZ
R3CnZ/qtcgt4R4cYxJPIMghJqs515wvHcAKZyZkHXN1daW3gamjB2Ti9BQtc6hyo
zcZQX1FoQX12U3vu1oao50PN5PSkoB1SOsUHPq5Y5heAmSFxfXGIe9MQnZ3JJsQS
GoHrnqkXP9P/3pkNpPra/Wmuxg5iuwa5Mz3JKCaLi6+6wMQJ9uJ3N2VM/j+cSVGO
U9s9xu/q2gfP85Hu+/hapiKKJqtVhoDL/1AZLxseuARxp2NNLZTzYGk+TmoANWjS
WlYbfUAO4zOUUuRfDjFmJIGuFrI6eUffo1mvn7IUcBpr8CQSDumDq9OauS+D62iM
3Su6DnyGdrycRqt7BqXV20W3Jzf9by2K5RXR7UY3Tu1yTv1vV8kMpeLu46H2rD81
2rsHVid1LQLO55kcfpVIFTfHfJn54Isg2BfJqOKFPANvaLWAZQ+zT1wg0/NGEUCs
DP5FoPVgnEF2XtOgeeE+rHv9Bys3UkzyphTOrxFyxXZRXIVUlmul7ao+0B/HtgND
vPwYDhlxtU7UfNIKGYGyesRfFSOkPpNHORv+BrYRAsLrFuNLFKKYdhRhVoBEvpdp
cS5iBZxxCeHJWXXbiQyMeW6ZXvR4gRzsAGoLbrz8riwzb2C3Z88=
=V/MD
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
