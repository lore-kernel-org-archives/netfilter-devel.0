Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C3FFCD5BD6
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Sep 2023 15:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233098AbjISPVh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Sep 2023 11:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbjISPVh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Sep 2023 11:21:37 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0793DEC
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Sep 2023 08:21:29 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2] limit: display default burst when listing ruleset
Date:   Tue, 19 Sep 2023 17:21:25 +0200
Message-Id: <20230919152125.529465-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Default burst for limit is 5 for historical reasons but it is not
displayed when listing the ruleset.

Update listing to display the default burst to disambiguate.

man nft(8) has been recently updated to document this, no action in this
front is therefore required.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: update tests/shell.

 src/statement.c                               |  4 +---
 tests/py/any/limit.t                          | 20 +++++++++----------
 .../json/dumps/0001set_statements_0.nft       |  2 +-
 .../nft-f/dumps/0025empty_dynset_0.nft        |  2 +-
 .../sets/dumps/0022type_selective_flush_0.nft |  2 +-
 .../testcases/sets/dumps/0038meter_list_0.nft |  2 +-
 .../sets/dumps/0059set_update_multistmt_0.nft |  2 +-
 .../sets/dumps/0060set_multistmt_0.nft        |  6 +++---
 8 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/src/statement.c b/src/statement.c
index 721739498e2e..66424eb420ab 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -486,9 +486,7 @@ static void limit_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 		nft_print(octx, "limit rate %s%" PRIu64 "/%s",
 			  inv ? "over " : "", stmt->limit.rate,
 			  get_unit(stmt->limit.unit));
-		if (stmt->limit.burst && stmt->limit.burst != 5)
-			nft_print(octx, " burst %u packets",
-				  stmt->limit.burst);
+		nft_print(octx, " burst %u packets", stmt->limit.burst);
 		break;
 	case NFT_LIMIT_PKT_BYTES:
 		data_unit = get_rate(stmt->limit.rate, &rate);
diff --git a/tests/py/any/limit.t b/tests/py/any/limit.t
index 86e8d43009b9..a04ef42af931 100644
--- a/tests/py/any/limit.t
+++ b/tests/py/any/limit.t
@@ -9,11 +9,11 @@
 *bridge;test-bridge;output
 *netdev;test-netdev;ingress,egress
 
-limit rate 400/minute;ok
-limit rate 20/second;ok
-limit rate 400/hour;ok
-limit rate 40/day;ok
-limit rate 400/week;ok
+limit rate 400/minute;ok;limit rate 400/minute burst 5 packets
+limit rate 20/second;ok;limit rate 20/second burst 5 packets
+limit rate 400/hour;ok;limit rate 400/hour burst 5 packets
+limit rate 40/day;ok;limit rate 40/day burst 5 packets
+limit rate 400/week;ok;limit rate 400/week burst 5 packets
 limit rate 1023/second burst 10 packets;ok
 limit rate 1023/second burst 10 bytes;fail
 
@@ -35,11 +35,11 @@ limit rate 1025 kbytes/second burst 1023 kbytes;ok
 limit rate 1025 mbytes/second burst 1025 kbytes;ok
 limit rate 1025000 mbytes/second burst 1023 mbytes;ok
 
-limit rate over 400/minute;ok
-limit rate over 20/second;ok
-limit rate over 400/hour;ok
-limit rate over 40/day;ok
-limit rate over 400/week;ok
+limit rate over 400/minute;ok;limit rate over 400/minute burst 5 packets
+limit rate over 20/second;ok;limit rate over 20/second burst 5 packets
+limit rate over 400/hour;ok;limit rate over 400/hour burst 5 packets
+limit rate over 40/day;ok;limit rate over 40/day burst 5 packets
+limit rate over 400/week;ok;limit rate over 400/week burst 5 packets
 limit rate over 1023/second burst 10 packets;ok
 
 limit rate over 1 kbytes/second;ok
diff --git a/tests/shell/testcases/json/dumps/0001set_statements_0.nft b/tests/shell/testcases/json/dumps/0001set_statements_0.nft
index ee4a86705a94..d80a43211943 100644
--- a/tests/shell/testcases/json/dumps/0001set_statements_0.nft
+++ b/tests/shell/testcases/json/dumps/0001set_statements_0.nft
@@ -7,6 +7,6 @@ table ip testt {
 
 	chain testc {
 		type filter hook input priority filter; policy accept;
-		tcp dport 22 ct state new add @ssh_meter { ip saddr limit rate 10/second } accept
+		tcp dport 22 ct state new add @ssh_meter { ip saddr limit rate 10/second burst 5 packets } accept
 	}
 }
