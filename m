Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CA7CC6FD19
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 Mar 2023 17:51:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjCLRvR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 12 Mar 2023 13:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjCLRvQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Mar 2023 13:51:16 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8D738004
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Mar 2023 10:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BEqawCvK9D+PlILUL8/Bt0RJ5p3LOixqS3LL6Z/0htA=; b=Xevxho5PhpV7vGL6+8QSJGJyTg
        AyDz7aVhe+zTJUh6dTw2TP2dGB2YCUOQiT3jDGDgsNQYqwTy2+vX86ibCCWdUOtf+CVNg7Kg/mN8V
        wefIIRpIoZdLOGLr33v92fUtFNRGLPxCOjW+RkZbf4k/sdSqTDZB9O/AkcvqDc+sPfAK5s4X+Od7F
        DgCvIKjd8bgGmJStEQMgzsmO+geaKM5YjJOk+wyKwHuKVzbGIYaP8qYVgesf4zNud3u1+MFNuUmWw
        13OAgyZiRADWKnhzxm0Fqj5aAXy8tcnMNUdtJCqS7AKqKZYElmTwlj4X0rpg0GOYE7RNC9Xzn9ieo
        YqsxXaug==;
Received: from [2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] (helo=celephais.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pbPqi-005gW4-QA; Sun, 12 Mar 2023 17:51:12 +0000
Date:   Sun, 12 Mar 2023 17:51:11 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next] netfilter: nft_exthdr: add boolean DCCP option
 matching
Message-ID: <20230312175111.GH226246@celephais.dreamlands>
References: <20230312143714.158943-1-jeremy@azazel.net>
 <20230312151731.GA30453@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rbCjkO5i3NSxNMf6"
Content-Disposition: inline
In-Reply-To: <20230312151731.GA30453@breakpoint.cc>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--rbCjkO5i3NSxNMf6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-03-12, at 16:17:31 +0100, Florian Westphal wrote:
> Jeremy Sowden <jeremy@azazel.net> wrote:
> > The xt_dccp iptables module supports the matching of DCCP packets based
> > on the presence or absence of DCCP options.  Extend nft_exthdr to add
> > this functionality to nftables.
>=20
> Is DCCP even used in reality?

Now that you mentioned it, it doesn't seem to be very widely adopted. :)

J.

--rbCjkO5i3NSxNMf6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmQOEQcACgkQKYasCr3x
BA2HqQ//a5Vodb9lWi2iMml1wJxuX+/AyRLXXmoblLQY+SAk7Aa+tZjaTyCv5oqi
FnfYgDJ3DQsj314roJe2lNXro7pGC/X27Fm5GHJlAok/IkWGolUqvY/5OXtP07CE
76cbIMZXcDdpE15Neh52dqb3b3YMgDzFFZvjIQdYf7MU84i2jJFhMNJ8+7xH/Nla
+Nm3TfYZJTrCQyK1pW+9YY4x/fbdaUyyJp5eDEaOlfQp994xe4hIuhuQKBvgZm/u
8r8CTGXiPoMV0ZaeAFEfIsosdPXIw5LL0JgQlj9uwoRfO3ASw++/pgBYi3gu5hku
jN4r/csxtGdbV1ybamdbzMcCeOUozg5gL5hqKL0Y8jk4mFU5r/hbHO4jCWuEkRrJ
FBV4P2qJLPPv9DiOJOBCEisyDphJ2MAdDYMYyOoXAVyKxBSG89bvTdlSm4wTVW9e
Sj08/qB41eStqfn+awNfolhwuXt10LNQR/b0IOUpu4Uy92rGW/YmLshshBB5NIQY
8C8ClvC1rgwNo8o6r/RuvRpF2dXpoWrCQ6y1HuW1jac0ou21+NL5EKMeaoC9tOJo
ZKc9ej5xPueU5v26jdoNx6DjCWPUG2B/XbbzQaksaN8H2OjBTAPxA6tJc2HxwNF8
HzVwrOY8XGrWaOouzXr4QuDyT9XJoRRyYDhaAB6cZl0deohQSvE=
=bHTv
-----END PGP SIGNATURE-----

--rbCjkO5i3NSxNMf6--
