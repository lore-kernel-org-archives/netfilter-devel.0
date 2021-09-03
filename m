Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01C2CC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Sep 2021 08:29:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D08E761058
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Sep 2021 08:29:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348210AbhICIaV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Sep 2021 04:30:21 -0400
Received: from mail.netfilter.org ([217.70.188.207]:57414 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348150AbhICIaV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Sep 2021 04:30:21 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1C1506008B
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Sep 2021 10:28:19 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] include: add NFT_CTX_OUTPUT_NUMERIC_TIME to NFT_CTX_OUTPUT_NUMERIC_ALL
Date:   Fri,  3 Sep 2021 10:29:16 +0200
Message-Id: <20210903082916.7630-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Therefore, -n honors numeric time in seconds.

Fixes: f8f32deda31d ("meta: Introduce new conditions 'time', 'day' and 'hour'")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/nftables/libnftables.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/nftables/libnftables.h b/include/nftables/libnftables.h
index 8e7151a324b0..957b5fbee243 100644
--- a/include/nftables/libnftables.h
+++ b/include/nftables/libnftables.h
@@ -55,7 +55,8 @@ enum {
 	NFT_CTX_OUTPUT_NUMERIC_TIME	= (1 << 10),
 	NFT_CTX_OUTPUT_NUMERIC_ALL	= (NFT_CTX_OUTPUT_NUMERIC_PROTO |
 					   NFT_CTX_OUTPUT_NUMERIC_PRIO |
-					   NFT_CTX_OUTPUT_NUMERIC_SYMBOL),
+					   NFT_CTX_OUTPUT_NUMERIC_SYMBOL |
+					   NFT_CTX_OUTPUT_NUMERIC_TIME),
 	NFT_CTX_OUTPUT_TERSE		= (1 << 11),
 };
 
-- 
2.20.1

