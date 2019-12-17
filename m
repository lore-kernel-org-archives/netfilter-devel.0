Return-Path: <SRS0=i/iJ=2H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87FFCC2D0CD
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 11:28:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64F502082E
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 11:28:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbfLQL2E (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Dec 2019 06:28:04 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:57366 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727202AbfLQL2E (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 06:28:04 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ihB1G-0006mr-Bm; Tue, 17 Dec 2019 12:28:02 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v3 10/10] tests: add typeof test cases
Date:   Tue, 17 Dec 2019 12:27:13 +0100
Message-Id: <20191217112713.6017-11-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217112713.6017-1-fw@strlen.de>
References: <20191217112713.6017-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add sets using unspecific string/integer types, one with
osf name, other with vlan id.  Neither type can be used directly,
as they lack the type size information.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../testcases/maps/dumps/typeof_maps_0.nft    | 16 ++++++++++
 tests/shell/testcases/maps/typeof_maps_0      | 27 +++++++++++++++++
 .../testcases/sets/dumps/typeof_sets_0.nft    | 19 ++++++++++++
 tests/shell/testcases/sets/typeof_sets_0      | 29 +++++++++++++++++++
 4 files changed, 91 insertions(+)
 create mode 100644 tests/shell/testcases/maps/dumps/typeof_maps_0.nft
 create mode 100755 tests/shell/testcases/maps/typeof_maps_0
 create mode 100644 tests/shell/testcases/sets/dumps/typeof_sets_0.nft
 create mode 100755 tests/shell/testcases/sets/typeof_sets_0

diff --git a/tests/shell/testcases/maps/dumps/typeof_maps_0.nft b/tests/shell/testcases/maps/dumps/typeof_maps_0.nft
new file mode 100644
index 000000000000..833b834e3162
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/typeof_maps_0.nft
@@ -0,0 +1,16 @@
+table inet t {
+	map m1 {
+		typeof osf name : ct mark
+		elements = { "Linux" : 0x00000001 }
+	}
+
+	map m2 {
+		typeof vlan id : mark
+		elements = { 1 : 0x00000001 }
+	}
+
+	chain c {
+		ct mark set osf name map @m1
+		ct mark set osf name map @m2
+	}
+}
diff --git a/tests/shell/testcases/maps/typeof_maps_0 b/tests/shell/testcases/maps/typeof_maps_0
new file mode 100755
index 000000000000..14bf5811ac3f
--- /dev/null
+++ b/tests/shell/testcases/maps/typeof_maps_0
@@ -0,0 +1,27 @@
+#!/bin/bash
+
+# support for strings and integers in named maps.
+# without typeof, this is 'type string' and 'type integer',
+# but neither could be used because it lacks size information.
+
+EXPECTED="table inet t {
+	map m1 {
+		typeof osf name : ct mark
+		elements = { "Linux" : 0x00000001 }
+	}
+
+	map m2 {
+		typeof vlan id : mark
+		elements = { 1 : 0x1,
+			     4095 : 0x4095 }
+	}
+
+	chain c {
+		ct mark set ip daddr map @m1
+		ether type vlan meta mark set vlan id map @m2
+	}
+}"
+
+set -e
+$NFT -f - <<< $EXPECTED
+
diff --git a/tests/shell/testcases/sets/dumps/typeof_sets_0.nft b/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
new file mode 100644
index 000000000000..44e11202d299
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
@@ -0,0 +1,19 @@
+table inet t {
+	set s1 {
+		typeof osf name
+		elements = { "Linux" }
+	}
+
+	set s2 {
+		typeof vlan id
+		elements = { 2, 3, 103 }
+	}
+
+	chain c1 {
+		osf name @s1 accept
+	}
+
+	chain c2 {
+		vlan id @s2 accept
+	}
+}
diff --git a/tests/shell/testcases/sets/typeof_sets_0 b/tests/shell/testcases/sets/typeof_sets_0
new file mode 100755
index 000000000000..2a8b21c725c6
--- /dev/null
+++ b/tests/shell/testcases/sets/typeof_sets_0
@@ -0,0 +1,29 @@
+#!/bin/bash
+
+# support for strings/typeof in named sets.
+# s1 and s2 are identical, they just use different
+# ways for declaration.
+
+EXPECTED="table inet t {
+	set s1 {
+		typeof osf name
+		elements = { \"Linux\" }
+	}
+
+	set s2 {
+		typeof vlan id
+		elements = { 2, 3, 103 }
+	}
+
+	chain c1 {
+		osf name @s1 accept
+	}
+
+	chain c2 {
+		ether type vlan vlan id @s2 accept
+	}
+}"
+
+set -e
+$NFT -f - <<< $EXPECTED
+
-- 
2.24.1

