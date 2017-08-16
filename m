From: Eric Leblond <eric@regit.org>
Subject: [nft PATH 07/16] libnftables: add NFT_EXIT_* to library
Date: Wed, 16 Aug 2017 22:43:01 +0200
Message-ID: <20170816204310.3371-8-eric@regit.org>
References: <20170816204310.3371-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:40706 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752726AbdHPVZg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Aug 2017 17:25:36 -0400
In-Reply-To: <20170816204310.3371-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

So it can be used by client to check function return.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/nftables.h          | 7 -------
 include/nftables/nftables.h | 7 +++++++
 src/netlink.c               | 1 +
 src/utils.c                 | 1 +
 4 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index c2bb7d8..aad204e 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -48,13 +48,6 @@ extern unsigned int max_errors;
 extern unsigned int debug_level;
 extern const char *include_paths[INCLUDE_PATHS_MAX];
 
-enum nftables_exit_codes {
-	NFT_EXIT_SUCCESS	= 0,
-	NFT_EXIT_FAILURE	= 1,
-	NFT_EXIT_NOMEM		= 2,
-	NFT_EXIT_NONL		= 3,
-};
-
 struct input_descriptor;
 struct location {
 	const struct input_descriptor		*indesc;
diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
index 980c6ec..20a062c 100644
--- a/include/nftables/nftables.h
+++ b/include/nftables/nftables.h
@@ -14,6 +14,13 @@
 #include <stdint.h>
 #include <stdbool.h>
 
+enum nftables_exit_codes {
+	NFT_EXIT_SUCCESS	= 0,
+	NFT_EXIT_FAILURE	= 1,
+	NFT_EXIT_NOMEM		= 2,
+	NFT_EXIT_NONL		= 3,
+};
+
 void nft_global_init(void);
 void nft_global_deinit(void);
 
diff --git a/src/netlink.c b/src/netlink.c
index 7311149..ea5d9b1 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -30,6 +30,7 @@
 #include <linux/netfilter.h>
 
 #include <nftables.h>
+#include <nftables/nftables.h>
 #include <netlink.h>
 #include <mnl.h>
 #include <expression.h>
diff --git a/src/utils.c b/src/utils.c
index 47f5b79..aace563 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -16,6 +16,7 @@
 #include <string.h>
 
 #include <nftables.h>
+#include <nftables/nftables.h>
 #include <utils.h>
 
 void __noreturn __memory_allocation_error(const char *filename, uint32_t line)
-- 
2.14.1

