Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07FF4C76196
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Apr 2023 19:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjDATZw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Apr 2023 15:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDATZv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Apr 2023 15:25:51 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC34419A2
        for <netfilter-devel@vger.kernel.org>; Sat,  1 Apr 2023 12:25:49 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 3DAEB3200971;
        Sat,  1 Apr 2023 15:25:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sat, 01 Apr 2023 15:25:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1680377148; x=1680463548; bh=sx
        uDreJpLGPWK5v5O4lnwYqPUGBtX2yQMrrSxjVnPIM=; b=MqhiGwmBHvLJIKsceA
        tZpsGyL3h/roAA6rq1/vOj2KvhF/2WZY6tsmOF9mdk+ynxDDMNFh++AzvFVvogNq
        7Y0sTBotaXntJzbhF3Kx6yxW5lDQSWzOhXurH3/0hLdV0n7iOdP7bwGnEe25XJVj
        5YIphMtknBSyMHi22pZwjwXRJiTlsKa0iBA3UHbCccDvTYvTabOHBDUzFcZdTcqu
        +3dhsuu5RulvAo8Vd3wrBaX4KG+u2KXo8PnxiZYL5I8T5TaUmliIYN7YDbZBOlyf
        v9R2zF1X64bxugJbqWpVDjo9dXBZ0KRdXORDk1EMWTyX/RlWTX7D6No19wdWQwu+
        cDMg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1680377148; x=1680463548; bh=sxuDreJpLGPWK
        5v5O4lnwYqPUGBtX2yQMrrSxjVnPIM=; b=lKCKt2yrP17WMrbvGhMBc1KOeJkAR
        H7KysGWK7TA04QknitpnAyjVaunWybhgk2T9kQFOF0f2IvgLdcOE/3Q60bKYdTao
        NegXSudpSBmHvMBeA4hgHyqa2hItvV/t90cTNwrzZqDKDprk+zkHVGmvS+/wSvek
        otHs4WI3BpTBnG4YENopdBNAgUL87rfkPXJA9FEUcyC0W718/HjajriPPwWuesV+
        leTbmcOYO3Eo0h5LFu8SaHoo4wKZiYxf+chupadLB1eVsrWq6iIworRo1n7kzzzO
        PwzSXpgG9rOCBVFVG2ZhN6+YBkkFApk79lx8upKAllNS5cWLSRSRvgJCA==
X-ME-Sender: <xms:PIUoZGAcPu8fJgP8MezkZi3VTq8hY9s3Db5anRzIxUl8i7wBlynDTA>
    <xme:PIUoZAhxZlsCaff_Y13WeZd4JAcQnhzgdjqMC9ViwhZpljxSkK4qpwhUtgG4rHq1l
    W05n3RCiPNEg3Timg>
X-ME-Received: <xmr:PIUoZJmo6w4P48BIwa398cAcvvwihey4zWku28QwQw55LDcl0E8bF-aWh3pYm4-oCOWVqvWE_oZsxZ7yLkkJGYl28F3lKlzSBQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeifedgudefjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehgtderredttddvnecuhfhrohhmpeetlhih
    shhsrgcutfhoshhsuceohhhisegrlhihshhsrgdrihhsqeenucggtffrrghtthgvrhhnpe
    ehfefgiefhgfefheetkefhgeevvedugffhvdffleeuvdeltdeugeehfefhtdfggeenucff
    ohhmrghinhepnhgvthhfihhlthgvrhdrohhrghenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehhihesrghlhihsshgrrdhish
X-ME-Proxy: <xmx:PIUoZEyrv3NcgJ1scSaUqg-p4jaWZw838EG41zIflDygFRWDuzfc7w>
    <xmx:PIUoZLT71YryTvVms3kfiQysw-0ezCgkYsb1Mm6J2ID4W1u2LRaBBQ>
    <xmx:PIUoZPZ_FgBvxUAlOORP2XDyCubUGe76PHMNwO9Jn_DEcEeObr-Zrg>
    <xmx:PIUoZM7fgde4BUrnMoVFkhr5zgHmYOUQBHj3X60xPFjYRN0BeLhSHw>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 1 Apr 2023 15:25:48 -0400 (EDT)
