Return-Path: <SRS0=Vh4p=6F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B21CC54FD0
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Apr 2020 12:35:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30D912071C
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Apr 2020 12:35:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbgDUMfk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Apr 2020 08:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726018AbgDUMfk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Apr 2020 08:35:40 -0400
X-Greylist: delayed 596 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 21 Apr 2020 05:35:40 PDT
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690F7C061A10
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Apr 2020 05:35:40 -0700 (PDT)
Received: from localhost ([::1]:47350 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jQs7n-0000ax-8k; Tue, 21 Apr 2020 14:35:39 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] xshared: Drop pointless assignment in add_param_to_argv()
Date:   Tue, 21 Apr 2020 14:35:30 +0200
Message-Id: <20200421123530.31231-1-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This must be a leftover from a previous cleanup.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xshared.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index 16c58914e59a5..c1d1371a6d54a 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -495,7 +495,6 @@ void add_param_to_argv(struct argv_store *store, char *parsestart, int line)
 				continue;
 			} else if (*curchar == '"') {
 				quote_open = 0;
-				*curchar = '"';
 			} else {
 				add_param(&param, curchar);
 				continue;
-- 
2.25.1

