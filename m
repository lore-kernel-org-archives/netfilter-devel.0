From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 1/3, libnftnl] tests: Add missing tests to test-script.sh
Date: Wed, 10 Aug 2016 17:12:03 +0200
Message-ID: <20160810151205.24975-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:51718 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933761AbcHJUcS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 16:32:18 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
---
 tests/test-script.sh | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tests/test-script.sh b/tests/test-script.sh
index b040158..ba13571 100755
--- a/tests/test-script.sh
+++ b/tests/test-script.sh
@@ -4,7 +4,9 @@
 ./nft-expr_cmp-test
 ./nft-expr_counter-test
 ./nft-expr_ct-test
+./nft-expr_dup-test
 ./nft-expr_exthdr-test
+./nft-expr_fwd-test
 ./nft-expr_immediate-test
 ./nft-expr_limit-test
 ./nft-expr_log-test
@@ -12,6 +14,7 @@
 ./nft-expr_match-test
 ./nft-expr_masq-test
 ./nft-expr_meta-test
+./nft-expr_queue-test
 ./nft-expr_redir-test
 ./nft-expr_nat-test
 ./nft-expr_payload-test
-- 
2.8.3

