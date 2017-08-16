From: Eric Leblond <eric@regit.org>
Subject: [nft PATH 13/16] libnftables: set max_errors to 1 in library
Date: Wed, 16 Aug 2017 22:43:07 +0200
Message-ID: <20170816204310.3371-14-eric@regit.org>
References: <20170816204310.3371-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:40694 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752659AbdHPVZd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Aug 2017 17:25:33 -0400
In-Reply-To: <20170816204310.3371-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As memory handling is defficient if we don't do so, we can't really
use a non 1 value for the parameter in the library due to memory
leak.

Also this is not a real issue as programmatically a user of the
library should only encounter one error at a time.

This patch also introduces a function that can be used to modify
the max_errors parameter. It is used in main to keep the existing
behavior.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/nftables/nftables.h | 1 +
 src/libnftables.c           | 8 +++++++-
 src/main.c                  | 1 +
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
index 2ddb38a..f419884 100644
--- a/include/nftables/nftables.h
+++ b/include/nftables/nftables.h
@@ -22,6 +22,7 @@ enum nftables_exit_codes {
 };
 
 void nft_global_init(void);
+int nft_global_set_max_errors(unsigned int errors);
 void nft_global_deinit(void);
 
 struct nft_ctx *nft_context_new(void);
diff --git a/src/libnftables.c b/src/libnftables.c
index 08050e5..c50c068 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -25,7 +25,7 @@
 #include <fcntl.h>
 
 
-unsigned int max_errors = 10;
+unsigned int max_errors = 1;
 unsigned int numeric_output;
 unsigned int ip2name_output;
 unsigned int handle_output;
@@ -58,6 +58,12 @@ void nft_global_deinit(void)
 	mark_table_exit();
 }
 
+int nft_global_set_max_errors(unsigned int errors)
+{
+	max_errors = errors;
+	return 0;
+}
+
 __attribute__((format(printf, 2, 0)))
 static int nft_print(void *ctx, const char *fmt, ...)
 {
diff --git a/src/main.c b/src/main.c
index a6305cc..bb08c31 100644
--- a/src/main.c
+++ b/src/main.c
@@ -192,6 +192,7 @@ int main(int argc, char * const *argv)
 	struct nft_ctx *nft;
 
 	nft_global_init();
+	nft_global_set_max_errors(10);
 	nft = nft_context_new();
 	while (1) {
 		val = getopt_long(argc, argv, OPTSTRING, options, NULL);
-- 
2.14.1

