Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BB97C6379D
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Nov 2020 17:29:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6264520857
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Nov 2020 17:29:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="ilOkysYO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390887AbgKXR3H (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Nov 2020 12:29:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390885AbgKXR3G (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Nov 2020 12:29:06 -0500
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA93C0613D6
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2020 09:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DcXwpyoZ3zLIsEUoP+wcbm6Ufw+LI94mFH+W32uQVrc=; b=ilOkysYO2kUy/VSOhszI/t409m
        YRLqaeI8KdQyw2fgQTAxP+XFwaH1QjgHZFEBXRQU6gxp5D4fLhT/5p+PiEylTm1A1ETi47UMXBVPN
        aEpAWDFgFsXZNMZbfo9Y7eB6IaVU9ZZAOUNgKl0ohsnitjo+hk0AVLbVzhZEz2pBMl1h/drQ53VdZ
        I2HVikQ2UZ5EgcZPpHjO4Bw5nVmO1bONfot2e+e/T9aNBp+P67hB0FaBAo/907oSFXv8XfUOontdX
        RM0GhowmGWa3VUA/y3nNjR7cIS1Dl2ei+iFjX/cxV/Har327DMhYJgVkHUAyoFP6Z6U7KS07KHPE3
        sJZYCDNg==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:7c7a:91ff:fe7e:d268] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1khc7j-0005yp-SE; Tue, 24 Nov 2020 17:29:03 +0000
Date:   Tue, 24 Nov 2020 17:29:02 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH xtables-addons 0/4] geoip: script fixes
Message-ID: <20201124172902.GB807877@azazel.net>
References: <20201122140530.250248-1-jeremy@azazel.net>
 <702191n9-1n33-9027-n968-nqs36r0q288@vanv.qr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <702191n9-1n33-9027-n968-nqs36r0q288@vanv.qr>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:7c7a:91ff:fe7e:d268
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-11-22, at 17:55:03 +0100, Jan Engelhardt wrote:
> On Sunday 2020-11-22 15:05, Jeremy Sowden wrote:
> > A couple of fixes and some man-pages for the MaxMind geoip scripts.
> >
> > Jeremy Sowden (4):
> >   geoip: remove superfluous xt_geoip_fetch_maxmind script.
> >   geoip: fix man-page typo'.
> >   geoip: add man-pages for MaxMind scripts.
> >   geoip: use correct download URL for MaxMind DB's.
>
> Applied.

Thanks!  I only see 1-3 in your tree, however.  Was there something
wrong with the fourth patch or did it just get mislaid?

J.

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAl+9QtYACgkQKYasCr3x
BA1AMQ/+JS7fVEwxu/M2pM7tR225UxG9QDKkKzdkxADdMAUCBCkogAP3NYyHpFnu
u864IGqlf5jyD4c1DgK0bpRUsSp52tb6quoknzqve63wNXvEIHfLVA5p7RXwmdYy
7/oMI4++0SkulSobcV9nHSjVwnJMcb3sBFNcVOLdbJCPpEFroXgjN4OLqelG73kx
BWJ9N+qAkJy05MJHNDPoxrm2TPlj8zMljFlu9GjYODYW9sXswRLQQRBMLzRDHSXe
CDvsrHwFP/PtbePNxQb5lOf1baudCwmZXfjofac5o5WKaK0xd4b68opLoR1akXrB
bqfyHBJWepwHRkpi9OZ8SyFYBn/UYkgzmNRrTEtkHg0GW0Z7KyzPQjdVYi0k0Owh
BjCHNbeRkbmOtw2SCtiIhg2ivmEIPJkgbgzSZIP0PRx+VUBblx0JhdT4aILJotWa
JurEkn+aYfgZqON24GBD+Dmd/eEJjNRlnjy5tfB6pOGy8IZOyFlVCnxtPaJLmGQX
VZFj2FJm9rmmmyw+If6mGZzdtI3NfNf27zjckATspM3fF7+8C78+aLY3eYLi1WPc
jLGRFxsf2q0T0fh3gQvVRaPYv/6T6lLgH9gzSg2QPfyx4bbJPK3QycUr1CCHcPew
i6B818myI8/mnvXgkMffG3LlJjWHs8DYPORExZ0SD50b36RXJ+U=
=y4f3
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
