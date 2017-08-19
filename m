From: Eric Leblond <eric@regit.org>
Subject: [PATH nft v2 08/18] libnftables: add missing variables to library
Date: Sat, 19 Aug 2017 17:24:10 +0200
Message-ID: <20170819152420.22563-9-eric@regit.org>
References: <20170819152420.22563-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:33634 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751644AbdHSPYn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Aug 2017 11:24:43 -0400
In-Reply-To: <20170819152420.22563-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch also avoids double definition of global vars.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/libnftables.c | 2 ++
 src/main.c        | 6 ------
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index 446ec1e..28f9272 100644
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
index 9b4e450..7ab01b7 100644
--- a/src/main.c
+++ b/src/main.c
@@ -29,12 +29,6 @@
 #include <iface.h>
 #include <cli.h>
 
-unsigned int max_errors = 10;
-#ifdef DEBUG
-unsigned int debug_level;
-#endif
-
-const char *include_paths[INCLUDE_PATHS_MAX] = { DEFAULT_INCLUDE_PATH };
 static unsigned int num_include_paths = 1;
 
 enum opt_vals {
-- 
2.14.1

