Return-Path: <SRS0=D+Hy=4U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6024C3F2CD
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 00:26:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C35B2467B
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 00:26:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="kzv9byor"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgCCA0X (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Mar 2020 19:26:23 -0500
Received: from ozlabs.org ([203.11.71.1]:58941 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726915AbgCCA0X (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 19:26:23 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48Wd985fPQz9sSG;
        Tue,  3 Mar 2020 11:26:20 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1583195181;
        bh=6pNAZ4DNdVjlv1OmTqyQ0CQpMidWYRVRMi415EdzFLc=;
        h=Date:From:To:Cc:Subject:From;
        b=kzv9byorkfPrd7DYiYlrIPiBbd+bYYnp1AXR3ttQVpD56sZ0IK0gsrwntv/HpxQgL
         tph+FEXez5mEAa5IucY03akcTStY9ZKyWP1Zrhj/SesO87572xUk+yiUv3R3gq2GZj
         fjJpiaaECCy0k/Hpx9MRY0eKyHYq5rLcSVPNslFFvM2tHxhpY55XSV61hACWdTqGAS
         BJjgI0kOw/f+zhj5EgogimWiT6mZws2xzwSiZSCx9TBAdcExgtytDpJi/nWqDtQ19Y
         k/9G2pNHci/NSDfcAEIUT7GUn/zhqXId1+WQQy0kPh9ZWQ7lT/eKmOcJ3TB+H9uUxc
         ZmXU/lc5DXfXw==
Date:   Tue, 3 Mar 2020 11:26:14 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: linux-next: manual merge of the netfilter-next tree with Linus'
 tree
Message-ID: <20200303112614.546aa34f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/QYioLg.i7ALBe_AZALOdD7Y";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--Sig_/QYioLg.i7ALBe_AZALOdD7Y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the netfilter-next tree got a conflict in:

  net/netfilter/ipset/ip_set_hash_gen.h

between commit:

  f66ee0410b1c ("netfilter: ipset: Fix "INFO: rcu detected stall in hash_xx=
x" reports")

from Linus' tree and commit:

  9fabbf56abfe ("netfilter: Replace zero-length array with flexible-array m=
ember")

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

diff --cc net/netfilter/ipset/ip_set_hash_gen.h
index e52d7b7597a0,f1edc5b9b4ce..1ee43752d6d3
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@@ -105,11 -75,9 +105,11 @@@ struct htable_gc=20
  /* The hash table: the table size stored here in order to make resizing e=
asy */
  struct htable {
  	atomic_t ref;		/* References for resizing */
 -	atomic_t uref;		/* References for dumping */
 +	atomic_t uref;		/* References for dumping and gc */
  	u8 htable_bits;		/* size of hash table =3D=3D 2^htable_bits */
 +	u32 maxelem;		/* Maxelem per region */
 +	struct ip_set_region *hregion;	/* Region locks and ext sizes */
- 	struct hbucket __rcu *bucket[0]; /* hashtable buckets */
+ 	struct hbucket __rcu *bucket[]; /* hashtable buckets */
  };
 =20
  #define hbucket(h, i)		((h)->bucket[i])

--Sig_/QYioLg.i7ALBe_AZALOdD7Y
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl5dpCYACgkQAVBC80lX
0Gw3uwf/RaVvcJWrbYdHPzAx4vdbLuHRp6bdBd+kgaV3Np/hFh/ipUI5+fq2yeWK
ZogcV2y+VqXIVTliSHhNN0RkH9vlwo/tylSfs9WFERG1HmrMsQmhtTt0Idjfef0y
AD/S+WYSn0uV5eZxHa/ZUUS4xkdqvfrumnXVlz7haeert/+FrHDFc3BkzgxdJxLi
REVLdgBvyrly5ZiwaVqQliQ+NlyG3uRVhRMNiPwLq4hTjnauy5gIukRqsMwUmGeb
RT6U1skYeytt7UDFWKEkX/8s3PG/1jqdTf9dEKPgOybaqAsl5W+uidZTdvmHiIVW
JFbEtM9+NNJBpmmh6LlVCR/cltXNLw==
=Ig/C
-----END PGP SIGNATURE-----

--Sig_/QYioLg.i7ALBe_AZALOdD7Y--
