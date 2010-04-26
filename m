From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/2] netfilter: rectify XT_FUNCTION_MAXNAMELEN usage
Date: Mon, 26 Apr 2010 14:47:33 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004261447250.28260@obet.zrqbmnf.qr>
References: <1271856071-32179-1-git-send-email-jengelh@medozas.de> <1271856071-32179-3-git-send-email-jengelh@medozas.de> <4BD02998.707@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36746 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab0DZMre (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Apr 2010 08:47:34 -0400
In-Reply-To: <4BD02998.707@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-04-22 12:48, Patrick McHardy wrote:

>Jan Engelhardt wrote:
>> There has been quite a confusion in userspace about
>> XT_FUNCTION_MAXNAMELEN. Change it to match the definition of
>> XT_TABLE_MAXNAMELEN - being the size of the actual struct member.
>
>iptables userspace uses XT_FUNCTION_MAXNAMELEN - 1 for checking
>the length of names. Changing the definition now will change
>the behaviour of userspace code.
>
>If you want to clean this up, I'd suggest to introduce a new
>define and use that.

parent 7067c52d1a6537f9ad7ab3f3f3c782058e54d389 (v2.6.34-rc3-1398-g7067c52)
commit d3912288924fa136b08656edaa8af41d87b070b0
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Apr 22 14:47:57 2010 +0200

netfilter: x_tables: rectify XT_FUNCTION_MAXNAMELEN usage

There has been quite a confusion in userspace about
XT_FUNCTION_MAXNAMELEN; because struct xt_entry_match used MAX-1,
userspace would have to do an awkward MAX-2 for maximum length
checking (due to '\0'). This patch adds a new define that matches the
definition of XT_TABLE_MAXNAMELEN - being the size of the actual
struct member, not one off.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index adeb2a9..7f30e41 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -4,6 +4,7 @@
 #include <linux/types.h>
 
 #define XT_FUNCTION_MAXNAMELEN 30
+#define XT_EXTENSION_MAXNAMELEN 29
 #define XT_TABLE_MAXNAMELEN 32
 
 struct xt_entry_match {
@@ -12,8 +13,7 @@ struct xt_entry_match {
 			__u16 match_size;
 
 			/* Used by userspace */
-			char name[XT_FUNCTION_MAXNAMELEN-1];
-
+			char name[XT_EXTENSION_MAXNAMELEN];
 			__u8 revision;
 		} user;
 		struct {
@@ -36,8 +36,7 @@ struct xt_entry_target {
 			__u16 target_size;
 
 			/* Used by userspace */
-			char name[XT_FUNCTION_MAXNAMELEN-1];
-
+			char name[XT_EXTENSION_MAXNAMELEN];
 			__u8 revision;
 		} user;
 		struct {
@@ -70,8 +69,7 @@ struct xt_standard_target {
 /* The argument to IPT_SO_GET_REVISION_*.  Returns highest revision
  * kernel supports, if >= revision. */
 struct xt_get_revision {
-	char name[XT_FUNCTION_MAXNAMELEN-1];
-
+	char name[XT_EXTENSION_MAXNAMELEN];
 	__u8 revision;
 };
 
@@ -291,7 +289,7 @@ struct xt_tgdtor_param {
 struct xt_match {
 	struct list_head list;
 
-	const char name[XT_FUNCTION_MAXNAMELEN-1];
+	const char name[XT_EXTENSION_MAXNAMELEN];
 	u_int8_t revision;
 
 	/* Return true or false: return FALSE and set *hotdrop = 1 to
@@ -330,7 +328,7 @@ struct xt_match {
 struct xt_target {
 	struct list_head list;
 
-	const char name[XT_FUNCTION_MAXNAMELEN-1];
+	const char name[XT_EXTENSION_MAXNAMELEN];
 	u_int8_t revision;
 
 	/* Returns verdict. Argument order changed since 2.6.9, as this
-- 
# Created with git-export-patch
