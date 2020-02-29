Return-Path: <SRS0=4Rej=4R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B019C3F2C6
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Feb 2020 11:44:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4875A2469C
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Feb 2020 11:44:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="kudWfIbW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgB2Lo2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Feb 2020 06:44:28 -0500
Received: from kadath.azazel.net ([81.187.231.250]:49480 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbgB2Lo1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Feb 2020 06:44:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LbcYDU65bQ34H+lIeGiPFLS9z51WFVsz32zAIlWXKq8=; b=kudWfIbWKgNrZzZxraywkKACmF
        1jwS1OncTEk1EjiocP/osN4BpLfr0I8PaHvBSoKqJgcouUHT65/tKg+FaP66akQFJ3gK8ZG7MeZYC
        88E3mx2gkgDHf3gCaX7d8dMSvdGwWflojfqO7QyzanEV0sLxrcASWsAnUBFf4z9NhATX91Yu3xeMB
        XVMr/EfgmR8Ezn8syoAUCsH2PWGzohos7ce672HWEh5vrgVfyb38CZKVKG+ccnPuZL4TeiRD628wA
        9TigxzM4cEQX7awPvDkISduA2+Z7j2ygpcSc/DVS7GqSJOuLw0REKZqYYdGxHk8BfppcTdJNrNboO
        nAiBR5vw==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j80HO-0003Wm-BM; Sat, 29 Feb 2020 11:27:34 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 17/18] tests: shell: add variable binop RHS tests.
Date:   Sat, 29 Feb 2020 11:27:30 +0000
Message-Id: <20200229112731.796417-18-jeremy@azazel.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200229112731.796417-1-jeremy@azazel.net>
References: <20200229112731.796417-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add some tests to validate setting payload fields and marks with
statement arguments that include binops with variable RHS operands.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 tests/shell/testcases/chains/0040mark_shift_2         | 11 +++++++++++
 tests/shell/testcases/chains/0041payload_variable_0   | 11 +++++++++++
 tests/shell/testcases/chains/0041payload_variable_1   | 11 +++++++++++
 tests/shell/testcases/chains/0041payload_variable_2   | 11 +++++++++++
 tests/shell/testcases/chains/0041payload_variable_3   | 11 +++++++++++
 .../shell/testcases/chains/dumps/0040mark_shift_2.nft |  6 ++++++
 .../testcases/chains/dumps/0041payload_variable_0.nft |  6 ++++++
 .../testcases/chains/dumps/0041payload_variable_1.nft |  6 ++++++
 .../testcases/chains/dumps/0041payload_variable_2.nft |  6 ++++++
 .../testcases/chains/dumps/0041payload_variable_3.nft |  6 ++++++
 10 files changed, 85 insertions(+)
 create mode 100755 tests/shell/testcases/chains/0040mark_shift_2
 create mode 100755 tests/shell/testcases/chains/0041payload_variable_0
 create mode 100755 tests/shell/testcases/chains/0041payload_variable_1
 create mode 100755 tests/shell/testcases/chains/0041payload_variable_2
 create mode 100755 tests/shell/testcases/chains/0041payload_variable_3
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_shift_2.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0041payload_variable_0.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0041payload_variable_1.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0041payload_variable_2.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0041payload_variable_3.nft

diff --git a/tests/shell/testcases/chains/0040mark_shift_2 b/tests/shell/testcases/chains/0040mark_shift_2
new file mode 100755
index 000000000000..2ff3418bdd3f
--- /dev/null
+++ b/tests/shell/testcases/chains/0040mark_shift_2
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table t
+  add chain t c { type filter hook input priority mangle; }
+  add rule t c ct mark set ct mark and 0xffff0000 or meta mark and 0xffff
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/chains/0041payload_variable_0 b/tests/shell/testcases/chains/0041payload_variable_0
new file mode 100755
index 000000000000..c9819ff4ab88
--- /dev/null
+++ b/tests/shell/testcases/chains/0041payload_variable_0
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table t
+  add chain t c { type filter hook output priority mangle; }
+  add rule ip t c tcp dport set tcp dport
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/chains/0041payload_variable_1 b/tests/shell/testcases/chains/0041payload_variable_1
new file mode 100755
index 000000000000..e9b1e1dde515
--- /dev/null
+++ b/tests/shell/testcases/chains/0041payload_variable_1
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table t
+  add chain t c { type filter hook output priority mangle; }
+  add rule ip t c tcp dport set tcp dport lshift 1
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/chains/0041payload_variable_2 b/tests/shell/testcases/chains/0041payload_variable_2
new file mode 100755
index 000000000000..5a458ef5d525
--- /dev/null
+++ b/tests/shell/testcases/chains/0041payload_variable_2
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table t
+  add chain t c { type filter hook output priority mangle; }
+  add rule ip t c ip dscp set ip dscp
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/chains/0041payload_variable_3 b/tests/shell/testcases/chains/0041payload_variable_3
new file mode 100755
index 000000000000..0375399c3d0f
--- /dev/null
+++ b/tests/shell/testcases/chains/0041payload_variable_3
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table t
+  add chain t c { type filter hook output priority mangle; }
+  add rule ip t c ip dscp set ip dscp or 0x3
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/chains/dumps/0040mark_shift_2.nft b/tests/shell/testcases/chains/dumps/0040mark_shift_2.nft
new file mode 100644
index 000000000000..14f2d1685706
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0040mark_shift_2.nft
@@ -0,0 +1,6 @@
+table ip t {
+	chain c {
+		type filter hook input priority mangle; policy accept;
+		ct mark set ct mark & 0xffff0000 | meta mark & 0x0000ffff
+	}
+}
diff --git a/tests/shell/testcases/chains/dumps/0041payload_variable_0.nft b/tests/shell/testcases/chains/dumps/0041payload_variable_0.nft
new file mode 100644
index 000000000000..731949e6b355
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0041payload_variable_0.nft
@@ -0,0 +1,6 @@
+table ip t {
+	chain c {
+		type filter hook output priority mangle; policy accept;
+		tcp dport set tcp dport
+	}
+}
diff --git a/tests/shell/testcases/chains/dumps/0041payload_variable_1.nft b/tests/shell/testcases/chains/dumps/0041payload_variable_1.nft
new file mode 100644
index 000000000000..2cd87a4dc8e1
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0041payload_variable_1.nft
@@ -0,0 +1,6 @@
+table ip t {
+	chain c {
+		type filter hook output priority mangle; policy accept;
+		tcp dport set tcp dport << 1
+	}
+}
diff --git a/tests/shell/testcases/chains/dumps/0041payload_variable_2.nft b/tests/shell/testcases/chains/dumps/0041payload_variable_2.nft
new file mode 100644
index 000000000000..d1e7adb92c4c
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0041payload_variable_2.nft
@@ -0,0 +1,6 @@
+table ip t {
+	chain c {
+		type filter hook output priority mangle; policy accept;
+		ip dscp set ip dscp
+	}
+}
diff --git a/tests/shell/testcases/chains/dumps/0041payload_variable_3.nft b/tests/shell/testcases/chains/dumps/0041payload_variable_3.nft
new file mode 100644
index 000000000000..52b3a833175a
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0041payload_variable_3.nft
@@ -0,0 +1,6 @@
+table ip t {
+	chain c {
+		type filter hook output priority mangle; policy accept;
+		ip dscp set ip dscp | 0x03
+	}
+}
-- 
2.25.0