diff --git a/tests/shell/testcases/nft-f/dumps/0025empty_dynset_0.nft b/tests/shell/testcases/nft-f/dumps/0025empty_dynset_0.nft
index 2bb35592588a..33b9e4ff7f20 100644
--- a/tests/shell/testcases/nft-f/dumps/0025empty_dynset_0.nft
+++ b/tests/shell/testcases/nft-f/dumps/0025empty_dynset_0.nft
@@ -13,6 +13,6 @@ table ip foo {
 	set inflows_ratelimit {
 		type ipv4_addr . inet_service . ifname . ipv4_addr . inet_service
 		flags dynamic
-		elements = { 10.1.0.3 . 39466 . "veth1" . 10.3.0.99 . 5201 limit rate 1/second counter packets 0 bytes 0 }
+		elements = { 10.1.0.3 . 39466 . "veth1" . 10.3.0.99 . 5201 limit rate 1/second burst 5 packets counter packets 0 bytes 0 }
 	}
 }
diff --git a/tests/shell/testcases/sets/dumps/0022type_selective_flush_0.nft b/tests/shell/testcases/sets/dumps/0022type_selective_flush_0.nft
index 5a6e3261b4ba..0a4cb0a54d73 100644
--- a/tests/shell/testcases/sets/dumps/0022type_selective_flush_0.nft
+++ b/tests/shell/testcases/sets/dumps/0022type_selective_flush_0.nft
@@ -8,6 +8,6 @@ table ip t {
 	}
 
 	chain c {
-		tcp dport 80 meter f size 1024 { ip saddr limit rate 10/second }
+		tcp dport 80 meter f size 1024 { ip saddr limit rate 10/second burst 5 packets }
 	}
 }
diff --git a/tests/shell/testcases/sets/dumps/0038meter_list_0.nft b/tests/shell/testcases/sets/dumps/0038meter_list_0.nft
index c537aa1c702a..f274086b5285 100644
--- a/tests/shell/testcases/sets/dumps/0038meter_list_0.nft
+++ b/tests/shell/testcases/sets/dumps/0038meter_list_0.nft
@@ -6,6 +6,6 @@ table ip t {
 	}
 
 	chain c {
-		tcp dport 80 meter m size 128 { ip saddr limit rate 10/second }
+		tcp dport 80 meter m size 128 { ip saddr limit rate 10/second burst 5 packets }
 	}
 }
diff --git a/tests/shell/testcases/sets/dumps/0059set_update_multistmt_0.nft b/tests/shell/testcases/sets/dumps/0059set_update_multistmt_0.nft
index 1b0ffae4d651..c1cc3b51d2bc 100644
--- a/tests/shell/testcases/sets/dumps/0059set_update_multistmt_0.nft
+++ b/tests/shell/testcases/sets/dumps/0059set_update_multistmt_0.nft
@@ -8,6 +8,6 @@ table ip x {
 
 	chain z {
 		type filter hook output priority filter; policy accept;
-		update @y { ip daddr limit rate 1/second counter }
+		update @y { ip daddr limit rate 1/second burst 5 packets counter }
 	}
 }
diff --git a/tests/shell/testcases/sets/dumps/0060set_multistmt_0.nft b/tests/shell/testcases/sets/dumps/0060set_multistmt_0.nft
index f23db53436fe..df68fcdf89e6 100644
--- a/tests/shell/testcases/sets/dumps/0060set_multistmt_0.nft
+++ b/tests/shell/testcases/sets/dumps/0060set_multistmt_0.nft
@@ -1,9 +1,9 @@
 table ip x {
 	set y {
 		type ipv4_addr
-		limit rate 1/second counter
-		elements = { 1.1.1.1 limit rate 1/second counter packets 0 bytes 0, 4.4.4.4 limit rate 1/second counter packets 0 bytes 0,
-			     5.5.5.5 limit rate 1/second counter packets 0 bytes 0 }
+		limit rate 1/second burst 5 packets counter
+		elements = { 1.1.1.1 limit rate 1/second burst 5 packets counter packets 0 bytes 0, 4.4.4.4 limit rate 1/second burst 5 packets counter packets 0 bytes 0,
+			     5.5.5.5 limit rate 1/second burst 5 packets counter packets 0 bytes 0 }
 	}
 
 	chain y {
-- 
2.30.2

