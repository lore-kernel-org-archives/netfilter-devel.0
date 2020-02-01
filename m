Return-Path: <SRS0=IEee=3V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC79FC33C9E
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Feb 2020 12:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FA9820661
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Feb 2020 12:32:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="WX5V4D8i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgBAMcf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Feb 2020 07:32:35 -0500
Received: from kadath.azazel.net ([81.187.231.250]:41244 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbgBAMce (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Feb 2020 07:32:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=071w1eAdy9zpMuWebRIqF8ZmP/D0jSSZGUP4pZIIEsY=; b=WX5V4D8ispUYH5q4SQbKRC2TKA
        gTfYSOkVY5vJ0rs5DfLSdRcSf34EsrgBFxwQ2UYjnjf12M5ej7CN31RyvZe7VeTxxJ8VVuWFcPsXe
        Wiwh9TUOJrPuHITTyldhKh9EXtkkNmvoUuUPB8DgEbaSHVGfwbr3kQNxNX75ctG2NfNKmR5eM5T+g
        Y5mOO+T+vSmcJU6JTxje2ppVAEw+olTd8V9fMQV0509kMH4oDHdi2neKAtUN8MDytw9pAWKPOw2Dy
        jFl+6XKQqbOYrodwh/N0A7QI0mkvjkRy/7T/aoKzD73u/c0VQSk7htZL4dNTq3/EXdzt+2i7b1w+8
        8/uhRofQ==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1ixrwv-0007aU-L0; Sat, 01 Feb 2020 12:32:33 +0000
Date:   Sat, 1 Feb 2020 12:32:55 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v3 9/9] tests: shell: add bit-shift tests.
Message-ID: <20200201123255.GB136286@azazel.net>
References: <20200119225710.222976-1-jeremy@azazel.net>
 <20200119225710.222976-10-jeremy@azazel.net>
 <20200128192036.7os3dd4vwdvlr3qi@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jq0ap7NbKX2Kqbes"
Content-Disposition: inline
In-Reply-To: <20200128192036.7os3dd4vwdvlr3qi@salvia>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--jq0ap7NbKX2Kqbes
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-01-28, at 20:20:36 +0100, Pablo Neira Ayuso wrote:
> On Sun, Jan 19, 2020 at 10:57:10PM +0000, Jeremy Sowden wrote:
> > Add a couple of tests for setting the CT mark to a bitwise
> > expression derived from the packet mark and vice versa.
>
> Probably tests/py for this instead?
>
> It also checks for the netlink bytecode, which is good to catch for
> regressions in the future.

Will do.

J.

--jq0ap7NbKX2Kqbes
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl41b/cACgkQonv1GCHZ
79cRdQv8CqpUkKxrlTaSGfdBVABh7I/+IPP30LiYPt6O5cXgQEakGrNpY0M5ha81
hpu1Y0QBd69IdAuQxJUO5cKCrwy/3rXNL9XUrBf6OeZFLWDpQuAXl+gM5qz9qd2M
ggsfrWjkZclk5y0F4iudjZQLBEfnmzZpteg9QJqN55qWtHrd2TGiK8QXiy+/L3wZ
FpE9SyMZU/NzJxd27wEwgkfNmfPqIl2HSAA2dUkoDePh0feqqyqfAtOe/OUS1biO
nc5wsjTkGd43MlnkBDYNAhbU/2m3rMEcy2oGqZeENup/HXEyjYBCx0bhW+Ss9Q5O
QeN5j/TQTcJRObsUGGQYWvAVAqMC806uednn5PXZQO00XfCNWZmVBNIYsjAVm+s1
GnNFFtsX5DKwHnvl9539v5vCjVMbAVxzoADMo55nQXb+3EO/7x8HJYjjbFBHaj0T
2PerKME1WyduGb/Mx6cAnAMu4ZRq1KMScUEhlCrP5hC0nRw3ov5YkfgP6M1Yxy8z
PtqoVAzS
=PSCu
-----END PGP SIGNATURE-----

--jq0ap7NbKX2Kqbes--
