Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0BEBC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 09:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B040A60D42
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 09:28:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238630AbhIMJaA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 05:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238597AbhIMJ37 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 05:29:59 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A2BC061574
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Sep 2021 02:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=m1565KDf+Hie8W0fpZkcWi3wb+opHxQ2MlVNf7prtqM=; b=At/5ur1cx3DtN3A2//m9ejcTtW
        HwlETvwjlAVYX8MZVpzoPxLpaVWAaTQnY0hyjlTglav7JbmWubCWZ9C1S2Vf3rgf4xgSkH0fyQSws
        9K0tqf1WUoK+z774qxqc0WVhm9fUoZptftiemUX5Y0ylgqc2Ys30HIQGYDIKlCjTimxynyBHRIpGb
        FmRp7R4dJQQbufLnuHBvLc/QTDAZBcyMkmidrcgXs28sB0H894UFwJ9egQq/rAjHE3LG6HpDzn7Ai
        F3TR9Sy2KL+DWmZVmHyK1ON6O3S895xyGwRqGKmd3n/ErrFmp9f7P2PMF0YcWkkijjQTzhVAN28IN
        yfaBPm5A==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mPiGV-00GM42-Tb; Mon, 13 Sep 2021 10:28:39 +0100
Date:   Mon, 13 Sep 2021 10:28:38 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf] netfilter: ip6_tables: zero-initialize fragment offset
Message-ID: <YT8ZxmPcpm7lJpQW@azazel.net>
References: <20210912212433.45389-1-jeremy@azazel.net>
 <20210912233900.GN23554@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="DkpZiPJy5Bce0/Vt"
Content-Disposition: inline
In-Reply-To: <20210912233900.GN23554@breakpoint.cc>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--DkpZiPJy5Bce0/Vt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-09-13, at 01:39:00 +0200, Florian Westphal wrote:
> Jeremy Sowden <jeremy@azazel.net> wrote:
> > ip6tables only sets the `IP6T_F_PROTO` flag on a rule if a protocol
> > is specified (`-p tcp`, for example).  However, if the flag is not
> > set, `ip6_packet_match` doesn't call `ipv6_find_hdr` for the skb, in
> > which case the fragment offset is left uninitialized and a garbage
> > value is passed to each matcher.
>
> Fixes: f7108a20dee44 ("netfilter: xtables: move extension arguments into compound structure (1/6)"
> Reviewed-by: Florian Westphal <fw@strlen.de>

Thanks, Florian.

J.

--DkpZiPJy5Bce0/Vt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmE/Gb8ACgkQKYasCr3x
BA3+RQ//RvTZzkR32KDWmm4c0sXL+cIeSm/MvwQ9J80+/CPZEIa56IO+c9LWKzBi
IGayisi54jvytCIZeD989Qqe3adPYFM90sEZR2vRmrEW87jKJxtm0G9x8HQaeGFr
eidb8Hzs514r402Jw9KR/I4EnLq0i1binDFHo2pjwNJ+noW0ANPMXyYSOA+BR92D
bVdu5VQhhLwEa2rYoOzbMrKJ/Pb00NQOz0WxHp+OJ37VyItog9e26pTKVYMnwAE2
1f3UKTB7HLD3P1Ea+lrX3cG+WyuGIBXEGiiB14F18eGoMo1bD9HGtg5jrS2ZCBA+
qZ4v6q7X5aa9sPBiqM0wSroxnTTlhLoTALNNnEkKfLiVgEE3UcCjPI1dwOUyf2M+
RK5YraX484gGyY6FoR6MGwyLhdrU5NPnoiQToKmRrDvS0pwOLZPj8UH5mDRhyXDd
/nwhw7LfbQqnJAsYeE7O/4u5CTqqvkbSBqcXs4cnoLvjRNqCYplBEdu1bV8lkKF7
oYObslLkIRp8H7d8XM9gcIu3KPljf7rLeqz1B4EP2EdCr6Gdi33MWfpas7G3ebAm
JSJ5wR3JBbm7XS5Q2uZIt4NwbmqlkhjwZHw13aililbicFJQPxA/wDT8p7IBJtN4
SsiUOFPa+jAsSqEKpmVw9UGNnn4rOtryXpQXlRT8nOKCuoXFWwE=
=/nXw
-----END PGP SIGNATURE-----

--DkpZiPJy5Bce0/Vt--
