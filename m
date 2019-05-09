Return-Path: <SRS0=htyh=TJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76513C04AB3
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 May 2019 22:35:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 460F62177E
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 May 2019 22:35:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="o6pb63bU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbfEIWes (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 May 2019 18:34:48 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:50141 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726686AbfEIWer (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 May 2019 18:34:47 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 450Snw21ctz9s7h;
        Fri, 10 May 2019 08:34:43 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1557441284;
        bh=nqt2J1Tvd3nd726L9NOu6y41YE7UUVKiEXFRxS9Io7o=;
        h=Date:From:To:Cc:Subject:From;
        b=o6pb63bUrdyEQy66I2K5jxxfdMGEklSfe7tzSeFiMECiG/v+gwmRObK0/I1Ltpy8u
         j8wInQZqTO0fPAv6FErt7Cg5CHgrvKeGhIvYm7L91LF9HaSzAS6rQpNb0O5nH4Jdaw
         s372XpQfBlb8JZiVyV8yURMcImAHiyPeNo7zbH6u2rwpk+NfcOtFlMNU5IhxvK6MZR
         yzZcWVEhRCGlY92kHPug0CdWux8W56ulUJ5/Gtp2Du88sZE7ocKQmHIA9kB5lEVuDG
         bJEm52Q9Oomqy8Tc/1l7oosBzHHMacm6vy2xkKeTlQRlpqmY6GUjkg7PircBCg3Rrz
         1K8l0+7xtHWaQ==
Date:   Fri, 10 May 2019 08:34:35 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Brett Mastbergen <bmastbergen@untangle.com>
Subject: linux-next: manual merge of the netfilter tree with Linus' tree
Message-ID: <20190510083435.68faecf5@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/h7S8YNgI927TIl05dJJy0b6"; protocol="application/pgp-signature"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--Sig_/h7S8YNgI927TIl05dJJy0b6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the netfilter tree got a conflict in:

  include/uapi/linux/netfilter/nf_tables.h

between commit:

  3087c3f7c23b ("netfilter: nft_ct: Add ct id support")

from Linus' tree and commit:

  c6c9c0596c21 ("netfilter: nf_tables: remove NFT_CT_TIMEOUT")

from the netfilter tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc include/uapi/linux/netfilter/nf_tables.h
index f0cf7b0f4f35,92bb1e2b2425..000000000000
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@@ -966,8 -966,6 +966,7 @@@ enum nft_socket_keys=20
   * @NFT_CT_DST_IP: conntrack layer 3 protocol destination (IPv4 address)
   * @NFT_CT_SRC_IP6: conntrack layer 3 protocol source (IPv6 address)
   * @NFT_CT_DST_IP6: conntrack layer 3 protocol destination (IPv6 address)
-  * @NFT_CT_TIMEOUT: connection tracking timeout policy assigned to conntr=
ack
 + * @NFT_CT_ID: conntrack id
   */
  enum nft_ct_keys {
  	NFT_CT_STATE,
@@@ -993,8 -991,6 +992,7 @@@
  	NFT_CT_DST_IP,
  	NFT_CT_SRC_IP6,
  	NFT_CT_DST_IP6,
- 	NFT_CT_TIMEOUT,
 +	NFT_CT_ID,
  	__NFT_CT_MAX
  };
  #define NFT_CT_MAX		(__NFT_CT_MAX - 1)

--Sig_/h7S8YNgI927TIl05dJJy0b6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlzUqvsACgkQAVBC80lX
0GxnZAf/SdTlpbKzDuxhI5RBK2yQNcTv6GgKfwVURQRdDOIjqr4jpzkRcd3zbVCh
mFX+mAR1xmJ13MeSZ1Cis7o58GfkZuNV/i3GxKl4l7GSEtU6gAscrqqXnZ66wdd/
oAlNyJLpmIpsL/rs9E5MWK/ZavrsYU4eQLLzqZvO63wx8zTYlhvyVpr3IF2pCyjb
wUZgxUz4i1blraY756ULGw1G/vWHbWmbZEVbTubXzugYgqTfZqi1xSA3BjYM6Hvs
yRRj1AZ4qOlhzyFe2UwUHXWJv+TgECO9iBpELW7IsUOsNqJaAZnQZ6WH5WxF9IwC
FD/5SCnPAXGFHY6/CQf4Fu9wwdjuPA==
=sJiz
-----END PGP SIGNATURE-----

--Sig_/h7S8YNgI927TIl05dJJy0b6--
