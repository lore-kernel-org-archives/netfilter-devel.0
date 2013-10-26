From: Kevin Cernekee <cernekee@gmail.com>
Subject: [PATCH iptables 2/3] android: Don't include conflicting headers
Date: Sat, 26 Oct 2013 11:50:32 -0700
Message-ID: <1382813433-20890-3-git-send-email-cernekee@gmail.com>
References: <1382813433-20890-1-git-send-email-cernekee@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:62828 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab3JZSus (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Oct 2013 14:50:48 -0400
Received: by mail-pa0-f45.google.com with SMTP id kp14so5158438pab.4
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2013 11:50:47 -0700 (PDT)
In-Reply-To: <1382813433-20890-1-git-send-email-cernekee@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

<netinet/ip.h> and <linux/ip.h> redefine a couple of structs, including
iphdr.  Handle this the same way as on glibc, i.e. don't include
<linux/ip.h>.

This change comes from AOSP.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 include/libiptc/ipt_kernel_headers.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/libiptc/ipt_kernel_headers.h b/include/libiptc/ipt_kernel_headers.h
index 18861fe..60c7998 100644
--- a/include/libiptc/ipt_kernel_headers.h
+++ b/include/libiptc/ipt_kernel_headers.h
@@ -5,7 +5,7 @@
 
 #include <limits.h>
 
-#if defined(__GLIBC__) && __GLIBC__ == 2
+#if defined(__ANDROID__) || (defined(__GLIBC__) && __GLIBC__ == 2)
 #include <netinet/ip.h>
 #include <netinet/in.h>
 #include <netinet/ip_icmp.h>
-- 
1.7.9.5

