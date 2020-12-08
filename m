Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87E6DC1B0D9
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Dec 2020 20:55:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C9A723AFE
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Dec 2020 20:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729302AbgLHUzY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Dec 2020 15:55:24 -0500
Received: from correo.us.es ([193.147.175.20]:33260 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbgLHUzW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Dec 2020 15:55:22 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 82B19190C60
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Dec 2020 20:33:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 73FEDDA704
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Dec 2020 20:33:47 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 69830FC5E5; Tue,  8 Dec 2020 20:33:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 29670DA704
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Dec 2020 20:33:45 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 08 Dec 2020 20:33:45 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 141484265A5A
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Dec 2020 20:33:45 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: shell: timeouts later than 23 days
Date:   Tue,  8 Dec 2020 20:33:50 +0100
Message-Id: <20201208193350.25081-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Test timeout later than 23 days in set definitions and dynamic set
insertions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../testcases/sets/0058_setupdate_timeout_0     | 17 +++++++++++++++++
 .../sets/dumps/0058_setupdate_timeout_0.nft     | 12 ++++++++++++
 2 files changed, 29 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0058_setupdate_timeout_0
 create mode 100644 tests/shell/testcases/sets/dumps/0058_setupdate_timeout_0.nft

diff --git a/tests/shell/testcases/sets/0058_setupdate_timeout_0 b/tests/shell/testcases/sets/0058_setupdate_timeout_0
new file mode 100755
index 000000000000..52a658e13794
--- /dev/null
+++ b/tests/shell/testcases/sets/0058_setupdate_timeout_0
@@ -0,0 +1,17 @@
+#!/bin/bash
+
+RULESET="table inet filter {
+	set ssh_meter {
+		type ipv4_addr
+		size 65535
+		flags dynamic,timeout
+		timeout 30d
+	}
+
+	chain test {
+		add @ssh_meter { ip saddr timeout 30d }
+	}
+}"
+
+set -e
+$NFT -f - <<< $RULESET
diff --git a/tests/shell/testcases/sets/dumps/0058_setupdate_timeout_0.nft b/tests/shell/testcases/sets/dumps/0058_setupdate_timeout_0.nft
new file mode 100644
index 000000000000..873adc63298d
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0058_setupdate_timeout_0.nft
@@ -0,0 +1,12 @@
+table inet filter {
+	set ssh_meter {
+		type ipv4_addr
+		size 65535
+		flags dynamic,timeout
+		timeout 30d
+	}
+
+	chain test {
+		add @ssh_meter { ip saddr timeout 30d }
+	}
+}
-- 
2.20.1

