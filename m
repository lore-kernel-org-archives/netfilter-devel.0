Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E763DC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344310AbiDDMaU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344528AbiDDMaM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:30:12 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2079A3D1DB
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fQTUbiFVmKB2fUp9toOez0Ypq+tsxfWnV4ALUlUJMDw=; b=JWJhiTN74J8z43CTwQqgDZTu4z
        7GV3S8mebq5N1/dBfCG7O3kGrld8sFYUMxWReENdzJ3BL2snYm9vMjBhsB/i+bzOnas7c7SNLFTRs
        vtgFw8yElUWjuwCoOS3zcJitowqWEWb+yf74ScvpajPAfefZdt4nezQbAgcgOccie1v6omItlN7CE
        zwQyMyBVJlJkEta+uvlH5iNUPf3qOh1zf4p3IB8wvVtc91FB4mUDEaflmCmlsFhj+0cH1nFMWadUL
        iRyirWayOAda4y2Xe7AJhxxBBK1NcsHSA8Ra6OvSANyEMwfzaZh1TWgbF3Z7PJjg+pwUGGETLzhnX
        h4WKt55Q==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLbJ-007FTC-WE; Mon, 04 Apr 2022 13:14:30 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [nft PATCH v4 16/32] tests: shell: add test-cases for ct and packet mark payload expressions
Date:   Mon,  4 Apr 2022 13:13:54 +0100
Message-Id: <20220404121410.188509-17-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220404121410.188509-1-jeremy@azazel.net>
References: <20220404121410.188509-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add new test-cases to verify that defining a rule that sets the ct or
packet mark to a value derived from a payload works correctly.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 tests/shell/testcases/chains/0040mark_binop_2         | 11 +++++++++++
 tests/shell/testcases/chains/0040mark_binop_3         | 11 +++++++++++
 tests/shell/testcases/chains/0040mark_binop_4         | 11 +++++++++++
 tests/shell/testcases/chains/0040mark_binop_5         | 11 +++++++++++
 tests/shell/testcases/chains/0040mark_binop_6         | 11 +++++++++++
 tests/shell/testcases/chains/0040mark_binop_7         | 11 +++++++++++
 tests/shell/testcases/chains/0040mark_binop_8         | 11 +++++++++++
 tests/shell/testcases/chains/0040mark_binop_9         | 11 +++++++++++
 .../shell/testcases/chains/dumps/0040mark_binop_2.nft |  6 ++++++
 .../shell/testcases/chains/dumps/0040mark_binop_3.nft |  6 ++++++
 .../shell/testcases/chains/dumps/0040mark_binop_4.nft |  6 ++++++
 .../shell/testcases/chains/dumps/0040mark_binop_5.nft |  6 ++++++
 .../shell/testcases/chains/dumps/0040mark_binop_6.nft |  6 ++++++
 .../shell/testcases/chains/dumps/0040mark_binop_7.nft |  6 ++++++
 .../shell/testcases/chains/dumps/0040mark_binop_8.nft |  6 ++++++
 .../shell/testcases/chains/dumps/0040mark_binop_9.nft |  6 ++++++
 16 files changed, 136 insertions(+)
 create mode 100755 tests/shell/testcases/chains/0040mark_binop_2
 create mode 100755 tests/shell/testcases/chains/0040mark_binop_3
 create mode 100755 tests/shell/testcases/chains/0040mark_binop_4
 create mode 100755 tests/shell/testcases/chains/0040mark_binop_5
 create mode 100755 tests/shell/testcases/chains/0040mark_binop_6
 create mode 100755 tests/shell/testcases/chains/0040mark_binop_7
 create mode 100755 tests/shell/testcases/chains/0040mark_binop_8
 create mode 100755 tests/shell/testcases/chains/0040mark_binop_9
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_binop_2.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_binop_3.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_binop_4.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_binop_5.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_binop_6.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_binop_7.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_binop_8.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_binop_9.nft

