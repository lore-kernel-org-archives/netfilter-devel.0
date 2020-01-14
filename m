Return-Path: <SRS0=kgPV=3D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B109C33C9E
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 21:30:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23F3C24656
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 21:30:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="DbRpGW6g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728844AbgANVa2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Jan 2020 16:30:28 -0500
Received: from kadath.azazel.net ([81.187.231.250]:55218 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728731AbgANVa2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Jan 2020 16:30:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5bVomGknvQqJfFpCsvcoGVdfRpCGA+1pXADcrNwqNns=; b=DbRpGW6gnCGgXafv+VgjO/Enm8
        cocP7nazJ2zEQodhU5yBOuSwr+1xzvuWvvtG8Nr6yDbDLg1m3Wt3IJZaeoco4oF9IjcpqFlwGwUJj
        f1CfkQfF4pW+OBWU0cC+rAqU6APbRBZR3pTAdIJhjfUvN4vwigoY0TpI17vccF+mZBmrBqHknW6vt
        MroIwgiTtyyKRluCwS+q+yfrTjK6N8jFadqq/j8jFxOBA0fIy0xYMbujpn/DF+uQOVYNlmk+oyrWW
        GRdTetFNBNzsfYD4AjQu1M4YIdNa6JsStilP1rbB02IjqpKO7fSqgt9QXUnlQdg3urhgI9ZjhIFsm
        01sb4aTQ==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1irTlb-0001IG-0N; Tue, 14 Jan 2020 21:30:27 +0000
Date:   Tue, 14 Jan 2020 21:30:28 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next 0/3] netfilter: nft_bitwise: shift support
Message-ID: <20200114213028.GD999973@azazel.net>
References: <20200114212900.134015-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="IpbVkmxF4tDyP/Kb"
Content-Disposition: inline
In-Reply-To: <20200114212900.134015-1-jeremy@azazel.net>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--IpbVkmxF4tDyP/Kb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-01-14, at 21:28:57 +0000, Jeremy Sowden wrote:
> The connmark xtables extension supports bit-shifts.  Add support for
> shifts to nft_bitwise in order to allow nftables to do likewise, e.g.:
>
>   nft add rule t c oif lo ct mark set meta mark << 8 | 0xab
>   nft add rule t c iif lo meta mark & 0xff 0xab ct mark set meta mark >> 8
>
> There are a couple of preliminary tidying-up patches first.
>
> Jeremy Sowden (3):
>   netfilter: nf_tables: white-space fixes.
>   netfilter: bitwise: replace gotos with returns.
>   netfilter: bitwise: add support for shifts.
>
>  include/uapi/linux/netfilter/nf_tables.h |  9 ++-
>  net/netfilter/nft_bitwise.c              | 97 ++++++++++++++++++++----
>  net/netfilter/nft_set_bitmap.c           |  4 +-
>  net/netfilter/nft_set_hash.c             |  2 +-
>  4 files changed, 94 insertions(+), 18 deletions(-)

Resent these by accident, please ignore.

J.

--IpbVkmxF4tDyP/Kb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl4eMuwACgkQonv1GCHZ
79cCtgv9G5BjJnIGvwBCDh1i7sdEHZLEPJKsPv/Ja+mQeRMQvcUOjjT/8Ab6/JYj
5sPdnT1QzQupLwPXOk6EP/XjWuJdf3ykfdc3fFnFMs7nGI0Lybq3QeueoV7061Or
CsjrRL1Khtr1bNvhAXOLANcQ2fnBlk81kJGPAyN9cErELYOFq6w+W3PotPaVV7g1
wz+eElJcExWAgUC9q7EWx+RJ01FvUr7XttEiQ2quSP32SBwAQB4Y+FgLFNFh0GZk
6GwDE+Bd0RIobpUD7ggQPbq4H/zfBO2+LkCx28GUV6tXkV/Nnf4aB+CYjX0VZPSk
9Wy1tJ1VA/DDfaGWEvY+I8babJGYgumTZig/NOBu9AjTpiHUt7Tr9pyKUNrLLISq
+GmfJgTVMChf6VVeefEOlKJVESqUnkwY9WVpXUen5+Qw6sooAHGVG+PZSlcG3S21
dt10TM9RXmbgctQWgI1DPcTmT5sSicww6EBIZHlmR7icR9nekbTYsRIcyBDxpGSl
FLJHhIQG
=IqZi
-----END PGP SIGNATURE-----

--IpbVkmxF4tDyP/Kb--
