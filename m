Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53003C001DC
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Jul 2023 11:24:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjGaLYg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 Jul 2023 07:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjGaLYf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Jul 2023 07:24:35 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 954B7F1
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2023 04:24:32 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] libnftables: Drop cache in -c/--check mode
Date:   Mon, 31 Jul 2023 13:24:24 +0200
Message-Id: <20230731112424.69600-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extend e0aace943412 ("libnftables: Drop cache in error case") to also
drop the cache with -c/--check, this is a dry run mode and kernel does
not get any update.

This fixes a bug with -o/--optimize, which first runs in an implicit
-c/--check mode to validate that the ruleset is correct, then it
provides the proposed optimization. In this case, if the cache is not
emptied, old objects in the cache refer to scanner data that was
already released, which triggers BUG like this:

 BUG: invalid input descriptor type 151665524
 nft: erec.c:161: erec_print: Assertion `0' failed.
 Aborted

This bug was triggered in a ruleset that contains a set for geoip
filtering. This patch also extends tests/shell to cover this case.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/libnftables.c                                     |  7 +++++--
 .../optimizations/dumps/skip_unsupported.nft          | 11 +++++++++++
 tests/shell/testcases/optimizations/skip_unsupported  | 11 +++++++++++
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index 6fc4f7db6760..e214abb69cf2 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -607,8 +607,10 @@ err:
 	    nft_output_json(&nft->output) &&
 	    nft_output_echo(&nft->output))
 		json_print_echo(nft);
-	if (rc)
+
+	if (rc || nft->check)
 		nft_cache_release(&nft->cache);
+
 	return rc;
 }
 
@@ -713,7 +715,8 @@ err:
 	    nft_output_json(&nft->output) &&
 	    nft_output_echo(&nft->output))
 		json_print_echo(nft);
-	if (rc)
+
+	if (rc || nft->check)
 		nft_cache_release(&nft->cache);
 
 	scope_release(nft->state->scopes[0]);
diff --git a/tests/shell/testcases/optimizations/dumps/skip_unsupported.nft b/tests/shell/testcases/optimizations/dumps/skip_unsupported.nft
index 43b6578dc704..f24855e7b5e1 100644
--- a/tests/shell/testcases/optimizations/dumps/skip_unsupported.nft
+++ b/tests/shell/testcases/optimizations/dumps/skip_unsupported.nft
@@ -1,4 +1,15 @@
 table inet x {
+	set GEOIP_CC_wan-lan_120 {
+		type ipv4_addr
+		flags interval
+		elements = { 1.32.128.0/18, 1.32.200.0-1.32.204.128,
+			     1.32.207.0/24, 1.32.216.118-1.32.216.255,
+			     1.32.219.0-1.32.222.255, 1.32.226.0/23,
+			     1.32.231.0/24, 1.32.233.0/24,
+			     1.32.238.0/23, 1.32.240.0/24,
+			     223.223.220.0/22, 223.255.254.0/24 }
+	}
+
 	chain y {
 		ip saddr 1.2.3.4 tcp dport 80 meta mark set 0x0000000a accept
 		ip saddr 1.2.3.4 tcp dport 81 meta mark set 0x0000000b accept
diff --git a/tests/shell/testcases/optimizations/skip_unsupported b/tests/shell/testcases/optimizations/skip_unsupported
index 9313c302048c..6baa8280a9b5 100755
--- a/tests/shell/testcases/optimizations/skip_unsupported
+++ b/tests/shell/testcases/optimizations/skip_unsupported
@@ -3,6 +3,17 @@
 set -e
 
 RULESET="table inet x {
+	set GEOIP_CC_wan-lan_120 {
+		type ipv4_addr
+		flags interval
+		elements = { 1.32.128.0/18, 1.32.200.0-1.32.204.128,
+			     1.32.207.0/24, 1.32.216.118-1.32.216.255,
+			     1.32.219.0-1.32.222.255, 1.32.226.0/23,
+			     1.32.231.0/24, 1.32.233.0/24,
+			     1.32.238.0/23, 1.32.240.0/24,
+			     223.223.220.0/22, 223.255.254.0/24 }
+	}
+
 	chain y {
 		ip saddr 1.2.3.4 tcp dport 80 meta mark set 10 accept
 		ip saddr 1.2.3.4 tcp dport 81 meta mark set 11 accept
-- 
2.30.2

