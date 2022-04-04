Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED318C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:29:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344642AbiDDMbI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344222AbiDDMbH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:31:07 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4E913F88
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=27rQndcByeNelYac6qbZzC352JhUWlT3m9+MyS3cYcQ=; b=WwFNXlhiOU0ZZNLXe507vajLRx
        we9GhVMXP5472nYVYo6lqKe6Dz2a729CtCeSC7ONwlwruSZiYiD3b6ivSIInD5i+TVivtjcbVRsLz
        zuNfs7yP/aEqAJedyCvjbdxxLsWh+uvXf+PUairDKhvelCyd5Vn2PqqgxpaxSUAhX0145IjXlnai+
        FKyy9K3zwiIc8CtY21FOULYjbxsU8MaIx0ivJ/+PLprxF0EDjOxzP8V0jB5LOH35XNy/+coqWsmsl
        mMgIPhmVj4AkiOJZkL7RIJtOUPeFh8dwCeNGyneRmLlBuyo7CRrC0obzR01aSNboVtLX2GogOEwy/
        CAGXn5hg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLbL-007FTC-Ei; Mon, 04 Apr 2022 13:14:31 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [nft PATCH v4 31/32] tests: shell: add tests for binops with variable RHS operands
Date:   Mon,  4 Apr 2022 13:14:09 +0100
Message-Id: <20220404121410.188509-32-jeremy@azazel.net>
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

Add tests to validate setting marks with statement arguments that include
binops with variable RHS operands.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 tests/shell/testcases/chains/0040mark_binop_10        | 11 +++++++++++
 tests/shell/testcases/chains/0040mark_binop_11        | 11 +++++++++++
 tests/shell/testcases/chains/0040mark_binop_12        | 11 +++++++++++
 tests/shell/testcases/chains/0040mark_binop_13        | 11 +++++++++++
 tests/shell/testcases/chains/0044payload_binop_0      | 11 +++++++++++
 tests/shell/testcases/chains/0044payload_binop_1      | 11 +++++++++++
 tests/shell/testcases/chains/0044payload_binop_2      | 11 +++++++++++
 tests/shell/testcases/chains/0044payload_binop_3      | 11 +++++++++++
 tests/shell/testcases/chains/0044payload_binop_4      | 11 +++++++++++
 tests/shell/testcases/chains/0044payload_binop_5      | 11 +++++++++++
 .../testcases/chains/dumps/0040mark_binop_10.nft      |  6 ++++++
 .../testcases/chains/dumps/0040mark_binop_11.nft      |  6 ++++++
 .../testcases/chains/dumps/0040mark_binop_12.nft      |  6 ++++++
 .../testcases/chains/dumps/0040mark_binop_13.nft      |  6 ++++++
 .../testcases/chains/dumps/0044payload_binop_0.nft    |  6 ++++++
 .../testcases/chains/dumps/0044payload_binop_1.nft    |  6 ++++++
 .../testcases/chains/dumps/0044payload_binop_2.nft    |  6 ++++++
 .../testcases/chains/dumps/0044payload_binop_3.nft    |  6 ++++++
 .../testcases/chains/dumps/0044payload_binop_4.nft    |  6 ++++++
 .../testcases/chains/dumps/0044payload_binop_5.nft    |  6 ++++++
 20 files changed, 170 insertions(+)
 create mode 100755 tests/shell/testcases/chains/0040mark_binop_10
 create mode 100755 tests/shell/testcases/chains/0040mark_binop_11
 create mode 100755 tests/shell/testcases/chains/0040mark_binop_12
 create mode 100755 tests/shell/testcases/chains/0040mark_binop_13
 create mode 100755 tests/shell/testcases/chains/0044payload_binop_0
 create mode 100755 tests/shell/testcases/chains/0044payload_binop_1
 create mode 100755 tests/shell/testcases/chains/0044payload_binop_2
 create mode 100755 tests/shell/testcases/chains/0044payload_binop_3
 create mode 100755 tests/shell/testcases/chains/0044payload_binop_4
 create mode 100755 tests/shell/testcases/chains/0044payload_binop_5
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_binop_10.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_binop_11.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_binop_12.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_binop_13.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0044payload_binop_0.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0044payload_binop_1.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0044payload_binop_2.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0044payload_binop_3.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0044payload_binop_4.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0044payload_binop_5.nft

