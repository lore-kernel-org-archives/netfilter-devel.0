From: Eric Leblond <eric@regit.org>
Subject: [nft PATH 06/16] libnftables: add missing variable to library
Date: Wed, 16 Aug 2017 22:43:00 +0200
Message-ID: <20170816204310.3371-7-eric@regit.org>
References: <20170816204310.3371-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:40720 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752704AbdHPVZn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Aug 2017 17:25:43 -0400
In-Reply-To: <20170816204310.3371-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/libnftables.c | 2 ++
 src/main.c        | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index 6599248..6d4aceb 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -33,6 +33,8 @@ unsigned int handle_output;
 unsigned int debug_level;
 #endif
 
+const char *include_paths[INCLUDE_PATHS_MAX] = { DEFAULT_INCLUDE_PATH };
+
 void nft_global_init(void)
 {
 	mark_table_init();
diff --git a/src/main.c b/src/main.c
index 9b4e450..20fea87 100644
--- a/src/main.c
+++ b/src/main.c
@@ -34,7 +34,6 @@ unsigned int max_errors = 10;
 unsigned int debug_level;
 #endif
 
-const char *include_paths[INCLUDE_PATHS_MAX] = { DEFAULT_INCLUDE_PATH };
 static unsigned int num_include_paths = 1;
 
 enum opt_vals {
-- 
2.14.1

