Return-Path: <SRS0=zFhn=2O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BFAEC2D0C3
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Dec 2019 23:16:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F24D9206D3
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Dec 2019 23:16:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="C8RpBULe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfLXXQH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Dec 2019 18:16:07 -0500
Received: from kadath.azazel.net ([81.187.231.250]:49822 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbfLXXQH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Dec 2019 18:16:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=d7sMv1jpcvZW3fBBCG0aOjGOY9H8YsQPaZRtWO4yfmQ=; b=C8RpBULeu39DS7COhhpbrvvMo+
        51yyfotWqW7m/moTjmZmULbu7Is2cXrUynH9fuTzNzoZf0OzWR1blhXikdP0lDYxkfw9tvS3S7AOk
        ZORzA+2RsaYA2R82246AjP9C9s0ueJ/tR2QQzX0DZh+1Mtb0yGmfZl/4caFo2KMn8NWY/sWbTKtdX
        CuInEJ9V3vQIWYgctSjF8GY2PKtZ0GzGwMUMUQcx8c9bsQ9MQfpQ4CMGdUGHTpGExfBI+YOqG1vpZ
        S0oifEtDXo5ZXsYPjg1TgdgsL0CKLwcN2tB8hakhIjcishPpoutYRkJ23hTgMetyU3/Rbfk9uxBC5
        knl2r7bg==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1ijtPK-00028i-8P
        for netfilter-devel@vger.kernel.org; Tue, 24 Dec 2019 23:16:06 +0000
Date:   Tue, 24 Dec 2019 23:16:05 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nftables] evaluate: remove expr_set_context call.
Message-ID: <20191224231605.GA1798750@azazel.net>
References: <20191220190215.1743199-1-jeremy@azazel.net>
 <20191224231211.1972101-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
In-Reply-To: <20191224231211.1972101-1-jeremy@azazel.net>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-12-24, at 23:12:11 +0000, Jeremy Sowden wrote:
> expr_evaluate_binop calls expr_set_context for shift expressions to
> set the context data-type to `integer`.  This doesn't seem to serve a
> purpose, and its only effect is to clobber the byte-order of the
> context, resulting in unexpected conversions to NBO.  For example:

Whoops.  Sent v1 again, instead of v2.  Let's try that again.

J.

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl4CnBYACgkQ0Z7UzfnX
9sNhRg/9EXWvzSBs7mFqFwpZt9190M+fzpXsrCEEydA97D4MNWWBeJdbu+fHz3un
HSzu/yqPdY6PqY8ho+K6Jv+TdD0ikL7ZJuDqFQf1rbJ0LDcYK+yj6RJ+D0feNvXl
7zzogDE5RTws083PU/jO6T66+B6yq4JoIugwRbVBlZSjAcdhp55qXy/5c0krlFT8
9wQf9hNaOJ8AthrTNVJL2RyjoycNVu5lqo+PA6Tktm9pyVumsqrE1aQfXBOvRCVR
dct2n+Zm8YxMSpY9d9ApSTtT12uxzjDZQ0h5+maxQ7aylUkycYGaxQaouhmOkRHR
ZDXoMv1OvHmqXzpVNafQAGD1+/5WWqRMD/J0kGNL/tZ2l7DIQEG7w4DSAp6LNDZz
XnsBLvr9I4wwE+KzKlkUmRAYLBko15kjTei1NB7y67ugQKAF/KciJ7pjTodDslLG
5EFxOTa9IG1gzAQb4b2C1D03kTCNzd9qQBoUZIotVnHFvAk4m7fs1WviUYuXuJdY
QyMOX0/Ud53BRZBudfALTfQBhXfMTLeapRtPCext9VHbVk/Vccucu+1KDww/gZDx
hs61wb9MV5oF4S+xvgIMZoUgACY8RlTMv6Ekx40tcJ+4D+dRcIF6umZRMuMnDDEg
Uawi3ygB7ZNSh/V6I3e9Q8xNvZ0Ccr9whTrruKvBE3CbkYG38Ns=
=ojGG
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
