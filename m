Return-Path: <SRS0=9gIA=6L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD3BCC82E42
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Apr 2020 23:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93E192072D
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Apr 2020 23:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgD0XMa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Apr 2020 19:12:30 -0400
Received: from correo.us.es ([193.147.175.20]:44774 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726204AbgD0XM3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Apr 2020 19:12:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 09D0AD2DA14
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 01:12:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EEA57BAAB5
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 01:12:27 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E3A02BAAB4; Tue, 28 Apr 2020 01:12:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EE561DA736
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 01:12:25 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 28 Apr 2020 01:12:25 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DC11F42EF9E1
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 01:12:25 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 9/9] tests: shell: add NAT mappings tests
Date:   Tue, 28 Apr 2020 01:12:17 +0200
Message-Id: <20200427231217.20274-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200427231217.20274-1-pablo@netfilter.org>
References: <20200427231217.20274-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/sets/0046netmap_0       | 14 +++++++++++++
 tests/shell/testcases/sets/0047nat_0          | 20 +++++++++++++++++++
 .../testcases/sets/dumps/0046netmap_0.nft     |  6 ++++++
 .../shell/testcases/sets/dumps/0047nat_0.nft  | 13 ++++++++++++
 4 files changed, 53 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0046netmap_0
 create mode 100755 tests/shell/testcases/sets/0047nat_0
 create mode 100644 tests/shell/testcases/sets/dumps/0046netmap_0.nft
 create mode 100644 tests/shell/testcases/sets/dumps/0047nat_0.nft

diff --git a/tests/shell/testcases/sets/0046netmap_0 b/tests/shell/testcases/sets/0046netmap_0
new file mode 100755
index 000000000000..2804a4a27ede
--- /dev/null
+++ b/tests/shell/testcases/sets/0046netmap_0
@@ -0,0 +1,14 @@
+#!/bin/bash
+
+EXPECTED="table ip x {
+            chain y {
+                    type nat hook postrouting priority srcnat; policy accept;
+                    snat ip prefix to ip saddr map { 10.141.11.0/24 : 192.168.2.0/24,
+						     10.141.12.0/24 : 192.168.3.0/24,
+						     10.141.13.0/24 : 192.168.4.0/24 }
+            }
+     }
+"
+
+set -e
+$NFT -f - <<< $EXPECTED
diff --git a/tests/shell/testcases/sets/0047nat_0 b/tests/shell/testcases/sets/0047nat_0
new file mode 100755
index 000000000000..746a6b6d3450
--- /dev/null
+++ b/tests/shell/testcases/sets/0047nat_0
@@ -0,0 +1,20 @@
+#!/bin/bash
+
+EXPECTED="table ip x {
+            map y {
+                    type ipv4_addr : interval ipv4_addr
+                    flags interval
+                    elements = { 10.141.10.0/24 : 192.168.2.2-192.168.2.4,
+				 10.141.11.0/24 : 192.168.4.2-192.168.4.3 }
+            }
+
+            chain y {
+                    type nat hook postrouting priority srcnat; policy accept;
+                    snat ip interval to ip saddr map @y
+            }
+     }
+"
+
+set -e
+$NFT -f - <<< $EXPECTED
+$NFT add element x y { 10.141.12.0/24 : 192.168.5.10-192.168.5.20 }
diff --git a/tests/shell/testcases/sets/dumps/0046netmap_0.nft b/tests/shell/testcases/sets/dumps/0046netmap_0.nft
new file mode 100644
index 000000000000..7b66e644c05a
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0046netmap_0.nft
@@ -0,0 +1,6 @@
+table ip x {
+	chain y {
+		type nat hook postrouting priority srcnat; policy accept;
+		snat ip prefix to ip saddr map { 10.141.11.0/24 : 192.168.2.0-192.168.2.255, 10.141.12.0/24 : 192.168.3.0-192.168.3.255, 10.141.13.0/24 : 192.168.4.0-192.168.4.255 }
+	}
+}
diff --git a/tests/shell/testcases/sets/dumps/0047nat_0.nft b/tests/shell/testcases/sets/dumps/0047nat_0.nft
new file mode 100644
index 000000000000..ebfb174199e1
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0047nat_0.nft
@@ -0,0 +1,13 @@
+table ip x {
+	map y {
+		type ipv4_addr : interval ipv4_addr
+		flags interval
+		elements = { 10.141.10.0/24 : 192.168.2.2-192.168.2.4, 10.141.11.0/24 : 192.168.4.2-192.168.4.3,
+			     10.141.12.0/24 : 192.168.5.10-192.168.5.20 }
+	}
+
+	chain y {
+		type nat hook postrouting priority srcnat; policy accept;
+		snat ip interval to ip saddr map @y
+	}
+}
-- 
2.20.1

