Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77AB5C47072
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Nov 2023 09:42:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234695AbjKOJmn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Nov 2023 04:42:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234800AbjKOJml (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Nov 2023 04:42:41 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 108D5116
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Nov 2023 01:42:38 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, thaller@redhat.com
Subject: [PATCH nft 2/4] tests: shell: skip if kernel does not support flowtable with no devices
Date:   Wed, 15 Nov 2023 10:42:29 +0100
Message-Id: <20231115094231.168870-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231115094231.168870-1-pablo@netfilter.org>
References: <20231115094231.168870-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Originally, flowtables required devices in place to work, this was later
relaxed to allow flowtable with no initial devices, see 05abe4456fa3
("netfilter: nf_tables: allow to register flowtable with no devices").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/features/flowtable_no_devices.nft | 8 ++++++++
 tests/shell/testcases/listing/0020flowtable_0 | 2 ++
 2 files changed, 10 insertions(+)
 create mode 100755 tests/shell/features/flowtable_no_devices.nft

diff --git a/tests/shell/features/flowtable_no_devices.nft b/tests/shell/features/flowtable_no_devices.nft
new file mode 100755
index 000000000000..30dd3db8b8dd
--- /dev/null
+++ b/tests/shell/features/flowtable_no_devices.nft
@@ -0,0 +1,8 @@
+# 05abe4456fa3 ("netfilter: nf_tables: allow to register flowtable with no devices")
+# v5.8-rc1~165^2~27^2~1
+table ip filter2 {
+	flowtable main_ft2 {
+		hook ingress priority filter
+		counter
+	}
+}
diff --git a/tests/shell/testcases/listing/0020flowtable_0 b/tests/shell/testcases/listing/0020flowtable_0
index 6eb82cfeabc3..0e89f5dd0139 100755
--- a/tests/shell/testcases/listing/0020flowtable_0
+++ b/tests/shell/testcases/listing/0020flowtable_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_flowtable_no_devices)
+
 # list only the flowtable asked for with table
 
 set -e
-- 
2.30.2

