Return-Path: <SRS0=8OCJ=4F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13464C34022
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Feb 2020 14:13:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E53222072C
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Feb 2020 14:13:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgBQONt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Feb 2020 09:13:49 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:47404 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727132AbgBQONt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Feb 2020 09:13:49 -0500
Received: from localhost ([::1]:60494 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1j3h9g-0008JG-6W; Mon, 17 Feb 2020 15:13:48 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] nft: Drop pointless assignment
Date:   Mon, 17 Feb 2020 15:13:43 +0100
Message-Id: <20200217141343.13539-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No need to set 'i' to zero here, it is not used before the next
assignment.

Fixes: 77e6a93d5c9dc ("xtables: add and set "implict" flag on transaction objects")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 806b77fed462b..2f0a8c4a772f7 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2821,7 +2821,6 @@ retry:
 
 		nft_refresh_transaction(h);
 
-		i=0;
 		list_for_each_entry_safe(err, ne, &h->err_list, head)
 			mnl_err_list_free(err);
 
-- 
2.24.1

