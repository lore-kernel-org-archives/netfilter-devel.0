From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: [iptables PATCH 2/2] Add iptables support for the socket match
Date: Wed, 15 Oct 2008 10:10:28 +0200
Message-ID: <200810151010.29094@nessa>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7BIT
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from balu.sch.bme.hu ([152.66.208.40]:40192 "EHLO balu.sch.bme.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbYJOIKu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Oct 2008 04:10:50 -0400
Received: from nessa.odu ([89.132.101.55])
 by balu.sch.bme.hu (Sun Java System Messaging Server 6.2-7.05 (built Sep  5
 2006)) with ESMTPSA id <0K8R00A2MTCBY290@balu.sch.bme.hu> for
 netfilter-devel@vger.kernel.org; Wed, 15 Oct 2008 10:10:07 +0200 (CEST)
Content-disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add user-space code for the socket match.

Signed-off-by: KOVACS Krisztian <hidden@sch.bme.hu>
---

 extensions/libxt_socket.c   |   39 +++++++++++++++++++++++++++++++++++++++
 extensions/libxt_socket.man |    2 ++
 2 files changed, 41 insertions(+), 0 deletions(-)
 create mode 100644 extensions/libxt_socket.c
 create mode 100644 extensions/libxt_socket.man


diff --git a/extensions/libxt_socket.c b/extensions/libxt_socket.c
new file mode 100644
index 0000000..26ac9e3
--- /dev/null
+++ b/extensions/libxt_socket.c
@@ -0,0 +1,39 @@
+/*
+ * Shared library add-on to iptables to add early socket matching support.
+ *
+ * Copyright (C) 2007 BalaBit IT Ltd.
+ */
+#include <stdio.h>
+#include <getopt.h>
+#include <xtables.h>
+
+static void socket_mt_help(void)
+{
+	printf("socket v%s has no options\n\n", XTABLES_VERSION);
+}
+
+static int socket_mt_parse(int c, char **argv, int invert, unsigned int *flags,
+			const void *entry, struct xt_entry_match **match)
+{
+	return 0;
+}
+
+static void socket_mt_check(unsigned int flags)
+{
+}
+
+static struct xtables_match socket_mt_reg = {
+	.name	       = "socket",
+	.version       = XTABLES_VERSION,
+	.family	       = AF_INET,
+	.size	       = XT_ALIGN(0),
+	.userspacesize = XT_ALIGN(0),
+	.parse	       = socket_mt_parse,
+	.final_check   = socket_mt_check,
+	.help	       = socket_mt_help,
+};
+
+void _init(void)
+{
+	xtables_register_match(&socket_mt_reg);
+}
diff --git a/extensions/libxt_socket.man b/extensions/libxt_socket.man
new file mode 100644
index 0000000..50c8854
--- /dev/null
+++ b/extensions/libxt_socket.man
@@ -0,0 +1,2 @@
+This matches if an open socket can be found by doing a socket lookup on the
+packet.
