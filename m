Return-Path: <SRS0=AKzi=VV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BEFBC76186
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jul 2019 21:18:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBFB22189F
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jul 2019 21:18:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="V0hHpFzh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbfGXVSO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Jul 2019 17:18:14 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:34167 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726818AbfGXVSO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Jul 2019 17:18:14 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45v7VV2NDJz9s4Y;
        Thu, 25 Jul 2019 07:18:10 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1564003091;
        bh=ZlrI6QWEkVk+jpf0/CEmKaDNIZ69mnNqNbr14CHhqng=;
        h=Date:From:To:Cc:Subject:From;
        b=V0hHpFzhze4oGwu7Htn6DCkrEhZF/gMBLiLqoBKZJINfwk5VbXdjkH3FGGtgxYHlk
         mMuvKZLwtjtfpN6TXtLe4tOJwKdTsaAqXk8lge7zexGcdwmUPTZShpGr2gycha7vyB
         ax8tMdygCfqhSj0dS1YDff9xmIRndkJz7WHiwVkaPOGt3YkQK/1RYoiu7dANcNFHup
         58dYCDdF2iJZMUsotsoqhRiAp0A1G4gT99sUD9uPzbRSoJYC7uhcAZ2kJX+GgB5eMI
         onJRuZX6Na+vioFOSlwypRsJZN47zpXdF1WMZ9PvHorj/1VKYn5iCv6blEBCmvS+Rf
         ATyePvl0rloew==
Date:   Thu, 25 Jul 2019 07:18:03 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Phil Sutter <phil@nwl.cc>
Subject: linux-next: Signed-off-by missing for commit in the netfilter tree
Message-ID: <20190725071803.6beb44f9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/myjbYSr/EfRoQ1LLFBsAGba";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--Sig_/myjbYSr/EfRoQ1LLFBsAGba
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  5f5ff5ca2e18 ("netfilter: nf_tables: Make nft_meta expression more robust=
")

is missing a Signed-off-by from its author.

--=20
Cheers,
Stephen Rothwell

--Sig_/myjbYSr/EfRoQ1LLFBsAGba
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl04ywsACgkQAVBC80lX
0GxZGAf/UUOEi8K2f2YAehwZpxFFt9+M1OitxZVyr4HLAvttAT5uYVbRytRlqmkS
cChx6PqCD9/ExbeUIjubSHXkt5Y8z2spIQ18SpFjRZsmajz7m7t3Fp/WWAsBOLtT
QQkG6HxKv7yGhN4DDTirJ2bd2l/u9yxDbju/OxDoXGyssQuPjVJBiCYweHev6+zS
7T6Oe1yeqYExjyL8Vzj8/agxAuRyJRVNYzJUuFS9/UN+6k3043dY2rnsr9GFtkF9
kfZphzNM5O/YtjFHFFsquQT8PlIbCSr+8ES3Q8e/msQCHv3PwKlj67FazOHMtG0w
vK+/ovxdnAQQ3982Q5UjRZzppuHKcg==
=7TJs
-----END PGP SIGNATURE-----

--Sig_/myjbYSr/EfRoQ1LLFBsAGba--
