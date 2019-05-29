Return-Path: <SRS0=BqdC=T5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CD37C28CC0
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 13:14:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 153AB205F4
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 13:14:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfE2NOK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 May 2019 09:14:10 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:40282 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbfE2NOK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 May 2019 09:14:10 -0400
Received: from localhost ([::1]:53370 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hVyPB-0006xG-7G; Wed, 29 May 2019 15:14:09 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: [nft PATCH 4/4] tests/shell: Test large transaction with echo output
Date:   Wed, 29 May 2019 15:13:46 +0200
Message-Id: <20190529131346.23659-5-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190529131346.23659-1-phil@nwl.cc>
References: <20190529131346.23659-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This reliably triggered ENOBUFS condition in mnl_batch_talk(). With the
past changes, it passes even after increasing the number of rules to
300k.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/testcases/transactions/0049huge_0 | 14 ++++++++++++++
 1 file changed, 14 insertions(+)
 create mode 100755 tests/shell/testcases/transactions/0049huge_0

diff --git a/tests/shell/testcases/transactions/0049huge_0 b/tests/shell/testcases/transactions/0049huge_0
new file mode 100755
index 0000000000000..12338087c63e0
--- /dev/null
+++ b/tests/shell/testcases/transactions/0049huge_0
@@ -0,0 +1,14 @@
+#!/bin/bash
+
+# let's try to exceed transaction buffer space
+
+$NFT flush ruleset
+$NFT add table inet test
+$NFT add chain inet test c
+
+RULESET=$(
+for ((i = 0; i < 3000; i++)); do
+	echo "add rule inet test c accept comment rule$i"
+done
+)
+$NFT -e -f - <<< "$RULESET" >/dev/null
-- 
2.21.0

