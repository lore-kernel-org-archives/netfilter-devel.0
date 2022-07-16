Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15A41C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Jul 2022 17:53:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbiGPRxU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 16 Jul 2022 13:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiGPRxU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 16 Jul 2022 13:53:20 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE1B1D0ED
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Jul 2022 10:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=gkOg8udhdLCzhCHTsfUR6c2WwkrxSxVdY5yTmDDx2q4=; b=UsRSzih3gFreWI1RAVsfG+Ntzc
        ZnuAwNVUCirIAA9JXzsG3S03ZEHG1HM2cPTmqModUMAEepLjBDSzkAKhJaQZVR3l3hZtkjJUvgyuC
        x+sdUYjXP0ofYxbRuHRulhEWdOj2is8xpxXLSwDnKDRXEYjQdrlvohSPVaOU9XK71g6HY6rBCSnyw
        35JZWlmPvD1K2o2D4ALcrJ9gL4RbSaWMqsxhOZPC4+Ni8EutwphbcXMTK8rLYAAoep2hbgbmaS6Nu
        8M2A3C4Nx/mxUjCozCaf+EULvLOzM7hlXPg/tvMz/OhN4UgAKUjOhpprTr5VhN209a2R0Tkz6JMQs
        fj60Tq5g==;
Received: from [2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oClyc-006HTB-D5; Sat, 16 Jul 2022 18:53:14 +0100
Date:   Sat, 16 Jul 2022 18:53:13 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Serg <jpo39rxtfl@at.encryp.ch>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: libnftnl broken examples
Message-ID: <YtL7CXTK244pN7pv@azazel.net>
References: <fef69c25-3b17-a111-f447-744d3afe750b@at.encryp.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="0LPy2hyBKU1LfA2L"
Content-Disposition: inline
In-Reply-To: <fef69c25-3b17-a111-f447-744d3afe750b@at.encryp.ch>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--0LPy2hyBKU1LfA2L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2022-07-08, at 21:18:24 +0300, Serg wrote:
> I am trying to integrate my userspace tool with nftables directly, i.e.
> without executing nft utility.
>=20
> However, I failed to find any libnftnl-related documentation, so I tried =
to
> play with examples located at
> <https://git.netfilter.org/libnftnl/tree/examples>. I tried to run
> nft-set-elem-add.c, but every time I got `error: Invalid argument'. Could
> you help me troubleshoot this issue, please?
>=20
> Some details about my system to help reproduce this issue:
>=20
> 0. Clone master branch from git.netfilter.org
>=20
> 1. nftables rules are:
>=20
> # nft add table ip table_example
> # nft 'add set ip table_example set_example { type ipv4_addr; }'
>=20
> 2. My linux kernel version is 5.15.32
>=20
> 3. Run the following command:
>=20
> $ sudo ./nft-set-elem-add ip table_example set_example

nft-set-elem-add attempts to add two 16-bit integer values to the set.
You have defined the set with type `ipv4_addr`.  Try `inet_service`
instead:

  $ sudo nft add table ip table_example
  $ sudo nft add set ip table_example set_example \{ type inet_service\; \}
  $ sudo nft list table ip table_example
  table ip table_example {
    set set_example {
      type inet_service
    }
  }
  $ sudo ./examples/nft-set-elem-add ip table_example set_example
  $ sudo nft list table ip table_example
    table ip table_example {
      set set_example {
        type inet_service
        elements =3D { 256, 512 }
    }
  }


J.

--0LPy2hyBKU1LfA2L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmLS+wkACgkQKYasCr3x
BA0U9RAAyV0r6NDfu88eKtT0l6L+y4l/i/AVvkrHfmqBrEyx4gsJXR5/r290bF61
AQkz3CceFgBsCl0Zieb4T2PfrD5wPp4ET+ytMYXFGDfHe7Dx1TMGBxIUPE32SJxk
NUZ3KTxQF4HxE/L9hMypKX/n5d435vp8r4GmbWiykHy6xcXrPVCh+tlAVPSuaB+P
I56F/rHjK6X4skinbS4So7HrJIj1l++iCOr7YC/PavqorsP9wKorpftnfdq8gwGR
bYDre38WtpIK7COs7D1rM1a1DYsrwRTsOfYob9C+2BazRd7DIn4jk5kWvN9fFfNK
gSOW7faM5R77HmFj1dQs4nN7lP/31GkMGWuQm5cxDzba2uRVq47p8ZZ50a/5c2pW
ltQA4w+ja9SIFd79cGYnMgD16on4Lyq4iLHYW2gnxa1cAInnRy2WHbMpyCIJMDdY
R/X09E6cbAAy8Fc+wU4iV9Apr1cxGBvCW5M9HdOKdH7eFNZrUfGHF3nU2ZzMi8pJ
t8v0zyK9jumAzsQS4jeMn1MxSBjmprIKOdNXwSyKrMfwe//dUHxAhjIUXk+JUIpD
B1CMrQEKtpFQTM4kRgLaOMV/G/yUGZq73TpjXGDxsoW1kfxb65A7ExV57RsnV5Sv
sbH4BFQwzn0HjEjFNyhAMgdsUqX8+LwV9tkAyNfl/dGvGCZerBE=
=WBGK
-----END PGP SIGNATURE-----

--0LPy2hyBKU1LfA2L--
