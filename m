Return-Path: <SRS0=kfn4=SQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3093C10F13
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Apr 2019 22:15:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A21872070D
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Apr 2019 22:15:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="at2h4rCe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbfDNWPQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Apr 2019 18:15:16 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:43413 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbfDNWPQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Apr 2019 18:15:16 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44j5Xx2DkNz9s4V;
        Mon, 15 Apr 2019 08:15:12 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1555280114;
        bh=AgvFWbYC1YjzUhch5GyyscixmdXndMPaaLrwndOl/BI=;
        h=Date:From:To:Cc:Subject:From;
        b=at2h4rCe/DzJdblKwZckE5vO971jIBIRiW4yXj91Adp0i2/PSjnekNA14vZFc7Sca
         Xj5THdVz93ByygWR0gfx+mU+x8rLQ2r/hpVq501QFl+xEUP6oTSniStUe4x79N0nY0
         6a8f4AthubgQz2ozHJVDmsdCUN58Foa4ESPWy+DcbEIpsdZPY2wugRodvAkQiN1S4Q
         y+qP3E61i0p52XNofzKLK00LpeVywpqX7SQGFOOANrHcqb7Q5NduDsGnBVzCkce95j
         w7tMW9Bx14gEVEkqp5P6uwBAsKWVOictCk7GlonXPa9r59W4b159jViVi5Kk9o3DMa
         JadmtvZ0tNddQ==
Date:   Mon, 15 Apr 2019 08:15:11 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
Subject: linux-next: build warning after merge of the netfilter tree
Message-ID: <20190415081511.5bb6f079@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/6W8k5es4STvbnGrzJBCubrc"; protocol="application/pgp-signature"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--Sig_/6W8k5es4STvbnGrzJBCubrc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the netfilter tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

WARNING: net/netfilter/nf_conntrack_netlink: 'nf_ct_get_id' exported twice.=
 Previous export was in net/netfilter/nf_conntrack.ko

Introduced by commit

  a5dc1fb1928a ("netfilter: ctnetlink: don't use conntrack/expect object ad=
dresses as id")

--=20
Cheers,
Stephen Rothwell

--Sig_/6W8k5es4STvbnGrzJBCubrc
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlyzsO8ACgkQAVBC80lX
0GxAhggAm6kbUw+wJycsUBKUPkB7K4HEZeMNzKdEZ2ao4OebT8vWWPE/Y/VQte8B
+wWTWdBWIFf+XTj3PhiOPjwTnRu06uEv89HREsmXwGvDs/9cUvquUQo3AW2WtoVU
LC7X2pZ/FaW+Vx13fzRSrf06zjz2a/hCGOHW0f7hrMrSgTC80PbICmqNXzoJe6Ir
chSZSvED+FZTXMSNSYETx0KVfiqtXE1UHzWA79lfA3Lc9qrCtXrnehcT0IMG4KG8
6eMyiuF6FpbI1Fn0TRT42oSY7W2UCKz1OGq2+gT5089ab/N2MnMinhtvJ3b7GkaU
hY3mQDL4A2uJFWHg0p+/Ql9IjC/vTw==
=KAAy
-----END PGP SIGNATURE-----

--Sig_/6W8k5es4STvbnGrzJBCubrc--
