Return-Path: <SRS0=MXD6=UM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A31CC31E45
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Jun 2019 22:58:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E9AE2147A
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Jun 2019 22:58:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfFMW6g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 Jun 2019 18:58:36 -0400
Received: from mail.us.es ([193.147.175.20]:40746 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726575AbfFMW6g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Jun 2019 18:58:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C7585C3280
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jun 2019 00:58:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B8C23DA702
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jun 2019 00:58:33 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AE5D3DA701; Fri, 14 Jun 2019 00:58:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 56FA8DA702
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jun 2019 00:58:31 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 14 Jun 2019 00:58:31 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3D9314265A31
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jun 2019 00:58:31 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: use-after-free in meter
Date:   Fri, 14 Jun 2019 00:58:27 +0200
Message-Id: <20190613225827.32200-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Similar to bbe139fdf5a5 ("evaluate: use-after-free in implicit set").

==12727== Invalid read of size 4
==12727==    at 0x72DB515: expr_free (expression.c:86)
==12727==    by 0x72D3092: set_free (rule.c:367)
==12727==    by 0x72DB555: expr_destroy (expression.c:79)
==12727==    by 0x72DB555: expr_free (expression.c:95)
==12727==    by 0x72D7A35: meter_stmt_destroy (statement.c:137)
==12727==    by 0x72D7A07: stmt_free (statement.c:50)
==12727==    by 0x72D7AD7: stmt_list_free (statement.c:60)
==12727==    by 0x72D32EF: rule_free (rule.c:610)
==12727==    by 0x72D3834: chain_free (rule.c:827)
==12727==    by 0x72D45D4: table_free (rule.c:1184)
==12727==    by 0x72D46A7: __cache_flush (rule.c:293)
==12727==    by 0x72D472C: cache_release (rule.c:313)
==12727==    by 0x72D4A79: cache_update (rule.c:264)
==12727==  Address 0x64f14c8 is 56 bytes inside a block of size 128 free'd
==12727==    at 0x4C2CDDB: free (vg_replace_malloc.c:530)
==12727==    by 0x72D7A2C: meter_stmt_destroy (statement.c:136)
==12727==    by 0x72D7A07: stmt_free (statement.c:50)
==12727==    by 0x72D7AD7: stmt_list_free (statement.c:60)
==12727==    by 0x72D32EF: rule_free (rule.c:610)
==12727==    by 0x72D3834: chain_free (rule.c:827)
==12727==    by 0x72D45D4: table_free (rule.c:1184)
==12727==    by 0x72D46A7: __cache_flush (rule.c:293)
==12727==    by 0x72D472C: cache_release (rule.c:313)
==12727==    by 0x72D4A79: cache_update (rule.c:264)
==12727==    by 0x72F82CE: nft_evaluate (libnftables.c:388)
==12727==    by 0x72F8A8B: nft_run_cmd_from_buffer (libnftables.c:428)

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 4a06c7e8f673..a41a28e97288 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2114,7 +2114,8 @@ static int stmt_evaluate_meter(struct eval_ctx *ctx, struct stmt *stmt)
 	if (key->timeout)
 		set->set_flags |= NFT_SET_TIMEOUT;
 
-	setref = implicit_set_declaration(ctx, stmt->meter.name, key, set);
+	setref = implicit_set_declaration(ctx, stmt->meter.name,
+					  expr_get(key), set);
 
 	setref->set->desc.size = stmt->meter.size;
 	stmt->meter.set = setref;
-- 
2.11.0

