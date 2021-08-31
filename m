Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5BE6C432BE
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Aug 2021 12:14:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B535561029
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Aug 2021 12:14:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240078AbhHaMPa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Aug 2021 08:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239965AbhHaMPU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Aug 2021 08:15:20 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD36C03541C
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Aug 2021 05:08:00 -0700 (PDT)
Received: from localhost ([::1]:37562 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mL2YY-0006Va-Gl; Tue, 31 Aug 2021 14:07:58 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/2] nft: Use xtables_malloc() in mnl_err_list_node_add()
Date:   Tue, 31 Aug 2021 14:08:29 +0200
Message-Id: <20210831120830.6414-1-phil@nwl.cc>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The function called malloc() without checking for memory allocation
failure. Simply replace the call by xtables_malloc() to fix that.

Fixes: 4e2020952d6f9 ("xtables: use libnftnl batch API")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 795dff8605404..a470939db54fb 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -143,7 +143,7 @@ struct mnl_err {
 static void mnl_err_list_node_add(struct list_head *err_list, int error,
 				  int seqnum)
 {
-	struct mnl_err *err = malloc(sizeof(struct mnl_err));
+	struct mnl_err *err = xtables_malloc(sizeof(struct mnl_err));
 
 	err->seqnum = seqnum;
 	err->err = error;
-- 
2.32.0

