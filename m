Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DAA1C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Mar 2022 11:50:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234481AbiC1Lvj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Mar 2022 07:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241894AbiC1Lrn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Mar 2022 07:47:43 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 46E8119C37
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Mar 2022 04:42:03 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0F72F601B5
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Mar 2022 13:38:53 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] expression: typeof verdict needs verdict datatype
Date:   Mon, 28 Mar 2022 13:41:53 +0200
Message-Id: <20220328114153.715876-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Otherwise listing breaks showing [invalid type] notice.

 # nft list ruleset
 table inet x {
        map y {
                typeof ip saddr : verdict
                elements = { 1.1.1.1 : 0x1010101 [invalid type] }
        }
 }

Update tests to cover this usecase.

Fixes: 4ab1e5e60779 ("src: allow use of 'verdict' in typeof definitions")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expression.c                                   | 1 +
 tests/shell/testcases/maps/dumps/typeof_maps_0.nft | 2 ++
 tests/shell/testcases/maps/typeof_maps_0           | 2 ++
 3 files changed, 5 insertions(+)

diff --git a/src/expression.c b/src/expression.c
index ea999f2e546c..612f2c06d1b1 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -268,6 +268,7 @@ static struct expr *verdict_expr_parse_udata(const struct nftnl_udata *attr)
 	struct expr *e;
 
 	e = symbol_expr_alloc(&internal_location, SYMBOL_VALUE, NULL, "verdict");
+	e->dtype = &verdict_type;
 	e->len = NFT_REG_SIZE * BITS_PER_BYTE;
 	return e;
 }
diff --git a/tests/shell/testcases/maps/dumps/typeof_maps_0.nft b/tests/shell/testcases/maps/dumps/typeof_maps_0.nft
index 438b9829db90..7315b0731d6d 100644
--- a/tests/shell/testcases/maps/dumps/typeof_maps_0.nft
+++ b/tests/shell/testcases/maps/dumps/typeof_maps_0.nft
@@ -17,11 +17,13 @@ table inet t {
 
 	map m4 {
 		typeof iifname . ip protocol . th dport : verdict
+		elements = { "eth0" . tcp . 22 : accept }
 	}
 
 	chain c {
 		ct mark set osf name map @m1
 		meta mark set vlan id map @m2
 		meta mark set ip saddr . ip daddr map @m3
+		iifname . ip protocol . th dport vmap @m4
 	}
 }
diff --git a/tests/shell/testcases/maps/typeof_maps_0 b/tests/shell/testcases/maps/typeof_maps_0
index f024ebe0f9f6..9e36c02f514f 100755
--- a/tests/shell/testcases/maps/typeof_maps_0
+++ b/tests/shell/testcases/maps/typeof_maps_0
@@ -24,12 +24,14 @@ EXPECTED="table inet t {
 
 	map m4 {
 		typeof        iifname . ip protocol . th dport : verdict
+		elements = { eth0 . tcp . 22 : accept }
 	}
 
 	chain c {
 		ct mark set osf name map @m1
 		ether type vlan meta mark set vlan id map @m2
 		meta mark set ip saddr . ip daddr map @m3
+		iifname . ip protocol . th dport vmap @m4
 	}
 }"
 
-- 
2.30.2

