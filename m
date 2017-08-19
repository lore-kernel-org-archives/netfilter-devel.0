From: Eric Leblond <eric@regit.org>
Subject: [PATH nft v2 17/18] libnftables: suppress unused global variables
Date: Sat, 19 Aug 2017 17:24:19 +0200
Message-ID: <20170819152420.22563-18-eric@regit.org>
References: <20170819152420.22563-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:33756 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751591AbdHSPca (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Aug 2017 11:32:30 -0400
In-Reply-To: <20170819152420.22563-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/libnftables.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index b1df916..1abe077 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -26,9 +26,6 @@
 
 
 unsigned int max_errors = 1;
-unsigned int numeric_output;
-unsigned int ip2name_output;
-unsigned int handle_output;
 #ifdef DEBUG
 unsigned int debug_level;
 #endif
-- 
2.14.1

