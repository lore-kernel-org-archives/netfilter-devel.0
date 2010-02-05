From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] xtables: symmetric COMPAT_XT_ALIGN definition
Date: Sat, 6 Feb 2010 00:13:31 +0200
Message-ID: <20100205221331.GC27953@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:32825 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933791Ab0BEWNm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Feb 2010 17:13:42 -0500
Received: by fxm20 with SMTP id 20so4488384fxm.1
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Feb 2010 14:13:41 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Rewrite COMPAT_XT_ALIGN in terms of dummy structure hack.
Compat counters logically have nothing to do with it.
Use ALIGN() macro while I'm at it for same types.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/netfilter/x_tables.h |   13 +++++++++----
 net/netfilter/x_tables.c           |    4 ++--
 2 files changed, 11 insertions(+), 6 deletions(-)

--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -93,8 +93,7 @@ struct _xt_align {
 	__u64 u64;
 };
 
-#define XT_ALIGN(s) (((s) + (__alignof__(struct _xt_align)-1)) 	\
-			& ~(__alignof__(struct _xt_align)-1))
+#define XT_ALIGN(s) ALIGN((s), __alignof__(struct _xt_align))
 
 /* Standard return verdict, or do jump. */
 #define XT_STANDARD_TARGET ""
@@ -571,8 +570,14 @@ struct compat_xt_counters_info {
 	struct compat_xt_counters counters[0];
 };
 
-#define COMPAT_XT_ALIGN(s) (((s) + (__alignof__(struct compat_xt_counters)-1)) \
-		& ~(__alignof__(struct compat_xt_counters)-1))
+struct _compat_xt_align {
+	__u8 u8;
+	__u16 u16;
+	__u32 u32;
+	compat_u64 u64;
+};
+
+#define COMPAT_XT_ALIGN(s) ALIGN((s), __alignof__(struct _compat_xt_align))
 
 extern void xt_compat_lock(u_int8_t af);
 extern void xt_compat_unlock(u_int8_t af);
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -364,7 +364,7 @@ int xt_check_match(struct xt_mtchk_param *par,
 		 * ebt_among is exempt from centralized matchsize checking
 		 * because it uses a dynamic-size data set.
 		 */
-		pr_err("%s_tables: %s match: invalid size %Zu != %u\n",
+		pr_err("%s_tables: %s match: invalid size %u != %u\n",
 		       xt_prefix[par->family], par->match->name,
 		       XT_ALIGN(par->match->matchsize), size);
 		return -EINVAL;
@@ -514,7 +514,7 @@ int xt_check_target(struct xt_tgchk_param *par,
 		    unsigned int size, u_int8_t proto, bool inv_proto)
 {
 	if (XT_ALIGN(par->target->targetsize) != size) {
-		pr_err("%s_tables: %s target: invalid size %Zu != %u\n",
+		pr_err("%s_tables: %s target: invalid size %u != %u\n",
 		       xt_prefix[par->family], par->target->name,
 		       XT_ALIGN(par->target->targetsize), size);
 		return -EINVAL;
