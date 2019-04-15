Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B943C10F0E
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 07:57:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA0EE206BA
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 07:57:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="HxuiOGS2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbfDOH5f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 03:57:35 -0400
Received: from ozlabs.org ([203.11.71.1]:53743 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725779AbfDOH5f (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 03:57:35 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44jLSq2Gh2z9s00;
        Mon, 15 Apr 2019 17:57:31 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1555315052;
        bh=UHm7ADjBV7S70IALgYFjz+HSEuvdlSWBfmwTelSZUfk=;
        h=Date:From:To:Cc:Subject:From;
        b=HxuiOGS2Mniqh1TUnkGg4GCCDdHx4icfA/xf+K0PwF0wW1PBsEZ5s1U9kO85VaIe8
         ldjgZN0NGtEBcfxYzxYfhuXllThzQ5tC63TZM0aNEewOp/sGisi/Gs0xLkQiqip2QZ
         uUIT0O+0wW1sRRF+xXAj8qp1Uz0Se0DVIwgwvWI1E7jFNTUjuSfbQwN3VLmGN7F3tr
         tggVOpOifV/EVPXHy3x5c22kyvJ0AkFDA2RBCWs5AXk3/raBG4C6zQXpoB7Dy/u8zB
         +UOyIP2vDWUHl8YuHUB197n2xQpOHJfkuICs0hxiv5h3KzRbQa07C5OZ0yO3E8FLNS
         ZbmPTj5g6rWzg==
Date:   Mon, 15 Apr 2019 17:57:30 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
Subject: linux-next: build failure after merge of the netfilter tree
Message-ID: <20190415175657.7824ebc6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/l2K=bE5.rzDSVRQAz7EuIvz"; protocol="application/pgp-signature"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--Sig_/l2K=bE5.rzDSVRQAz7EuIvz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the netfilter-next tree, today's linux-next build (powerpc
allyesconfig) failed like this:

ld: net/netfilter/nf_conntrack_netlink.o: in function `__crc_nf_ct_get_id':
(.rodata+0x0): multiple definition of `__crc_nf_ct_get_id'; net/netfilter/n=
f_conntrack_core.o:(.rodata+0x20): first defined here

Caused by commit

  a5dc1fb1928a ("netfilter: ctnetlink: don't use conntrack/expect object ad=
dresses as id")

I have reverted that commit for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/l2K=bE5.rzDSVRQAz7EuIvz
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAly0OWoACgkQAVBC80lX
0GwPHAf/UXwnjjoj4okJvHf5Y50ZOJZap4LopxnHSc4MSR6H6g997I22J0sBczXh
s9SEeAoaz0/asYyTSzH7GCYOupipx/uhPhI45tWqjOxnkMIvaqB6i7ZhNzp86ySF
42VhtEvbMbgrgO9tLDAUsL1YTq6R+QXY5R7MuSZ7IQz6whPlapPE3lHFi5eQZx9i
+GFAHzUTaoTQjq86/z44tyPkiXEPB1tVXjT10hSxzbBjjAfIVpVtXkRMmQKVOwvA
XFERIC7zTZINICw2zciPQcdICkaXq+rDF7R+FdBwTI180frv/mUebrSEnIqUNeq1
1KLtawiBB8kZ6MN7RWdo8I44DPxtbQ==
=EEea
-----END PGP SIGNATURE-----

--Sig_/l2K=bE5.rzDSVRQAz7EuIvz--