Received: by x220.qyliss.net (Postfix, from userid 1000)
        id 4A207260F; Sat,  1 Apr 2023 19:25:45 +0000 (UTC)
Date:   Sat, 1 Apr 2023 19:25:45 +0000
From:   Alyssa Ross <hi@alyssa.is>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables] build: use pkg-config for libpcap
Message-ID: <20230401192545.7bbscvjfvak3zc74@x220>
References: <20230331223601.315215-1-hi@alyssa.is>
 <20230401114304.GB730228@celephais.dreamlands>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="57kcg2izefnzputc"
Content-Disposition: inline
In-Reply-To: <20230401114304.GB730228@celephais.dreamlands>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--57kcg2izefnzputc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 01, 2023 at 12:43:04PM +0100, Jeremy Sowden wrote:
> On 2023-03-31, at 22:36:01 +0000, Alyssa Ross wrote:
> > If building statically, with libpcap built with libnl support, linking
> > will fail, as the compiler won't be able to find the libnl symbols
> > since static libraries don't contain dependency information.  To fix
> > this, use pkg-config to find the flags for linking libpcap, since the
> > pkg-config files contain the neccesary dependency information.
>                                ^^^^^^^^^
> "necessary"
>
> > Signed-off-by: Alyssa Ross <hi@alyssa.is>
>
> LGTM.  The only thing I would say is that pkg-config support was added
> to libpcap comparatively recently (2018).  When I made similar changes
> to ulogd2 last year, I added a fall-back to pcap-config:
>
>   https://git.netfilter.org/ulogd2/commit/?id=be4df8f66eb843dc19c7d1fed7c33fd7a40c2e21

That's quite a lot of extra code.  Is it likely that people will want
to build a version of iptables that is five years newer than their
libpcap?

--57kcg2izefnzputc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEH9wgcxqlHM/ARR3h+dvtSFmyccAFAmQohTcACgkQ+dvtSFmy
ccD6AQ/8Dm3BHQ67w2j2kzbYCjvmlz1OtB11UvfBColv9t3be45hIhjCqugKrpbJ
/6WFJSlUCYddnkuKVU+CopB5z6AIw/X1JxwSBLsiO92+bs/PJkCICSFc8dh2hsPe
IsuocLddQvP3MTWDNFp3gm46Q+uDYhYUyV6T9MlRXCB/7EeNRpepxeA2wSBULock
Hdv9h0g0sUaXm3etUIWOkL6AnRIfpRgyBwX5D0Is2IjH04ELYoNFyCIGtEhZrwKF
grGbRIoZvQdRFyNZ+pmM1lKBL9208nVfmu9e9/jth0KCPP7xC6mPJlztWCXsm9cc
l98ndiGs4gqLZrejv6f+vkc2hI0kdwDzbRD/M+/1h94Lk9L2ANRDbAbcZxvyBgx9
NEKq96fxPrZsDRNX0yHfuJiTO56tghnCOL8m+5ZmxDgJoXMYDSO2/urEPB7LXzUC
f30+Se4uzzqcLZb7TNMMC0w1T/3Wvl1lpBkI6VUx3/Vc9YHRc8YTKQNsZbyFIRVa
Jk6iHoXaBzUhbrGmpvt9hKGGtZfhl5skS41+y5++oUc9Up02Z64nsGiQpXsoQnQx
fMJHEFzveERjbfX7BbFisu9QNdIp57NSkKvCv2ZhGaJ/uDkEp2uSukxl3pnfMLlX
Q7VVbKSCbCGKU1md6QSzAB6vq4jlsfjcSvszfgYdvOduLynHBK8=
=nfJt
-----END PGP SIGNATURE-----

--57kcg2izefnzputc--
