Return-Path: <SRS0=4pKc=6U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 244C1C28CBC
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 20:36:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DDB92075E
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 20:36:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbgEFUg4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 May 2020 16:36:56 -0400
Received: from correo.us.es ([193.147.175.20]:34528 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726093AbgEFUg4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 May 2020 16:36:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D9619E862E
        for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2020 22:36:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C9D323332
        for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2020 22:36:54 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BF362DA7B2; Wed,  6 May 2020 22:36:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B9FA52004A
        for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2020 22:36:52 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 06 May 2020 22:36:52 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A71FA42EF42B
        for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2020 22:36:52 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: fix netlink_get_setelem() memleaks
Date:   Wed,  6 May 2020 22:36:49 +0200
Message-Id: <20200506203649.2235-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

==26693==ERROR: LeakSanitizer: detected memory leaks

Direct leak of 256 byte(s) in 2 object(s) allocated from:
    #0 0x7f6ce2189330 in __interceptor_malloc (/usr/lib/x86_64-linux-gnu/libasan.so.5+0xe9330)
    #1 0x7f6ce1b1767a in xmalloc /home/pablo/devel/scm/git-netfilter/nftables/src/utils.c:36
    #2 0x7f6ce1b177d3 in xzalloc /home/pablo/devel/scm/git-netfilter/nftables/src/utils.c:65
    #3 0x7f6ce1a41760 in expr_alloc /home/pablo/devel/scm/git-netfilter/nftables/src/expression.c:45
    #4 0x7f6ce1a4dea7 in set_elem_expr_alloc /home/pablo/devel/scm/git-netfilter/nftables/src/expression.c:1278
    #5 0x7f6ce1ac2215 in netlink_delinearize_setelem /home/pablo/devel/scm/git-netfilter/nftables/src/netlink.c:1094
    #6 0x7f6ce1ac3c16 in list_setelem_cb /home/pablo/devel/scm/git-netfilter/nftables/src/netlink.c:1172
    #7 0x7f6ce0198808 in nftnl_set_elem_foreach /home/pablo/devel/scm/git-netfilter/libnftnl/src/set_elem.c:725

Indirect leak of 256 byte(s) in 2 object(s) allocated from:
    #0 0x7f6ce2189330 in __interceptor_malloc (/usr/lib/x86_64-linux-gnu/libasan.so.5+0xe9330)
    #1 0x7f6ce1b1767a in xmalloc /home/pablo/devel/scm/git-netfilter/nftables/src/utils.c:36
    #2 0x7f6ce1b177d3 in xzalloc /home/pablo/devel/scm/git-netfilter/nftables/src/utils.c:65
    #3 0x7f6ce1a41760 in expr_alloc /home/pablo/devel/scm/git-netfilter/nftables/src/expression.c:45
    #4 0x7f6ce1a4515d in constant_expr_alloc /home/pablo/devel/scm/git-netfilter/nftables/src/expression.c:388
    #5 0x7f6ce1abaf12 in netlink_alloc_value /home/pablo/devel/scm/git-netfilter/nftables/src/netlink.c:354
    #6 0x7f6ce1ac17f5 in netlink_delinearize_setelem /home/pablo/devel/scm/git-netfilter/nftables/src/netlink.c:1080
    #7 0x7f6ce1ac3c16 in list_setelem_cb /home/pablo/devel/scm/git-netfilter/nftables/src/netlink.c:1172
    #8 0x7f6ce0198808 in nftnl_set_elem_foreach /home/pablo/devel/scm/git-netfilter/libnftnl/src/set_elem.c:725

Indirect leak of 16 byte(s) in 1 object(s) allocated from:
    #0 0x7f6ce2189720 in __interceptor_realloc (/usr/lib/x86_64-linux-gnu/libasan.so.5+0xe9720)
    #1 0x7f6ce1b1778d in xrealloc /home/pablo/devel/scm/git-netfilter/nftables/src/utils.c:55
    #2 0x7f6ce1b1756d in gmp_xrealloc /home/pablo/devel/scm/git-netfilter/nftables/src/gmputil.c:202
    #3 0x7f6ce1417059 in __gmpz_realloc (/usr/lib/x86_64-linux-gnu/libgmp.so.10+0x23059)

Indirect leak of 8 byte(s) in 1 object(s) allocated from:
    #0 0x7f6ce2189330 in __interceptor_malloc (/usr/lib/x86_64-linux-gnu/libasan.so.5+0xe9330)
    #1 0x7f6ce1b1767a in xmalloc /home/pablo/devel/scm/git-netfilter/nftables/src/utils.c:36
    #2 0x7f6ce14105c5 in __gmpz_init2 (/usr/lib/x86_64-linux-gnu/libgmp.so.10+0x1c5c5)

SUMMARY: AddressSanitizer: 536 byte(s) leaked in 6 allocation(s).

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink.c | 4 +++-
 src/segtree.c | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/src/netlink.c b/src/netlink.c
index bb014320ea6c..fb0a17bac0d7 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1236,8 +1236,10 @@ int netlink_get_setelem(struct netlink_ctx *ctx, const struct handle *h,
 	netlink_dump_set(nls, ctx);
 
 	nls_out = mnl_nft_setelem_get_one(ctx, nls);
-	if (!nls_out)
+	if (!nls_out) {
+		nftnl_set_free(nls);
 		return -1;
+	}
 
 	ctx->set = set;
 	set->init = set_expr_alloc(loc, set);
diff --git a/src/segtree.c b/src/segtree.c
index 2b5831f2d64b..266a2b4dc98b 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -744,6 +744,8 @@ int get_set_decompose(struct table *table, struct set *set)
 				errno = ENOENT;
 				return -1;
 			}
+			expr_free(left);
+			expr_free(i);
 
 			compound_expr_add(new_init, range);
 			left = NULL;
-- 
2.20.1

