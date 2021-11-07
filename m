Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EEE2C433F5
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Nov 2021 16:07:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74D3E61356
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Nov 2021 16:07:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234767AbhKGQKT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 7 Nov 2021 11:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233295AbhKGQKS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 Nov 2021 11:10:18 -0500
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B595DC061570
        for <netfilter-devel@vger.kernel.org>; Sun,  7 Nov 2021 08:07:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YGfzPJa9t95V0gVf/PXweUbOognS7xqqy3Wqx6Isan4=; b=VkTHBxFneMUSO33cDVjmn9DLN2
        CkUMwV5mHWHqk+4WukebBCQrg89Emzm3UqXrUKWAiEhVLRAic5BJvrgbMs8IvxAuNBi99l1STcM/z
        MXHlXEEEKTZ5G7MFzgxgcEI3WNA+RanFIyyidxWgOZeMeF2zqoF0NhwZ1d7/MWTpWahWnwVfT0i5E
        n3ZjvpZgRpRY9UFuaFe5bE/yf0qTSEOgJHPuIOBD3TrF99WMx1te0oUeqEQ7bN+FrxwW28CkfJ6pQ
        i3NdIFjUG+cGNnVtGaDZoEhn9U8lqkTxIY61Axiv8qJOZcm5Tjhr4M6cWxgVcfkTS0e28jExV58qg
        dPqk2PaA==;
Received: from ec2-18-200-185-153.eu-west-1.compute.amazonaws.com ([18.200.185.153] helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjkhg-005khQ-Bl; Sun, 07 Nov 2021 16:07:32 +0000
Date:   Sun, 7 Nov 2021 16:07:27 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] Unbreak xtables-translate
Message-ID: <YYf5vzKUJB3bgQpV@azazel.net>
References: <20211106204544.13136-1-phil@nwl.cc>
 <YYf41EwPa8YBKNpY@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="QMMItw3X+Eu31K7H"
Content-Disposition: inline
In-Reply-To: <YYf41EwPa8YBKNpY@azazel.net>
X-SA-Exim-Connect-IP: 18.200.185.153
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--QMMItw3X+Eu31K7H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-11-07, at 16:03:38 +0000, Jeremy Sowden wrote:
> On 2021-11-06, at 21:45:44 +0100, Phil Sutter wrote:
> > Fixed commit broke xtables-translate which still relied upon
> > do_parse() to properly initialize the passed iptables_command_state
> > reference. To allow for callers to preset fields, this doesn't
> > happen anymore so do_command_xlate() has to initialize itself.
> > Otherwise garbage from stack is read leading to segfaults and
> > program aborts.
> >
> > Although init_cs callback is used by arptables only and
> > arptables-translate has not been implemented, do call it if set just
> > to avoid future issues.
> >
> > Fixes: cfdda18044d81 ("nft-shared: Introduce init_cs family ops callback")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  iptables/xtables-translate.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
> > index 086b85d2f9cef..e2948c5009dd6 100644
> > --- a/iptables/xtables-translate.c
> > +++ b/iptables/xtables-translate.c
> > @@ -253,11 +253,18 @@ static int do_command_xlate(struct nft_handle *h, int argc, char *argv[],
> >  		.restore	= restore,
> >  		.xlate		= true,
> >  	};
> > -	struct iptables_command_state cs;
> > +	struct iptables_command_state cs = {
> > +		.jumpto = "",
> > +		.argv = argv,
> > +	};
>
> No need to initialize .jumpto explicitly: initializing .argv will
> zero-initialize all the other members.

Apologies, I'm talking nonsense: .jumpto is a pointer, not an array.
Ignore me. :)

> > +
> >  	struct xtables_args args = {
> >  		.family = h->family,
> >  	};
> >
> > +	if (h->ops->init_cs)
> > +		h->ops->init_cs(&cs);
> > +
> >  	do_parse(h, argc, argv, &p, &cs, &args);
> >
> >  	cs.restore = restore;
> > --
> > 2.33.0
> >
> >



--QMMItw3X+Eu31K7H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmGH+b8ACgkQKYasCr3x
BA2ogxAAnT378E3qmKvjCIbA0du5W2jD7XsAPb52rFcMEtKQTxVc4xfuWkkHr4CH
JZxXEbl6EmZa9VMvDeoiT3D5OcCh7Tz+x0U9Ji9/w6iecXSNi6uJc6mSyuovSgYf
HJ8iXIMMoIS9ICx6icMqaK8wcKXsNR591jM0fbyY2+MBPZubpcQ0lnwytWjCMu5w
Fv0FF+X9F8RNITq4WpH+878uKndNZtEaDuVSbO/14hTdR8N2RoHzm9Ck5ydcS5lV
4buqIARavSrjaiu6CFMWQV6H3hQU1BdggfjxpYedE2D4fN/WiD3sNcVRB76u+UTF
DLcWLIsMdu7qOuoF0eMMpUWc9FZoCz6Lt/BSnNRTCymI/nhEHvSSeDxgH8qrZLVU
lvfBP8++3/aFLrd3O0FH4ViQ5eEnGNDSTnqBHM9Fz90+KyVmJrA+zHBNrJmunIbj
C4/8BaY7x6qbmkfD0R1sLFf7KJCEokZJa29kGWJ68DtA6wuZR8phRpwpMQXoAsy/
zTkrgxWYmDltH77bUyan81Wtc+NKl6Wrpa2v44S9h3cASDkrHKxA1+7vXBe0vI0K
oogllKarv1OX7uxH6mXj5slD1/Pgt8lyxAdngTuUuqre6G3r/j1imJNZROpmRf/d
5oZFrqZIrQDk0307T/MhlB1qBf5iYPgOrAf1AhWeGH9mWvYt28E=
=R40L
-----END PGP SIGNATURE-----

--QMMItw3X+Eu31K7H--
