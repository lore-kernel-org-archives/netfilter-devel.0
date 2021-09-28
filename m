Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B8BC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Sep 2021 20:55:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B052D6137E
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Sep 2021 20:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242762AbhI1U53 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Sep 2021 16:57:29 -0400
Received: from mail.netfilter.org ([217.70.188.207]:58740 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242734AbhI1U53 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Sep 2021 16:57:29 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8FBE863EC4
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Sep 2021 22:54:23 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] evaluate: check for concatenation in set data datatype
Date:   Tue, 28 Sep 2021 22:55:42 +0200
Message-Id: <20210928205543.368551-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When adding this rule with an existing map:

  add rule nat x y meta l4proto { tcp, udp } dnat ip to ip daddr . th dport map @fwdtoip_th

reports a bogus:

Error: datatype mismatch: expected IPv4 address, expression has type
concatenation of (IPv4 address, internet network service)

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                                        |  3 ++-
 tests/shell/testcases/sets/0067nat_concat_interval_0  | 11 +++++++++++
 .../sets/dumps/0067nat_concat_interval_0.nft          |  7 +++++++
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index a0c67fb0e213..1737ca0854cd 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3243,7 +3243,8 @@ static bool nat_concat_map(struct eval_ctx *ctx, struct stmt *stmt)
 		if (expr_evaluate(ctx, &stmt->nat.addr->mappings))
 			return false;
 
-		if (stmt->nat.addr->mappings->set->data->etype == EXPR_CONCAT) {
+		if (stmt->nat.addr->mappings->set->data->etype == EXPR_CONCAT ||
+		    stmt->nat.addr->mappings->set->data->dtype->subtypes) {
 			stmt->nat.type_flags |= STMT_NAT_F_CONCAT;
 			return true;
 		}
diff --git a/tests/shell/testcases/sets/0067nat_concat_interval_0 b/tests/shell/testcases/sets/0067nat_concat_interval_0
index 3d1b62d69b26..530771b0016c 100755
--- a/tests/shell/testcases/sets/0067nat_concat_interval_0
+++ b/tests/shell/testcases/sets/0067nat_concat_interval_0
@@ -31,3 +31,14 @@ EXPECTED="table ip nat {
 }"
 
 $NFT -f - <<< $EXPECTED
+
+EXPECTED="table ip nat {
+	map fwdtoip_th {
+		type ipv4_addr . inet_service : interval ipv4_addr . inet_service
+		flags interval
+		elements = { 1.2.3.4 . 10000-20000 : 192.168.3.4 . 30000-40000 }
+	}
+}"
+
+$NFT -f - <<< $EXPECTED
+$NFT add rule ip nat prerouting meta l4proto { tcp, udp } dnat to ip daddr . th dport map @fwdtoip_th
diff --git a/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft b/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft
index c565d21f8acc..3226da157272 100644
--- a/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft
+++ b/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft
@@ -11,9 +11,16 @@ table ip nat {
 		elements = { 192.168.1.2 . 192.168.2.2 : 127.0.0.0/8 . 42-43 }
 	}
 
+	map fwdtoip_th {
+		type ipv4_addr . inet_service : interval ipv4_addr . inet_service
+		flags interval
+		elements = { 1.2.3.4 . 10000-20000 : 192.168.3.4 . 30000-40000 }
+	}
+
 	chain prerouting {
 		type nat hook prerouting priority dstnat; policy accept;
 		ip protocol tcp dnat ip to ip saddr map @ipportmap
 		ip protocol tcp dnat ip to ip saddr . ip daddr map @ipportmap2
+		meta l4proto { tcp, udp } dnat ip to ip daddr . th dport map @fwdtoip_th
 	}
 }
-- 
2.30.2

