From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 4/4] build: use C++11 headers if available
Date: Mon, 28 Oct 2013 13:27:20 +0100
Message-ID: <1382963240-18760-5-git-send-email-jengelh@inai.de>
References: <1382963240-18760-1-git-send-email-jengelh@inai.de>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:34052 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756262Ab3J1M11 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Oct 2013 08:27:27 -0400
In-Reply-To: <1382963240-18760-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/libnftables/chain.h   | 6 +++++-
 include/libnftables/expr.h    | 6 +++++-
 include/libnftables/rule.h    | 6 +++++-
 include/libnftables/ruleset.h | 6 +++++-
 include/libnftables/set.h     | 6 +++++-
 include/libnftables/table.h   | 6 +++++-
 6 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/include/libnftables/chain.h b/include/libnftables/chain.h
index 13b037d..0e2035d 100644
--- a/include/libnftables/chain.h
+++ b/include/libnftables/chain.h
@@ -1,7 +1,11 @@
 #ifndef _CHAIN_H_
 #define _CHAIN_H_
 
-#include <stdint.h>
+#if defined(__cplusplus) && __cplusplus >= 201100L
+#	include <cstdint>
+#else
+#	include <stdint.h>
+#endif
 #ifndef __cplusplus
 #	include <stdbool.h>
 #endif
diff --git a/include/libnftables/expr.h b/include/libnftables/expr.h
index d5f13a6..0b16db3 100644
--- a/include/libnftables/expr.h
+++ b/include/libnftables/expr.h
@@ -1,7 +1,11 @@
 #ifndef _RULE_EXPR_H_
 #define _RULE_EXPR_H_
 
-#include <stdint.h>
+#if defined(__cplusplus) && __cplusplus >= 201100L
+#	include <cstdint>
+#else
+#	include <stdint.h>
+#endif
 #ifndef __cplusplus
 #	include <stdbool.h>
 #endif
diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
index cb71e49..915d4ea 100644
--- a/include/libnftables/rule.h
+++ b/include/libnftables/rule.h
@@ -1,7 +1,11 @@
 #ifndef _RULE_H_
 #define _RULE_H_
 
-#include <stdint.h>
+#if defined(__cplusplus) && __cplusplus >= 201100L
+#	include <cstdint>
+#else
+#	include <stdint.h>
+#endif
 #ifndef __cplusplus
 #	include <stdbool.h>
 #endif
diff --git a/include/libnftables/ruleset.h b/include/libnftables/ruleset.h
index 96ff425..0efc831 100644
--- a/include/libnftables/ruleset.h
+++ b/include/libnftables/ruleset.h
@@ -4,7 +4,11 @@
 #ifndef __cplusplus
 #	include <stdbool.h>
 #endif
-#include <stdint.h>
+#if defined(__cplusplus) && __cplusplus >= 201100L
+#	include <cstdint>
+#else
+#	include <stdint.h>
+#endif
 #include <sys/types.h>
 
 #ifdef __cplusplus
diff --git a/include/libnftables/set.h b/include/libnftables/set.h
index 92af85c..c9553b6 100644
--- a/include/libnftables/set.h
+++ b/include/libnftables/set.h
@@ -1,7 +1,11 @@
 #ifndef _NFT_SET_H_
 #define _NFT_SET_H_
 
-#include <stdint.h>
+#if defined(__cplusplus) && __cplusplus >= 201100L
+#	include <cstdint>
+#else
+#	include <stdint.h>
+#endif
 #ifndef __cplusplus
 #	include <stdbool.h>
 #endif
diff --git a/include/libnftables/table.h b/include/libnftables/table.h
index b91a457..ba05f5c 100644
--- a/include/libnftables/table.h
+++ b/include/libnftables/table.h
@@ -1,7 +1,11 @@
 #ifndef _TABLE_H_
 #define _TABLE_H_
 
-#include <stdint.h>
+#if defined(__cplusplus) && __cplusplus >= 201100L
+#	include <cstdint>
+#else
+#	include <stdint.h>
+#endif
 #ifndef __cplusplus
 #	include <stdbool.h>
 #endif
-- 
1.8.2

