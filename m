Return-Path: <SRS0=a9hH=2D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40674C751C3
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7587B247C2
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbfLMQEV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Dec 2019 11:04:21 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:40382 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727990AbfLMQEV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Dec 2019 11:04:21 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ifnQR-0004Eu-Md; Fri, 13 Dec 2019 17:04:19 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v2 11/11] tests: add typeof test cases
Date:   Fri, 13 Dec 2019 17:03:45 +0100
Message-Id: <20191213160345.30057-12-fw@strlen.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191213160345.30057-1-fw@strlen.de>
References: <20191213160345.30057-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../testcases/maps/dumps/typeof_maps_0.nft    | 16 ++++++++
 tests/shell/testcases/maps/typeof_maps_0      | 26 ++++++++++++
 .../testcases/sets/dumps/typeof_sets_0.nft    | 31 ++++++++++++++
 tests/shell/testcases/sets/typeof_sets_0      | 40 +++++++++++++++++++
 4 files changed, 113 insertions(+)
 create mode 100644 tests/shell/testcases/maps/dumps/typeof_maps_0.nft
 create mode 100755 tests/shell/testcases/maps/typeof_maps_0
 create mode 100644 tests/shell/testcases/sets/dumps/typeof_sets_0.nft
 create mode 100755 tests/shell/testcases/sets/typeof_sets_0

diff --git a/tests/shell/testcases/maps/dumps/typeof_maps_0.nft b/tests/shell/testcases/maps/dumps/typeof_maps_0.nft
new file mode 100644
index 000000000000..5c6a4d1f8662
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
+		type string,128 : mark
+		elements = { "Linux" : 0x00000001 }
+	}
+
+	chain c {
+		ct mark set osf name map @m1
+		ct mark set osf name map @m2
+	}
+}
diff --git a/tests/shell/testcases/maps/typeof_maps_0 b/tests/shell/testcases/maps/typeof_maps_0
new file mode 100755
index 000000000000..16b54b7adeb3
--- /dev/null
+++ b/tests/shell/testcases/maps/typeof_maps_0
@@ -0,0 +1,26 @@
+#!/bin/bash
+
+# support for strings/typeof in named maps.
+# m1 and m2 are identical, they just use different
+# ways for declaration.
+
+EXPECTED="table inet t {
+	map m1 {
+		typeof osf name : ct mark
+		elements = { \"Linux\" : 0x1 }
+	}
+
+	map m2 {
+		type string, 128 : mark
+		elements = { \"Linux\" : 0x1 }
+	}
+
+	chain c {
+		ct mark set osf name map @m1
+		ct mark set osf name map @m2
+	}
+}"
+
+set -e
+$NFT -f - <<< $EXPECTED
+
diff --git a/tests/shell/testcases/sets/dumps/typeof_sets_0.nft b/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
new file mode 100644
index 000000000000..eeeeb844e0e1
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
@@ -0,0 +1,31 @@
+table inet t {
+	set s1 {
+		typeof osf name
+		elements = { "Linux" }
+	}
+
+	set s2 {
+		type string,128
+		elements = { "Linux" }
+	}
+
+	set s3 {
+		typeof vlan id
+		elements = { 2, 3, 103 }
+	}
+
+	set s4 {
+		type integer,16
+		elements = { 2, 3, 103, 2003 }
+	}
+
+	chain c1 {
+		osf name @s1 accept
+		osf name @s2 accept
+	}
+
+	chain c2 {
+		vlan id @s3 accept
+		vlan id @s4 accept
+	}
+}
diff --git a/tests/shell/testcases/sets/typeof_sets_0 b/tests/shell/testcases/sets/typeof_sets_0
new file mode 100755
index 000000000000..bbdeb4743ee7
--- /dev/null
+++ b/tests/shell/testcases/sets/typeof_sets_0
@@ -0,0 +1,40 @@
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
+		type string, 128
+		elements = { \"Linux\" }
+	}
+
+	set s3 {
+		typeof vlan id
+		elements = { 2, 3, 103 }
+	}
+
+	set s4 {
+		type integer,16
+		elements = { 2, 3, 103, 2003 }
+	}
+	chain c1 {
+		osf name @s1 accept
+		osf name @s2 accept
+	}
+
+	chain c2 {
+		ether type vlan vlan id @s3 accept
+		ether type vlan vlan id @s4 accept
+	}
+}"
+
+set -e
+$NFT -f - <<< $EXPECTED
+
-- 
2.23.0

