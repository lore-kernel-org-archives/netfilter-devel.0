Return-Path: <SRS0=9u1R=UN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A073C31E44
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Jun 2019 09:58:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D18EC21773
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Jun 2019 09:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbfFNJ6t (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Jun 2019 05:58:49 -0400
Received: from mail.us.es ([193.147.175.20]:48872 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbfFNJ6t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Jun 2019 05:58:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 52B27C1A6F
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jun 2019 11:58:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 45BA8DA70B
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jun 2019 11:58:47 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3B193DA70A; Fri, 14 Jun 2019 11:58:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4988CDA711
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jun 2019 11:58:45 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 14 Jun 2019 11:58:45 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 289AA4265A5B
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jun 2019 11:58:45 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] evaluate: update byteorder only for implicit maps
Date:   Fri, 14 Jun 2019 11:58:40 +0200
Message-Id: <20190614095841.18119-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The byteorder adjustment for the integer datatype is only required by
implicit maps.

Fixes: b9b6092304ae ("evaluate: store byteorder for set keys")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index a41a28e97288..337b66c5ad2d 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -84,7 +84,8 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 	struct set *set;
 	struct handle h;
 
-	key_fix_dtype_byteorder(key);
+	if (expr->set_flags & NFT_SET_MAP)
+		key_fix_dtype_byteorder(key);
 
 	set = set_alloc(&expr->location);
 	set->flags	= NFT_SET_ANONYMOUS | expr->set_flags;
-- 
2.11.0

