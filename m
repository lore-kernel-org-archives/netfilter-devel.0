From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: xtables: consistent struct compat_xt_counters definition
Date: Sat, 6 Feb 2010 00:11:42 +0200
Message-ID: <20100205221142.GB27953@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:59948 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933863Ab0BEWLs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Feb 2010 17:11:48 -0500
Received: by fxm20 with SMTP id 20so4486370fxm.1
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Feb 2010 14:11:47 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There is compat_u64 type which deals with different u64 type alignment
on different compat-capable platforms, so use it and removed some
hardcoded assumptions.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/netfilter/x_tables.h |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -562,11 +562,7 @@ struct compat_xt_entry_target {
  * current task alignment */
 
 struct compat_xt_counters {
-#if defined(CONFIG_X86_64) || defined(CONFIG_IA64)
-	u_int32_t cnt[4];
-#else
-	u_int64_t cnt[2];
-#endif
+	compat_u64 pcnt, bcnt;			/* Packet and byte counters */
 };
 
 struct compat_xt_counters_info {
