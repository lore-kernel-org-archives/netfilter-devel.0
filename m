Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 746FEC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Dec 2021 23:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbhLOXgP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Dec 2021 18:36:15 -0500
Received: from mail.netfilter.org ([217.70.188.207]:56556 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232096AbhLOXgP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Dec 2021 18:36:15 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id B96FA625F1
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Dec 2021 00:33:44 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: shell: extend catchall tests for maps
Date:   Thu, 16 Dec 2021 00:36:07 +0100
Message-Id: <20211215233607.170171-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211215233607.170171-1-pablo@netfilter.org>
References: <20211215233607.170171-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a few tests for the catchall features and maps.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/sets/0064map_catchall_0           | 5 +++++
 tests/shell/testcases/sets/dumps/0064map_catchall_0.nft | 6 ++++++
 2 files changed, 11 insertions(+)

diff --git a/tests/shell/testcases/sets/0064map_catchall_0 b/tests/shell/testcases/sets/0064map_catchall_0
index 6f2a7c6f0249..436851604e34 100755
--- a/tests/shell/testcases/sets/0064map_catchall_0
+++ b/tests/shell/testcases/sets/0064map_catchall_0
@@ -17,3 +17,8 @@ RULESET="table ip x {
 $NFT -f - <<< $RULESET
 $NFT delete element x y { \* : 192.168.0.3 }
 $NFT add element x y { \* : 192.168.0.4 }
+
+$NFT add chain x y
+$NFT add rule x y snat to ip saddr map @z
+$NFT 'add rule x y snat to ip saddr map { 10.141.0.0/24 : 192.168.0.2, * : 192.168.0.3 }'
+$NFT 'add rule x y snat to ip saddr . ip daddr map { 10.141.0.0/24 . 10.0.0.0/8 : 192.168.0.2, 192.168.9.0/24 . 192.168.10.0/24 : 192.168.0.4, * : 192.168.0.3 }'
diff --git a/tests/shell/testcases/sets/dumps/0064map_catchall_0.nft b/tests/shell/testcases/sets/dumps/0064map_catchall_0.nft
index 286683a05df9..890ed2aab080 100644
--- a/tests/shell/testcases/sets/dumps/0064map_catchall_0.nft
+++ b/tests/shell/testcases/sets/dumps/0064map_catchall_0.nft
@@ -9,4 +9,10 @@ table ip x {
 		flags interval
 		elements = { 10.141.0.0/24 : 192.168.0.2, * : 192.168.0.3 }
 	}
+
+	chain y {
+		snat to ip saddr map @z
+		snat to ip saddr map { 10.141.0.0/24 : 192.168.0.2, * : 192.168.0.3 }
+		snat to ip saddr . ip daddr map { 10.141.0.0/24 . 10.0.0.0/8 : 192.168.0.2, 192.168.9.0/24 . 192.168.10.0/24 : 192.168.0.4, * : 192.168.0.3 }
+	}
 }
-- 
2.30.2

