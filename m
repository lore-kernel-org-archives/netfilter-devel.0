Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3A2EC43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Sep 2022 13:03:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiI3NC7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Sep 2022 09:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbiI3NC6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Sep 2022 09:02:58 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D20B216512A
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Sep 2022 06:02:57 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 5/6] tests: shell: add vxlan set tests
Date:   Fri, 30 Sep 2022 15:02:47 +0200
Message-Id: <20220930130248.416386-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220930130248.416386-1-pablo@netfilter.org>
References: <20220930130248.416386-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/sets/dumps/inner_0.nft | 18 ++++++++++++++
 tests/shell/testcases/sets/inner_0           | 25 ++++++++++++++++++++
 2 files changed, 43 insertions(+)
 create mode 100644 tests/shell/testcases/sets/dumps/inner_0.nft
 create mode 100755 tests/shell/testcases/sets/inner_0

diff --git a/tests/shell/testcases/sets/dumps/inner_0.nft b/tests/shell/testcases/sets/dumps/inner_0.nft
new file mode 100644
index 000000000000..925ca777ccd4
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/inner_0.nft
@@ -0,0 +1,18 @@
+table netdev x {
+	set x {
+		typeof vxlan ip saddr . vxlan ip daddr
+		elements = { 3.3.3.3 . 4.4.4.4 }
+	}
+
+	set y {
+		typeof vxlan ip saddr
+		size 65535
+		flags dynamic
+	}
+
+	chain y {
+		udp dport 4789 vxlan ip saddr . vxlan ip daddr { 1.1.1.1 . 2.2.2.2 } counter packets 0 bytes 0
+		udp dport 4789 vxlan ip saddr . vxlan ip daddr @x counter packets 0 bytes 0
+		udp dport 4789 update @y { vxlan ip saddr }
+	}
+}
diff --git a/tests/shell/testcases/sets/inner_0 b/tests/shell/testcases/sets/inner_0
new file mode 100755
index 000000000000..0eb172a8cf06
--- /dev/null
+++ b/tests/shell/testcases/sets/inner_0
@@ -0,0 +1,25 @@
+#!/bin/bash
+
+set -e
+
+RULESET="table netdev x {
+	set x {
+		typeof vxlan ip saddr . vxlan ip daddr
+		elements = {
+			3.3.3.3 . 4.4.4.4,
+		}
+	}
+
+	set y {
+		typeof vxlan ip saddr
+		flags dynamic
+	}
+
+        chain y {
+		udp dport 4789 vxlan ip saddr . vxlan ip daddr { 1.1.1.1 . 2.2.2.2 } counter
+		udp dport 4789 vxlan ip saddr . vxlan ip daddr @x counter
+		udp dport 4789 update @y { vxlan ip saddr }
+        }
+}"
+
+$NFT -f - <<< $RULESET
-- 
2.30.2

