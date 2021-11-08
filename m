Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D51BC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Nov 2021 12:03:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3774F611C0
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Nov 2021 12:03:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238058AbhKHMFp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 07:05:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238065AbhKHMFp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 07:05:45 -0500
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC67C061570
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Nov 2021 04:03:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KLVwPdrBkkxtZ5VBfAbrnodJ89BAFpJ3XHgIatV9GmA=; b=B1QZ3v/lWk7PCYC6g+mOhSZ3zh
        0rR7SMzCS6EjPpqs674FvH419XQEZgsuKMIpMrYtOUcBxkI/yfOnhd8CzV+bAmVol8aGA/Wse0qJ1
        zR/cmh9v9lRFf446TVlqRzRM/fV33i19unTG7d7MtMAtQgwivgNACrxoRDOHa4/ruiFTG7qIsoUUr
        5xx4e6pIeS6r9rOfyqJohiNswBCGPfW4HUsvRhUYGiw30KqQRx3DS2nmoBg1Dniwxt9TBVFuaiF2o
        a4xmSwcMwhxbptO5OKVjK3m7bfSYGyXGwVfPwbSni8B2o+OqnplVjtDNYPk6+4jLaybgmZ2EwsXhc
        jyGQ2pqQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mk3MZ-006fxk-CT; Mon, 08 Nov 2021 12:02:59 +0000
Date:   Mon, 8 Nov 2021 12:02:47 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [ulogd2 PATCH v2 00/13] Build Improvements
Message-ID: <YYkR5z0g0anX2aMr@ulthar.dreamlands>
References: <20211106161759.128364-1-jeremy@azazel.net>
 <YYkFdfmq4gtY7Fr6@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mztoOcTrn/SedOOj"
Content-Disposition: inline
In-Reply-To: <YYkFdfmq4gtY7Fr6@salvia>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--mztoOcTrn/SedOOj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-11-08, at 12:09:41 +0100, Pablo Neira Ayuso wrote:
> On Sat, Nov 06, 2021 at 04:17:47PM +0000, Jeremy Sowden wrote:
> > Some tidying and autotools updates and fixes.
>
> Same thing, please add a description.
>
> Sorry for dumping this series for this "silly reason", I think this
> helps dig out in the future if the natural language description
> (expressed in the commit description) matches with update as a way to
> spot for bugs.
>
> It does not need to be long, I understand some little update are quite
> obvious to the reader, so a concise description should be fine.

No problem.

J.

--mztoOcTrn/SedOOj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmGJEeAACgkQKYasCr3x
BA19/w//W/jImAo8Ac1Apq788lhb/lmNZAPHiOrSQvgsSvQF8DE2+zgBIvqfQmD0
iS/qVnUSwBHd891OPN9Y0qDDkmudZMywXWyoOoirgmPJ5xPC4CCUJ0BDXwn84dPd
eHHM7Kwy1V7fc73Yt7DN8cungFBZIbTQ9xQXQNixU7xKw7uLTnsLfWGbALj4Dy3N
lMel8m7rJgH3eVeb8j1toT3DJUxZkQMd4td3rM80XFsfGl8nrnbOrguIZhZJHfTU
REmhrjlh86URGch9BRuduoQ8v3jmkw8poiAP/JFHIKRw2mruwXjAtio/qNZoWi+5
ipL51aKCTmyKKs05uitO+NGJcdwSP/bVZgkZrEeDBatJEn4WyBItrQeKsLY5RL2D
/5SobLRUXZXMBYfwYmcIIBppH1d4NiookbRushzMJQxck0SNUWQD973rlojqvAWx
smvk6EigL++stauJ47U6moDORM5KmY7nuAqduXtopW0O4H5ldi7NUEd2qu3P2O45
GW+P6ZVSVVdm2YPOr1CTxDvL+mw/aCGQSqGjJukZYM0U2Ks8qOmiG/CUYDnG57hf
/NrrR8YRKot1K3o8EUEohYg8JUbbcrzmP7P/z8eEiBqosJzDr9LkAO/ohHftnIBP
1oUFZhlIVeZK5N2bmze4/jV0b82f0u10+kpRx3dnhJ4uZMsGYBw=
=qgYN
-----END PGP SIGNATURE-----

--mztoOcTrn/SedOOj--
