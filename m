Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D70A0C6FD1D
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Mar 2023 21:50:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbjCOVug (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Mar 2023 17:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjCOVuf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2023 17:50:35 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2217510F7
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2023 14:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=D68fgn6CRtexpS8moeozncsoDQm2KFWzcMRpBLefDiU=; b=PkLXemLRTxI0byRzTUa7UJiq98
        XiaNQTqvxtldcmwaRm4jcW1SAqThtvL3KcxD/6C+s0pkoPPP+VZGu0F0HSUCi4IGEvTgSHAuolOgd
        vv6XjrgfsN1NG4Ll1oDwgsu3/5VQHUnOpHkXpBf+9Sw8F8GAlJ6x9WATxmKqw+8TOFtJjsm9HHj8R
        kdKQJfIuhq68m+HmCPTAESEmZb6fNv1spB8IZFtC6pngGJHBCOXr0VU3evdbs6HEc545xP1NHkuLt
        f4MkeA5fHH7/8W0Gtp0Ow/6UETuVqVsm2Dkej2STgkK58y3vBUux5ptxJPgBcDdznSqzKYH/RWsJr
        D2JDu+cg==;
Received: from [2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] (helo=celephais.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pcZ0z-009t03-Gr
        for netfilter-devel@vger.kernel.org; Wed, 15 Mar 2023 21:50:33 +0000
Date:   Wed, 15 Mar 2023 21:50:32 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next 0/3] NF NAT deduplication refactoring
Message-ID: <20230315215032.GB4331@celephais.dreamlands>
References: <20230315214735.236444-1-jeremy@azazel.net>
 <20230315214925.GA4331@celephais.dreamlands>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="W4feZ30kBK465k+v"
Content-Disposition: inline
In-Reply-To: <20230315214925.GA4331@celephais.dreamlands>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--W4feZ30kBK465k+v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-03-15, at 21:49:25 +0000, Jeremy Sowden wrote:
> On 2023-03-15, at 21:47:32 +0000, Jeremy Sowden wrote:
> > These three patches perform refactoring in NF NAT modules to remove
> > duplicate code.
>=20
> Whoops!  Sent v1 out again by default.

"by mistake", even.  Duh. :)

> J.
>=20
> > Jeremy Sowden (3):
> >   netfilter: nf_nat_redirect: use `struct nf_nat_range2` in ipv4 API
> >   netfilter: nft_masq: deduplicate eval call-backs
> >   netfilter: nft_redir: deduplicate eval call-backs
> >=20
> >  include/net/netfilter/nf_nat_redirect.h |  3 +-
> >  net/netfilter/nf_nat_redirect.c         | 58 ++++++++---------
> >  net/netfilter/nft_masq.c                | 75 +++++++++-------------
> >  net/netfilter/nft_redir.c               | 84 +++++++++----------------
> >  net/netfilter/xt_REDIRECT.c             | 10 ++-
> >  5 files changed, 96 insertions(+), 134 deletions(-)
> >=20
> > --=20
> > 2.39.2
> >=20
> >=20



--W4feZ30kBK465k+v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmQSPagACgkQKYasCr3x
BA1jghAAmyU49rpK0p4La5CXRP+djby9BTQ3zvlZl5FaNIRm/S/BtHv2qH+t7gJg
fyysVR81M1+cuvxjtsVE3lxcS94DTIbC31SPLYP+GZQ6xTiJUHfLuyZ0/rzQzTSx
K38zWZdiJr9yl3a5BwRqPOhuIatrhyYyBFOy1dK5XevEPBYn0sNkgPQZGUM7E9Og
UKCyBn+OplZ+qansQdMGaK89PkdXvG2MgLOUtueIEcVKyU+p0A8h8L7EmGRU3axp
Zy9KVYgdwmJl08gr/NJu9fCKJh01wF9BBZdzPwDFamfoW++1enO3aGQfU31vFBor
hiOeALdClVfJCadsV3z41zcL9QiQZGFjhBF7vLKKPxJXXjOkhnCvFllNWoiEjgyh
8W+XoTHC1ITg/3259qz0WAjtEbCei9IM4bnZldWofGNdxgyJoniUYBN0lwfyLS5w
ju5eYRrFRQU4yl9bH/0V8RxK8BOh+3gWBbvWORjdKy9fTp62XgNrwNsKtcPdyOjC
JqfvIiXd8TkmhRiISetdk6Cct20qKlKcygHKxPVPuibeWsmLIyezz61y+4c8nMp1
nUS0cBRAQnccZo6Jx3r8NNj8dM3pv5cvlFutMo/T/GJs0iZkcE/i9nj7fdlSdtpt
nbvbEH51fQlLCUnR51gMRH0KvdHRTnfI6eNpU0+Ae7R4QKXlcno=
=C+YR
-----END PGP SIGNATURE-----

--W4feZ30kBK465k+v--
