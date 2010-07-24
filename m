From: Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH iptables v2] libxt_length: update to revision 1
Date: Sat, 24 Jul 2010 14:42:42 +0800
Message-ID: <1279953762-24124-1-git-send-email-xiaosuo@gmail.com>
Cc: netfilter-devel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:51566 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab0GXGm5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Jul 2010 02:42:57 -0400
Received: by pxi14 with SMTP id 14so3942814pxi.19
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Jul 2010 23:42:57 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

update libxt_length to revision 1 to support ipv6 jumbo frames.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 extensions/libxt_length.c           |    5 +++--
 include/linux/netfilter/xt_length.h |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)
diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
index 96e8b6c..d46eb50 100644
--- a/extensions/libxt_length.c
+++ b/extensions/libxt_length.c
@@ -21,7 +21,7 @@ static const struct option length_opts[] = {
 	{ .name = NULL }
 };
 
-static u_int16_t
+static u_int32_t
 parse_length(const char *s)
 {
 	unsigned int len;
@@ -47,7 +47,7 @@ parse_lengths(const char *s, struct xt_length_info *info)
 		cp++;
 
 		info->min = buffer[0] ? parse_length(buffer) : 0;
-		info->max = cp[0] ? parse_length(cp) : 0xFFFF;
+		info->max = cp[0] ? parse_length(cp) : 0xFFFFFFFF;
 	}
 	free(buffer);
 	
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
 
