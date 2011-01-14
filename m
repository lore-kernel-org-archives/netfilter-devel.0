From: Thomas Graf <tgraf@infradead.org>
Subject: [PATCH] netfilter: create audit records for x_tables replaces
Date: Fri, 14 Jan 2011 17:45:25 -0500
Message-ID: <20110114224525.GC22508@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, linux-audit@redhat.com,
	Eric Paris <eparis@parisplace.org>,
	Al Viro <viro@ZenIV.linux.org.uk>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from canuck.infradead.org ([134.117.69.58]:57195 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab1ANWp0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Jan 2011 17:45:26 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The setsockopt() syscall to replace tables is already recorded
in the audit logs. This patch stores additional information
such as table name and netfilter protocol.

Cc: Patrick McHardy <kaber@trash.net>
Cc: Eric Paris <eparis@parisplace.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Thomas Graf <tgraf@redhat.com>

Index: net-2.6/include/linux/audit.h
===================================================================
--- net-2.6.orig/include/linux/audit.h
+++ net-2.6/include/linux/audit.h
@@ -104,6 +104,7 @@
 #define AUDIT_CAPSET		1322	/* Record showing argument to sys_capset */
 #define AUDIT_MMAP		1323	/* Record showing descriptor and flags in mmap */
 #define AUDIT_NETFILTER_PKT	1324	/* Packets traversing netfilter chains */
+#define AUDIT_NETFILTER_CFG	1325	/* Netfilter chain modifications */
 
 #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
 #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
Index: net-2.6/net/netfilter/x_tables.c
===================================================================
--- net-2.6.orig/net/netfilter/x_tables.c
+++ net-2.6/net/netfilter/x_tables.c
@@ -23,6 +23,7 @@
 #include <linux/mutex.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <linux/audit.h>
 #include <net/net_namespace.h>
 
 #include <linux/netfilter/x_tables.h>
@@ -820,6 +821,21 @@ xt_replace_table(struct xt_table *table,
 	 */
 	local_bh_enable();
 
+#ifdef CONFIG_AUDIT
+	if (audit_enabled) {
+		struct audit_buffer *ab;
+
+		ab = audit_log_start(current->audit_context, GFP_KERNEL,
+				     AUDIT_NETFILTER_CFG);
+		if (ab) {
+			audit_log_format(ab, "table=%s family=%u entries=%u",
+					 table->name, table->af,
+					 private->number);
+			audit_log_end(ab);
+		}
+	}
+#endif
+
 	return private;
 }
 EXPORT_SYMBOL_GPL(xt_replace_table);
