Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 287D5C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  8 Jan 2022 20:11:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiAHULQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 8 Jan 2022 15:11:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232644AbiAHULQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 Jan 2022 15:11:16 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88067C06173F
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Jan 2022 12:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4OAe38Lf9GmkzAWAcAHzSCEcGhsrS5zaj9srGYKRDa0=; b=B6Jjq7ahcmr3h1/KuVfxyOjEbz
        CysZ/uhSF+vRb9udzD3FkEOb7ipmB9eCai9Ty11MKjwhpZ0mo3muEIgdFdUbxguD+gko8VsvrxTG8
        StsX/odDlxOlDwlvXcCpN2ED3JcSnSnWd5HQK1HpF0HZVS4ctKgwb5gCok5n6Li4dviJF2Xz0OKvt
        OTX1GPn62ZdMOteTEwqsHOeaDpVMIYk4+T0CYMErsnbyqY6EernZ5GErO2xoaLtgcrMlfYlcskd2b
        QJD2SyZ+ZAX0LYm/iuuCEXrS4QeAJynAy49cX283POgzRPZlj2t8aOGXuf7V/pKFd4u2c6jy3iLFK
        PlCBTBQw==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1n6I3V-001MK6-4v; Sat, 08 Jan 2022 20:11:13 +0000
Date:   Sat, 8 Jan 2022 20:11:12 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [ulogd2 PATCH 03/10] build: use pkg-config or upstream M4 for
 mysql
Message-ID: <Ydnv4PFW/9urHq7K@azazel.net>
References: <20220106210937.1676554-1-jeremy@azazel.net>
 <20220106210937.1676554-4-jeremy@azazel.net>
 <q6p24q-47r9-p184-69s7-165p7264o123@vanv.qr>
 <YdnEYem+9arx088i@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gLJY43Qv106BOoaD"
Content-Disposition: inline
In-Reply-To: <YdnEYem+9arx088i@azazel.net>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--gLJY43Qv106BOoaD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2022-01-08, at 17:05:37 +0000, Jeremy Sowden wrote:
> On 2022-01-06, at 23:15:31 +0100, Jan Engelhardt wrote:
> > On Thursday 2022-01-06 22:09, Jeremy Sowden wrote:
> > >+    dnl The [MYSQL_CLIENT] macro calls [_MYSQL_CONFIG] to locate mysql_config.
> > >+
> > >+    _MYSQL_CONFIG
> >
> > One caveat of m4 macros is that they may be left unexpanded if not
> > found, and it is up to the tarball producer to ensure the m4 macro is
> > expanded.  Over the years, I built the opinion that this is not always
> > a nice experience to have.
> >
> > I would do away with _MYSQL_CONFIG and just attempt to run
> > `mysql_config` out the blue. sh failing to execute mysql_config, or a
> > compiler failing to find mysql.h as part of AC_CHECK_HEADER is a nicer
> > experience than _MYSQL_CONFIG being left accidentally unexpanded.
>
> I'll use `m4_ifdef` to add a fall-back.

I took another look at what the macros in mysql.m4 give us, and all we
need is what we implement for libpcap and libpq, so I've updated the
mysql patch to match those.

J.

--gLJY43Qv106BOoaD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmHZ7+AACgkQKYasCr3x
BA2lqBAAmjN6MsD752+zJg5iHMx8VCuHX/D0zJ5Ts95fXRC1oc4HHOirD8fRCk3y
CrxIhJf6w/ybgJWrTJ6+/CeM3L7bmlPYRVZBI0zq/C3jVk/6NYH27HuTx/rrQPyh
1dZ/vsqgZrub+8SYCAubHZSvW4L6oPVgqkZYvHncV/RZ9d7YSJ4d5QHEoyuOqO64
XmRj/AGnXylwIZ8lOajdIZXx5B5lCuXo/fw0szbyeTfLjxtT2s21BE70gjevL6fw
ajwSTe9IBCtcdYzcpoa3bWYuX/VSiUh43ze4GJo/VwGsjKSUV8sROObezSkwdodt
VgNus5nrD9Tdh0dzNprAHb0RuBHbKO8MNyUfbw+Y5MRmTzDyA276LNoEJG97m5vE
yLkp3KPJoBG3Aaatu+7XicZW6yl2+xWvEnOxC8S5noSLf7A3DuiA60rjaKm5gKcI
xbeYyAuVq/MaTNFOPiwpP8RSKrut0MaMxmqSGdlrEK2o/Z9WqqDwoPN1uyk6zpDn
veNwVHuGhMIihFlhbWGjAuiIy0mMraBc+7GJPFtYLGAC2LhQ/kbo2f93avnZKYte
5ToxsHzJoSL1YhEh4nBeLS+60eAsR6UVlUP4AbNmqXa9EMU4KOyNAFDNuLQJg6Jn
PibBd37mre1F8N6TqEwy2u55+E0KwO9JRynAHB+DKgFC/C3m8u0=
=zOYZ
-----END PGP SIGNATURE-----

--gLJY43Qv106BOoaD--
