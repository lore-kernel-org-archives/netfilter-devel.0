Return-Path: <SRS0=/SeC=YO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1C1ACA9EAF
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Oct 2019 16:56:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 882E32064B
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Oct 2019 16:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfJUQ4N (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Oct 2019 12:56:13 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:51726 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726276AbfJUQ4N (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Oct 2019 12:56:13 -0400
Received: from localhost ([::1]:36584 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iMayZ-0008G9-Oy; Mon, 21 Oct 2019 18:56:11 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] main: Fix for misleading error with negative chain priority
Date:   Mon, 21 Oct 2019 18:56:03 +0200
Message-Id: <20191021165603.32467-1-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

getopt_long() would try to parse the negative priority as an option and
return -1 as it is not known:

| # nft add chain x y { type filter hook input priority -30\; }
| nft: invalid option -- '3'

Fix this by prefixing optstring with a plus character. This instructs
getopt_long() to not collate arguments but just stop after the first
non-option, leaving the rest for manual handling. In fact, this is just
what nft desires: mixing options with nft syntax leads to confusive
command lines anyway.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/main.c                                           | 2 +-
 tests/shell/testcases/chains/0039negative_priority_0 | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)
 create mode 100755 tests/shell/testcases/chains/0039negative_priority_0

diff --git a/src/main.c b/src/main.c
index f77d8a820a028..577850e54f68c 100644
--- a/src/main.c
+++ b/src/main.c
@@ -45,7 +45,7 @@ enum opt_vals {
 	OPT_NUMERIC_TIME	= 't',
 	OPT_INVALID		= '?',
 };
-#define OPTSTRING	"hvcf:iI:jvnsNaeSupypt"
+#define OPTSTRING	"+hvcf:iI:jvnsNaeSupypt"
 
 static const struct option options[] = {
 	{
diff --git a/tests/shell/testcases/chains/0039negative_priority_0 b/tests/shell/testcases/chains/0039negative_priority_0
new file mode 100755
index 0000000000000..ba17b8cc19eda
--- /dev/null
+++ b/tests/shell/testcases/chains/0039negative_priority_0
@@ -0,0 +1,8 @@
+#!/bin/bash
+
+# Test parsing of negative priority values
+
+set -e
+
+$NFT add table t
+$NFT add chain t c { type filter hook input priority -30\; }
-- 
2.23.0

