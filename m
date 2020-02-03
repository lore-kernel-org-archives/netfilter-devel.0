Return-Path: <SRS0=ffOv=3X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C0EEC35247
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 11:20:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2327E20721
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 11:20:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="tMIlDQBe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbgBCLUZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Feb 2020 06:20:25 -0500
Received: from kadath.azazel.net ([81.187.231.250]:33252 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727306AbgBCLUY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Feb 2020 06:20:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wOFfEFTjWwR4/TuAekGEhiH7+o06UHfgBdSDi7+teSQ=; b=tMIlDQBeeqxqMBLwQd//B/6FNg
        zoTrt+zfN1mUWFIyDID3RM/XidCyU+9G5MTOJiv8Zzt06VRak1fgahiW7e0M3Kb/6igObWxeDpNDc
        ZhuC2cWtDYVWoIx0+zoRU6h+CayzoAubpmvGhAmEp8zyQjkdwQuj4bDBl6PhoutWgYzvYe3PIamsx
        /T9b25ijxQTc1cvCV4vlCwbtQUfQ365E9yim3ljgekBUvia21buSm4hSDmm5/7czYNPLVckTNMtf4
        BH4W6XCC5Npnotj5JWaQAZERdm0HEC6EGEVHHw7wU80foz+YpyyDV5KY/Em2j4Z0mm6YlBox10QYd
        ZLMmLfGw==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iyZmB-0007Br-M5
        for netfilter-devel@vger.kernel.org; Mon, 03 Feb 2020 11:20:23 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v4 4/6] tests: shell: add bit-shift tests.
Date:   Mon,  3 Feb 2020 11:20:21 +0000
Message-Id: <20200203112023.646840-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200203112023.646840-1-jeremy@azazel.net>
References: <20200203112023.646840-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a couple of shell test-cases for setting the CT mark to a bitwise
expression derived from the packet mark and vice versa.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 tests/shell/testcases/chains/0040mark_shift_0         | 11 +++++++++++
 tests/shell/testcases/chains/0040mark_shift_1         | 11 +++++++++++
 .../shell/testcases/chains/dumps/0040mark_shift_0.nft |  6 ++++++
 .../shell/testcases/chains/dumps/0040mark_shift_1.nft |  6 ++++++
 4 files changed, 34 insertions(+)
 create mode 100755 tests/shell/testcases/chains/0040mark_shift_0
 create mode 100755 tests/shell/testcases/chains/0040mark_shift_1
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_shift_0.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_shift_1.nft

diff --git a/tests/shell/testcases/chains/0040mark_shift_0 b/tests/shell/testcases/chains/0040mark_shift_0
new file mode 100755
index 000000000000..55447f0b9737
--- /dev/null
+++ b/tests/shell/testcases/chains/0040mark_shift_0
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table t
+  add chain t c { type filter hook output priority mangle; }
+  add rule t c oif lo ct mark set (meta mark | 0x10) << 8
+"
+
+$NFT --debug=eval -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/chains/0040mark_shift_1 b/tests/shell/testcases/chains/0040mark_shift_1
new file mode 100755
index 000000000000..b609f5ef10ad
--- /dev/null
+++ b/tests/shell/testcases/chains/0040mark_shift_1
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table t
+  add chain t c { type filter hook input priority mangle; }
+  add rule t c iif lo ct mark & 0xff 0x10 meta mark set ct mark >> 8
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/chains/dumps/0040mark_shift_0.nft b/tests/shell/testcases/chains/dumps/0040mark_shift_0.nft
new file mode 100644
index 000000000000..52d59d2c6da4
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0040mark_shift_0.nft
@@ -0,0 +1,6 @@
+table ip t {
+	chain c {
+		type filter hook output priority mangle; policy accept;
+		oif "lo" ct mark set (meta mark | 0x00000010) << 8
+	}
+}
diff --git a/tests/shell/testcases/chains/dumps/0040mark_shift_1.nft b/tests/shell/testcases/chains/dumps/0040mark_shift_1.nft
new file mode 100644
index 000000000000..56ec8dc766ca
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0040mark_shift_1.nft
@@ -0,0 +1,6 @@
+table ip t {
+	chain c {
+		type filter hook input priority mangle; policy accept;
+		iif "lo" ct mark & 0x000000ff == 0x00000010 meta mark set ct mark >> 8
+	}
+}
-- 
2.24.1

