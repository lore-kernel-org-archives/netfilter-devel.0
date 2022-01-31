Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFEF7C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Jan 2022 10:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358146AbiAaKZT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 Jan 2022 05:25:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358132AbiAaKYz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Jan 2022 05:24:55 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76359C06173B
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jan 2022 02:24:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5alrWNmBC0Y9It+OuxzZbVctQ+KvmhvGw1GpA+auQxE=; b=WVTOpf56ERZ6YsGB/6ivYICT8j
        RKab0lbesLr/x099w7UMJiL3RRQBoOzQ18SX0s4dvPGUMRnGII9gi2HoAEazGfwIUX+HeaWx1Bos/
        OAJNbZFN+XmJlmaV19QlUWGgRHFunSmctYBvf6i46ho6P2cLKoe8fIcmtDlh77ShIk/LYIuuuBuoW
        PeqzMQ9GP28j7SP0bfq1XPYmP2T9/TJvxBlyAO9+WCmOiDslbNcYQYsGG09gvRnX37BF3PPRJT1zF
        WQkemHcbzv84rRd3EczcIIF9x5Fuf54KcKqK45H9h4r4fgwDk1JQEuq5sYB5Hb7vc2/hvBI2IRO6G
        ohOgXhLw==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nETrf-007AwN-4o; Mon, 31 Jan 2022 10:24:51 +0000
Date:   Mon, 31 Jan 2022 10:24:49 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Philip Prindeville <philipp_subx@redfish-solutions.com>
Cc:     Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] xt_ECHO, xt_TARPIT: make properly conditional on
 IPv6
Message-ID: <Yfe48T7Nxpzp20wL@azazel.net>
References: <20210926195734.702772-1-philipp@redfish-solutions.com>
 <5s32r847-4op5-70s2-7o9n-4968n7rso321@vanv.qr>
 <05A51779-4B94-49BA-B1B8-6CA5BE695D80@redfish-solutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pGVBvug5htLSHnGo"
Content-Disposition: inline
In-Reply-To: <05A51779-4B94-49BA-B1B8-6CA5BE695D80@redfish-solutions.com>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--pGVBvug5htLSHnGo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2022-01-30, at 21:53:26 -0700, Philip Prindeville wrote:
> On Sep 28, 2021, at 3:43 AM, Jan Engelhardt <jengelh@inai.de> wrote:
> > On Sunday 2021-09-26 21:57, Philip Prindeville wrote:
> >> From: Philip Prindeville <philipp@redfish-solutions.com>
> >>
> >> Not all modules compile equally well when CONFIG_IPv6 is disabled.
> >>
> >> 	{
> >> 		.name       = "ECHO",
> >> 		.revision   = 0,
> >> -		.family     = NFPROTO_IPV6,
> >> +		.family     = NFPROTO_IPV4,
> >> 		.proto      = IPPROTO_UDP,
> >> 		.table      = "filter",
> >> -		.target     = echo_tg6,
> >> +		.target     = echo_tg4,
> >> 		.me         = THIS_MODULE,
> >> 	},
> >> +#ifdef WITH_IPV6
> >
> > I put the original order back, makes the diff smaller.
> > So added.
>
> Did this get merged?

It did.  It's currently at the tip of master.

> Last commit I saw was:
>
> commit c90ecf4320289e2567f2b6dee0c6c21d9d51b145
> Author: Jeff Carlson <jeff@ultimateevil.org>
> Date:   Sun Aug 15 18:59:25 2021 -0700
>
>     pknock:  added UDP options to help and made whitespace consistent

J.

--pGVBvug5htLSHnGo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmH3uOMACgkQKYasCr3x
BA0/gQ/+ParfuAa6GTOb1nmPWFfeo916ObTf17LEqc1ONZGcimlNMhsZOegddso0
TIPNzHuBP6RUN7mFSCMCQRlSmfu4yUNR82vSJU8fNPG8adaeUMipbQAc0skwBRm3
q0+T2UeCuPF0wvF3nmB02DnxKee78gN1EGziShCDXJISpr8HDIs4FhHfijUhu/C4
ZaQUggpi7aNAo4RML9wkYab28NnmdnfJO46iVu0Q2wTKOPEmGyRMTzfm7DFsPqKr
RBcssZXDxeZZUN3naXTtWs24YDw3uMTCMzUCtWlO6GEdcIzKSD1tTlPbtGOp7RZK
XCeE1BGHgX8gXqSqUWrmXkGtjDKvBRzYwQPg/FBRne52ec03AtPGThhjgoyXb1Z5
4T7wNNDLr/Y1n49jlwHJ4yOoG3I/io6ytW0224DW2GA5oBz8AWuanOOr0OSfZVz0
4IBsMfWKOVPR7oAlIW4WczVUwtCCgyTfws6RuIsuuPwRzz0WZCLxghUERR7hwYJy
rH1+hkw+vWDE5VmA5pg99FIB87hsFhqhFgMuJ2gqcW8QJFVU9oTu72o9MJmOFzJa
37xtckbutWdu8GBks97XlCiV9EBP2PXVOU2KiCgJMmxRVr2AZyEo22IFgHV2vmAh
EHadwMzZmBAbBICU/ZLky2XqyiNC7XQsUGbqQl/Ti4vJH1PomJQ=
=hBy1
-----END PGP SIGNATURE-----

--pGVBvug5htLSHnGo--