diff --git a/tests/shell/testcases/chains/0040mark_binop_2 b/tests/shell/testcases/chains/0040mark_binop_2
new file mode 100755
index 000000000000..94ebe976c987
--- /dev/null
+++ b/tests/shell/testcases/chains/0040mark_binop_2
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table t
+  add chain t c { type filter hook output priority filter; }
+  add rule t c ct mark set ip dscp lshift 2 or 0x10
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/chains/0040mark_binop_3 b/tests/shell/testcases/chains/0040mark_binop_3
new file mode 100755
index 000000000000..b491565ca573
--- /dev/null
+++ b/tests/shell/testcases/chains/0040mark_binop_3
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table t
+  add chain t c { type filter hook input priority filter; }
+  add rule t c meta mark set ip dscp lshift 2 or 0x10
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/chains/0040mark_binop_4 b/tests/shell/testcases/chains/0040mark_binop_4
new file mode 100755
index 000000000000..adc5f25ba930
--- /dev/null
+++ b/tests/shell/testcases/chains/0040mark_binop_4
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table t
+  add chain t c { type filter hook output priority filter; }
+  add rule t c ct mark set ip dscp lshift 26 or 0x10
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/chains/0040mark_binop_5 b/tests/shell/testcases/chains/0040mark_binop_5
new file mode 100755
index 000000000000..286b7b1fc7f9
--- /dev/null
+++ b/tests/shell/testcases/chains/0040mark_binop_5
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table t
+  add chain t c { type filter hook input priority filter; }
+  add rule t c meta mark set ip dscp lshift 26 or 0x10
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/chains/0040mark_binop_6 b/tests/shell/testcases/chains/0040mark_binop_6
new file mode 100755
index 000000000000..9ea82952ef24
--- /dev/null
+++ b/tests/shell/testcases/chains/0040mark_binop_6
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table ip6 t
+  add chain ip6 t c { type filter hook output priority filter; }
+  add rule ip6 t c ct mark set ip6 dscp lshift 2 or 0x10
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/chains/0040mark_binop_7 b/tests/shell/testcases/chains/0040mark_binop_7
new file mode 100755
index 000000000000..ff9cfb55ac3e
--- /dev/null
+++ b/tests/shell/testcases/chains/0040mark_binop_7
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table ip6 t
+  add chain ip6 t c { type filter hook input priority filter; }
+  add rule ip6 t c meta mark set ip6 dscp lshift 2 or 0x10
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/chains/0040mark_binop_8 b/tests/shell/testcases/chains/0040mark_binop_8
new file mode 100755
index 000000000000..b348ee9367df
--- /dev/null
+++ b/tests/shell/testcases/chains/0040mark_binop_8
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table ip6 t
+  add chain ip6 t c { type filter hook output priority filter; }
+  add rule ip6 t c ct mark set ip6 dscp lshift 26 or 0x10
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/chains/0040mark_binop_9 b/tests/shell/testcases/chains/0040mark_binop_9
new file mode 100755
index 000000000000..d19447d42b22
--- /dev/null
+++ b/tests/shell/testcases/chains/0040mark_binop_9
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table ip6 t
+  add chain ip6 t c { type filter hook input priority filter; }
+  add rule ip6 t c meta mark set ip6 dscp lshift 26 or 0x10
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/chains/dumps/0040mark_binop_2.nft b/tests/shell/testcases/chains/dumps/0040mark_binop_2.nft
new file mode 100644
index 000000000000..7dc274f4e6a3
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0040mark_binop_2.nft
@@ -0,0 +1,6 @@
+table ip t {
+	chain c {
+		type filter hook output priority filter; policy accept;
+		ct mark set ip dscp << 2 | 16
+	}
+}
diff --git a/tests/shell/testcases/chains/dumps/0040mark_binop_3.nft b/tests/shell/testcases/chains/dumps/0040mark_binop_3.nft
new file mode 100644
index 000000000000..c484f7a54948
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0040mark_binop_3.nft
@@ -0,0 +1,6 @@
+table ip t {
+	chain c {
+		type filter hook input priority filter; policy accept;
+		meta mark set ip dscp << 2 | 16
+	}
+}
diff --git a/tests/shell/testcases/chains/dumps/0040mark_binop_4.nft b/tests/shell/testcases/chains/dumps/0040mark_binop_4.nft
new file mode 100644
index 000000000000..1bebea1683bc
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0040mark_binop_4.nft
@@ -0,0 +1,6 @@
+table ip t {
+	chain c {
+		type filter hook output priority filter; policy accept;
+		ct mark set ip dscp << 26 | 16
+	}
+}
diff --git a/tests/shell/testcases/chains/dumps/0040mark_binop_5.nft b/tests/shell/testcases/chains/dumps/0040mark_binop_5.nft
new file mode 100644
index 000000000000..787c6cdd9231
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0040mark_binop_5.nft
@@ -0,0 +1,6 @@
+table ip t {
+	chain c {
+		type filter hook input priority filter; policy accept;
+		meta mark set ip dscp << 26 | 16
+	}
+}
diff --git a/tests/shell/testcases/chains/dumps/0040mark_binop_6.nft b/tests/shell/testcases/chains/dumps/0040mark_binop_6.nft
new file mode 100644
index 000000000000..53940eaf2ea4
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0040mark_binop_6.nft
@@ -0,0 +1,6 @@
+table ip6 t {
+	chain c {
+		type filter hook output priority filter; policy accept;
+		ct mark set ip6 dscp << 2 | 16
+	}
+}
diff --git a/tests/shell/testcases/chains/dumps/0040mark_binop_7.nft b/tests/shell/testcases/chains/dumps/0040mark_binop_7.nft
new file mode 100644
index 000000000000..35e12a0af66d
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0040mark_binop_7.nft
@@ -0,0 +1,6 @@
+table ip6 t {
+	chain c {
+		type filter hook input priority filter; policy accept;
+		meta mark set ip6 dscp << 2 | 16
+	}
+}
diff --git a/tests/shell/testcases/chains/dumps/0040mark_binop_8.nft b/tests/shell/testcases/chains/dumps/0040mark_binop_8.nft
new file mode 100644
index 000000000000..f9f16c2491d4
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0040mark_binop_8.nft
@@ -0,0 +1,6 @@
+table ip6 t {
+	chain c {
+		type filter hook output priority filter; policy accept;
+		ct mark set ip6 dscp << 26 | 16
+	}
+}
diff --git a/tests/shell/testcases/chains/dumps/0040mark_binop_9.nft b/tests/shell/testcases/chains/dumps/0040mark_binop_9.nft
new file mode 100644
index 000000000000..03c69c3f7cd2
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0040mark_binop_9.nft
@@ -0,0 +1,6 @@
+table ip6 t {
+	chain c {
+		type filter hook input priority filter; policy accept;
+		meta mark set ip6 dscp << 26 | 16
+	}
+}
-- 
2.35.1

