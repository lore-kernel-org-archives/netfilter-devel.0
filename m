Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1077EC48BDF
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Jun 2021 18:41:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBA13606A5
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Jun 2021 18:41:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhFJSnl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 14:43:41 -0400
Received: from mail.netfilter.org ([217.70.188.207]:35082 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbhFJSnl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 14:43:41 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id D48FD64231
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Jun 2021 20:40:29 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: shell: extend connlimit test
Date:   Thu, 10 Jun 2021 20:41:36 +0200
Message-Id: <20210610184136.1420-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extend existing test to add a ct count expression in the set definition.

This test cover the upstream kernel fix ad9f151e560b ("netfilter:
nf_tables: initialize set before expression setup").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/sets/0062set_connlimit_0 | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tests/shell/testcases/sets/0062set_connlimit_0 b/tests/shell/testcases/sets/0062set_connlimit_0
index 4f95f3835f83..48d589fe68cc 100755
--- a/tests/shell/testcases/sets/0062set_connlimit_0
+++ b/tests/shell/testcases/sets/0062set_connlimit_0
@@ -12,3 +12,15 @@ RULESET="table ip x {
 }"
 
 $NFT -f - <<< $RULESET
+
+RULESET="table ip x {
+	set new-connlimit {
+		type ipv4_addr
+		size 65535
+		flags dynamic
+		ct count over 20
+		elements = { 84.245.120.167 }
+	}
+}"
+
+$NFT -f - <<< $RULESET
-- 
2.30.2

