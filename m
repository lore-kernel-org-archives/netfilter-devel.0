Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DE4BC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Sep 2021 20:04:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D848261A3D
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Sep 2021 20:04:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240840AbhI3UGK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Sep 2021 16:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhI3UGJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Sep 2021 16:06:09 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E293AC06176A
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Sep 2021 13:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=S7vUbsn6H0QabcpbQhcK78PriOSUzWFNhHAOMSo/DhQ=; b=jiW/8t80C+M9CHSBe0SMfmD8oe
        uGDztkDyA8BmHEbllkGoFPc8S2MDeTcxtuV6SSgpUDVDEOkIsEFxr6488PbQpfbxrHp7IdFSAJnH0
        jA2TooKvunKyKFwur9AFrT0GGe3SCCqTzgY+Wy8nmG3GYvVYykVNp20qMafq/nbg5o4cNC7O2Yhby
        VMqQjQ65T/5D8tZmoBIxdC+9vkyWN9cp6T8SokjCCIIqc9meJj9IWTMu0WLa6ZSduoLknZ1nNtrFY
        khlB/6UZKPcwbv7adfNtj4jG6+juckjN1uFJ1CubAWJvqWexkt1f/AnzlREo+5WKoHS+sbE0lhPbj
        yBfn2y7Q==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mW2I1-001LHM-Ok; Thu, 30 Sep 2021 21:04:21 +0100
Date:   Thu, 30 Sep 2021 21:04:20 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Core Team <coreteam@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Kyle Bowman <kbowman@cloudflare.com>,
        Alex Forster <aforster@cloudflare.com>,
        Cloudflare Kernel Team <kernel-team@cloudflare.com>
Subject: Re: [PATCH 1/3] extensions: libtxt_NFLOG: use nft built-in logging
 instead of xt_NFLOG
Message-ID: <YVYYRCDylFqmFlWC@azazel.net>
References: <20210809194243.53370-1-kbowman@cloudflare.com>
 <YVVkN0ZNs5I+tKG+@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zyIJzBT/xElbnYmt"
Content-Disposition: inline
In-Reply-To: <YVVkN0ZNs5I+tKG+@azazel.net>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--zyIJzBT/xElbnYmt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-09-30, at 08:16:07 +0100, Jeremy Sowden wrote:
> On 2021-08-09, at 14:42:41 -0500, Kyle Bowman wrote:
> > Replaces the use of xt_NFLOG with the nft built-in log statement.
> >
> > This additionally adds support for using longer log prefixes of 128
> > characters in size. Until now NFLOG has truncated the log-prefix to
> > the 64-character limit supported by iptables-legacy. We now use the
> > struct xtables_target's udata member to store the longer
> > 128-character prefix supported by iptables-nft.
> >
> > Signed-off-by: Kyle Bowman <kbowman@cloudflare.com>
> > Signed-off-by: Alex Forster <aforster@cloudflare.com>
> > Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
>
> Hi Core Team,
>
> It's been the better part of two months since this patch series was
> posted and there has been no feedback.  I was wondering if one of you
> might be in a position to review it in the not too distant future.  I
> see that it is delegated to Pablo in Patchwork, but then so is every-
> thing else. :)

Having asked for feedback, I've spotted a bug. :)  Will fix and send out
v2.

J.

--zyIJzBT/xElbnYmt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmFWGD0ACgkQKYasCr3x
BA0R4g//djyfxfBSTBd6nTRlvaYsoxjrcbg9ylWV/QXzsHuwmrRRhQy3KrlobhEa
OP7xBPqMjA2sZ5XSQLFzgFSDuobeBBHmKO3hkwqregVr9G7cGXiEGo088yHduIIP
x9VzwIKwJckGRpUqBR1j6rQhGAq1Onw+JNsdP5VvP/YHLi2dQ6KyTwRZmgAuoy9A
3NZBJN9IYf966Ssb5e0MAR9LbdPmuN/YwZDFSE1qy0kEzjb56o/yDMUqrIJFKtTA
fCZt2DQURI7xkBFOJIOAVw9XNYPy5XzVyHFlNpH9ZoTsuh6eHXQmMkc8h/mYudt6
s4jTw2w/OW/HqK6CjxEidM0FU4ZvhQA5j7Y1vcyQ1ry7sRxinPZTi9uvSr0eAKNg
nJNWetoi5LYwWcCW3pIZzLLT6mb0rR1rMpzm2ua8CL/ch/RV99PJNArqbqqMyWIu
R4PWZlx6FWFHN5QlwF8eKkvweDdAxMAWixvwK07D5AGu8gEgQkcQKt7wmBO4mPT6
J3w+B3qZC/OIuDZvfUwFqVYMYWkdLv8s3dZYWWcEMCb+fmemOa+AjCS00MlzBIQl
WRTSHVXh7Sbv2h3hZTbdN3zQaTyOKh7cjLNyAHLpvW3cZtP7KzZlbxDrkT6tL0uG
lno/bbNHlRBbVNXPyY3fPmdX22YUm0mfwgABDtaTcEWVWscMJmA=
=HmPn
-----END PGP SIGNATURE-----

--zyIJzBT/xElbnYmt--
