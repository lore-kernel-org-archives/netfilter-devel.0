Return-Path: <SRS0=eJXe=SP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE62C10F14
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 04:05:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EE8D218C3
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 04:05:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="BSyyCyfK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfDMEFu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 Apr 2019 00:05:50 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:60475 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726285AbfDMEFt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Apr 2019 00:05:49 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44h1QM3zntz9s4V;
        Sat, 13 Apr 2019 14:05:47 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1555128347;
        bh=f4pXpIm4O1dRRGPJUJojO1ITAE8mkoq4eCYYIU++Kr0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BSyyCyfKQfZmwgPohswkHrGWvtNSbhvI2KW57VbHNhK0ZTRVYaeHe6WUtFtvzbN8U
         78I7CxT97u9QqecXZXUsidvXqIszAA9PgpySkPBNiZ4M4y3HEDoy6hhFEB2N2C2G98
         sybBAr11akZl1x6WZE1cW0qMYznFi0VTRkISBC2dTtVdHAfpl53VIrHU2vPZoAyRCd
         dnQOnu3I2yAs+I+rm4DywX5WNUL7e9iU4s6a6O6T7/IySExbBj1LuKTwd3OsV8j7Ax
         CMhpVig9bx+ylOkbKhr+KSoWP9ULJ+QL3D/LSoosn2Dgba+DcgmBGtQ/DpHwqvk2KY
         62I0KXQbPXE+g==
Date:   Sat, 13 Apr 2019 14:05:46 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: Re: linux-next: build failure after merge of the netfilter-next
 tree
Message-ID: <20190413140546.081e8196@canb.auug.org.au>
In-Reply-To: <20190412081527.vrym3czsko2lbqx7@breakpoint.cc>
References: <20190412163720.576c6610@canb.auug.org.au>
        <20190412081527.vrym3czsko2lbqx7@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/4OamxP1cmijJi54GAt=fr7A"; protocol="application/pgp-signature"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--Sig_/4OamxP1cmijJi54GAt=fr7A
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Florian,

On Fri, 12 Apr 2019 10:15:27 +0200 Florian Westphal <fw@strlen.de> wrote:
>
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > After merging the netfilter tree, today's linux-next build (powerpc
> > ppc44x_defconfig) failed like this:
> >=20
> > In file included from /home/sfr/next/next/net/bridge/br_input.c:19:
> > /home/sfr/next/next/include/net/netfilter/nf_queue.h:16:23: error: fiel=
d 'state'
> >  has incomplete type
> >   struct nf_hook_state state;
> >                        ^~~~~
> > Caused by commit
> >=20
> >   971502d77faa ("bridge: netfilter: unroll NF_HOOK helper in bridge inp=
ut path")
> >=20
> > This build has CONFIG_NETFILTER not set.
> >=20
> > I have applied this patch for today: =20
>=20
> Can you submit this fix formally to netfilter-devel@vger.kernel.org?

Done.  Though I was hoping someone might come up with a better solution
(I don't particularly like conditional inclusions).

--=20
Cheers,
Stephen Rothwell

--Sig_/4OamxP1cmijJi54GAt=fr7A
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlyxYBoACgkQAVBC80lX
0GwJfQf8D6+u8aTCymnS8gu6KTZkkJfslYj7/ErHQ1JiBE9sv6DI2jsith2+JsYW
sFsR0d0XZOD7NB0yP/+nYO/0ujNqFR/brSHVtpSpLhNIiwFU+CC0kK/TfIWutsXd
IDiTIpZz5gmDFn1qycipn/+57BY2PlT/7ZcXvzZOxABduE6/zhU+X/Y1y2j6BfIA
HOiTKbaVamVrjZvVIoZxNhbns4Z4+ik7bUyjvTwX69DkkQS7Yfxp/Hz+GL6PcHm2
0gC+DVAThVvXCmTd4g9jJgZFTXDw1yA6TcadiEkj1XFbAKimjw5EeYwA0+4UXFl0
Eg1aWNwsKO27WiVYw5rAbi2JjX8lYQ==
=ejU3
-----END PGP SIGNATURE-----

--Sig_/4OamxP1cmijJi54GAt=fr7A--
