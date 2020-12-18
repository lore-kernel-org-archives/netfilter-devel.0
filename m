Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49F2DC4361B
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Dec 2020 11:33:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0183323426
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Dec 2020 11:33:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgLRLdd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Dec 2020 06:33:33 -0500
Received: from correo.us.es ([193.147.175.20]:51180 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbgLRLdd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Dec 2020 06:33:33 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8D0B915C12B
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2020 12:32:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5F468FC5E8
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2020 12:32:30 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BCA3EFC619; Fri, 18 Dec 2020 12:32:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3CC3BE151B
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2020 12:31:58 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 18 Dec 2020 12:31:58 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 20C5A42DF561
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2020 12:31:58 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: shell: set element multistatement support
Date:   Fri, 18 Dec 2020 12:32:12 +0100
Message-Id: <20201218113212.1993-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds two tests to add multistatement support:

- Dynamic set updates from packet path.
- Set that is updated from the control plane.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../testcases/sets/0059set_update_multistmt_0 | 17 +++++++
 .../shell/testcases/sets/0060set_multistmt_0  | 49 +++++++++++++++++++
 .../sets/dumps/0059set_update_multistmt_0.nft | 13 +++++
 .../sets/dumps/0060set_multistmt_0.nft        | 12 +++++
 4 files changed, 91 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0059set_update_multistmt_0
 create mode 100755 tests/shell/testcases/sets/0060set_multistmt_0
 create mode 100644 tests/shell/testcases/sets/dumps/0059set_update_multistmt_0.nft
 create mode 100644 tests/shell/testcases/sets/dumps/0060set_multistmt_0.nft

diff --git a/tests/shell/testcases/sets/0059set_update_multistmt_0 b/tests/shell/testcases/sets/0059set_update_multistmt_0
new file mode 100755
index 000000000000..107bfb870932
--- /dev/null
+++ b/tests/shell/testcases/sets/0059set_update_multistmt_0
@@ -0,0 +1,17 @@
+#!/bin/bash
+
+RULESET="table x {
+	set y {
+		type ipv4_addr
+		size 65535
+		flags dynamic,timeout
+		timeout 1h
+	}
+	chain z {
+		type filter hook output priority 0;
+		update @y { ip daddr limit rate 1/second counter }
+	}
+}"
+
+set -e
+$NFT -f - <<< $RULESET
diff --git a/tests/shell/testcases/sets/0060set_multistmt_0 b/tests/shell/testcases/sets/0060set_multistmt_0
new file mode 100755
index 000000000000..2cb4d3c55535
--- /dev/null
+++ b/tests/shell/testcases/sets/0060set_multistmt_0
@@ -0,0 +1,49 @@
+#!/bin/bash
+
+RULESET="table x {
+	set y {
+		type ipv4_addr
+		limit rate 1/second counter
+	}
+	chain y {
+		type filter hook output priority filter; policy accept;
+		ip daddr @y
+	}
+}"
+
+$NFT -f - <<< $RULESET
+# should work
+if [ $? -ne 0 ]
+then
+	exit 1
+fi
+
+# should work
+$NFT add element x y { 1.1.1.1 limit rate 1/second counter }
+if [ $? -ne 0 ]
+then
+	exit 1
+fi
+
+# should fail
+$NFT add element x y { 2.2.2.2 limit rate 1/second }
+if [ $? -eq 0 ]
+then
+	exit 1
+fi
+
+# should fail
+$NFT add element x y { 3.3.3.3 counter limit rate 1/second }
+if [ $? -eq 0 ]
+then
+	exit 1
+fi
+
+# should work
+$NFT add element x y { 4.4.4.4 }
+if [ $? -ne 0 ]
+then
+	exit 1
+fi
+
+exit 0
diff --git a/tests/shell/testcases/sets/dumps/0059set_update_multistmt_0.nft b/tests/shell/testcases/sets/dumps/0059set_update_multistmt_0.nft
new file mode 100644
index 000000000000..1b0ffae4d651
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0059set_update_multistmt_0.nft
@@ -0,0 +1,13 @@
+table ip x {
+	set y {
+		type ipv4_addr
+		size 65535
+		flags dynamic,timeout
+		timeout 1h
+	}
+
+	chain z {
+		type filter hook output priority filter; policy accept;
+		update @y { ip daddr limit rate 1/second counter }
+	}
+}
diff --git a/tests/shell/testcases/sets/dumps/0060set_multistmt_0.nft b/tests/shell/testcases/sets/dumps/0060set_multistmt_0.nft
new file mode 100644
index 000000000000..7ebb709fac2a
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0060set_multistmt_0.nft
@@ -0,0 +1,12 @@
+table ip x {
+	set y {
+		type ipv4_addr
+		limit rate 1/second counter
+		elements = { 1.1.1.1 limit rate 1/second counter packets 0 bytes 0, 4.4.4.4 limit rate 1/second counter packets 0 bytes 0 }
+	}
+
+	chain y {
+		type filter hook output priority filter; policy accept;
+		ip daddr @y
+	}
+}
-- 
2.20.1

