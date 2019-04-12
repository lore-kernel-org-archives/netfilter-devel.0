Return-Path: <SRS0=aNn+=SO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8969DC10F14
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Apr 2019 06:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 500E92082E
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Apr 2019 06:37:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="qdWzfBTj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbfDLGh0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 02:37:26 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:41793 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbfDLGh0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 02:37:26 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44gSqj6xLHz9s5c;
        Fri, 12 Apr 2019 16:37:21 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1555051043;
        bh=/aL45c6y6k4uVrODejj/SYz5uSufI12V2NBjxR0gdns=;
        h=Date:From:To:Cc:Subject:From;
        b=qdWzfBTjLJGHQDaoMWAr7KCYG8YlkH3TTcFCBNQ3l/zChmSF+sVBf1uNxF/pepHTS
         8bWIMj//k/QUywv6jzW5lQrvlAnEFS8DgGMMFOZXvTIuCxIwD236PXv4+Enhjr5YjX
         HLe0FUuBAkb8nfDqh6O16Fp1mxiA+YBiaXS+unMhaiUt9GmH6QhTJHjdPTOIFMKUTq
         QumJH2U0gk/zoo3YbyZjJpYEr+oBOVqPbbUkDH6IOQ+QWyDa8imt4D9kuoQnjPn11U
         UO5ZZzOiGErXFLNQUYAiDLvZmj0GcsMqai1YIh7YPGvep9xVNKoqB31p1eH7mwSCHF
         /sOaPQiFKsr4g==
Date:   Fri, 12 Apr 2019 16:37:20 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: linux-next: build failure after merge of the netfilter-next tree
Message-ID: <20190412163720.576c6610@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/oR8njQFj0U8FUgPgAFadP=D"; protocol="application/pgp-signature"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--Sig_/oR8njQFj0U8FUgPgAFadP=D
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the netfilter tree, today's linux-next build (powerpc
ppc44x_defconfig) failed like this:

In file included from /home/sfr/next/next/net/bridge/br_input.c:19:
/home/sfr/next/next/include/net/netfilter/nf_queue.h:16:23: error: field 's=
tate'
 has incomplete type
  struct nf_hook_state state;
                       ^~~~~

Caused by commit

  971502d77faa ("bridge: netfilter: unroll NF_HOOK helper in bridge input p=
ath")

This build has CONFIG_NETFILTER not set.

I have applied this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 12 Apr 2019 16:32:47 +1000
Subject: [PATCH] bridge: only include nf_queue.h if needed

---
 net/bridge/br_input.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index e0aacfedcfe1..86dc46f6a68f 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -16,7 +16,9 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/netfilter_bridge.h>
+#ifdef CONFIG_NETFILTER_FAMILY_BRIDGE
 #include <net/netfilter/nf_queue.h>
+#endif
 #include <linux/neighbour.h>
 #include <net/arp.h>
 #include <linux/export.h>
--=20
2.20.1

--=20
Cheers,
Stephen Rothwell

--Sig_/oR8njQFj0U8FUgPgAFadP=D
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlywMiAACgkQAVBC80lX
0GylpAf+MwFoGn4mG286guZxJhwHgLa4J/ZQuJonNtQPbXxNNzJXpvJkfWZUm7h5
vQAf+NtuAVoC7vG4zGubdkjXBo6nN+OEQjcoJMLgyou0EjVJDoj47+r02S0LwbZ+
Flt/9IHsM9nN3qA2Rxdi+gSRv/NFMciwJQwORU8krfWpDRS3L8tArn4vwDoFCIir
K4y5ITYJ5RhWkA6ML6TGR3dVqCz1IQKJw7W3jTF/MliWhURIRvk8oMsAazOhHc/e
/vAjvYfb+Kchfc0MgZwEEYdiTgTq8M3mINkqSXmJBxLXjTJ47v8nHXjoTHGty5++
fgwLWm/A/zhfLYSFiKUJNgqliTzMsg==
=S0en
-----END PGP SIGNATURE-----

--Sig_/oR8njQFj0U8FUgPgAFadP=D--
