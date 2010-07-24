From: Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH iptables] libxt_length: update to revision 1
Date: Sat, 24 Jul 2010 12:29:06 +0800
Message-ID: <1279945746-24034-1-git-send-email-xiaosuo@gmail.com>
Cc: netfilter-devel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48140 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab0GXEaT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Jul 2010 00:30:19 -0400
Received: by pvc7 with SMTP id 7so3781534pvc.19
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Jul 2010 21:30:18 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

update libxt_length to revision 1 to support ipv6 jumbo frames.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 extensions/libxt_length.c           |    1 +
 include/linux/netfilter/xt_length.h |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)
diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
index 96e8b6c..5d0f5e9 100644
--- a/extensions/libxt_length.c
+++ b/extensions/libxt_length.c
@@ -125,6 +125,7 @@ static struct xtables_match length_match = {
 	.print		= length_print,
 	.save		= length_save,
 	.extra_opts	= length_opts,
+	.revision	= 1,
 };
 
 void _init(void)
diff --git a/include/linux/netfilter/xt_length.h b/include/linux/netfilter/xt_length.h
index b82ed7c..a12785c 100644
--- a/include/linux/netfilter/xt_length.h
+++ b/include/linux/netfilter/xt_length.h
@@ -4,7 +4,7 @@
 #include <linux/types.h>
 
 struct xt_length_info {
-    __u16	min, max;
+    __u32	min, max;
     __u8	invert;
 };
 
