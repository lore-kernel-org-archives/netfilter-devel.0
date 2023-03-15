Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91ECBC61DA4
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Mar 2023 21:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbjCOVte (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Mar 2023 17:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbjCOVtc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2023 17:49:32 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71D21BAD1
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2023 14:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yJiDgQZr27aCa/Tcw5kxALoFfuHVRHBCG4hO97PihLQ=; b=KSN8+rx1J0FqY9cZRXbuu6l+K1
        Ozp5cA5f8owgGFYSjDfAv/oryrK6vgiJ94XCynxocYfciNgzaEKG8wycvpHGMLDSCirQX3v99LRW2
        BKR6qr2VAidB08bGKsUYwxxfns5tKohuYTeea5BdKoxFqQIApWqq2M57C63ZcLDFd+B7NFlVblixN
        a6QmozFqISdWw/Mg51mbF/iGMJz8Vb3QA9Q47XmEY9hZvU1lAzrvIYvAh7oQbAtiAeOAOv4uj0IaA
        O/snuVxpCNPaFqH4bR3OMhFqkXvPj2xIsr+AlLnYJgORH6dbGpghjqthUwcEiDdyiHHdM6WLIXeTl
        VyxsRlnw==;
Received: from [2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] (helo=celephais.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pcYzu-009szK-RW
        for netfilter-devel@vger.kernel.org; Wed, 15 Mar 2023 21:49:26 +0000
Date:   Wed, 15 Mar 2023 21:49:25 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next 0/3] NF NAT deduplication refactoring
Message-ID: <20230315214925.GA4331@celephais.dreamlands>
References: <20230315214735.236444-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="D/eQmBVEU6iP98/N"
Content-Disposition: inline
In-Reply-To: <20230315214735.236444-1-jeremy@azazel.net>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--D/eQmBVEU6iP98/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-03-15, at 21:47:32 +0000, Jeremy Sowden wrote:
> These three patches perform refactoring in NF NAT modules to remove
> duplicate code.

Whoops!  Sent v1 out again by default.

J.

> Jeremy Sowden (3):
>   netfilter: nf_nat_redirect: use `struct nf_nat_range2` in ipv4 API
>   netfilter: nft_masq: deduplicate eval call-backs
>   netfilter: nft_redir: deduplicate eval call-backs
>=20
>  include/net/netfilter/nf_nat_redirect.h |  3 +-
>  net/netfilter/nf_nat_redirect.c         | 58 ++++++++---------
>  net/netfilter/nft_masq.c                | 75 +++++++++-------------
>  net/netfilter/nft_redir.c               | 84 +++++++++----------------
>  net/netfilter/xt_REDIRECT.c             | 10 ++-
>  5 files changed, 96 insertions(+), 134 deletions(-)
>=20
> --=20
> 2.39.2
>=20
>=20

--D/eQmBVEU6iP98/N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmQSPVcACgkQKYasCr3x
BA2RlA/+Md8hv4eCRHBIlYyY7WLEB9mb769N7naIHizmhliWh2sE/+JfZsSkZl8S
/WZU2V/pPX9MZ2U2/uWdwKn1tEsX3mFaNiaW8xURWtQFPziuyuA9SeWkpEsLxlo8
7O0pYU9ze6+D12xwrGhnIWQipB4TNKqircdTsGBTGRNwEykZxewnR+CDfQZx7Slc
xcoifwVVGye9cdD6tOycszmBy+3B6G5doloxMCew0QjL6FTtRdBCKlcXm/g1VGEJ
CYHRSL8m+U9lWQx/iOvIXsQlL8SV3pb4v3QqmkP3uYPu2Em3hBPiTyP0xlNGNN+H
FBDR/OLeUwH0MOZaqozEIvO1YvMTOs2f2j97DxPYCP35phkwD1Vx6ipnxZq8bZsL
sAWVanung5lX6DGEsNoaO8j9RZEep87ObfMX9iUqNGxqzvx3ojlcwj5iPvMs5+ZQ
6HTYhh77GdR7cO4QLKluXRemdgqukO+LLuJAgviVs7pclXQVqoq8uTQn+LK4P8jk
2W7etKx8k+8ecdKM56Gsnm2AQxbB+iHLD8+vNfPHkKXZEf/gbhKHaq/WS4IQAON5
1O5MTac3n03egDTAvHwmLyEMnGZM+K1f85fE5B4NwJ1Xl1SVFZYOUT9Kd4WeAIUd
xyPcPAcefZVItXHs5nqdgW/86e8eJ9Z5w8zctBORvobtWcN4a8Y=
=yqDq
-----END PGP SIGNATURE-----

--D/eQmBVEU6iP98/N--
