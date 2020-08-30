Return-Path: <SRS0=XBPj=CI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB51EC433E2
	for <netfilter-devel@archiver.kernel.org>; Sun, 30 Aug 2020 11:43:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 886222087D
	for <netfilter-devel@archiver.kernel.org>; Sun, 30 Aug 2020 11:43:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="bDCA/LuP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728700AbgH3Lnv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 30 Aug 2020 07:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728691AbgH3Lnu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 30 Aug 2020 07:43:50 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369D8C061573
        for <netfilter-devel@vger.kernel.org>; Sun, 30 Aug 2020 04:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yh1AiHeLkQnDvGXjVBZtF3IPRjOzmlzmzrYYV06MunM=; b=bDCA/LuPAieS0NGp+wsMEN01Ue
        owuWHQYiKsrRjPBL4AXy5UrJOJCqDTz8DiNi3vwK99vpT10v9O+f37FN0I5TEAUFVrhQwiNX1j+xB
        OPfQOXH0nYXKMreahJaYpd3LeyGAhQoIitBT/+dvf0mCTebWndJE3jHOhdAU0XDlMMNVFM5jmnnEy
        AcF9zE3NAPIV0uNJvDkhOj7Ei5lOWHNFI2l/3psHa6ml8HJVScfXM1pk3q3zBsUz2m8CNTAl7Azhv
        Rjm8/RYbKf7gvjQc/WBdIMdRKs7ALjPFTLMKG92ro2RtjEkvrMbBd0yKHRiR7poK6Nyyc/gRvoqmK
        izpDPbAw==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:5ec5:d4ff:fe95:cee6] helo=dreamlands)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kCLkM-0003Iy-O5; Sun, 30 Aug 2020 12:43:42 +0100
Date:   Sun, 30 Aug 2020 12:43:41 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH xtables-addons] build: clean some extra build artefacts.
Message-ID: <20200830114341.GA1414639@dreamlands>
References: <20200829204127.2709641-1-jeremy@azazel.net>
 <nycvar.YFH.7.77.849.2008301337350.1576@n3.vanv.qr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.77.849.2008301337350.1576@n3.vanv.qr>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:5ec5:d4ff:fe95:cee6
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-08-30, at 13:39:28 +0200, Jan Engelhardt wrote:
> On Saturday 2020-08-29 22:41, Jeremy Sowden wrote:
> > Because extensions/Makefile.am does not contain a `SUBDIRS` variable
> > listing extensions/ACCOUNT and extensions/pknock, when `make distclean`
> > is run, make does not recurse into them.  Add a `distclean-local` target
> > to extensions/Makefile.am to fix this.
>
> I find it suspicious that the userspace tools are not even built.
> Therefore, I just added those directories to SUBDIRS. This should
> conveniently also cure the need for an extra call to distcleaning.

Thanks,

J.

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl9LkN4ACgkQonv1GCHZ
79e2IAv6AjE/3uWjPhGtVB9JgiEBETa30VeE8fzjidxXJxVgplQ0gNmYZ8Ro7pVT
G56gyfqDZfLbgqPfpFLad5YRHAuThP1UAODjXIx7I/Z30BYStYC3DW70FyXo37Ck
mrFOxFnkE9wk5oDVeD8bSlqdU2oNVxFq+zC+2s1cyOBymzXlUri484dKEpoZeiqp
m3fmrHVZXKybQw0jvvGOYjEisorV4JNknyiKdAqLgLH60lin93nd0p+KY0rpdOr7
Z9TEwbJX2pkxpFFREry4ic4azomAvlbrGXKg2unzO0lxlAizbP6dcH5JMYyPmhgD
MCxH+3LGkGqZdG+WrEy1KMD/JWnt7HlbKA9uHsigNgloNHCi19jco8GEw3b6QbgB
EetZxNV/wd8RdWWcIWh+RxsN/Z08o27nbarac4zyB9OpelAowiN4rqEHZPO5sKCa
5eXxQZ9qRlVkMjR7CxiTx0bDmEhmU520dNBfxgnb/Ukm0nFy5vjpQhBaUDXa6v1D
kItLDW2V
=OtUG
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
