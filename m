Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8E68EE14B3
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 16:56:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237118AbjIFQ4t (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 12:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241497AbjIFQ4t (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 12:56:49 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C9519B1
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 09:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=J7bxh+sM8aRYS6ppjZchPgVZbZ+D3rgABx7Wbxizv9Q=; b=hKqgn8ZGTgKvJS7xgzE4iT46i1
        vNXl63+LhIQo4xAGPrcQZ/tsq9cjyWBjqQybkqs9ssKWA2LCmLO7Yx9FcS/G3MqYsJVHPkuXZS+f7
        NX4GPlw0/iRGGFxVgMeblHldGtzv9yykz3lfhE+wz1L7Dluc2W8pdSen12tKaOPLnk/Ya9KXLz563
        v3E5PykgacnFZ1S+6qCOuyYBlLoe0jnbkom2HPK8MaeI6Vsi4c3aGTdZXtZ1loEPgNCwKfFuqvvEa
        YHfeHVWX6EbZ8lQWer5VP40Oc8jTa2V3wZJcmvX0BvsjAGllaCAxbLWyxjkbr4Y4fdP5CEEeQ9fMy
        BQCxAZ4w==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qdvpU-00088C-0G
        for netfilter-devel@vger.kernel.org; Wed, 06 Sep 2023 18:56:36 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] include: linux: Update kernel.h
Date:   Wed,  6 Sep 2023 19:08:07 +0200
Message-ID: <20230906170807.23100-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Its contents were moved into const.h and sysinfo.h, apply these changes
to the cached copies. Fixes for the following warning when compiling
xtables-monitor.c with new kernel headers in /usr/include:

| In file included from ../include/linux/netfilter/x_tables.h:3,
|                  from ../include/xtables.h:19,
|                  from xtables-monitor.c:36:
| ../include/linux/kernel.h:7: warning: "__ALIGN_KERNEL" redefined
|     7 | #define __ALIGN_KERNEL(x, a)            __ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
|       |
| In file included from /usr/include/linux/netlink.h:5,
|                  from /home/n0-1/git/libmnl/install/include/libmnl/libmnl.h:9,
|                  from xtables-monitor.c:30:
| /usr/include/linux/const.h:31: note: this is the location of the previous definition
|    31 | #define __ALIGN_KERNEL(x, a)            __ALIGN_KERNEL_MASK(x, (__typeof__(x))(a) - 1)
|       |

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/linux/const.h   | 36 ++++++++++++++++++++++++++++++++++++
 include/linux/kernel.h  | 29 ++++-------------------------
 include/linux/sysinfo.h | 25 +++++++++++++++++++++++++
 3 files changed, 65 insertions(+), 25 deletions(-)
 create mode 100644 include/linux/const.h
 create mode 100644 include/linux/sysinfo.h

diff --git a/include/linux/const.h b/include/linux/const.h
new file mode 100644
index 0000000000000..1eb84b5087f8a
--- /dev/null
+++ b/include/linux/const.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/* const.h: Macros for dealing with constants.  */
+
+#ifndef _LINUX_CONST_H
+#define _LINUX_CONST_H
+
+/* Some constant macros are used in both assembler and
+ * C code.  Therefore we cannot annotate them always with
+ * 'UL' and other type specifiers unilaterally.  We
+ * use the following macros to deal with this.
+ *
+ * Similarly, _AT() will cast an expression with a type in C, but
+ * leave it unchanged in asm.
+ */
+
+#ifdef __ASSEMBLY__
+#define _AC(X,Y)	X
+#define _AT(T,X)	X
+#else
+#define __AC(X,Y)	(X##Y)
+#define _AC(X,Y)	__AC(X,Y)
+#define _AT(T,X)	((T)(X))
+#endif
+
+#define _UL(x)		(_AC(x, UL))
+#define _ULL(x)		(_AC(x, ULL))
+
+#define _BITUL(x)	(_UL(1) << (x))
+#define _BITULL(x)	(_ULL(1) << (x))
+
+#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (__typeof__(x))(a) - 1)
+#define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
+
+#define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
+
+#endif /* _LINUX_CONST_H */
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index d4c59f6557d35..5413a8c50bfe4 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -1,29 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 #ifndef _LINUX_KERNEL_H
 #define _LINUX_KERNEL_H
 
-/*
- * 'kernel.h' contains some often-used function prototypes etc
- */
-#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
-#define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
+#include <linux/sysinfo.h>
+#include <linux/const.h>
 
-
-#define SI_LOAD_SHIFT	16
-struct sysinfo {
-	long uptime;			/* Seconds since boot */
-	unsigned long loads[3];		/* 1, 5, and 15 minute load averages */
-	unsigned long totalram;		/* Total usable main memory size */
-	unsigned long freeram;		/* Available memory size */
-	unsigned long sharedram;	/* Amount of shared memory */
-	unsigned long bufferram;	/* Memory used by buffers */
-	unsigned long totalswap;	/* Total swap space size */
-	unsigned long freeswap;		/* swap space still available */
-	unsigned short procs;		/* Number of current processes */
-	unsigned short pad;		/* explicit padding for m68k */
-	unsigned long totalhigh;	/* Total high memory size */
-	unsigned long freehigh;		/* Available high memory size */
-	unsigned int mem_unit;		/* Memory unit size in bytes */
-	char _f[20-2*sizeof(long)-sizeof(int)];	/* Padding: libc5 uses this.. */
-};
-
-#endif
+#endif /* _LINUX_KERNEL_H */
diff --git a/include/linux/sysinfo.h b/include/linux/sysinfo.h
new file mode 100644
index 0000000000000..435d5c23f0c0e
--- /dev/null
+++ b/include/linux/sysinfo.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _LINUX_SYSINFO_H
+#define _LINUX_SYSINFO_H
+
+#include <linux/types.h>
+
+#define SI_LOAD_SHIFT	16
+struct sysinfo {
+	__kernel_long_t uptime;		/* Seconds since boot */
+	__kernel_ulong_t loads[3];	/* 1, 5, and 15 minute load averages */
+	__kernel_ulong_t totalram;	/* Total usable main memory size */
+	__kernel_ulong_t freeram;	/* Available memory size */
+	__kernel_ulong_t sharedram;	/* Amount of shared memory */
+	__kernel_ulong_t bufferram;	/* Memory used by buffers */
+	__kernel_ulong_t totalswap;	/* Total swap space size */
+	__kernel_ulong_t freeswap;	/* swap space still available */
+	__u16 procs;		   	/* Number of current processes */
+	__u16 pad;		   	/* Explicit padding for m68k */
+	__kernel_ulong_t totalhigh;	/* Total high memory size */
+	__kernel_ulong_t freehigh;	/* Available high memory size */
+	__u32 mem_unit;			/* Memory unit size in bytes */
+	char _f[20-2*sizeof(__kernel_ulong_t)-sizeof(__u32)];	/* Padding: libc5 uses this.. */
+};
+
+#endif /* _LINUX_SYSINFO_H */
-- 
2.41.0

