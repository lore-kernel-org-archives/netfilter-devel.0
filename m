Return-Path: <SRS0=eJXe=SP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8D3DC10F11
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 04:03:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B66320869
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 04:03:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="g3hH3jxm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725789AbfDMEDs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 Apr 2019 00:03:48 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:46451 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbfDMEDr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Apr 2019 00:03:47 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44h1Mz27T8z9s71;
        Sat, 13 Apr 2019 14:03:42 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1555128225;
        bh=iuGrqpeV+AQHpscD9oFWpa++C7nnsfEU6wyE4Mh12F4=;
        h=Date:From:To:Cc:Subject:From;
        b=g3hH3jxmAYpfCyb4P6d4KxglOKgkIUXkx4iHjMB2viemGpqeYuteryCcA0IJ3m6BB
         TZY67vfSMXf/T1BQFQdDcb+Z5pricluU/7laJ6RT6sZRO+FbX6IfmfbMDzYbk7FVkE
         H1m/jvzE+wPmlO4a9HLklCYrhQkoqEN+EDKktUMsf9ZCGGai6Ukj0WkFVGTi0xlvCE
         PCqrrQTcI2A9PMkRFetiK0TPHOr0MjSWDFnkqwsKBRH5cI9yTa+9ERIyYe6yVgrxst
         9LtayD1EWUohYB5VC6FtF0p+TYm86FT3PBD9bOg2F1Td1vfJGgokFnuLzwkpy888OP
         lxKA1cjwl4EhA==
Date:   Sat, 13 Apr 2019 14:03:36 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH netfilter-next] bridge: only include nf_queue.h if needed
Message-ID: <20190413140336.1c77bfc1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/2_Heq91rE2gKd.nbemAKTFG"; protocol="application/pgp-signature"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--Sig_/2_Heq91rE2gKd.nbemAKTFG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

After merging the netfilter-next tree, today's linux-next build (powerpc
ppc44x_defconfig) failed like this:

In file included from net/bridge/br_input.c:19:
include/net/netfilter/nf_queue.h:16:23: error: field 'state' has incomplete=
 type
  struct nf_hook_state state;
                       ^~~~~

Fixes: 971502d77faa ("bridge: netfilter: unroll NF_HOOK helper in bridge in=
put path")
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
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

--Sig_/2_Heq91rE2gKd.nbemAKTFG
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlyxX5gACgkQAVBC80lX
0GzrHQf/ci5aTImHaEe/yzBhxm8N6qFYZymfOl1bQh3o+5ultUngUwVDHSgXvuPo
WaMwYuXI1NinqZLY9aqzKrce2cNcYmZlqqXqsLbjOkLju3nOVJZeEn27Xod5SUVS
BEypBw55ZAPvxUE5Sbu8h0BGk/Mgzaa73OOrLfTcNi/lM32ypv0CmWTjzINf3USa
72M7g6PbvSuWBENp9NagsM1vSQXMWifvQeRNB80yJLJFPvb7g6PbNbwxnmnRlbe9
CqKEmjfATPQDzUeETbXQK4J7//JWJqOL44w8i7Kn7rRWZNF6bixlECNvfY62UU+0
dYRo2/hr4VjL6f0UyFEs7BHoWWLWLA==
=5LtA
-----END PGP SIGNATURE-----

--Sig_/2_Heq91rE2gKd.nbemAKTFG--
