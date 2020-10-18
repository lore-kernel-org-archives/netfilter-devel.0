Return-Path: <SRS0=5q/u=DZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B52C433DF
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Oct 2020 15:32:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46CEC21D7F
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Oct 2020 15:32:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="OaP2IUwm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbgJRPcx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 18 Oct 2020 11:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbgJRPcw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Oct 2020 11:32:52 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA81C061755
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Oct 2020 08:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FZO2HZt8DH24V9ePtcOIzwJhAArDyGVbtmsprgaS4EQ=; b=OaP2IUwmlNQ9khWH7XOmHBRXYz
        rgqKrqYwoycEdsvVC07zvlYvwR7NyYd2aISpZ7woAy384ogoCrddxBYCUqlPl+VaCyHwMIsVPFwDK
        laCrZt1c1yC5dlaUTyVRafYmO7p60YtIKvuxMh6bC0DgdqCk+ZfPNErxlaWxLXEGkX+sUowREw6/j
        QWmQtcpPax4XkiFaz2VAXlslaYO7boU7+lWQftL7rRYbNcYXIs9p1ehKqUIKplYiDYrLcP8Ob3udP
        yQV8k0fqNqoaEU9Kw7Klbx7GtF6gtv04ivk4etSFlDVnMYE0eW8jr7pZoGvJX+FrKO+70sPDtiuws
        Wx1Fa3CQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kUAfz-0007o9-15; Sun, 18 Oct 2020 16:32:51 +0100
Date:   Sun, 18 Oct 2020 16:32:39 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] docs: nf_flowtable: fix typo.
Message-ID: <20201018153239.GA349273@ulthar.dreamlands>
References: <20201018153019.350400-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <20201018153019.350400-1-jeremy@azazel.net>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-10-18, at 16:30:19 +0100, Jeremy Sowden wrote:
> "mailined" should be "mainlined."
>
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
>  Documentation/networking/nf_flowtable.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/networking/nf_flowtable.rst b/Documentation/networking/nf_flowtable.rst
> index b6e1fa141aae..6cdf9a1724b6 100644
> --- a/Documentation/networking/nf_flowtable.rst
> +++ b/Documentation/networking/nf_flowtable.rst
> @@ -109,7 +109,7 @@ More reading
>  This documentation is based on the LWN.net articles [1]_\ [2]_. Rafal Milecki
>  also made a very complete and comprehensive summary called "A state of network
>  acceleration" that describes how things were before this infrastructure was
> -mailined [3]_ and it also makes a rough summary of this work [4]_.
> +mainlined [3]_ and it also makes a rough summary of this work [4]_.
>
>  .. [1] https://lwn.net/Articles/738214/
>  .. [2] https://lwn.net/Articles/742164/

Forgot to include the tree in the subject.  The patch was intended for
nf-next.

J.

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl+MYBAACgkQonv1GCHZ
79fKNAv9GtZB72sP69lK9WhYUhkA8COeaK7AzQdo1xGkxtpl6OBmRJJuk+S7XHlX
e0AB+jK83InodK5t5xXVKTQg3cWX04xD/fWMHPQ9hkwW261qYQQkXTeKfO+DSsv+
OJofB3aBW10DTHbUczu1dwJU/Y66wgYlIcKqkkgJkbafWJNqLVyzqAd2kiBVS+xR
bOeRvEOr52PTehnvz/sorf71DGpSH/rR8DDPvnLGwsRUqyHPP5+AVl0ABeMUT8P9
TUaWDAbWd+3zLOWgyTSG1doBcIJlMq3y/vGqT100s/V/a1wVk/euxaiE05DVd4j5
F9gFW3stBaI1ieIHeRN24OgTNTR4GnrjEm+wSXjZo2eCAy+m2DDqIsvh/Ou7K4qh
R2TG/MH5wlRpTH3MGLKQT1Wpu9ASPYLkApXv3oFge2bhGxXdqiVjTXwNvGvLb+ke
55Vd6l9RGpPvoDE3T3Y1SnCuCdbcrOIe6NmGjMLIZ0+L6fCrJiaQReUNRqaXrYCQ
4xtxLmnH
=BJch
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
