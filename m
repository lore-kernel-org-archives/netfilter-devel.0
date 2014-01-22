From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] include: add cached copy of linux/kernel.h
Date: Wed, 22 Jan 2014 13:15:21 +0100
Message-ID: <1390392921-6779-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59369 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755304AbaAVMPb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jan 2014 07:15:31 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This fixes the following compilation warning when using old installed
kernel headers (2.6.32).

  CC     expr/target.lo
expr/target.c: In function =E2=80=98nft_rule_expr_target_build=E2=80=99=
:
expr/target.c:127: warning: implicit declaration of function =E2=80=98_=
_ALIGN_KERNEL=E2=80=99

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/kernel.h |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)
 create mode 100644 include/linux/kernel.h

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
new file mode 100644
index 0000000..d4c59f6
--- /dev/null
+++ b/include/linux/kernel.h
@@ -0,0 +1,29 @@
+#ifndef _LINUX_KERNEL_H
+#define _LINUX_KERNEL_H
+
+/*
+ * 'kernel.h' contains some often-used function prototypes etc
+ */
+#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (typeof(x))(a) - =
1)
+#define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
+
+
+#define SI_LOAD_SHIFT	16
+struct sysinfo {
+	long uptime;			/* Seconds since boot */
+	unsigned long loads[3];		/* 1, 5, and 15 minute load averages */
+	unsigned long totalram;		/* Total usable main memory size */
+	unsigned long freeram;		/* Available memory size */
+	unsigned long sharedram;	/* Amount of shared memory */
+	unsigned long bufferram;	/* Memory used by buffers */
+	unsigned long totalswap;	/* Total swap space size */
+	unsigned long freeswap;		/* swap space still available */
+	unsigned short procs;		/* Number of current processes */
+	unsigned short pad;		/* explicit padding for m68k */
+	unsigned long totalhigh;	/* Total high memory size */
+	unsigned long freehigh;		/* Available high memory size */
+	unsigned int mem_unit;		/* Memory unit size in bytes */
+	char _f[20-2*sizeof(long)-sizeof(int)];	/* Padding: libc5 uses this..=
 */
+};
+
+#endif
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
