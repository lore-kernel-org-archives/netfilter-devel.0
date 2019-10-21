Return-Path: <SRS0=/SeC=YO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54AB2CA9EB5
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Oct 2019 07:50:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DDA020830
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Oct 2019 07:50:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="UvpBEkEs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfJUHuJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Oct 2019 03:50:09 -0400
Received: from kadath.azazel.net ([81.187.231.250]:45480 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfJUHuJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Oct 2019 03:50:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2g0KJu3lfiAqq33SS9VQXKsglPJX/eD5LJAxN2HSiWo=; b=UvpBEkEsdFPjij+g7iBGlWtmGu
        cLVSnFxM0AZzcBQhdilxj9y/PeqGY7kTwItinFDR4qCiYBaEI7CTFXjikqxcDNRBIsds1TdwfViOX
        6TKGPAgWUNIlQee7+DQ3ObLkbtrPVyCRiWxQjTvY86MeudlRIRoL09a0MvhS5wLgG8fBzYOMm3flf
        set4n8LiKSi+pQHO2hof0v8cGdsOe3YSPhbaaHXtadxHqJrFJNx0OhZFS8gL/AXH+iOzmmUDZaDV+
        eYskS2I1Ww8ZiCqlPqJiz1QLjYpgMqcPFDK+YCSI602D5N6mZoR9PnPVDAXTKID+eGlYwdyBRbw66
        4vU2PnQQ==;
Received: from pnakotus.dreamlands ([192.168.96.5] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iMSS4-0003Hs-1z; Mon, 21 Oct 2019 08:50:05 +0100
Date:   Mon, 21 Oct 2019 08:50:04 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] src: extend --stateless to suppress output of
 non-dynamic set elements.
Message-ID: <20191021075002.GA28709@azazel.net>
References: <20191020194403.19298-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
In-Reply-To: <20191020194403.19298-1-jeremy@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 192.168.96.5
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-10-20, at 20:44:03 +0100, Jeremy Sowden wrote:
> Currently, --stateless only suppresses the output of the contents of
> dynamic sets.  Extend it to support an optional parameter which may be
> `dynamic` (the current behaviour) or `all`.  If it is `all`, `nft
> list` will also omit the elements of sets which are not marked
> `dynamic`.
>
> Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1374
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
>  doc/libnftables.adoc           |  7 +++++--
>  include/nftables.h             |  5 +++++
>  include/nftables/libnftables.h |  1 +
>  src/main.c                     | 15 +++++++++++++--
>  src/rule.c                     |  3 ++-
>  5 files changed, 26 insertions(+), 5 deletions(-)

Haven't updated the man-page.  Will send out v2 shortly.

J.

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl2tYx0ACgkQ0Z7UzfnX
9sP+Yw/+ODtPy04RI0D4BP5M95hiaqv61iTHRfEDTYBA0af9ewcPVTUdze6r0QkY
idhQHXZOgr9cZSxZw/jRLmIsywOkn1tfjGOAkXVeCktS+gjfIvksm0DLZBdNG3Y4
kVv/aTzBk7+cnug2mlxzNKL4AGDCS6Ex36a1zary6Etbzzhq+cU9L0SGVg9uJjG6
m9vv1dVtq4eQUJwOsAmECXr/B1RQq0SVOBroSWRCKa/ga+gfKpfbca+SaWaaMsy6
5X13TpKB6yytikLZ/vzA6+uZykLGJC2NyvhYZPCUkVW/X2A6+D7SMRr+Nnl/r2h0
ID2XapYvSCmfChCoKgLiyFhUba3M4eD8yv5RoVokZuJIn+Kxf4mZ7p+C1gzKFnvH
m5nR4cxiKpvRBprkAVE9MKs4mQ88bWLM9fyfSfFku7OI+zOPqPbiWvrFIGVM1P6Z
5A8Blg1FsPwqSvyKCgLa0wT4ILcljwCt6mME/CJ9sD5ZqFtMkYC7HC0KEUVtQybe
xr0OXwncQ/Q7ZNNqJ5sC/hFsSVy62nM9YJuW02JOSMJrhpSQFDApZqEXqFdACcch
whc8Tg91/hHLPoU6uS82Ul3jsO7V4vd+nNGjgNqrzTUVDUCqCI1NuN/71pyXiW14
7IWAjmN/RBk7vfq1gfnDZ+62TltOnSz9jGFfBLhtRApPZCb8e4M=
=10sz
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
