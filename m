Return-Path: <SRS0=Dg9R=XT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06F03C432C1
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Sep 2019 07:42:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C896120872
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Sep 2019 07:42:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="q2RoG1yW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438518AbfIXHmP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Sep 2019 03:42:15 -0400
Received: from kadath.azazel.net ([81.187.231.250]:33580 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408088AbfIXHmP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Sep 2019 03:42:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BBTGEr3u4OcfedYzZpfjSwkr/Ngw3BmN9We554PS0so=; b=q2RoG1yWkbX2+uLnmTYF6xvsvJ
        KgXUde0F1mGb/73skrxu4V15BA1uvaJn/WXs3q9/BakgYx4rrFHsKF9VVWHsYWICHaa4K/YbXEleJ
        3Y4DAEEkwQabVj2RzVujfvDH4WNw+WaCTgBouC13Kav+YxYz9Z8ukmE3S31klJjTm0f4blsbVVUfC
        TgydT3lQtvMKHDM5pyoiWJ/jrpJ+g3UX2Zqz4qUygCjloHkZYYrZkGU/+Sd8AszMp9qPUAB2QmhSy
        Euw40K6VafjeeL1sfEAHzCjhYc+nA5Cqn1qnKGg0ovlZ1h6upzfl8SrZE9/or91HwtlmWsqkFB2J1
        xFmKjiQQ==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iCfSg-0001UJ-By; Tue, 24 Sep 2019 08:42:14 +0100
Date:   Tue, 24 Sep 2019 08:42:13 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Sebastian Priebe <sebastian.priebe@de.sii.group>
Subject: Re: [PATCH nftables 0/3] Add Linenoise support to the CLI.
Message-ID: <20190924074212.GB4859@azazel.net>
References: <20190924074034.4099-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="JP+T4n/bALQSJXh8"
Content-Disposition: inline
In-Reply-To: <20190924074034.4099-1-jeremy@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--JP+T4n/bALQSJXh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-09-24, at 08:40:31 +0100, Jeremy Sowden wrote:
> Sebastian Priebe [0] requested Linenoise support for the CLI as an
> alternative to Readline, so I thought I'd have a go at providing it.
> Linenoise is a minimal, zero-config, BSD licensed, Readline replacement
> used in Redis, MongoDB, and Android [1].
>
>  0 - https://lore.kernel.org/netfilter-devel/4df20614cd10434b9f91080d0862dd0c@de.sii.group/
>  1 - https://github.com/antirez/linenoise/
>
> The upstream repo doesn't contain the infrastructure for building or
> installing libraries.  I've taken a look at how Redis and MongoDB handle
> this, and they both include the upstream sources in their trees (MongoDB
> actually uses a C++ fork, Linenoise NG [2]), so I've done the same.
>
>  2 - https://github.com/arangodb/linenoise-ng
>
> By default, the CLI continues to be build using Readline, but passing
> `--with-cli=linenoise` instead causes Linenoise to be used instead.
>
> `nft -v` has been extended to display what CLI implementation was built
> and whether mini-gmp was used.
>
> Changes since RFC:
>
>  * two tidy-up patches dropped because they have already been applied;
>  * source now added to include/ and src/;
>  * tests/build/run-tests.sh updated to test `--with-cli=linenoise`;
>  * `nft -v` extended.
>
> Jeremy Sowden (3):
>   src, include: add upstream linenoise source.
>   cli: add linenoise CLI implementation.
>   main: add more information to `nft -v`.
>
>  configure.ac             |   14 +-
>  include/Makefile.am      |    1 +
>  include/cli.h            |    2 +-
>  include/linenoise.h      |   73 +++
>  src/Makefile.am          |   12 +
>  src/cli.c                |   64 +-
>  src/linenoise.c          | 1201 ++++++++++++++++++++++++++++++++++++++
>  src/main.c               |   28 +-
>  tests/build/run-tests.sh |    4 +-
>  9 files changed, 1381 insertions(+), 18 deletions(-)
>  create mode 100644 include/linenoise.h
>  create mode 100644 src/linenoise.c

Whoops!  Sent the old version out again by mistake.  v2 to follow.

J.

--JP+T4n/bALQSJXh8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl2JyMcACgkQ0Z7UzfnX
9sOBFA//ZLVp/wSn9opyQBGvgtJRWgkw+zS4IOymoGyFuA/9OxljpD/V3Lm0CRmz
8kjunME+XqD+pI15tQ0WrnYHdn9BrOpS6pdfZoG0mdQPNO629tkzDKaktXN18mU2
n4bV8G7Y0ziYISsQjvK+XQUFNklFjZ/+Qqm0SvH5npKMPXAu6V8AkfFlgb5MgCFT
DI0jWt6vVISxqqJsuoYHY7RdiDl5pv6satLqzvA5crhcaB/X5Pi38ZbLlSEARu6m
9KfGXXUOCbInn4Xzx+ofhINWy1SswC4Lw/npPvRxz85u6P8pxJpLiAWTPws6Vk3d
akqoCQTojyqLOq+7eZ1ItXbiqqAbkRZNA9v2xEVAfqNVavwtyWOXVrCLxkoeIaxK
aMnQsZbj6ckyPdGRqb76Q+p39KJkzL/TUiTCNSv4KyPtfKK8ZjwUUxuvjpw/nB99
Blr4TPjovOwlos/z9R/ZKxVDKntltnuLQ4BPo/fyOlvPABPAzkp4FSAvvzlwqYR4
bPO5Rn0SvaNt6bUB3IYl3jpA+o09ZQTQ6NxPI5yQVEj2kPdvfOjlV6DaLag/TMMW
RBvT+FvzeGui9LM1GNk9o3Y9G7Mxr1QxHD6edhxSTefEc0k+KiQvvUPvUFP2BSbi
1tlDCGYSR2lzwQOuPnna6nbbBgHSifPhm9PfMUJvlb5sYL6RPwU=
=Mbaw
-----END PGP SIGNATURE-----

--JP+T4n/bALQSJXh8--
