Return-Path: <SRS0=mmp3=BP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4A2FC433E0
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Aug 2020 09:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E6892075A
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Aug 2020 09:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgHEJeV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Aug 2020 05:34:21 -0400
Received: from correo.us.es ([193.147.175.20]:49144 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728021AbgHEJdu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Aug 2020 05:33:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 84CCE11EB8A
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Aug 2020 11:33:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 76DFBDA73D
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Aug 2020 11:33:42 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6C897DA72F; Wed,  5 Aug 2020 11:33:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 28E88DA796
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Aug 2020 11:33:40 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 05 Aug 2020 11:33:40 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.174.3.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id BEFB24265A2F
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Aug 2020 11:33:39 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] segtree: memleaks in interval_map_decompose()
Date:   Wed,  5 Aug 2020 11:33:12 +0200
Message-Id: <20200805093312.26212-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

mpz_init_bitmask() overrides the existing memory area:

==19179== 8 bytes in 1 blocks are definitely lost in loss record 1 of 1
==19179==    at 0x483577F: malloc (vg_replace_malloc.c:299)
==19179==    by 0x489C718: xmalloc (utils.c:36)
==19179==    by 0x4B825C5: __gmpz_init2 (in /usr/lib/x86_64-linux-g nu/libgmp.so.10.3.2)                                               f
==19179==    by 0x4880239: constant_expr_alloc (expression.c:400)
==19179==    by 0x489B8A1: interval_map_decompose (segtree.c:1098)
==19179==    by 0x489017D: netlink_list_setelems (netlink.c:1220)
==19179==    by 0x48779AC: cache_init_objects (rule.c:170)         5
==19179==    by 0x48779AC: cache_init (rule.c:228)
==19179==    by 0x48779AC: cache_update (rule.c:279)
==19179==    by 0x48A21AE: nft_evaluate (libnftables.c:406)

left-hand side of the interval is leaked when building the range:

==25835== 368 (128 direct, 240 indirect) bytes in 1 blocks are definitely lost in loss record 5 of 5
==25835==    at 0x483577F: malloc (vg_replace_malloc.c:299)
==25835==    by 0x489B628: xmalloc (utils.c:36)
==25835==    by 0x489B6F8: xzalloc (utils.c:65)
==25835==    by 0x487E176: expr_alloc (expression.c:45)
==25835==    by 0x487F960: mapping_expr_alloc (expression.c:1149)
==25835==    by 0x488EC84: netlink_delinearize_setelem (netlink.c:1166)
==25835==    by 0x4DC6928: nftnl_set_elem_foreach (set_elem.c:725)
==25835==    by 0x488F0D5: netlink_list_setelems (netlink.c:1215)
==25835==    by 0x487695C: cache_init_objects (rule.c:170)
==25835==    by 0x487695C: cache_init (rule.c:228)
==25835==    by 0x487695C: cache_update (rule.c:279)
==25835==    by 0x48A10BE: nft_evaluate (libnftables.c:406)
==25835==    by 0x48A19B6: nft_run_cmd_from_buffer (libnftables.c:451)
==25835==    by 0x10A8E1: main (main.c:487)

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index a9b4b1bd6e2c..3a641bc56213 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -1097,16 +1097,20 @@ void interval_map_decompose(struct expr *set)
 
 	i = constant_expr_alloc(&low->location, low->dtype,
 				low->byteorder, expr_value(low)->len, NULL);
-	mpz_init_bitmask(i->value, i->len);
+	mpz_bitmask(i->value, i->len);
 
 	if (!mpz_cmp(i->value, expr_value(low)->value)) {
 		expr_free(i);
 		i = low;
 	} else {
-		i = range_expr_alloc(&low->location, expr_value(low), i);
+		i = range_expr_alloc(&low->location,
+				     expr_clone(expr_value(low)), i);
 		i = set_elem_expr_alloc(&low->location, i);
 		if (low->etype == EXPR_MAPPING)
-			i = mapping_expr_alloc(&i->location, i, low->right);
+			i = mapping_expr_alloc(&i->location, i,
+					       expr_clone(low->right));
+
+		expr_free(low);
 	}
 
 	compound_expr_add(set, i);
-- 
2.20.1

