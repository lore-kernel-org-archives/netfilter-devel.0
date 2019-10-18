Return-Path: <SRS0=5/AD=YL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 161FACA9EA0
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Oct 2019 15:51:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE1FF2064A
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Oct 2019 15:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390044AbfJRPvY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Oct 2019 11:51:24 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:44346 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389072AbfJRPvY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Oct 2019 11:51:24 -0400
Received: from localhost ([::1]:57436 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iLUXD-0006Kb-6J; Fri, 18 Oct 2019 17:51:23 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] nft: Use ARRAY_SIZE() macro in nft_strerror()
Date:   Fri, 18 Oct 2019 17:51:14 +0200
Message-Id: <20191018155114.7423-1-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Variable 'table' is an array of type struct table_struct, so this is a
classical use-case for ARRAY_SIZE() macro.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 89b1c7a808f57..3c230c121f8b9 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2888,7 +2888,7 @@ const char *nft_strerror(int err)
 	    { NULL, ENOENT, "No chain/target/match by that name" },
 	  };
 
-	for (i = 0; i < sizeof(table)/sizeof(struct table_struct); i++) {
+	for (i = 0; i < ARRAY_SIZE(table); i++) {
 		if ((!table[i].fn || table[i].fn == nft_fn)
 		    && table[i].err == err)
 			return table[i].message;
-- 
2.23.0

