From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/2] netfilter: rectify XT_FUNCTION_MAXNAMELEN usage
Date: Wed, 21 Apr 2010 15:21:10 +0200
Message-ID: <1271856071-32179-3-git-send-email-jengelh@medozas.de>
References: <1271856071-32179-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58573 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515Ab0DUNVP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Apr 2010 09:21:15 -0400
In-Reply-To: <1271856071-32179-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There has been quite a confusion in userspace about
XT_FUNCTION_MAXNAMELEN. Change it to match the definition of
XT_TABLE_MAXNAMELEN - being the size of the actual struct member.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 50c8672..1733b35 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -3,7 +3,7 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 
-#define XT_FUNCTION_MAXNAMELEN 30
+#define XT_FUNCTION_MAXNAMELEN 29
 #define XT_TABLE_MAXNAMELEN 32
 
 struct xt_entry_match {
@@ -12,8 +12,7 @@ struct xt_entry_match {
 			__u16 match_size;
 
 			/* Used by userspace */
-			char name[XT_FUNCTION_MAXNAMELEN-1];
-
+			char name[XT_FUNCTION_MAXNAMELEN];
 			__u8 revision;
 		} user;
 		struct {
@@ -36,8 +35,7 @@ struct xt_entry_target {
 			__u16 target_size;
 
 			/* Used by userspace */
-			char name[XT_FUNCTION_MAXNAMELEN-1];
-
+			char name[XT_FUNCTION_MAXNAMELEN];
 			__u8 revision;
 		} user;
 		struct {
@@ -70,8 +68,7 @@ struct xt_standard_target {
 /* The argument to IPT_SO_GET_REVISION_*.  Returns highest revision
  * kernel supports, if >= revision. */
 struct xt_get_revision {
-	char name[XT_FUNCTION_MAXNAMELEN-1];
-
+	char name[XT_FUNCTION_MAXNAMELEN];
 	__u8 revision;
 };
 
@@ -291,7 +288,7 @@ struct xt_tgdtor_param {
 struct xt_match {
 	struct list_head list;
 
-	const char name[XT_FUNCTION_MAXNAMELEN-1];
+	const char name[XT_FUNCTION_MAXNAMELEN];
 	u_int8_t revision;
 
 	/* Return true or false: return FALSE and set *hotdrop = 1 to
@@ -330,7 +327,7 @@ struct xt_match {
 struct xt_target {
 	struct list_head list;
 
-	const char name[XT_FUNCTION_MAXNAMELEN-1];
+	const char name[XT_FUNCTION_MAXNAMELEN];
 	u_int8_t revision;
 
 	/* Returns verdict. Argument order changed since 2.6.9, as this
@@ -561,7 +558,7 @@ struct compat_xt_entry_match {
 	union {
 		struct {
 			u_int16_t match_size;
-			char name[XT_FUNCTION_MAXNAMELEN - 1];
+			char name[XT_FUNCTION_MAXNAMELEN];
 			u_int8_t revision;
 		} user;
 		struct {
@@ -577,7 +574,7 @@ struct compat_xt_entry_target {
 	union {
 		struct {
 			u_int16_t target_size;
-			char name[XT_FUNCTION_MAXNAMELEN - 1];
+			char name[XT_FUNCTION_MAXNAMELEN];
 			u_int8_t revision;
 		} user;
 		struct {
-- 
1.7.0.5

