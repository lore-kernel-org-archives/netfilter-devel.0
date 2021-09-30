Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A462DC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Sep 2021 07:16:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CBF56187A
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Sep 2021 07:16:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348589AbhI3HR6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Sep 2021 03:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348579AbhI3HR5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Sep 2021 03:17:57 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944F0C06161C
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Sep 2021 00:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=J7vbq+cFK+Bd4umOfBO0FH/3gyFwfSpyRnSCQJ4diLg=; b=Rso/7yDNcbewe0V6lxUIKbmekB
        GqbxofJscQbGtI35MnsA9Go9uPbJ/lxHbhqbMz0cPYbtsZJNPtODVgs4tMhhOrhRAvODsA2tQ2LH6
        3sx6E4zcaPcEQ8hmVmyPk5r5vAVg4EFhIJIYwxhVEPDoLIcGWWo8iACOuw+DeYM04sBEQEeyBIZLh
        7SgMyDtoA/iE1Y0tYmi/dY2iSG6+8ooduknaYmWiVeph8ZKMm3hVgmnepSqucYSfbvpJ71br0wvqH
        59fDDpteWH8M0oZxUAfCyVlvM7WIdzADSS7uEZCqZu89axCciHvGZcr/HqIT2YA1JnM9ktTJOJEX9
        kwDf49uA==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mVqIa-000zyK-Fg; Thu, 30 Sep 2021 08:16:08 +0100
Date:   Thu, 30 Sep 2021 08:16:07 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Core Team <coreteam@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Kyle Bowman <kbowman@cloudflare.com>,
        Alex Forster <aforster@cloudflare.com>,
        Cloudflare Kernel Team <kernel-team@cloudflare.com>
Subject: Re: [PATCH 1/3] extensions: libtxt_NFLOG: use nft built-in logging
 instead of xt_NFLOG
Message-ID: <YVVkN0ZNs5I+tKG+@azazel.net>
References: <20210809194243.53370-1-kbowman@cloudflare.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="RTUT6lRwdoDagbBh"
Content-Disposition: inline
In-Reply-To: <20210809194243.53370-1-kbowman@cloudflare.com>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--RTUT6lRwdoDagbBh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-08-09, at 14:42:41 -0500, Kyle Bowman wrote:
> Replaces the use of xt_NFLOG with the nft built-in log statement.
>
> This additionally adds support for using longer log prefixes of 128
> characters in size. Until now NFLOG has truncated the log-prefix to
> the 64-character limit supported by iptables-legacy. We now use the
> struct xtables_target's udata member to store the longer 128-character
> prefix supported by iptables-nft.
>
> Signed-off-by: Kyle Bowman <kbowman@cloudflare.com>
> Signed-off-by: Alex Forster <aforster@cloudflare.com>
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>

Hi Core Team,

It's been the better part of two months since this patch series was
posted and there has been no feedback.  I was wondering if one of you
might be in a position to review it in the not too distant future.  I
see that it is delegated to Pablo in Patchwork, but then so is every-
thing else. :)

Cheers,

J.

--RTUT6lRwdoDagbBh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmFVZCoACgkQKYasCr3x
BA341A//ZLq3MJCZF3JZFf3R6gVzYERj+0/G7dKHac3qf2BeRxuYVQUqfcAVii0c
ErQyc2Odlf61j7/DgbhUxpZVaY3riJ+5iz38d1BJ/8LaVN0+qH6ngMQ1UIfO5EF1
MsjEHy2j88gp5UWV+61CntlKx5gDfa3iZ4BtfTqY3T0IvGh5d5Nz0L9Gx7+7l4Fc
pOH1kVgWpQsGpkQ2h3JItZsq/H95iUrzWTIdurF167Yoh99KJjRIz/k4YkPsXyCJ
VTgiOtMR79is/6MGetnH903ndsYQMcSKbYzdgGdChfqkLkrw4eekfFygElB5ROS0
lWlGTU7sN2V66Ty/k33gQzxqqRU53k44pFNvWAcLBF5UFmSXfXSUvZR+vwt3vnZb
aFRiVmNGjSfpiV2mPqidbvNropDZnfQRP3UEvLZ0C/kVCHB1siubWlWS0cnUwcBj
50TKGDbh3Jq/l60K6t32hxOx4SVHI1HYUQKn/FxRNNVVECjRTL7CivWOp6HT3Wpx
on/d5P1hEF50S3N7r15MTKp57W+kJ49gpFFn/RKmfU+QFEbyVcyJHvsr5J/RsrEI
BCl7fg+77v9dayC8bP8PFnZsooLJbEpRq/LwAEcj2tEFtTzmRKAU+a9GNIIAVUL9
oaZHukNDkaxOCAriWyI0s0k9lnP5bDdWSa/M1f5nwr2MYR66mAg=
=jryJ
-----END PGP SIGNATURE-----

--RTUT6lRwdoDagbBh--
