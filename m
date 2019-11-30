Return-Path: <SRS0=76Lg=ZW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 541EEC432C0
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Nov 2019 17:05:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E48D2073C
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Nov 2019 17:05:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="CVp4t5lB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbfK3RFO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Nov 2019 12:05:14 -0500
Received: from kadath.azazel.net ([81.187.231.250]:52306 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbfK3RFO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Nov 2019 12:05:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=eYEkAvuXvVLTaAvV7NrLvJbj8rQiuu7xsq3uUnECtiA=; b=CVp4t5lBTALKtWtqHxQX6SoSLp
        y9uTwAbv8t9vEMzYqLjx+0i6NQMzu20ZfrlU+iyYFzmW+cdO+KW6+ryLYe07j//BjJuKkqBMy4JdU
        nL9FicoDWk6fgrUHJiuTMY864lODMLSpdhxgXxxZNil6fQbtu+zS140z6ykUetcEYjqwX6crzqH8f
        eWcwkUWIAowOwBhHzQ4Ea900r7otalvygWDSDYBC5vGXUhu2MnzVv6T75+YfhM0xzXSP0cLaQwJaP
        yYV0BeOP+2JBHBG1H11t1kXT11436lDOFN5+cktKzx+z4PtH91pWGCAhX7wgQGtgm7FLsVEwzJje6
        z7XUKJxA==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1ib6BF-0001tj-EX; Sat, 30 Nov 2019 17:05:13 +0000
Date:   Sat, 30 Nov 2019 17:05:22 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        "Thomas B . Clark" <kernel@clark.bz>
Subject: Re: [PATCH xtables-addons 1/3] configure: Fix max. supported kernel
 version.
Message-ID: <20191130170522.GB133447@azazel.net>
References: <3971b408-51e6-d90e-f291-7a43e46e84c1@ferree-clark.org>
 <20191130170219.368867-1-jeremy@azazel.net>
 <20191130170219.368867-2-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pvezYHf7grwyp3Bc"
Content-Disposition: inline
In-Reply-To: <20191130170219.368867-2-jeremy@azazel.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--pvezYHf7grwyp3Bc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-11-30, at 17:02:16 +0000, Jeremy Sowden wrote:
> The maximum supported version is reported as 5.3.  Bump to 5.4.
>
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>

This is an old version of the first patch that I sent out by accident.
Please ignore.

J.

--pvezYHf7grwyp3Bc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl3ioVIACgkQ0Z7UzfnX
9sMQMQ//aYxe+1BFHeTpkt6OxwmQBke5I/zX6Dw5i/KuhlBGgvLayKB0pdA+ZX0d
6xq1u+pW81qEw6zZMW6eC3tnNYl/qvPZkx5dvVWjF+DBfMUTl+iUwj8AcE67d3ub
tTILMwdu4A0rYcOMt6FU8NNpVrUiyZiR2+dsDLl7fwmYaI6HjkSQozZrMBWBepkq
CofVAebvfB91g3ReN5Meyh0wtyjln65ob4aKoshSp+m8oixqJ1TA+RSBUEqMimao
R4wR6uAmVU5rcQqQuLZy6K/QLxHb3yoYHbadYhjApFdQ/zx0bMysYK2tS3kz2C3T
Y5172bTxUAI8iLuKfo5Jls3Fb6ycwZvNCciVCUQ+7uHWOC9PU8x7/+vSKG5PjmYG
5dQHs5zaNTIsSW2WGGmV71d5WRZ/XENJomCu4vNRwhPpMv13sl7wHW0LvTWf+5ld
Qb6EyJY76fj/HPGNeIiRk45WTMS2/IsS0g5RA4km1XLWSOpHv7nmUtU9Oy0xFVol
Xcf1isfk+39t5lac6ICgdRB2TTBB3o0AQk8D0Xie4buUuov74oWpAR1Y8p5Xjn5Y
Y2VkU54paTTwabRZ4Hgt4K5L4eqzhSC5Rd7A1mL+N7o3HcyZr2cFdJX+xF72f47D
r5VAU0iKSP3FEK/RfQIIFOQ+xjfu1C/ueT2DDELCEKTHiLfkwZo=
=MJf5
-----END PGP SIGNATURE-----

--pvezYHf7grwyp3Bc--
