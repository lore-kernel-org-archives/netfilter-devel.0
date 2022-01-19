Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F6BC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jan 2022 21:43:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbiASVnZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 16:43:25 -0500
Received: from mail.netfilter.org ([217.70.188.207]:37052 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiASVnZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 16:43:25 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5063560027
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jan 2022 22:40:26 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] parser_bison: missing synproxy support in map declarations
Date:   Wed, 19 Jan 2022 22:43:18 +0100
Message-Id: <20220119214318.900947-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Update parser to allow for maps with synproxy.

Fixes: f44ab88b1088 ("src: add synproxy stateful object support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y                             |  1 +
 tests/shell/testcases/sets/0024named_objects_0 | 15 +++++++++++++++
 .../sets/dumps/0024named_objects_0.nft         | 18 ++++++++++++++++++
 3 files changed, 34 insertions(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 1136ab911f0f..d67d16b8bc8c 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1984,6 +1984,7 @@ map_block_obj_type	:	COUNTER	close_scope_counter { $$ = NFT_OBJECT_COUNTER; }
 			|	QUOTA	close_scope_quota { $$ = NFT_OBJECT_QUOTA; }
 			|	LIMIT	close_scope_limit { $$ = NFT_OBJECT_LIMIT; }
 			|	SECMARK close_scope_secmark { $$ = NFT_OBJECT_SECMARK; }
+			|	SYNPROXY { $$ = NFT_OBJECT_SYNPROXY; }
 			;
 
 map_block		:	/* empty */	{ $$ = $<set>-1; }
diff --git a/tests/shell/testcases/sets/0024named_objects_0 b/tests/shell/testcases/sets/0024named_objects_0
index 21200c3cca3c..6d21e3884da9 100755
--- a/tests/shell/testcases/sets/0024named_objects_0
+++ b/tests/shell/testcases/sets/0024named_objects_0
@@ -18,6 +18,15 @@ table inet x {
 	quota user124 {
 		over 2000 bytes
 	}
+	synproxy https-synproxy {
+		mss 1460
+		wscale 7
+		timestamp sack-perm
+	}
+	synproxy other-synproxy {
+		mss 1460
+		wscale 5
+	}
 	set y {
 		type ipv4_addr
 	}
@@ -25,9 +34,15 @@ table inet x {
 		type ipv4_addr : quota
 		elements = { 192.168.2.2 : "user124", 192.168.2.3 : "user124"}
 	}
+	map test2 {
+		type ipv4_addr : synproxy
+		flags interval
+		elements = { 192.168.1.0/24 : "https-synproxy", 192.168.2.0/24 : "other-synproxy" }
+	}
 	chain y {
 		type filter hook input priority 0; policy accept;
 		counter name ip saddr map { 192.168.2.2 : "user123", 1.1.1.1 : "user123", 2.2.2.2 : "user123"}
+		synproxy name ip saddr map { 192.168.1.0/24 : "https-synproxy", 192.168.2.0/24 : "other-synproxy" }
 		quota name ip saddr map @test drop
 	}
 }"
diff --git a/tests/shell/testcases/sets/dumps/0024named_objects_0.nft b/tests/shell/testcases/sets/dumps/0024named_objects_0.nft
index 2ffa4f2ff757..52d1bf64b686 100644
--- a/tests/shell/testcases/sets/dumps/0024named_objects_0.nft
+++ b/tests/shell/testcases/sets/dumps/0024named_objects_0.nft
@@ -15,6 +15,17 @@ table inet x {
 		over 2000 bytes
 	}
 
+	synproxy https-synproxy {
+		mss 1460
+		wscale 7
+		timestamp sack-perm
+	}
+
+	synproxy other-synproxy {
+		mss 1460
+		wscale 5
+	}
+
 	set y {
 		type ipv4_addr
 	}
@@ -24,9 +35,16 @@ table inet x {
 		elements = { 192.168.2.2 : "user124", 192.168.2.3 : "user124" }
 	}
 
+	map test2 {
+		type ipv4_addr : synproxy
+		flags interval
+		elements = { 192.168.1.0/24 : "https-synproxy", 192.168.2.0/24 : "other-synproxy" }
+	}
+
 	chain y {
 		type filter hook input priority filter; policy accept;
 		counter name ip saddr map { 1.1.1.1 : "user123", 2.2.2.2 : "user123", 192.168.2.2 : "user123" }
+		synproxy name ip saddr map { 192.168.1.0/24 : "https-synproxy", 192.168.2.0/24 : "other-synproxy" }
 		quota name ip saddr map @test drop
 	}
 }
-- 
2.30.2

