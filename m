Return-Path: <SRS0=dF0f=SS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7EF5C10F12
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Apr 2019 01:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7458B2084B
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Apr 2019 01:26:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="ihVRlnoG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbfDPB03 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 21:26:29 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:33491 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727049AbfDPB03 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 21:26:29 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44jnl53Kdsz9s4V;
        Tue, 16 Apr 2019 11:26:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1555377985;
        bh=gjU7FMLpYX0ir1gFboGn0zeL9QOciAAYwT3yIxoqXyg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ihVRlnoG7lBE5VHTsvrlWxtmLQGvWaEr+eeV59gqupDRakDHuPCTbPuskxF0QwgaD
         9SX7YAF3/acK3HHTq0zvrdu6m4Y6y0o+smbP143oqEpS8/Py0ywQaOGMCUKpAi4cOa
         nIAjPuYUsSzcfalW4ZMdFIZuVgEEZO8HGz6Ush0K8ozijaRh7v8GXleXBU9cRFFpPi
         wmk9ytGYufydCee6nJG1zWIMEmC8HdZglOtne06jzPbSC6f1Hd8ecCmGKohZqwo0vO
         67W/smSKD5MXlXJNVYy7lS4O7nhDV34D1zhqToOigkO6YAHlv9PQoNS7PT1CcS4NHz
         Wl7dR54sTEVkg==
Date:   Tue, 16 Apr 2019 11:26:24 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
Subject: Re: linux-next: manual merge of the netfilter-next tree with the
 netfilter tree
Message-ID: <20190416112624.597e3fd2@canb.auug.org.au>
In-Reply-To: <20190415112216.451541f6@canb.auug.org.au>
References: <20190415112216.451541f6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/HdqGYCYdJHK2MVfjDqHqtMG"; protocol="application/pgp-signature"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--Sig_/HdqGYCYdJHK2MVfjDqHqtMG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 15 Apr 2019 11:22:16 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the netfilter-next tree got a conflict in:
>=20
>   tools/testing/selftests/netfilter/Makefile
>=20
> between commit:
>=20
>   becf2319f320 ("selftests: netfilter: check icmp pkttoobig errors are se=
t as related")
>=20
> from the netfilter tree and commit:
>=20
>   26f7fe4a5db5 ("selftests: netfilter: add ebtables broute test case")
>=20
> from the netfilter-next tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>=20
> --=20
> Cheers,
> Stephen Rothwell
>=20
> diff --cc tools/testing/selftests/netfilter/Makefile
> index a37cb1192c6a,80dae72a25c7..000000000000
> --- a/tools/testing/selftests/netfilter/Makefile
> +++ b/tools/testing/selftests/netfilter/Makefile
> @@@ -1,6 -1,6 +1,6 @@@
>   # SPDX-License-Identifier: GPL-2.0
>   # Makefile for netfilter selftests
>  =20
> - TEST_PROGS :=3D nft_trans_stress.sh nft_nat.sh conntrack_icmp_related.sh
>  -TEST_PROGS :=3D nft_trans_stress.sh nft_nat.sh bridge_brouter.sh
> ++TEST_PROGS :=3D nft_trans_stress.sh nft_nat.sh conntrack_icmp_related.s=
h bridge_brouter.sh
>  =20
>   include ../lib.mk

This is now a conflict between the net-next and netfilter trees.

--=20
Cheers,
Stephen Rothwell

--Sig_/HdqGYCYdJHK2MVfjDqHqtMG
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAly1L0AACgkQAVBC80lX
0GyGuAgAnb38YRpcBwZLivcb7dTLp6GRoZSwyn8sAVFzvoioQPSyh1UrP/3YWPGC
vD0tKMkm3DWJd0XjycbKY0isKp0NCzxWcrM2ikRu7ldTJ8u7FpNmCD3I7JL0SreU
Zx7lKhxjiLfZW9VenoTzL0PGTRWo/1cqjbrf/b6+nYGUmOHrqkIG2KejvwaVTfQ/
oaY7udoxS9KafGQAq7XvYc2v5NPwCkRsCVfwv/APEV7B/mFf54Pd84jh/98OfIie
jmNB+adc81ZV6l7m9xMdZUjoe2IJIsYg4BvqqQ0ZzDKP4YXM0ctHKa++nKYBCkY1
b61j6ZDxRkGNR7RDKqvhCw2YBFdk/g==
=9yAt
-----END PGP SIGNATURE-----

--Sig_/HdqGYCYdJHK2MVfjDqHqtMG--
