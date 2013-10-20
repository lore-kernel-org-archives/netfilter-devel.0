From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 2/2] build: resolve build errors in dependent programs
Date: Sun, 20 Oct 2013 16:29:16 +0200
Message-ID: <1382279356-5050-3-git-send-email-jengelh@inai.de>
References: <1382279356-5050-1-git-send-email-jengelh@inai.de>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:38889 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045Ab3JTO3V (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Oct 2013 10:29:21 -0400
In-Reply-To: <1382279356-5050-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The headers do not compile standalone, which also causes nftables to
fail to build for the same reason. In addition, <stdbool.h> is not
needed for C++, and C++ should use contemporary headers if available,
which is hereby done.

	chain.h:44:71: warning: "struct nlmsghdr" declared inside
	parameter list [enabled by default]
	chain.h:60:35: error: unknown type name "size_t"
	expr.h:40:39: error: unknown type name "size_t"
	rule.h:43:64: warning: "struct nlmsghdr" declared inside
	parameter list [enabled by default]
	rule.h:59:34: error: unknown type name "size_t"
	ruleset.h:20:1: error: unknown type name "bool"
	ruleset.h:20:59: error: unknown type name "uint16_t"
	ruleset.h:39:37: error: unknown type name "size_t"
	set.h:38:33: error: unknown type name "size_t"
	table.h:32:71: warning: "struct nlmsghdr" declared inside
	parameter list [enabled by default]
	table.h:48:35: error: unknown type name "size_t"

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/libnftables/chain.h   | 10 ++++++++--
 include/libnftables/expr.h    | 10 ++++++++--
 include/libnftables/rule.h    | 10 ++++++++--
 include/libnftables/ruleset.h |  8 ++++++++
 include/libnftables/set.h     | 10 ++++++++--
 include/libnftables/table.h   | 10 ++++++++--
 6 files changed, 48 insertions(+), 10 deletions(-)

diff --git a/include/libnftables/chain.h b/include/libnftables/chain.h
index d3086ea..36522d6 100644
--- a/include/libnftables/chain.h
+++ b/include/libnftables/chain.h
@@ -1,14 +1,20 @@
 #ifndef _CHAIN_H_
 #define _CHAIN_H_
 
-#include <stdint.h>
-#include <stdbool.h>
+#if defined(__cplusplus) && __cplusplus >= 201100L
+#	include <cstdint>
+#else
+#	include <stdbool.h>
+#	include <stdint.h>
+#endif
+#include <sys/types.h>
 
 #ifdef __cplusplus
 extern "C" {
 #endif
 
 struct nft_chain;
+struct nlmsghdr;
 
 struct nft_chain *nft_chain_alloc(void);
 void nft_chain_free(struct nft_chain *);
diff --git a/include/libnftables/expr.h b/include/libnftables/expr.h
index b8f1d1e..4c640f7 100644
--- a/include/libnftables/expr.h
+++ b/include/libnftables/expr.h
@@ -1,14 +1,20 @@
 #ifndef _RULE_EXPR_H_
 #define _RULE_EXPR_H_
 
-#include <stdint.h>
-#include <stdbool.h>
+#if defined(__cplusplus) && __cplusplus >= 201100L
+#	include <cstdint>
+#else
+#	include <stdbool.h>
+#	include <stdint.h>
+#endif
+#include <sys/types.h>
 
 #ifdef __cplusplus
 extern "C" {
 #endif
 
 struct nft_rule_expr;
+struct nlmsghdr;
 
 enum {
 	NFT_RULE_EXPR_ATTR_NAME = 0,
diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
index 9fba9c8..5876a98 100644
--- a/include/libnftables/rule.h
+++ b/include/libnftables/rule.h
@@ -1,8 +1,13 @@
 #ifndef _RULE_H_
 #define _RULE_H_
 
-#include <stdint.h>
-#include <stdbool.h>
+#if defined(__cplusplus) && __cplusplus >= 201100L
+#	include <cstdint>
+#else
+#	include <stdbool.h>
+#	include <stdint.h>
+#endif
+#include <sys/types.h>
 
 #ifdef __cplusplus
 extern "C" {
@@ -10,6 +15,7 @@ extern "C" {
 
 struct nft_rule;
 struct nft_rule_expr;
+struct nlmsghdr;
 
 struct nft_rule *nft_rule_alloc(void);
 void nft_rule_free(struct nft_rule *);
diff --git a/include/libnftables/ruleset.h b/include/libnftables/ruleset.h
index a4a1279..cde75b1 100644
--- a/include/libnftables/ruleset.h
+++ b/include/libnftables/ruleset.h
@@ -1,6 +1,14 @@
 #ifndef _RULESET_H_
 #define _RULESET_H_
 
+#if defined(__cplusplus) && __cplusplus >= 201100L
+#	include <cstdint>
+#else
+#	include <stdbool.h>
+#	include <stdint.h>
+#endif
+#include <sys/types.h>
+
 #ifdef __cplusplus
 extern "C" {
 #endif
diff --git a/include/libnftables/set.h b/include/libnftables/set.h
index e377826..a25742b 100644
--- a/include/libnftables/set.h
+++ b/include/libnftables/set.h
@@ -1,8 +1,13 @@
 #ifndef _NFT_SET_H_
 #define _NFT_SET_H_
 
-#include <stdint.h>
-#include <stdbool.h>
+#if defined(__cplusplus) && __cplusplus >= 201100L
+#	include <cstdint>
+#else
+#	include <stdbool.h>
+#	include <stdint.h>
+#endif
+#include <sys/types.h>
 
 enum {
 	NFT_SET_ATTR_TABLE,
@@ -16,6 +21,7 @@ enum {
 };
 
 struct nft_set;
+struct nlmsghdr;
 
 struct nft_set *nft_set_alloc(void);
 void nft_set_free(struct nft_set *s);
diff --git a/include/libnftables/table.h b/include/libnftables/table.h
index 66574cf..815b6a7 100644
--- a/include/libnftables/table.h
+++ b/include/libnftables/table.h
@@ -1,14 +1,20 @@
 #ifndef _TABLE_H_
 #define _TABLE_H_
 
-#include <stdint.h>
-#include <stdbool.h>
+#if defined(__cplusplus) && __cplusplus >= 201100L
+#	include <cstdint>
+#else
+#	include <stdbool.h>
+#	include <stdint.h>
+#endif
+#include <sys/types.h>
 
 #ifdef __cplusplus
 extern "C" {
 #endif
 
 struct nft_table;
+struct nlmsghdr;
 
 struct nft_table *nft_table_alloc(void);
 void nft_table_free(struct nft_table *);
-- 
1.8.2

