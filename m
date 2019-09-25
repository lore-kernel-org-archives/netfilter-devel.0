Return-Path: <SRS0=+tY6=XU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA1A1C432C2
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 21:27:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A254F20673
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 21:27:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbfIYV17 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:27:59 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45902 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbfIYV17 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Sep 2019 17:27:59 -0400
Received: from localhost ([::1]:58992 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iDEpK-0005Ib-5I; Wed, 25 Sep 2019 23:27:58 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 21/24] tests: shell: Add ipt-restore/0007-flush-noflush_0
Date:   Wed, 25 Sep 2019 23:26:02 +0200
Message-Id: <20190925212605.1005-22-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190925212605.1005-1-phil@nwl.cc>
References: <20190925212605.1005-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Simple test to make sure iptables-restore does not touch tables it is
not supposed to.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../ipt-restore/0007-flush-noflush_0          | 42 +++++++++++++++++++
 1 file changed, 42 insertions(+)
 create mode 100755 iptables/tests/shell/testcases/ipt-restore/0007-flush-noflush_0

diff --git a/iptables/tests/shell/testcases/ipt-restore/0007-flush-noflush_0 b/iptables/tests/shell/testcases/ipt-restore/0007-flush-noflush_0
new file mode 100755
index 0000000000000..029db2235b9a4
--- /dev/null
+++ b/iptables/tests/shell/testcases/ipt-restore/0007-flush-noflush_0
@@ -0,0 +1,42 @@
+#!/bin/bash
+
+# Make sure iptables-restore without --noflush does not flush tables other than
+# those contained in the dump it's reading from
+
+set -e
+
+$XT_MULTI iptables-restore <<EOF
+*nat
+-A POSTROUTING -j ACCEPT
+COMMIT
+EOF
+
+EXPECT="*nat
+:PREROUTING ACCEPT [0:0]
+:INPUT ACCEPT [0:0]
+:OUTPUT ACCEPT [0:0]
+:POSTROUTING ACCEPT [0:0]
+-A POSTROUTING -j ACCEPT
+COMMIT"
+diff -u -Z <(echo -e "$EXPECT" | sort) <($XT_MULTI iptables-save | grep -v '^#' | sort)
+
+$XT_MULTI iptables-restore <<EOF
+*filter
+-A FORWARD -j ACCEPT
+COMMIT
+EOF
+
+EXPECT="*filter
+:INPUT ACCEPT [0:0]
+:FORWARD ACCEPT [0:0]
+:OUTPUT ACCEPT [0:0]
+-A FORWARD -j ACCEPT
+COMMIT
+*nat
+:PREROUTING ACCEPT [0:0]
+:INPUT ACCEPT [0:0]
+:OUTPUT ACCEPT [0:0]
+:POSTROUTING ACCEPT [0:0]
+-A POSTROUTING -j ACCEPT
+COMMIT"
+diff -u -Z <(echo -e "$EXPECT" | sort) <($XT_MULTI iptables-save | grep -v '^#' | sort)
-- 
2.23.0

