From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 16/16] tests: shell: Add test case for map expression.
Date: Mon, 30 Oct 2017 02:19:31 +0530
Message-ID: <20171029204931.7792-16-rvarsha016@gmail.com>
References: <cover.1509305217.git.rvarsha016@gmail.com>
 <20171029204931.7792-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:53770 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752073AbdJ2UuX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Oct 2017 16:50:23 -0400
Received: by mail-pf0-f194.google.com with SMTP id t188so9217377pfd.10
        for <netfilter-devel@vger.kernel.org>; Sun, 29 Oct 2017 13:50:23 -0700 (PDT)
In-Reply-To: <20171029204931.7792-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add tests for different map expression.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 tests/shell/testcases/maps/different_map_types_1 | 10 ++++++++++
 1 file changed, 10 insertions(+)
 create mode 100755 tests/shell/testcases/maps/different_map_types_1

diff --git a/tests/shell/testcases/maps/different_map_types_1 b/tests/shell/testcases/maps/different_map_types_1
new file mode 100755
index 0000000..4d09163
--- /dev/null
+++ b/tests/shell/testcases/maps/different_map_types_1
@@ -0,0 +1,10 @@
+#!/bin/bash
+
+# must fail: expr MAP { expr : type1, expr : type2, .. } expr 
+
+set -e
+
+$NFT add table ip filter
+$NFT add chain ip filter output { type filter hook output priority 0 \; }
+$NFT add rule ip filter output meta mark set tcp dport map { 22 : 1, 23 : 192.168.0.1 }
+echo "E: Added two different types of expression to map"
-- 
2.13.6

