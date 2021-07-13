Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 330EDC07E95
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Jul 2021 18:43:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16D2961369
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Jul 2021 18:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbhGMSqs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Jul 2021 14:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhGMSqs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Jul 2021 14:46:48 -0400
X-Greylist: delayed 1121 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 13 Jul 2021 11:43:57 PDT
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7C1C0613DD
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Jul 2021 11:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=liG/iYwCjk9IwFIWJzxxmXPQVJ5gALM1qXYXgEh6FLE=; b=U0krkkn3Owz+SOLcFScUnvgb9/
        qk/2saV1k9abkX1GlWSZ45nSlr2tXNqZ02LiDh2sdLoSikFUMEW8ILjokfxbd9zdtH9srhz5T2B4n
        0v3keBFzD6UvJcEdLv5Oy9pIbQPiuw6JVt67Tgo02g8BORsuSFw8bFAw+yD1PJBUw3O1Twbf6cSPA
        px2/XMyaO/+XLkpQ1ZjTaxXdXvICNhkKQVHrIZHrd2VqrHrj1pJ7S4XkFX9zUgB1QaJ4noTih5WG1
        jSD3sqZ8CIWWBeT6I4RAqhar5haBdC6yzwhGJDtVnmzLJTGktq+5q1w3wuBoDaqHqh/Se8dT4siPp
        c/xGj4nQ==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1m3N5f-0003he-Kv; Tue, 13 Jul 2021 19:25:07 +0100
Date:   Tue, 13 Jul 2021 19:25:06 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables,v2 1/2] src: infer interval from set
Message-ID: <YO3agpfuoOaV7HsF@azazel.net>
References: <20210713124735.31498-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="BjM+8LHwK3uRYr3b"
Content-Disposition: inline
In-Reply-To: <20210713124735.31498-1-pablo@netfilter.org>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--BjM+8LHwK3uRYr3b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-07-13, at 14:47:34 +0200, Pablo Neira Ayuso wrote:
> STMT_NAT_F_INTERVAL can actually be interfered from the set, update
                                      ^^^^^^^^^^
inferred.

> 9599d9d25a6b ("src: NAT support for intervals in maps") not to set on
> this flag.
>
> Do not remove STMT_NAT_F_INTERVAL since this flag is needed for
> interval concatenations.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---

J.

--BjM+8LHwK3uRYr3b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmDt2nkACgkQKYasCr3x
BA2a6Q/8D6A9b3Ygdt6K7akLqkfDq5LFVkZxvhf2hLowdS50w/qn+CvbmU256xfm
v7y95qviFKyit8XczpIk6uZyMHt2vhY9CZxHWYTpoyEYwISmw6xrwNLtBU4RF3EV
gSTktuRU1LSH7Br/z5L4rOFEGWMynnYWSC3huVY4bfhtJcsDyzk4TKBs6W5/eBKg
1aZZIjT7THlEvji7xQs8k5ZTYOcT4bA4C6r9DTbofOwn0Y/aPTMbE/Vgl0LFg6i3
LZQXE7UphBuJ0fmRR8tqKyNL26KUeDtc2hXbc99l5MbFStRwyGMgidoZPnXfNh9R
EwdHbcrH3cMHRZox+AuWTH3y3W2qXG+/WFAhInpgWOgAF6Mo/9IsN93LfXiWhX4n
+JsrUexBWMqgeoN/46eb7qvj2GaMsozCijcFCxT6DIauDzW3eP8E2f+ov2chwyzB
vmxPBDeNvGwnJG4Xfc8WD0flSApnq9qmO/qFFDO8GkurS9FpcoEyCJFnij33EjOw
WAZgD0V+27wggIxgGgmHGiv2ppl/tZNs7kiHyBlYZjh8zTralkdvQaL1eQC8drm4
34YPHzfMkSD3RTwziKMQTbZlMOwQdPE/ke+nBDCWqsliOqw58VDbwcgt9bD/R5yO
CH7wU/4t6NRmY4mF6W7wc0wArS6+ou98zSvhGVh3pJiS+ZosLAA=
=KmLU
-----END PGP SIGNATURE-----

--BjM+8LHwK3uRYr3b--
