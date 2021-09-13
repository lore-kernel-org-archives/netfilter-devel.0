Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A81EC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 15:40:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65831610CE
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 15:40:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234460AbhIMPlV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 11:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242379AbhIMPlQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 11:41:16 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1DCC09CE57
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Sep 2021 07:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7eIXLVrdwl66dkcgf4oSDPzkfqHZ1QMtkZPfinnZJ/c=; b=pVn2NKW9g/oz9Zun5G3/HFG4gi
        FqrPqUBsrZshWNKpUbtBOw+1R6J9J82fNo8IZp/htHBl7Rv0f1jnybMaj7jqHsKKkuvagNod/VHBO
        Pl2Ss8ueTabmsokJL+tISCA9GYTiRMF2otRY6qYjOOGbAeVBo/634R7t5QSXrss1oRdUNt4v9izk6
        Fbi3gnAZ1kXHxIzCw2x0jtZfzut20dvt66jGhJmfrzV6ezcE8o1sTklb0LLp4d5hXFhGgUZvrf0tU
        x+pE/hK6wPc4bjnECRiBToqfxYij8bRn6ScVtRXoqapMMw7Mdjd0QiZY2okk6Q1rzONOyrbvhQX3O
        QEPTBUVw==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mPnMc-00GUas-6d; Mon, 13 Sep 2021 15:55:18 +0100
Date:   Mon, 13 Sep 2021 15:55:17 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     kaskada@email.cz
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [xtables-addons 0/4] IPv6 support for xt_ipp2p
Message-ID: <YT9mVQeL7yohP7th@azazel.net>
References: <20210913092051.79743-1-jeremy@azazel.net>
 <1wg.aVMb.5l0xziYPqYA.1XFsCY@seznam.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Pu0617Uo4xPr0HcK"
