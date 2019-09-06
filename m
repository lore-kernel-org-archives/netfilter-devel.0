Return-Path: <SRS0=fPey=XB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C8C4C00306
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Sep 2019 00:33:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E0C820820
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Sep 2019 00:33:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391555AbfIFAdF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Sep 2019 20:33:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60696 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390838AbfIFAdF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Sep 2019 20:33:05 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4E94F18C4271;
        Fri,  6 Sep 2019 00:33:05 +0000 (UTC)
Received: from egarver.remote.csb (ovpn-122-8.rdu2.redhat.com [10.10.122.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D477F19C77;
        Fri,  6 Sep 2019 00:33:04 +0000 (UTC)
From:   Eric Garver <eric@garver.life>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2] tests: shell: check that rule add with index works with echo
Date:   Thu,  5 Sep 2019 20:33:02 -0400
Message-Id: <20190906003302.25953-2-eric@garver.life>
In-Reply-To: <20190906003302.25953-1-eric@garver.life>
References: <20190906003302.25953-1-eric@garver.life>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.62]); Fri, 06 Sep 2019 00:33:05 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Eric Garver <eric@garver.life>
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

