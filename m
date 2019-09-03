Return-Path: <SRS0=xNQb=W6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 121F6C3A5A2
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Sep 2019 23:27:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7A6E2339D
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Sep 2019 23:27:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfICX1R (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Sep 2019 19:27:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47370 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbfICX1R (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Sep 2019 19:27:17 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2190A18C4264;
        Tue,  3 Sep 2019 23:27:16 +0000 (UTC)
Received: from egarver.remote.csb.redhat.com (ovpn-120-189.rdu2.redhat.com [10.10.120.189])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A55B95C219;
        Tue,  3 Sep 2019 23:27:15 +0000 (UTC)
From:   Eric Garver <eric@garver.life>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] tests: shell: check that rule add with index works with echo
Date:   Tue,  3 Sep 2019 19:27:13 -0400
Message-Id: <20190903232713.14394-1-eric@garver.life>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.62]); Tue, 03 Sep 2019 23:27:16 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If --echo is used the rule cache will not be populated. This causes
rules added using the "index" keyword to be simply appended to the
chain. The bug was introduced in commit 3ab02db5f836 ("cache: add
NFT_CACHE_UPDATE and NFT_CACHE_FLUSHED flags").

Signed-off-by: Eric Garver <eric@garver.life>
---
I think the issue is in cache_evaluate(). It sets the flags to
NFT_CACHE_FULL and then bails early, but I'm not sure of the best way to
fix it. So I'll start by submitting a test case. :)
---
 tests/shell/testcases/cache/0007_echo_cache_init_0 | 14 ++++++++++++++
 .../cache/dumps/0007_echo_cache_init_0.nft         |  7 +++++++
 2 files changed, 21 insertions(+)
 create mode 100755 tests/shell/testcases/cache/0007_echo_cache_init_0
 create mode 100644 tests/shell/testcases/cache/dumps/0007_echo_cache_init_0.nft

diff --git a/tests/shell/testcases/cache/0007_echo_cache_init_0 b/tests/shell/testcases/cache/0007_echo_cache_init_0
new file mode 100755
index 000000000000..280a0d06bdc3
--- /dev/null
+++ b/tests/shell/testcases/cache/0007_echo_cache_init_0
@@ -0,0 +1,14 @@
+#!/bin/bash
+
+set -e
+
+$NFT -i >/dev/null <<EOF
+add table inet t
+add chain inet t c
+add rule inet t c accept comment "first"
+add rule inet t c accept comment "third"
+EOF
+
+# make sure the rule cache gets initialized when using echo option
+#
+$NFT --echo add rule inet t c index 0 accept comment '"second"' >/dev/null
diff --git a/tests/shell/testcases/cache/dumps/0007_echo_cache_init_0.nft b/tests/shell/testcases/cache/dumps/0007_echo_cache_init_0.nft
new file mode 100644
index 000000000000..c774ee72a683
--- /dev/null
+++ b/tests/shell/testcases/cache/dumps/0007_echo_cache_init_0.nft
@@ -0,0 +1,7 @@
+table inet t {
+	chain c {
+		accept comment "first"
+		accept comment "second"
+		accept comment "third"
+	}
+}
-- 
2.20.1

