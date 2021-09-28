Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E528AC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Sep 2021 22:27:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAF666138D
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Sep 2021 22:27:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234701AbhI1W30 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Sep 2021 18:29:26 -0400
Received: from mail.netfilter.org ([217.70.188.207]:58974 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbhI1W30 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Sep 2021 18:29:26 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 50B3663586
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Sep 2021 00:26:20 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 2/2] evaluate: check for missing transport protocol match in nat map with concatenations
Date:   Wed, 29 Sep 2021 00:27:37 +0200
Message-Id: <20210928222737.434858-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Restore this error with NAT maps:

 # nft add rule 'ip ipfoo c dnat to ip daddr map @y'
 Error: transport protocol mapping is only valid after transport protocol match
 add rule ip ipfoo c dnat to ip daddr map @y
                     ~~~~    ^^^^^^^^^^^^^^^

Allow for transport protocol match in the map too, which is implicitly
pulling in a transport protocol dependency.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: - update tests
    - payload transport expression in mapping (except th) pulls in dependencies.

 src/evaluate.c             | 12 ++++++++++++
 tests/py/ip/snat.t         |  6 +++++-
 tests/py/ip/snat.t.payload | 22 ++++++++++++++++++++--
 3 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 1737ca0854cd..d62f73dcb889 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3080,6 +3080,11 @@ static bool nat_evaluate_addr_has_th_expr(const struct expr *map)
 	list_for_each_entry(i, &concat->expressions, list) {
 		enum proto_bases base;
 
+		if (i->etype == EXPR_PAYLOAD &&
+		    i->payload.base == PROTO_BASE_TRANSPORT_HDR &&
+		    i->payload.desc != &proto_th)
+			return true;
+
 		if ((i->flags & EXPR_F_PROTOCOL) == 0)
 			continue;
 
@@ -3159,10 +3164,17 @@ static int stmt_evaluate_addr(struct eval_ctx *ctx, struct stmt *stmt,
 
 static int stmt_evaluate_nat_map(struct eval_ctx *ctx, struct stmt *stmt)
 {
+	struct proto_ctx *pctx = &ctx->pctx;
 	struct expr *one, *two, *data, *tmp;
 	const struct datatype *dtype;
 	int addr_type, err;
 
+	if (pctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc == NULL &&
+	    !nat_evaluate_addr_has_th_expr(stmt->nat.addr))
+		return stmt_binary_error(ctx, stmt->nat.addr, stmt,
+					 "transport protocol mapping is only "
+					 "valid after transport protocol match");
+
 	switch (stmt->nat.family) {
 	case NFPROTO_IPV4:
 		addr_type = TYPE_IPADDR;
diff --git a/tests/py/ip/snat.t b/tests/py/ip/snat.t
index a8ff8d1a00c1..d4b0d2cb0a88 100644
--- a/tests/py/ip/snat.t
+++ b/tests/py/ip/snat.t
@@ -11,7 +11,11 @@ iifname "eth0" tcp dport 80-90 snat to 192.168.3.15-192.168.3.240;ok
 
 iifname "eth0" tcp dport != 23-34 snat to 192.168.3.2;ok
 
-snat ip to ip saddr map { 10.141.11.4 : 192.168.2.3 . 80 };ok
+meta l4proto 17 snat ip to ip saddr map { 10.141.11.4 : 192.168.2.3 . 80 };ok
 snat ip to ip saddr map { 10.141.11.4 : 192.168.2.2-192.168.2.4 };ok
 snat ip to ip saddr map { 10.141.12.14 : 192.168.2.0/24 };ok
 snat ip prefix to ip saddr map { 10.141.11.0/24 : 192.168.2.0/24 };ok
+
+meta l4proto { 6, 17} snat ip to ip saddr . th dport map { 10.141.11.4 . 20 : 192.168.2.3 . 80};ok
+snat ip to ip saddr map { 10.141.11.4 : 192.168.2.3 . 80 };fail
+snat ip to ip saddr . th dport map { 10.141.11.4 . 20 : 192.168.2.3 . 80 };fail
diff --git a/tests/py/ip/snat.t.payload b/tests/py/ip/snat.t.payload
index 64f478964a40..48ae46b31121 100644
--- a/tests/py/ip/snat.t.payload
+++ b/tests/py/ip/snat.t.payload
@@ -86,11 +86,13 @@ ip
   [ immediate reg 2 0xf003a8c0 ]
   [ nat snat ip addr_min reg 1 addr_max reg 2 ]
 
-# snat ip to ip saddr map { 10.141.11.4 : 192.168.2.3 . 80 }
+# meta l4proto 17 snat ip to ip saddr map { 10.141.11.4 : 192.168.2.3 . 80 }
 __map%d test-ip4 b size 1
 __map%d test-ip4 0
 	element 040b8d0a  : 0302a8c0 00005000 0 [end]
-ip 
+ip
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ nat snat ip addr_min reg 1 proto_min reg 9 ]
@@ -121,3 +123,19 @@ ip
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ nat snat ip addr_min reg 1 addr_max reg 9 ]
+
+# meta l4proto { 6, 17} snat ip to ip saddr . th dport map { 10.141.11.4 . 20 : 192.168.2.3 . 80}
+__set%d test-ip4 3 size 2
+__set%d test-ip4 0
+        element 00000006  : 0 [end]     element 00000011  : 0 [end]
+__map%d test-ip4 b size 1
+__map%d test-ip4 0
+        element 040b8d0a 00001400  : 0302a8c0 00005000 0 [end]
+ip
+  [ meta load l4proto => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ payload load 2b @ transport header + 2 => reg 9 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ nat snat ip addr_min reg 1 proto_min reg 9 ]
+
-- 
2.30.2