diff --git a/tests/shell/testcases/chains/0040mark_binop_10 b/tests/shell/testcases/chains/0040mark_binop_10
new file mode 100755
index 000000000000..8e9bc6ad4329
--- /dev/null
+++ b/tests/shell/testcases/chains/0040mark_binop_10
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table t
+  add chain t c { type filter hook output priority filter; }
+  add rule t c ct mark set ct mark and 0xffff0000 or meta mark and 0xffff
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/chains/0040mark_binop_11 b/tests/shell/testcases/chains/0040mark_binop_11
new file mode 100755
index 000000000000..7825b0827851
--- /dev/null
+++ b/tests/shell/testcases/chains/0040mark_binop_11
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table t
+  add chain t c { type filter hook input priority filter; }
+  add rule t c meta mark set ct mark and 0xffff0000 or meta mark and 0xffff
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/chains/0040mark_binop_12 b/tests/shell/testcases/chains/0040mark_binop_12
new file mode 100755
index 000000000000..aa27cdc5303c
--- /dev/null
+++ b/tests/shell/testcases/chains/0040mark_binop_12
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table ip6 t
+  add chain ip6 t c { type filter hook output priority filter; }
+  add rule ip6 t c ct mark set ct mark and 0xffff0000 or meta mark and 0xffff
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/chains/0040mark_binop_13 b/tests/shell/testcases/chains/0040mark_binop_13
new file mode 100755
index 000000000000..53a7e2ec6c6f
--- /dev/null
+++ b/tests/shell/testcases/chains/0040mark_binop_13
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table ip6 t
+  add chain ip6 t c { type filter hook input priority filter; }
+  add rule ip6 t c meta mark set ct mark and 0xffff0000 or meta mark and 0xffff
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/chains/0044payload_binop_0 b/tests/shell/testcases/chains/0044payload_binop_0
new file mode 100755
index 000000000000..81b8cbaa961f
--- /dev/null
+++ b/tests/shell/testcases/chains/0044payload_binop_0
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table t
+  add chain t c { type filter hook output priority filter; }
+  add rule t c ip dscp set (ct mark & 0xfc000000) >> 26
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/chains/0044payload_binop_1 b/tests/shell/testcases/chains/0044payload_binop_1
new file mode 100755
index 000000000000..1d69b6f78654
--- /dev/null
+++ b/tests/shell/testcases/chains/0044payload_binop_1
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table t
+  add chain t c { type filter hook output priority filter; }
+  add rule t c ip dscp set ip dscp and 0xc
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/chains/0044payload_binop_2 b/tests/shell/testcases/chains/0044payload_binop_2
new file mode 100755
index 000000000000..2d09d24479d0
--- /dev/null
+++ b/tests/shell/testcases/chains/0044payload_binop_2
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table t
+  add chain t c { type filter hook output priority filter; }
+  add rule t c ct mark set ct mark | ip dscp | 0x200 counter
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/chains/0044payload_binop_3 b/tests/shell/testcases/chains/0044payload_binop_3
new file mode 100755
index 000000000000..7752af238409
--- /dev/null
+++ b/tests/shell/testcases/chains/0044payload_binop_3
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table ip6 t
+  add chain ip6 t c { type filter hook output priority filter; }
+  add rule ip6 t c ip6 dscp set (ct mark & 0xfc000000) >> 26
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/chains/0044payload_binop_4 b/tests/shell/testcases/chains/0044payload_binop_4
new file mode 100755
index 000000000000..2c7792e9f929
--- /dev/null
+++ b/tests/shell/testcases/chains/0044payload_binop_4
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table ip6 t
+  add chain ip6 t c { type filter hook output priority filter; }
+  add rule ip6 t c ip6 dscp set ip6 dscp and 0xc
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/chains/0044payload_binop_5 b/tests/shell/testcases/chains/0044payload_binop_5
new file mode 100755
index 000000000000..aa82cd1c299e
--- /dev/null
+++ b/tests/shell/testcases/chains/0044payload_binop_5
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table ip6 t
+  add chain ip6 t c { type filter hook output priority filter; }
+  add rule ip6 t c ct mark set ct mark | ip6 dscp | 0x200 counter
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/chains/dumps/0040mark_binop_10.nft b/tests/shell/testcases/chains/dumps/0040mark_binop_10.nft
new file mode 100644
index 000000000000..5566f7298461
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0040mark_binop_10.nft
@@ -0,0 +1,6 @@
+table ip t {
+	chain c {
+		type filter hook output priority filter; policy accept;
+		ct mark set ct mark & 0xffff0000 | meta mark & 0x0000ffff
+	}
+}
diff --git a/tests/shell/testcases/chains/dumps/0040mark_binop_11.nft b/tests/shell/testcases/chains/dumps/0040mark_binop_11.nft
new file mode 100644
index 000000000000..719980d55341
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0040mark_binop_11.nft
@@ -0,0 +1,6 @@
+table ip t {
+	chain c {
+		type filter hook input priority filter; policy accept;
+		meta mark set ct mark & 0xffff0000 | meta mark & 0x0000ffff
+	}
+}
diff --git a/tests/shell/testcases/chains/dumps/0040mark_binop_12.nft b/tests/shell/testcases/chains/dumps/0040mark_binop_12.nft
new file mode 100644
index 000000000000..bd589fe549f7
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0040mark_binop_12.nft
@@ -0,0 +1,6 @@
+table ip6 t {
+	chain c {
+		type filter hook output priority filter; policy accept;
+		ct mark set ct mark & 0xffff0000 | meta mark & 0x0000ffff
+	}
+}
diff --git a/tests/shell/testcases/chains/dumps/0040mark_binop_13.nft b/tests/shell/testcases/chains/dumps/0040mark_binop_13.nft
new file mode 100644
index 000000000000..2b046b128fb2
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0040mark_binop_13.nft
@@ -0,0 +1,6 @@
+table ip6 t {
+	chain c {
+		type filter hook input priority filter; policy accept;
+		meta mark set ct mark & 0xffff0000 | meta mark & 0x0000ffff
+	}
+}
diff --git a/tests/shell/testcases/chains/dumps/0044payload_binop_0.nft b/tests/shell/testcases/chains/dumps/0044payload_binop_0.nft
new file mode 100644
index 000000000000..5aaf1353bdc8
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0044payload_binop_0.nft
@@ -0,0 +1,6 @@
+table ip t {
+	chain c {
+		type filter hook output priority filter; policy accept;
+		ip dscp set (ct mark & 0xfc000000) >> 26
+	}
+}
diff --git a/tests/shell/testcases/chains/dumps/0044payload_binop_1.nft b/tests/shell/testcases/chains/dumps/0044payload_binop_1.nft
new file mode 100644
index 000000000000..54f744b54a3a
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0044payload_binop_1.nft
@@ -0,0 +1,6 @@
+table ip t {
+	chain c {
+		type filter hook output priority filter; policy accept;
+		ip dscp set ip dscp & af12
+	}
+}
diff --git a/tests/shell/testcases/chains/dumps/0044payload_binop_2.nft b/tests/shell/testcases/chains/dumps/0044payload_binop_2.nft
new file mode 100644
index 000000000000..ed347bb2788a
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0044payload_binop_2.nft
@@ -0,0 +1,6 @@
+table ip t {
+	chain c {
+		type filter hook output priority filter; policy accept;
+		ct mark set ct mark | ip dscp | 0x00000200 counter packets 0 bytes 0
+	}
+}
diff --git a/tests/shell/testcases/chains/dumps/0044payload_binop_3.nft b/tests/shell/testcases/chains/dumps/0044payload_binop_3.nft
new file mode 100644
index 000000000000..64da4a77cb5c
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0044payload_binop_3.nft
@@ -0,0 +1,6 @@
+table ip6 t {
+	chain c {
+		type filter hook output priority filter; policy accept;
+		ip6 dscp set (ct mark & 0xfc000000) >> 26
+	}
+}
diff --git a/tests/shell/testcases/chains/dumps/0044payload_binop_4.nft b/tests/shell/testcases/chains/dumps/0044payload_binop_4.nft
new file mode 100644
index 000000000000..e863f44ef991
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0044payload_binop_4.nft
@@ -0,0 +1,6 @@
+table ip6 t {
+	chain c {
+		type filter hook output priority filter; policy accept;
+		ip6 dscp set ip6 dscp & af12
+	}
+}
diff --git a/tests/shell/testcases/chains/dumps/0044payload_binop_5.nft b/tests/shell/testcases/chains/dumps/0044payload_binop_5.nft
new file mode 100644
index 000000000000..ccdb93d74a9a
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0044payload_binop_5.nft
@@ -0,0 +1,6 @@
+table ip6 t {
+	chain c {
+		type filter hook output priority filter; policy accept;
+		ct mark set ct mark | ip6 dscp | 0x00000200 counter packets 0 bytes 0
+	}
+}
-- 
2.35.1

