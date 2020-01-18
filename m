Return-Path: <SRS0=S009=3H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A53BC33CB1
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Jan 2020 08:58:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4E7B24683
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Jan 2020 08:58:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="OmNwj5Ii"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbgARI6D (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 18 Jan 2020 03:58:03 -0500
Received: from kadath.azazel.net ([81.187.231.250]:55264 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726543AbgARI6D (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 18 Jan 2020 03:58:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zqj4Hqt+QQykLjVn8CC4eROln+rCrurKSa/jlermQbU=; b=OmNwj5IirRdMEwbFeZZkzEeYmt
        16HNsrjn2xPydExeb0n8V/O/eysi51Ic/t5CX69qm33+4t5n2/B7oIuCJdIPaVrROioLabpW4vJF9
        vKN9MeDaaTBQYfkeXdWGCBfHPgw3Um58nmQoFDOePCdvgIvZu7Z9CwnC0gwhL7D29u5S79t9H23if
        SI2H/AIwOADYHnBHBQUp/mMf6JRMSHqTtXoH4FastAzEY0Mrj9yxujcmeCJjHTjRNHBT5Dbrdat2j
        HQoTKh8+qHDGauFWnKU/60LyQMBQPD/WzRAM9oSsge/FOHzG3qRPybL4eDqQEH+ScZJ1U3BsXSJ6/
        7hRNBjwQ==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1isjvd-0007x5-J2
        for netfilter-devel@vger.kernel.org; Sat, 18 Jan 2020 08:58:01 +0000
Date:   Sat, 18 Jan 2020 08:58:00 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnftnl v2 0/6] bitwise shift support
Message-ID: <20200118085800.GA1416073@azazel.net>
References: <20200117205808.172194-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
In-Reply-To: <20200117205808.172194-1-jeremy@azazel.net>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-01-17, at 20:58:02 +0000, Jeremy Sowden wrote:
> The kernel supports bitwise shift operations.  This patch-set adds the
> support to libnftnl.  There are couple of preliminary housekeeping
> patches.

Changes since v1:

  * updated to match the final kernel API;
  * split the single patch that implemented the new shift expressions
    into several smaller ones.

> Jeremy Sowden (6):
>   Update gitignore.
>   bitwise: fix some incorrect indentation.
>   bitwise: add helper to print boolean expressions.
>   include: update nf_tables.h.
>   bitwise: add support for new netlink attributes.
>   bitwise: add support for left- and right-shifts.
>
>  .gitignore                          |   9 ++
>  include/libnftnl/expr.h             |   2 +
>  include/linux/netfilter/nf_tables.h |  24 +++-
>  src/expr/bitwise.c                  |  93 +++++++++++--
>  tests/nft-expr_bitwise-test.c       | 204 +++++++++++++++++++++++++---
>  5 files changed, 304 insertions(+), 28 deletions(-)
>
> --
> 2.24.1
>
>

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl4iyIsACgkQonv1GCHZ
79eCLAv+Oxagte3e4s9Qj8mhVHQe1BQskiu99hLme6OrE1wPYIsOkYXDf3d5v77o
PR5Hc8cQJ5NzRW8XDKPcY98uqEeFMTrWxZahbzD9tEcxwgg7C7Rv5+U1IXVSLpGN
emeGzHeH8CQ1fZvD5u5EjYbToZjMVOG2DEi+W8xJ3uw5NyXEt44YKtWDigX8/Vk/
Fydvz7Wrku+c0KleR2OLaPk206ee/9mZfZNYEJU+HskN+TDuIu3dQid3XlvWEnsg
w8Z0nSuCXtsuGrb1Po57TkKHN1Nr/XwdUgs3IqLpfrcKfnKRPkEfhIHKl1CpjnF+
jn53Ur5FCTyIYo0wweSzg+O9A3Z/fTv/T6jNkW5I6U4c7kZufhf9QxPsMUtY4H2g
uBCUqXaSzwYGUmrvlRTjcvG6bFtx2O1T5nYI9ZKa4QjPkSW2CWvCJDSngvLXbZkO
dfU7l8KR/FQstuI4XaDYE7uTPXIuPZu//TEgeC5uHLP7MCKnI0BH2JOvtZkbJODk
aaHibteG
=366V
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
