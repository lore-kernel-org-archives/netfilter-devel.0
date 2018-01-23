From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] tests: shell: fetch rule handle with '-a' option and then delete
Date: Wed, 24 Jan 2018 04:47:39 +0530
Message-ID: <20180123231739.6412-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, harshasharmaiitr@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:46378 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932273AbeAWXR4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jan 2018 18:17:56 -0500
Received: by mail-pg0-f66.google.com with SMTP id s9so1346951pgq.13
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2018 15:17:56 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fetch rule handle and then delete rule via that rule handle.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 tests/shell/testcases/cache/0001_cache_handling_0 | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tests/shell/testcases/cache/0001_cache_handling_0 b/tests/shell/testcases/cache/0001_cache_handling_0
index 9a73769..2bcb8c5 100755
--- a/tests/shell/testcases/cache/0001_cache_handling_0
+++ b/tests/shell/testcases/cache/0001_cache_handling_0
@@ -24,6 +24,7 @@ table inet test {
 set -e
 
 $NFT -f $tmpfile
-$NFT delete rule inet test test handle 2
+rule_handle=$($NFT list ruleset -a | grep "saddr" | awk '{print $NF}')
+$NFT delete rule inet test test handle $rule_handle
 $NFT delete set inet test test
 $NFT -f $tmpfile
-- 
2.11.0

