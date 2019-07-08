Return-Path: <SRS0=pcH3=VF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAA36C5B57D
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 03:40:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AA3820665
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 03:40:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="q2TXKGkn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbfGHDkD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 7 Jul 2019 23:40:03 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:40829 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727286AbfGHDkD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 Jul 2019 23:40:03 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45hrmv5V9Gz9sN1;
        Mon,  8 Jul 2019 13:39:59 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1562557200;
        bh=39hnV0Tn7e7+rBTWWb3IWz3qcT1/yKjynR7c6gY2tpM=;
        h=Date:From:To:Cc:Subject:From;
        b=q2TXKGknUvxY8o2CSVNwg0T1ZR+2Vu4s+CBh554LpwGqgERmVa68CU/FvaUFgtisB
         IzjjJX3QSVtY0Vt1dcx8e6WrGxcy+gcY8/lZeU87UJcv8lgom+WOJqdFMcHCLeE1s2
         gPYVMyzO3/pEnOmiEv9fscnteTqfVsztrM50eKqyiqua2ZrE7/QKAauQx43lHkB1Dy
         vwPRQb8dUQXTndGNY0ps1wOFrdtMktXJFqaxDH+q9RaDhG+i2mHbjcTgsDiBGidSX0
         Cv14v2USJenE1tV5EGXbxiH27sPLMjPJaYW0Z2j4m3g7pLGulUczcszcQQBwa1qh2W
         SC2yAyYkp8MeQ==
Date:   Mon, 8 Jul 2019 13:39:58 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        wenxu <wenxu@ucloud.cn>
Subject: linux-next: build failure after merge of the netfilter-next tree
Message-ID: <20190708133958.6a30f5cb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/h4fLp5t4l=mmg./plMjkz4y"; protocol="application/pgp-signature"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--Sig_/h4fLp5t4l=mmg./plMjkz4y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the netfilter-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from <command-line>:
include/net/netfilter/nft_meta.h:6:21: warning: 'key' is narrower than valu=
es of its type
  enum nft_meta_keys key:8;
                     ^~~
include/net/netfilter/nft_meta.h:6:21: error: field 'key' has incomplete ty=
pe
include/net/netfilter/nft_meta.h:8:22: warning: 'dreg' is narrower than val=
ues of its type
   enum nft_registers dreg:8;
                      ^~~~
include/net/netfilter/nft_meta.h:8:22: error: field 'dreg' has incomplete t=
ype
include/net/netfilter/nft_meta.h:9:22: warning: 'sreg' is narrower than val=
ues of its type
   enum nft_registers sreg:8;
                      ^~~~
include/net/netfilter/nft_meta.h:9:22: error: field 'sreg' has incomplete t=
ype
include/net/netfilter/nft_meta.h:13:32: error: array type has incomplete el=
ement type 'struct nla_policy'
 extern const struct nla_policy nft_meta_policy[];
                                ^~~~~~~~~~~~~~~
include/net/netfilter/nft_meta.h:17:22: warning: 'struct nlattr' declared i=
nside parameter list will not be visible outside of this definition or decl=
aration
         const struct nlattr * const tb[]);
                      ^~~~~~
include/net/netfilter/nft_meta.h:16:22: warning: 'struct nft_expr' declared=
 inside parameter list will not be visible outside of this definition or de=
claration
         const struct nft_expr *expr,
                      ^~~~~~~~
include/net/netfilter/nft_meta.h:15:36: warning: 'struct nft_ctx' declared =
inside parameter list will not be visible outside of this definition or dec=
laration
 int nft_meta_get_init(const struct nft_ctx *ctx,
                                    ^~~~~~~
include/net/netfilter/nft_meta.h:21:22: warning: 'struct nlattr' declared i=
nside parameter list will not be visible outside of this definition or decl=
aration
         const struct nlattr * const tb[]);
                      ^~~~~~
include/net/netfilter/nft_meta.h:20:22: warning: 'struct nft_expr' declared=
 inside parameter list will not be visible outside of this definition or de=
claration
         const struct nft_expr *expr,
                      ^~~~~~~~
include/net/netfilter/nft_meta.h:19:36: warning: 'struct nft_ctx' declared =
inside parameter list will not be visible outside of this definition or dec=
laration
 int nft_meta_set_init(const struct nft_ctx *ctx,
                                    ^~~~~~~
include/net/netfilter/nft_meta.h:24:22: warning: 'struct nft_expr' declared=
 inside parameter list will not be visible outside of this definition or de=
claration
         const struct nft_expr *expr);
                      ^~~~~~~~
include/net/netfilter/nft_meta.h:23:30: warning: 'struct sk_buff' declared =
inside parameter list will not be visible outside of this definition or dec=
laration
 int nft_meta_get_dump(struct sk_buff *skb,
                              ^~~~~~~
include/net/netfilter/nft_meta.h:27:22: warning: 'struct nft_expr' declared=
 inside parameter list will not be visible outside of this definition or de=
claration
         const struct nft_expr *expr);
                      ^~~~~~~~
