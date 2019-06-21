Return-Path: <SRS0=QW5x=UU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 032EAC43613
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jun 2019 11:47:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE17721530
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jun 2019 11:47:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="uifGP4ZU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbfFULrG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Jun 2019 07:47:06 -0400
Received: from ozlabs.org ([203.11.71.1]:41701 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726229AbfFULrG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Jun 2019 07:47:06 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45VcNg3c3zz9s4V;
        Fri, 21 Jun 2019 21:46:58 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1561117622;
        bh=goiHVT1iUGD2l33DnwurL5bS+yBEy6KApwjMnYaTsxI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uifGP4ZUU2wtxqOg71WdZY/0n9SJaAiVKPjelcqdNWENlsYIM7yRiDvDvfW3lhJgn
         zhCiElpBSepXHeRVItdqY30osuxukgLccIbLlKLQ7A2wPTqX6B7iRI5YwIspV3udVa
         qubXTugaHY92iLHAwJsKNzwQ+HtzeuJ6Lg4AkDjDpIsn0W08UJlvQGRUR9PncKYi0C
         2a7OB6MpuXpwuYdnPTvItu6seQL06xYcV92zciL0t3E9ybIIb+eUBAot6BLSJ24kTR
         hXE8UEKKbw+sM869plid4Y4NbXty2zd+SyizosVOMvVs0rD6JC/dklhK4W0VJC+tci
         vEgFlDKzX6vOg==
Date:   Fri, 21 Jun 2019 21:46:57 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Next 20190620: fails to compile in netfilter on x86-32
Message-ID: <20190621214657.1624e5a4@canb.auug.org.au>
In-Reply-To: <20190621110311.GF24145@amd>
References: <20190621110311.GF24145@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/fB+x7BsJ7wdh58PHPD01xnZ"; protocol="application/pgp-signature"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--Sig_/fB+x7BsJ7wdh58PHPD01xnZ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Pavel,

On Fri, 21 Jun 2019 13:03:11 +0200 Pavel Machek <pavel@ucw.cz> wrote:
>
> I get this during compilation:
>=20
>   CC      net/netfilter/core.o
>   In file included from net/netfilter/core.c:19:0:
>   ./include/linux/netfilter_ipv6.h: In function
>   =E2=80=98nf_ipv6_cookie_init_sequence=E2=80=99:
>   ./include/linux/netfilter_ipv6.h:174:2: error: implicit declaration
>   of function =E2=80=98__cookie_v6_init_sequence=E2=80=99
>   [-Werror=3Dimplicit-function-declaration]
>     return __cookie_v6_init_sequence(iph, th, mssp);
>       ^
>       ./include/linux/netfilter_ipv6.h: In function
>   =E2=80=98nf_cookie_v6_check=E2=80=99:
>   ./include/linux/netfilter_ipv6.h:189:2: error: implicit declaration
>   of function =E2=80=98__cookie_v6_check=E2=80=99
>   [-Werror=3Dimplicit-function-declaration]
>     return __cookie_v6_check(iph, th, cookie);
>       ^
>       cc1: some warnings being treated as errors
>       scripts/Makefile.build:278: recipe for target
>   'net/netfilter/core.o' failed
>   make[2]: *** [net/netfilter/core.o] Error 1
>   scripts/Makefile.build:498: recipe for target 'net/netfilter' failed
>   make[1]: *** [net/netfilter] Error 2
>=20
> Is it known?

Yes, and should be fixed in next-20190621.

--=20
Cheers,
Stephen Rothwell

--Sig_/fB+x7BsJ7wdh58PHPD01xnZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0Mw7EACgkQAVBC80lX
0Gx2Uwf+OcvRXbTwZiW7IssHj5zEYP+d7wkRVOWoTwGXiWVnlJRL6fRNH7rkYm6l
z7OMiSWiccESjC5ZtRgIWPnBG9UGDzdRTTuQq9kxf2jsaMcOGsknX6v4CixMG74J
ZB5lnsd/kpVQm3d8KQn1A3d6rsb4y9bvxuJFTXCOItzw0g1GDXz/cA6sZbHX7Tdl
UBNGKeXg91RPxDT25pFudMukD8QcLG1MmToy95qWNRXmaVaAJD0izmyBMJgFddCL
E8neM/A2VhWoMUGHI1gE67BSwu8SP6dzKOCJcrVfzr4PLeQs3JBu82mnADCp+V85
XYHP/5YlIMr9IAJlUnlWXAMR2OzqtA==
=xAad
-----END PGP SIGNATURE-----

--Sig_/fB+x7BsJ7wdh58PHPD01xnZ--
