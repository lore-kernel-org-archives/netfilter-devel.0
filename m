Return-Path: <SRS0=4QBM=ZU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E263C432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Nov 2019 20:32:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7155421781
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Nov 2019 20:32:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="oT3Z7RhB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbfK1Ucn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Nov 2019 15:32:43 -0500
Received: from kadath.azazel.net ([81.187.231.250]:38580 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbfK1Ucn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Nov 2019 15:32:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OTdjpFMKWRwB3J22miibUheOlOJC3IN2w6p7jIe2CJo=; b=oT3Z7RhByW18iw/lJQFBmtnXNe
        tH4WxypN0Yqii8ImgDFuNbkj1BLELs2nuTniLEr+SDuVWbrggUui5d2xNU3wlC6aqo/2b4b8w+9u/
        vDziKnAWxkwChjPSSRsAwXsSXW8N+C0r/xRhp1emRlW+bRGDHS3P48WM1qwmt8Av9hx9d2TMgw2KF
        fgbpbU0GhzAKxnaKHCX4jDEqzUjgeZMpCYFrSkAU99h0AVBZhsQNryzvJmWme2kIZ/LVVUIK4N514
        cehjmkeqq0XoHnQbX9jAu6vT9pVwbQ6HFqxP+VXfcLE7CsArNTIkCwCxdvlLW0cKyKca6+rWtKpSY
        QkpqEt8Q==;
Received: from ec2-34-241-25-124.eu-west-1.compute.amazonaws.com ([34.241.25.124] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iaQSu-0001Ce-SO; Thu, 28 Nov 2019 20:32:40 +0000
Date:   Thu, 28 Nov 2019 20:32:49 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] doc: fix inconsistency in set statement
 documentation.
Message-ID: <20191128203249.GA9566@azazel.net>
References: <20191125205450.240041-1-jeremy@azazel.net>
 <20191125213043.zkkwfg6m7rned6v2@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <20191125213043.zkkwfg6m7rned6v2@salvia>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-SA-Exim-Connect-IP: 34.241.25.124
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-11-25, at 22:30:43 +0100, Pablo Neira Ayuso wrote:
> On Mon, Nov 25, 2019 at 08:54:50PM +0000, Jeremy Sowden wrote:
> > The description of the set statement asserts that the set must have
> > been created with the "dynamic" flag.  However, this is not in fact
> > the case, and the assertion is contradicted by the following
> > example, in which the set is created with just the "timeout" flag
> > (which suffices to ensure that the kernel will create a set which
> > can be updated).  Remove the assertion.
>
> The timeout implies dynamic.
>
> Without the timeout flag, you need the dynamic flag.
>
> Do you want to keep supporting this scenario or probably this should
> disallow set updates from the packet path with no timeout.

Having gone back and had another look at the code, I see that I missed
(or forgot) the fact one can include stateful expressions in set state-
ments, and without the "dnyamic" flag these will not work.  Thus drop-
ping the reference to it from the documentation is the wrong thing to
do.

I'll redo the patch.

J.

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl3gLugACgkQ0Z7UzfnX
9sMOOBAAvlvageZIuh05h1qOXO8FUMdq5T6pyUNKr59IkIbxBciiwRQiEgPTq3GN
oI7LPLO/Ra6O5p+JCFliKcGByYwhVe/9HmD6TlQZyOOWWteSaghSQQ6S9R4rh9Pg
uWBR4TxeAMD4BZa7AVkCWkEMA8YmfOvC8EAa2TXSgBhByYzuQSEI52+GHDK1BOGj
lUrsG4iec2djMrRcVBiuITRBNOPp9wz760s4N5SKaPKOyhbr8abHw2Sum7Q5FTSV
lZ5MsyIqlEcvRDWT6iT6/B8yvDy2L/lYwrbRbV6ISSKIzIRgmUD8Tyjj93SE66aL
ssoWaXDGG9llVGebaedd4FlNdSX0NK7YVLgKRLm2Vt8oYAK8BaT1UGcsePOZMjYy
JhMB5BoobR7NiyBY5rp3g1+5hJGFU7wzOfKu4wrcMA12GNQIfUB42phwLE8/UQyj
SsY4WyBWSXAFLbAfDfqa3q2k3ZA1I1GOZRzSMoHD2aQAE71/BPEcTjUFGolWkXkG
3YSQ9ax8JOk7RUn4ocUlxZJALKDVDPr2k6DUd5mC7H4ZxViTlTiH+QimYDutf7Gy
Pzwl3nQCjqOu4uPXnwE5gfI77zJxPtYat2E9kp3ceCB8pq2eKN1ejBuJBnC0ptgt
bh9TxF9HYKVafPNOpnmbTN1H60gYLpOjdHpDVB2aFnv1KhttIZs=
=bJDI
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