Content-Disposition: inline
In-Reply-To: <1wg.aVMb.5l0xziYPqYA.1XFsCY@seznam.cz>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--Pu0617Uo4xPr0HcK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-09-13, at 16:41:38 +0200, kaskada@email.cz wrote:
> big thank you for your patches. I`ve already tried to compile them as
> those are already on git.
>
> Unfortunatelly I got these errors after make. You can see it in the
> attachment.
>
> [...]
>
> M=/usr/src/xtables-addons-with-ipv6-for-IPP2P/xtables-addons/extensions modules; fi;
> make[3]: Vstupuje se do adres????e ???/usr/src/linux-headers-4.19.0-17-amd64???
>   CC [M]  /usr/src/xtables-addons-with-ipv6-for-IPP2P/xtables-addons/extensions/ACCOUNT/xt_ACCOUNT.o
>   CC [M]  /usr/src/xtables-addons-with-ipv6-for-IPP2P/xtables-addons/extensions/pknock/xt_pknock.o
>   CC [M]  /usr/src/xtables-addons-with-ipv6-for-IPP2P/xtables-addons/extensions/compat_xtables.o
>   CC [M]  /usr/src/xtables-addons-with-ipv6-for-IPP2P/xtables-addons/extensions/xt_CHAOS.o
>   CC [M]  /usr/src/xtables-addons-with-ipv6-for-IPP2P/xtables-addons/extensions/xt_DELUDE.o
>   CC [M]  /usr/src/xtables-addons-with-ipv6-for-IPP2P/xtables-addons/extensions/xt_DHCPMAC.o
>   CC [M]  /usr/src/xtables-addons-with-ipv6-for-IPP2P/xtables-addons/extensions/xt_DNETMAP.o
>   CC [M]  /usr/src/xtables-addons-with-ipv6-for-IPP2P/xtables-addons/extensions/xt_ECHO.o
>   CC [M]  /usr/src/xtables-addons-with-ipv6-for-IPP2P/xtables-addons/extensions/xt_IPMARK.o
>   CC [M]  /usr/src/xtables-addons-with-ipv6-for-IPP2P/xtables-addons/extensions/xt_LOGMARK.o
>   CC [M]  /usr/src/xtables-addons-with-ipv6-for-IPP2P/xtables-addons/extensions/xt_PROTO.o
>   CC [M]  /usr/src/xtables-addons-with-ipv6-for-IPP2P/xtables-addons/extensions/xt_SYSRQ.o
>   CC [M]  /usr/src/xtables-addons-with-ipv6-for-IPP2P/xtables-addons/extensions/xt_TARPIT.o
>   CC [M]  /usr/src/xtables-addons-with-ipv6-for-IPP2P/xtables-addons/extensions/xt_condition.o
>   CC [M]  /usr/src/xtables-addons-with-ipv6-for-IPP2P/xtables-addons/extensions/xt_fuzzy.o
>   CC [M]  /usr/src/xtables-addons-with-ipv6-for-IPP2P/xtables-addons/extensions/xt_geoip.o
>   CC [M]  /usr/src/xtables-addons-with-ipv6-for-IPP2P/xtables-addons/extensions/xt_iface.o
>   CC [M]  /usr/src/xtables-addons-with-ipv6-for-IPP2P/xtables-addons/extensions/xt_ipp2p.o
> /usr/src/xtables-addons-with-ipv6-for-IPP2P/xtables-addons/extensions/xt_ipp2p.c: In function ???ipp2p_mt???:
> /usr/src/xtables-addons-with-ipv6-for-IPP2P/xtables-addons/extensions/xt_ipp2p.c:978:10: error: implicit declaration of function ???ip_transport_len???; did you mean ???skb_transport_offset???? [-Werror=implicit-function-declaration]
>    hlen = ip_transport_len(skb);
>           ^~~~~~~~~~~~~~~~
>           skb_transport_offset
> /usr/src/xtables-addons-with-ipv6-for-IPP2P/xtables-addons/extensions/xt_ipp2p.c:988:10: error: implicit declaration of function ???ipv6_transport_len???; did you mean ???ipv6_authlen???? [-Werror=implicit-function-declaration]
>    hlen = ipv6_transport_len(skb);
>           ^~~~~~~~~~~~~~~~~~

Ah, ip_transport_len and ipv6_transport_len were introduced in v5.1.
I'll change the code to use something else.

J.

--Pu0617Uo4xPr0HcK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmE/ZlQACgkQKYasCr3x
BA02rw//ZgBJ126z+TsHGHmnmSYwYLxPolUho4fIqTLz+g+4/0m3wm+lMtCeu6So
8n18cztg++gyJK2HD96vQJiZHJXv4M90xcyD1JRVullTlau19qub8fMqfVekJ1cd
+DrKQMhHNmbpYQ0m2iZ+209zsZ+wsRHaY9zcCnTuQiLL7mel0+Uh2kMHDF+h5mhg
mqKHJjvnJptb7mw8am3t5vAt8V4jOOe3tiW8RcuV7BUHISzyfkTKXj8TeuG6LrvI
rCxFOqjnXAmEyitzrstWipBfdJy0/4qWNvlAXvIqLB1YtfPR6AkgdGuRlj5avdCI
HW2TuxNKsBFuuUJnjHHGakDjnpA5v4naoXkCpzsiWzwfEPzI6WDI0VzYj5iSgQcQ
EAqzZ1FmcFqlAx0bI0FqS9JixJ/r6X1joQoJCfFs/O3O9AHSu8VrgXa2cXZq6JhM
66sr43R2rAoNYZvhhhFUn5Hms68LZMnwfhjw8gKXz2Xw5fIHE4C70EG8MnhIR5vY
xdsCtHf4p1SaDWeuC5XUHChl/tvspEU4BudSs/bBtfnuzt/LY1EDqfDML/oSgB3V
8H6/El8VUGUEaVG1AhvfqP5s9uYSxzB+D1+9xF4fobfLD/AVAIsClt8Of438yWYt
lQfN2TS3IBfkqTYvdh2mYxX7DRvTGUMWsbcStCr6LI/O4S0xS5A=
=i9Xl
-----END PGP SIGNATURE-----

--Pu0617Uo4xPr0HcK--
