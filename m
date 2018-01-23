From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH v2] tests: shell: fetch rule handle with '-a' option and then delete rule
Date: Wed, 24 Jan 2018 05:16:01 +0530
Message-ID: <20180123234601.7841-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, harshasharmaiitr@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:42433 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752564AbeAWXqW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jan 2018 18:46:22 -0500
Received: by mail-pf0-f193.google.com with SMTP id b25so1578725pfd.9
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2018 15:46:22 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fetch rule handle and then delete rule via that rule handle.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
Changes in v2:
 - No need to use grep

 tests/shell/testcases/cache/0001_cache_handling_0 | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tests/shell/testcases/cache/0001_cache_handling_0 b/tests/shell/testcases/cache/0001_cache_handling_0
index 9a73769..3693f15 100755
--- a/tests/shell/testcases/cache/0001_cache_handling_0
+++ b/tests/shell/testcases/cache/0001_cache_handling_0
@@ -24,6 +24,7 @@ table inet test {
 set -e
 
 $NFT -f $tmpfile
-$NFT delete rule inet test test handle 2
+rule_handle=$($NFT list ruleset -a | awk '/saddr/{print $NF}')
+$NFT delete rule inet test test handle $rule_handle
 $NFT delete set inet test test
 $NFT -f $tmpfile
-- 
2.11.0

