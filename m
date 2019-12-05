Return-Path: <SRS0=LaOm=Z3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1DF8C43603
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Dec 2019 22:00:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0BED24675
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Dec 2019 22:00:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="mMyhiIKJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387395AbfLEWAT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Dec 2019 17:00:19 -0500
Received: from kadath.azazel.net ([81.187.231.250]:50272 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727236AbfLEWAT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Dec 2019 17:00:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OuPSiz+p9JASe2MbkB2eV8zrFq1h2IjFCzWCK73mP1I=; b=mMyhiIKJnqQYEzWx8IXzTUKhjW
        NTlR9LCBP7yWYJ+l+VbdHQ/AiP7uiIgeRYPGmczxbE/JXi8AtEBhP7v4oC8mP27a1TkoZEvrUicHC
        ljffQoFv8RME3NEEtfzN4NuX/jxsDJVNaSJUD5b6pCsjzTESt+yqoX9iRppydtnICs++glUAqSh50
        wHGpvVPZHBZh7DnSjCC+bk1/ayDrh9IV2raFgSvNjNFD8IcoGs6walLj96R8iWzZJLXPfKMRRM0Eq
        bsb4kCNWk1dITo1/DyovxyNJz4vRZRW+XPuwCQsmrCRWen1UDp8mJADnQYcIxnDq6WEmS7YYpk4n/
        MVruH91w==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iczAV-0001Iv-0p; Thu, 05 Dec 2019 22:00:15 +0000
Date:   Thu, 5 Dec 2019 22:00:19 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 0/1] netfilter: connmark: introduce set-dscpmark
Message-ID: <20191205220019.GG133447@azazel.net>
References: <20190324142314.92539-1-ldir@darbyshire-bryant.me.uk>
 <20191203160652.44396-1-ldir@darbyshire-bryant.me.uk>
 <20191205085657.GF133447@azazel.net>
 <20191205104959.GX795@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="z9ECzHErBrwFF8sy"
Content-Disposition: inline
In-Reply-To: <20191205104959.GX795@breakpoint.cc>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--z9ECzHErBrwFF8sy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-12-05, at 11:49:59 +0100, Florian Westphal wrote:
> Jeremy Sowden <jeremy@azazel.net> wrote:
> > Pablo, comparing the x_tables and nftables connmark implementations
> > I see that nftables doesn't support all the bit-twiddling that
> > x_tables does.  Why is this?  Was it not wanted or has it just not
> > been imple- mented?
>
> The latter.  It would be needed to extend nft_bitwise.c to accept a
> second register value and extend nft userspace to accept non-immediate
> values as second operand.

Thanks for the explanation.

J.

--z9ECzHErBrwFF8sy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl3pfewACgkQ0Z7UzfnX
9sPHww//RDpnbkGtv5yFp57tm6xOc7l1s+vBTEZvwNIiqBDlQbnHnfwesXSNj+V/
ca8g1CvL1D+AKsqADKic35r6HzHjEjB1Pi9FCG+Z8By2gerZbMFBaBj+F1TCUI6V
1wzWObZgzCCqUNTmFHd6gqlqUEtS1Gt/d0mXJtab1Qybj1KVpjA0AD1Nr89ynBHb
j3REmNG7Bydn0pJyp2kZ4TGK0QOg1CPZ2/LD6mbKYMavpND9RD8ZXeV/xr8ky6pi
vEeiR71l1ivY61IbGklaFxz/RrBcR0Gf5QwQa1emucncAwuE+pIvAAEmJQi2uALb
qKl3V8BiSmsPZS8fFRRwzOL8i5zjyVVrQt1igMyOPj4QqpOub7rwpjwbFB6rzwZw
RV7PlxP7NjN/bFa4nK3XvjCYBtbRBn6WT0/sYiaNiPUYdvHqcS0mKIndRVH3XfiT
jtTv5AJPOGEp/usE2RSBEqvSO+ePPqmzUIw/h0hU6vIKMsU0c8DabCQW58uTd6pc
g2YGXbeIeiJzp9kn6IVCuLoW4Az6IeAJ1U5uRTCSCPIUYCikvfJi9cqVLQ0VliOG
3/QQr0tKYxgFt9heWqHMRCLkxSQqcR2LE9fYrLJ7TI3+kC5QXZqti39EEMsBu63y
kdLcQjHEWdbXXbcE4+yQgWspxVPW4E6RY6cQK3vXLRScp0ufk10=
=vRWU
-----END PGP SIGNATURE-----

--z9ECzHErBrwFF8sy--
