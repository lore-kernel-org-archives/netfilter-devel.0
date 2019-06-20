Return-Path: <SRS0=UCdS=UT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F5A5C43613
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jun 2019 13:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF1BC2083B
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jun 2019 13:48:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="BPlE0xQL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbfFTNrx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jun 2019 09:47:53 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:51379 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726391AbfFTNrx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jun 2019 09:47:53 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45V36W3DrBz9s00;
        Thu, 20 Jun 2019 23:47:47 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1561038469;
        bh=/k/qQswXAZi75pd1SKBRQnISr4mCyddX13qbGQESFGo=;
        h=Date:From:To:Cc:Subject:From;
        b=BPlE0xQLO9TbS8sg66zn4hp+e5XgV8vRZYX26T7jxpYehBvBSvgFWn4yT9OcuU3xd
         TV8s+QdwI5I07dZZfjGLEK8ONsLlAq1t5wr5ysJDleNbjbAHE0fJSXBxMpXiU8R6us
         FF1P6QrPjAXtcTfxw59lcON8XQQdp6t/yXyTB2h7fY4yTHh12GdNFJ1eiZ4M2NdVDN
         4ZPGP5tcyLXHfut+J6erYkhVJWyr8A4bmtu/cZPA3RcB3NglKPrX3rRojShWOE6NH3
         OMAxwxDd12GlR5IWM4LuBrCNpaRvveGHElHebrmEk+dNaoRWv7O3X1Qf6UupaIn5Fx
         XgoWAu9eYXvpQ==
Date:   Thu, 20 Jun 2019 23:47:43 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: linux-next: build failure after merge of the netfilter-next tree
Message-ID: <20190620234743.42e9d3e8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Pgq8rDpprbxoIRCNvHFBehR"; protocol="application/pgp-signature"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--Sig_/Pgq8rDpprbxoIRCNvHFBehR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the netfilter-next tree, today's linux-next build
(arm imx_v4_v5_defconfig and several others) failed like this:

In file included from net/netfilter/core.c:19:0:
include/linux/netfilter_ipv6.h: In function 'nf_ipv6_cookie_init_sequence':
include/linux/netfilter_ipv6.h:174:2: error: implicit declaration of functi=
on '__cookie_v6_init_sequence' [-Werror=3Dimplicit-function-declaration]
include/linux/netfilter_ipv6.h: In function 'nf_cookie_v6_check':
include/linux/netfilter_ipv6.h:189:2: error: implicit declaration of functi=
on '__cookie_v6_check' [-Werror=3Dimplicit-function-declaration]

Caused by commit

  3006a5224f15 ("netfilter: synproxy: remove module dependency on IPv6 SYNP=
ROXY")

This has been happening for a few days, sorry.

# CONFIG_IPV6 is not set

--=20
Cheers,
Stephen Rothwell

--Sig_/Pgq8rDpprbxoIRCNvHFBehR
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0Ljn8ACgkQAVBC80lX
0Gz3hQf+JL8ZUPKg+z4tA8K/9e0a7HFDulhxQZl9wRn1ATnFGby1MzNWqotmbOgP
IBEBYO3njQayBsqg2Uy87zlcHpAZnpr8OJTI1ZcW/SWgDJb3JzBiYHkNZ/IVRHz0
tqxC42xc4udKOrooP2Nczi/fBEnXGf1pWgUL+zeMmOSQNP7U7M2zXDdCjKYyNMAH
E0N8Uh+0nG10MfCZyvHyTvbj0+mEeilRmblo5bjdnz55qD+iM7rzBrZESn3jeMG+
4qoRg1uKkXDh3pTu2XPADpv4ex+WYE8i4xm7ZNoYBszwYMWACmO6z+vFvQG8KvMS
L7YQQiWK8fOmPMfAmi1h2DIqO4kvQA==
=RMsC
-----END PGP SIGNATURE-----

--Sig_/Pgq8rDpprbxoIRCNvHFBehR--
