Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27513C4338F
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Aug 2021 11:10:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03823604AC
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Aug 2021 11:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbhHTLKz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Aug 2021 07:10:55 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53192 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236784AbhHTLKz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Aug 2021 07:10:55 -0400
Received: from localhost.localdomain (unknown [213.94.13.0])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4CCF36019A
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Aug 2021 13:09:26 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: shell: add nft-f/0022variables_0 dump file
Date:   Fri, 20 Aug 2021 13:10:06 +0200
Message-Id: <20210820111006.21755-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Dump file was missing.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../nft-f/dumps/0022priority_variable_0.nft        |  5 -----
 .../testcases/nft-f/dumps/0022variables_0.nft      | 14 ++++++++++++++
 2 files changed, 14 insertions(+), 5 deletions(-)
 delete mode 100644 tests/shell/testcases/nft-f/dumps/0022priority_variable_0.nft
 create mode 100644 tests/shell/testcases/nft-f/dumps/0022variables_0.nft

diff --git a/tests/shell/testcases/nft-f/dumps/0022priority_variable_0.nft b/tests/shell/testcases/nft-f/dumps/0022priority_variable_0.nft
deleted file mode 100644
index 2e9445995e06..000000000000
--- a/tests/shell/testcases/nft-f/dumps/0022priority_variable_0.nft
+++ /dev/null
@@ -1,5 +0,0 @@
-table inet global {
-	chain prerouting {
-		type filter hook prerouting priority filter + 10; policy accept;
-	}
-}
diff --git a/tests/shell/testcases/nft-f/dumps/0022variables_0.nft b/tests/shell/testcases/nft-f/dumps/0022variables_0.nft
new file mode 100644
index 000000000000..d30f4d53a3ce
--- /dev/null
+++ b/tests/shell/testcases/nft-f/dumps/0022variables_0.nft
@@ -0,0 +1,14 @@
+table ip x {
+	set y {
+		type ipv4_addr
+		size 65535
+		flags dynamic,timeout
+	}
+
+	chain z {
+		type filter hook input priority filter; policy accept;
+		add @y { ip saddr }
+		update @y { ip saddr timeout 30s }
+		ip saddr @y
+	}
+}
-- 
2.20.1

