Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42519C10F14
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 01:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1031620833
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 01:22:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="VOrPVvn0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbfDOBWX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Apr 2019 21:22:23 -0400
Received: from ozlabs.org ([203.11.71.1]:58401 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbfDOBWW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Apr 2019 21:22:22 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44j9hq128Mz9s55;
        Mon, 15 Apr 2019 11:22:18 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1555291340;
        bh=uVJqsNqWecz568FD0lgI56skK+CJ/v1w4A4ckQnzlQ0=;
        h=Date:From:To:Cc:Subject:From;
        b=VOrPVvn05Yum4MmNllCIbpLm9tWgWTPwFFzlL5O1KyC7XYkqV9nMx0MecgbeQ9Rjn
         SHgRrBs1TzvPj78xPNWAgbwIEM9K6Bali82KmyH2IbSNbagzAOkLVSYFW/bLz9qJpz
         QqNGOM28FG8n762JdeBEqeYCAlC/8zaqC7f2Wl7wW0lEFUmTfTIPW0y3RBsY9CF/5Z
         hH3b/Sz3nvtJxDmGZb5NJCBEUpsxy2trhOiGvkQOyFobJdeFY8V9IsqtnlYpKZKi9Y
         FKXVr8QZfPJpVd3zY2eXev7hXFUCSOzuwbnjkblR5tH3t3+iuP7AFjyHZdLQb01uqn
         Mp0ainDSNq4Iw==
Date:   Mon, 15 Apr 2019 11:22:16 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
Subject: linux-next: manual merge of the netfilter-next tree with the
 netfilter tree
Message-ID: <20190415112216.451541f6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/iOfTixBwxjYaL/xdyiLQNRZ"; protocol="application/pgp-signature"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--Sig_/iOfTixBwxjYaL/xdyiLQNRZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the netfilter-next tree got a conflict in:

  tools/testing/selftests/netfilter/Makefile

between commit:

  becf2319f320 ("selftests: netfilter: check icmp pkttoobig errors are set =
as related")

from the netfilter tree and commit:

  26f7fe4a5db5 ("selftests: netfilter: add ebtables broute test case")

from the netfilter-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc tools/testing/selftests/netfilter/Makefile
index a37cb1192c6a,80dae72a25c7..000000000000
--- a/tools/testing/selftests/netfilter/Makefile
+++ b/tools/testing/selftests/netfilter/Makefile
@@@ -1,6 -1,6 +1,6 @@@
  # SPDX-License-Identifier: GPL-2.0
  # Makefile for netfilter selftests
 =20
- TEST_PROGS :=3D nft_trans_stress.sh nft_nat.sh conntrack_icmp_related.sh
 -TEST_PROGS :=3D nft_trans_stress.sh nft_nat.sh bridge_brouter.sh
++TEST_PROGS :=3D nft_trans_stress.sh nft_nat.sh conntrack_icmp_related.sh =
bridge_brouter.sh
 =20
  include ../lib.mk

--Sig_/iOfTixBwxjYaL/xdyiLQNRZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlyz3MgACgkQAVBC80lX
0GzjNgf/ZwehfdOYLgn3vj+PmNnPfX5E4sW6tOwrR5hmfSGKJNgaMEaBf6W/7Fkn
yIof8g2A64z1NdAtBFcvSrMMPOFUCJ2hXGUViFlo9cdjcEGXY+5Ls4RceKsBhWQk
noq0DVyYWT1DDp5DP+hPB8A4uOPTBF5luIoGEi2SFoIG2qAet5EbU23tu9PKm60k
OsqN9juYTuzbdzohO8oNBPM6T+hmkytEP/6+1II/VvVW0/Qz+rovYneytJqn0Fuw
/tqJQYLzcYiWRwC/WQUoibX1y+LRFeiY7fPgDNAE3vO51JFWVoVrW+HvgRMWhjby
+ckbpw+X50ATjR3rrs3uHAAethwIbQ==
=A7mt
-----END PGP SIGNATURE-----

--Sig_/iOfTixBwxjYaL/xdyiLQNRZ--
