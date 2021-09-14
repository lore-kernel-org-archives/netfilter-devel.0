Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD6A6C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Sep 2021 17:55:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A336960FED
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Sep 2021 17:55:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbhINR5L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 13:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbhINR5L (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 13:57:11 -0400
X-Greylist: delayed 565 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Sep 2021 10:55:53 PDT
Received: from dehost.average.org (dehost.average.org [IPv6:2a01:4f8:130:53eb::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E1AC061574
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Sep 2021 10:55:53 -0700 (PDT)
Received: from [IPv6:2a02:8106:1:6800:fc82:dec2:f8e7:4714] (unknown [IPv6:2a02:8106:1:6800:fc82:dec2:f8e7:4714])
        by dehost.average.org (Postfix) with ESMTPSA id E44BE38BFEBB
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Sep 2021 19:46:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=average.org; s=mail;
        t=1631641584; bh=R98GpoZBRohfRIwYSlX7oQk0JoUYG22nMCepoaQDWv0=;
        h=To:From:Subject:Date:From;
        b=bVsC2cnyrUKqQMgubhktRBVCDXAV6XDVZ//ZVhH/jVPBMV5Rv5eE5V6PadQhckDGo
         KDiZ8NvkLIOLCKMofEpxoWV/odIEbl/aPfwZyTKCaUTWhwfc2UJnVoEAVXZWsg72N5
         v3+OZGAWotVi41VfVnJFi67CP8oOdqN6OdlgBbRo=
To:     netfilter-devel@vger.kernel.org
From:   Eugene Crosser <crosser@average.org>
Subject: Python bindings crash when more than one Nftables is instantiated
Message-ID: <5dcf2dd4-0fdf-30d7-6588-1e571c486289@average.org>
Date:   Tue, 14 Sep 2021 19:46:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QaOiL4fRlVTzmRMHeS0XMwY2BPud0LTEm"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QaOiL4fRlVTzmRMHeS0XMwY2BPud0LTEm
Content-Type: multipart/mixed; boundary="7110Czb5OOmONoBhJTXYQXKJaHWJnOGmR";
 protected-headers="v1"
From: Eugene Crosser <crosser@average.org>
To: netfilter-devel@vger.kernel.org
Message-ID: <5dcf2dd4-0fdf-30d7-6588-1e571c486289@average.org>
Subject: Python bindings crash when more than one Nftables is instantiated

--7110Czb5OOmONoBhJTXYQXKJaHWJnOGmR
Content-Type: text/plain; charset=koi8-r
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hello,

it seems to me that this should not be happening. Use case is not as
pathological as it may seem: your program may be using different third pa=
rty
modules, each of them instantiate `Nftables` interface.

$ sudo python
[sudo] password for echerkashin:
Python 3.9.7 (default, Sep  3 2021, 06:18:44)
[GCC 11.2.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> from nftables import Nftables
>>> n1=3DNftables()
>>> n2=3DNftables()
>>> <Ctrl-D>
double free or corruption (top)
Aborted

Note that it happens on exit (possibly on the second call to __del__()).

nftables v0.9.9

Regards,

Eugene


--7110Czb5OOmONoBhJTXYQXKJaHWJnOGmR--

--QaOiL4fRlVTzmRMHeS0XMwY2BPud0LTEm
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEnAziRJw3ydIzIkaHfKQHw5GdRYwFAmFA3+gACgkQfKQHw5Gd
RYxOYwgArIsog5xX3kqsNcy0Og/fkyX4yyQO6ZD0n4gnyLuGi9mgaDRTQxDVdYoP
2CXYDMTMUXIisRqo0H1z9B101cNPgjitZtc+2HUPMNZ65yy/QJJsQPzqsxTNgYe+
xq9jZKye4DhraIZsjt3eXBpcjNyJie2wdGXrj4cEA26jcUxcmgS9tnz5ymiM9zXU
OTtKCmOHuZ1LirZvsDq/8AcJTJLva0UtWwHx4qj4/F4SqPAcUsyAyQ2DP6KzO2Ro
P25dX+TBCETPaX2nW2Xvs/3Wa+kaZ98OPOWIKkSMjzf7zXi2OJAvWQpD/8c+kv5X
0mqFX6KWSJCMQ5rKwc/h9UaGJmt4HQ==
=HkPs
-----END PGP SIGNATURE-----

--QaOiL4fRlVTzmRMHeS0XMwY2BPud0LTEm--
