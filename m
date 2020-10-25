Return-Path: <SRS0=hvDf=EA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA71C388F7
	for <netfilter-devel@archiver.kernel.org>; Sun, 25 Oct 2020 10:58:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21077222D9
	for <netfilter-devel@archiver.kernel.org>; Sun, 25 Oct 2020 10:58:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="uLUBQY/c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415319AbgJYK6b (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 25 Oct 2020 06:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732573AbgJYK6b (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Oct 2020 06:58:31 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672E8C0613CE
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Oct 2020 03:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6h5X2yxjl/B5yPBsFLlYUWkqeOTo7X2oZuzRPiu6p+g=; b=uLUBQY/cGkuRCRW2FsyNJ8SUz+
        YfgbQxyoYWknkekjjV4zoYNGqZ+ubMLEpyDdvecycgU5V3rjdF0KjdKSlC47OFIhchPYpYCppTfwv
        5PwTxlWyx5hzjkHEI+VNw1h4gBHPJubPNa2VvfNoEyxmaU9yS5+1jysyMkFDgqxlYhmtwChx6bZTi
        btCoUPqXInQDJI1utPUkxsnW9xdVV2n4XjIPREe/s9x/uvi/j3PcZBmbhHeFuozu4QfdXia9igeBW
        XKT9E4EkpwVcn6uJVrfdWu0NUlFsAeadqV/w+ZEWHppcjSMogDY72TnVAqELAXLMqdeyfRsroDpS8
        e6eG9jKg==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:5ec5:d4ff:fe95:cee6] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kWdjG-00039c-UK; Sun, 25 Oct 2020 10:58:26 +0000
Date:   Sun, 25 Oct 2020 10:58:25 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH xtables-addons 2/3] pknock: pknlusr: fix hard-coded
 netlink multicast group ID.
Message-ID: <20201025105825.GA5964@azazel.net>
References: <20201022173006.635720-1-jeremy@azazel.net>
 <20201022173006.635720-3-jeremy@azazel.net>
 <3ns38p0-1pp5-3185-5r96-rqqo2r77s8p2@vanv.qr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
In-Reply-To: <3ns38p0-1pp5-3185-5r96-rqqo2r77s8p2@vanv.qr>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:5ec5:d4ff:fe95:cee6
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-10-23, at 11:13:45 +0200, Jan Engelhardt wrote:
> On Thursday 2020-10-22 19:30, Jeremy Sowden wrote:
> > The group ID used by xt_pknock is configurable, but pknlusr
> > hard-codes it to 1.  Modify pknlusr to accept an optional ID from
> > the command-line.
>
> According to netlink(7), that is not a group ID but a bitmask of
> groups.  That changes the semantic quite significantly and would make
> this patch faulty.

Yup, v2 will follow shortly.

J.

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl+VWkMACgkQonv1GCHZ
79eU8gv+Oq0QCLNtyTICI9LguMi9bvkw+LJGob5yDbdKYZJj+O+Ys3lHX2sopJHg
IPUspxg7cv363+DPIjKVfqIkIXutBt2sjWYGGzZhUO3XdEentBJpuM7vEfmIgA5L
sDOJsciogELOIMPdfjdWx6KAwE0MCNjVdnCSbxkX+LIPpkAmACe7+H8im338UEGz
kOhr7+fD5oXsgHzADr8srUtJGc/N+eHG2yaJnYPgL8iK6IWWJ+icg+gMZVFE6tbs
iRAb1GQfJ3O6Aaedj6pgRjaNVvjlPGo+f2ucxYvNSfLzmJKTbyKXshUWlij6Fszh
dzuhyaQk2T+4kZQ16x8wtO4u7YBff9u4wT6kfknNpOV/baXB0nfiwIPJI8jqGLaA
R1nqrAlSdQcVChudcWMLbxutKjXVZXSXczcZ1/OGs7v9bdUwUgz9Rpph/LJpV/bl
OTkpk5oIhIbOhh62anOwQ/VDo7yrgK0m7sm9kTWDRzJTAEqs9DmqSweqKGaImtqW
LaKjIThp
=Rs/x
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
