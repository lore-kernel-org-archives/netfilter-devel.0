From: Cong Wang <amwang@redhat.com>
Subject: Increasing XT_EXTENSION_MAXNAMELEN to 32
Date: Sat, 29 Sep 2012 23:53:49 +0800
Message-ID: <1348934029.10238.15.camel@cr0>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756172Ab2I2PyF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Sep 2012 11:54:05 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi, netfilter experts,

A customer wants to increase XT_EXTENSION_MAXNAMELEN to at least 31 (1
for '\0'), so I just increase it to 32. Do you have any comments or
objections for the following patch?

The vmlinux size increases by 768 bytes with my allyesconfig:

% size vmlinux
   text	   data	    bss	    dec	    hex	filename
15158877	3942208	11812864	30913949	1d7b59d	vmlinux
% size vmlinux.AFTER 
   text	   data	    bss	    dec	    hex	filename
15158877	3942976	11812864	30914717	1d7b89d	vmlinux.AFTER


I know probably the user-space part needs to update too, here is just
the kernel part patch for you to review. And I only did compile test.

Thanks!

---
diff --git a/include/linux/netfilter/x_tables.h
b/include/linux/netfilter/x_tables.h
index 8d674a7..24b4dd4 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -4,7 +4,7 @@
 #include <linux/types.h>
 
 #define XT_FUNCTION_MAXNAMELEN 30
-#define XT_EXTENSION_MAXNAMELEN 29
+#define XT_EXTENSION_MAXNAMELEN 32
 #define XT_TABLE_MAXNAMELEN 32
 
 struct xt_entry_match {


