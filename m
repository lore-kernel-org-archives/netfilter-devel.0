From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 3/4] build: avoid inclusion of stdbool.h in C++
Date: Mon, 28 Oct 2013 13:27:19 +0100
Message-ID: <1382963240-18760-4-git-send-email-jengelh@inai.de>
References: <1382963240-18760-1-git-send-email-jengelh@inai.de>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:34050 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756247Ab3J1M11 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Oct 2013 08:27:27 -0400
In-Reply-To: <1382963240-18760-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

C++ does not need this header, as it already has bool builtin.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/libnftables/chain.h   | 4 +++-
 include/libnftables/expr.h    | 4 +++-
 include/libnftables/rule.h    | 4 +++-
 include/libnftables/ruleset.h | 4 +++-
 include/libnftables/set.h     | 4 +++-
 include/libnftables/table.h   | 4 +++-
 6 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/include/libnftables/chain.h b/include/libnftables/chain.h
index d3ba75b..13b037d 100644
--- a/include/libnftables/chain.h
+++ b/include/libnftables/chain.h
@@ -2,7 +2,9 @@
 #define _CHAIN_H_
 
 #include <stdint.h>
-#include <stdbool.h>
+#ifndef __cplusplus
+#	include <stdbool.h>
+#endif
 #include <sys/types.h>
 
 #ifdef __cplusplus
diff --git a/include/libnftables/expr.h b/include/libnftables/expr.h
index 81e224c..d5f13a6 100644
--- a/include/libnftables/expr.h
+++ b/include/libnftables/expr.h
@@ -2,7 +2,9 @@
 #define _RULE_EXPR_H_
 
 #include <stdint.h>
-#include <stdbool.h>
+#ifndef __cplusplus
+#	include <stdbool.h>
+#endif
 #include <sys/types.h>
 
 #ifdef __cplusplus
diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
index 5b5263a..cb71e49 100644
--- a/include/libnftables/rule.h
+++ b/include/libnftables/rule.h
@@ -2,7 +2,9 @@
 #define _RULE_H_
 
 #include <stdint.h>
-#include <stdbool.h>
+#ifndef __cplusplus
+#	include <stdbool.h>
+#endif
 #include <sys/types.h>
 
 #ifdef __cplusplus
diff --git a/include/libnftables/ruleset.h b/include/libnftables/ruleset.h
index 49f7c4e..96ff425 100644
--- a/include/libnftables/ruleset.h
+++ b/include/libnftables/ruleset.h
@@ -1,7 +1,9 @@
 #ifndef _RULESET_H_
 #define _RULESET_H_
 
-#include <stdbool.h>
+#ifndef __cplusplus
+#	include <stdbool.h>
+#endif
 #include <stdint.h>
 #include <sys/types.h>
 
diff --git a/include/libnftables/set.h b/include/libnftables/set.h
index 1bd7670..92af85c 100644
--- a/include/libnftables/set.h
+++ b/include/libnftables/set.h
@@ -2,7 +2,9 @@
 #define _NFT_SET_H_
 
 #include <stdint.h>
-#include <stdbool.h>
+#ifndef __cplusplus
+#	include <stdbool.h>
+#endif
 #include <sys/types.h>
 
 enum {
diff --git a/include/libnftables/table.h b/include/libnftables/table.h
index 86978e1..b91a457 100644
--- a/include/libnftables/table.h
+++ b/include/libnftables/table.h
@@ -2,7 +2,9 @@
 #define _TABLE_H_
 
 #include <stdint.h>
-#include <stdbool.h>
+#ifndef __cplusplus
+#	include <stdbool.h>
+#endif
 #include <sys/types.h>
 
 #ifdef __cplusplus
-- 
1.8.2

