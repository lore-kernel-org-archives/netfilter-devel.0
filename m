From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH iptables] xtables: Remove unused macro
Date: Mon, 27 Feb 2017 13:33:42 -0700
Message-ID: <1488227622-2623-1-git-send-email-subashab@codeaurora.org>
Cc: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48116 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751530AbdB0UpK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Feb 2017 15:45:10 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Minor change to remove the unused macro added as part of commit
e8f857a5a1514c3e7d0d8ea0f7d2d571f0e37bd1 ("xtables: Add an interval
option for xtables lock wait")

Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 iptables/xshared.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index cccb8ae..543d9be 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -17,7 +17,6 @@
 #include "xshared.h"
 
 #define XT_LOCK_NAME	"/run/xtables.lock"
-#define BASE_MICROSECONDS	100000
 
 /*
  * Print out any special helps. A user might like to be able to add a --help
-- 
1.9.1