include/net/netfilter/nft_meta.h:26:30: warning: 'struct sk_buff' declared =
inside parameter list will not be visible outside of this definition or dec=
laration
 int nft_meta_set_dump(struct sk_buff *skb,
                              ^~~~~~~
include/net/netfilter/nft_meta.h:31:23: warning: 'struct nft_pktinfo' decla=
red inside parameter list will not be visible outside of this definition or=
 declaration
          const struct nft_pktinfo *pkt);
                       ^~~~~~~~~~~
include/net/netfilter/nft_meta.h:30:17: warning: 'struct nft_regs' declared=
 inside parameter list will not be visible outside of this definition or de=
claration
          struct nft_regs *regs,
                 ^~~~~~~~
include/net/netfilter/nft_meta.h:29:37: warning: 'struct nft_expr' declared=
 inside parameter list will not be visible outside of this definition or de=
claration
 void nft_meta_get_eval(const struct nft_expr *expr,
                                     ^~~~~~~~
include/net/netfilter/nft_meta.h:35:23: warning: 'struct nft_pktinfo' decla=
red inside parameter list will not be visible outside of this definition or=
 declaration
          const struct nft_pktinfo *pkt);
                       ^~~~~~~~~~~
include/net/netfilter/nft_meta.h:34:17: warning: 'struct nft_regs' declared=
 inside parameter list will not be visible outside of this definition or de=
claration
          struct nft_regs *regs,
                 ^~~~~~~~
include/net/netfilter/nft_meta.h:33:37: warning: 'struct nft_expr' declared=
 inside parameter list will not be visible outside of this definition or de=
claration
 void nft_meta_set_eval(const struct nft_expr *expr,
                                     ^~~~~~~~
include/net/netfilter/nft_meta.h:38:19: warning: 'struct nft_expr' declared=
 inside parameter list will not be visible outside of this definition or de=
claration
      const struct nft_expr *expr);
                   ^~~~~~~~
include/net/netfilter/nft_meta.h:37:40: warning: 'struct nft_ctx' declared =
inside parameter list will not be visible outside of this definition or dec=
laration
 void nft_meta_set_destroy(const struct nft_ctx *ctx,
                                        ^~~~~~~
include/net/netfilter/nft_meta.h:42:19: warning: 'struct nft_data' declared=
 inside parameter list will not be visible outside of this definition or de=
claration
      const struct nft_data **data);
                   ^~~~~~~~
include/net/netfilter/nft_meta.h:41:19: warning: 'struct nft_expr' declared=
 inside parameter list will not be visible outside of this definition or de=
claration
      const struct nft_expr *expr,
                   ^~~~~~~~
include/net/netfilter/nft_meta.h:40:40: warning: 'struct nft_ctx' declared =
inside parameter list will not be visible outside of this definition or dec=
laration
 int nft_meta_set_validate(const struct nft_ctx *ctx,
                                        ^~~~~~~

Caused by commit

  30e103fe24de ("netfilter: nft_meta: move bridge meta keys into nft_meta_b=
ridge")

interacting with commit

  3a768d9f7ae5 ("kbuild: compile-test kernel headers to ensure they are sel=
f-contained")

from the kbuild tree.

I have applied the following patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 8 Jul 2019 13:34:42 +1000
Subject: [PATCH] don't test build another netfilter header

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/Kbuild | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/Kbuild b/include/Kbuild
index 78434c59701f..cfd73c94d015 100644
--- a/include/Kbuild
+++ b/include/Kbuild
@@ -900,6 +900,7 @@ header-test-			+=3D net/netfilter/nf_tables_core.h
 header-test-			+=3D net/netfilter/nf_tables_ipv4.h
 header-test-			+=3D net/netfilter/nf_tables_ipv6.h
 header-test-			+=3D net/netfilter/nft_fib.h
+header-test-			+=3D net/netfilter/nft_meta.h
 header-test-			+=3D net/netfilter/nft_reject.h
 header-test-			+=3D net/netns/can.h
 header-test-			+=3D net/netns/generic.h
--=20
2.20.1

--=20
Cheers,
Stephen Rothwell

--Sig_/h4fLp5t4l=mmg./plMjkz4y
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0iuw4ACgkQAVBC80lX
0GzFBQf/b/YE1PdhlGCXXYtciFUNz6F/q06Jom3PElXtxUPS4c/8BevEMLw5s5s0
8njf6f782BbbgIP7EJaZIQHVVnk6ROr+AUXi1uWwALViruEaVvvHDg3bIX9miu17
P2bVHSGit5vAsYUe++AlylfjrFuAt07wXTcJ7vZ9lSv5ddZ+ARev8yMpZaEJi75Q
Y7nWEKkWDAbzcchit4Srp5PcYszldXNnyZEfSgZOWeKpWVaFGJGoUprkHTLdciS1
V7FASRGW0b1tieoTY9/vIj6gbEBPnxASBNbM3VwnLINqAEMM7XUzOVIx1YQmE/XV
NximHTIu89QjKc/4u89SqM5ESd+P5Q==
=Okfl
-----END PGP SIGNATURE-----

--Sig_/h4fLp5t4l=mmg./plMjkz4y--
