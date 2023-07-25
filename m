Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49A0EEB64DD
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jul 2023 19:11:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbjGYTLd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jul 2023 15:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjGYTLc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jul 2023 15:11:32 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8192C10C9
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jul 2023 12:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
        Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=AHDYLVkqgOruaivlXTpI3H+su6YeZaeOOwpr7gzLsWU=; b=BTbi5Hbk6zR0HlxQOXXbHgDYka
        mqUgLZVlKdGuLEGMfXHfDn0W/izPGjnuebkHsOefH5eEq+78nX9tGtjf2u+0jW4W42zvu2RFpteO2
        zXpeqEvulZZ/yKRnk7CrHXR3nOKxaea7D+zx9ECxdZ7+ibOd2SpB492DSDz5juMRi55GFAI7YW85l
        mDeSqb/8vihhJ8u01BroxcqChulIngvjLDShSkuefRjdUp1lwb4iEpkshyB0Bnsi1X90aPjM+xhz7
        mQCUdb2jwdSgPrgstxwVK3uRt6yO9uIepdv7DhpP4HYyttUuC+47WfEdZs9N4JbuNAW0D76GvBjnJ
        a37Jua+Q==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
        by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qONRR-000Elg-0q
        for netfilter-devel@vger.kernel.org;
        Tue, 25 Jul 2023 20:11:29 +0100
Date:   Tue, 25 Jul 2023 20:11:28 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: ulogd2 patch ping
Message-ID: <20230725191128.GE84273@celephais.dreamlands>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="HoMlYLPINzY0/Rd4"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--HoMlYLPINzY0/Rd4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

There is a ulogd2 patch of mine from the end of last that is still under
review in Patchwork:

  https://patchwork.ozlabs.org/project/netfilter-devel/patch/20221208222208.681865-1-jeremy@azazel.net/

It would be great to get a yea or nay.

J.

--HoMlYLPINzY0/Rd4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmTAHlkACgkQKYasCr3x
BA0F5RAAvtJVc22D89zUA1zOc2vVnitapIP25qL0oJXDmZ/C0KyB+v+aaTiZb5KS
qChgeCpYlh7t/0MBKBJwtUJqqa0dRUTfOAfCzM6u+nb6NW7YHtIO4rGg3gU66LxK
gE3SJXfVukWRwzmlsB6/d3YznIVZGaBp9ubd8GlCVYjHLm1BMbuPKshObJBixYRp
AnKq5BwLgp17kFIPzU7kC4ZMTMSUoZGoIhjPY7Dwe6AbrMxnYQepBn0SShdWKAuE
Ddg5DHDitIIUu3rUcrkUgdbanodLhw9nhm9jKmBL8iRcg8iT6M3ja1kpXNVkjWpH
fu8wgofHeQ6r1+KebrXN52ZHiISJLWRdHa1KQ/0Q8Rm3tER5i3ddwlLZXUNyXG+z
mGsSXKmaqzQHyZC7crX1+E1a1u39fqAemK21rt3NOLbnuACw3DOWi8FvLBn/hALr
7mWK0+h935gNwUnTfSigTI/oXpYO89UPXBVg+GjIX9DFG5Ju7tauyqmcrud6FLIK
y5hW4gCuI55GU8QEL+RA2qIy3hxF0kRvZqYqBb9AY7ZFn+4/vmeEvbAdDQPqGpQ3
iFhTPI52DyWv/qTWB1AP7np42f3iaQdf5ORHofPtaUCwtlduVSR2xr+CMwhIifaH
nkECsG6xcz+U6RcBWQWWyEBiXWy2GXbvTyI3flefjnGEd8CXqQY=
=KEgP
-----END PGP SIGNATURE-----

--HoMlYLPINzY0/Rd4--
