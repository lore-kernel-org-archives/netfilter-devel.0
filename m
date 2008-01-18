From: Patrick McHardy <kaber@trash.net>
Subject: [LIBNL 03/09]: Generic netfilter stuff
Date: Fri, 18 Jan 2008 17:55:51 +0100 (MET)
Message-ID: <20080118165518.13385.89054.sendpatchset@localhost.localdomain>
References: <20080118165514.13385.44695.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	philipc@snapgear.com
To: tgraf@suug.ch
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42966 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762013AbYARQzw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:55:52 -0500
In-Reply-To: <20080118165514.13385.44695.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit d0d52158ccf2b1d60f864e888f9bdb08c0bdae8b
Author: Patrick McHardy <kaber@trash.net>
Date:   Fri Jan 18 16:17:18 2008 +0100

    [LIBNL]: Generic netfilter stuff
    
    Add some generic helper functions for netfilter.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
new file mode 100644
index 0000000..0750ca6
--- /dev/null
+++ b/include/linux/netfilter.h
@@ -0,0 +1,39 @@
+#ifndef __LINUX_NETFILTER_H
+#define __LINUX_NETFILTER_H
+
+
+/* Responses from hook functions. */
+#define NF_DROP 0
+#define NF_ACCEPT 1
+#define NF_STOLEN 2
+#define NF_QUEUE 3
+#define NF_REPEAT 4
+#define NF_STOP 5
+#define NF_MAX_VERDICT NF_STOP
+
+/* we overload the higher bits for encoding auxiliary data such as the queue
+ * number. Not nice, but better than additional function arguments. */
+#define NF_VERDICT_MASK 0x0000ffff
+#define NF_VERDICT_BITS 16
+
+#define NF_VERDICT_QMASK 0xffff0000
+#define NF_VERDICT_QBITS 16
+
+#define NF_QUEUE_NR(x) (((x << NF_VERDICT_QBITS) & NF_VERDICT_QMASK) | NF_QUEUE)
+
+/* only for userspace compatibility */
+/* Generic cache responses from hook functions.
+   <= 0x2000 is used for protocol-flags. */
+#define NFC_UNKNOWN 0x4000
+#define NFC_ALTERED 0x8000
+
+enum nf_inet_hooks {
+	NF_INET_PRE_ROUTING,
+	NF_INET_LOCAL_IN,
+	NF_INET_FORWARD,
+	NF_INET_LOCAL_OUT,
+	NF_INET_POST_ROUTING,
+	NF_INET_NUMHOOKS,
+};
+
+#endif /*__LINUX_NETFILTER_H*/
diff --git a/include/netlink/netfilter/netfilter.h b/include/netlink/netfilter/netfilter.h
new file mode 100644
index 0000000..dd3589c
--- /dev/null
+++ b/include/netlink/netfilter/netfilter.h
@@ -0,0 +1,31 @@
+/*
+ * netlink/netfilter/netfilter.h	Netfilter generic functions
+ *
+ *	This library is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU Lesser General Public
+ *	License as published by the Free Software Foundation version 2.1
+ *	of the License.
+ *
+ * Copyright (c) 2008 Patrick McHardy <kaber@trash.net>
+ */
+
+#ifndef NETLINK_NETFILTER_H_
+#define NETLINK_NETFILTER_H_
+
+#include <netlink/netlink.h>
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+extern char *			nfnl_verdict2str(unsigned int, char *, size_t);
+extern unsigned int		nfnl_str2verdict(const char *);
+
+extern char *			nfnl_inet_hook2str(unsigned int, char *, size_t);
+extern unsigned int		nfnl_str2inet_hook(const char *);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/netfilter/netfilter.c b/lib/netfilter/netfilter.c
new file mode 100644
index 0000000..f88b355
--- /dev/null
+++ b/lib/netfilter/netfilter.c
@@ -0,0 +1,53 @@
+/*
+ * lib/netfilter/netfilter.c    Netfilter Generic Functions
+ *
+ *	This library is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU Lesser General Public
+ *	License as published by the Free Software Foundation version 2.1
+ *	of the License.
+ *
+ * Copyright (c) 2008 Patrick McHardy <kaber@trash.net>
+ */
+
+#include <netlink-local.h>
+#include <netlink/netfilter/netfilter.h>
+#include <linux/netfilter.h>
+
+static struct trans_tbl nfnl_verdicts[] = {
+	__ADD(NF_DROP,		NF_DROP)
+	__ADD(NF_ACCEPT,	NF_ACCEPT)
+	__ADD(NF_STOLEN,	NF_STOLEN)
+	__ADD(NF_QUEUE,		NF_QUEUE)
+	__ADD(NF_REPEAT,	NF_REPEAT)
+	__ADD(NF_STOP,		NF_STOP)
+};
+
+char *nfnl_verdict2str(unsigned int verdict, char *buf, size_t len)
+{
+	return __type2str(verdict, buf, len, nfnl_verdicts,
+			  ARRAY_SIZE(nfnl_verdicts));
+}
+
+unsigned int nfnl_str2verdict(const char *name)
+{
+	return __str2type(name, nfnl_verdicts, ARRAY_SIZE(nfnl_verdicts));
+}
+
+static struct trans_tbl nfnl_inet_hooks[] = {
+	__ADD(NF_INET_PRE_ROUTING,	NF_INET_PREROUTING)
+	__ADD(NF_INET_LOCAL_IN,		NF_INET_LOCAL_IN)
+	__ADD(NF_INET_FORWARD,		NF_INET_FORWARD)
+	__ADD(NF_INET_LOCAL_OUT,	NF_INET_LOCAL_OUT)
+	__ADD(NF_INET_POST_ROUTING,	NF_INET_POST_ROUTING)
+};
+
+char *nfnl_inet_hook2str(unsigned int hook, char *buf, size_t len)
+{
+	return __type2str(hook, buf, len, nfnl_inet_hooks,
+			  ARRAY_SIZE(nfnl_inet_hooks));
+}
+
+unsigned int nfnl_str2inet_hook(const char *name)
+{
+	return __str2type(name, nfnl_inet_hooks, ARRAY_SIZE(nfnl_inet_hooks));
+}
