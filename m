From: Eric Leblond <eric@regit.org>
Subject: [nft PATCH 1/3] regression: fix typo in README
Date: Thu, 26 Feb 2015 00:51:08 +0100
Message-ID: <1424908270-554-2-git-send-email-eric@regit.org>
References: <1424908270-554-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:42927 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbbBZATw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Feb 2015 19:19:52 -0500
In-Reply-To: <1424908270-554-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Eric Leblond <eric@regit.org>
---
 tests/regression/README | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/regression/README b/tests/regression/README
index 7b66d22..82d73a2 100644
--- a/tests/regression/README
+++ b/tests/regression/README
@@ -112,7 +112,7 @@ bridge and any.
  * "ip" folder contains the test files that are executed in ip and inet
    table.
 
- * "ip" folder contains the test files that are executed in ip6 and inet
+ * "ip6" folder contains the test files that are executed in ip6 and inet
    table.
 
  * "inet" folder contains the test files that are executed in the ip, ip6
-- 
2.1.4

