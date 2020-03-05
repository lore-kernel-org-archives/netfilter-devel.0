Return-Path: <SRS0=H9P1=4W=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 605A6C3F2D1
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Mar 2020 11:36:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32A572073D
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Mar 2020 11:36:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="juvl6+Ee"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgCELge (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Mar 2020 06:36:34 -0500
Received: from kadath.azazel.net ([81.187.231.250]:48098 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgCELgd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Mar 2020 06:36:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=W8y0IpQGEVT4kIakqsTrC4F5sYKWFlKdULXgs9SQQWQ=; b=juvl6+EerewXWMxLLADIQfTC7/
        wrqu0v9vKfTI74FeelpvF5EPsdjaheoO67+4cY9BA3yzHWHoaIRBXcgG1SFWXfS7hgzs6uYbi87Zc
        WxJADCphjPDLTyIvRppYKe/emG0rPu4VsYN2ylb4RIkKI7rpzXRjwlaFmmwV5Canaq9t2Ype055DZ
        P4+gFwNDu/tCDzVuDBZo5zasNXhFhSV8n/7IleEVr7xZSDRCLKattFUksyC/d9+WtYcFDy6ASyRPk
        Og1SRtd6v0HiTp9qjmzbd8MRCrDoGCbxORV6gHXa4A3WStOxceHKTNdDKlHSqMYaHguwUd89Xxlc1
        YNwEawlA==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j9onl-0002Ci-Vn; Thu, 05 Mar 2020 11:36:30 +0000
Date:   Thu, 5 Mar 2020 11:36:28 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v3 00/18] Support for boolean binops with variable
 RHS operands.
Message-ID: <20200305113628.GA49820@azazel.net>
References: <20200303094844.26694-1-jeremy@azazel.net>
 <20200305105340.GH979@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
In-Reply-To: <20200305105340.GH979@breakpoint.cc>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-03-05, at 11:53:40 +0100, Florian Westphal wrote:
> Jeremy Sowden <jeremy@azazel.net> wrote:
> > Kernel support for passing mask and xor values for bitwise boolean
> > operations via registers allows us to support boolean binop's with
> > variable RHS operands: XOR expressions pass the xor value in a
> > register; AND expressions pass the mask value in a register; OR
> > expressions pass both mask and xor values in registers.
> >
> > NB, OR expressions are converted to `(a & (b ^ 1)) ^ b` during
> > linearization (in patch 9), because it makes both linearization and
> > delinearization a lot simpler.  However, it involves rearranging and
> > allocating expressions after the evaluation phase.  Since nothing
> > else does this, AFAICS, I'm not sure whether it's the right thing to
> > do.
> >
> > The patch-set comprises four parts:
> >
> >    1 -  7: some tidying and bug-fixes;
>
> I've pushed these to master, thanks.

Thanks, Florian.

J.

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl5g5DMACgkQonv1GCHZ
79ebKAv+KUMr2m9zoHgH9z3XnFP/c/LGTYD9PeypaRQNCJdniCuRXP1Sxbjsmz4Y
hALaS7pYgdJskkV2C71QoJE147Hw1dS6dsv34FtqB2syrsTtNTYoYymtoAeZpmQS
EWZRveqU0SIQ53bbtpUAImxXBxZxIEzM+eM/CR9fmhMlL9QXj82yQbFxJrez6JAw
L75jLNrRYYLjZaoyQeFCjXaBT9775T+X0rLYrYPXDLOLDT8RbVD3RTMItDNwZo58
4FEqlP+w44zdoNskQgrMxNZUxz9eSYRqdiRuZ7/UkAK9HrxIJvHYysvVI5h30U8r
2DWKe/98oGCyVu71UVk5mxDLJXG74Cl2WBChbaEowsU/WqKXROGMH8MRbR/bETFX
Rwnn3lwz1UpqVpvVAjvp8Tcz27PPQBRrIoufcq4YP5fw2MqkW7/ElsvZAbVB9hPj
7R2/LOEPeTsc0T6PHFQkRtNHuCVjBxreUj81S70LtqaPpv0Xa/Ek1JttoJvSGJ0o
EmAKTrQP
=K1zP
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
