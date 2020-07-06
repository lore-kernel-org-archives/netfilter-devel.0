Return-Path: <SRS0=Edk1=AR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09912C433E0
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jul 2020 11:17:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1E6C20724
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jul 2020 11:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbgGFLR6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Jul 2020 07:17:58 -0400
Received: from correo.us.es ([193.147.175.20]:55264 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728578AbgGFLR6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Jul 2020 07:17:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 25273DA715
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Jul 2020 13:17:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 11723DA73F
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Jul 2020 13:17:56 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0D127DA72F; Mon,  6 Jul 2020 13:17:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AC2BFDA792
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Jul 2020 13:17:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 06 Jul 2020 13:17:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 98F4642EF42E
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Jul 2020 13:17:53 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] segtree: zap element statement when decomposing interval
Date:   Mon,  6 Jul 2020 13:17:48 +0200
Message-Id: <20200706111748.29601-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Otherwise, interval sets do not display element statement such as
counters.

Fixes: 6d80e0f15492 ("src: support for counter in set definition")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c                                 | 16 ++++++++++++++++
 .../testcases/sets/0051set_interval_counter_0 | 19 +++++++++++++++++++
 .../sets/dumps/0051set_interval_counter_0.nft | 13 +++++++++++++
 3 files changed, 48 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0051set_interval_counter_0
 create mode 100644 tests/shell/testcases/sets/dumps/0051set_interval_counter_0.nft

diff --git a/src/segtree.c b/src/segtree.c
index b6ca6083ea0b..c143a6a74a21 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -1027,6 +1027,10 @@ void interval_map_decompose(struct expr *set)
 					tmp->timeout = low->left->timeout;
 				if (low->left->expiration)
 					tmp->expiration = low->left->expiration;
+				if (low->left->stmt) {
+					tmp->stmt = low->left->stmt;
+					low->left->stmt = NULL;
+				}
 
 				tmp = mapping_expr_alloc(&tmp->location, tmp,
 							 expr_clone(low->right));
@@ -1037,6 +1041,10 @@ void interval_map_decompose(struct expr *set)
 					tmp->timeout = low->timeout;
 				if (low->expiration)
 					tmp->expiration = low->expiration;
+				if (low->left->stmt) {
+					tmp->stmt = low->stmt;
+					low->stmt = NULL;
+				}
 			}
 
 			compound_expr_add(set, tmp);
@@ -1059,6 +1067,10 @@ void interval_map_decompose(struct expr *set)
 					prefix->timeout = low->left->timeout;
 				if (low->left->expiration)
 					prefix->expiration = low->left->expiration;
+				if (low->left->stmt) {
+					prefix->stmt = low->left->stmt;
+					low->left->stmt = NULL;
+				}
 
 				prefix = mapping_expr_alloc(&low->location, prefix,
 							    expr_clone(low->right));
@@ -1069,6 +1081,10 @@ void interval_map_decompose(struct expr *set)
 					prefix->timeout = low->timeout;
 				if (low->expiration)
 					prefix->expiration = low->expiration;
+				if (low->stmt) {
+					prefix->stmt = low->stmt;
+					low->stmt = NULL;
+				}
 			}
 
 			compound_expr_add(set, prefix);
diff --git a/tests/shell/testcases/sets/0051set_interval_counter_0 b/tests/shell/testcases/sets/0051set_interval_counter_0
new file mode 100755
index 000000000000..ea90e264bfcc
--- /dev/null
+++ b/tests/shell/testcases/sets/0051set_interval_counter_0
@@ -0,0 +1,19 @@
+#!/bin/bash
+
+set -e
+
+EXPECTED="table ip x {
+	set s {
+		type ipv4_addr
+		flags interval
+		counter
+		elements = { 192.168.2.0/24 }
+	}
+
+	chain y {
+		type filter hook output priority filter; policy accept;
+		ip daddr @s
+	}
+}"
+
+$NFT -f - <<< "$EXPECTED"
diff --git a/tests/shell/testcases/sets/dumps/0051set_interval_counter_0.nft b/tests/shell/testcases/sets/dumps/0051set_interval_counter_0.nft
new file mode 100644
index 000000000000..fd488a76432f
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0051set_interval_counter_0.nft
@@ -0,0 +1,13 @@
+table ip x {
+	set s {
+		type ipv4_addr
+		flags interval
+		counter
+		elements = { 192.168.2.0/24 counter packets 0 bytes 0 }
+	}
+
+	chain y {
+		type filter hook output priority filter; policy accept;
+		ip daddr @s
+	}
+}
-- 
2.20.1

