Return-Path: <SRS0=fe67=44=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7D4FC10F27
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Mar 2020 14:35:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5EBC20575
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Mar 2020 14:35:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="habwRYRV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729798AbgCKOfk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Mar 2020 10:35:40 -0400
Received: from kadath.azazel.net ([81.187.231.250]:55162 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729473AbgCKOfk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Mar 2020 10:35:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FGRlqSuKZ6HisQhIbsXQrX4d8pXaJWB1TvyZmjL9x0I=; b=habwRYRVEelYpeNZpMFRXQrB9k
        ym5rPLZF+7pw+h3cwXf3Htld4kYq48o9E2KY8qy+QTk0/KD6+XK+Oc667v+o3/Mnw45iIguE4lyia
        rfBJD+852fx3Dp4oihZi1NtmvGibq0n58JGFKT2iQwKPcet0g/zMdK/2jSTFFBL49w5vpFZAG9ZDp
        eeHl+wapquOxlCxE9/XB0FWLEY/XNtxibq0gjZF0F3e3s2ZEH1PfITqPEoq2r0nMq+2+AVdN1HN6R
        OFlDCslWILcAJrFOPaqJM+e4vSF+Yw6H1mTx0T1lOROGu5j/EBkt1Bo19NPpJ9ryLnZjIX4oPS4Qe
        IRYH8MwQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1jC2SO-0006fc-II; Wed, 11 Mar 2020 14:35:36 +0000
Date:   Wed, 11 Mar 2020 14:35:35 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v3 18/18] tests: py: add variable binop RHS tests.
Message-ID: <20200311143535.GA184442@azazel.net>
References: <20200303094844.26694-1-jeremy@azazel.net>
 <20200303094844.26694-19-jeremy@azazel.net>
 <20200310023913.uebkl7uywu4gkldn@salvia>
 <20200310093008.GA166204@azazel.net>
 <20200311132613.c2onkaxo7uizzofs@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <20200311132613.c2onkaxo7uizzofs@salvia>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-03-11, at 14:26:13 +0100, Pablo Neira Ayuso wrote:
> Do you think it would be to keep back this one from the nf-next tree
> until you evaluate an alternative way to extend nft_bitwise?
>
> commit 8d1f378a51fcf2f5e44e06ff726a91c885d248cc
> Author: Jeremy Sowden <jeremy@azazel.net>
> Date:   Mon Feb 24 12:49:31 2020 +0000
>
>     netfilter: bitwise: add support for passing mask and xor values in registers.

If we do move away from converting all boolean op's to:

  d = (s & m) ^ x

then it seems unlikely that the new attributes will be used.

For me, it depends whether you rebase nf-next.  I'm guessing not.  In
that case, I probably wouldn't bother reverting the patch now, since
it's not big or invasive, and it wouldn't much matter if it went into
5.6 and got removed in a later patch-set.

J.

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl5o9zEACgkQonv1GCHZ
79dLTgv/axql/CHhT1wpk+2Nhob+BqZRUMeYdH/OjvcxUuYTT1mDiQ0zxiJC8lA8
ky1AtS724Wt98fjwBDOjavEV1VIKpTP9Ldxk/hlfToUZuNB51PbLljBlciFromsK
DKtiDGhgYJS16G4kIirL90Qt0ww7N1Q7McWM8TWAopA3Kq8VuhdIMETyvQ5Y8U9C
LAS5Fk5yakk+jZwr/UEiPtiiIiXt+HqtlGsZbIVpdWbAm33ImPdNjD18ZdEffqmY
iND3AwRJdhmuPdSP/OhIqOBXVm7nzK8TnBtCTCA4C2e4+jtI/Yi9txHRcwiBfjHy
oP+4IOEulK8C+FSBnpT+WzVTHmGv96ppWAZC/J2/kKv4Zq4eUDgbrsf/SwxHuh5P
ss94xVWp+K6DT/N2vWf7VecrwgGBujiPXdLtWtY6P4HD5YW7fvU2XvgiE4Zd3Zuz
8x0PmCyhlKPduVGPC89mioZd8VK5+TH9gHB98PiXo4DPXZI0Cq5chpkVf4g8DmHd
223TZ0tv
=eEtM
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
