Return-Path: <SRS0=w/jS=XG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AE66C49ED6
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Sep 2019 11:56:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C37D20872
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Sep 2019 11:56:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfIKL4z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Sep 2019 07:56:55 -0400
Received: from correo.us.es ([193.147.175.20]:49334 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726928AbfIKL4z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Sep 2019 07:56:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1B5794A7064
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Sep 2019 13:56:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0D55C2E401
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Sep 2019 13:56:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 02D62CA0F3; Wed, 11 Sep 2019 13:56:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AFB74DA4CA
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Sep 2019 13:56:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 11 Sep 2019 13:56:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [47.60.32.60])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6449C42EE38E
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Sep 2019 13:56:47 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] libnftables: use-after-free in exit path
Date:   Wed, 11 Sep 2019 13:56:46 +0200
Message-Id: <20190911115646.5278-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

==29699== Invalid read of size 8
==29699==    at 0x507E140: ct_label_table_exit (ct.c:239)
==29699==    by 0x5091877: nft_exit (libnftables.c:97)
==29699==    by 0x5091877: nft_ctx_free (libnftables.c:297)
[...]
==29699==  Address 0xb251008 is 136 bytes inside a block of size 352 free'd
==29699==    at 0x4C2CDDB: free (vg_replace_malloc.c:530)
==29699==    by 0x509186F: nft_ctx_free (libnftables.c:296)
[...]
==29699==  Block was alloc'd at
==29699==    at 0x4C2DBC5: calloc (vg_replace_malloc.c:711)
==29699==    by 0x508C51D: xmalloc (utils.c:36)
==29699==    by 0x508C51D: xzalloc (utils.c:65)
==29699==    by 0x50916BE: nft_ctx_new (libnftables.c:151)
[...]

Release symbol tables before context object.

Fixes: 45cb29a2ada4 ("src: remove global symbol_table")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/libnftables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index b169dd2f2afe..a19636b22683 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -293,8 +293,8 @@ void nft_ctx_free(struct nft_ctx *ctx)
 	cache_release(&ctx->cache);
 	nft_ctx_clear_include_paths(ctx);
 	xfree(ctx->state);
-	xfree(ctx);
 	nft_exit(ctx);
+	xfree(ctx);
 }
 
 EXPORT_SYMBOL(nft_ctx_set_output);
-- 
2.11.0

