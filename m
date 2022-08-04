Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76712C19F29
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Aug 2022 00:08:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239923AbiHDAIx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Aug 2022 20:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239921AbiHDAIx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Aug 2022 20:08:53 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 275A0DF23
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Aug 2022 17:08:52 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, vladbu@nvidia.com, ozsh@nvidia.com
Subject: [PATCH nf] netfilter: flowtable: fix incorrect Kconfig dependencies
Date:   Thu,  4 Aug 2022 02:08:43 +0200
Message-Id: <20220804000843.86722-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Remove default to 'y', this infrastructure is not fundamental for the
flowtable operational.

Add a missing dependency on CONFIG_NF_FLOW_TABLE.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Fixes: b038177636f8 ("netfilter: nf_flow_table: count pending offload workqueue tasks")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index df6abbfe0079..22f15ebf6045 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -736,9 +736,8 @@ config NF_FLOW_TABLE
 
 config NF_FLOW_TABLE_PROCFS
 	bool "Supply flow table statistics in procfs"
-	default y
+	depends on NF_FLOW_TABLE
 	depends on PROC_FS
-	depends on SYSCTL
 	help
 	  This option enables for the flow table offload statistics
 	  to be shown in procfs under net/netfilter/nf_flowtable.
-- 
2.30.2

