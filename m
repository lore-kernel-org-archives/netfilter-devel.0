Return-Path: <SRS0=RE83=6O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB5DAC8300B
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Apr 2020 12:18:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95D222076D
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Apr 2020 12:18:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgD3MSx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Apr 2020 08:18:53 -0400
Received: from correo.us.es ([193.147.175.20]:47942 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726500AbgD3MSw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Apr 2020 08:18:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C097B6D008
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2020 14:18:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A7C0CB7FFF
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2020 14:18:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7FF7BB7FFD; Thu, 30 Apr 2020 14:18:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DF689B7FF3;
        Thu, 30 Apr 2020 14:18:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 30 Apr 2020 14:18:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id BDE7042EFB80;
        Thu, 30 Apr 2020 14:18:47 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft] rule: memleak in __do_add_setelems()
Date:   Thu, 30 Apr 2020 14:18:45 +0200
Message-Id: <20200430121845.10388-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch invokes interval_map_decompose() with named sets:

==3402== 2,352 (128 direct, 2,224 indirect) bytes in 1 blocks are definitely lost in loss record 9 of 9
==3402==    at 0x483577F: malloc (vg_replace_malloc.c:299)
==3402==    by 0x48996A8: xmalloc (utils.c:36)
==3402==    by 0x4899778: xzalloc (utils.c:65)
==3402==    by 0x487CB46: expr_alloc (expression.c:45)
==3402==    by 0x487E2A0: mapping_expr_alloc (expression.c:1140)
==3402==    by 0x4898AA8: interval_map_decompose (segtree.c:1095)
==3402==    by 0x4872BDF: __do_add_setelems (rule.c:1569)
==3402==    by 0x4872BDF: __do_add_setelems (rule.c:1559)
==3402==    by 0x4877936: do_command (rule.c:2710)
==3402==    by 0x489F1CB: nft_netlink.isra.5 (libnftables.c:42)
==3402==    by 0x489FB07: nft_run_cmd_from_filename (libnftables.c:508)
==3402==    by 0x10A9AA: main (main.c:455)

Fixes: dd44081d91ce ("segtree: Fix add and delete of element in same batch")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index 633ca13639ad..9e80c0251947 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1563,7 +1563,8 @@ static int __do_add_setelems(struct netlink_ctx *ctx, struct set *set,
 	if (mnl_nft_setelem_add(ctx, set, expr, flags) < 0)
 		return -1;
 
-	if (set->init != NULL &&
+	if (!set_is_anonymous(set->flags) &&
+	    set->init != NULL &&
 	    set->flags & NFT_SET_INTERVAL &&
 	    set->desc.field_count <= 1) {
 		interval_map_decompose(expr);
-- 
2.20.1

