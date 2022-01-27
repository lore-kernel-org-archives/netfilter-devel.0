Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A793C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jan 2022 16:53:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234331AbiA0QxJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jan 2022 11:53:09 -0500
Received: from mail.netfilter.org ([217.70.188.207]:39510 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244138AbiA0QxI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jan 2022 11:53:08 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 19C2460693
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jan 2022 17:50:04 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_tables: remove assignment with no effect in chain blob builder
Date:   Thu, 27 Jan 2022 17:53:04 +0100
Message-Id: <20220127165304.510741-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

cppcheck possible warnings:

>> net/netfilter/nf_tables_api.c:2014:2: warning: Assignment of function parameter has no effect outside the function. Did you forget dereferencing it? [uselessAssignmentPtrArg]
    ptr += offsetof(struct nft_rule_dp, data);
    ^

Reported-by: kernel test robot <yujie.liu@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index cf454f8ca2b0..5fa16990da95 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2011,7 +2011,6 @@ static void nft_last_rule(struct nft_rule_blob *blob, const void *ptr)
 
 	prule = (struct nft_rule_dp *)ptr;
 	prule->is_last = 1;
-	ptr += offsetof(struct nft_rule_dp, data);
 	/* blob size does not include the trailer rule */
 }
 
-- 
2.30.2

